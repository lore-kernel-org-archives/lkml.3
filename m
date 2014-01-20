Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbaATSUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 13:20:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021AbaATSUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 13:20:22 -0500
Date: Mon, 20 Jan 2014 19:20:13 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] lockdep: change mark_held_locks() to check
	hlock->check instead of lockdep_no_validate
Message-ID: <20140120182013.GA26505@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140120181942.GA20783@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __lockdep_no_validate check in mark_held_locks() adds the subtle
and (afaics) unnecessary difference between no-validate and check==0.
And this looks even more inconsistent because __lock_acquire() skips
mark_irqflags()->mark_lock() if !check.

Change mark_held_locks() to check hlock->check instead.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/locking/lockdep.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 543e120..28e41c0 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -2515,7 +2515,7 @@ mark_held_locks(struct task_struct *curr, enum mark_type mark)
 
 		BUG_ON(usage_bit >= LOCK_USAGE_STATES);
 
-		if (hlock_class(hlock)->key == __lockdep_no_validate__.subkeys)
+		if (!hlock->check)
 			continue;
 
 		if (!mark_lock(curr, hlock, usage_bit))
-- 
1.5.5.1

