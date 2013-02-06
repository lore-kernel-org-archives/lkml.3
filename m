Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030195Ab3BFTuy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:50:54 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:45564 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758254Ab3BFTuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:50:46 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Rodolfo Giometti <giometti@linux.it>
Subject: [PATCH 50/77] misc/c2port: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:40:22 -0800
Message-Id: <1360179649-22465-51-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Rodolfo Giometti <giometti@linux.it>
---
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

