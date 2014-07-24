Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664AbaGXE3L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 00:29:11 -0400
Received: from AUSXIPPC110.us.dell.com ([143.166.85.200]:48248 "EHLO
	ausxippc110.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbaGXE3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 00:29:10 -0400
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jul 2014 00:29:09 EDT
X-LoopCount0: from 10.208.46.70
X-IronPort-AV: E=Sophos;i="5.01,721,1400043600"; 
   d="scan'208";a="41537950"
From: Mario Limonciello <mario_limonciello@dell.com>
To: matthew.garrett@nebula.com
Cc: LKML <linux-kernel@vger.kernel.org>, platform-driver-x86@vger.kernel.org,
        Mario Limonciello <mario_limonciello@dell.com>
Subject: [PATCH 1/1] alienware-wmi: make hdmi_mux enabled on case-by-case basis
Date: Wed, 23 Jul 2014 23:19:23 -0500
Message-Id: <1406175563-30393-1-git-send-email-mario_limonciello@dell.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not all HW supporting WMAX method will support the HDMI mux feature.
Explicitly quirk the HW that does support it.

Signed-off-by: Mario Limonciello <mario_limonciello@dell.com>
---
 drivers/platform/x86/alienware-wmi.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/alienware-wmi.c b/drivers/platform/x86/alienware-wmi.c
index 297b664..7b1fe5f 100644
--- a/drivers/platform/x86/alienware-wmi.c
+++ b/drivers/platform/x86/alienware-wmi.c
@@ -59,16 +59,24 @@ enum WMAX_CONTROL_STATES {
 
 struct quirk_entry {
 	u8 num_zones;
+	u8 hdmi_mux;
 };
 
 static struct quirk_entry *quirks;
 
 static struct quirk_entry quirk_unknown = {
 	.num_zones = 2,
+	.hdmi_mux = 0,
 };
 
 static struct quirk_entry quirk_x51_family = {
 	.num_zones = 3,
+	.hdmi_mux = 0,
+};
+
+static struct quirk_entry quirk_asm100 = {
+	.num_zones = 2,
+	.hdmi_mux = 1,
 };
 
 static int dmi_matched(const struct dmi_system_id *dmi)
@@ -96,6 +104,15 @@ static struct dmi_system_id alienware_quirks[] = {
 		     },
 	 .driver_data = &quirk_x51_family,
 	 },
+	{
+	 .callback = dmi_matched,
+	 .ident = "Alienware ASM100",
+	 .matches = {
+		     DMI_MATCH(DMI_SYS_VENDOR, "Alienware"),
+		     DMI_MATCH(DMI_PRODUCT_NAME, "ASM100"),
+		     },
+	 .driver_data = &quirk_asm100,
+	 },
 	{}
 };
 
@@ -537,7 +554,8 @@ static struct attribute_group hdmi_attribute_group = {
 
 static void remove_hdmi(struct platform_device *dev)
 {
-	sysfs_remove_group(&dev->dev.kobj, &hdmi_attribute_group);
+	if (quirks->hdmi_mux > 0)
+		sysfs_remove_group(&dev->dev.kobj, &hdmi_attribute_group);
 }
 
 static int create_hdmi(struct platform_device *dev)
@@ -583,7 +601,7 @@ static int __init alienware_wmi_init(void)
 	if (ret)
 		goto fail_platform_device2;
 
-	if (interface == WMAX) {
+	if (quirks->hdmi_mux > 0) {
 		ret = create_hdmi(platform_device);
 		if (ret)
 			goto fail_prep_hdmi;
-- 
1.9.1

