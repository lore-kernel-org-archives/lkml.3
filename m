Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab3BCBW3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:22:29 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:47430 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748Ab3BCBWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:22:22 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk, Tejun Heo <tj@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Rodolfo Giometti <giometti@linux.it>
Subject: [PATCH 34/62] misc/c2port: convert to idr_alloc()
Date: Sat,  2 Feb 2013 17:20:35 -0800
Message-Id: <1359854463-2538-35-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1359854463-2538-1-git-send-email-tj@kernel.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Rodolfo Giometti <giometti@linux.it>
---
This patch depends on an earlier idr changes and I think it would be
best to route these together through -mm.  Please holler if there's
any objection.  Thanks.

 drivers/misc/c2port/core.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/misc/c2port/core.c b/drivers/misc/c2port/core.c
index f428d86..f32550a 100644
--- a/drivers/misc/c2port/core.c
+++ b/drivers/misc/c2port/core.c
@@ -885,7 +885,7 @@ struct c2port_device *c2port_device_register(char *name,
 					struct c2port_ops *ops, void *devdata)
 {
 	struct c2port_device *c2dev;
-	int id, ret;
+	int ret;
 
 	if (unlikely(!ops) || unlikely(!ops->access) || \
 		unlikely(!ops->c2d_dir) || unlikely(!ops->c2ck_set) || \
@@ -897,22 +897,18 @@ struct c2port_device *c2port_device_register(char *name,
 	if (unlikely(!c2dev))
 		return ERR_PTR(-ENOMEM);
 
-	ret = idr_pre_get(&c2port_idr, GFP_KERNEL);
-	if (!ret) {
-		ret = -ENOMEM;
-		goto error_idr_get_new;
-	}
-
+	idr_preload(GFP_KERNEL);
 	spin_lock_irq(&c2port_idr_lock);
-	ret = idr_get_new(&c2port_idr, c2dev, &id);
+	ret = idr_alloc(&c2port_idr, c2dev, 0, 0, GFP_NOWAIT);
 	spin_unlock_irq(&c2port_idr_lock);
+	idr_preload_end();
 
 	if (ret < 0)
-		goto error_idr_get_new;
-	c2dev->id = id;
+		goto error_idr_alloc;
+	c2dev->id = ret;
 
 	c2dev->dev = device_create(c2port_class, NULL, 0, c2dev,
-					"c2port%d", id);
+				   "c2port%d", c2dev->id);
 	if (unlikely(IS_ERR(c2dev->dev))) {
 		ret = PTR_ERR(c2dev->dev);
 		goto error_device_create;
@@ -946,10 +942,10 @@ error_device_create_bin_file:
 
 error_device_create:
 	spin_lock_irq(&c2port_idr_lock);
-	idr_remove(&c2port_idr, id);
+	idr_remove(&c2port_idr, c2dev->id);
 	spin_unlock_irq(&c2port_idr_lock);
 
-error_idr_get_new:
+error_idr_alloc:
 	kfree(c2dev);
 
 	return ERR_PTR(ret);
-- 
1.8.1

