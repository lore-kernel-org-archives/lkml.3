Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbbAGLur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 06:50:47 -0500
Received: from smarthost01a.mail.zen.net.uk ([212.23.1.1]:48707 "EHLO
	smarthost01a.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751625AbbAGLuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 06:50:46 -0500
Message-ID: <1420631436.4044.26.camel@linaro.org>
Subject: Re: [PATCH v19 02/11] ARM: kprobes: remove unused ARM decoder
 actions.
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Wang Nan <wangnan0@huawei.com>, David Long <dave.long@linaro.org>
Cc: masami.hiramatsu.pt@hitachi.com, linux@arm.linux.org.uk,
        lizefan@huawei.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Wed, 07 Jan 2015 11:50:36 +0000
In-Reply-To: <1420457354-77099-1-git-send-email-wangnan0@huawei.com>
References: <1420457284-76923-1-git-send-email-wangnan0@huawei.com>
	 <1420457354-77099-1-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01a-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-05 at 19:29 +0800, Wang Nan wrote:
> There are 3 actions which is never used:
> 
>  PROBES_MOV_HALFWORD,
>  PROBES_SEV,
>  PROBES_WFE,
> 
> This patch removes them.
> 
> Signed-off-by: Wang Nan <wangnan0@huawei.com>

I think that PROBES_MOV_HALFWORD should be used, for MOVW and MOVT.
Currently those instructions use PROBES_DATA_PROCESSING_IMM which,
whilst it will work it ends up using a less efficient emulation routine
than necessary.

The other unused actions, PROBES_SEV and PROBES_WFE, could possibly be
removed as redundant, but there are are Thumb equivalents for those
which are used, so for symmetry I think we should use them. That will
let us remove PROBES_EMULATE_NONE and PROBES_SIMULATE_NOP.

So how about the following patch instead...

----------------------------------------------------------------------------

From: Jon Medhurst <tixy@linaro.org>
Date: Wed, 7 Jan 2015 11:42:30 +0000
Subject: [PATCH] ARM: probes: Use correct action types for MOVW, SEV and WFI

This doesn't correct any bugs when probing these instructions but makes
MOVW slightly faster and makes everything more symmetric with the Thumb
instruction cases.

We can also remove the now redundant PROBES_EMULATE_NONE and
PROBES_SIMULATE_NOP actions.

Signed-off-by: Jon Medhurst <tixy@linaro.org>
---
 arch/arm/probes/decode-arm.c          | 6 +++---
 arch/arm/probes/decode-arm.h          | 2 --
 arch/arm/probes/kprobes/actions-arm.c | 2 --
 arch/arm/probes/uprobes/actions-arm.c | 2 --
 4 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/arch/arm/probes/decode-arm.c b/arch/arm/probes/decode-arm.c
index f46d8fc..f72c33a 100644
--- a/arch/arm/probes/decode-arm.c
+++ b/arch/arm/probes/decode-arm.c
@@ -370,17 +370,17 @@ static const union decode_item arm_cccc_001x_table[] = {
 
 	/* MOVW			cccc 0011 0000 xxxx xxxx xxxx xxxx xxxx */
 	/* MOVT			cccc 0011 0100 xxxx xxxx xxxx xxxx xxxx */
-	DECODE_EMULATEX	(0x0fb00000, 0x03000000, PROBES_DATA_PROCESSING_IMM,
+	DECODE_EMULATEX	(0x0fb00000, 0x03000000, PROBES_MOV_HALFWORD,
 						 REGS(0, NOPC, 0, 0, 0)),
 
 	/* YIELD		cccc 0011 0010 0000 xxxx xxxx 0000 0001 */
 	DECODE_OR	(0x0fff00ff, 0x03200001),
 	/* SEV			cccc 0011 0010 0000 xxxx xxxx 0000 0100 */
-	DECODE_EMULATE	(0x0fff00ff, 0x03200004, PROBES_EMULATE_NONE),
+	DECODE_EMULATE	(0x0fff00ff, 0x03200004, PROBES_SEV),
 	/* NOP			cccc 0011 0010 0000 xxxx xxxx 0000 0000 */
 	/* WFE			cccc 0011 0010 0000 xxxx xxxx 0000 0010 */
 	/* WFI			cccc 0011 0010 0000 xxxx xxxx 0000 0011 */
-	DECODE_SIMULATE	(0x0fff00fc, 0x03200000, PROBES_SIMULATE_NOP),
+	DECODE_SIMULATE	(0x0fff00fc, 0x03200000, PROBES_WFE),
 	/* DBG			cccc 0011 0010 0000 xxxx xxxx ffff xxxx */
 	/* unallocated hints	cccc 0011 0010 0000 xxxx xxxx xxxx xxxx */
 	/* MSR (immediate)	cccc 0011 0x10 xxxx xxxx xxxx xxxx xxxx */
diff --git a/arch/arm/probes/decode-arm.h b/arch/arm/probes/decode-arm.h
index a7b0398..b3b80f6 100644
--- a/arch/arm/probes/decode-arm.h
+++ b/arch/arm/probes/decode-arm.h
@@ -18,8 +18,6 @@
 #include "decode.h"
 
 enum probes_arm_action {
-	PROBES_EMULATE_NONE,
-	PROBES_SIMULATE_NOP,
 	PROBES_PRELOAD_IMM,
 	PROBES_PRELOAD_REG,
 	PROBES_BRANCH_IMM,
diff --git a/arch/arm/probes/kprobes/actions-arm.c b/arch/arm/probes/kprobes/actions-arm.c
index 1e67839..06988ef 100644
--- a/arch/arm/probes/kprobes/actions-arm.c
+++ b/arch/arm/probes/kprobes/actions-arm.c
@@ -303,8 +303,6 @@ emulate_rdlo12rdhi16rn0rm8_rwflags_nopc(probes_opcode_t insn,
 }
 
 const union decode_action kprobes_arm_actions[NUM_PROBES_ARM_ACTIONS] = {
-	[PROBES_EMULATE_NONE] = {.handler = probes_emulate_none},
-	[PROBES_SIMULATE_NOP] = {.handler = probes_simulate_nop},
 	[PROBES_PRELOAD_IMM] = {.handler = probes_simulate_nop},
 	[PROBES_PRELOAD_REG] = {.handler = probes_simulate_nop},
 	[PROBES_BRANCH_IMM] = {.handler = simulate_blx1},
diff --git a/arch/arm/probes/uprobes/actions-arm.c b/arch/arm/probes/uprobes/actions-arm.c
index 1dd4916..76eb449 100644
--- a/arch/arm/probes/uprobes/actions-arm.c
+++ b/arch/arm/probes/uprobes/actions-arm.c
@@ -195,8 +195,6 @@ uprobe_decode_ldmstm(probes_opcode_t insn,
 }
 
 const union decode_action uprobes_probes_actions[] = {
-	[PROBES_EMULATE_NONE] = {.handler = probes_simulate_nop},
-	[PROBES_SIMULATE_NOP] = {.handler = probes_simulate_nop},
 	[PROBES_PRELOAD_IMM] = {.handler = probes_simulate_nop},
 	[PROBES_PRELOAD_REG] = {.handler = probes_simulate_nop},
 	[PROBES_BRANCH_IMM] = {.handler = simulate_blx1},
-- 
2.1.4



