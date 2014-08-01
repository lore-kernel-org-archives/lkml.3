Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbaHAInJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 04:43:09 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:59546 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaHAInG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 04:43:06 -0400
Subject: [PATCH -tip ] [BUGFIX] kprobes: Skip kretprobe hit in NMI context
 to avoid deadlock
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Fri, 01 Aug 2014 08:42:54 +0000
Message-ID: <20140801084254.12330.64728.stgit@kbuild-fedora.novalocal>
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

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
---
 kernel/kprobes.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 734e9a7..a537029 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1778,6 +1778,12 @@ static int pre_handler_kretprobe(struct kprobe *p, struct pt_regs *regs)
 	unsigned long hash, flags = 0;
 	struct kretprobe_instance *ri;
 
+	/* To avoid deadlock, prohibit return probing in NMI context */
+	if (in_nmi()) {
+		rp->nmissed++;
+		return 0;
+	}
+
 	/*TODO: consider to only swap the RA after the last pre_handler fired */
 	hash = hash_ptr(current, KPROBE_HASH_BITS);
 	raw_spin_lock_irqsave(&rp->lock, flags);


