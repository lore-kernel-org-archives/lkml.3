Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab3CMBcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 21:32:10 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:15463 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864Ab3CMBcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 21:32:05 -0400
X-IronPort-AV: E=Sophos;i="4.84,833,1355126400"; 
   d="scan'208";a="29184078"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: [PATCH 3/3] ARM: Work around faulty ISAR0 register in some Krait CPUs
Date: Tue, 12 Mar 2013 18:32:01 -0700
Message-Id: <1363138321-27849-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2.rc2.4.g7799588
In-Reply-To: <1363138321-27849-1-git-send-email-sboyd@codeaurora.org>
References: <1363138321-27849-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some early versions of the Krait CPU design incorrectly indicate
that they only support the UDIV and SDIV instructions in Thumb
mode when they actually support them in ARM and Thumb mode. It
seems that these CPUs follow the DDI0406B ARM ARM which has two
possible values for the divide instructions field, instead of the
DDI0406C document which has three possible values.

Work around this problem by checking the MIDR against Krait CPUs
with this faulty ISAR0 register and force the detection code
to indicate support in both modes.

Cc: Will Deacon <will.deacon@arm.com>
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/kernel/setup.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index bd27a70..34ec24e 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -362,6 +362,14 @@ static void __init idiv_setup(void)
 
 	divide_instrs = (read_cpuid_ext(CPUID_EXT_ISAR0) & 0x0f000000) >> 24;
 
+	/*
+	 * Some Krait processors don't indicate support for SDIV and UDIV
+	 * instructions in the ARM instruction set, even though they actually
+	 * do support them.
+	 */
+	if ((read_cpuid_id() & 0xff0ffc00) == 0x510f0400)
+		divide_instrs = 2;
+
 	switch (divide_instrs) {
 	case 2:
 		elf_hwcap |= HWCAP_IDIVA;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

