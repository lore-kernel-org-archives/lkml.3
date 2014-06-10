Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbaFJT4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:56:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35700 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591AbaFJTys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:54:48 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Deucher <alexander.deucher@amd.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 036/160] drm/radeon: add support for newer mc ucode on SI (v2)
Date: Tue, 10 Jun 2014 12:44:36 -0700
Message-Id: <1402429600-20477-37-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 1ebe92802eaf0569784dce843bc28a78842d236c upstream.

May fix stability issues with some newer cards.

v2: print out mc firmware version used and size

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/radeon/radeon_ucode.h |  3 +++
 drivers/gpu/drm/radeon/si.c           | 35 ++++++++++++++++++++++-------------
 2 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_ucode.h b/drivers/gpu/drm/radeon/radeon_ucode.h
index a77cd27..f415548 100644
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
 #define HAWAII_MC_UCODE_SIZE         7933
diff --git a/drivers/gpu/drm/radeon/si.c b/drivers/gpu/drm/radeon/si.c
index 4a2e532..925cac0 100644
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
 
@@ -1465,7 +1470,7 @@ static int si_mc_load_microcode(struct radeon_device *rdev)
 	const __be32 *fw_data;
 	u32 running, blackout = 0;
 	u32 *io_mc_regs;
-	int i, ucode_size, regs_size;
+	int i, regs_size, ucode_size = rdev->mc_fw->size / 4;
 
 	if (!rdev->mc_fw)
 		return -EINVAL;
@@ -1473,28 +1478,23 @@ static int si_mc_load_microcode(struct radeon_device *rdev)
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
@@ -1550,7 +1550,7 @@ static int si_init_microcode(struct radeon_device *rdev)
 	const char *chip_name;
 	const char *rlc_chip_name;
 	size_t pfp_req_size, me_req_size, ce_req_size, rlc_req_size, mc_req_size;
-	size_t smc_req_size;
+	size_t smc_req_size, mc2_req_size;
 	char fw_name[30];
 	int err;
 
@@ -1565,6 +1565,7 @@ static int si_init_microcode(struct radeon_device *rdev)
 		ce_req_size = SI_CE_UCODE_SIZE * 4;
 		rlc_req_size = SI_RLC_UCODE_SIZE * 4;
 		mc_req_size = SI_MC_UCODE_SIZE * 4;
+		mc2_req_size = TAHITI_MC_UCODE_SIZE * 4;
 		smc_req_size = ALIGN(TAHITI_SMC_UCODE_SIZE, 4);
 		break;
 	case CHIP_PITCAIRN:
@@ -1575,6 +1576,7 @@ static int si_init_microcode(struct radeon_device *rdev)
 		ce_req_size = SI_CE_UCODE_SIZE * 4;
 		rlc_req_size = SI_RLC_UCODE_SIZE * 4;
 		mc_req_size = SI_MC_UCODE_SIZE * 4;
+		mc2_req_size = PITCAIRN_MC_UCODE_SIZE * 4;
 		smc_req_size = ALIGN(PITCAIRN_SMC_UCODE_SIZE, 4);
 		break;
 	case CHIP_VERDE:
@@ -1585,6 +1587,7 @@ static int si_init_microcode(struct radeon_device *rdev)
 		ce_req_size = SI_CE_UCODE_SIZE * 4;
 		rlc_req_size = SI_RLC_UCODE_SIZE * 4;
 		mc_req_size = SI_MC_UCODE_SIZE * 4;
+		mc2_req_size = VERDE_MC_UCODE_SIZE * 4;
 		smc_req_size = ALIGN(VERDE_SMC_UCODE_SIZE, 4);
 		break;
 	case CHIP_OLAND:
@@ -1594,7 +1597,7 @@ static int si_init_microcode(struct radeon_device *rdev)
 		me_req_size = SI_PM4_UCODE_SIZE * 4;
 		ce_req_size = SI_CE_UCODE_SIZE * 4;
 		rlc_req_size = SI_RLC_UCODE_SIZE * 4;
-		mc_req_size = OLAND_MC_UCODE_SIZE * 4;
+		mc_req_size = mc2_req_size = OLAND_MC_UCODE_SIZE * 4;
 		smc_req_size = ALIGN(OLAND_SMC_UCODE_SIZE, 4);
 		break;
 	case CHIP_HAINAN:
@@ -1604,7 +1607,7 @@ static int si_init_microcode(struct radeon_device *rdev)
 		me_req_size = SI_PM4_UCODE_SIZE * 4;
 		ce_req_size = SI_CE_UCODE_SIZE * 4;
 		rlc_req_size = SI_RLC_UCODE_SIZE * 4;
-		mc_req_size = OLAND_MC_UCODE_SIZE * 4;
+		mc_req_size = mc2_req_size = OLAND_MC_UCODE_SIZE * 4;
 		smc_req_size = ALIGN(HAINAN_SMC_UCODE_SIZE, 4);
 		break;
 	default: BUG();
@@ -1657,16 +1660,22 @@ static int si_init_microcode(struct radeon_device *rdev)
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
1.9.1

