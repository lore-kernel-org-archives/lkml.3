Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777AbaFUVMQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 17:12:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35631 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757703AbaFUVML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 17:12:11 -0400
Date: Sat, 21 Jun 2014 14:11:08 -0700
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-2e0ad0e2c13534f1a0e7f63661e666c281e09b66@git.kernel.org>
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
In-Reply-To: <1402302011-23642-10-git-send-email-jiang.liu@linux.intel.com>
References: <1402302011-23642-10-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, ACPI, irq:
  Fix possible eror in GSI to IRQ mapping for legacy IRQ
Git-Commit-ID: 2e0ad0e2c13534f1a0e7f63661e666c281e09b66
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

Commit-ID:  2e0ad0e2c13534f1a0e7f63661e666c281e09b66
Gitweb:     http://git.kernel.org/tip/2e0ad0e2c13534f1a0e7f63661e666c281e09b66
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 9 Jun 2014 16:19:38 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 21 Jun 2014 23:05:41 +0200

x86, ACPI, irq: Fix possible eror in GSI to IRQ mapping for legacy IRQ

A default identity mapping between GSI and IRQ is built for legacy IRQs.
So when overriding the default identity mapping for legacy IRQs,
we should also invalidate isa_irq_to_gsi[gsi] when setting
isa_irq_to_gsi[irq] = gsi.  Otherwise there may be two entries with the
same GSI in the isa_irq_to_gsi array, and acpi_isa_irq_to_gsi() may give
wrong result.

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
Link: http://lkml.kernel.org/r/1402302011-23642-10-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/acpi/boot.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 298f796..f3bafcd 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -366,6 +366,13 @@ static void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger,
 
 	mp_save_irq(&mp_irq);
 
+	/*
+	 * Reset default identity mapping if gsi is also an legacy IRQ,
+	 * otherwise there will be more than one entry with the same GSI
+	 * and acpi_isa_irq_to_gsi() may give wrong result.
+	 */
+	if (gsi < NR_IRQS_LEGACY && isa_irq_to_gsi[gsi] == gsi)
+		isa_irq_to_gsi[gsi] = ACPI_INVALID_GSI;
 	isa_irq_to_gsi[bus_irq] = gsi;
 }
 
@@ -621,7 +628,8 @@ EXPORT_SYMBOL_GPL(acpi_gsi_to_irq);
 
 int acpi_isa_irq_to_gsi(unsigned isa_irq, u32 *gsi)
 {
-	if (isa_irq < NR_IRQS_LEGACY) {
+	if (isa_irq < NR_IRQS_LEGACY &&
+	    isa_irq_to_gsi[isa_irq] != ACPI_INVALID_GSI) {
 		*gsi = isa_irq_to_gsi[isa_irq];
 		return 0;
 	}
