Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab3LCS6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 13:58:01 -0500
Received: from mail-we0-f170.google.com ([74.125.82.170]:60172 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755Ab3LCS57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 13:57:59 -0500
MIME-Version: 1.0
In-Reply-To: <20131202152440.GA10900@redhat.com>
References: <20131202152423.GA10878@redhat.com> <20131202152440.GA10900@redhat.com>
From: Sameer Nanda <snanda@chromium.org>
Date: Tue, 3 Dec 2013 10:57:36 -0800
X-Google-Sender-Auth: epJrNlWZMy79r2uC2eQkwaKsPiY
Message-ID: <CANMivWbMmra05sqAgZb7AP+W0qAs8z3jGgsMPPML=3v5TZfFwA@mail.gmail.com>
Subject: Re: [PATCH 2/2] oom_kill: change oom_kill.c to use for_each_thread()
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        "Ma, Xindong" <xindong.ma@intel.com>, Michal Hocko <mhocko@suse.cz>,
        Sergey Dyasly <dserrg@gmail.com>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for helping get this fixed!  Couple of comments below.

On Mon, Dec 2, 2013 at 7:24 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> 1. Change oom_kill.c to use for_each_thread() rather than the racy
>    while_each_thread() which can loop forever if we race with exit.
>
>    Note also that most users were buggy even if while_each_thread()
>    was fine, the task can exit even _before_ rcu_read_lock().
>
>    Fortunately the new for_each_thread() only requires the stable
>    task_struct, so this change fixes both problems.
>
> 2. At least out_of_memory() calls has_intersects_mems_allowed()
>    without even rcu_read_lock(), this is obviously buggy.
>
>    Add the necessary rcu_read_lock(). This means that we can not
>    simply return from the loop, we need "bool ret" and "break".
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Sameer Nanda <snanda@chromium.org>

> ---
>  mm/oom_kill.c |   37 ++++++++++++++++++++-----------------
>  1 files changed, 20 insertions(+), 17 deletions(-)
>
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 1e4a600..47dd4ce 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -54,12 +54,14 @@ static DEFINE_SPINLOCK(zone_scan_lock);
>   * shares the same mempolicy nodes as current if it is bound by such a policy
>   * and whether or not it has the same set of allowed cpuset nodes.
>   */
> -static bool has_intersects_mems_allowed(struct task_struct *tsk,
> +static bool has_intersects_mems_allowed(struct task_struct *start,
Comment block needs to be fixed up due to variable name change from
tsk to start.

>                                         const nodemask_t *mask)
>  {
> -       struct task_struct *start = tsk;
> +       struct task_struct *tsk;
> +       bool ret = false;
>
> -       do {
> +       rcu_read_lock();
> +       for_each_thread(start, tsk) {
>                 if (mask) {
>                         /*
>                          * If this is a mempolicy constrained oom, tsk's
> @@ -67,19 +69,20 @@ static bool has_intersects_mems_allowed(struct task_struct *tsk,
>                          * mempolicy intersects current, otherwise it may be
>                          * needlessly killed.
>                          */
> -                       if (mempolicy_nodemask_intersects(tsk, mask))
> -                               return true;
> +                       ret = mempolicy_nodemask_intersects(tsk, mask);
>                 } else {
>                         /*
>                          * This is not a mempolicy constrained oom, so only
>                          * check the mems of tsk's cpuset.
>                          */
> -                       if (cpuset_mems_allowed_intersects(current, tsk))
> -                               return true;
> +                       ret = cpuset_mems_allowed_intersects(current, tsk);
>                 }
> -       } while_each_thread(start, tsk);
> +               if (ret)
> +                       break;
> +       }
> +       rcu_read_unlock();
>
> -       return false;
> +       return ret;
>  }
>  #else
>  static bool has_intersects_mems_allowed(struct task_struct *tsk,
> @@ -97,14 +100,14 @@ static bool has_intersects_mems_allowed(struct task_struct *tsk,
>   */
>  struct task_struct *find_lock_task_mm(struct task_struct *p)
>  {
> -       struct task_struct *t = p;
> +       struct task_struct *t;
>
> -       do {
> +       for_each_thread(p, t) {
>                 task_lock(t);
>                 if (likely(t->mm))
>                         return t;
>                 task_unlock(t);
> -       } while_each_thread(p, t);
> +       }
>
>         return NULL;
>  }
> @@ -301,7 +304,7 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
>         unsigned long chosen_points = 0;
>
>         rcu_read_lock();
> -       do_each_thread(g, p) {
> +       for_each_process_thread(g, p) {
>                 unsigned int points;
>
>                 switch (oom_scan_process_thread(p, totalpages, nodemask,
> @@ -323,7 +326,7 @@ static struct task_struct *select_bad_process(unsigned int *ppoints,
>                         chosen = p;
>                         chosen_points = points;
>                 }
> -       } while_each_thread(g, p);
> +       }
>         if (chosen)
>                 get_task_struct(chosen);
>         rcu_read_unlock();
> @@ -406,7 +409,7 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
>  {
>         struct task_struct *victim = p;
>         struct task_struct *child;
> -       struct task_struct *t = p;
> +       struct task_struct *t;
>         struct mm_struct *mm;
>         unsigned int victim_points = 0;
>         static DEFINE_RATELIMIT_STATE(oom_rs, DEFAULT_RATELIMIT_INTERVAL,
> @@ -437,7 +440,7 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
>          * still freeing memory.
>          */
>         read_lock(&tasklist_lock);
This can be a rcu_read_lock now, I think?

> -       do {
> +       for_each_thread(p, t) {
>                 list_for_each_entry(child, &t->children, sibling) {
>                         unsigned int child_points;
>
> @@ -455,7 +458,7 @@ void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
>                                 get_task_struct(victim);
>                         }
>                 }
> -       } while_each_thread(p, t);
> +       }
>         read_unlock(&tasklist_lock);
>
>         rcu_read_lock();
> --
> 1.5.5.1
>



-- 
Sameer
