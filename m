Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbaEBTBr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 15:01:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:43783 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbaEBTBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 15:01:46 -0400
Date: Fri, 2 May 2014 21:01:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
cc: Steven Rostedt <rostedt@goodmis.org>, Stanislav Meduna <stano@meduna.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: BUG: spinlock trylock failure on UP, i.MX28 3.12.15-rt25
In-Reply-To: <20140502183824.GH9178@linutronix.de>
Message-ID: <alpine.DEB.2.02.1405022100351.6261@ionos.tec.linutronix.de>
References: <534C3606.7010206@meduna.org> <534C731F.1050406@meduna.org> <534DADF1.6060608@meduna.org> <20140422115439.GA20669@linutronix.de> <20140422094657.5b6ca1e2@gandalf.local.home> <53569E05.8010600@linutronix.de> <20140422134802.73fc1fa4@gandalf.local.home>
 <20140422141650.7f43d5ba@gandalf.local.home> <20140502183824.GH9178@linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 May 2014, Sebastian Andrzej Siewior wrote:
> * Steven Rostedt | 2014-04-22 14:16:50 [-0400]:
> > /*
> >  * Called by the local, per-CPU timer interrupt on SMP.
> >  */
> >@@ -1467,7 +1473,7 @@ void run_local_timers(void)
> > 		return;
> > 	}
> > 
> >-	if (!spin_do_trylock(&base->lock)) {
> >+	if (timer_should_raise_softirq(&base->lock)) {
> > 		raise_softirq(TIMER_SOFTIRQ);
> > 		return;
> > 	}
> 
> Okay. So Peter said that it is okay to apply this since FULL_NO_HZ users
> wouldn't complain on UP. I still wouldn't say it is broken but that is a
> different story.
> We have two users of this trylock. run_local_timers() which pops up
> quite often (and you patched here) and the other is
> get_next_timer_interrupt(). What do you suggest we do here? It is
> basically the same thing.

It's different as it CANNOT fail on UP. That's called from the idle
code and there is no way that anything holds that lock on UP when idle
runs.

Thanks,

	tglx
