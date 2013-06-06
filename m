Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933659Ab3FFMUT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 08:20:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933377Ab3FFMUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 08:20:16 -0400
Date: Thu, 6 Jun 2013 15:20:39 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: netdev@vger.kernel.org
Cc: Asias He <asias@redhat.com>, David Miller <davem@davemloft.net>,
        Tommi Rantala <tt.rantala@gmail.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 1/2] vhost: check owner before we overwrite ubuf_info
Message-ID: <1370521145-9723-2-git-send-email-mst@redhat.com>
References: <1370521145-9723-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370521145-9723-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If device has an owner, we shouldn't touch ubuf_info
since it might be in use.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/net.c   | 4 ++++
 drivers/vhost/vhost.c | 8 +++++++-
 drivers/vhost/vhost.h | 1 +
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 2b51e23..6b00f64 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1053,6 +1053,10 @@ static long vhost_net_set_owner(struct vhost_net *n)
 	int r;
 
 	mutex_lock(&n->dev.mutex);
+	if (vhost_dev_has_owner(&n->dev)) {
+		r = -EBUSY;
+		goto out;
+	}
 	r = vhost_net_set_ubuf_info(n);
 	if (r)
 		goto out;
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index beee7f5..60aa5ad 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -344,13 +344,19 @@ static int vhost_attach_cgroups(struct vhost_dev *dev)
 }
 
 /* Caller should have device mutex */
+bool vhost_dev_has_owner(struct vhost_dev *dev)
+{
+	return dev->mm;
+}
+
+/* Caller should have device mutex */
 long vhost_dev_set_owner(struct vhost_dev *dev)
 {
 	struct task_struct *worker;
 	int err;
 
 	/* Is there an owner already? */
-	if (dev->mm) {
+	if (vhost_dev_has_owner(dev)) {
 		err = -EBUSY;
 		goto err_mm;
 	}
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index a7ad635..64adcf9 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -133,6 +133,7 @@ struct vhost_dev {
 
 long vhost_dev_init(struct vhost_dev *, struct vhost_virtqueue **vqs, int nvqs);
 long vhost_dev_set_owner(struct vhost_dev *dev);
+bool vhost_dev_has_owner(struct vhost_dev *dev);
 long vhost_dev_check_owner(struct vhost_dev *);
 struct vhost_memory *vhost_dev_reset_owner_prepare(void);
 void vhost_dev_reset_owner(struct vhost_dev *, struct vhost_memory *);
-- 
MST

