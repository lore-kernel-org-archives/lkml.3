Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbaIJP4B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 11:56:01 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:44184 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744AbaIJPy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 11:54:56 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jingoo Han <jg1.han@samsung.com>, Bryan Wu <cooloney@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Adam Jackson <ajax@redhat.com>, linux-kernel@vger.kernel.org,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH RFC 2/4] backlight: use spin-lock to protect device list
Date: Wed, 10 Sep 2014 17:54:21 +0200
Message-Id: <1410364463-12692-3-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1410364463-12692-1-git-send-email-dh.herrmann@gmail.com>
References: <1410364463-12692-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is really no reason to use a mutex to protect a simple list. Convert
the list-lock to a simple spinlock instead.

The spin-locks prepare for a backlight_find() helper, which should
preferably be usable from atomic context. A mutex would prevent that, so
use an irq-save spinlock instead.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 drivers/video/backlight/backlight.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index 726c6c6..33b64be 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -16,13 +16,14 @@
 #include <linux/err.h>
 #include <linux/fb.h>
 #include <linux/slab.h>
+#include <linux/spinlock.h>
 
 #ifdef CONFIG_PMAC_BACKLIGHT
 #include <asm/backlight.h>
 #endif
 
 static LIST_HEAD(backlight_dev_list);
-static DEFINE_MUTEX(backlight_dev_list_mutex);
+static DEFINE_SPINLOCK(backlight_dev_list_lock);
 static BLOCKING_NOTIFIER_HEAD(backlight_notifier);
 
 static const char *const backlight_types[] = {
@@ -369,9 +370,9 @@ struct backlight_device *backlight_device_register(const char *name,
 	mutex_unlock(&pmac_backlight_mutex);
 #endif
 
-	mutex_lock(&backlight_dev_list_mutex);
+	spin_lock_irq(&backlight_dev_list_lock);
 	list_add(&new_bd->entry, &backlight_dev_list);
-	mutex_unlock(&backlight_dev_list_mutex);
+	spin_unlock_irq(&backlight_dev_list_lock);
 
 	blocking_notifier_call_chain(&backlight_notifier,
 				     BACKLIGHT_REGISTERED, new_bd);
@@ -384,15 +385,16 @@ bool backlight_device_registered(enum backlight_type type)
 {
 	bool found = false;
 	struct backlight_device *bd;
+	unsigned long flags;
 
-	mutex_lock(&backlight_dev_list_mutex);
+	spin_lock_irqsave(&backlight_dev_list_lock, flags);
 	list_for_each_entry(bd, &backlight_dev_list, entry) {
 		if (bd->props.type == type) {
 			found = true;
 			break;
 		}
 	}
-	mutex_unlock(&backlight_dev_list_mutex);
+	spin_unlock_irqrestore(&backlight_dev_list_lock, flags);
 
 	return found;
 }
@@ -409,9 +411,9 @@ void backlight_device_unregister(struct backlight_device *bd)
 	if (!bd)
 		return;
 
-	mutex_lock(&backlight_dev_list_mutex);
+	spin_lock_irq(&backlight_dev_list_lock);
 	list_del(&bd->entry);
-	mutex_unlock(&backlight_dev_list_mutex);
+	spin_unlock_irq(&backlight_dev_list_lock);
 
 #ifdef CONFIG_PMAC_BACKLIGHT
 	mutex_lock(&pmac_backlight_mutex);
-- 
2.1.0

