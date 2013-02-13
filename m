Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933952Ab3BMMIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 07:08:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36553 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933784Ab3BMMIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 07:08:45 -0500
Date: Wed, 13 Feb 2013 04:07:24 -0800
From: tip-bot for Rik van Riel <riel@redhat.com>
Message-ID: <tip-4c13d231339a8dc7ca056476fa10d95369080c8c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, riel@redhat.com,
        aquini@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de,
        walken@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, riel@redhat.com,
        aquini@redhat.com, akpm@linux-foundation.org, tglx@linutronix.de,
        walken@google.com
In-Reply-To: <20130206150442.1ffd017c@cuia.bos.redhat.com>
References: <20130206150442.1ffd017c@cuia.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] x86/smp:
  Implement proportional backoff for ticket spinlocks
Git-Commit-ID: 4c13d231339a8dc7ca056476fa10d95369080c8c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 13 Feb 2013 04:07:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4c13d231339a8dc7ca056476fa10d95369080c8c
Gitweb:     http://git.kernel.org/tip/4c13d231339a8dc7ca056476fa10d95369080c8c
Author:     Rik van Riel <riel@redhat.com>
AuthorDate: Wed, 6 Feb 2013 15:04:42 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 13 Feb 2013 09:06:29 +0100

x86/smp: Implement proportional backoff for ticket spinlocks

Add simple fixed value proportional backoff for ticket spinlocks.

By pounding on the cacheline with the spin lock less often,
bus traffic is reduced. In cases of a data structure with
embedded spinlock, the lock holder has a better chance of
making progress.

If we are next in line behind the current holder of the
lock, we do a fast spin, so as not to waste any time when
the lock is released.

The number 50 is likely to be wrong for many setups, and
this patch is mostly to illustrate the concept of proportional
backup. The next patch automatically tunes the delay value.

Signed-off-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Michel Lespinasse <walken@google.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Cc: eric.dumazet@gmail.com
Cc: lwoodman@redhat.com
Cc: knoel@redhat.com
Cc: chegu_vinod@hp.com
Cc: raghavendra.kt@linux.vnet.ibm.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/20130206150442.1ffd017c@cuia.bos.redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/smp.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 20da354..aa743e9 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -117,11 +117,28 @@ static bool smp_no_nmi_ipi = false;
  */
 void ticket_spin_lock_wait(arch_spinlock_t *lock, struct __raw_tickets inc)
 {
+	__ticket_t head = inc.head, ticket = inc.tail;
+	__ticket_t waiters_ahead;
+	unsigned loops;
+
 	for (;;) {
-		cpu_relax();
-		inc.head = ACCESS_ONCE(lock->tickets.head);
+		waiters_ahead = ticket - head - 1;
+		/*
+		 * We are next after the current lock holder. Check often
+		 * to avoid wasting time when the lock is released.
+		 */
+		if (!waiters_ahead) {
+			do {
+				cpu_relax();
+			} while (ACCESS_ONCE(lock->tickets.head) != ticket);
+			break;
+		}
+		loops = 50 * waiters_ahead;
+		while (loops--)
+			cpu_relax();
 
-		if (inc.head == inc.tail)
+		head = ACCESS_ONCE(lock->tickets.head);
+		if (head == ticket)
 			break;
 	}
 }
