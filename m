Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbaFIJJN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:09:13 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58471 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754900AbaFIIvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Deucher <alexdeucher@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 044/146] drm/radeon: add support for newer mc ucode on SI (v2)
Date: Mon,  9 Jun 2014 10:49:39 +0200
Message-Id: <0f9aed4142002f86e1eef78a2506e8c650f2a85a.1402303820.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Deucher <alexdeucher@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 1ebe92802eaf0569784dce843bc28a78842d236c upstream.

May fix stability issues with some newer cards.

v2: print out mc firmware version used and size

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/radeon/radeon_ucode.h |  3 +++
 drivers/gpu/drm/radeon/si.c           | 35 ++++++++++++++++++++++-------------
 2 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_ucode.h b/drivers/gpu/drm/radeon/radeon_ucode.h
index 33858364fe89..7e48c359b04c 100644
--- a/drivers/gpu/drm/radeon/radeon_ucode.h
+++ b/drivers/gpu/drm/radeon/radeon_ucode.h
@@ -57,6 +57,9 @@
 #define BTC_MC_UCODE_SIZE            6024
 #define CAYMAN_MC_UCODE_SIZE         6037
 #define SI_MC_UCODE_SIZE             7769
+#define TAHITI_MC_UCODE_SIZE         7808
+#define PITCAIRN_MC_UCODE_SIZE       7775
+#define VERDE_MC_UCODE_SIZE          7875
 #define OLAND_MC_UCODE_SIZE          7863
 #define CIK_MC_UCODE_SIZE            7866
 
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index 873e0a608948..de0c2bfcc7fc 100644
--- a/drivers/gpu/drm/radeon/si.c
+++ b/drivers/gpu/drm/radeon/si.c
@@ -39,30 +39,35 @@ MODULE_FIRMWARE("radeon/TAHITI_pfp.bin");
 MODULE_FIRMWARE("radeon/TAHITI_me.bin");
 MODULE_FIRMWARE("radeon/TAHITI_ce.bin");
 MODULE_FIRMWARE("radeon/TAHITI_mc.bin");
+MODULE_FIRMWARE("radeon/TAHITI_mc2.bin");
 MODULE_FIRMWARE("radeon/TAHITI_rlc.bin");
 MODULE_FIRMWARE("radeon/TAHITI_smc.bin");
 MODULE_FIRMWARE("radeon/PITCAIRN_pfp.bin");
 MODULE_FIRMWARE("radeon/PITCAIRN_me.bin");
 MODULE_FIRMWARE("radeon/PITCAIRN_ce.bin");
 MODULE_FIRMWARE("radeon/PITCAIRN_mc.bin");
+MODULE_FIRMWARE("radeon/PITCAIRN_mc2.bin");
 MODULE_FIRMWARE("radeon/PITCAIRN_rlc.bin");
 MODULE_FIRMWARE("radeon/PITCAIRN_smc.bin");
 MODULE_FIRMWARE("radeon/VERDE_pfp.bin");
 MODULE_FIRMWARE("radeon/VERDE_me.bin");
 MODULE_FIRMWARE("radeon/VERDE_ce.bin");
 MODULE_FIRMWARE("radeon/VERDE_mc.bin");
+MODULE_FIRMWARE("radeon/VERDE_mc2.bin");
 MODULE_FIRMWARE("radeon/VERDE_rlc.bin");
 MODULE_FIRMWARE("radeon/VERDE_smc.bin");
 MODULE_FIRMWARE("radeon/OLAND_pfp.bin");
 MODULE_FIRMWARE("radeon/OLAND_me.bin");
 MODULE_FIRMWARE("radeon/OLAND_ce.bin");
 MODULE_FIRMWARE("radeon/OLAND_mc.bin");
+MODULE_FIRMWARE("radeon/OLAND_mc2.bin");
 MODULE_FIRMWARE("radeon/OLAND_rlc.bin");
 MODULE_FIRMWARE("radeon/OLAND_smc.bin");
 MODULE_FIRMWARE("radeon/HAINAN_pfp.bin");
 MODULE_FIRMWARE("radeon/HAINAN_me.bin");
 MODULE_FIRMWARE("radeon/HAINAN_ce.bin");
 MODULE_FIRMWARE("radeon/HAINAN_mc.bin");
+MODULE_FIRMWARE("radeon/HAINAN_mc2.bin");
 MODULE_FIRMWARE("radeon/HAINAN_rlc.bin");
 MODULE_FIRMWARE("radeon/HAINAN_smc.bin");
 
@@ -1470,7 +1475,7 @@ static int si_mc_load_microcode(struct radeon_device *rdev)
 	const __be32 *fw_data;
 	u32 running, blackout = 0;
 	u32 *io_mc_regs;
-	int i, ucode_size, regs_size;
+	int i, regs_size, ucode_size = rdev->mc_fw->size / 4;
 
 	if (!rdev->mc_fw)
 		return -EINVAL;
@@ -1478,28 +1483,23 @@ static int si_mc_load_microcode(struct radeon_device *rdev)
 	switch (rdev->family) {
 	case CHIP_TAHITI:
 		io_mc_regs = (u32 *)&tahiti_io_mc_regs;
-		ucode_size = SI_MC_UCODE_SIZE;
 		regs_size = TAHITI_IO_MC_REGS_SIZE;
 		break;
 	case CHIP_PITCAIRN:
 		io_mc_regs = (u32 *)&pitcairn_io_mc_regs;
-		ucode_size = SI_MC_UCODE_SIZE;
 		regs_size = TAHITI_IO_MC_REGS_SIZE;
 		break;
 	case CHIP_VERDE:
 	default:
 		io_mc_regs = (u32 *)&verde_io_mc_regs;
-		ucode_size = SI_MC_UCODE_SIZE;
 		regs_size = TAHITI_IO_MC_REGS_SIZE;
 		break;
 	case CHIP_OLAND:
 		io_mc_regs = (u32 *)&oland_io_mc_regs;
-		ucode_size = OLAND_MC_UCODE_SIZE;
 		regs_size = TAHITI_IO_MC_REGS_SIZE;
 		break;
 	case CHIP_HAINAN:
 		io_mc_regs = (u32 *)&hainan_io_mc_regs;
-		ucode_size = OLAND_MC_UCODE_SIZE;
 		regs_size = TAHITI_IO_MC_REGS_SIZE;
 		break;
 	}
@@ -1555,7 +1555,7 @@ static int si_init_microcode(struct radeon_device *rdev)
 	const char *chip_name;
 	const char *rlc_chip_name;
 	size_t pfp_req_size, me_req_size, ce_req_size, rlc_req_size, mc_req_size;
-	size_t smc_req_size;
+	size_t smc_req_size, mc2_req_size;
 	char fw_name[30];
 	int err;
 
@@ -1570,6 +1570,7 @@ static int si_init_microcode(struct radeon_device *rdev)
 		ce_req_size = SI_CE_UCODE_SIZE * 4;
 		rlc_req_size = SI_RLC_UCODE_SIZE * 4;
 		mc_req_size = SI_MC_UCODE_SIZE * 4;
+		mc2_req_size = TAHITI_MC_UCODE_SIZE * 4;
 		smc_req_size = ALIGN(TAHITI_SMC_UCODE_SIZE, 4);
 		break;
 	case CHIP_PITCAIRN:
@@ -1580,6 +1581,7 @@ static int si_init_microcode(struct radeon_device *rdev)
 		ce_req_size = SI_CE_UCODE_SIZE * 4;
 		rlc_req_size = SI_RLC_UCODE_SIZE * 4;
 		mc_req_size = SI_MC_UCODE_SIZE * 4;
+		mc2_req_size = PITCAIRN_MC_UCODE_SIZE * 4;
 		smc_req_size = ALIGN(PITCAIRN_SMC_UCODE_SIZE, 4);
 		break;
 	case CHIP_VERDE:
@@ -1590,6 +1592,7 @@ static int si_init_microcode(struct radeon_device *rdev)
 		ce_req_size = SI_CE_UCODE_SIZE * 4;
 		rlc_req_size = SI_RLC_UCODE_SIZE * 4;
 		mc_req_size = SI_MC_UCODE_SIZE * 4;
+		mc2_req_size = VERDE_MC_UCODE_SIZE * 4;
 		smc_req_size = ALIGN(VERDE_SMC_UCODE_SIZE, 4);
 		break;
 	case CHIP_OLAND:
@@ -1599,7 +1602,7 @@ static int si_init_microcode(struct radeon_device *rdev)
 		me_req_size = SI_PM4_UCODE_SIZE * 4;
 		ce_req_size = SI_CE_UCODE_SIZE * 4;
 		rlc_req_size = SI_RLC_UCODE_SIZE * 4;
-		mc_req_size = OLAND_MC_UCODE_SIZE * 4;
+		mc_req_size = mc2_req_size = OLAND_MC_UCODE_SIZE * 4;
 		smc_req_size = ALIGN(OLAND_SMC_UCODE_SIZE, 4);
 		break;
 	case CHIP_HAINAN:
@@ -1609,7 +1612,7 @@ static int si_init_microcode(struct radeon_device *rdev)
 		me_req_size = SI_PM4_UCODE_SIZE * 4;
 		ce_req_size = SI_CE_UCODE_SIZE * 4;
 		rlc_req_size = SI_RLC_UCODE_SIZE * 4;
-		mc_req_size = OLAND_MC_UCODE_SIZE * 4;
+		mc_req_size = mc2_req_size = OLAND_MC_UCODE_SIZE * 4;
 		smc_req_size = ALIGN(HAINAN_SMC_UCODE_SIZE, 4);
 		break;
 	default: BUG();
@@ -1662,16 +1665,22 @@ static int si_init_microcode(struct radeon_device *rdev)
 		err = -EINVAL;
 	}
 
-	snprintf(fw_name, sizeof(fw_name), "radeon/%s_mc.bin", chip_name);
+	snprintf(fw_name, sizeof(fw_name), "radeon/%s_mc2.bin", chip_name);
 	err = request_firmware(&rdev->mc_fw, fw_name, rdev->dev);
-	if (err)
-		goto out;
-	if (rdev->mc_fw->size != mc_req_size) {
+	if (err) {
+		snprintf(fw_name, sizeof(fw_name), "radeon/%s_mc.bin", chip_name);
+		err = request_firmware(&rdev->mc_fw, fw_name, rdev->dev);
+		if (err)
+			goto out;
+	}
+	if ((rdev->mc_fw->size != mc_req_size) &&
+	    (rdev->mc_fw->size != mc2_req_size)) {
 		printk(KERN_ERR
 		       "si_mc: Bogus length %zu in firmware \"%s\"\n",
 		       rdev->mc_fw->size, fw_name);
 		err = -EINVAL;
 	}
+	DRM_INFO("%s: %zu bytes\n", fw_name, rdev->mc_fw->size);
 
 	snprintf(fw_name, sizeof(fw_name), "radeon/%s_smc.bin", chip_name);
 	err = request_firmware(&rdev->smc_fw, fw_name, rdev->dev);
-- 
1.9.3

