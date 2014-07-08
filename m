Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791AbaGHTTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:19:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54322 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755746AbaGHTIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:42 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Roland Dreier" <roland@purestorage.com>,
        "Yann Droneaud" <ydroneaud@opteya.com>,
        "Bart Van Assche" <bvanassche@acm.org>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.73605378@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 049/125] IB/umad: Fix error handling
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit 8ec0a0e6b58218bdc1db91dd70ebfcd6ad8dd6cd upstream.

Avoid leaking a kref count in ib_umad_open() if port->ib_dev == NULL
or if nonseekable_open() fails.

Avoid leaking a kref count, that sm_sem is kept down and also that the
IB_PORT_SM capability mask is not cleared in ib_umad_sm_open() if
nonseekable_open() fails.

Since container_of() never returns NULL, remove the code that tests
whether container_of() returns NULL.

Moving the kref_get() call from the start of ib_umad_*open() to the
end is safe since it is the responsibility of the caller of these
functions to ensure that the cdev pointer remains valid until at least
when these functions return.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>

[ydroneaud@opteya.com: rework a bit to reduce the amount of code changed]

Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>

[ nonseekable_open() can't actually fail, but....  - Roland ]

Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/infiniband/core/user_mad.c | 49 +++++++++++++++++++++-----------------
 1 file changed, 27 insertions(+), 22 deletions(-)

--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -780,27 +780,19 @@ static int ib_umad_open(struct inode *in
 {
 	struct ib_umad_port *port;
 	struct ib_umad_file *file;
-	int ret;
+	int ret = -ENXIO;
 
 	port = container_of(inode->i_cdev, struct ib_umad_port, cdev);
-	if (port)
-		kref_get(&port->umad_dev->ref);
-	else
-		return -ENXIO;
 
 	mutex_lock(&port->file_mutex);
 
-	if (!port->ib_dev) {
-		ret = -ENXIO;
+	if (!port->ib_dev)
 		goto out;
-	}
 
+	ret = -ENOMEM;
 	file = kzalloc(sizeof *file, GFP_KERNEL);
-	if (!file) {
-		kref_put(&port->umad_dev->ref, ib_umad_release_dev);
-		ret = -ENOMEM;
+	if (!file)
 		goto out;
-	}
 
 	mutex_init(&file->mutex);
 	spin_lock_init(&file->send_lock);
@@ -814,6 +806,13 @@ static int ib_umad_open(struct inode *in
 	list_add_tail(&file->port_list, &port->file_list);
 
 	ret = nonseekable_open(inode, filp);
+	if (ret) {
+		list_del(&file->port_list);
+		kfree(file);
+		goto out;
+	}
+
+	kref_get(&port->umad_dev->ref);
 
 out:
 	mutex_unlock(&port->file_mutex);
@@ -880,10 +879,6 @@ static int ib_umad_sm_open(struct inode
 	int ret;
 
 	port = container_of(inode->i_cdev, struct ib_umad_port, sm_cdev);
-	if (port)
-		kref_get(&port->umad_dev->ref);
-	else
-		return -ENXIO;
 
 	if (filp->f_flags & O_NONBLOCK) {
 		if (down_trylock(&port->sm_sem)) {
@@ -898,17 +893,27 @@ static int ib_umad_sm_open(struct inode
 	}
 
 	ret = ib_modify_port(port->ib_dev, port->port_num, 0, &props);
-	if (ret) {
-		up(&port->sm_sem);
-		goto fail;
-	}
+	if (ret)
+		goto err_up_sem;
 
 	filp->private_data = port;
 
-	return nonseekable_open(inode, filp);
+	ret = nonseekable_open(inode, filp);
+	if (ret)
+		goto err_clr_sm_cap;
+
+	kref_get(&port->umad_dev->ref);
+
+	return 0;
+
+err_clr_sm_cap:
+	swap(props.set_port_cap_mask, props.clr_port_cap_mask);
+	ib_modify_port(port->ib_dev, port->port_num, 0, &props);
+
+err_up_sem:
+	up(&port->sm_sem);
 
 fail:
-	kref_put(&port->umad_dev->ref, ib_umad_release_dev);
 	return ret;
 }
 

