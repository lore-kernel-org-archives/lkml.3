Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704AbaHDDKb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 23:10:31 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:56986 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbaHDDKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 23:10:30 -0400
Subject: [PATCH -tip v2] [BUGFIX] kprobes: Skip kretprobe hit in NMI context
 to avoid deadlock
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Date: Mon, 04 Aug 2014 03:10:16 +0000
Message-ID: <20140804031016.11433.65539.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Skip kretprobe hit in NMI context, because if an NMI happens
inside the critical section protected by kretprobe_table.lock
and another(or same) kretprobe hit, pre_kretprobe_handler
tries to lock kretprobe_table.lock again.
Normal interrupts have no problem because they are disabled
with the lock.

Changes in v2:
 - Add unlikely for in_nmi.
 - Add a comment for nmissed counter.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
---
 kernel/kprobes.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 734e9a7..138219b 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1778,6 +1778,16 @@ static int pre_handler_kretprobe(struct kprobe *p, struct pt_regs *regs)
 	unsigned long hash, flags = 0;
 	struct kretprobe_instance *ri;
 
+	/* To avoid deadlock, prohibit return probing in NMI context */
+	if (unlikely(in_nmi())) {
+		/*
+		 * Do not get a lock. nmissed is not accurate.
+		 * This just informs user some misses are happened.
+		 */
+		rp->nmissed++;
+		return 0;
+	}
+
 	/*TODO: consider to only swap the RA after the last pre_handler fired */
 	hash = hash_ptr(current, KPROBE_HASH_BITS);
 	raw_spin_lock_irqsave(&rp->lock, flags);


