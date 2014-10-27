Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbaJ0FTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:19:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:52184 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469AbaJ0FTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:19:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="406497571"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, x86@kernel.org
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [Patch v7 03/18] ACPI, irq, x86: Return IRQ instead of GSI in mp_register_gsi()
Date: Mon, 27 Oct 2014 13:21:33 +0800
Message-Id: <1414387308-27148-4-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1414387308-27148-1-git-send-email-jiang.liu@linux.intel.com>
References: <1414387308-27148-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GSI for ACPI SCI may be shared with other devices. For example,

Function mp_register_gsi() should return IRQ number, so fix a regression
by returning mp_map_gsi_to_irq(gsi, 0) instead of gsi.

The regression was caused by commit 84245af7297ced9e8fe "x86, irq, ACPI:
Change __acpi_register_gsi to return IRQ number instead of GSI" and
exposed on a SuperMicro system, which shares one GSI between ACPI SCI
and PCI device, with following failure:

http://sourceforge.net/p/linux1394/mailman/linux1394-user/?viewmonth=201410
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 20 low
level)
[    2.699224] firewire_ohci 0000:06:00.0: failed to allocate interrupt
20

Reported-and-Tested-by: Daniel Robbins <drobbins@funtoo.org>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: <stable@vger.kernel.org> # 3.17
---
 arch/x86/kernel/acpi/boot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index eceba9d9e116..e077c080a519 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -397,7 +397,7 @@ static int mp_register_gsi(struct device *dev, u32 gsi, int trigger,
 
 	/* Don't set up the ACPI SCI because it's already set up */
 	if (acpi_gbl_FADT.sci_interrupt == gsi)
-		return gsi;
+		return mp_map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC);
 
 	trigger = trigger == ACPI_EDGE_SENSITIVE ? 0 : 1;
 	polarity = polarity == ACPI_ACTIVE_HIGH ? 0 : 1;
-- 
1.7.10.4

