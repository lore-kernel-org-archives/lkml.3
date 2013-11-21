Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab3KUTPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 14:15:47 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:61761 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab3KUTPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 14:15:46 -0500
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH] driver core: fix device_create() error path
Date: Thu, 21 Nov 2013 20:15:48 +0100
Message-Id: <1385061348-13153-1-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We call put_device() in the error path, which is fine for dev==NULL.
However, in case kobject_set_name_vargs() fails, we have dev!=NULL but
device_initialized() wasn't called, yet.

Fix this by splitting device_register() into explicit calls to
device_add() and an early call to device_initialize().

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 drivers/base/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 34abf4d..4be8911 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1676,6 +1676,7 @@ device_create_groups_vargs(struct class *class, struct device *parent,
 		goto error;
 	}
 
+	device_initialize(dev);
 	dev->devt = devt;
 	dev->class = class;
 	dev->parent = parent;
@@ -1687,7 +1688,7 @@ device_create_groups_vargs(struct class *class, struct device *parent,
 	if (retval)
 		goto error;
 
-	retval = device_register(dev);
+	retval = device_add(dev);
 	if (retval)
 		goto error;
 
-- 
1.8.4.2

