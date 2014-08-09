Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750878AbaHICAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 22:00:20 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:45450 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaHICAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 22:00:19 -0400
MIME-Version: 1.0
In-Reply-To: <1407545198-9009-1-git-send-email-xiyou.wangcong@gmail.com>
References: <1407545198-9009-1-git-send-email-xiyou.wangcong@gmail.com>
Date: Sat, 9 Aug 2014 11:00:18 +0900
X-Google-Sender-Auth: FDREbQn7qrT7c1-QRfqSMCdUxqE
Message-ID: <CAH9JG2XuC0A=MVNx=OQcutHaCtXKt=hoWoB9PW3V_PuND6RJ5g@mail.gmail.com>
Subject: Re: [Patch] freezer: check OOM kill signal while being frozen
From: Kyungmin Park <kmpark@infradead.org>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>, Michal Hocko <mhocko@suse.cz>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 9, 2014 at 9:46 AM, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> There is a race condition between OOM killer and freezer when
> they try to operate on the same process, something like below:
>
>         Process A       Process B               Process C
> trigger oom
> B=oom_scan_process_thread()
>                                         cgroup_freezer_freeze(B)
>                         ...
>                         try_to_freeze()
>                         stay in D state
> oom_kill_process(B)
>
> In this case, process A triggers OOM and kernel selects process B
> as the victim, right before being killed process B was frozen by
> process C therefore went to D state, then kernel sent SIGKILL but
> it is already too late as process B will never care about pending
> signals any more. Fix this straightly by checking fatal pending signal
> from OOM killer, so that the frozen process will recover itself
> and then be killed finally.

Similar patch is posted and discussed but no conclusion.
http://marc.info/?t=137699769400004&r=1&w=1

Adding Bart,

Thank you,
Kyungmin Park
>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---
> diff --git a/kernel/freezer.c b/kernel/freezer.c
> index aa6a8aa..c6d189d 100644
> --- a/kernel/freezer.c
> +++ b/kernel/freezer.c
> @@ -68,7 +68,9 @@ bool __refrigerator(bool check_kthr_stop)
>                 spin_lock_irq(&freezer_lock);
>                 current->flags |= PF_FROZEN;
>                 if (!freezing(current) ||
> -                   (check_kthr_stop && kthread_should_stop()))
> +                   (check_kthr_stop && kthread_should_stop()) ||
> +                   (test_tsk_thread_flag(current, TIF_MEMDIE) &&
> +                        fatal_signal_pending(current)))
>                         current->flags &= ~PF_FROZEN;
>                 spin_unlock_irq(&freezer_lock);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
