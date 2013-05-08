Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901Ab3EHVsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 17:48:00 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41836 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885Ab3EHVr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 17:47:58 -0400
X-IronPort-AV: E=Sophos;i="4.87,636,1363158000"; 
   d="scan'208";a="45526386"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Brian Swetland <swetland@google.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] ARM: avoid mis-detecting some V7 cores in the decompressor
Date: Wed,  8 May 2013 14:47:51 -0700
Message-Id: <1368049671-22879-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.8.3.rc1.25.g423ecb0.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brian Swetland <swetland@google.com>

Currently v7 CPUs with an MIDR that has no bits set in the range
[16:12] will be detected as old ARM CPUs with no caches and so
the cache will never be turned on during decompression. ARM's
Cortex chips have an 0xC in the range [16:12] so they never match
this entry, but Qualcomm's Scorpion and Krait processors never
set these bits to anything besides 0 so they always match.

Skip this entry if we've compiled in support for v7 CPUs. This
allows kernel decompression to happen nearly instantly instead of
taking over 20 seconds.

Signed-off-by: Brian Swetland <swetland@google.com>
[sboyd: Clarified and extended commit text]
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/boot/compressed/head.S | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index fe4d9c3..a236190 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -805,6 +805,8 @@ call_cache_fn:	adr	r12, proc_types
 		.align	2
 		.type	proc_types,#object
 proc_types:
+#if !defined(CONFIG_CPU_V7)
+		/* This collides with some V7 IDs, preventing correct detection */
 		.word	0x00000000		@ old ARM ID
 		.word	0x0000f000
 		mov	pc, lr
@@ -813,6 +815,7 @@ proc_types:
  THUMB(		nop				)
 		mov	pc, lr
  THUMB(		nop				)
+#endif
 
 		.word	0x41007000		@ ARM7/710
 		.word	0xfff8fe00
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

