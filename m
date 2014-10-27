Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953AbaJ0FTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:19:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:20805 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750873AbaJ0FTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:19:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="406497536"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        David Cohen <david.a.cohen@linux.intel.com>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [Patch v7 02/18] x86, intel-mid: Create IRQs for APB timers and RTC timers
Date: Mon, 27 Oct 2014 13:21:32 +0800
Message-Id: <1414387308-27148-3-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1414387308-27148-1-git-send-email-jiang.liu@linux.intel.com>
References: <1414387308-27148-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel MID platforms has no legacy interrupts, so no IRQ descriptors
preallocated. We need to call mp_map_gsi_to_irq() to create IRQ
descriptors for APB timers and RTC timers, otherwise it may cause
invalid memory access as:
[    0.116839] BUG: unable to handle kernel NULL pointer dereference at
0000003a
[    0.123803] IP: [<c1071c0e>] setup_irq+0xf/0x4d

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Tested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: <stable@vger.kernel.org> # 3.17
---
 arch/x86/kernel/apb_timer.c       |    2 --
 arch/x86/platform/intel-mid/sfi.c |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index 5972b108f15a..b708738d016e 100644
--- a/arch/x86/kernel/apb_timer.c
+++ b/arch/x86/kernel/apb_timer.c
@@ -185,8 +185,6 @@ static void apbt_setup_irq(struct apbt_dev *adev)
 
 	irq_modify_status(adev->irq, 0, IRQ_MOVE_PCNTXT);
 	irq_set_affinity(adev->irq, cpumask_of(adev->cpu));
-	/* APB timer irqs are set up as mp_irqs, timer is edge type */
-	__irq_set_handler(adev->irq, handle_edge_irq, 0, "edge");
 }
 
 /* Should be called with per cpu */
diff --git a/arch/x86/platform/intel-mid/sfi.c b/arch/x86/platform/intel-mid/sfi.c
index 3c53a90fdb18..c14ad34776c4 100644
--- a/arch/x86/platform/intel-mid/sfi.c
+++ b/arch/x86/platform/intel-mid/sfi.c
@@ -106,6 +106,7 @@ int __init sfi_parse_mtmr(struct sfi_table_header *table)
 			mp_irq.dstapic = MP_APIC_ALL;
 			mp_irq.dstirq = pentry->irq;
 			mp_save_irq(&mp_irq);
+			mp_map_gsi_to_irq(pentry->irq, IOAPIC_MAP_ALLOC);
 	}
 
 	return 0;
@@ -176,6 +177,7 @@ int __init sfi_parse_mrtc(struct sfi_table_header *table)
 		mp_irq.dstapic = MP_APIC_ALL;
 		mp_irq.dstirq = pentry->irq;
 		mp_save_irq(&mp_irq);
+		mp_map_gsi_to_irq(pentry->irq, IOAPIC_MAP_ALLOC);
 	}
 	return 0;
 }
-- 
1.7.10.4

