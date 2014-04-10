Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935610AbaDJO42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 10:56:28 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:48029 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934661AbaDJO41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 10:56:27 -0400
Date: Thu, 10 Apr 2014 16:56:23 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Subject: Re: [Query]: tick-sched: can idle_active be false in
 tick_nohz_idle_exit()?
Message-ID: <20140410145621.GC27654@localhost.localdomain>
References: <CAKohpon3vJzL51V9aOBcXKJC4nr3K-0q77HsxFi+=ACUqNqhcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpon3vJzL51V9aOBcXKJC4nr3K-0q77HsxFi+=ACUqNqhcA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 05:28:57PM +0530, Viresh Kumar wrote:
> Hi Guys,
> 
> File: kernel/time/tick-sched.c
> function: tick_nohz_idle_exit()
> 
> We are checking here if idle_active is true or not and then
> do some stuff. But is it possible that idle_active be false
> here?
> 
> The sequence as far as I understood is:
> idle-loop:
> 
> tick_nohz_idle_enter(), i.e. idle_active = true;
> local_irq_disable()
> 
> IDLE
> .
> .
> 
> wake up due to IPI ??
> 
> local_irq_enable()
>     tick_nohz_irq_enter(), i.e. idle_active = false;
>     tick_nohz_irq_exit(), i.e. idle_active = true;
> 
> tick_nohz_idle_exit()
> 
> How can idle_active be false here?

When a dynticks idle CPU is woken up (typically with an IPI), tick_nohz_stop_idle()
is called on interrupt entry but, because this is a waking up IPI, tick_nohz_start_idle()
won't be called. The reason is that need_resched() prevents tick_nohz_irq_exit() to be
called in irq_exit().

After all if we know that the CPU is going to exit the idle task, we don't need to account
any more idle time. We also don't need to retry to enter in dynticks idle mode since we
are going to restart the tick with tick_nohz_idle_exit().

So in case of wake up IPIs, we may end up with !ts->idle_active in tick_nohz_idle_exit() :)

I must confess this is not obvious. It confused me as well when I met that part. A small
comment in tick_nohz_idle_exit() would be welcome ;)

Thanks.

> 
> --
> viresh
