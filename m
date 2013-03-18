Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab3CRS3r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 14:29:47 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38770 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab3CRS3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 14:29:01 -0400
X-IronPort-AV: E=Sophos;i="4.84,865,1355126400"; 
   d="scan'208";a="30630027"
From: Stephen Boyd <sboyd@codeaurora.org>
To: linux-arm-kernel@lists.infradead.org
Cc: Stepan Moskovchenko <stepanm@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Will Deacon <will.deacon@arm.com>
Subject: [PATCHv2 3/3] ARM: Work around faulty ISAR0 register in some Krait CPUs
Date: Mon, 18 Mar 2013 11:28:57 -0700
Message-Id: <1363631337-13816-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.2.rc2.4.g7799588
In-Reply-To: <1363631337-13816-1-git-send-email-sboyd@codeaurora.org>
References: <1363631337-13816-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stepan Moskovchenko <stepanm@codeaurora.org>

Some early versions of the Krait CPU design incorrectly indicate
that they only support the UDIV and SDIV instructions in Thumb
mode when they actually support them in ARM and Thumb mode. It
seems that these CPUs follow the DDI0406B ARM ARM which has two
possible values for the divide instructions field, instead of the
DDI0406C document which has three possible values.

Work around this problem by checking the MIDR against Krait CPUs
with this faulty ISAR0 register and force the hwcaps to indicate
support in both modes.

Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
[sboyd: Rewrote commit text to reflect real reasoning now that
	we autodetect udiv/sdiv]
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/mm/proc-v7.S | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm/mm/proc-v7.S b/arch/arm/mm/proc-v7.S
index bcd3d48..f584d3f 100644
--- a/arch/arm/mm/proc-v7.S
+++ b/arch/arm/mm/proc-v7.S
@@ -434,6 +434,21 @@ __v7_ca15mp_proc_info:
 	.size	__v7_ca15mp_proc_info, . - __v7_ca15mp_proc_info
 
 	/*
+	 * Qualcomm Inc. Krait processors.
+	 */
+	.type	__krait_proc_info, #object
+__krait_proc_info:
+	.long	0x510f0400		@ Required ID value
+	.long	0xff0ffc00		@ Mask for ID
+	/*
+	 * Some Krait processors don't indicate support for SDIV and UDIV
+	 * instructions in the ARM instruction set, even though they actually
+	 * do support them.
+	 */
+	__v7_proc __v7_setup, hwcaps = HWCAP_IDIV
+	.size	__krait_proc_info, . - __krait_proc_info
+
+	/*
 	 * Match any ARMv7 processor core.
 	 */
 	.type	__v7_proc_info, #object
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

