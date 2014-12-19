Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbaLSSRA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 13:17:00 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57470 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751142AbaLSSQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 13:16:58 -0500
Date: Fri, 19 Dec 2014 10:16:13 -0800
From: Shaohua Li <shli@fb.com>
To: Andy Lutomirski <luto@amacapital.net>
CC: Chris Mason <clm@fb.com>, Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, <Kernel-team@fb.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH v2 3/3] X86: Add a thread cpu time implementation to vDSO
Message-ID: <20141219181613.GA86430@devbig257.prn2.facebook.com>
References: <8559794d3a1924408a811a2881ab916fffb6015b.1418857018.git.shli@fb.com>
 <95a7ba1a95a6251439d5ca2d3d56fe7f0778cb95.1418857018.git.shli@fb.com>
 <CALCETrVyrOXNFk5OhPGukg+VmOEsHW93NLAd6LvkKFtV7H76kw@mail.gmail.com>
 <CALCETrV2+qkuj3WinOW-Ro_PjtZBhLaXwSHCeWpMpTJnog83EQ@mail.gmail.com>
 <20141219112350.GJ30905@twins.programming.kicks-ass.net>
 <CALCETrXRs5mXYq8OPH-WYqWPoD=35WccnHh7Bcm-YZMjW3ADcw@mail.gmail.com>
 <1419010969.13012.7@mail.thefacebook.com>
 <CALCETrUaYkVtbxOHwsAe35L_Mfr3YLMnwX_FbR4D+EjNiuHwaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CALCETrUaYkVtbxOHwsAe35L_Mfr3YLMnwX_FbR4D+EjNiuHwaQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-19_05:2014-12-19,2014-12-19,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=13.4417604359027
 compositescore=0.923639739835017 urlsuspect_oldscore=0.923639739835017
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.923639739835017 spamscore=0
 recipient_to_sender_domain_totalscore=35 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412190174
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 09:53:24AM -0800, Andy Lutomirski wrote:
> On Fri, Dec 19, 2014 at 9:42 AM, Chris Mason <clm@fb.com> wrote:
> >
> >
> > On Fri, Dec 19, 2014 at 11:48 AM, Andy Lutomirski <luto@amacapital.net>
> > wrote:
> >>
> >> On Fri, Dec 19, 2014 at 3:23 AM, Peter Zijlstra <peterz@infradead.org>
> >> wrote:
> >>>
> >>>  On Thu, Dec 18, 2014 at 04:22:59PM -0800, Andy Lutomirski wrote:
> >>>>
> >>>>  Bad news: this patch is incorrect, I think.  Take a look at
> >>>>  update_rq_clock -- it does fancy things involving irq time and
> >>>>  paravirt steal time.  So this patch could result in extremely
> >>>>  non-monotonic results.
> >>>
> >>>
> >>>  Yeah, I'm not sure how (and if) we could make all that work :/
> >>
> >>
> >> I obviously can't comment on what Facebook needs, but if I were
> >> rigging something up to profile my own code*, I'd want a count of
> >> elapsed time, including user, system, and probably interrupt as well.
> >> I would probably not want to count time during which I'm not
> >> scheduled, and I would also probably not want to count steal time.
> >> The latter makes any implementation kind of nasty.
> >>
> >> The API presumably doesn't need to be any particular clock id for
> >> clock_gettime, and it may not even need to be clock_gettime at all.
> >>
> >> Is perf self-monitoring good enough for this?  If not, can we make it
> >> good enough?
> >>
> >> * I do this today using CLOCK_MONOTONIC
> >
> >
> > The clock_gettime calls are used for a wide variety of things, but usually
> > they are trying to instrument how much CPU the application is using.  So for
> > example with the HHVM interpreter they have a ratio of the number of hhvm
> > instructions they were able to execute in N seconds of cputime.  This gets
> > used to optimize the HHVM implementation and can be used as a push blocking
> > counter (code can't go in if it makes it slower).
> >
> > Wall time isn't a great representation of this because it includes factors
> > that might be outside a given HHVM patch, but it sounds like we're saying
> > almost the same thing.
> >
> > I'm not familiar with the perf self monitoring?
> 
> You can call perf_event_open and mmap the result.  Then you can read
> the docs^Wheader file.
> 
> On the god side, it's an explicit mmap, so all the nasty preemption
> issues are entirely moot.  And you can count cache misses and such if
> you want to be fancy.
> 
> On the bad side, the docs are a bit weak, and the added context switch
> overhead might be higher.

I'll measure the overhead for sure. If overhead isn't high, the perf
approach is very interesting. On the other hand, is it acceptable the
clock_gettime fallbacks to slow path if irq time is enabled (it's
overhead is high, we don't enable it actually)?

Thanks,
Shaohua
