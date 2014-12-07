Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbaLGKpp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 05:45:45 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:53578 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbaLGKpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 05:45:43 -0500
Date: Sun, 7 Dec 2014 11:45:39 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        "\\\"Rafael J. Wysocki\\\"" <rjw@rjwysocki.net>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Oleg Nesterov <oleg@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org
Subject: Re: [PATCH -v2 2/5] OOM: thaw the OOM victim if it is frozen
Message-ID: <20141207104539.GK15892@dhcp22.suse.cz>
References: <20141110163055.GC18373@dhcp22.suse.cz>
 <1417797707-31699-1-git-send-email-mhocko@suse.cz>
 <1417797707-31699-3-git-send-email-mhocko@suse.cz>
 <20141206130657.GC18711@htj.dyndns.org>
 <20141207102430.GF15892@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141207102430.GF15892@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 07-12-14 11:24:30, Michal Hocko wrote:
> On Sat 06-12-14 08:06:57, Tejun Heo wrote:
> > Hello,
> > 
> > On Fri, Dec 05, 2014 at 05:41:44PM +0100, Michal Hocko wrote:
> > > oom_kill_process only sets TIF_MEMDIE flag and sends a signal to the
> > > victim. This is basically noop when the task is frozen though because
> > > the task sleeps in uninterruptible sleep. The victim is eventually
> > > thawed later when oom_scan_process_thread meets the task again in a
> > > later OOM invocation so the OOM killer doesn't live lock. But this is
> > > less than optimal. Let's add the frozen check and thaw the task right
> > > before we send SIGKILL to the victim.
> > > 
> > > The check and thawing in oom_scan_process_thread has to stay because the
> > > task might got access to memory reserves even without an explicit
> > > SIGKILL from oom_kill_process (e.g. it already has fatal signal pending
> > > or it is exiting already).
> > 
> > How else would a task get TIF_MEMDIE?  If there are other paths which
> > set TIF_MEMDIE, the right thing to do is creating a function which
> > thaws / wakes up the target task and use it there too.  Please
> > interlock these things properly from the get-go instead of scattering
> > these things around.
> 
> See __out_of_memory which sets TIF_MEMDIE on current when it is exiting
> or has fatal signals pending. This task cannot be frozen obviously.

On the other hand we are doing the same early in oom_kill_process which
doesn't work on the current. I've moved the __thaw_task
into mark_tsk_oom_victim so it catches all instances now.
oom_scan_process_thread doesn't need to thaw anymore.
---
>From af8222df6c503fa1beab8279ff39a282fd90698b Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Wed, 12 Nov 2014 18:56:54 +0100
Subject: [PATCH] OOM: thaw the OOM victim if it is frozen

oom_kill_process only sets TIF_MEMDIE flag and sends a signal to the
victim. This is basically noop when the task is frozen though because
the task sleeps in uninterruptible sleep. The victim is eventually
thawed later when oom_scan_process_thread meets the task again in a
later OOM invocation so the OOM killer doesn't live lock. But this is
less than optimal. Let's add __thaw_task into mark_tsk_oom_victim after
we set TIF_MEMDIE to the victim. We are not checking whether the task is
frozen because that would be racy and __thaw_task does that already.
oom_scan_process_thread doesn't need to care about freezer anymore
as TIF_MEMDIE and freezer are excluded completely now.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/oom_kill.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 56eab9621c3a..19a08f3f00ba 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -266,8 +266,6 @@ enum oom_scan_t oom_scan_process_thread(struct task_struct *task,
 	 * Don't allow any other task to have access to the reserves.
 	 */
 	if (test_tsk_thread_flag(task, TIF_MEMDIE)) {
-		if (unlikely(frozen(task)))
-			__thaw_task(task);
 		if (!force_kill)
 			return OOM_SCAN_ABORT;
 	}
@@ -428,6 +426,7 @@ void note_oom_kill(void)
 void mark_tsk_oom_victim(struct task_struct *tsk)
 {
 	set_tsk_thread_flag(tsk, TIF_MEMDIE);
+	__thaw_task(tsk);
 }
 
 /**
-- 
2.1.3


-- 
Michal Hocko
SUSE Labs
