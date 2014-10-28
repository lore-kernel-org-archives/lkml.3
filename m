Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356AbaJ1LMf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:12:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51305 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008AbaJ1LMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:12:31 -0400
Date: Tue, 28 Oct 2014 04:11:40 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-26cabd31259ba43f68026ce3f62b78094124333f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        davem@davemloft.net, ilya.dryomov@inktank.com, peterz@infradead.org,
        tglx@linutronix.de, mingo@kernel.org, hpa@zytor.com
Reply-To: torvalds@linux-foundation.org, davem@davemloft.net,
        ilya.dryomov@inktank.com, peterz@infradead.org, mingo@kernel.org,
        tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
In-Reply-To: <20140924082242.524407432@infradead.org>
References: <20140924082242.524407432@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, net: Clean up sk_wait_event()
  vs. might_sleep()
Git-Commit-ID: 26cabd31259ba43f68026ce3f62b78094124333f
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

Commit-ID:  26cabd31259ba43f68026ce3f62b78094124333f
Gitweb:     http://git.kernel.org/tip/26cabd31259ba43f68026ce3f62b78094124333f
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 24 Sep 2014 10:18:54 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 28 Oct 2014 10:56:37 +0100

sched, net: Clean up sk_wait_event() vs. might_sleep()

WARNING: CPU: 1 PID: 1744 at kernel/sched/core.c:7104 __might_sleep+0x58/0x90()
do not call blocking ops when !TASK_RUNNING; state=1 set at [<ffffffff81070e10>] prepare_to_wait+0x50 /0xa0

 [<ffffffff8105bc38>] __might_sleep+0x58/0x90
 [<ffffffff8148c671>] lock_sock_nested+0x31/0xb0
 [<ffffffff81498aaa>] sk_stream_wait_memory+0x18a/0x2d0

Which is a false positive because sk_wait_event() will already have
TASK_RUNNING at that point if it would've gone through
schedule_timeout().

So annotate with sched_annotate_sleep(); which goes away on !DEBUG builds.

Reported-by: Ilya Dryomov <ilya.dryomov@inktank.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140924082242.524407432@infradead.org
Cc: David S. Miller <davem@davemloft.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: netdev@vger.kernel.org
Cc: tglx@linutronix.de
Cc: ilya.dryomov@inktank.com
Cc: umgwanakikbuti@gmail.com
Cc: oleg@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/net/sock.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/net/sock.h b/include/net/sock.h
index 7db3db1..e6f235e 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -897,6 +897,7 @@ static inline void sock_rps_reset_rxhash(struct sock *sk)
 		if (!__rc) {						\
 			*(__timeo) = schedule_timeout(*(__timeo));	\
 		}							\
+		sched_annotate_sleep();						\
 		lock_sock(__sk);					\
 		__rc = __condition;					\
 		__rc;							\
