Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab3IJH0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 03:26:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37689 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab3IJH0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 03:26:22 -0400
Date: Tue, 10 Sep 2013 00:25:06 -0700
From: tip-bot for Joonsoo Kim <tipbot@zytor.com>
Message-ID: <tip-b0cff9d88ce2f3030f73138078c5b1019f17e1cc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, pjt@google.com, dchinner@redhat.com,
        tglx@linutronix.de, iamjoonsoo.kim@lge.com, david@fromorbit.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        pjt@google.com, peterz@infradead.org, dchinner@redhat.com,
        david@fromorbit.com, tglx@linutronix.de, iamjoonsoo.kim@lge.com
In-Reply-To: <20130910065448.GA20368@lge.com>
References: <20130910065448.GA20368@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched:
  Fix load balancing performance regression in should_we_balance()
Git-Commit-ID: b0cff9d88ce2f3030f73138078c5b1019f17e1cc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 10 Sep 2013 00:25:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b0cff9d88ce2f3030f73138078c5b1019f17e1cc
Gitweb:     http://git.kernel.org/tip/b0cff9d88ce2f3030f73138078c5b1019f17e1cc
Author:     Joonsoo Kim <iamjoonsoo.kim@lge.com>
AuthorDate: Tue, 10 Sep 2013 15:54:49 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 10 Sep 2013 09:20:42 +0200

sched: Fix load balancing performance regression in should_we_balance()

Commit 23f0d20 ("sched: Factor out code to should_we_balance()")
introduces the should_we_balance() function.  This function should
return 1 if this cpu is appropriate for balancing. But the newly
introduced code doesn't do so, it returns 0 instead of 1.

This introduces performance regression, reported by Dave Chinner:

                        v4 filesystem           v5 filesystem
3.11+xfsdev:            220k files/s            225k files/s
3.12-git                180k files/s            185k files/s
3.12-git-revert         245k files/s            247k files/s

You can find more detailed information at:

  https://lkml.org/lkml/2013/9/10/1

This patch corrects the return value of should_we_balance()
function as orignally intended.

With this patch, Dave Chinner reports that the regression is gone:

                        v4 filesystem           v5 filesystem
3.11+xfsdev:            220k files/s            225k files/s
3.12-git                180k files/s            185k files/s
3.12-git-revert         245k files/s            247k files/s
3.12-git-fix            249k files/s            248k files/s

Reported-by: Dave Chinner <dchinner@redhat.com>
Tested-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Paul Turner <pjt@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>
Link: http://lkml.kernel.org/r/20130910065448.GA20368@lge.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7f0a5e6..9b3fe1c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5151,7 +5151,7 @@ static int should_we_balance(struct lb_env *env)
 	 * First idle cpu or the first cpu(busiest) in this sched group
 	 * is eligible for doing load balancing at this and above domains.
 	 */
-	return balance_cpu != env->dst_cpu;
+	return balance_cpu == env->dst_cpu;
 }
 
 /*
