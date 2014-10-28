Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbaJ1S4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 14:56:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54272 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbaJ1S4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 14:56:08 -0400
Date: Tue, 28 Oct 2014 11:54:42 -0700
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-91d0639923526b8f312a4d865451934ab67e7730@git.kernel.org>
Cc: bhelgaas@google.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        tony.luck@intel.com, konrad.wilk@oracle.com,
        gregkh@linuxfoundation.org, pavel@ucw.cz, bp@alien8.de,
        jiang.liu@linux.intel.com, joro@8bytes.org, rjw@rjwysocki.net,
        mingo@kernel.org, rdunlap@infradead.org, hpa@zytor.com,
        yinghai@kernel.org, len.brown@intel.com, drobbins@funtoo.org,
        benh@kernel.crashing.org
Reply-To: benh@kernel.crashing.org, drobbins@funtoo.org, len.brown@intel.com,
        yinghai@kernel.org, hpa@zytor.com, rdunlap@infradead.org,
        rjw@rjwysocki.net, mingo@kernel.org, jiang.liu@linux.intel.com,
        joro@8bytes.org, bp@alien8.de, pavel@ucw.cz, konrad.wilk@oracle.com,
        gregkh@linuxfoundation.org, tony.luck@intel.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, bhelgaas@google.com
In-Reply-To: <1414387308-27148-4-git-send-email-jiang.liu@linux.intel.com>
References: <1414387308-27148-4-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] ACPI, irq, x86:
  Return IRQ instead of GSI in mp_register_gsi()
Git-Commit-ID: 91d0639923526b8f312a4d865451934ab67e7730
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

Commit-ID:  91d0639923526b8f312a4d865451934ab67e7730
Gitweb:     http://git.kernel.org/tip/91d0639923526b8f312a4d865451934ab67e7730
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 27 Oct 2014 13:21:33 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 28 Oct 2014 19:50:50 +0100

ACPI, irq, x86: Return IRQ instead of GSI in mp_register_gsi()

Function mp_register_gsi() returns blindly the GSI number for the ACPI
SCI interrupt. That causes a regression when the GSI for ACPI SCI is
shared with other devices.

The regression was caused by commit 84245af7297ced9e8fe "x86, irq, ACPI:
Change __acpi_register_gsi to return IRQ number instead of GSI" and
exposed on a SuperMicro system, which shares one GSI between ACPI SCI
and PCI device, with following failure:

http://sourceforge.net/p/linux1394/mailman/linux1394-user/?viewmonth=201410
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 20 low
level)
[    2.699224] firewire_ohci 0000:06:00.0: failed to allocate interrupt
20

Return mp_map_gsi_to_irq(gsi, 0) instead of the GSI number.

Reported-and-Tested-by: Daniel Robbins <drobbins@funtoo.org>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Len Brown <len.brown@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: <stable@vger.kernel.org> # 3.17
Link: http://lkml.kernel.org/r/1414387308-27148-4-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/acpi/boot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index d5c8872..a142e77 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -397,7 +397,7 @@ static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
 
 	/* Don't set up the ACPI SCI because it's already set up */
 	if (acpi_gbl_FADT.sci_interrupt == gsi)
-		return gsi;
+		return mp_map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC);
 
 	trigger = trigger == ACPI_EDGE_SENSITIVE ? 0 : 1;
 	polarity = polarity == ACPI_ACTIVE_HIGH ? 0 : 1;
