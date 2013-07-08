Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab3GHQky (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 12:40:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38232 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab3GHQkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 12:40:52 -0400
Date: Mon, 8 Jul 2013 18:40:02 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        trinity@vger.kernel.org
Subject: Re: [bisected] perf: yet another fuzzer triggered crash
Message-ID: <20130708164002.GB22923@dyad.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1306121911500.12627@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1306140058520.8617@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1306281531070.10799@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1306281705340.10799@vincent-weaver-1.um.maine.edu>
 <20130701090713.GO6626@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1307011112090.8216@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1307021628510.8353@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1307022314450.11385@vincent-weaver-1.um.maine.edu>
 <20130703074929.GE23916@twins.programming.kicks-ass.net>
 <20130708135048.GA1069@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130708135048.GA1069@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 08, 2013 at 03:50:48PM +0200, Jiri Olsa wrote:
> patch below gets rid of the warning, and probably the
> crash as well
> 
> the reason seems to be when HW context is cloned based
> on SW event that happened to get there because of the
> HW leader, which got closed just before (fd[15] event
> in the reproducer)
> 
> and the consequence is that in HW context we access
> SW's cpuctx -> and thus overwriting its task_ctx variable
> any time there's *sched_in routine
> 
> need to check if that does not break anything else ;-)
> 
> jirka
> 
> ---
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 1833bc5..1d1f030 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -7465,7 +7465,7 @@ inherit_task_group(struct perf_event *event, struct task_struct *parent,
>  		 * child.
>  		 */
>  
> -		child_ctx = alloc_perf_context(event->pmu, child);
> +		child_ctx = alloc_perf_context(parent_ctx->pmu, child);
>  		if (!child_ctx)
>  			return -ENOMEM;
>  

Ha! very good catch. Thanks!
