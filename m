Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296AbbAJAyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 19:54:33 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:44416 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbbAJAyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 19:54:32 -0500
MIME-Version: 1.0
In-Reply-To: <1420801555-22659-6-git-send-email-mhocko@suse.cz>
References: <1420801555-22659-1-git-send-email-mhocko@suse.cz>
	<1420801555-22659-6-git-send-email-mhocko@suse.cz>
Date: Fri, 9 Jan 2015 16:54:31 -0800
Message-ID: <CAM_iQpVZT4Wd+5CX4MxaCtuPzU8u7fXn+XfJVdXq4LZ8jXNu6Q@mail.gmail.com>
Subject: Re: [PATCH -v3 5/5] oom, PM: make OOM detection in the freezer path raceless
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        "\\Rafael J. Wysocki\\" <rjw@rjwysocki.net>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Linux PM <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 9, 2015 at 3:05 AM, Michal Hocko <mhocko@suse.cz> wrote:
>  /**
>   * freeze_processes - Signal user space processes to enter the refrigerator.
>   * The current thread will not be frozen.  The same process that calls
> @@ -142,7 +118,6 @@ static bool check_frozen_processes(void)
>  int freeze_processes(void)
>  {
>         int error;
> -       int oom_kills_saved;
>
>         error = __usermodehelper_disable(UMH_FREEZING);
>         if (error)
> @@ -157,29 +132,22 @@ int freeze_processes(void)
>         pm_wakeup_clear();
>         pr_info("Freezing user space processes ... ");
>         pm_freezing = true;
> -       oom_kills_saved = oom_kills_count();
>         error = try_to_freeze_tasks(true);
>         if (!error) {
>                 __usermodehelper_set_disable_depth(UMH_DISABLED);
> -               oom_killer_disable();
> -
> -               /*
> -                * There might have been an OOM kill while we were
> -                * freezing tasks and the killed task might be still
> -                * on the way out so we have to double check for race.
> -                */
> -               if (oom_kills_count() != oom_kills_saved &&
> -                   !check_frozen_processes()) {
> -                       __usermodehelper_set_disable_depth(UMH_ENABLED);
> -                       pr_cont("OOM in progress.");
> -                       error = -EBUSY;
> -               } else {
> -                       pr_cont("done.");
> -               }
> +               pr_cont("done.");
>         }
>         pr_cont("\n");
>         BUG_ON(in_atomic());
>
> +       /*
> +        * Now that the whole userspace is frozen we need to disbale


disable


> +        * the OOM killer to disallow any further interference with
> +        * killable tasks.
> +        */
> +       if (!error && !oom_killer_disable())
> +               error = -EBUSY;
> +
[...]
>  void unmark_oom_victim(void)
>  {
> -       clear_thread_flag(TIF_MEMDIE);
> +       if (!test_and_clear_thread_flag(TIF_MEMDIE))
> +               return;
> +
> +       down_read(&oom_sem);
> +       /*
> +        * There is no need to signal the lasst oom_victim if there

last

> +        * is nobody who cares.
> +        */
> +       if (!atomic_dec_return(&oom_victims) && oom_killer_disabled)
> +               wake_up_all(&oom_victims_wait);
> +       up_read(&oom_sem);
> +}
[...]
>  /*
>   * The pagefault handler calls here because it is out of memory, so kill a
>   * memory-hogging task.  If any populated zone has ZONE_OOM_LOCKED set, a
> @@ -727,12 +806,25 @@ void pagefault_out_of_memory(void)
>  {
>         struct zonelist *zonelist;
>
> +       down_read(&oom_sem);
>         if (mem_cgroup_oom_synchronize(true))
> -               return;
> +               goto unlock;
>
>         zonelist = node_zonelist(first_memory_node, GFP_KERNEL);
>         if (oom_zonelist_trylock(zonelist, GFP_KERNEL)) {
> -               out_of_memory(NULL, 0, 0, NULL, false);
> +               if (!oom_killer_disabled)
> +                       __out_of_memory(NULL, 0, 0, NULL, false);
> +               else
> +                       /*
> +                        * There shouldn't be any user tasks runable while the

runnable


> +                        * OOM killer is disabled so the current task has to
> +                        * be a racing OOM victim for which oom_killer_disable()
> +                        * is waiting for.
> +                        */
> +                       WARN_ON(test_thread_flag(TIF_MEMDIE));
> +
>                 oom_zonelist_unlock(zonelist, GFP_KERNEL);
>         }
> +unlock:
> +       up_read(&oom_sem);
>  }


Thanks!
