Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbaHYKA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 06:00:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754975AbaHYKAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 06:00:23 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Matthew Garrett <matthew.garrett@nebula.com>,
        Corentin Chary <corentin.chary@gmail.com>
Cc: GOESSEL Guillaume <g_goessel@outlook.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>
Subject: [3.17 REGRESSION FIX] Revert "ideapad-laptop: Disable touchpad interface on Yoga models"
Date: Mon, 25 Aug 2014 12:00:13 +0200
Message-Id: <1408960813-12237-1-git-send-email-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've received a bug report from a user that the touchpad control part
of the ideapad-laptop ACPI interface does work for him on his
"Lenovo Yoga 2 13", and that this patch causes a regression for him.

Since it did not work for me when I had a "Lenovo Yoga 2 11" in my own
hands (loaned from a friend). It seems that this is a bit of hit and miss.

Since the result of having a false positive here is worse, then the minor
annoyance of a false touchpad disabled messages being shown after suspend /
resume on models (or is it firmware versions?) where the interface does not
work, simply revert the patch.

This reverts commit f79a901331a823ae370584b15cd39dd110b95a0a.

Reported-by: GOESSEL Guillaume <g_goessel@outlook.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/platform/x86/ideapad-laptop.c | 27 ---------------------------
 1 file changed, 27 deletions(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index fc468a3..de1e0c3 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -88,7 +88,6 @@ struct ideapad_private {
 	struct dentry *debug;
 	unsigned long cfg;
 	bool has_hw_rfkill_switch;
-	bool has_touchpad_control;
 };
 
 static bool no_bt_rfkill;
@@ -767,9 +766,6 @@ static void ideapad_sync_touchpad_state(struct ideapad_private *priv)
 {
 	unsigned long value;
 
-	if (!priv->has_touchpad_control)
-		return;
-
 	/* Without reading from EC touchpad LED doesn't switch state */
 	if (!read_ec_data(priv->adev->handle, VPCCMD_R_TOUCHPAD, &value)) {
 		/* Some IdeaPads don't really turn off touchpad - they only
@@ -844,28 +840,6 @@ static struct dmi_system_id no_hw_rfkill_list[] = {
 	{}
 };
 
-/*
- * Some models don't offer touchpad ctrl through the ideapad interface, causing
- * ideapad_sync_touchpad_state to send wrong touchpad enable/disable events.
- */
-static struct dmi_system_id no_touchpad_ctrl_list[] = {
-	{
-		.ident = "Lenovo Yoga 1 series",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "Lenovo IdeaPad Yoga"),
-		},
-	},
-	{
-		.ident = "Lenovo Yoga 2 11 / 13 / Pro",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "Lenovo Yoga 2"),
-		},
-	},
-	{}
-};
-
 static int ideapad_acpi_add(struct platform_device *pdev)
 {
 	int ret, i;
@@ -889,7 +863,6 @@ static int ideapad_acpi_add(struct platform_device *pdev)
 	priv->adev = adev;
 	priv->platform_device = pdev;
 	priv->has_hw_rfkill_switch = !dmi_check_system(no_hw_rfkill_list);
-	priv->has_touchpad_control = !dmi_check_system(no_touchpad_ctrl_list);
 
 	ret = ideapad_sysfs_init(priv);
 	if (ret)
-- 
2.1.0

