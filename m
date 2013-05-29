Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967047Ab3E2UzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 16:55:18 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:40751 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966896Ab3E2UzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 16:55:15 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Sergey Dyasly <dserrg@gmail.com>, linux-kernel@vger.kernel.org
References: <20130529143938.GA22211@redhat.com>
Date: Wed, 29 May 2013 13:54:45 -0700
In-Reply-To: <20130529143938.GA22211@redhat.com> (Oleg Nesterov's message of
	"Wed, 29 May 2013 16:39:38 +0200")
Message-ID: <87r4gpy0a2.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18w44K+4g2D6ctovo9djr3TdosxSjPQe+A=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.5 XMGappySubj_01 Very gappy subject
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0213]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] don't use task->pid/tgid in same_thread_group/has_group_leader_pid
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> task_struct->pid/tgid should go away.
>
> 1. Change same_thread_group() to use task->signal for comparison.
>
> 2. Change has_group_leader_pid(task) to compare task_pid(task) with
>    signal->leader_pid.

Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>

This change looks good, thanks.

The posix cpu timers usage of has_group_leader_pid looks a little iffy,
but this change doesn't look like it will break them.

Thanks for this cleanup Oleg.

> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  include/linux/sched.h |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 178a8d9..ce51dfd 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -2179,15 +2179,15 @@ static inline bool thread_group_leader(struct task_struct *p)
>   * all we care about is that we have a task with the appropriate
>   * pid, we don't actually care if we have the right task.
>   */
> -static inline int has_group_leader_pid(struct task_struct *p)
> +static inline bool has_group_leader_pid(struct task_struct *p)
>  {
> -	return p->pid == p->tgid;
> +	return task_pid(p) == p->signal->leader_pid;
>  }
>  
>  static inline
> -int same_thread_group(struct task_struct *p1, struct task_struct *p2)
> +bool same_thread_group(struct task_struct *p1, struct task_struct *p2)
>  {
> -	return p1->tgid == p2->tgid;
> +	return p1->signal == p2->signal;
>  }
>  
>  static inline struct task_struct *next_thread(const struct task_struct *p)
