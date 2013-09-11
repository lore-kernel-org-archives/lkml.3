Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab3IKRtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 13:49:09 -0400
Received: from mail.openrapids.net ([64.15.138.104]:43486 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753203Ab3IKRtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 13:49:07 -0400
Date: Wed, 11 Sep 2013 13:49:02 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org
Subject: Re: [RFC PATCH] timekeeping: introduce timekeeping_is_busy()
Message-ID: <20130911174902.GA23532@Krystal>
References: <20130911150853.GA19800@Krystal> <52309D13.3020305@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52309D13.3020305@linaro.org>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

* John Stultz (john.stultz@linaro.org) wrote:
> On 09/11/2013 08:08 AM, Mathieu Desnoyers wrote:
> > Starting from commit 06c017fdd4dc48451a29ac37fc1db4a3f86b7f40
> > "timekeeping: Hold timekeepering locks in do_adjtimex and hardpps"
> > (3.10 kernels), the xtime write seqlock is held across calls to
> > __do_adjtimex(), which includes a call to notify_cmos_timer(), and hence
> > schedule_delayed_work().
> >
> > This introduces a side-effect for a set of tracepoints, including mainly
> > the workqueue tracepoints: a tracer hooking on those tracepoints and
> > reading current time with ktime_get() will cause hard system LOCKUP such
> > as:
> Oh bummer. I had just worked this issue out the other day:
>     https://lkml.org/lkml/2013/9/9/476
>
> Apparently it was a schroedinbug of sorts. My apologies for time you
> spent chasing this down.

No worries. As soon as I've been able to reproduce it on my test box
(with serial port), the NMI watchdog had a pretty reasonable explanation
for the issue.

> My plan is to pull the notify_cmos_timer call to outside of the
> timekeeper locking (see the patch at the very end of the mail in the
> above link), as well as try to add lockdep support to seqcount/seqlocks
> so we can catch these sorts of issues more easily.

I just tried your patch, and it indeed seems to fix the lockup I've been
experiencing with lttng-modules. Do you plan pushing this fix into
master, and submitting it for inclusion into stable 3.10 and stable 3.11 ?
I'm planning on dealing with with this issue with a blacklist of
kernel versions that will prevent people from building lttng-modules
against broken kernels as soon as the patch makes it into those trees.

I will reply to the rest of your email separately, so this thread can
focus on getting the fix upstream quickly.

Thanks!

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
