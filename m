Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789AbaAJR7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 12:59:47 -0500
Received: from mail-ee0-f44.google.com ([74.125.83.44]:34696 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbaAJR6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 12:58:42 -0500
From: Taras Kondratiuk <taras.kondratiuk@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Jon Medhurst <tixy@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Cc: patches@linaro.org, linaro-networking@linaro.org,
        linaro-kernel@lists.linaro.org,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/5] ARM: kprobes-test: use <asm/opcodes.h> for instruction accesses
Date: Fri, 10 Jan 2014 19:58:23 +0200
Message-Id: <1389376706-30051-3-git-send-email-taras.kondratiuk@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389376706-30051-1-git-send-email-taras.kondratiuk@linaro.org>
References: <1389376706-30051-1-git-send-email-taras.kondratiuk@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Dooks <ben.dooks@codethink.co.uk>

Ensure we read instructions in the correct endian-ness by using
the <asm/opcodes.h> helper to transform them as necessary.

Acked-by: Jon Medhurst <tixy@linaro.org>
Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
[taras.kondratiuk@linaro.org: fix next_instruction() function]
Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
---
 arch/arm/kernel/kprobes-test.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kernel/kprobes-test.c b/arch/arm/kernel/kprobes-test.c
index 0cd63d0..0850c72 100644
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
-- 
1.7.9.5

