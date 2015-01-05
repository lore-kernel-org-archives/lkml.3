Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbbAEXYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 18:24:21 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51253 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753031AbbAEXYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 18:24:19 -0500
Date: Mon, 5 Jan 2015 15:23:38 -0800
From: Shaohua Li <shli@fb.com>
To: Andy Lutomirski <luto@amacapital.net>
CC: Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, <Kernel-team@fb.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH v2 3/3] X86: Add a thread cpu time implementation to vDSO
Message-ID: <20150105232337.GA391887@devbig257.prn2.facebook.com>
References: <8559794d3a1924408a811a2881ab916fffb6015b.1418857018.git.shli@fb.com>
 <95a7ba1a95a6251439d5ca2d3d56fe7f0778cb95.1418857018.git.shli@fb.com>
 <CALCETrVyrOXNFk5OhPGukg+VmOEsHW93NLAd6LvkKFtV7H76kw@mail.gmail.com>
 <CALCETrV2+qkuj3WinOW-Ro_PjtZBhLaXwSHCeWpMpTJnog83EQ@mail.gmail.com>
 <20141219112350.GJ30905@twins.programming.kicks-ass.net>
 <CALCETrXRs5mXYq8OPH-WYqWPoD=35WccnHh7Bcm-YZMjW3ADcw@mail.gmail.com>
 <20141219170334.GM30905@twins.programming.kicks-ass.net>
 <20150102025953.GA1253265@devbig257.prn2.facebook.com>
 <CALCETrW=Z14X-TyOwsaMGKbY+w=JkUgjRFDsasBgWy83ZtkaeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CALCETrW=Z14X-TyOwsaMGKbY+w=JkUgjRFDsasBgWy83ZtkaeQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-05_04:2015-01-05,2015-01-05,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=21.5297862717038
 compositescore=0.928745990228454 urlsuspect_oldscore=0.928745990228454
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.928745990228454 spamscore=0
 recipient_to_sender_domain_totalscore=46 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1501050232
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2015 at 09:47:29AM -0800, Andy Lutomirski wrote:
> On Thu, Jan 1, 2015 at 6:59 PM, Shaohua Li <shli@fb.com> wrote:
> > On Fri, Dec 19, 2014 at 06:03:34PM +0100, Peter Zijlstra wrote:
> >> On Fri, Dec 19, 2014 at 08:48:07AM -0800, Andy Lutomirski wrote:
> >> > On Fri, Dec 19, 2014 at 3:23 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> >> > > On Thu, Dec 18, 2014 at 04:22:59PM -0800, Andy Lutomirski wrote:
> >> > >> Bad news: this patch is incorrect, I think.  Take a look at
> >> > >> update_rq_clock -- it does fancy things involving irq time and
> >> > >> paravirt steal time.  So this patch could result in extremely
> >> > >> non-monotonic results.
> >> > >
> >> > > Yeah, I'm not sure how (and if) we could make all that work :/
> >> >
> >> > I obviously can't comment on what Facebook needs, but if I were
> >> > rigging something up to profile my own code*, I'd want a count of
> >> > elapsed time, including user, system, and probably interrupt as well.
> >> > I would probably not want to count time during which I'm not
> >> > scheduled, and I would also probably not want to count steal time.
> >> > The latter makes any implementation kind of nasty.
> >> >
> >> > The API presumably doesn't need to be any particular clock id for
> >> > clock_gettime, and it may not even need to be clock_gettime at all.
> >> >
> >> > Is perf self-monitoring good enough for this?  If not, can we make it
> >> > good enough?
> >>
> >> Yeah, I think you should be able to use that. You could count a NOP
> >> event and simply use its activated time. We have PERF_COUNT_SW_DUMMY for
> >> such purposes iirc.
> >>
> >> The advantage of using perf self profiling is that it (obviously)
> >> extends to more than just walltime.
> >
> > Hi Peter & Andy,
> > I'm wondering how we could use the perf to implament a clock_gettime.
> > reading the perf fd or using ioctl is slow so reading the mmap
> > ringbuffer is the only option. But as far as I know the ringbuffer has
> > data only when an event is generated. Between two events, there is
> > nothing we can read from the ringbuffer. Then how can application get
> > time info in the interval?
> 
> Don't use the ringbuffer.  Instead, use a counting event, mmap it, and
> look at struct perf_event_mmap_page's comments to see how to read the
> time stamps.
> 
> There's some code here that does this:
> 
> https://github.com/andikleen/pmu-tools
> 
> but you won't actually need the rdpmc part, since you just want
> overall times instead of hardware event counts.

Good, it works. But the timestamp (.time_running and friends) only gets
updated for real hardware event between context switches. For software
event, the timestamp is initialized once, then never updated. If I use
it to get time, I actually get CLOCK_MONOTONIC. Hardware events work
well here, but depending on hardware event is too tricky, which I'd like
to avoid.

Thanks,
Shaohua
