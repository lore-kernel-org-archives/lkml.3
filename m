Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935270Ab3DKMCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 08:02:25 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:43187 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935205Ab3DKMCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 08:02:23 -0400
Message-ID: <5166A5AF.4050904@linux.vnet.ibm.com>
Date: Thu, 11 Apr 2013 17:29:43 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Dave Hansen <dave@sr71.net>, Borislav Petkov <bp@alien8.de>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, dhillf@gmail.com,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] kthread: Prevent unpark race which puts threads on the
 wrong cpu
References: <515F457E.5050505@sr71.net> <515FCAC6.8090806@linux.vnet.ibm.com> <alpine.LFD.2.02.1304061019000.21884@ionos> <alpine.LFD.2.02.1304071119100.21884@ionos> <20130407095025.GA31307@pd.tnic> <alpine.LFD.2.02.1304081122040.21884@ionos> <20130408115553.GA4395@pd.tnic> <alpine.LFD.2.02.1304081415570.21884@ionos> <alpine.LFD.2.02.1304091635430.21884@ionos> <516439DF.3050901@sr71.net> <alpine.LFD.2.02.1304092036431.21884@ionos> <alpine.LFD.2.02.1304092126150.21884@ionos> <51647C30.3050109@sr71.net> <alpine.LFD.2.02.1304101024010.21884@ionos> <alpine.LFD.2.02.1304101250320.21884@ionos> <5165C087.4060404@sr71.net> <alpine.LFD.2.02.1304111020520.21884@ionos> <51669510.2040200@linux.vnet.ibm.com> <5166A1D0.1080102@linux.vnet.ibm.com>
In-Reply-To: <5166A1D0.1080102@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041111-2000-0000-0000-00000BB21159
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2013 05:13 PM, Srivatsa S. Bhat wrote:
[...] 
> So Dave, could you kindly test the below patch on mainline?
> 

BTW, you don't need to try out any of the previous patches that I sent,
just this one is good enough. Thanks!

Regards,
Srivatsa S. Bhat

> 
> diff --git a/kernel/kthread.c b/kernel/kthread.c
> index 691dc2e..9558355 100644
> --- a/kernel/kthread.c
> +++ b/kernel/kthread.c
> @@ -308,6 +308,15 @@ struct task_struct *kthread_create_on_cpu(int (*threadfn)(void *data),
>  	to_kthread(p)->cpu = cpu;
>  	/* Park the thread to get it out of TASK_UNINTERRUPTIBLE state */
>  	kthread_park(p);
> +
> +	/*
> +	 * Wait for p->on_rq to be reset to 0, to ensure that the per-cpu
> +	 * migration thread (which belongs to the stop_task sched class)
> +	 * doesn't run until the cpu is actually onlined and the thread is
> +	 * unparked.
> +	 */
> +	if (!wait_task_inactive(p, TASK_INTERRUPTIBLE))
> +		WARN_ON(1);
>  	return p;
>  }
>  

