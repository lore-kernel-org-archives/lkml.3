Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762394Ab3JQSUT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 14:20:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46032 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758369Ab3JQSUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 14:20:17 -0400
Date: Thu, 17 Oct 2013 11:19:57 -0700
From: tip-bot for David Cohen <tipbot@zytor.com>
Message-ID: <tip-d121fa8c225b89b0ea2c126bd9db6fff51949973@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        david.a.cohen@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        david.a.cohen@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1381896701-23476-11-git-send-email-david.a.cohen@linux.intel.com>
References: <1381896701-23476-11-git-send-email-david.a.cohen@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/intel-mid] intel-mid: sfi:
  allow struct devs_id.get_platform_data to be NULL
Git-Commit-ID: d121fa8c225b89b0ea2c126bd9db6fff51949973
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 17 Oct 2013 11:20:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d121fa8c225b89b0ea2c126bd9db6fff51949973
Gitweb:     http://git.kernel.org/tip/d121fa8c225b89b0ea2c126bd9db6fff51949973
Author:     David Cohen <david.a.cohen@linux.intel.com>
AuthorDate: Tue, 15 Oct 2013 21:11:39 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 16 Oct 2013 17:16:47 -0700

intel-mid: sfi: allow struct devs_id.get_platform_data to be NULL

Intel mid sfi code doesn't need struct devs_id.get_platform_data != NULL.
If the callback is not set, just assume there is no platform_data.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Link: http://lkml.kernel.org/r/1381896701-23476-11-git-send-email-david.a.cohen@linux.intel.com
Cc: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
