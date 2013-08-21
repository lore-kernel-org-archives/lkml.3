Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab3HUR0E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 13:26:04 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:44105 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab3HUR0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 13:26:01 -0400
Message-ID: <5214F825.8010504@linaro.org>
Date: Wed, 21 Aug 2013 10:25:57 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Don Zickus <dzickus@redhat.com>
Subject: Re: [RFC PATCH 6/6] timekeeping: Debug missing timekeeping updates
References: <1377103341-15235-1-git-send-email-fweisbec@gmail.com> <1377103341-15235-7-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1377103341-15235-7-git-send-email-fweisbec@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2013 09:42 AM, Frederic Weisbecker wrote:
> With the full dynticks feature and the tricky full system idle
> detection code that is coming soon, it becomes necessary to have
> some debug code that makes sure that the timekeeping is always
> maintained and moving forward as expected.
>
> This provides a simple detection of missing timekeeping updates
> inspired by the lockup detector's use of CPU cycles clock.
>
> The jiffies are compared to the cpu clock after several snapshots taken
> from NMIs that trigger after arbitrary CPU cycles period overflow.
>
> If the jiffies progression appears to drift too far away from the CPU
> clock's, this triggers a warning.
>
> We just make sure not to account the tiny code on irq entry that
> may have stale jiffies values before tick_check_nohz() is called
> after the CPU is woken up while the system went full idle for some
> time.
>
> Same goes for idle exit in case the tick were stopped but idle
> was polling on need_resched().

So you're using sched_clock to try to detect timekeeping
inconsistencies. Hrm.. Do you have some examples of where this debug
infrastructure helped out?

A few thoughts:

1) Why are you using jiffies as the timekeeping reference instead of
reading some of actual timekeeping values? Jiffies usage has been
intentionally on the decline, and since the dynticks infrastructure
landed, jiffies are just derived from the timekeeping core, so its so
its sort of strange to see it used for this.

2) This seems very similar to the old lost-ticks compensation code we
had prior to the clocksource infrastructure, and seems like it might
suffer from some of the issues seen there. For instance, sched_clock has
been historically looser in its correctness requirements then the
timekeeping code, so using it to validate the more strict timekeeping
code, makes me worry we might see cases of false positives.

3) I'm also curious (maybe skeptical) as if sched_clock is reliable
enough to use for validating time, then we likely are using that same
hardware as the timekeeping clocksource. Thus cases where I'd suspect
you'd see likely issues w/ nohz, like clocksource counter overflows
being missed on quick wrapping clcoksources wouldn't really apply.


Personally, I've been thinking the timekeeping update code could use
some improvements/warnings around cases where update delay is larger
then the clocksource max_deferment - possibly falling back to a slower
overflow-proof multiply as is done in the CLOCK_SOURCE_SUSPEND_NONSTOP
resume case. This would allow more robust behaivor in cases like kvm
guests being paused for unreasonable lengths of time, and could also
provide very similar NOHZ debug warnings (assuming the clocksource
doesn't wrap quickly - but again, in those cases, I'm not confident we
can trust sched_clock either).


thanks
-john

