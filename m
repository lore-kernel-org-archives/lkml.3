Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477Ab3EKCkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 22:40:36 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:40181 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956Ab3EKCkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 22:40:35 -0400
MIME-Version: 1.0
In-Reply-To: <20130511001756.GA13340@somewhere>
References: <1367556468-4021-1-git-send-email-kosaki.motohiro@gmail.com>
 <1367556468-4021-3-git-send-email-kosaki.motohiro@gmail.com>
 <20130506234717.GA1703@somewhere> <1367896600.14310.49.camel@Wailaba2> <20130511001756.GA13340@somewhere>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Fri, 10 May 2013 22:40:09 -0400
Message-ID: <CAHGf_=r=k3hTsZDGWpfnAcpV=LXyPRzV3LDxoKLM6fRcRQB_Aw@mail.gmail.com>
Subject: Re: [PATCH 1/7] posix-cpu-timers: don't account cpu timer after
 stopped thread runtime accounting
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Olivier Langlois <olivier@trillion01.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 8:17 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Mon, May 06, 2013 at 11:16:40PM -0400, Olivier Langlois wrote:
>> On Tue, 2013-05-07 at 01:47 +0200, Frederic Weisbecker wrote:
>> > On Fri, May 03, 2013 at 12:47:42AM -0400, kosaki.motohiro@gmail.com wrote:
>> > > From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> > >
>> > > When tsk->signal->cputimer->running is 1, signal->cputimer and
>> > > tsk->sum_sched_runtime increase at the same pace because update_curr()
>> > > increases both accounting.
>> > >
>> > > However, there is one exception. When thread exiting, __exit_signal() turns
>> > > over task's sum_shced_runtime to sig->sum_sched_runtime, but it doesn't stop
>> > > signal->cputimer accounting.
>> > >
>> > > This inconsistency makes POSIX timer wake up too early. This patch fixes it.
>> > >
>> > > Cc: Thomas Gleixner <tglx@linutronix.de>
>> > > Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> > > Cc: Ingo Molnar <mingo@kernel.org>
>> > > Acked-by: Peter Zijlstra <peterz@infradead.org>
>> > > Signed-off-by: Olivier Langlois <olivier@trillion01.com>
>> > > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> > > ---
>> > >  kernel/sched/stats.h |    7 +++++++
>> > >  1 files changed, 7 insertions(+), 0 deletions(-)
>> > >
>> > > diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
>> > > index 2ef90a5..5a0cfc4 100644
>> > > --- a/kernel/sched/stats.h
>> > > +++ b/kernel/sched/stats.h
>> > > @@ -225,6 +225,13 @@ static inline void account_group_exec_runtime(struct task_struct *tsk,
>> > >       if (!cputimer->running)
>> > >               return;
>> > >
>> > > +     /*
>> > > +      * After turning over se.sum_exec_runtime to sig->sum_sched_runtime
>> > > +      * in __exit_signal(), we must not account exec_runtime for consistency.
>> > > +      */
>
> Please just precise the nature of that consistency: the fact we want CLOCK_PROCESS_CPUTIME_ID
> clock and timer to be consistent.

typo? This patch fixes an inconsistency between a thread cputime and a
process cputime.

How is this?

/*
* After turning over se.sum_exec_runtime to sig->sum_sched_runtime
* in __exit_signal(), a per-thread cputime of the thread will be lost. We
* must not account exec_runtime here too because we need to keep
* consistent cputime between per-thread and per-process. Otherwise,
* the inconsistency is observable when single thread program run.
*/
