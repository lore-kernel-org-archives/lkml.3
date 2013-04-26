Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab3DZE2I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 00:28:08 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:52629 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751374Ab3DZE2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 00:28:05 -0400
Message-ID: <1366950479.7911.22.camel@Wailaba2>
Subject: Re: [PATCH 2/3] posix_timers: Defer per process timer stop after
 timers processing
From: Olivier Langlois <olivier@trillion01.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
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
Date: Fri, 26 Apr 2013 00:27:59 -0400
In-Reply-To: <CAFTL4hzTbko=jArO+kFF3icDbXmZzamDr1FJL3Vx+11Q54NABg@mail.gmail.com>
References: <1366305822-5499-1-git-send-email-fweisbec@gmail.com>
	 <1366305822-5499-3-git-send-email-fweisbec@gmail.com>
	 <1366345802.2855.38.camel@Wailaba2>
	 <CAFTL4hzTbko=jArO+kFF3icDbXmZzamDr1FJL3Vx+11Q54NABg@mail.gmail.com>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Identified-User: {5686:box610.bluehost.com:olivierl:trillion01.com} {sentby:smtp auth 173.178.230.31 authed with olivier@trillion01.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-19 at 14:47 +0200, Frederic Weisbecker wrote:

> 
> >
> > I might be mistaken but I believe that firing timers are not rescheduled
> > in the current interrupt context. They are going to be rescheduled later
> > from the task context handling the timer generated signal.
> 
> No, when the timer fires, it might generate a signal. But it won't
> execute that signal right away in the same code path. Instead, after
> signal generation, it may reschedule the timer if necessary then look
> at the next firing timer in the list. This is all made from the same
> timer interrupt context from the same call to run_posix_cpu_timers().
> The signal itself is executed asynchronously. Either by interrupting a
> syscall, or from the irq return path.
> 
Frederic, be careful with the interpretation, there are 2 locations from
where posix_cpu_timer_schedule() can be called.

Call to posix_cpu_timer_schedule() from cpu_timer_fire() only happens if
the signal isn't sent because it is ignored by the recipient.

Maybe the condition around the posix_cpu_timer_schedule() block inside
cpu_timer_fire() could even be a good candidate for 'unlikely'
qualifier.

IMO, a more likely scenario, posix_cpu_timer_schedule() will be called
from dequeue_signal() which will be from from a different context than
the interrupt context.

At best, you have an interesting race!

dequeue_signal() is called when delivering a signal, not when it is
generated, right?

If you have a different understanding then please explain when call to
posix_cpu_timer_schedule() from dequeue_signal() will happen.


