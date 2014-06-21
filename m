Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375AbaFUVLc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 17:11:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35568 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757240AbaFUVLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 17:11:30 -0400
Date: Sat, 21 Jun 2014 14:10:29 -0700
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-032329eebba86350849c027fe3a0b672558893d4@git.kernel.org>
Cc: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        len.brown@intel.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        jiang.liu@linux.intel.com, grant.likely@linaro.org, yinghai@kernel.org,
        joro@8bytes.org, pavel@ucw.cz, benh@kernel.crashing.org,
        bhelgaas@google.com, rjw@rjwysocki.net, paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, konrad.wilk@oracle.com, rdunlap@infradead.org,
        tony.luck@intel.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        len.brown@intel.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        jiang.liu@linux.intel.com, grant.likely@linaro.org, yinghai@kernel.org,
        joro@8bytes.org, pavel@ucw.cz, benh@kernel.crashing.org,
        bhelgaas@google.com, rjw@rjwysocki.net, paul.gortmaker@windriver.com
In-Reply-To: <1402302011-23642-7-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-7-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, acpi, irq: Kill static function irq_to_gsi()
Git-Commit-ID: 032329eebba86350849c027fe3a0b672558893d4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  032329eebba86350849c027fe3a0b672558893d4
Gitweb:     http://git.kernel.org/tip/032329eebba86350849c027fe3a0b672558893d4
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 9 Jun 2014 16:19:35 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 21 Jun 2014 23:05:40 +0200

x86, acpi, irq: Kill static function irq_to_gsi()

Static function irq_to_gsi() is only called by acpi_isa_irq_to_gsi(),
so kill function irq_to_gsi() and simplify acpi_isa_irq_to_gsi().

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Link: http://lkml.kernel.org/r/1402302011-23642-7-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/acpi/boot.c | 26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index ceb3b36..0968276 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -120,22 +120,6 @@ static unsigned int gsi_to_irq(unsigned int gsi)
 	return irq;
 }
 
-static u32 irq_to_gsi(int irq)
-{
-	unsigned int gsi;
-
-	if (irq < NR_IRQS_LEGACY)
-		gsi = isa_irq_to_gsi[irq];
-	else if (irq < gsi_top)
-		gsi = irq;
-	else if (irq < (gsi_top + NR_IRQS_LEGACY))
-		gsi = irq - gsi_top;
-	else
-		gsi = 0xffffffff;
-
-	return gsi;
-}
-
 /*
  * This is just a simple wrapper around early_ioremap(),
  * with sanity checks for phys == 0 and size == 0.
@@ -640,10 +624,12 @@ EXPORT_SYMBOL_GPL(acpi_gsi_to_irq);
 
 int acpi_isa_irq_to_gsi(unsigned isa_irq, u32 *gsi)
 {
-	if (isa_irq >= 16)
-		return -1;
-	*gsi = irq_to_gsi(isa_irq);
-	return 0;
+	if (isa_irq < NR_IRQS_LEGACY) {
+		*gsi = isa_irq_to_gsi[isa_irq];
+		return 0;
+	}
+
+	return -1;
 }
 
 static int acpi_register_gsi_pic(struct device *dev, u32 gsi,
