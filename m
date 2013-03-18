Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab3CREar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:30:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33381 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751250Ab3CREaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:30:03 -0400
Message-Id: <20130318042145.067262763@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:21:52 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Russell King <rmk+kernel@arm.linux.org.uk>,
        =?ISO-8859-15?q?Martin=20Storsj=C3=B6?= <martin@martin.st>
Subject: [ 08/82] ARM: VFP: fix emulation of second VFP instruction
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 5e4ba617c1b584b2e376f31a63bd4e734109318a upstream.

Martin Storsjö reports that the sequence:

        ee312ac1        vsub.f32        s4, s3, s2
        ee702ac0        vsub.f32        s5, s1, s0
        e59f0028        ldr             r0, [pc, #40]
        ee111a90        vmov            r1, s3

on Raspberry Pi (implementor 41 architecture 1 part 20 variant b rev 5)
where s3 is a denormal and s2 is zero results in incorrect behaviour -
the instruction "vsub.f32 s5, s1, s0" is not executed:

        VFP: bounce: trigger ee111a90 fpexc d0000780
        VFP: emulate: INST=0xee312ac1 SCR=0x00000000
        ...

As we can see, the instruction triggering the exception is the "vmov"
instruction, and we emulate the "vsub.f32 s4, s3, s2" but fail to
properly take account of the FPEXC_FP2V flag in FPEXC.  This is because
the test for the second instruction register being valid is bogus, and
will always skip emulation of the second instruction.

Reported-by: Martin Storsjö <martin@martin.st>
Tested-by: Martin Storsjö <martin@martin.st>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/vfp/vfpmodule.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -409,7 +409,7 @@ void VFP_bounce(u32 trigger, u32 fpexc,
 	 * If there isn't a second FP instruction, exit now. Note that
 	 * the FPEXC.FP2V bit is valid only if FPEXC.EX is 1.
 	 */
-	if (fpexc ^ (FPEXC_EX | FPEXC_FP2V))
+	if ((fpexc & (FPEXC_EX | FPEXC_FP2V)) != (FPEXC_EX | FPEXC_FP2V))
 		goto exit;
 
 	/*


