Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030919AbaGCJ4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:56:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52034 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964955AbaGCJXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:23:15 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bart Van Assche <bvanassche@acm.org>,
        Roland Dreier <roland@purestorage.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 101/198] IB/umad: Fix use-after-free on close
Date: Thu,  3 Jul 2014 10:19:04 +0100
Message-Id: <1404379241-8590-102-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit 60e1751cb52cc6d1ae04b6bd3c2b96e770b5823f upstream.

Avoid that closing /dev/infiniband/umad<n> or /dev/infiniband/issm<n>
triggers a use-after-free.  __fput() invokes f_op->release() before it
invokes cdev_put().  Make sure that the ib_umad_device structure is
freed by the cdev_put() call instead of f_op->release().  This avoids
that changing the port mode from IB into Ethernet and back to IB
followed by restarting opensmd triggers the following kernel oops:

    general protection fault: 0000 [#1] PREEMPT SMP
    RIP: 0010:[<ffffffff810cc65c>]  [<ffffffff810cc65c>] module_put+0x2c/0x170
    Call Trace:
     [<ffffffff81190f20>] cdev_put+0x20/0x30
     [<ffffffff8118e2ce>] __fput+0x1ae/0x1f0
     [<ffffffff8118e35e>] ____fput+0xe/0x10
     [<ffffffff810723bc>] task_work_run+0xac/0xe0
     [<ffffffff81002a9f>] do_notify_resume+0x9f/0xc0
     [<ffffffff814b8398>] int_signal+0x12/0x17

Reference: https://bugzilla.kernel.org/show_bug.cgi?id=75051
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Yann Droneaud <ydroneaud@opteya.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/infiniband/core/user_mad.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 9bdf576cd4ab..1acb99100556 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -98,7 +98,7 @@ struct ib_umad_port {
 
 struct ib_umad_device {
 	int                  start_port, end_port;
-	struct kref          ref;
+	struct kobject       kobj;
 	struct ib_umad_port  port[0];
 };
 
@@ -134,14 +134,18 @@ static DECLARE_BITMAP(dev_map, IB_UMAD_MAX_PORTS);
 static void ib_umad_add_one(struct ib_device *device);
 static void ib_umad_remove_one(struct ib_device *device);
 
-static void ib_umad_release_dev(struct kref *ref)
+static void ib_umad_release_dev(struct kobject *kobj)
 {
 	struct ib_umad_device *dev =
-		container_of(ref, struct ib_umad_device, ref);
+		container_of(kobj, struct ib_umad_device, kobj);
 
 	kfree(dev);
 }
 
+static struct kobj_type ib_umad_dev_ktype = {
+	.release = ib_umad_release_dev,
+};
+
 static int hdr_size(struct ib_umad_file *file)
 {
 	return file->use_pkey_index ? sizeof (struct ib_user_mad_hdr) :
@@ -812,7 +816,7 @@ static int ib_umad_open(struct inode *inode, struct file *filp)
 		goto out;
 	}
 
-	kref_get(&port->umad_dev->ref);
+	kobject_get(&port->umad_dev->kobj);
 
 out:
 	mutex_unlock(&port->file_mutex);
@@ -851,7 +855,7 @@ static int ib_umad_close(struct inode *inode, struct file *filp)
 	mutex_unlock(&file->port->file_mutex);
 
 	kfree(file);
-	kref_put(&dev->ref, ib_umad_release_dev);
+	kobject_put(&dev->kobj);
 
 	return 0;
 }
@@ -902,7 +906,7 @@ static int ib_umad_sm_open(struct inode *inode, struct file *filp)
 	if (ret)
 		goto err_clr_sm_cap;
 
-	kref_get(&port->umad_dev->ref);
+	kobject_get(&port->umad_dev->kobj);
 
 	return 0;
 
@@ -932,7 +936,7 @@ static int ib_umad_sm_close(struct inode *inode, struct file *filp)
 
 	up(&port->sm_sem);
 
-	kref_put(&port->umad_dev->ref, ib_umad_release_dev);
+	kobject_put(&port->umad_dev->kobj);
 
 	return ret;
 }
@@ -1000,6 +1004,7 @@ static int find_overflow_devnum(void)
 }
 
 static int ib_umad_init_port(struct ib_device *device, int port_num,
+			     struct ib_umad_device *umad_dev,
 			     struct ib_umad_port *port)
 {
 	int devnum;
@@ -1032,6 +1037,7 @@ static int ib_umad_init_port(struct ib_device *device, int port_num,
 
 	cdev_init(&port->cdev, &umad_fops);
 	port->cdev.owner = THIS_MODULE;
+	port->cdev.kobj.parent = &umad_dev->kobj;
 	kobject_set_name(&port->cdev.kobj, "umad%d", port->dev_num);
 	if (cdev_add(&port->cdev, base, 1))
 		goto err_cdev;
@@ -1050,6 +1056,7 @@ static int ib_umad_init_port(struct ib_device *device, int port_num,
 	base += IB_UMAD_MAX_PORTS;
 	cdev_init(&port->sm_cdev, &umad_sm_fops);
 	port->sm_cdev.owner = THIS_MODULE;
+	port->sm_cdev.kobj.parent = &umad_dev->kobj;
 	kobject_set_name(&port->sm_cdev.kobj, "issm%d", port->dev_num);
 	if (cdev_add(&port->sm_cdev, base, 1))
 		goto err_sm_cdev;
@@ -1143,7 +1150,7 @@ static void ib_umad_add_one(struct ib_device *device)
 	if (!umad_dev)
 		return;
 
-	kref_init(&umad_dev->ref);
+	kobject_init(&umad_dev->kobj, &ib_umad_dev_ktype);
 
 	umad_dev->start_port = s;
 	umad_dev->end_port   = e;
@@ -1151,7 +1158,8 @@ static void ib_umad_add_one(struct ib_device *device)
 	for (i = s; i <= e; ++i) {
 		umad_dev->port[i - s].umad_dev = umad_dev;
 
-		if (ib_umad_init_port(device, i, &umad_dev->port[i - s]))
+		if (ib_umad_init_port(device, i, umad_dev,
+				      &umad_dev->port[i - s]))
 			goto err;
 	}
 
@@ -1163,7 +1171,7 @@ err:
 	while (--i >= s)
 		ib_umad_kill_port(&umad_dev->port[i - s]);
 
-	kref_put(&umad_dev->ref, ib_umad_release_dev);
+	kobject_put(&umad_dev->kobj);
 }
 
 static void ib_umad_remove_one(struct ib_device *device)
@@ -1177,7 +1185,7 @@ static void ib_umad_remove_one(struct ib_device *device)
 	for (i = 0; i <= umad_dev->end_port - umad_dev->start_port; ++i)
 		ib_umad_kill_port(&umad_dev->port[i]);
 
-	kref_put(&umad_dev->ref, ib_umad_release_dev);
+	kobject_put(&umad_dev->kobj);
 }
 
 static char *umad_devnode(struct device *dev, umode_t *mode)
-- 
1.9.1

