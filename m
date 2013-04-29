Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932578Ab3D2VVA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 17:21:00 -0400
Received: from oproxy14-pub.unifiedlayer.com ([67.222.51.224]:60725 "HELO
	oproxy14-pub.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932336Ab3D2VU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 17:20:57 -0400
Message-ID: <1367270454.8833.45.camel@Wailaba2>
Subject: Re: [PATCH v2 1/3] process cputimer is moving faster than its
 corresponding clock
From: Olivier Langlois <olivier@trillion01.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, schwidefsky@de.ibm.com,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 29 Apr 2013 17:20:54 -0400
In-Reply-To: <517EC582.8090400@gmail.com>
References: <1365184746.874.103.camel@Wailaba2>
	 <1365593710.30071.52.camel@laptop> <1365608911.707.65.camel@Wailaba2>
	 <1365763837.17140.52.camel@laptop> <1365782115.17140.68.camel@laptop>
	 <CAFTL4hwQ4FZs0VCNXP37f=+DBW7Q2EQc6PW_EtYiVnZCPWN4OQ@mail.gmail.com>
	 <CAHGf_=pWPT4XdrJ8ZveL4zJKm1SE0whpL_fMHd5_TokuNQxSJQ@mail.gmail.com>
	 <CAHGf_=psD4V-U4FFwAWr4k3ZP6p=GVkNY_0S-Cg06m-=89MM7Q@mail.gmail.com>
	 <1366951210.7911.28.camel@Wailaba2> <1366957639.7911.42.camel@Wailaba2>
	 <517AD0AE.1030404@gmail.com> <1367037606.7911.66.camel@Wailaba2>
	 <517DFFE9.4050808@gmail.com> <1367255407.8833.4.camel@Wailaba2>
	 <517EB45D.60007@gmail.com> <1367259631.8833.27.camel@Wailaba2>
	 <517EBC71.4070709@gmail.com> <1367261667.8833.39.camel@Wailaba2>
	 <517EC582.8090400@gmail.com>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Identified-User: {5686:box610.bluehost.com:olivierl:trillion01.com} {sentby:smtp auth 173.178.230.31 authed with olivier@trillion01.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-29 at 15:09 -0400, KOSAKI Motohiro wrote:
> (4/29/13 2:54 PM), Olivier Langlois wrote:
> > On Mon, 2013-04-29 at 14:31 -0400, KOSAKI Motohiro wrote:
> >> (4/29/13 2:20 PM), Olivier Langlois wrote:
> >>>
> >>>>
> >>>>>> I'm confused. glibc's rt/tst-cputimer1 doesn't have thread exiting code. I have
> >>>>>> no seen any issue in this accounting.
> >>>>>
> >>>>> glibc launch a helper thread to receive timer signal and will also
> >>>>> create a new thread upon signal reception when a timer is created with
> >>>>> sigev_notify = SIGEV_THREAD;
> >>>>>
> >>>>> please see:
> >>>>>
> >>>>> glibc-2.17/nptl/sysdeps/unix/sysv/linux/timer_create.c
> >>>>> glibc-2.17/nptl/sysdeps/unix/sysv/linux/timer_routines.c
> >>>>
> >>>> I know. I taled thread exiting. not thread creating. And, as far as I can see, only test sig1 can fail,
> >>>> not thr[12].
> >>>>
> >>> Apart from glibc helper thread, the threads created for handling timer
> >>> firing all do exit immediatly as soon as user callback returns.
> >>
> >> And, libc ensure its exiting finished before starting actual tests. Why such thread exiting
> >> affect timers code? It shouldn't. becuase signal.cputimer is initialized timer_settime().
> >> The initialization is incorrect, we should fix initialization.
> > 
> > It doesn't have anything to do with initialisation.
> > 
> > Quick Quiz #1: How does the cputimer tick?
> > Answer: With calls to account_group_exec_runtime()
> 
> Only account when cputimer->running. Quick Quiz: When turn on cputimer->running?
> 
> 
> > Every task updates occuring after release_task() has been called in
> > do_exit() (scheduler ticks or the task final schedule() call) will be
> > lost because tasks stats are added to the global group stats located in
> > the signal struct in release_task() So every update after release_task()
> > will be lost but account_group_exec_runtime is still called.
> 
> tick lost doesn't occur an issue. because glibc only test posix conformance and
> posix allow inacculacy. In other words, timer must not run faster than real clock.
> but lost and makes slower are accepted in the test.
> 
What is lost isn't cputimer tick. They are accounted
account_group_exec_runtime(). What is lost it is what is added to
curr->sum_exec_runtime. Thus making the thread group clock running
slower than the cputimer.

Please spend some time reading the code and less time writing e-mails.

Read the code of release_task() and where it is called in do_exit().

Once it is done, it should be clear to you.


