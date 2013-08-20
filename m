Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751097Ab3HTMNF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 08:13:05 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:51310 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907Ab3HTMND (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 08:13:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Pavel Machek <pavel@ucw.cz>, linux-pm@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Colin Cross <ccross@android.com>
Subject: Re: [RFC PATCH] freezer: allow killing of frozen tasks
Date: Tue, 20 Aug 2013 14:23:32 +0200
Message-ID: <4596920.E6jI568rc1@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <5917186.DMyAa9ofOj@amdc1032>
References: <5917186.DMyAa9ofOj@amdc1032>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, August 20, 2013 01:20:03 PM Bartlomiej Zolnierkiewicz wrote:
> Change __refrigerator() to allow SIGKILL signal handling during
> the frozen state (by setting task to a TASK_KILLABLE state instead
> of TASK_UNINTERRUPTIBLE one before entering sleep) and make tasks
> leave __refrigerator() upon receiving such signal.
> 
> These changes allow frozen tasks to be killed immediately without
> the need to thaw them first.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Well, it doesn't sound like an entirely bad idea to me, but I'd like to know
what Colin and Tejun (CCed now) think about it.

Thanks,
Rafael


> ---
>  kernel/freezer.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/freezer.c b/kernel/freezer.c
> index b462fa1..0c05a7a 100644
> --- a/kernel/freezer.c
> +++ b/kernel/freezer.c
> @@ -57,12 +57,13 @@ bool __refrigerator(bool check_kthr_stop)
>  	pr_debug("%s entered refrigerator\n", current->comm);
>  
>  	for (;;) {
> -		set_current_state(TASK_UNINTERRUPTIBLE);
> +		set_current_state(TASK_KILLABLE);
>  
>  		spin_lock_irq(&freezer_lock);
>  		current->flags |= PF_FROZEN;
>  		if (!freezing(current) ||
> -		    (check_kthr_stop && kthread_should_stop()))
> +		    (check_kthr_stop && kthread_should_stop()) ||
> +		    fatal_signal_pending(current))
>  			current->flags &= ~PF_FROZEN;
>  		spin_unlock_irq(&freezer_lock);
>  
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
