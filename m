Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbaHHJUA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 05:20:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45084 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbaHHJT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 05:19:57 -0400
Date: Fri, 8 Aug 2014 02:19:37 -0700
From: tip-bot for Masami Hiramatsu <tipbot@zytor.com>
Message-ID: <tip-f96f56780ca584930bb3a2769d73fd9a101bcbbe@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com, hpa@zytor.com,
        mingo@kernel.org, masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
        davem@davemloft.net
Reply-To: mingo@kernel.org, hpa@zytor.com, ananth@in.ibm.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        tglx@linutronix.de, davem@davemloft.net
In-Reply-To: <20140804031016.11433.65539.stgit@kbuild-fedora.novalocal>
References: <20140804031016.11433.65539.stgit@kbuild-fedora.novalocal>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] kprobes:
  Skip kretprobe hit in NMI context to avoid deadlock
Git-Commit-ID: f96f56780ca584930bb3a2769d73fd9a101bcbbe
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f96f56780ca584930bb3a2769d73fd9a101bcbbe
Gitweb:     http://git.kernel.org/tip/f96f56780ca584930bb3a2769d73fd9a101bcbbe
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Mon, 4 Aug 2014 03:10:16 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 8 Aug 2014 10:38:04 +0200

kprobes: Skip kretprobe hit in NMI context to avoid deadlock

Skip kretprobe hit in NMI context, because if an NMI happens
inside the critical section protected by kretprobe_table.lock
and another(or same) kretprobe hit, pre_kretprobe_handler
tries to lock kretprobe_table.lock again.
Normal interrupts have no problem because they are disabled
with the lock.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Link: http://lkml.kernel.org/r/20140804031016.11433.65539.stgit@kbuild-fedora.novalocal
[ Minor edits for clarity. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/kprobes.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 734e9a7..3995f54 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1778,7 +1778,18 @@ static int pre_handler_kretprobe(struct kprobe *p, struct pt_regs *regs)
 	unsigned long hash, flags = 0;
 	struct kretprobe_instance *ri;
 
-	/*TODO: consider to only swap the RA after the last pre_handler fired */
+	/*
+	 * To avoid deadlocks, prohibit return probing in NMI contexts,
+	 * just skip the probe and increase the (inexact) 'nmissed'
+	 * statistical counter, so that the user is informed that
+	 * something happened:
+	 */
+	if (unlikely(in_nmi())) {
+		rp->nmissed++;
+		return 0;
+	}
+
+	/* TODO: consider to only swap the RA after the last pre_handler fired */
 	hash = hash_ptr(current, KPROBE_HASH_BITS);
 	raw_spin_lock_irqsave(&rp->lock, flags);
 	if (!hlist_empty(&rp->free_instances)) {
