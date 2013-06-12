Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab3FLXF0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 19:05:26 -0400
Received: from forward18.mail.yandex.net ([95.108.253.143]:53347 "EHLO
	forward18.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758133Ab3FLXFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 19:05:25 -0400
X-Greylist: delayed 381 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Jun 2013 19:05:25 EDT
Authentication-Results: smtp19.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <1371078380.20762.29.camel@hp>
Subject: Re: [PATCH] spin_unlock*_no_resched()
From: Kirill Tkhai <tkhai@yandex.ru>
Reply-To: tkhai@yandex.ru
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, tglx@linutronix.de
Date: Thu, 13 Jun 2013 03:06:20 +0400
In-Reply-To: <1371042443.9844.255.camel@gandalf.local.home>
References: <1022041371038807@web30d.yandex.ru>
	 <20130612121532.GD3204@twins.programming.kicks-ass.net>
	 <1371042443.9844.255.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-12 at 09:07 -0400, Steven Rostedt wrote:
> On Wed, 2013-06-12 at 14:15 +0200, Peter Zijlstra wrote:
> 
> > So I absolutely hate this API because people can (and invariably will)
> > abuse it; much like they did/do preempt_enable_no_resched().
> 
> Me too.
> 
> > 
> > IIRC Thomas even maps preempt_enable_no_resched() to preempt_enable() in
> > -rt to make sure we don't miss preemption points due to stupidity.
> > 
> > He converted the 'few' sane sites to use schedule_preempt_disabled(). In
> > that vein, does it make sense to introduce schedule_spin_locked()?
> > 
> 
> I was thinking the exact same thing when I read this patch. This is a
> strict policy that we should enforce and not let individual developers
> implement. Yes, a schedule_spin_unlock() would work nicely. The API will
> enforce the two to be used together.

Steven thanks for your explanation and Peter's, now I looked to this
from another side.

If we speak about combined primitive does it have to be a special
variant of schedule_spin_unlock_* for every irq state? The simplest way
is to do local_irq_enable() always before schedule() call, but I'm not
sure that this is good for all platforms.

For -rt everything of this is completely useless, because number of
raw_spin_locks is small. Maybe changes for some another types of locks
will applicable.

Kirill

> Otherwise, I can envision seeing
> things like:
> 
> 	preempt_disable();
> 	[...]
> 
> 	spin_lock(x);
> 
> 	spin_unlock_no_resched(x);
> 
> 	[...]
> 
> 	preempt_enable();
> 
> And developers having no idea why the above is broken. Although, I would
> say the above is broken for other reasons, but I was just using that to
> show the craziness such an API would give to us.
> 
> -- Steve
> 
> 
> 



