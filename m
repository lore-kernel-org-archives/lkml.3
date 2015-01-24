Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbbAXOE1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 09:04:27 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:54292 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbbAXOEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 09:04:23 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 22/32] input: use %*pb[l] to print bitmaps including cpumasks and nodemasks
Date: Sat, 24 Jan 2015 09:03:28 -0500
Message-Id: <1422108218-25398-23-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1422108218-25398-1-git-send-email-tj@kernel.org>
References: <1422108218-25398-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

printk and friends can now formap bitmaps using '%*pb[l]'.  cpumask
and nodemask also provide cpumask_pr_args() and nodemask_pr_args()
respectively which can be used to generate the two printf arguments
necessary to format the specified cpu/nodemask.

* Line termination only requires one extra space at the end of the
  buffer.  Use PAGE_SIZE - 1 instead of PAGE_SIZE - 2 when formatting.

This patch is dependent on the following two patches.

 lib/vsprintf: implement bitmap printing through '%*pb[l]'
 cpumask, nodemask: implement cpumask/nodemask_pr_args()

Please wait till the forementioned patches are merged to mainline
before applying to subsystem trees.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/keyboard/atkbd.c     | 4 ++--
 drivers/input/keyboard/gpio_keys.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
index e27a258..387c51f 100644
--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -1399,8 +1399,8 @@ static ssize_t atkbd_set_extra(struct atkbd *atkbd, const char *buf, size_t coun
 
 static ssize_t atkbd_show_force_release(struct atkbd *atkbd, char *buf)
 {
-	size_t len = bitmap_scnlistprintf(buf, PAGE_SIZE - 2,
-			atkbd->force_release_mask, ATKBD_KEYMAP_SIZE);
+	size_t len = scnprintf(buf, PAGE_SIZE - 1, "%*pbl",
+			       ATKBD_KEYMAP_SIZE, atkbd->force_release_mask);
 
 	buf[len++] = '\n';
 	buf[len] = '\0';
diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
index 883d6ae..ddf4045 100644
--- a/drivers/input/keyboard/gpio_keys.c
+++ b/drivers/input/keyboard/gpio_keys.c
@@ -190,7 +190,7 @@ static ssize_t gpio_keys_attr_show_helper(struct gpio_keys_drvdata *ddata,
 		__set_bit(bdata->button->code, bits);
 	}
 
-	ret = bitmap_scnlistprintf(buf, PAGE_SIZE - 2, bits, n_events);
+	ret = scnprintf(buf, PAGE_SIZE - 1, "%*pbl", n_events, bits);
 	buf[ret++] = '\n';
 	buf[ret] = '\0';
 
-- 
2.1.0

