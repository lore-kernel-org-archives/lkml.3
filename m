Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932985Ab3JPEII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 00:08:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:18000 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751397Ab3JPEHu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 00:07:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,504,1378882800"; 
   d="scan'208";a="419797696"
From: David Cohen <david.a.cohen@linux.intel.com>
To: x86@kernel.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, sathyanarayanan.kuppuswamy@linux.intel.com,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: [PATCH v5 10/12] intel-mid: sfi: allow struct devs_id.get_platform_data to be NULL
Date: Tue, 15 Oct 2013 21:11:39 -0700
Message-Id: <1381896701-23476-11-git-send-email-david.a.cohen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381896701-23476-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1381896701-23476-1-git-send-email-david.a.cohen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel mid sfi code doesn't need struct devs_id.get_platform_data != NULL.
If the callback is not set, just assume there is no platform_data.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Cc: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
---
 arch/x86/platform/intel-mid/sfi.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/platform/intel-mid/sfi.c b/arch/x86/platform/intel-mid/sfi.c
index 2f8196d..3f1c171 100644
--- a/arch/x86/platform/intel-mid/sfi.c
+++ b/arch/x86/platform/intel-mid/sfi.c
@@ -70,6 +70,9 @@ struct blocking_notifier_head intel_scu_notifier =
 			BLOCKING_NOTIFIER_INIT(intel_scu_notifier);
 EXPORT_SYMBOL_GPL(intel_scu_notifier);
 
+#define intel_mid_sfi_get_pdata(dev, priv)	\
+	((dev)->get_platform_data ? (dev)->get_platform_data(priv) : NULL)
+
 /* parse all the mtimer info to a static mtimer array */
 int __init sfi_parse_mtmr(struct sfi_table_header *table)
 {
@@ -334,7 +337,7 @@ static void __init sfi_handle_ipc_dev(struct sfi_device_table_entry *pentry,
 
 	pr_debug("IPC bus, name = %16.16s, irq = 0x%2x\n",
 		pentry->name, pentry->irq);
-	pdata = dev->get_platform_data(pentry);
+	pdata = intel_mid_sfi_get_pdata(dev, pentry);
 
 	pdev = platform_device_alloc(pentry->name, 0);
 	if (pdev == NULL) {
@@ -367,7 +370,7 @@ static void __init sfi_handle_spi_dev(struct sfi_device_table_entry *pentry,
 		spi_info.max_speed_hz,
 		spi_info.chip_select);
 
-	pdata = dev->get_platform_data(&spi_info);
+	pdata = intel_mid_sfi_get_pdata(dev, &spi_info);
 
 	spi_info.platform_data = pdata;
 	if (dev->delay)
@@ -391,7 +394,7 @@ static void __init sfi_handle_i2c_dev(struct sfi_device_table_entry *pentry,
 		i2c_info.type,
 		i2c_info.irq,
 		i2c_info.addr);
-	pdata = dev->get_platform_data(&i2c_info);
+	pdata = intel_mid_sfi_get_pdata(dev, &i2c_info);
 	i2c_info.platform_data = pdata;
 
 	if (dev->delay)
@@ -450,7 +453,7 @@ static int __init sfi_parse_devs(struct sfi_table_header *table)
 
 		dev = get_device_id(pentry->type, pentry->name);
 
-		if ((dev == NULL) || (dev->get_platform_data == NULL))
+		if (!dev)
 			continue;
 
 		if (dev->device_handler) {
-- 
1.8.4.rc3

