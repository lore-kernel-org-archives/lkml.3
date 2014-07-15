Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965425AbaGOXmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:42:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45024 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933873AbaGOXOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:14:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Joel Stanley <joel@jms.id.au>, Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>, Alexander Graf <agraf@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.15 28/84] powerpc/kvm: Remove redundant save of SIER AND MMCR2
Date: Tue, 15 Jul 2014 16:17:25 -0700
Message-Id: <20140715231714.052565870@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231713.193785557@linuxfoundation.org>
References: <20140715231713.193785557@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joel Stanley <joel@jms.id.au>

commit f73128f4f680e8be68cda831f2710214559583cb upstream.

These two registers are already saved in the block above. Aside from
being unnecessary, by the time we get down to the second save location
r8 no longer contains MMCR2, so we are clobbering the saved value with
PMC5.

MMCR2 primarily consists of counter freeze bits. So restoring the value
of PMC5 into MMCR2 will most likely have the effect of freezing
counters.

Fixes: 72cde5a88d37 ("KVM: PPC: Book3S HV: Save/restore host PMU registers that are new in POWER8")
Signed-off-by: Joel Stanley <joel@jms.id.au>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Acked-by: Paul Mackerras <paulus@samba.org>
Reviewed-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kvm/book3s_hv_interrupts.S |    5 -----
 1 file changed, 5 deletions(-)

--- a/arch/powerpc/kvm/book3s_hv_interrupts.S
+++ b/arch/powerpc/kvm/book3s_hv_interrupts.S
@@ -127,11 +127,6 @@ BEGIN_FTR_SECTION
 	stw	r10, HSTATE_PMC + 24(r13)
 	stw	r11, HSTATE_PMC + 28(r13)
 END_FTR_SECTION_IFSET(CPU_FTR_ARCH_201)
-BEGIN_FTR_SECTION
-	mfspr	r9, SPRN_SIER
-	std	r8, HSTATE_MMCR + 40(r13)
-	std	r9, HSTATE_MMCR + 48(r13)
-END_FTR_SECTION_IFSET(CPU_FTR_ARCH_207S)
 31:
 
 	/*


