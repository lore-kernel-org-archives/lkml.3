Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693AbbABDAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2015 22:00:42 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33229 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751522AbbABDAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2015 22:00:38 -0500
Date: Thu, 1 Jan 2015 18:59:53 -0800
From: Shaohua Li <shli@fb.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Andy Lutomirski <luto@amacapital.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, <Kernel-team@fb.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH v2 3/3] X86: Add a thread cpu time implementation to vDSO
Message-ID: <20150102025953.GA1253265@devbig257.prn2.facebook.com>
References: <8559794d3a1924408a811a2881ab916fffb6015b.1418857018.git.shli@fb.com>
 <95a7ba1a95a6251439d5ca2d3d56fe7f0778cb95.1418857018.git.shli@fb.com>
 <CALCETrVyrOXNFk5OhPGukg+VmOEsHW93NLAd6LvkKFtV7H76kw@mail.gmail.com>
 <CALCETrV2+qkuj3WinOW-Ro_PjtZBhLaXwSHCeWpMpTJnog83EQ@mail.gmail.com>
 <20141219112350.GJ30905@twins.programming.kicks-ass.net>
 <CALCETrXRs5mXYq8OPH-WYqWPoD=35WccnHh7Bcm-YZMjW3ADcw@mail.gmail.com>
 <20141219170334.GM30905@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141219170334.GM30905@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-02_01:2014-12-31,2015-01-02,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=13.4417604359027
 compositescore=0.923639739835017 urlsuspect_oldscore=0.923639739835017
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.923639739835017 spamscore=0
 recipient_to_sender_domain_totalscore=35 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1501020031
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 06:03:34PM +0100, Peter Zijlstra wrote:
> On Fri, Dec 19, 2014 at 08:48:07AM -0800, Andy Lutomirski wrote:
> > On Fri, Dec 19, 2014 at 3:23 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > > On Thu, Dec 18, 2014 at 04:22:59PM -0800, Andy Lutomirski wrote:
> > >> Bad news: this patch is incorrect, I think.  Take a look at
> > >> update_rq_clock -- it does fancy things involving irq time and
> > >> paravirt steal time.  So this patch could result in extremely
> > >> non-monotonic results.
> > >
> > > Yeah, I'm not sure how (and if) we could make all that work :/
> > 
> > I obviously can't comment on what Facebook needs, but if I were
> > rigging something up to profile my own code*, I'd want a count of
> > elapsed time, including user, system, and probably interrupt as well.
> > I would probably not want to count time during which I'm not
> > scheduled, and I would also probably not want to count steal time.
> > The latter makes any implementation kind of nasty.
> > 
> > The API presumably doesn't need to be any particular clock id for
> > clock_gettime, and it may not even need to be clock_gettime at all.
> > 
> > Is perf self-monitoring good enough for this?  If not, can we make it
> > good enough?
> 
> Yeah, I think you should be able to use that. You could count a NOP
> event and simply use its activated time. We have PERF_COUNT_SW_DUMMY for
> such purposes iirc.
> 
> The advantage of using perf self profiling is that it (obviously)
> extends to more than just walltime.

Hi Peter & Andy,
I'm wondering how we could use the perf to implament a clock_gettime.
reading the perf fd or using ioctl is slow so reading the mmap
ringbuffer is the only option. But as far as I know the ringbuffer has
data only when an event is generated. Between two events, there is
nothing we can read from the ringbuffer. Then how can application get
time info in the interval?

Thanks,
Shaohua
