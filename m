Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbaA2U2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 15:28:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33603 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbaA2U2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 15:28:15 -0500
Date: Wed, 29 Jan 2014 12:28:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm, oom: base root bonus on current usage
Message-Id: <20140129122813.59d32e5c5dad3efc2248bc60@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.02.1401251942510.3140@chino.kir.corp.google.com>
References: <20140115234308.GB4407@cmpxchg.org>
	<alpine.DEB.2.02.1401151614480.15665@chino.kir.corp.google.com>
	<20140116070709.GM6963@cmpxchg.org>
	<alpine.DEB.2.02.1401212050340.8512@chino.kir.corp.google.com>
	<20140124040531.GF4407@cmpxchg.org>
	<alpine.DEB.2.02.1401251942510.3140@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Jan 2014 19:48:32 -0800 (PST) David Rientjes <rientjes@google.com> wrote:

> A 3% of system memory bonus is sometimes too excessive in comparison to 
> other processes and can yield poor results when all processes on the 
> system are root and none of them use over 3% of memory.
> 
> Replace the 3% of system memory bonus with a 3% of current memory usage 
> bonus.

This changelog has deteriorated :( We should provide sufficient info so
that people will be able to determine whether this patch will fix a
problem they or their customers are observing.  And so that people who
maintain -stable and its derivatives can decide whether to backport it.

I went back and stole some text from the v1 patch.  Please review the
result.  The changelog would be even better if it were to describe the
new behaviour under the problematic workloads.

We don't think -stable needs this?


From: David Rientjes <rientjes@google.com>
Subject: mm, oom: base root bonus on current usage

A 3% of system memory bonus is sometimes too excessive in comparison to
other processes.

With a63d83f427fb ("oom: badness heuristic rewrite"), the OOM killer tries
to avoid killing privileged tasks by subtracting 3% of overall memory
(system or cgroup) from their per-task consumption.  But as a result, all
root tasks that consume less than 3% of overall memory are considered
equal, and so it only takes 33+ privileged tasks pushing the system out of
memory for the OOM killer to do something stupid and kill sshd or
dhclient.  For example, on a 32G machine it can't tell the difference
between the 1M agetty and the 10G fork bomb member.

The changelog describes this 3% boost as the equivalent to the global
overcommit limit being 3% higher for privileged tasks, but this is not the
same as discounting 3% of overall memory from _every privileged task
individually_ during OOM selection.

Replace the 3% of system memory bonus with a 3% of current memory usage
bonus.

Signed-off-by: David Rientjes <rientjes@google.com>
Reported-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |    4 ++--
 mm/oom_kill.c                      |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN Documentation/filesystems/proc.txt~mm-oom-base-root-bonus-on-current-usage Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~mm-oom-base-root-bonus-on-current-usage
+++ a/Documentation/filesystems/proc.txt
@@ -1386,8 +1386,8 @@ may allocate from based on an estimation
 For example, if a task is using all allowed memory, its badness score will be
 1000.  If it is using half of its allowed memory, its score will be 500.
 
-There is an additional factor included in the badness score: root
-processes are given 3% extra memory over other tasks.
+There is an additional factor included in the badness score: the current memory
+and swap usage is discounted by 3% for root processes.
 
 The amount of "allowed" memory depends on the context in which the oom killer
 was called.  If it is due to the memory assigned to the allocating task's cpuset
diff -puN mm/oom_kill.c~mm-oom-base-root-bonus-on-current-usage mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-base-root-bonus-on-current-usage
+++ a/mm/oom_kill.c
@@ -178,7 +178,7 @@ unsigned long oom_badness(struct task_st
 	 * implementation used by LSMs.
 	 */
 	if (has_capability_noaudit(p, CAP_SYS_ADMIN))
-		adj -= 30;
+		points -= (points * 3) / 100;
 
 	/* Normalize to oom_score_adj units */
 	adj *= totalpages / 1000;
_

