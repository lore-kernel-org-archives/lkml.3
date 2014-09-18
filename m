Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536AbaIRVnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 17:43:47 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:36127 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464AbaIRVnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 17:43:17 -0400
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 3/3] arm: vfp: Bounce undefined instructions in vectored mode
Date: Thu, 18 Sep 2014 14:43:12 -0700
Message-Id: <1411076592-6157-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 2.1.0.61.ge50deb1
In-Reply-To: <1411076592-6157-1-git-send-email-sboyd@codeaurora.org>
References: <1411076592-6157-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stepan Moskovchenko <stepanm@codeaurora.org>

Certain ARM CPU implementations (e.g. Cortex-A15) may not raise a
floating- point exception whenever deprecated short-vector VFP
instructions are executed. Instead these instructions are treated
as UNALLOCATED. Change the VFP exception handling code to emulate
short-vector instructions even if FPEXC exception bits are not
set.

Tested-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/vfp/vfphw.S | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/vfp/vfphw.S b/arch/arm/vfp/vfphw.S
index be807625ed8c..c041579a8d82 100644
--- a/arch/arm/vfp/vfphw.S
+++ b/arch/arm/vfp/vfphw.S
@@ -197,6 +197,12 @@ look_for_VFP_exceptions:
 	tst	r5, #FPSCR_IXE
 	bne	process_exception
 
+	tst	r5, #FPSCR_LENGTH_MASK
+	beq	skip
+	orr	r1, r1, #FPEXC_DEX
+	b process_exception
+skip:
+
 	@ Fall into hand on to next handler - appropriate coproc instr
 	@ not recognised by VFP
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

