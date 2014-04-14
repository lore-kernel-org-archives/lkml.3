Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbaDNRs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 13:48:59 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:51544
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508AbaDNRs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 13:48:57 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: x86@kernel.org, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, tglx@linutronix.de, hpa@zytor.com,
        JBeulich@suse.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V4 1/1] X86: Probe for PIC and set legacy_pic appropriately
Date: Mon, 14 Apr 2014 11:43:49 -0700
Message-Id: <1397501029-29286-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The legacy PIC may or may not be available and we need a mechanism to detect the
existence of the legacy PIC that is applicable for all hardware (both physical
as well as virtual) currently supported by Linux. On Hyper-V, our legacy firmware
presented to the  guests, emulates the legacy PIC while our EFI based firmware
does not emulate the PIC. To support Hyper-V EFI firmware, we had to set the
legacy_pic to the null_legacy_pic since we had to bypass PIC based calibration in
the early boot code. While, on the EFI firmware, we know we don't emulate the
legacy PIC, we need a generic mechanism to detect the presence of the legacy
PIC that is not based on boot time state - this became apparent when we tried to
get kexec to work on Hyper-V EFI firmware.

This patch implements the proposal put forth by H. Peter Anvin <hpa@linux.intel.com>:
Write a known value to the PIC data port and read it back. If the value read is
the value written, we do have the PIC, if not there is no PIC and we can safely set
the legacy_pic to null_legacy_pic. Since the read from an unconnected I/O port
returns 0xff, we will use ~(1 << PIC_CASCADE_IR) (0xfb: mask all lines except
the cascade line) to probe for the existence of the PIC.

In version V1 of the patch, I had cleaned up the code based on comments from Peter.
In version V2 of the patch, I have addressed additional comments from Peter.
In version V3 of the patch, I have addressed Jan's comments (JBeulich@suse.com).
In version V4 of the patch, I have addressed additional comments from Peter.


Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 arch/x86/kernel/cpu/mshyperv.c |    2 --
 arch/x86/kernel/i8259.c        |   20 +++++++++++++++++++-
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 47359f7..9ca9587 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -133,8 +133,6 @@ static void __init ms_hyperv_init_platform(void)
 		printk(KERN_INFO "HyperV: LAPIC Timer Frequency: %#x\n",
 				lapic_timer_frequency);
 
-		printk(KERN_INFO "HyperV: Using null_legacy_pic\n");
-		legacy_pic = &null_legacy_pic;
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
-- 
1.7.4.1

