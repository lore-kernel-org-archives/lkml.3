Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933360AbaGQOW4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 10:22:56 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:50780 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932405AbaGQOWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 10:22:55 -0400
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-mips@linux-mips.org
Cc: dborkman@redhat.com, markos.chandras@imgtec.com, ralf@linux-mips.org,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>
Subject: [PATCH] arch/mips/net/bpf_jit.c: fix failure check
Date: Thu, 17 Jul 2014 17:22:38 +0300
Message-Id: <1405606958-14383-1-git-send-email-andrey.krieger.utkin@gmail.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1405603655-12571-1-git-send-email-andrey.krieger.utkin@gmail.com>
References: <1405603655-12571-1-git-send-email-andrey.krieger.utkin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

static int pkt_type_offset(void) returned -1 in case of failure, and actual
(positive) offset value in case of success. In the only instance of its usage,
the result was saved to local "unsigned int off" variable, which is used in a
lot of places in the same (large) function, so changing its type could cause
many warnings. So new signed int variable was added.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=80371
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
---
 arch/mips/net/bpf_jit.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/mips/net/bpf_jit.c b/arch/mips/net/bpf_jit.c
index b87390a..918b341 100644
--- a/arch/mips/net/bpf_jit.c
+++ b/arch/mips/net/bpf_jit.c
@@ -793,6 +793,7 @@ static int build_body(struct jit_ctx *ctx)
 	const struct sock_filter *inst;
 	unsigned int i, off, load_order, condt;
 	u32 k, b_off __maybe_unused;
+	int tmp;
 
 	for (i = 0; i < prog->len; i++) {
 		u16 code;
@@ -1332,9 +1333,9 @@ jmp_cmp:
 		case BPF_ANC | SKF_AD_PKTTYPE:
 			ctx->flags |= SEEN_SKB;
 
-			off = pkt_type_offset();
+			tmp = off = pkt_type_offset();
 
-			if (off < 0)
+			if (tmp < 0)
 				return -1;
 			emit_load_byte(r_tmp, r_skb, off, ctx);
 			/* Keep only the last 3 bits */
-- 
1.8.5.5

