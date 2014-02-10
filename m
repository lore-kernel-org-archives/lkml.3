Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbaBJNeM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:34:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33388 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbaBJNeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:34:00 -0500
Date: Mon, 10 Feb 2014 05:33:20 -0800
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-34d0ed5ea7a72d5961552fb1758a94f0d3f8f3dc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, stern@rowland.harvard.edu,
        torvalds@linux-foundation.org, peterz@infradead.org, davej@redhat.com,
        gregkh@linuxfoundation.org, paulmck@linux.vnet.ibm.com,
        rostedt@goodmis.org, tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, stern@rowland.harvard.edu,
        torvalds@linux-foundation.org, peterz@infradead.org, davej@redhat.com,
        paulmck@linux.vnet.ibm.com, gregkh@linuxfoundation.org,
        rostedt@goodmis.org, oleg@redhat.com, tglx@linutronix.de
In-Reply-To: <20140120182013.GA26505@redhat.com>
References: <20140120182013.GA26505@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockdep: Change mark_held_locks()
  to check hlock->check instead of lockdep_no_validate
Git-Commit-ID: 34d0ed5ea7a72d5961552fb1758a94f0d3f8f3dc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 10 Feb 2014 05:33:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  34d0ed5ea7a72d5961552fb1758a94f0d3f8f3dc
Gitweb:     http://git.kernel.org/tip/34d0ed5ea7a72d5961552fb1758a94f0d3f8f3dc
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Mon, 20 Jan 2014 19:20:13 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 9 Feb 2014 21:18:59 +0100

lockdep: Change mark_held_locks() to check hlock->check instead of lockdep_no_validate

The __lockdep_no_validate check in mark_held_locks() adds the subtle
and (afaics) unnecessary difference between no-validate and check==0.
And this looks even more inconsistent because __lock_acquire() skips
mark_irqflags()->mark_lock() if !check.

Change mark_held_locks() to check hlock->check instead.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140120182013.GA26505@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/locking/lockdep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index f7eba92..bf0c6b0 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -2517,7 +2517,7 @@ mark_held_locks(struct task_struct *curr, enum mark_type mark)
 
 		BUG_ON(usage_bit >= LOCK_USAGE_STATES);
 
-		if (hlock_class(hlock)->key == __lockdep_no_validate__.subkeys)
+		if (!hlock->check)
 			continue;
 
 		if (!mark_lock(curr, hlock, usage_bit))
