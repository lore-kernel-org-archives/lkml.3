Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbaDKWHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 18:07:50 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:56272
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286AbaDKWHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 18:07:48 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: x86@kernel.org, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, tglx@linutronix.de, hpa@zytor.com,
        JBeulich@suse.com, bp@alien8.de
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] X86: Probe for PIC and set legacy_pic appropriately
Date: Fri, 11 Apr 2014 16:02:24 -0700
Message-Id: <1397257344-3035-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Probe for the existance of legacy PIC, if one does not exist, use the
null_legacy_pic.

This patch implements the proposal put forth by H. Peter Anvin <hpa@linux.intel.com>.


Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 arch/x86/kernel/cpu/mshyperv.c |    2 --
 arch/x86/kernel/i8259.c        |   11 +++++++++++
 2 files changed, 11 insertions(+), 2 deletions(-)

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
index 2e977b5..0a57a19 100644
--- a/arch/x86/kernel/i8259.c
+++ b/arch/x86/kernel/i8259.c
@@ -299,11 +299,22 @@ static void unmask_8259A(void)
 static void init_8259A(int auto_eoi)
 {
 	unsigned long flags;
+	unsigned char probe_val = 0xfb;
 
 	i8259A_auto_eoi = auto_eoi;
 
 	raw_spin_lock_irqsave(&i8259A_lock, flags);
 
+	/* Check to see if we have a PIC */
+	outb(probe_val, PIC_MASTER_IMR);
+	probe_val = inb(PIC_MASTER_IMR);
+	if (probe_val == 0xff) {
+		printk(KERN_INFO "Using NULL legacy PIC\n");
+		legacy_pic = &null_legacy_pic;
+		raw_spin_unlock_irqrestore(&i8259A_lock, flags);
+		return;
+	}
+
 	outb(0xff, PIC_MASTER_IMR);	/* mask all of 8259A-1 */
 	outb(0xff, PIC_SLAVE_IMR);	/* mask all of 8259A-2 */
 
-- 
1.7.4.1

