Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760593Ab3D3Mya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 08:54:30 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:57788 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab3D3My2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 08:54:28 -0400
Date: Tue, 30 Apr 2013 14:54:24 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Olivier Langlois <olivier@trillion01.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/3] posix_timers: Defer per process timer stop after
 timers processing
Message-ID: <20130430125423.GB8272@somewhere>
References: <1366305822-5499-1-git-send-email-fweisbec@gmail.com>
 <1366305822-5499-3-git-send-email-fweisbec@gmail.com>
 <1366345802.2855.38.camel@Wailaba2>
 <CAFTL4hzTbko=jArO+kFF3icDbXmZzamDr1FJL3Vx+11Q54NABg@mail.gmail.com>
 <1366950479.7911.22.camel@Wailaba2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366950479.7911.22.camel@Wailaba2>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 12:27:59AM -0400, Olivier Langlois wrote:
> On Fri, 2013-04-19 at 14:47 +0200, Frederic Weisbecker wrote:
> 
> > 
> > >
> > > I might be mistaken but I believe that firing timers are not rescheduled
> > > in the current interrupt context. They are going to be rescheduled later
> > > from the task context handling the timer generated signal.
> > 
> > No, when the timer fires, it might generate a signal. But it won't
> > execute that signal right away in the same code path. Instead, after
> > signal generation, it may reschedule the timer if necessary then look
> > at the next firing timer in the list. This is all made from the same
> > timer interrupt context from the same call to run_posix_cpu_timers().
> > The signal itself is executed asynchronously. Either by interrupting a
> > syscall, or from the irq return path.
> > 
> Frederic, be careful with the interpretation, there are 2 locations from
> where posix_cpu_timer_schedule() can be called.
> 
> Call to posix_cpu_timer_schedule() from cpu_timer_fire() only happens if
> the signal isn't sent because it is ignored by the recipient.
> 
> Maybe the condition around the posix_cpu_timer_schedule() block inside
> cpu_timer_fire() could even be a good candidate for 'unlikely'
> qualifier.

Well, cpu_timer_fire() is probably not a fast path. So helping branch
prediction there probably won't have much measurable effect in practice.

> 
> IMO, a more likely scenario, posix_cpu_timer_schedule() will be called
> from dequeue_signal() which will be from from a different context than
> the interrupt context.

Oh you're right! I misunderstood that. So I need to take into consideration
for the nohz code.

> 
> At best, you have an interesting race!
> 
> dequeue_signal() is called when delivering a signal, not when it is
> generated, right?

Yeah you're right, sorry for the confusion. I'll reconsider your patches
with that in mind.

Thanks.
