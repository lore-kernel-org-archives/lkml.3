Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbaANN6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 08:58:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49965 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbaANN6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 08:58:30 -0500
Date: Tue, 14 Jan 2014 05:58:12 -0800
From: tip-bot for Richard Weinberger <tipbot@zytor.com>
Message-ID: <tip-60283df7ac26a4fe2d56631ca2946e04725e7eaf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, richard@nod.at, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, richard@nod.at, tglx@linutronix.de
In-Reply-To: <1389685487-20872-1-git-send-email-richard@nod.at>
References: <1389685487-20872-1-git-send-email-richard@nod.at>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/apic: Read Error Status Register correctly
Git-Commit-ID: 60283df7ac26a4fe2d56631ca2946e04725e7eaf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 14 Jan 2014 05:58:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  60283df7ac26a4fe2d56631ca2946e04725e7eaf
Gitweb:     http://git.kernel.org/tip/60283df7ac26a4fe2d56631ca2946e04725e7eaf
Author:     Richard Weinberger <richard@nod.at>
AuthorDate: Tue, 14 Jan 2014 08:44:47 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 14 Jan 2014 14:05:36 +0100

x86/apic: Read Error Status Register correctly

Currently we do a read, a dummy write and a final read to fetch
the error code. The value from the final read is taken.
This is not the recommended way and leads to corrupted/lost ESR
values.

Intel(c) 64 and IA-32 Architectures Software Developer's Manual,
Combined Volumes 1, 2ABC, 3ABC, Section 10.5.3 states:

  Before attempt to read from the ESR, software should first
  write to it. (The value written does not affect the values read
  subsequently; only zero may be written in x2APIC mode.) This
  write clears any previously logged errors and updates the ESR
  with any errors detected since the last write to the ESR.
  This write also rearms the APIC error interrupt triggering
  mechanism.

This patch removes the first read such that we are conform with
the manual.

On my (very old) Pentium MMX SMP system this patch fixes the
issue that APIC errors:

  a) are not always reported and
  b) are reported with false error numbers.

Signed-off-by: Richard Weinberger <richard@nod.at>
Cc: seiji.aguchi@hds.com
Cc: rientjes@google.com
Cc: konrad.wilk@oracle.com
Cc: bp@alien8.de
Cc: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1389685487-20872-1-git-send-email-richard@nod.at
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/apic/apic.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index d278736..4ec1dd6 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1968,7 +1968,7 @@ __visible void smp_trace_spurious_interrupt(struct pt_regs *regs)
  */
 static inline void __smp_error_interrupt(struct pt_regs *regs)
 {
-	u32 v0, v1;
+	u32 v;
 	u32 i = 0;
 	static const char * const error_interrupt_reason[] = {
 		"Send CS error",		/* APIC Error Bit 0 */
@@ -1982,21 +1982,20 @@ static inline void __smp_error_interrupt(struct pt_regs *regs)
 	};
 
 	/* First tickle the hardware, only then report what went on. -- REW */
-	v0 = apic_read(APIC_ESR);
 	apic_write(APIC_ESR, 0);
-	v1 = apic_read(APIC_ESR);
+	v = apic_read(APIC_ESR);
 	ack_APIC_irq();
 	atomic_inc(&irq_err_count);
 
-	apic_printk(APIC_DEBUG, KERN_DEBUG "APIC error on CPU%d: %02x(%02x)",
-		    smp_processor_id(), v0 , v1);
+	apic_printk(APIC_DEBUG, KERN_DEBUG "APIC error on CPU%d: %02x",
+		    smp_processor_id(), v);
 
-	v1 = v1 & 0xff;
-	while (v1) {
-		if (v1 & 0x1)
+	v &= 0xff;
+	while (v) {
+		if (v & 0x1)
 			apic_printk(APIC_DEBUG, KERN_CONT " : %s", error_interrupt_reason[i]);
 		i++;
-		v1 >>= 1;
+		v >>= 1;
 	}
 
 	apic_printk(APIC_DEBUG, KERN_CONT "\n");
