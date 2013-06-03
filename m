Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759407Ab3FCTKy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 15:10:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5784 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756792Ab3FCTKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 15:10:50 -0400
Date: Mon, 3 Jun 2013 21:06:58 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Michal Hocko <mhocko@suse.cz>,
        Sergey Dyasly <dserrg@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] proc: first_tid: fix the potential use-after-free
Message-ID: <20130603190658.GA11500@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130603190640.GA11481@redhat.com>
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

Note: I think that proc_task_readdir/first_tid interaction can be
simplified, but this needs another patch. proc_task_readdir() should
not play with ->group_leader at all. See the next patches.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/proc/base.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index dd51e50..daf41dc 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -3190,6 +3190,9 @@ static struct task_struct *first_tid(struct task_struct *leader,
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

