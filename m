Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760652AbaJCXyV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:54:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45763 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756808AbaJCVxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:53:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Peter Zijlstra <peterz@infradead.org>,
        John Stultz <john.stultz@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>, Waiman Long <Waiman.Long@hp.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3.16 264/357] lockdep: Revert lockdep check in raw_seqcount_begin()
Date: Fri,  3 Oct 2014 14:30:50 -0700
Message-Id: <20141003212941.429439082@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@primarydata.com>

commit 22fdcf02f6e80d64a927f702dd9d631a927d87d4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/seqlock.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -164,8 +164,6 @@ static inline unsigned read_seqcount_beg
 static inline unsigned raw_seqcount_begin(const seqcount_t *s)
 {
 	unsigned ret = ACCESS_ONCE(s->sequence);
-
-	seqcount_lockdep_reader_access(s);
 	smp_rmb();
 	return ret & ~1;
 }


