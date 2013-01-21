Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752615Ab3AUJJp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 04:09:45 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:61583 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab3AUJJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 04:09:43 -0500
Message-ID: <1358759355.4994.108.camel@marge.simpson.net>
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
From: Mike Galbraith <bitbucket@online.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl
Date: Mon, 21 Jan 2013 10:09:15 +0100
In-Reply-To: <50FCF212.3010504@linux.vnet.ibm.com>
References: <1356588535-23251-1-git-send-email-wangyun@linux.vnet.ibm.com>
	 <50ED384C.1030301@linux.vnet.ibm.com>
	 <1357977704.6796.47.camel@marge.simpson.net>
	 <1357985943.6796.55.camel@marge.simpson.net>
	 <1358155290.5631.19.camel@marge.simpson.net>
	 <50F79256.1010900@linux.vnet.ibm.com>
	 <1358654997.5743.17.camel@marge.simpson.net>
	 <50FCACE3.5000706@linux.vnet.ibm.com>
	 <1358743128.4994.33.camel@marge.simpson.net>
	 <50FCCCF5.30504@linux.vnet.ibm.com>
	 <1358750523.4994.55.camel@marge.simpson.net>
	 <1358752180.4994.65.camel@marge.simpson.net>
	 <50FCF212.3010504@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:ixGVPqaBTdQvEEgZYKXC0CnUUrpIkz1SQUctRqE3YpG
 v+YcnUvmt8y1MbZN+LyWx61SPo8GL25lIbRq443sTAKap0anyJ
 OF89QOrg9FloUV+XfcwLSzQP9PSXUVmAfnyPtTH5qwkOnUl3t7
 cwlVEFg1kHwCsSzzUbLGQdCB263GEPFDuQL/FVA4mAoHLb8Hi2
 7QwvsarDOnF81TojOMlCNATE2w2SjFi1o/gM+ff+Yk/it2trBv
 w9eLjCsp3daYAJ9NnZX+muS3/jJrs5YdblYbVONfRMrBNHzGFz
 GXEnGRlLwLxgkqIBlsR0B7CWYIfWruUUp53LPVnDcgp9W4MIfl
 WdkNt8xec/Twuob3dSj+PgC5SafKq0RMi7J+8R0xo26u5qriV9
 aAij+qrOh7nPg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-21 at 15:45 +0800, Michael Wang wrote: 
> On 01/21/2013 03:09 PM, Mike Galbraith wrote:
> > On Mon, 2013-01-21 at 07:42 +0100, Mike Galbraith wrote: 
> >> On Mon, 2013-01-21 at 13:07 +0800, Michael Wang wrote:
> > 
> >>> May be we could try change this back to the old way later, after the aim
> >>> 7 test on my server.
> >>
> >> Yeah, something funny is going on.
> > 
> > Never entering balance path kills the collapse.  Asking wake_affine()
> > wrt the pull as before, but allowing us to continue should no idle cpu
> > be found, still collapsed.  So the source of funny behavior is indeed in
> > balance_path.
> 
> Below patch based on the patch set could help to avoid enter balance path
> if affine_sd could be found, just like the old logical, would you like to
> take a try and see whether it could help fix the collapse?

No, it does not.

> 
> Regards,
> Michael Wang
> 
> ---
>  kernel/sched/fair.c |   14 ++++++++------
>  1 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index d600708..4e95bb0 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3297,6 +3297,8 @@ next:
>                         sg = sg->next;
>                 } while (sg != sd->groups);
>         }
> +
> +       return -1;
>  done:
>         return target;
>  }
> @@ -3349,7 +3351,7 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
>                  * some cases.
>                  */
>                 new_cpu = select_idle_sibling(p, prev_cpu);
> -               if (idle_cpu(new_cpu))
> +               if (new_cpu != -1)
>                         goto unlock;
> 
>                 /*
> @@ -3363,15 +3365,15 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
>                         goto balance_path;
> 
>                 new_cpu = select_idle_sibling(p, cpu);
> -               if (!idle_cpu(new_cpu))
> -                       goto balance_path;
> -
>                 /*
>                  * Invoke wake_affine() finally since it is no doubt a
>                  * performance killer.
>                  */
> -               if (wake_affine(sbm->affine_map[prev_cpu], p, sync))
> -                       goto unlock;
> +               if (new_cpu == -1 ||
> +                       !wake_affine(sbm->affine_map[prev_cpu], p, sync))
> +                       new_cpu = prev_cpu;
> +
> +               goto unlock;
>         }
> 
>  balance_path:


