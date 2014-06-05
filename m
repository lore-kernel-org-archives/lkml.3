Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbaFEPbH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 11:31:07 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:52378 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbaFEPbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 11:31:04 -0400
From: Trond Myklebust <trond.myklebust@primarydata.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH] Revert lockdep check in raw_seqcount_begin
Date: Thu,  5 Jun 2014 11:31:01 -0400
Message-Id: <1401982261-11246-1-git-send-email-trond.myklebust@primarydata.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: John Stultz <john.stultz@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Link: http://lkml.kernel.org/r/CAHQdGtRR6SvEhXiqWo24hoUh9AU9cL82Z8Z-d8-7u951F_d+5g@mail.gmail.com
Signed-off-by: Trond Myklebust <trond.myklebust@primarydata.com>
---
 include/linux/seqlock.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 535f158977b9..8cf350325dc6 100644
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
-- 
1.9.3

