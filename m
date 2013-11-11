Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023Ab3KKRwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 12:52:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46616 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984Ab3KKRwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 12:52:39 -0500
Date: Mon, 11 Nov 2013 09:52:05 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-838cc7b488f89ee642fd8336e8e1b620c8c3ece2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, davidlohr@hp.com,
        fengguang.wu@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, fengguang.wu@intel.com,
        davidlohr@hp.com
In-Reply-To: <20131106164230.GE16117@laptop.programming.kicks-ass.net>
References: <20131106164230.GE16117@laptop.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] lockdep/proc: Fix lock-time avg computation
Git-Commit-ID: 838cc7b488f89ee642fd8336e8e1b620c8c3ece2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 11 Nov 2013 09:52:11 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  838cc7b488f89ee642fd8336e8e1b620c8c3ece2
Gitweb:     http://git.kernel.org/tip/838cc7b488f89ee642fd8336e8e1b620c8c3ece2
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 6 Nov 2013 17:42:30 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 11 Nov 2013 12:41:34 +0100

lockdep/proc: Fix lock-time avg computation

>    kernel/locking/lockdep_proc.c: In function 'seq_lock_time':
> >> kernel/locking/lockdep_proc.c:424:23: warning: comparison of distinct pointer types lacks a cast [enabled by default]
>
>    418	static void seq_lock_time(struct seq_file *m, struct lock_time *lt)
>    419	{
>    420		seq_printf(m, "%14lu", lt->nr);
>    421		seq_time(m, lt->min);
>    422		seq_time(m, lt->max);
>    423		seq_time(m, lt->total);
>  > 424		seq_time(m, lt->nr ? do_div(lt->total, lt->nr) : 0);
>    425	}

My compiler refuses to actually say that; but it looks wrong in that
do_div() returns the remainder, not the divisor.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Tested-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>
Link: http://lkml.kernel.org/r/20131106164230.GE16117@laptop.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/locking/lockdep_proc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/locking/lockdep_proc.c b/kernel/locking/lockdep_proc.c
index 0922065..ef43ac4 100644
--- a/kernel/locking/lockdep_proc.c
+++ b/kernel/locking/lockdep_proc.c
@@ -421,7 +421,7 @@ static void seq_lock_time(struct seq_file *m, struct lock_time *lt)
 	seq_time(m, lt->min);
 	seq_time(m, lt->max);
 	seq_time(m, lt->total);
-	seq_time(m, lt->nr ? do_div(lt->total, lt->nr) : 0);
+	seq_time(m, lt->nr ? div_s64(lt->total, lt->nr) : 0);
 }
 
 static void seq_stats(struct seq_file *m, struct lock_stat_data *data)
