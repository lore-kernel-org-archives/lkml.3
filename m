Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab3HRVr0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 17:47:26 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59604 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754861Ab3HRVrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 17:47:25 -0400
Date: Sun, 18 Aug 2013 23:47:21 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 3/4] nohz: Consolidate sleep time stats read code
Message-ID: <20130818214720.GD22640@somewhere>
References: <1376667753-29014-1-git-send-email-fweisbec@gmail.com>
 <1376667753-29014-4-git-send-email-fweisbec@gmail.com>
 <20130818170001.GC21310@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130818170001.GC21310@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 18, 2013 at 07:00:01PM +0200, Oleg Nesterov wrote:
> On 08/16, Frederic Weisbecker wrote:
> >
> > get_cpu_idle_time_us() and get_cpu_iowait_time_us() mostly share
> > the same code. Lets consolidate both implementations.
> 
> Personally I like every patch which consolidates the code ;)
> 
> >  	do {
> >  		seq = read_seqcount_begin(&ts->sleeptime_seq);
> > -		if (ts->idle_active && !nr_iowait_cpu(cpu)) {
> > +		if (io)
> > +			sleep = ts->iowait_sleeptime;
> > +		else
> > +			sleep = ts->idle_sleeptime;
> > +
> > +		if (ts->idle_active)
> > +			continue;
> > +
> > +		if ((io && nr_iowait_cpu(cpu)) || (!io && !nr_iowait_cpu(cpu))) {
> >  			ktime_t delta = ktime_sub(now, ts->idle_entrytime);
> > -			idle = ktime_add(ts->idle_sleeptime, delta);
> > -		} else {
> > -			idle = ts->idle_sleeptime;
> > +			sleep = ktime_add(sleep, delta);
> >  		}
> >  	} while (read_seqcount_retry(&ts->sleeptime_seq, seq));
> 
> Cosmetic/subjective, feel free to ignore. but perhaps
> 
> 		if (ts->idle_active && io == !!nr_iowait_cpu(cpu)) {
> 			...
> 		}
> 
> looks more understandable.

Agreed, that's much better.

thanks!

> 
> Oleg.
> 
