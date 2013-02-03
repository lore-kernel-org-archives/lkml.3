Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab3BCB2C (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:28:02 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:44057 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab3BCBWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:22:39 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Tejun Heo <tj@kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 43/62] rpmsg: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:44 -0800
Message-Id: <1359854463-2538-44-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

 drivers/rpmsg/virtio_rpmsg_bus.c | 30 ++++++++++++------------------
 1 file changed, 12 insertions(+), 18 deletions(-)

diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index aa334b6..7ce2802 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -213,13 +213,10 @@ static struct rpmsg_endpoint *__rpmsg_create_ept(struct virtproc_info *vrp,
 		struct rpmsg_channel *rpdev, rpmsg_rx_cb_t cb,
 		void *priv, u32 addr)
 {
-	int err, tmpaddr, request;
+	int id_min, id_max, id;
 	struct rpmsg_endpoint *ept;
 	struct device *dev = rpdev ? &rpdev->dev : &vrp->vdev->dev;
 
-	if (!idr_pre_get(&vrp->endpoints, GFP_KERNEL))
-		return NULL;
-
 	ept = kzalloc(sizeof(*ept), GFP_KERNEL);
 	if (!ept) {
 		dev_err(dev, "failed to kzalloc a new ept\n");
@@ -234,31 +231,28 @@ static struct rpmsg_endpoint *__rpmsg_create_ept(struct virtproc_info *vrp,
 	ept->priv = priv;
 
 	/* do we need to allocate a local address ? */
-	request = addr == RPMSG_ADDR_ANY ? RPMSG_RESERVED_ADDRESSES : addr;
+	if (addr == RPMSG_ADDR_ANY) {
+		id_min = RPMSG_RESERVED_ADDRESSES;
+		id_max = 0;
+	} else {
+		id_min = addr;
+		id_max = addr + 1;
+	}
 
 	mutex_lock(&vrp->endpoints_lock);
 
 	/* bind the endpoint to an rpmsg address (and allocate one if needed) */
-	err = idr_get_new_above(&vrp->endpoints, ept, request, &tmpaddr);
-	if (err) {
-		dev_err(dev, "idr_get_new_above failed: %d\n", err);
+	id = idr_alloc(&vrp->endpoints, ept, id_min, id_max, GFP_KERNEL);
+	if (id < 0) {
+		dev_err(dev, "idr_alloc failed: %d\n", id);
 		goto free_ept;
 	}
-
-	/* make sure the user's address request is fulfilled, if relevant */
-	if (addr != RPMSG_ADDR_ANY && tmpaddr != addr) {
-		dev_err(dev, "address 0x%x already in use\n", addr);
-		goto rem_idr;
-	}
-
-	ept->addr = tmpaddr;
+	ept->addr = id;
 
 	mutex_unlock(&vrp->endpoints_lock);
 
 	return ept;
 
-rem_idr:
-	idr_remove(&vrp->endpoints, request);
 free_ept:
 	mutex_unlock(&vrp->endpoints_lock);
 	kref_put(&ept->refcount, __ept_release);
-- 
1.8.1

