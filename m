Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab3JQNzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 09:55:17 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:42239 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221Ab3JQNzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 09:55:16 -0400
Date: Thu, 17 Oct 2013 15:55:11 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Mike Galbraith <bitbucket@online.de>, Thomas Gleixner <tglx@linutronix.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH] kmod: Run usermodehelpers only on cpus allowed for
 kthreadd
Message-ID: <20131017135509.GB28963@localhost.localdomain>
References: <00000141c1b99b20-64f9d142-961a-447e-8ebe-40f86b638278-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000141c1b99b20-64f9d142-961a-447e-8ebe-40f86b638278-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 02:44:28PM +0000, Christoph Lameter wrote:
> This is a follow on patch related to the earlier
> discussion about restricting the
> spawning of kernel threads. See https://lkml.org/lkml/2013/9/5/426
> 
> 
> 
> 
> usermodehelper() threads can currently run on all processors.
> This is an issue for low latency cores.

This might be redundant with akpm's reply but here we go:

low latency is a very confusing term nowadays. It's used by real time
to describe the time it takes for a high prio task to take the CPU,
and it's used by you for extreme HPC mode for deterministic undisturbed
throughput.

The changelog needs to be expanded to describe what's needed, or people
will be confused when they will stare at that git blame line in one year from now :)

> 
> Restrict usermodehelper() threads to the cores that kthreadd is
> restricted to.
> 
> The default for kthreadd is to be allowed to run on an processors.

s/an/all ?

> If the user restricts kthreadd then threads spawned by
> usermodhelper() will similarly restricted.
> 
> Before this patch there is no way to limit the cpus that usermodehelper
> can run on since the affinity is set when the thread is spawned to
> all processors.
> 
> Signed-off-by: Christoph Lameter <cl@linux.com>
> 
> Index: linux/include/linux/kthread.h
> ===================================================================
> --- linux.orig/include/linux/kthread.h	2013-10-10 11:00:34.167771996 -0500
> +++ linux/include/linux/kthread.h	2013-10-15 13:57:52.859056676 -0500
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
> --- linux.orig/kernel/kmod.c	2013-10-10 11:00:39.091771917 -0500
> +++ linux/kernel/kmod.c	2013-10-15 14:02:01.904261324 -0500
> @@ -40,6 +40,7 @@
>  #include <linux/ptrace.h>
>  #include <linux/async.h>
>  #include <asm/uaccess.h>
> +#include <linux/kthread.h>
> 
>  #include <trace/events/module.h>
> 
> @@ -209,8 +210,8 @@ static int ____call_usermodehelper(void
>  	flush_signal_handlers(current, 1);
>  	spin_unlock_irq(&current->sighand->siglock);
> 
> -	/* We can run anywhere, unlike our parent keventd(). */
> -	set_cpus_allowed_ptr(current, cpu_all_mask);
> +	/* We can run anywhere kthreadd can run */
> +	set_kthreadd_affinity();

If you really want your isolated CPUs to be undisturbed, you need this affinity to
be set before the creation of this usermode helper. Otherwise it's going to run to any random
place before you call the above function.

Is there now way to control the kworker affinity which create this usermode helpers threads
instead?
