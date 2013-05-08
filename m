Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367Ab3EHVpm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 17:45:42 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:44741 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703Ab3EHVpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 17:45:41 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Simon Glass <sjg@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] input: cros_ec_keyb_clear_keyboard() depends on CONFIG_PM_SLEEP
Date: Wed,  8 May 2013 23:45:29 +0200
Message-Id: <1368049529-8168-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_PM_SLEEP is not set:

drivers/input/keyboard/cros_ec_keyb.c:211: warning: ‘cros_ec_keyb_clear_keyboard’ defined but not used

Move the definition of cros_ec_keyb_clear_keyboard() inside the section
protected by #ifdef CONFIG_PM_SLEEP to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/input/keyboard/cros_ec_keyb.c |   54 ++++++++++++++++----------------
 1 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/input/keyboard/cros_ec_keyb.c b/drivers/input/keyboard/cros_ec_keyb.c
index 49557f2..7e8b0a5 100644
--- a/drivers/input/keyboard/cros_ec_keyb.c
+++ b/drivers/input/keyboard/cros_ec_keyb.c
@@ -206,33 +206,6 @@ static int cros_ec_keyb_work(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
-/* Clear any keys in the buffer */
-static void cros_ec_keyb_clear_keyboard(struct cros_ec_keyb *ckdev)
-{
-	uint8_t old_state[ckdev->cols];
-	uint8_t new_state[ckdev->cols];
-	unsigned long duration;
-	int i, ret;
-
-	/*
-	 * Keep reading until we see that the scan state does not change.
-	 * That indicates that we are done.
-	 *
-	 * Assume that the EC keyscan buffer is at most 32 deep.
-	 */
-	duration = jiffies;
-	ret = cros_ec_keyb_get_state(ckdev, new_state);
-	for (i = 1; !ret && i < 32; i++) {
-		memcpy(old_state, new_state, sizeof(old_state));
-		ret = cros_ec_keyb_get_state(ckdev, new_state);
-		if (0 == memcmp(old_state, new_state, sizeof(old_state)))
-			break;
-	}
-	duration = jiffies - duration;
-	dev_info(ckdev->dev, "Discarded %d keyscan(s) in %dus\n", i,
-		jiffies_to_usecs(duration));
-}
-
 static int cros_ec_keyb_probe(struct platform_device *pdev)
 {
 	struct cros_ec_device *ec = dev_get_drvdata(pdev->dev.parent);
@@ -299,6 +272,33 @@ static int cros_ec_keyb_probe(struct platform_device *pdev)
 }
 
 #ifdef CONFIG_PM_SLEEP
+/* Clear any keys in the buffer */
+static void cros_ec_keyb_clear_keyboard(struct cros_ec_keyb *ckdev)
+{
+	uint8_t old_state[ckdev->cols];
+	uint8_t new_state[ckdev->cols];
+	unsigned long duration;
+	int i, ret;
+
+	/*
+	 * Keep reading until we see that the scan state does not change.
+	 * That indicates that we are done.
+	 *
+	 * Assume that the EC keyscan buffer is at most 32 deep.
+	 */
+	duration = jiffies;
+	ret = cros_ec_keyb_get_state(ckdev, new_state);
+	for (i = 1; !ret && i < 32; i++) {
+		memcpy(old_state, new_state, sizeof(old_state));
+		ret = cros_ec_keyb_get_state(ckdev, new_state);
+		if (0 == memcmp(old_state, new_state, sizeof(old_state)))
+			break;
+	}
+	duration = jiffies - duration;
+	dev_info(ckdev->dev, "Discarded %d keyscan(s) in %dus\n", i,
+		jiffies_to_usecs(duration));
+}
+
 static int cros_ec_keyb_resume(struct device *dev)
 {
 	struct cros_ec_keyb *ckdev = dev_get_drvdata(dev);
-- 
1.7.0.4

