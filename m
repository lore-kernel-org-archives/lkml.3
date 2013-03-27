Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab3C0TOQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 15:14:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35300 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956Ab3C0TOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 15:14:15 -0400
Date: Wed, 27 Mar 2013 12:14:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH 2/2] timer_list: convert timer list to be a proper
 seq_file
Message-Id: <20130327121412.f589d0cc105843284e1d8eb5@linux-foundation.org>
In-Reply-To: <1364345790-14577-3-git-send-email-nzimmer@sgi.com>
References: <alpine.LFD.2.02.1303251651200.22263@ionos>
	<1364345790-14577-1-git-send-email-nzimmer@sgi.com>
	<1364345790-14577-3-git-send-email-nzimmer@sgi.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Mar 2013 19:56:30 -0500 Nathan Zimmer <nzimmer@sgi.com> wrote:

> When running with 4096 cores attemping to read /proc/timer_list will fail
> with an ENOMEM condition.  On a sufficantly large systems the total amount
> of data is more then 4mb, so it won't fit into a single buffer.  The
> failure can also occur on smaller systems when memory fragmentation is
> high as reported by Dave Jones.
> 
> Convert /proc/timer_list to a proper seq_file with its own iterator.  This
> is a little more complex given that we have to make two passes with two
> separate headers.
> 
> sysrq_timer_list_show also needed to be updated to reflect the fact that
> now timer_list_show only does one cpu at at time.
> 
> ...
>
> --- a/kernel/time/timer_list.c
> +++ b/kernel/time/timer_list.c
> @@ -20,6 +20,13 @@
>  
>  #include <asm/uaccess.h>
>  
> +
> +struct timer_list_iter {
> +	int cpu;
> +	bool second_pass;
> +	u64 now;
> +};
> +
>  typedef void (*print_fn_t)(struct seq_file *m, unsigned int *classes);
>  
>  DECLARE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases);
> @@ -247,43 +254,101 @@ static void timer_list_show_tickdevices_header(struct seq_file *m)
>  }
>  #endif
>  
> -static int timer_list_show(struct seq_file *m, void *v)
> +static inline void timer_list_header(struct seq_file *m, u64 now)

There's really no point in the explicit inline directive - modern gcc's
basically ignore it anyway.

>  {
> -	u64 now = ktime_to_ns(ktime_get());
> -	int cpu;
> -
>  	SEQ_printf(m, "Timer List Version: v0.7\n");
>  	SEQ_printf(m, "HRTIMER_MAX_CLOCK_BASES: %d\n", HRTIMER_MAX_CLOCK_BASES);
>  	SEQ_printf(m, "now at %Ld nsecs\n", (unsigned long long)now);
>  	SEQ_printf(m, "\n");
> +}
>
> ...
>
> +void sysrq_timer_list_show(void)
> +{
> +	u64 now = ktime_to_ns(ktime_get());
> +	int cpu;
> +
> +	timer_list_header(NULL, now);
>  
>  	for_each_online_cpu(cpu)

hm, it seems this code is taking the optimistic approach to CPU hotplug.

> -		print_cpu(m, cpu, now);
> +		print_cpu(NULL, cpu, now);

