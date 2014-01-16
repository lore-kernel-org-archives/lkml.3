Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbaAPXjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 18:39:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46418 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaAPXju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 18:39:50 -0500
Date: Thu, 16 Jan 2014 15:39:38 -0800
From: tip-bot for David Cohen <tipbot@zytor.com>
Message-ID: <tip-acb20d7395f75b0fdb5b300f9fb3b9c6054fb04f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.a.cohen@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        david.a.cohen@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1389913624-9149-2-git-send-email-david.a.cohen@linux.intel.com>
References: <1389913624-9149-2-git-send-email-david.a.cohen@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/intel-mid] x86, intel-mid: sfi_handle_*_dev()
  should check for pdata error code
Git-Commit-ID: acb20d7395f75b0fdb5b300f9fb3b9c6054fb04f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 16 Jan 2014 15:39:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  acb20d7395f75b0fdb5b300f9fb3b9c6054fb04f
Gitweb:     http://git.kernel.org/tip/acb20d7395f75b0fdb5b300f9fb3b9c6054fb04f
Author:     David Cohen <david.a.cohen@linux.intel.com>
AuthorDate: Thu, 16 Jan 2014 15:07:02 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 16 Jan 2014 15:06:29 -0800

x86, intel-mid: sfi_handle_*_dev() should check for pdata error code

When Intel MID finds a match between SFI table from FW and registered
SFI devices, it will always register a device regardless the platform
code was successful or not.

This patch adds an extra option for platform code to return error code
and abort device registration on SFI table parsing.

This patch does not contain any functional changes for current intel
mid platform code.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Link: http://lkml.kernel.org/r/1389913624-9149-2-git-send-email-david.a.cohen@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/platform/intel-mid/sfi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/platform/intel-mid/sfi.c b/arch/x86/platform/intel-mid/sfi.c
index 80a5228..1d5d20b 100644
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
