Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab3KGWdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 17:33:00 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:50874 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061Ab3KGWcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 17:32:54 -0500
Date: Thu, 7 Nov 2013 23:32:51 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/4] irq_work: Provide a irq work that can be processed
 on any cpu
Message-ID: <20131107223249.GB28130@localhost.localdomain>
References: <1383860919-1883-1-git-send-email-jack@suse.cz>
 <1383860919-1883-3-git-send-email-jack@suse.cz>
 <CAFTL4hxLXb3hZacx_EdHeKZVfrpuyGoNqpGbX997XJx0UJSwyg@mail.gmail.com>
 <20131107221904.GB2054@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131107221904.GB2054@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 11:19:04PM +0100, Jan Kara wrote:
> On Thu 07-11-13 23:13:39, Frederic Weisbecker wrote:
> > But then, who's going to process that work if every CPUs is idle?
>   Have a look into irq_work_queue(). There is:
>         /*
>          * If the work is not "lazy" or the tick is stopped, raise the irq
>          * work interrupt (if supported by the arch), otherwise, just wait
>          * for the next tick. We do this even for unbound work to make sure
>          * *some* CPU will be doing the work.
>          */
>         if (!(work->flags & IRQ_WORK_LAZY) || tick_nohz_tick_stopped()) {
>                 if (!this_cpu_cmpxchg(irq_work_raised, 0, 1))
>                         arch_irq_work_raise();
>         }
> 
>   So we raise an interrupt if there would be no timer ticking (which is
> what I suppose you mean by "CPU is idle"). That is nothing changed by my
> patches...

That said I agree that it would be nice to have smp_call_function_many() support
non waiting calls, something based on llist, that would be less deadlock prone
to begin with.
