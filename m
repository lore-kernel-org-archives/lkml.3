Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832Ab3LWQVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 11:21:41 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:48630 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757639Ab3LWQTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 11:19:55 -0500
From: Taras Kondratiuk <taras.kondratiuk@linaro.org>
To: Jon Medhurst <tixy@linaro.org>, Russell King <linux@arm.linux.org.uk>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        linux-arm-kernel@lists.infradead.org
Cc: patches@linaro.org, linaro-networking@linaro.org,
        linaro-kernel@lists.linaro.org,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] ARM: kprobes-test: use <asm/opcodes.h> for instruction accesses
Date: Mon, 23 Dec 2013 18:19:36 +0200
Message-Id: <1387815579-15677-3-git-send-email-taras.kondratiuk@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387815579-15677-1-git-send-email-taras.kondratiuk@linaro.org>
References: <1387815579-15677-1-git-send-email-taras.kondratiuk@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Dooks <ben.dooks@codethink.co.uk>

Ensure we read instructions in the correct endian-ness by using
the <asm/opcodes.h> helper to transform them as necessary.

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
[taras.kondratiuk@linaro.org: fix next_instruction() function]
Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
---
 arch/arm/kernel/kprobes-test.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/kernel/kprobes-test.c b/arch/arm/kernel/kprobes-test.c
index 0cd63d0..96e3dbc 100644
--- a/arch/arm/kernel/kprobes-test.c
+++ b/arch/arm/kernel/kprobes-test.c
@@ -1329,7 +1329,8 @@ static void test_case_failed(const char *message)
 static unsigned long next_instruction(unsigned long pc)
 {
 #ifdef CONFIG_THUMB2_KERNEL
-	if ((pc & 1) && !is_wide_instruction(*(u16 *)(pc - 1)))
+	if ((pc & 1) &&
+	    !is_wide_instruction(__mem_to_opcode_thumb16(*(u16 *)(pc - 1))))
 		return pc + 2;
 	else
 #endif
@@ -1374,13 +1375,13 @@ static uintptr_t __used kprobes_test_case_start(const char *title, void *stack)
 
 	if (test_case_is_thumb) {
 		u16 *p = (u16 *)(test_code & ~1);
-		current_instruction = p[0];
+		current_instruction = __mem_to_opcode_thumb16(p[0]);
 		if (is_wide_instruction(current_instruction)) {
-			current_instruction <<= 16;
-			current_instruction |= p[1];
+			u16 instr2 = __mem_to_opcode_thumb16(p[1]);
+			current_instruction = __opcode_thumb32_compose(current_instruction, instr2);
 		}
 	} else {
-		current_instruction = *(u32 *)test_code;
+		current_instruction = __mem_to_opcode_arm(*(u32 *)test_code);
 	}
 
 	if (current_title[0] == '.')
@@ -1593,7 +1594,6 @@ static int run_test_cases(void (*tests)(void), const union decode_item *table)
 	return 0;
 }
 
-
 static int __init run_all_tests(void)
 {
 	int ret = 0;
-- 
1.7.9.5

