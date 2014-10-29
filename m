Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295AbaJ2JMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:12:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58948 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264AbaJ2JMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:12:43 -0400
Date: Wed, 29 Oct 2014 02:10:48 -0700
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-b77e8f435337baa1cd15852fb9db3f6d26cd8eb7@git.kernel.org>
Cc: drobbins@funtoo.org, linux-kernel@vger.kernel.org,
        jiang.liu@linux.intel.com, tony.luck@intel.com, len.brown@intel.com,
        yinghai@kernel.org, rjw@rjwysocki.net, gregkh@linuxfoundation.org,
        bp@alien8.de, rdunlap@infradead.org, hpa@zytor.com, mingo@kernel.org,
        benh@kernel.crashing.org, bhelgaas@google.com, joro@8bytes.org,
        konrad.wilk@oracle.com, pavel@ucw.cz, tglx@linutronix.de
Reply-To: drobbins@funtoo.org, jiang.liu@linux.intel.com,
        linux-kernel@vger.kernel.org, len.brown@intel.com, tony.luck@intel.com,
        bp@alien8.de, gregkh@linuxfoundation.org, yinghai@kernel.org,
        rjw@rjwysocki.net, mingo@kernel.org, hpa@zytor.com,
        rdunlap@infradead.org, konrad.wilk@oracle.com, tglx@linutronix.de,
        pavel@ucw.cz, joro@8bytes.org, bhelgaas@google.com,
        benh@kernel.crashing.org
In-Reply-To: <1414387308-27148-4-git-send-email-jiang.liu@linux.intel.com>
References: <1414387308-27148-4-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] ACPI, irq, x86:
  Return IRQ instead of GSI in mp_register_gsi()
Git-Commit-ID: b77e8f435337baa1cd15852fb9db3f6d26cd8eb7
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

Commit-ID:  b77e8f435337baa1cd15852fb9db3f6d26cd8eb7
Gitweb:     http://git.kernel.org/tip/b77e8f435337baa1cd15852fb9db3f6d26cd8eb7
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 27 Oct 2014 13:21:33 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 29 Oct 2014 08:52:30 +0100

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
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
