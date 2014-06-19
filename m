Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359AbaFSMiE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 08:38:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57552 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaFSMiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 08:38:00 -0400
Date: Thu, 19 Jun 2014 05:36:52 -0700
From: tip-bot for Trond Myklebust <tipbot@zytor.com>
Message-ID: <tip-22fdcf02f6e80d64a927f702dd9d631a927d87d4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, trond.myklebust@primarydata.com,
        peterz@infradead.org, sboyd@codeaurora.org, viro@zeniv.linux.org.uk,
        davem@davemloft.net, john.stultz@linaro.org, Waiman.Long@hp.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        trond.myklebust@primarydata.com, torvalds@linux-foundation.org,
        peterz@infradead.org, viro@zeniv.linux.org.uk, sboyd@codeaurora.org,
        davem@davemloft.net, john.stultz@linaro.org, Waiman.Long@hp.com,
        tglx@linutronix.de
In-Reply-To: <CAHQdGtRR6SvEhXiqWo24hoUh9AU9cL82Z8Z-d8-7u951F_d+5g@mail.gmail.com>
References: <CAHQdGtRR6SvEhXiqWo24hoUh9AU9cL82Z8Z-d8-7u951F_d+5g@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] lockdep:
  Revert lockdep check in raw_seqcount_begin()
Git-Commit-ID: 22fdcf02f6e80d64a927f702dd9d631a927d87d4
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

Commit-ID:  22fdcf02f6e80d64a927f702dd9d631a927d87d4
Gitweb:     http://git.kernel.org/tip/22fdcf02f6e80d64a927f702dd9d631a927d87d4
Author:     Trond Myklebust <trond.myklebust@primarydata.com>
AuthorDate: Thu, 5 Jun 2014 11:31:01 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 18 Jun 2014 18:41:23 +0200

lockdep: Revert lockdep check in raw_seqcount_begin()

This commit reverts the addition of lockdep checking to raw_seqcount_begin
for the following reasons:

 1) It violates the naming convention that raw_* functions should not
    do lockdep checks (a convention that is also followed by the other
    raw_*_seqcount_begin functions).

 2) raw_seqcount_begin does not spin, so it can only be part of an ABBA
    deadlock in very special circumstances (for instance if a lock
    is held across the entire raw_seqcount_begin()+read_seqcount_retry()
    loop while also being taken inside the write_seqcount protected area).

 3) It is causing false positives with some existing callers, and there
    is no non-lockdep alternative for those callers to use.

None of the three existing callers (__d_lookup_rcu, netdev_get_name, and
the NFS state code) appear to use the function in a manner that is ABBA
deadlock prone.

Fixes: 1ca7d67cf5d5: seqcount: Add lockdep functionality to seqcount/seqlock
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: John Stultz <john.stultz@linaro.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Waiman Long <Waiman.Long@hp.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/CAHQdGtRR6SvEhXiqWo24hoUh9AU9cL82Z8Z-d8-7u951F_d+5g@mail.gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/seqlock.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 535f158..8cf3503 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -164,8 +164,6 @@ static inline unsigned read_seqcount_begin(const seqcount_t *s)
 static inline unsigned raw_seqcount_begin(const seqcount_t *s)
 {
 	unsigned ret = ACCESS_ONCE(s->sequence);
-
-	seqcount_lockdep_reader_access(s);
 	smp_rmb();
 	return ret & ~1;
 }
