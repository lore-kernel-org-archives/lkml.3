Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbaDNU56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 16:57:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50362 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbaDNU5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 16:57:55 -0400
Date: Mon, 14 Apr 2014 13:57:37 -0700
From: "tip-bot for K. Y. Srinivasan" <tipbot@zytor.com>
Message-ID: <tip-e179f6914152eca9b338e7d8445684062f560c55@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        kys@microsoft.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        kys@microsoft.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1397501029-29286-1-git-send-email-kys@microsoft.com>
References: <1397501029-29286-1-git-send-email-kys@microsoft.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/irq] x86, irq, pic:
  Probe for legacy PIC and set legacy_pic appropriately
Git-Commit-ID: e179f6914152eca9b338e7d8445684062f560c55
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

Commit-ID:  e179f6914152eca9b338e7d8445684062f560c55
Gitweb:     http://git.kernel.org/tip/e179f6914152eca9b338e7d8445684062f560c55
Author:     K. Y. Srinivasan <kys@microsoft.com>
AuthorDate: Mon, 14 Apr 2014 11:43:49 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 14 Apr 2014 11:49:55 -0700

x86, irq, pic: Probe for legacy PIC and set legacy_pic appropriately

The legacy PIC may or may not be available and we need a mechanism to
detect the existence of the legacy PIC that is applicable for all
hardware (both physical as well as virtual) currently supported by
Linux.

On Hyper-V, when our legacy firmware presented to the guests, emulates
the legacy PIC while when our EFI based firmware is presented we do
not emulate the PIC. To support Hyper-V EFI firmware, we had to set
the legacy_pic to the null_legacy_pic since we had to bypass PIC based
calibration in the early boot code. While, on the EFI firmware, we
know we don't emulate the legacy PIC, we need a generic mechanism to
detect the presence of the legacy PIC that is not based on boot time
state - this became apparent when we tried to get kexec to work on
Hyper-V EFI firmware.

This patch implements the proposal put forth by H. Peter Anvin
<hpa@linux.intel.com>: Write a known value to the PIC data port and
read it back. If the value read is the value written, we do have the
PIC, if not there is no PIC and we can safely set the legacy_pic to
null_legacy_pic. Since the read from an unconnected I/O port returns
0xff, we will use ~(1 << PIC_CASCADE_IR) (0xfb: mask all lines except
the cascade line) to probe for the existence of the PIC.

In version V1 of the patch, I had cleaned up the code based on comments from Peter.
In version V2 of the patch, I have addressed additional comments from Peter.
In version V3 of the patch, I have addressed Jan's comments (JBeulich@suse.com).
In version V4 of the patch, I have addressed additional comments from Peter.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Link: http://lkml.kernel.org/r/1397501029-29286-1-git-send-email-kys@microsoft.com
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/mshyperv.c |  9 ---------
 arch/x86/kernel/i8259.c        | 20 +++++++++++++++++++-
 2 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 76f98fe..a450373 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -132,15 +132,6 @@ static void __init ms_hyperv_init_platform(void)
 		lapic_timer_frequency = hv_lapic_frequency;
 		printk(KERN_INFO "HyperV: LAPIC Timer Frequency: %#x\n",
 				lapic_timer_frequency);
-
-		/*
-		 * On Hyper-V, when we are booting off an EFI firmware stack,
-		 * we do not have many legacy devices including PIC, PIT etc.
-		 */
-		if (efi_enabled(EFI_BOOT)) {
-			printk(KERN_INFO "HyperV: Using null_legacy_pic\n");
-			legacy_pic = &null_legacy_pic;
-		}
 	}
 #endif
 
diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c
index 2e977b5..8af8171 100644
--- a/arch/x86/kernel/i8259.c
+++ b/arch/x86/kernel/i8259.c
@@ -299,13 +299,31 @@ static void unmask_8259A(void)
 static void init_8259A(int auto_eoi)
 {
 	unsigned long flags;
+	unsigned char probe_val = ~(1 << PIC_CASCADE_IR);
+	unsigned char new_val;
 
 	i8259A_auto_eoi = auto_eoi;
 
 	raw_spin_lock_irqsave(&i8259A_lock, flags);
 
-	outb(0xff, PIC_MASTER_IMR);	/* mask all of 8259A-1 */
+	/*
+	 * Check to see if we have a PIC.
+	 * Mask all except the cascade and read
+	 * back the value we just wrote. If we don't
+	 * have a PIC, we will read 0xff as opposed to the
+	 * value we wrote.
+	 */
 	outb(0xff, PIC_SLAVE_IMR);	/* mask all of 8259A-2 */
+	outb(probe_val, PIC_MASTER_IMR);
+	new_val = inb(PIC_MASTER_IMR);
+	if (new_val != probe_val) {
+		printk(KERN_INFO "Using NULL legacy PIC\n");
+		legacy_pic = &null_legacy_pic;
+		raw_spin_unlock_irqrestore(&i8259A_lock, flags);
+		return;
+	}
+
+	outb(0xff, PIC_MASTER_IMR);	/* mask all of 8259A-1 */
 
 	/*
 	 * outb_pic - this has to work on a wide range of PC hardware.
