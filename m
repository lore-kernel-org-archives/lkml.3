Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab3IKF1x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:27:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab3IKE5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:25 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=ds2VJS_wCAEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=CxuqYWkBsZgA:10 a=drOt6m5kAAAA:8 a=VwQbUJbxAAAA:8 a=KKAkSRfTAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=WwgC8nHKvroA:10 a=jeBq3FmKZ4MA:10 a=DEUpVOoFkygzH1Qb:21 a=QP1dqoE7KauBsTHc:21 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042912.083565890@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [119/251] ARM: poison the vectors page
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0119-ARM-poison-the-vectors-page.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

[ Upstream commit f928d4f2a86f46b030fa0850385b4391fc2b5918 ]

Fill the empty regions of the vectors page with an exception generating
instruction.  This ensures that any inappropriate branch to the vector
page is appropriately trapped, rather than just encountering some code
to execute.  (The vectors page was filled with zero before, which
corresponds with the "andeq r0, r0, r0" instruction - a no-op.)

Cc: <stable@vger.kernel.org>
Acked-by Nicolas Pitre <nico@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/arm/kernel/traps.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index b0179b8..a4f84b0 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -824,10 +824,20 @@ void __init early_trap_init(void *vectors_base)
 	extern char __vectors_start[], __vectors_end[];
 	extern char __kuser_helper_start[], __kuser_helper_end[];
 	int kuser_sz = __kuser_helper_end - __kuser_helper_start;
+	unsigned i;
 
 	vectors_page = vectors_base;
 
 	/*
+	 * Poison the vectors page with an undefined instruction.  This
+	 * instruction is chosen to be undefined for both ARM and Thumb
+	 * ISAs.  The Thumb version is an undefined instruction with a
+	 * branch back to the undefined instruction.
+	 */
+	for (i = 0; i < PAGE_SIZE / sizeof(u32); i++)
+		((u32 *)vectors_base)[i] = 0xe7fddef1;
+
+	/*
 	 * Copy the vectors, stubs and kuser helpers (in entry-armv.S)
 	 * into the vector page, mapped at 0xffff0000, and ensure these
 	 * are visible to the instruction stream.
-- 
1.7.10.4


