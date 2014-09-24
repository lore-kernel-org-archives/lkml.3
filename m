Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbaIXI35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:29:57 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:57049 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbaIXI1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:27:22 -0400
Message-Id: <20140924082242.524407432@infradead.org>
User-Agent: quilt/0.60-1
Date: Wed, 24 Sep 2014 10:18:54 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@kernel.org, oleg@redhat.com, torvalds@linux-foundation.org
Cc: tglx@linutronix.de, ilya.dryomov@inktank.com, umgwanakikbuti@gmail.com,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        David Miller <davem@davemloft.net>
Subject: [PATCH 09/11] net: Clean up sk_wait_event() vs might_sleep()
References: <20140924081845.572814794@infradead.org>
Content-Disposition: inline; filename=peterz-sleep-net-sk_stream_wait_memory.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: CPU: 1 PID: 1744 at kernel/sched/core.c:7104 __might_sleep+0x58/0x90()
do not call blocking ops when !TASK_RUNNING; state=1 set at [<ffffffff81070e10>] prepare_to_wait+0x50 /0xa0

 [<ffffffff8105bc38>] __might_sleep+0x58/0x90
 [<ffffffff8148c671>] lock_sock_nested+0x31/0xb0
 [<ffffffff81498aaa>] sk_stream_wait_memory+0x18a/0x2d0

Which is a false positive because sk_wait_event() will already have
TASK_RUNNING at that point if it would've gone through
schedule_timeout().

So annotate with fixup_sleep(); which goes away on !DEBUG builds.

Cc: netdev@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Reported-by: Ilya Dryomov <ilya.dryomov@inktank.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 include/net/sock.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -902,6 +902,7 @@ static inline void sock_rps_reset_rxhash
 		if (!__rc) {						\
 			*(__timeo) = schedule_timeout(*(__timeo));	\
 		}							\
+		fixup_sleep();						\
 		lock_sock(__sk);					\
 		__rc = __condition;					\
 		__rc;							\


