Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab3KGWvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 17:51:15 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:57602 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776Ab3KGWuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 17:50:54 -0500
Date: Thu, 7 Nov 2013 23:50:51 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mike Galbraith <bitbucket@online.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] kmod: Run usermodehelpers only on cpus allowed for
 kthreadd V2
Message-ID: <20131107225049.GC28130@localhost.localdomain>
References: <00000141c1b99b20-64f9d142-961a-447e-8ebe-40f86b638278-000000@email.amazonses.com>
 <20131016141326.2e517e18e4d8af880c97a282@linux-foundation.org>
 <00000141c36b03b6-2f9bd3de-d153-4359-901f-084aeb4c040d-000000@email.amazonses.com>
 <20131017122344.39d55db97c3923131bdf2831@linux-foundation.org>
 <0000014233722db9-cc00d0af-a5fa-4090-83bd-73c87377b892-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000014233722db9-cc00d0af-a5fa-4090-83bd-73c87377b892-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 04:43:11PM +0000, Christoph Lameter wrote:
> usermodehelper() threads can currently run on all processors.
> This is an issue for low latency cores. Spawnig a new thread causes
> cpu holdoffs in the range of hundreds of microseconds to a few
> milliseconds. Not good for cores on which processes run that need
> to react as fast as possible.
> 
> kthreadd threads can be restricted using taskset to a limited set
> of processors. Then the kernel thread pool will not fork processes
> on those anymore thereby protecting those processors from additional
> latencies.
> 
> Make usermodehelper() threads obey the limitations that kthreadd is
> restricted to. Kthreadd is not the parent of usermodehelper threads
> so we need to explicitly get the allowed processors for kthreadd.
> 
> Before this patch there is no way to limit the cpus that usermodehelper
> can run on since the affinity is set when the thread is spawned to
> all processors.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> Index: linux/include/linux/kthread.h
> ===================================================================
> --- linux.orig/include/linux/kthread.h	2013-11-07 10:31:46.667807582 -0600
> +++ linux/include/linux/kthread.h	2013-11-07 10:31:46.663807693 -0600
> @@ -51,6 +51,7 @@ void kthread_parkme(void);
>  int kthreadd(void *unused);
>  extern struct task_struct *kthreadd_task;
>  extern int tsk_fork_get_node(struct task_struct *tsk);
> +void set_kthreadd_affinity(void);
> 
>  /*
>   * Simple work processor based on kthread.
> Index: linux/kernel/kmod.c
> ===================================================================
> --- linux.orig/kernel/kmod.c	2013-11-07 10:31:46.667807582 -0600
> +++ linux/kernel/kmod.c	2013-11-07 10:35:28.825645008 -0600
> @@ -40,6 +40,7 @@
>  #include <linux/ptrace.h>
>  #include <linux/async.h>
>  #include <asm/uaccess.h>
> +#include <linux/kthread.h>
> 
>  #include <trace/events/module.h>
> 
> @@ -209,8 +210,13 @@ static int ____call_usermodehelper(void
>  	flush_signal_handlers(current, 1);
>  	spin_unlock_irq(&current->sighand->siglock);
> 
> -	/* We can run anywhere, unlike our parent keventd(). */
> -	set_cpus_allowed_ptr(current, cpu_all_mask);
> +	/*
> +	 * Kthreadd can be restricted to a set of processors if the user wants to
> +	 * protect other processors from OS latencies. If that has happened then
> +	 * we do not want to disturb the other processors here either so we start
> +	 * the usermode helper threads only on the processors allowed for kthreadd.
> +	 */
> +	set_kthreadd_affinity();

I'm sorry to burden again on this but this looks too odd.

usermodehelper works are created via workqueues, right? And workqueues are an issue as
well for those who want CPU isolation.

So this looks like a more general problem than just call_usermodehelper.

Last time I checked, it seemed to me that this is an unbound workqueue? If so can't we tune
the affinity of this workqueue? If not perhaps that's something we want to solve and which
could be useful for all the users who don't want their CPU to be disturbed.

Thanks.
