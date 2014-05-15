Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753761AbaEOAfL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 20:35:11 -0400
Received: from mail-oa0-f73.google.com ([209.85.219.73]:40281 "EHLO
	mail-oa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbaEOAdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 20:33:15 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: linux-tegra@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [RFC PATCH 05/10] ARM: tegra: Export function to read USB calibration data
Date: Wed, 14 May 2014 17:33:01 -0700
Message-Id: <1400113986-339-6-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.9.1.423.g4596e3a
In-Reply-To: <1400113986-339-1-git-send-email-abrestic@chromium.org>
References: <1400113986-339-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Board-specific USB configuration data is stored in FUSE_SKU_CALIB_0.
Export a function to read it so the PHY can be properly configured.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 arch/arm/mach-tegra/fuse.c | 13 +++++++++++++
 include/linux/tegra-soc.h  |  1 +
 2 files changed, 14 insertions(+)

diff --git a/arch/arm/mach-tegra/fuse.c b/arch/arm/mach-tegra/fuse.c
index c9ac23b..e457ef7 100644
--- a/arch/arm/mach-tegra/fuse.c
+++ b/arch/arm/mach-tegra/fuse.c
@@ -34,6 +34,7 @@
 #define FUSE_UID_HIGH		0x10c
 
 /* Tegra30 and later */
+#define FUSE_USB_CALIB		0x1f0
 #define FUSE_VENDOR_CODE	0x200
 #define FUSE_FAB_CODE		0x204
 #define FUSE_LOT_CODE_0		0x208
@@ -154,6 +155,18 @@ u32 tegra_read_chipid(void)
 	return readl_relaxed(IO_ADDRESS(TEGRA_APB_MISC_BASE) + 0x804);
 }
 
+u32 tegra_read_usb_calibration_data(void)
+{
+	u32 reg;
+
+	tegra_fuse_enable_clk();
+	reg = tegra_fuse_readl(FUSE_USB_CALIB);
+	tegra_fuse_disable_clk();
+
+	return reg;
+}
+EXPORT_SYMBOL(tegra_read_usb_calibration_data);
+
 static void __init tegra20_fuse_init_randomness(void)
 {
 	u32 randomness[2];
diff --git a/include/linux/tegra-soc.h b/include/linux/tegra-soc.h
index 95f611d..492dc95 100644
--- a/include/linux/tegra-soc.h
+++ b/include/linux/tegra-soc.h
@@ -18,5 +18,6 @@
 #define __LINUX_TEGRA_SOC_H_
 
 u32 tegra_read_chipid(void);
+u32 tegra_read_usb_calibration_data(void);
 
 #endif /* __LINUX_TEGRA_SOC_H_ */
-- 
1.9.1.423.g4596e3a

