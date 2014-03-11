Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755750AbaCKMly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:41:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35790 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711AbaCKMls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:41:48 -0400
Date: Tue, 11 Mar 2014 05:41:00 -0700
From: tip-bot for Jason Low <tipbot@zytor.com>
Message-ID: <tip-46af29e479cc0c1c63633007993af5292c2c3e75@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, jason.low2@hp.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, jason.low2@hp.com
In-Reply-To: <1390936396-3962-2-git-send-email-jason.low2@hp.com>
References: <1390936396-3962-2-git-send-email-jason.low2@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] locking/mutexes:
  Return false if task need_resched() in mutex_can_spin_on_owner()
Git-Commit-ID: 46af29e479cc0c1c63633007993af5292c2c3e75
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

Commit-ID:  46af29e479cc0c1c63633007993af5292c2c3e75
Gitweb:     http://git.kernel.org/tip/46af29e479cc0c1c63633007993af5292c2c3e75
Author:     Jason Low <jason.low2@hp.com>
AuthorDate: Tue, 28 Jan 2014 11:13:12 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 11 Mar 2014 12:14:52 +0100

locking/mutexes: Return false if task need_resched() in mutex_can_spin_on_owner()

The mutex_can_spin_on_owner() function should also return false if the
task needs to be rescheduled to avoid entering the MCS queue when it
needs to reschedule.

Signed-off-by: Jason Low <jason.low2@hp.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman.Long@hp.com
Cc: torvalds@linux-foundation.org
Cc: tglx@linutronix.de
Cc: riel@redhat.com
Cc: akpm@linux-foundation.org
Cc: davidlohr@hp.com
Cc: hpa@zytor.com
Cc: andi@firstfloor.org
Cc: aswin@hp.com
Cc: scott.norton@hp.com
Cc: chegu_vinod@hp.com
Cc: paulmck@linux.vnet.ibm.com
Link: http://lkml.kernel.org/r/1390936396-3962-2-git-send-email-jason.low2@hp.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/locking/mutex.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 4f408be..e6d646b 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -166,6 +166,9 @@ static inline int mutex_can_spin_on_owner(struct mutex *lock)
 	struct task_struct *owner;
 	int retval = 1;
 
+	if (need_resched())
+		return 0;
+
 	rcu_read_lock();
 	owner = ACCESS_ONCE(lock->owner);
 	if (owner)
