Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbaJTVzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 17:55:09 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:53759 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbaJTVzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 17:55:07 -0400
From: Alexei Starovoitov <ast@plumgrid.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Daniel Borkmann <dborkman@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] bpf: fix bug in eBPF verifier
Date: Mon, 20 Oct 2014 14:54:57 -0700
Message-Id: <1413842097-4380-1-git-send-email-ast@plumgrid.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

while comparing for verifier state equivalency the comparison
was missing a check for uninitialized register.
Make sure it does so and add a testcase.

Fixes: f1bca824dabb ("bpf: add search pruning optimization to verifier")
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
---

while we were staring at the verifier code with Hannes during LPC
something felt odd in this spot. Yes. It was a bug. Fix it.

 kernel/bpf/verifier.c       |    3 ++-
 samples/bpf/test_verifier.c |   11 +++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 801f5f3..9f81818 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1409,7 +1409,8 @@ static bool states_equal(struct verifier_state *old, struct verifier_state *cur)
 		if (memcmp(&old->regs[i], &cur->regs[i],
 			   sizeof(old->regs[0])) != 0) {
 			if (old->regs[i].type == NOT_INIT ||
-			    old->regs[i].type == UNKNOWN_VALUE)
+			    (old->regs[i].type == UNKNOWN_VALUE &&
+			     cur->regs[i].type != NOT_INIT))
 				continue;
 			return false;
 		}
diff --git a/samples/bpf/test_verifier.c b/samples/bpf/test_verifier.c
index f44ef11..eb4bec0 100644
--- a/samples/bpf/test_verifier.c
+++ b/samples/bpf/test_verifier.c
@@ -209,6 +209,17 @@ static struct bpf_test tests[] = {
 		.result = REJECT,
 	},
 	{
+		"program doesn't init R0 before exit in all branches",
+		.insns = {
+			BPF_JMP_IMM(BPF_JGE, BPF_REG_1, 0, 2),
+			BPF_MOV64_IMM(BPF_REG_0, 1),
+			BPF_ALU64_IMM(BPF_ADD, BPF_REG_0, 2),
+			BPF_EXIT_INSN(),
+		},
+		.errstr = "R0 !read_ok",
+		.result = REJECT,
+	},
+	{
 		"stack out of bounds",
 		.insns = {
 			BPF_ST_MEM(BPF_DW, BPF_REG_10, 8, 0),
-- 
1.7.9.5

