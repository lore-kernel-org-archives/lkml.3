Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab3KTS3N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 13:29:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754001Ab3KTS3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 13:29:07 -0500
Date: Wed, 20 Nov 2013 19:30:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Michal Hocko <mhocko@suse.cz>, Sameer Nanda <snanda@chromium.org>,
        Sergey Dyasly <dserrg@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] proc: fix the potential use-after-free in first_tid()
Message-ID: <20131120183022.GA12209@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131120183009.GA12193@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

proc_task_readdir() verifies that the result of get_proc_task()
is pid_alive() and thus its ->group_leader is fine too. However
this is not necessarily true after rcu_read_unlock(), we need
to recheck this again after first_tid() does rcu_read_lock().
Otherwise leader->thread_group.next (used by next_thread()) can
be invalid if the rcu grace period expires in between.

The race is subtle and unlikely, but still it is possible afaics.
To simplify lets ignore the "likely" case when tid != 0, f_version
can be cleared by proc_task_operations->llseek().

Suppose we have a main thread M and its subthread T. Suppose that
f_pos == 3, iow first_tid() should return T. Now suppose that the
following happens between rcu_read_unlock() and rcu_read_lock():

	1. T execs and becomes the new leader. This removes M from
	    ->thread_group but next_thread(M) is still T.

	2. T creates another thread X which does exec as well, T
	   goes away.

	3. X creates another subthread, this increments nr_threads.

	4. first_tid() does next_thread(M) and returns the already
	   dead T.

Note also that we need 2. and 3. only because of get_nr_threads()
check, and this check was supposed to be optimization only.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/base.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 1485e38..da12c5c 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -3103,6 +3103,9 @@ static struct task_struct *first_tid(struct task_struct *leader,
 	pos = NULL;
 	if (nr && nr >= get_nr_threads(leader))
 		goto out;
+	/* It could be unhashed before we take rcu lock */
+	if (!pid_alive(leader))
+		goto out;
 
 	/* If we haven't found our starting place yet start
 	 * with the leader and walk nr threads forward.
-- 
1.5.5.1

