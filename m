Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbaAPNlQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:41:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38463 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbaAPNlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:41:12 -0500
Date: Thu, 16 Jan 2014 05:40:40 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-fid9nalzii2r5voxtf4eh5kz@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, raistlin@linux.it, tglx@linutronix.de,
        fengguang.wu@intel.com, juri.lelli@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, raistlin@linux.it, tglx@linutronix.de,
        fengguang.wu@intel.com, juri.lelli@gmail.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix up attr::sched_priority warning
Git-Commit-ID: 0bb040a44381261c0729636abbe03caeedb7d72e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 16 Jan 2014 05:40:46 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0bb040a44381261c0729636abbe03caeedb7d72e
Gitweb:     http://git.kernel.org/tip/0bb040a44381261c0729636abbe03caeedb7d72e
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 15 Jan 2014 17:15:13 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 16 Jan 2014 09:27:16 +0100

sched: Fix up attr::sched_priority warning

Fengguang Wu reported the following build warning:

  > kernel/sched/core.c:3067 __sched_setscheduler() warn: unsigned 'attr->sched_priority' is never less than zero.

Since it doesn't make sense for attr::sched_priority to be negative,
remove the check, since we already test for an upper limit any actual
negative values passed in through the old param::sched_priority field
will still be detected.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@gmail.com>
Cc: Dario Faggioli <raistlin@linux.it>
Fixes: d50dde5a10f3 ("sched: Add new scheduler syscalls to support an extended scheduling parameters ABI")
Link: http://lkml.kernel.org/n/tip-fid9nalzii2r5voxtf4eh5kz@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e9212eb..5a6ccdf 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3282,8 +3282,7 @@ recheck:
 	 * 1..MAX_USER_RT_PRIO-1, valid priority for SCHED_NORMAL,
 	 * SCHED_BATCH and SCHED_IDLE is 0.
 	 */
-	if (attr->sched_priority < 0 ||
-	    (p->mm && attr->sched_priority > MAX_USER_RT_PRIO-1) ||
+	if ((p->mm && attr->sched_priority > MAX_USER_RT_PRIO-1) ||
 	    (!p->mm && attr->sched_priority > MAX_RT_PRIO-1))
 		return -EINVAL;
 	if ((dl_policy(policy) && !__checkparam_dl(attr)) ||
