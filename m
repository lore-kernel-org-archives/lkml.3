Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758895Ab3KMR0h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 12:26:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52936 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757859Ab3KMR01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 12:26:27 -0500
Date: Wed, 13 Nov 2013 09:25:51 -0800
From: tip-bot for Michal Nazarewicz <tipbot@zytor.com>
Message-ID: <tip-85b088e934b9943322bfe37077289ae60f1b3414@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, bsegall@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        mina86@mina86.com
Reply-To: mingo@kernel.org, hpa@zytor.com, bsegall@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        mina86@mina86.com
In-Reply-To: <1384112521-25177-1-git-send-email-mpn@google.com>
References: <1384112521-25177-1-git-send-email-mpn@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/fair: Avoid integer overflow
Git-Commit-ID: 85b088e934b9943322bfe37077289ae60f1b3414
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 13 Nov 2013 09:25:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  85b088e934b9943322bfe37077289ae60f1b3414
Gitweb:     http://git.kernel.org/tip/85b088e934b9943322bfe37077289ae60f1b3414
Author:     Michal Nazarewicz <mina86@mina86.com>
AuthorDate: Sun, 10 Nov 2013 20:42:01 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 13 Nov 2013 13:33:55 +0100

sched/fair: Avoid integer overflow

sa->runnable_avg_sum is of type u32 but after shifting it by NICE_0_SHIFT
bits it is promoted to u64.  This of course makes no sense, since the
result will never be more then 32-bit long.  Casting sa->runnable_avg_sum
to u64 before it is shifted, fixes this problem.

Reviewed-by: Ben Segall <bsegall@google.com>
Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1384112521-25177-1-git-send-email-mpn@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 201be78..e8b652e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2178,7 +2178,7 @@ static inline void __update_tg_runnable_avg(struct sched_avg *sa,
 	long contrib;
 
 	/* The fraction of a cpu used by this cfs_rq */
-	contrib = div_u64(sa->runnable_avg_sum << NICE_0_SHIFT,
+	contrib = div_u64((u64)sa->runnable_avg_sum << NICE_0_SHIFT,
 			  sa->runnable_avg_period + 1);
 	contrib -= cfs_rq->tg_runnable_contrib;
 
