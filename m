Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288AbaFJKuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 06:50:20 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:51938 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaFJKuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 06:50:16 -0400
Subject: [PATCH ftrace/core 1/2] ftrace: Simplify ftrace_hash_disable/enable
 path in ftrace_hash_move
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Steven Rostedt <rostedt@goodmis.org>, Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Date: Tue, 10 Jun 2014 10:50:08 +0000
Message-ID: <20140610105008.8732.5359.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20140610105001.8732.93502.stgit@kbuild-fedora.novalocal>
References: <20140610105001.8732.93502.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify ftrace_hash_disable/enable path in ftrace_hash_move
for hardening the process if the memory allocation failed.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
---
 kernel/trace/ftrace.c |   33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index cc07b7f..e355b60 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1304,25 +1304,15 @@ ftrace_hash_move(struct ftrace_ops *ops, int enable,
 	struct ftrace_hash *new_hash;
 	int size = src->count;
 	int bits = 0;
-	int ret;
 	int i;
 
 	/*
-	 * Remove the current set, update the hash and add
-	 * them back.
-	 */
-	ftrace_hash_rec_disable(ops, enable);
-
-	/*
 	 * If the new source is empty, just free dst and assign it
 	 * the empty_hash.
 	 */
 	if (!src->count) {
-		free_ftrace_hash_rcu(*dst);
-		rcu_assign_pointer(*dst, EMPTY_HASH);
-		/* still need to update the function records */
-		ret = 0;
-		goto out;
+		new_hash = EMPTY_HASH;
+		goto update;
 	}
 
 	/*
@@ -1335,10 +1325,9 @@ ftrace_hash_move(struct ftrace_ops *ops, int enable,
 	if (bits > FTRACE_HASH_MAX_BITS)
 		bits = FTRACE_HASH_MAX_BITS;
 
-	ret = -ENOMEM;
 	new_hash = alloc_ftrace_hash(bits);
 	if (!new_hash)
-		goto out;
+		return -ENOMEM;
 
 	size = 1 << src->size_bits;
 	for (i = 0; i < size; i++) {
@@ -1349,20 +1338,20 @@ ftrace_hash_move(struct ftrace_ops *ops, int enable,
 		}
 	}
 
+update:
+	/*
+	 * Remove the current set, update the hash and add
+	 * them back.
+	 */
+	ftrace_hash_rec_disable(ops, enable);
+
 	old_hash = *dst;
 	rcu_assign_pointer(*dst, new_hash);
 	free_ftrace_hash_rcu(old_hash);
 
-	ret = 0;
- out:
-	/*
-	 * Enable regardless of ret:
-	 *  On success, we enable the new hash.
-	 *  On failure, we re-enable the original hash.
-	 */
 	ftrace_hash_rec_enable(ops, enable);
 
-	return ret;
+	return 0;
 }
 
 /*


