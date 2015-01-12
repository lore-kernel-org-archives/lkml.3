Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbbALTvH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:51:07 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46925 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751691AbbALTvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 14:51:05 -0500
Date: Mon, 12 Jan 2015 11:50:18 -0800
From: Shaohua Li <shli@fb.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Andy Lutomirski <luto@amacapital.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, <Kernel-team@fb.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH v2 3/3] X86: Add a thread cpu time implementation to vDSO
Message-ID: <20150112195018.GB3262197@devbig257.prn2.facebook.com>
References: <95a7ba1a95a6251439d5ca2d3d56fe7f0778cb95.1418857018.git.shli@fb.com>
 <CALCETrVyrOXNFk5OhPGukg+VmOEsHW93NLAd6LvkKFtV7H76kw@mail.gmail.com>
 <CALCETrV2+qkuj3WinOW-Ro_PjtZBhLaXwSHCeWpMpTJnog83EQ@mail.gmail.com>
 <20141219112350.GJ30905@twins.programming.kicks-ass.net>
 <CALCETrXRs5mXYq8OPH-WYqWPoD=35WccnHh7Bcm-YZMjW3ADcw@mail.gmail.com>
 <20141219170334.GM30905@twins.programming.kicks-ass.net>
 <20150102025953.GA1253265@devbig257.prn2.facebook.com>
 <CALCETrW=Z14X-TyOwsaMGKbY+w=JkUgjRFDsasBgWy83ZtkaeQ@mail.gmail.com>
 <20150105232337.GA391887@devbig257.prn2.facebook.com>
 <20150106101839.GN29390@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20150106101839.GN29390@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-12_03:2015-01-12,2015-01-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=21.5297862717038
 compositescore=0.928745990228454 urlsuspect_oldscore=0.928745990228454
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.928745990228454 spamscore=0
 recipient_to_sender_domain_totalscore=46 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1501120206
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 11:18:39AM +0100, Peter Zijlstra wrote:
> On Mon, Jan 05, 2015 at 03:23:38PM -0800, Shaohua Li wrote:
> > Good, it works. But the timestamp (.time_running and friends) only gets
> > updated for real hardware event between context switches. For software
> > event, the timestamp is initialized once, then never updated. If I use
> > it to get time, I actually get CLOCK_MONOTONIC. Hardware events work
> > well here, but depending on hardware event is too tricky, which I'd like
> > to avoid.
> 
> Hmm, that's an unfortunate difference in behaviour, does something like
> the below cure that for you?

Hi Peter,
can we push these to upstream? It works very well here.

Thanks,
Shaohua
 
> ---
>  kernel/events/core.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 4c1ee7f2bebc..0feb4e039359 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -5965,11 +5965,13 @@ static void perf_swevent_del(struct perf_event *event, int flags)
>  static void perf_swevent_start(struct perf_event *event, int flags)
>  {
>  	event->hw.state = 0;
> +	perf_event_update_userpage(event);
>  }
>  
>  static void perf_swevent_stop(struct perf_event *event, int flags)
>  {
>  	event->hw.state = PERF_HES_STOPPED;
> +	perf_event_update_userpage(event);
>  }
>  
>  /* Deref the hlist from the update side */
> @@ -6410,12 +6412,14 @@ static void cpu_clock_event_start(struct perf_event *event, int flags)
>  {
>  	local64_set(&event->hw.prev_count, local_clock());
>  	perf_swevent_start_hrtimer(event);
> +	perf_event_update_userpage(event);
>  }
>  
>  static void cpu_clock_event_stop(struct perf_event *event, int flags)
>  {
>  	perf_swevent_cancel_hrtimer(event);
>  	cpu_clock_event_update(event);
> +	perf_event_update_userpage(event);
>  }
>  
>  static int cpu_clock_event_add(struct perf_event *event, int flags)
> @@ -6484,12 +6488,14 @@ static void task_clock_event_start(struct perf_event *event, int flags)
>  {
>  	local64_set(&event->hw.prev_count, event->ctx->time);
>  	perf_swevent_start_hrtimer(event);
> +	perf_event_update_userpage(event);
>  }
>  
>  static void task_clock_event_stop(struct perf_event *event, int flags)
>  {
>  	perf_swevent_cancel_hrtimer(event);
>  	task_clock_event_update(event, event->ctx->time);
> +	perf_event_update_userpage(event);
>  }
>  
>  static int task_clock_event_add(struct perf_event *event, int flags)
