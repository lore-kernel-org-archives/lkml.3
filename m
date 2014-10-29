Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268AbaJ2JMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 05:12:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58946 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196AbaJ2JMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 05:12:40 -0400
Date: Wed, 29 Oct 2014 02:10:32 -0700
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-f18298595aefa2c836a128ec6e0f75f39965dd81@git.kernel.org>
Cc: rjw@rjwysocki.net, joro@8bytes.org, bp@alien8.de,
        jiang.liu@linux.intel.com, andriy.shevchenko@linux.intel.com,
        tony.luck@intel.com, benh@kernel.crashing.org, hpa@zytor.com,
        bhelgaas@google.com, rdunlap@infradead.org, gregkh@linuxfoundation.org,
        konrad.wilk@oracle.com, david.a.cohen@linux.intel.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org, yinghai@kernel.org,
        hpa@linux.intel.com, tglx@linutronix.de
Reply-To: jiang.liu@linux.intel.com, andriy.shevchenko@linux.intel.com,
        tony.luck@intel.com, bhelgaas@google.com, gregkh@linuxfoundation.org,
        konrad.wilk@oracle.com, rdunlap@infradead.org, hpa@zytor.com,
        benh@kernel.crashing.org, joro@8bytes.org, rjw@rjwysocki.net,
        bp@alien8.de, hpa@linux.intel.com, yinghai@kernel.org,
        tglx@linutronix.de, david.a.cohen@linux.intel.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org
In-Reply-To: <1414387308-27148-3-git-send-email-jiang.liu@linux.intel.com>
References: <1414387308-27148-3-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, intel-mid:
  Create IRQs for APB timers and RTC timers
Git-Commit-ID: f18298595aefa2c836a128ec6e0f75f39965dd81
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

Commit-ID:  f18298595aefa2c836a128ec6e0f75f39965dd81
Gitweb:     http://git.kernel.org/tip/f18298595aefa2c836a128ec6e0f75f39965dd81
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 27 Oct 2014 13:21:32 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 29 Oct 2014 08:52:23 +0100

x86, intel-mid: Create IRQs for APB timers and RTC timers

Intel MID platforms has no legacy interrupts, so no IRQ descriptors
preallocated. We need to call mp_map_gsi_to_irq() to create IRQ
descriptors for APB timers and RTC timers, otherwise it may cause
invalid memory access as:
[    0.116839] BUG: unable to handle kernel NULL pointer dereference at
0000003a
[    0.123803] IP: [<c1071c0e>] setup_irq+0xf/0x4d

Tested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: David Cohen <david.a.cohen@linux.intel.com>
Cc: <stable@vger.kernel.org> # 3.17
Link: http://lkml.kernel.org/r/1414387308-27148-3-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/apb_timer.c       | 2 --
 arch/x86/platform/intel-mid/sfi.c | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apb_timer.c b/arch/x86/kernel/apb_timer.c
index 5972b10..b708738 100644
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
index 3c53a90..c14ad34 100644
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
