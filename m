Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802AbaAPXCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 18:02:50 -0500
Received: from mga02.intel.com ([134.134.136.20]:12166 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbaAPXCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 18:02:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,670,1384329600"; 
   d="scan'208";a="467941383"
From: David Cohen <david.a.cohen@linux.intel.com>
To: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, x86@kernel.org
Cc: david.a.cohen@linux.intel.com, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/3] x86: intel-mid: sfi_handle_*_dev() should check for pdata error code
Date: Thu, 16 Jan 2014 15:07:02 -0800
Message-Id: <1389913624-9149-2-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389913624-9149-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1389913624-9149-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When Intel MID finds a match between SFI table from FW and registered
SFI devices, it will always register a device regardless the platform
code was successful or not.

This patch adds an extra option for platform code to return error code
and abort device registration on SFI table parsing.

This patch does no functional change for current intel mid platform
code.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
---
 arch/x86/platform/intel-mid/sfi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/platform/intel-mid/sfi.c b/arch/x86/platform/intel-mid/sfi.c
index 80a52288555c..1d5d20b088fa 100644
--- a/arch/x86/platform/intel-mid/sfi.c
+++ b/arch/x86/platform/intel-mid/sfi.c
@@ -337,6 +337,8 @@ static void __init sfi_handle_ipc_dev(struct sfi_device_table_entry *pentry,
 	pr_debug("IPC bus, name = %16.16s, irq = 0x%2x\n",
 		pentry->name, pentry->irq);
 	pdata = intel_mid_sfi_get_pdata(dev, pentry);
+	if (IS_ERR(pdata))
+		return;
 
 	pdev = platform_device_alloc(pentry->name, 0);
 	if (pdev == NULL) {
@@ -370,6 +372,8 @@ static void __init sfi_handle_spi_dev(struct sfi_device_table_entry *pentry,
 		spi_info.chip_select);
 
 	pdata = intel_mid_sfi_get_pdata(dev, &spi_info);
+	if (IS_ERR(pdata))
+		return;
 
 	spi_info.platform_data = pdata;
 	if (dev->delay)
@@ -395,6 +399,8 @@ static void __init sfi_handle_i2c_dev(struct sfi_device_table_entry *pentry,
 		i2c_info.addr);
 	pdata = intel_mid_sfi_get_pdata(dev, &i2c_info);
 	i2c_info.platform_data = pdata;
+	if (IS_ERR(pdata))
+		return;
 
 	if (dev->delay)
 		intel_scu_i2c_device_register(pentry->host_num, &i2c_info);
-- 
1.8.4.2

