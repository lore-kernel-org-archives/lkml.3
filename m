Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546AbaLSAb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 19:31:26 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58483 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751118AbaLSAbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 19:31:25 -0500
Date: Thu, 18 Dec 2014 16:30:44 -0800
From: Shaohua Li <shli@fb.com>
To: Andy Lutomirski <luto@amacapital.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, <Kernel-team@fb.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH v2 3/3] X86: Add a thread cpu time implementation to vDSO
Message-ID: <20141219003044.GA2804333@devbig257.prn2.facebook.com>
References: <8559794d3a1924408a811a2881ab916fffb6015b.1418857018.git.shli@fb.com>
 <95a7ba1a95a6251439d5ca2d3d56fe7f0778cb95.1418857018.git.shli@fb.com>
 <CALCETrVyrOXNFk5OhPGukg+VmOEsHW93NLAd6LvkKFtV7H76kw@mail.gmail.com>
 <CALCETrV2+qkuj3WinOW-Ro_PjtZBhLaXwSHCeWpMpTJnog83EQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CALCETrV2+qkuj3WinOW-Ro_PjtZBhLaXwSHCeWpMpTJnog83EQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-18_07:2014-12-18,2014-12-18,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=21.5297862717038
 compositescore=0.928745990228454 urlsuspect_oldscore=0.928745990228454
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.928745990228454 spamscore=0
 recipient_to_sender_domain_totalscore=46 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412190004
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 04:22:59PM -0800, Andy Lutomirski wrote:
> On Thu, Dec 18, 2014 at 3:30 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> > On Wed, Dec 17, 2014 at 3:12 PM, Shaohua Li <shli@fb.com> wrote:
> >> This primarily speeds up clock_gettime(CLOCK_THREAD_CPUTIME_ID, ..). We
> >> use the following method to compute the thread cpu time:
> >>
> >>     t0 = process start
> >>     t1 = most recent context switch time
> >>     t2 = time at which the vsyscall is invoked
> >>
> >>     thread_cpu_time = sum(time slices between t0 to t1) + (t2 - t1)
> >>                 = current->se.sum_exec_runtime + now - sched_clock()
> >>
> >> At context switch time We stash away
> >>
> >>     adj_sched_time = sum_exec_runtime - sched_clock()
> >>
> >> in a per-cpu struct in the VVAR page and then compute
> >>
> >>     thread_cpu_time = adj_sched_time + now
> >>
> >> All computations are done in nanosecs on systems where TSC is stable. If
> >> TSC is unstable, we fallback to a regular syscall.
> >>     Benchmark data:
> >>
> >>     for (i = 0; i < 100000000; i++) {
> >>             clock_gettime(CLOCK_THREAD_CPUTIME_ID, &ts);
> >>             sum += ts.tv_sec * NSECS_PER_SEC + ts.tv_nsec;
> >>     }
> >
> > A bunch of the time spent processing a CLOCK_THREAD_CPUTIME_ID syscall
> > is spent taking various locks, and I think it could be worth adding a
> > fast path for the read-my-own-clock case in which we just disable
> > preemption and read the thing without any locks.
> >
> > If we're actually going to go the vdso route, I'd like to make the
> > scheduler hooks clean.  Peterz and/or John, what's the right way to
> > get an arch-specific callback with sum_exec_runtime and an up to date
> > sched_clock value during a context switch?  I'd much rather not add
> > yet another rdtsc instruction to the scheduler.
> 
> Bad news: this patch is incorrect, I think.  Take a look at
> update_rq_clock -- it does fancy things involving irq time and
> paravirt steal time.  So this patch could result in extremely
> non-monotonic results.

Yes, it's not precise. But bear in mind, CONFIG_IRQ_TIME_ACCOUNTING is a
optional feature. Actually it's added not long time ago. I thought it's
acceptable the time isn't precise just like what we have before the
feature is added.

Thanks,
Shaohua
