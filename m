Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab3BZWNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 17:13:11 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:44330 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab3BZWNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 17:13:09 -0500
Subject: Re: [RFC/PATCH 1/5] context tracking: conditionalize guest support
 based on CONFIG_KVM
From: Namhyung Kim <namhyung@kernel.org>
To: Kevin Hilman <khilman@linaro.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Mats Liljegren <mats.liljegren@enea.com>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <87fw0izxe4.fsf@linaro.org>
References: <1361389302-11968-1-git-send-email-khilman@linaro.org>
	 <1361389302-11968-2-git-send-email-khilman@linaro.org>
	 <20130222132750.GE17948@somewhere.redhat.com>  <87fw0izxe4.fsf@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Feb 2013 07:13:02 +0900
Message-ID: <1361916782.1740.2.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013-02-26 (화), 11:29 -0800, Kevin Hilman:
> Frederic Weisbecker <fweisbec@gmail.com> writes:
> 
> > On Wed, Feb 20, 2013 at 11:41:38AM -0800, Kevin Hilman wrote:
> >> So that it can build on !KVM systems too.
> >> 
> >> Signed-off-by: Kevin Hilman <khilman@linaro.org>
> >> ---
> >>  kernel/context_tracking.c | 4 ++++
> >>  1 file changed, 4 insertions(+)
> >> 
> >> diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
> >> index 74f68f4..6fe96b1 100644
> >> --- a/kernel/context_tracking.c
> >> +++ b/kernel/context_tracking.c
> >> @@ -1,5 +1,7 @@
> >>  #include <linux/context_tracking.h>
> >> +#ifdef CONFIG_KVM
> >>  #include <linux/kvm_host.h>
> >> +#endif
> >
> > The header should take care of the off-case, no need to ifdef its inclusion.
> 
> In their current form, the headers will not build on platforms without
> KVM support.  For example, these platforms (like ARM) don't even have
> <asm/kvm.h> or <asm/kvm_host.h>.
> 
> >>  #include <linux/rcupdate.h>
> >>  #include <linux/sched.h>
> >>  #include <linux/hardirq.h>
> >> @@ -62,6 +64,7 @@ void user_exit(void)
> >>  	local_irq_restore(flags);
> >>  }
> >>  
> >> +#ifdef CONFIG_KVM
> >>  void guest_enter(void)
> >>  {
> >>  	if (vtime_accounting_enabled())
> >> @@ -79,6 +82,7 @@ void guest_exit(void)
> >>  		__guest_exit();
> >>  }
> >>  EXPORT_SYMBOL_GPL(guest_exit);
> >> +#endif
> >
> > Kvm might be built as a module so we can't actually do this unfortunately.
> 
> Ah, right.  How bout using 
> 
> #if defined(CONFIG_KVM) || defined(CONFIG_KVM_MODULE)
> 
> for both conditionals above?  Updated patch below.

This is what IS_ENABLED(CONFIG_KVM) is for.

Thanks,
Namhyung

> 
> Kevin
> 
> 
> From 4444ce39eea21a5fc63b04a711addab2a5c63243 Mon Sep 17 00:00:00 2001
> From: Kevin Hilman <khilman@linaro.org>
> Date: Thu, 14 Feb 2013 10:17:37 -0800
> Subject: [PATCH] context tracking: conditionalize guest support based on
>  CONFIG_KVM
> 
> So that it can build on !KVM systems too.
> 
> Signed-off-by: Kevin Hilman <khilman@linaro.org>
> ---
>  kernel/context_tracking.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
> index 74f68f4..d9c98dd 100644
> --- a/kernel/context_tracking.c
> +++ b/kernel/context_tracking.c
> @@ -1,5 +1,7 @@
>  #include <linux/context_tracking.h>
> +#if defined(CONFIG_KVM) || defined(CONFIG_KVM_MODULE)
>  #include <linux/kvm_host.h>
> +#endif
>  #include <linux/rcupdate.h>
>  #include <linux/sched.h>
>  #include <linux/hardirq.h>
> @@ -62,6 +64,7 @@ void user_exit(void)
>  	local_irq_restore(flags);
>  }
>  
> +#if defined(CONFIG_KVM) || defined(CONFIG_KVM_MODULE)
>  void guest_enter(void)
>  {
>  	if (vtime_accounting_enabled())
> @@ -79,6 +82,7 @@ void guest_exit(void)
>  		__guest_exit();
>  }
>  EXPORT_SYMBOL_GPL(guest_exit);
> +#endif
>  
>  void context_tracking_task_switch(struct task_struct *prev,
>  			     struct task_struct *next)



