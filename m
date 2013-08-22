Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab3HVTPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 15:15:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189Ab3HVTPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 15:15:21 -0400
Date: Thu, 22 Aug 2013 21:08:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        John Johansen <john.johansen@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 11/12] pid: rewrite task helper functions avoiding
	task->pid and task->tgid
Message-ID: <20130822190848.GA25053@redhat.com>
References: <cover.1377032086.git.rgb@redhat.com> <bbf1d1952bd17e3b19ecbafb1d1603d0bed72381.1377032086.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bbf1d1952bd17e3b19ecbafb1d1603d0bed72381.1377032086.git.rgb@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20, Richard Guy Briggs wrote:
>
>  static inline int is_global_init(struct task_struct *tsk)
>  {
> -	return tsk->pid == 1;
> +	return task_pid_nr(tsk) == 1;
>  }

Probably it would be better to simply kill it. Almost every usage is
wrong.

>  static inline bool is_idle_task(const struct task_struct *p)
>  {
> -	return p->pid == 0;
> +	return task_pid(p) == &init_struct_pid;
>  }

hmm. there should be a simpler check for this...

>  static inline int has_group_leader_pid(struct task_struct *p)
>  {
> -	return p->pid == p->tgid;
> +	return task_pid(p) == task_tgid(p);
>  }
>  
>  static inline
>  int same_thread_group(struct task_struct *p1, struct task_struct *p2)
>  {
> -	return p1->tgid == p2->tgid;
> +	return task_tgid(p1) == task_tgid(p2);

This is suboptinal. See the attached
include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid.patch
from -mm below.

Oleg.


--- a/include/linux/sched.h~include-linux-schedh-dont-use-task-pid-tgid-in-same_thread_group-has_group_leader_pid
+++ a/include/linux/sched.h
@@ -2179,15 +2179,15 @@ static inline bool thread_group_leader(s
  * all we care about is that we have a task with the appropriate
  * pid, we don't actually care if we have the right task.
  */
-static inline int has_group_leader_pid(struct task_struct *p)
+static inline bool has_group_leader_pid(struct task_struct *p)
 {
-	return p->pid == p->tgid;
+	return task_pid(p) == p->signal->leader_pid;
 }
 
 static inline
-int same_thread_group(struct task_struct *p1, struct task_struct *p2)
+bool same_thread_group(struct task_struct *p1, struct task_struct *p2)
 {
-	return p1->tgid == p2->tgid;
+	return p1->signal == p2->signal;
 }
 
 static inline struct task_struct *next_thread(const struct task_struct *p)

