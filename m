Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294AbaBUUQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 15:16:40 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:39824 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937AbaBUUQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 15:16:38 -0500
Date: Fri, 21 Feb 2014 15:18:38 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Vince Weaver <vincent.weaver@maine.edu>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: x86_pmu_start WARN_ON.
In-Reply-To: <20140221150312.GF3104@twins.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1402211514560.6395@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1402131234160.22113@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402131700090.24354@vincent-weaver-1.um.maine.edu> <20140217152859.GF15586@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1402181327400.31682@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402181717300.20073@vincent-weaver-1.um.maine.edu> <20140219101949.GG15586@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1402191727420.23543@vincent-weaver-1.um.maine.edu> <20140220100830.GN6835@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1402201302150.24360@vincent-weaver-1.um.maine.edu> <20140220182300.GN9987@twins.programming.kicks-ass.net> <20140221150312.GF3104@twins.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Feb 2014, Peter Zijlstra wrote:

> group_sched_in() that fails (for whatever reason), and without x86_pmu
> TXN support (because the leader is !x86_pmu), will corrupt the n_added
> state.
> 
> If this all is correct; the below ought to cure things.

I've applied the patch and have been unable to trigger the warning with 
either my testcase or a few hours of fuzzing.

My only comment on the patch is it could always use some comments.

The perf_event code is really hard to follow as is, without adding
more uncommented special cases.

Vince


> 
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  arch/x86/kernel/cpu/perf_event.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index 895604f2e916..79f9f848bee4 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -1192,6 +1192,9 @@ static void x86_pmu_del(struct perf_event *event, int flags)
>  	for (i = 0; i < cpuc->n_events; i++) {
>  		if (event == cpuc->event_list[i]) {
>  
> +			if (i >= cpuc->n_events - cpuc->n_added)
> +				--cpuc->n_added;
> +
>  			if (x86_pmu.put_event_constraints)
>  				x86_pmu.put_event_constraints(cpuc, event);
>  
