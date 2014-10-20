Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560AbaJTP0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 11:26:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40758 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaJTP0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 11:26:33 -0400
Date: Mon, 20 Oct 2014 08:25:55 -0700
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-961b6a7003acec4f9d70dabc1a253b783cb74272@git.kernel.org>
Cc: bhelgaas@google.com, rjw@rjwysocki.net, jiang.liu@linux.intel.com,
        thor@math.tu-berlin.de, mingo@kernel.org, tony.luck@intel.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de
Reply-To: hpa@zytor.com, tony.luck@intel.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, jiang.liu@linux.intel.com,
        bhelgaas@google.com, rjw@rjwysocki.net, mingo@kernel.org,
        thor@math.tu-berlin.de
In-Reply-To: <1413816327-12850-1-git-send-email-jiang.liu@linux.intel.com>
References: <1413816327-12850-1-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: ACPI:
  Do not translate GSI number if IOAPIC is disabled
Git-Commit-ID: 961b6a7003acec4f9d70dabc1a253b783cb74272
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

Commit-ID:  961b6a7003acec4f9d70dabc1a253b783cb74272
Gitweb:     http://git.kernel.org/tip/961b6a7003acec4f9d70dabc1a253b783cb74272
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 20 Oct 2014 22:45:27 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 20 Oct 2014 17:23:00 +0200

x86: ACPI: Do not translate GSI number if IOAPIC is disabled

When IOAPIC is disabled, acpi_gsi_to_irq() should return gsi directly
instead of calling mp_map_gsi_to_irq() to translate gsi to IRQ by IOAPIC.
It fixes https://bugzilla.kernel.org/show_bug.cgi?id=84381.

This regression was introduced with commit 6b9fb7082409 "x86, ACPI,
irq: Consolidate algorithm of mapping (ioapic, pin) to IRQ number"

Reported-and-Tested-by: Thomas Richter <thor@math.tu-berlin.de>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Thomas Richter <thor@math.tu-berlin.de>
Cc: rui.zhang@intel.com
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: <stable@vger.kernel.org> # 3.17
Link: http://lkml.kernel.org/r/1413816327-12850-1-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/acpi/boot.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index b436fc7..d5c8872 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -604,14 +604,18 @@ void __init acpi_pic_sci_set_trigger(unsigned int irq, u16 trigger)
 
 int acpi_gsi_to_irq(u32 gsi, unsigned int *irqp)
 {
-	int irq = mp_map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC | IOAPIC_MAP_CHECK);
+	int irq;
 
-	if (irq >= 0) {
+	if (acpi_irq_model == ACPI_IRQ_MODEL_PIC) {
+		*irqp = gsi;
+	} else {
+		irq = mp_map_gsi_to_irq(gsi,
+					IOAPIC_MAP_ALLOC | IOAPIC_MAP_CHECK);
+		if (irq < 0)
+			return -1;
 		*irqp = irq;
-		return 0;
 	}
-
-	return -1;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(acpi_gsi_to_irq);
 
