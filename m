Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756927Ab3CNKhJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:37:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51743 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756862Ab3CNKg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:36:58 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 13/88] ARM: VFP: fix emulation of second VFP instruction
Date: Thu, 14 Mar 2013 10:35:06 +0000
Message-Id: <1363257381-15900-14-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/vfp/vfpmodule.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index 3b44e0d..5dfbb0b 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -413,7 +413,7 @@ void VFP_bounce(u32 trigger, u32 fpexc, struct pt_regs *regs)
 	 * If there isn't a second FP instruction, exit now. Note that
 	 * the FPEXC.FP2V bit is valid only if FPEXC.EX is 1.
 	 */
-	if (fpexc ^ (FPEXC_EX | FPEXC_FP2V))
+	if ((fpexc & (FPEXC_EX | FPEXC_FP2V)) != (FPEXC_EX | FPEXC_FP2V))
 		goto exit;
 
 	/*
-- 
1.8.1.2

