Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161497Ab3FUHxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 03:53:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:37373 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161469Ab3FUHxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 03:53:50 -0400
Date: Fri, 21 Jun 2013 09:53:42 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Vrabel <david.vrabel@citrix.com>
cc: xen-devel@lists.xen.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 1/4] hrtimers: provide a hrtimers_late_resume() call
In-Reply-To: <1371755792-25962-2-git-send-email-david.vrabel@citrix.com>
Message-ID: <alpine.DEB.2.02.1306210947410.4013@ionos.tec.linutronix.de>
References: <1371755792-25962-1-git-send-email-david.vrabel@citrix.com> <1371755792-25962-2-git-send-email-david.vrabel@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jun 2013, David Vrabel wrote:
> From: David Vrabel <david.vrabel@citrix.com>
> 
> Xen suspends (and resumes) without disabling non-boot CPUs as doing so
> adds considerable delay to live migrations.  A 4 VCPU guest had more
> than 200 ms of additional downtime if disable_nonboot_cpus() was
> called prior to suspending.
> 
> As a consequence, only high resolution timers on the current CPU are
> retriggered when resuming.  The Xen resume path worked around this
> with a call to clock_was_set() to retrigger timers on all the CPUs.
> 
> A subsequent change will make clock_was_set() internal to hrtimers so
> add an new call (hrtimers_late_resume()) to do the same job.
> 
> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> ---
>  drivers/xen/manage.c    |    8 ++++++--
>  include/linux/hrtimer.h |    1 +
>  kernel/hrtimer.c        |    9 +++++++++
>  3 files changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
> index 412b96c..75bc2d5 100644
> --- a/drivers/xen/manage.c
> +++ b/drivers/xen/manage.c
> @@ -166,8 +166,12 @@ out_resume:
>  
>  	dpm_resume_end(si.cancelled ? PMSG_THAW : PMSG_RESTORE);
>  
> -	/* Make sure timer events get retriggered on all CPUs */
> -	clock_was_set();
> +	/*
> +	 * syscore_resume() ends up calling hrtimer_resume() but this
> +	 * only retriggers timer events on the current CPU.  We need
> +	 * to retrigger the events on all the other CPUS.
> +	 */
> +	hrtimers_late_resume();

This is the completely wrong approach. If an architecture does not
shut down the non boot cpus on suspend, then this wants to be handled
in the core code and not in some random arch specific driver.

Thanks,

	tglx
