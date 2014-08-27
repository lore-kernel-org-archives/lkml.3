Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605AbaH0FU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 01:20:26 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:32097 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaH0FUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 01:20:25 -0400
From: Wang Nan <wangnan0@huawei.com>
To: "David A. Long" <dave.long@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Jon Medhurst <tixy@linaro.org>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>
CC: Wang Nan <wangnan0@huawei.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <peifeiyue@huawei.com>
Subject: [PATCH] ARM: probes: return directly when emulate not set
Date: Wed, 27 Aug 2014 13:08:29 +0800
Message-ID: <1409116109-67330-1-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When kprobe decoding instruction, original code calls instruction
specific decoder if emulate is set to false.  However, instructions with
DECODE_TYPE_EMULATE are in fact don't have their decoder. What in the
action table are in fact handlers.  For example:

	/* LDRD (immediate)	cccc 000x x1x0 xxxx xxxx xxxx 1101 xxxx */
	/* STRD (immediate)	cccc 000x x1x0 xxxx xxxx xxxx 1111 xxxx */
	DECODE_EMULATEX	(0x0e5000d0, 0x004000d0, PROBES_LDRSTRD,
						 REGS(NOPCWB, NOPCX, 0, 0, 0)),

	and

const union decode_action kprobes_arm_actions[NUM_PROBES_ARM_ACTIONS] = {
	...
	[PROBES_LDRSTRD] = {.handler = emulate_ldrdstrd},
	...

In this situation, original code calls 'emulate_ldrdstrd' as a decoder,
which is obviously incorrect.

This patch makes it returns INSN_GOOD directly when 'emulate' is not
true.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
Cc: "David A. Long" <dave.long@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jon Medhurst <tixy@linaro.org>
Cc: Taras Kondratiuk <taras.kondratiuk@linaro.org>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>
---
 arch/arm/kernel/probes.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/kernel/probes.c b/arch/arm/kernel/probes.c
index a8ab540..1c77b8d 100644
--- a/arch/arm/kernel/probes.c
+++ b/arch/arm/kernel/probes.c
@@ -436,8 +436,7 @@ probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
 			struct decode_emulate *d = (struct decode_emulate *)h;
 
 			if (!emulate)
-				return actions[d->handler.action].decoder(insn,
-					asi, h);
+				return INSN_GOOD;
 
 			asi->insn_handler = actions[d->handler.action].handler;
 			set_emulated_insn(insn, asi, thumb);
-- 
1.8.4

