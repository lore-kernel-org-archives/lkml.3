Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345AbaJVLfs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 07:35:48 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:25507 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932934AbaJVLeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 07:34:05 -0400
From: Wang Nan <wangnan0@huawei.com>
To: <tixy@linaro.org>, <masami.hiramatsu.pt@hitachi.com>,
        <linux@arm.linux.org.uk>, <will.deacon@arm.com>,
        <dave.long@linaro.org>, <taras.kondratiuk@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Christoph Lameter <cl@linux.com>, Rabin Vincent <rabin@rab.in>,
        "David S. Miller" <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        "Li Zefan" <lizefan@huawei.com>
Subject: [PATCH v6 3/7] ARM: kprobes: introduces checker
Date: Wed, 22 Oct 2014 19:32:01 +0800
Message-ID: <1413977525-51480-4-git-send-email-wangnan0@huawei.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1413977525-51480-1-git-send-email-wangnan0@huawei.com>
References: <1413977525-51480-1-git-send-email-wangnan0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.107.197.247]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introdces a 'checker' field to decode_action, and calls
checkers when instruction decoding. This allows further analysis
for specific instructions.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
---
 arch/arm/kernel/probes.c | 10 ++++++++++
 arch/arm/kernel/probes.h | 10 ++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/probes.c b/arch/arm/kernel/probes.c
index ec030b8..6164b4d 100644
--- a/arch/arm/kernel/probes.c
+++ b/arch/arm/kernel/probes.c
@@ -393,6 +393,7 @@ probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
 	const struct decode_header *h = (struct decode_header *)table;
 	const struct decode_header *next;
 	bool matched = false;
+	probes_opcode_t origin_insn = insn;
 
 	if (emulate)
 		insn = prepare_emulated_insn(insn, asi, thumb);
@@ -423,17 +424,26 @@ probes_decode_insn(probes_opcode_t insn, struct arch_probes_insn *asi,
 
 		case DECODE_TYPE_CUSTOM: {
 			struct decode_custom *d = (struct decode_custom *)h;
+			probes_check_t *checker = actions[d->decoder.action].checker;
+			if (checker && (checker(origin_insn, asi, h) == INSN_REJECTED))
+				return INSN_REJECTED;
 			return actions[d->decoder.action].decoder(insn, asi, h);
 		}
 
 		case DECODE_TYPE_SIMULATE: {
 			struct decode_simulate *d = (struct decode_simulate *)h;
+			probes_check_t *checker = actions[d->handler.action].checker;
+			if (checker && (checker(origin_insn, asi, h) == INSN_REJECTED))
+				return INSN_REJECTED;
 			asi->insn_handler = actions[d->handler.action].handler;
 			return INSN_GOOD_NO_SLOT;
 		}
 
 		case DECODE_TYPE_EMULATE: {
 			struct decode_emulate *d = (struct decode_emulate *)h;
+			probes_check_t *checker = actions[d->handler.action].checker;
+			if (checker && (checker(origin_insn, asi, h) == INSN_REJECTED))
+				return INSN_REJECTED;
 
 			if (!emulate)
 				return actions[d->handler.action].decoder(insn,
diff --git a/arch/arm/kernel/probes.h b/arch/arm/kernel/probes.h
index 739c2a2..c56dd3d 100644
--- a/arch/arm/kernel/probes.h
+++ b/arch/arm/kernel/probes.h
@@ -309,9 +309,15 @@ typedef enum probes_insn (probes_custom_decode_t)(probes_opcode_t,
 						  struct arch_probes_insn *,
 						  const struct decode_header *);
 
+typedef enum probes_insn (probes_check_t)(probes_opcode_t,
+					   struct arch_probes_insn *,
+					   const struct decode_header *);
 struct decode_action {
-	probes_insn_handler_t	*handler;
-	probes_custom_decode_t	*decoder;
+	probes_check_t *checker;
+	union {
+		probes_insn_handler_t	*handler;
+		probes_custom_decode_t	*decoder;
+	};
 };
 
 #define DECODE_END			\
-- 
1.8.4

