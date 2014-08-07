Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439AbaHGM67 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 08:58:59 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:62220 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbaHGM66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 08:58:58 -0400
Date: Thu, 7 Aug 2014 14:58:55 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: WARN_ON_ONCE(in_nmi()) hit in irq_work_queue_on
Message-ID: <20140807125852.GA19662@localhost.localdomain>
References: <20140806162113.GC14261@redhat.com>
 <20140806164633.GY3935@laptop>
 <20140806165610.GB12054@laptop.lan>
 <20140806170151.GC12054@laptop.lan>
 <20140806234456.GA17015@localhost.localdomain>
 <20140807081321.GI19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140807081321.GI19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 10:13:21AM +0200, Peter Zijlstra wrote:
> On Thu, Aug 07, 2014 at 01:44:58AM +0200, Frederic Weisbecker wrote:
> > In fact the problem has arised since the recent irq work patches I did.
> 
> No, those just added the WARN, previously we send the resched IPI, and
> that's equally wrong from NMI context.

Well the scheduler IPI was rather used for remote kicks before we had remote irq
work. This includes local kicks as well as the caller could need to kick
anywhere. As in inc_nr_running().

But for strict local kicks, as in perf, we were using tick_nohz_full_kick() which has
been using irq work for a while. But it got broken when we replaced it to call irq_work_queue_on
instead of irq_work_queue.

> 
> > There I've changed tick_nohz_full_kick() to use irq_work_queue_on() instead
> > of irq_work_queue() so it has become NMI unsafe by accident.
> > 
> > So I'd rather suggest this instead of queuing two levels of irq_work:
> 
> > +void tick_nohz_full_kick(void)
> > +{
> > +	if (!tick_nohz_full_cpu(smp_processor_id()))
> > +		irq_work_queue(&__get_cpu_var(nohz_full_kick_work));
> > +}
> 
> Indeed, that's better. Thanks!


