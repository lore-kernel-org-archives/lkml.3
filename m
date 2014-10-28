Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609AbaJ1WNU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:13:20 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:35558 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266AbaJ1WL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:11:59 -0400
From: Alexei Starovoitov <ast@plumgrid.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/3] samples: bpf: add a verifier test and summary line
Date: Tue, 28 Oct 2014 15:11:42 -0700
Message-Id: <1414534303-9906-3-git-send-email-ast@plumgrid.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414534303-9906-1-git-send-email-ast@plumgrid.com>
References: <1414534303-9906-1-git-send-email-ast@plumgrid.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- add a test specifically targeting verifier state pruning.
It checks state propagation between registers, storing that
state into stack and state pruning algorithm recognizing
equivalent stack and register states.

- add summary line to spot failures easier

Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
---
 samples/bpf/test_verifier.c |   46 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff --git a/samples/bpf/test_verifier.c b/samples/bpf/test_verifier.c
index eb4bec0ad8af..63402742345e 100644
--- a/samples/bpf/test_verifier.c
+++ b/samples/bpf/test_verifier.c
@@ -602,6 +602,45 @@ static struct bpf_test tests[] = {
 		},
 		.result = ACCEPT,
 	},
+	{
+		"jump test 5",
+		.insns = {
+			BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
+			BPF_MOV64_REG(BPF_REG_3, BPF_REG_2),
+			BPF_JMP_IMM(BPF_JGE, BPF_REG_1, 0, 2),
+			BPF_STX_MEM(BPF_DW, BPF_REG_2, BPF_REG_3, -8),
+			BPF_JMP_IMM(BPF_JA, 0, 0, 2),
+			BPF_STX_MEM(BPF_DW, BPF_REG_2, BPF_REG_2, -8),
+			BPF_JMP_IMM(BPF_JA, 0, 0, 0),
+			BPF_MOV64_IMM(BPF_REG_0, 0),
+			BPF_JMP_IMM(BPF_JGE, BPF_REG_1, 0, 2),
+			BPF_STX_MEM(BPF_DW, BPF_REG_2, BPF_REG_3, -8),
+			BPF_JMP_IMM(BPF_JA, 0, 0, 2),
+			BPF_STX_MEM(BPF_DW, BPF_REG_2, BPF_REG_2, -8),
+			BPF_JMP_IMM(BPF_JA, 0, 0, 0),
+			BPF_MOV64_IMM(BPF_REG_0, 0),
+			BPF_JMP_IMM(BPF_JGE, BPF_REG_1, 0, 2),
+			BPF_STX_MEM(BPF_DW, BPF_REG_2, BPF_REG_3, -8),
+			BPF_JMP_IMM(BPF_JA, 0, 0, 2),
+			BPF_STX_MEM(BPF_DW, BPF_REG_2, BPF_REG_2, -8),
+			BPF_JMP_IMM(BPF_JA, 0, 0, 0),
+			BPF_MOV64_IMM(BPF_REG_0, 0),
+			BPF_JMP_IMM(BPF_JGE, BPF_REG_1, 0, 2),
+			BPF_STX_MEM(BPF_DW, BPF_REG_2, BPF_REG_3, -8),
+			BPF_JMP_IMM(BPF_JA, 0, 0, 2),
+			BPF_STX_MEM(BPF_DW, BPF_REG_2, BPF_REG_2, -8),
+			BPF_JMP_IMM(BPF_JA, 0, 0, 0),
+			BPF_MOV64_IMM(BPF_REG_0, 0),
+			BPF_JMP_IMM(BPF_JGE, BPF_REG_1, 0, 2),
+			BPF_STX_MEM(BPF_DW, BPF_REG_2, BPF_REG_3, -8),
+			BPF_JMP_IMM(BPF_JA, 0, 0, 2),
+			BPF_STX_MEM(BPF_DW, BPF_REG_2, BPF_REG_2, -8),
+			BPF_JMP_IMM(BPF_JA, 0, 0, 0),
+			BPF_MOV64_IMM(BPF_REG_0, 0),
+			BPF_EXIT_INSN(),
+		},
+		.result = ACCEPT,
+	},
 };
 
 static int probe_filter_length(struct bpf_insn *fp)
@@ -630,7 +669,7 @@ static int create_map(void)
 
 static int test(void)
 {
-	int prog_fd, i;
+	int prog_fd, i, pass_cnt = 0, err_cnt = 0;
 
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		struct bpf_insn *prog = tests[i].insns;
@@ -657,21 +696,25 @@ static int test(void)
 				printf("FAIL\nfailed to load prog '%s'\n",
 				       strerror(errno));
 				printf("%s", bpf_log_buf);
+				err_cnt++;
 				goto fail;
 			}
 		} else {
 			if (prog_fd >= 0) {
 				printf("FAIL\nunexpected success to load\n");
 				printf("%s", bpf_log_buf);
+				err_cnt++;
 				goto fail;
 			}
 			if (strstr(bpf_log_buf, tests[i].errstr) == 0) {
 				printf("FAIL\nunexpected error message: %s",
 				       bpf_log_buf);
+				err_cnt++;
 				goto fail;
 			}
 		}
 
+		pass_cnt++;
 		printf("OK\n");
 fail:
 		if (map_fd >= 0)
@@ -679,6 +722,7 @@ fail:
 		close(prog_fd);
 
 	}
+	printf("Summary: %d PASSED, %d FAILED\n", pass_cnt, err_cnt);
 
 	return 0;
 }
-- 
1.7.9.5

