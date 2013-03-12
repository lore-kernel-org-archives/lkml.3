Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306Ab3CLWcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:32:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60066 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680Ab3CLWcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:32:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Martin=20Storsj=C3=B6?= <martin@martin.st>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 001/100] ARM: VFP: fix emulation of second VFP instruction
Date: Tue, 12 Mar 2013 15:30:46 -0700
Message-Id: <20130312223123.035802490@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/vfp/vfpmodule.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -413,7 +413,7 @@ void VFP_bounce(u32 trigger, u32 fpexc,
 	 * If there isn't a second FP instruction, exit now. Note that
 	 * the FPEXC.FP2V bit is valid only if FPEXC.EX is 1.
 	 */
-	if (fpexc ^ (FPEXC_EX | FPEXC_FP2V))
+	if ((fpexc & (FPEXC_EX | FPEXC_FP2V)) != (FPEXC_EX | FPEXC_FP2V))
 		goto exit;
 
 	/*


