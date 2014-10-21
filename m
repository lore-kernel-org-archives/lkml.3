Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbaJUEQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 00:16:25 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:34009 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637AbaJUEPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 00:15:00 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH v2 45/47] x86: pmc_atom: Register poweroff handler with kernel poweroff handler
Date: Mon, 20 Oct 2014 21:13:01 -0700
Message-Id: <1413864783-3271-46-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020202.5445DDC4.0049,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 251
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 3
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register with kernel poweroff handler instead of setting pm_power_off
directly. Register with low priority to reflect that the original code
only sets pm_power_off if it was not already set.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
- Use define to specify poweroff handler priority
- Use dev_warn instead of dev_err

 arch/x86/kernel/pmc_atom.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/pmc_atom.c b/arch/x86/kernel/pmc_atom.c
index 0ee5025e..7799cdf 100644
--- a/arch/x86/kernel/pmc_atom.c
+++ b/arch/x86/kernel/pmc_atom.c
@@ -20,6 +20,8 @@
 #include <linux/pci.h>
 #include <linux/device.h>
 #include <linux/debugfs.h>
+#include <linux/notifier.h>
+#include <linux/pm.h>
 #include <linux/seq_file.h>
 #include <linux/io.h>
 
@@ -92,7 +94,8 @@ static inline void pmc_reg_write(struct pmc_dev *pmc, int reg_offset, u32 val)
 	writel(val, pmc->regmap + reg_offset);
 }
 
-static void pmc_power_off(void)
+static int pmc_power_off(struct notifier_block *this, unsigned long unused1,
+			 void *unused2)
 {
 	u16	pm1_cnt_port;
 	u32	pm1_cnt_value;
@@ -107,8 +110,15 @@ static void pmc_power_off(void)
 	pm1_cnt_value |= SLEEP_ENABLE;
 
 	outl(pm1_cnt_value, pm1_cnt_port);
+
+	return NOTIFY_DONE;
 }
 
+static struct notifier_block pmc_poweroff_nb = {
+	.notifier_call = pmc_power_off,
+	.priority = POWEROFF_PRIORITY_LOW,
+};
+
 static void pmc_hw_reg_setup(struct pmc_dev *pmc)
 {
 	/*
@@ -252,8 +262,12 @@ static int pmc_setup_dev(struct pci_dev *pdev)
 	acpi_base_addr &= ACPI_BASE_ADDR_MASK;
 
 	/* Install power off function */
-	if (acpi_base_addr != 0 && pm_power_off == NULL)
-		pm_power_off = pmc_power_off;
+	if (acpi_base_addr != 0) {
+		ret = register_power_off_handler(&pmc_poweroff_nb);
+		if (ret)
+			dev_warn(&pdev->dev,
+				 "Failed to install poweroff handler\n");
+	}
 
 	pci_read_config_dword(pdev, PMC_BASE_ADDR_OFFSET, &pmc->base_addr);
 	pmc->base_addr &= PMC_BASE_ADDR_MASK;
-- 
1.9.1

