Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437AbaJGCkD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 22:40:03 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:36184 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaJGCkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 22:40:00 -0400
Date: Mon, 6 Oct 2014 19:39:53 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@linux.intel.com>, Dave Hansen <dave@sr71.net>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 08/11] tracing: generate RCU warnings even when
 tracepoints are disabled
Message-ID: <20141007023953.GA5015@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141006213544.344821619@goodmis.org>
 <20141006213631.352752419@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141006213631.352752419@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100702-0013-0000-0000-0000055A86B0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 06, 2014 at 05:35:52PM -0400, Steven Rostedt wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> Dave Jones reported seeing a bug from one of my TLB tracepoints:
> 
> 	http://lkml.kernel.org/r/20140806181801.GA4605@redhat.com
> 
> I've been running these patches for months and never saw this.
> But, a big chunk of my testing, especially with all the debugging
> enabled, was in a vm where intel_idle doesn't work.  On the
> systems where I was using intel_idle, I never had lockdep enabled
> and this tracepoint on at the same time.
> 
> This patch ensures that whenever we have lockdep available, we do
> _some_ RCU activity at the site of the tracepoint, despite
> whether the tracepoint's condition matches or even if the
> tracepoint itself is completely disabled.  This is a bit of a
> hack, but it is pretty self-contained.
> 
> I confirmed that with this patch plus lockdep I get the same
> splat as Dave Jones did, but without enabling the tracepoint
> explicitly.
> 
> Link: http://lkml.kernel.org/p/20140807175204.C257CAC5@viggo.jf.intel.com
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Dave Hansen <dave@sr71.net>
> Cc: Dave Jones <davej@redhat.com>,
> Cc: paulmck@linux.vnet.ibm.com

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Cc: Ingo Molnar <mingo@redhat.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  include/linux/tracepoint.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
> index b1293f15f592..e08e21e5f601 100644
> --- a/include/linux/tracepoint.h
> +++ b/include/linux/tracepoint.h
> @@ -157,6 +157,12 @@ extern void syscall_unregfunc(void);
>   * Make sure the alignment of the structure in the __tracepoints section will
>   * not add unwanted padding between the beginning of the section and the
>   * structure. Force alignment to the same alignment as the section start.
> + *
> + * When lockdep is enabled, we make sure to always do the RCU portions of
> + * the tracepoint code, regardless of whether tracing is on or we match the
> + * condition.  This lets us find RCU issues triggered with tracepoints even
> + * when this tracepoint is off.  This code has no purpose other than poking
> + * RCU a bit.
>   */
>  #define __DECLARE_TRACE(name, proto, args, cond, data_proto, data_args) \
>  	extern struct tracepoint __tracepoint_##name;			\
> @@ -167,6 +173,11 @@ extern void syscall_unregfunc(void);
>  				TP_PROTO(data_proto),			\
>  				TP_ARGS(data_args),			\
>  				TP_CONDITION(cond),,);			\
> +		if (IS_ENABLED(CONFIG_LOCKDEP)) {			\
> +			rcu_read_lock_sched_notrace();			\
> +			rcu_dereference_sched(__tracepoint_##name.funcs);\
> +			rcu_read_unlock_sched_notrace();		\
> +		}							\
>  	}								\
>  	__DECLARE_TRACE_RCU(name, PARAMS(proto), PARAMS(args),		\
>  		PARAMS(cond), PARAMS(data_proto), PARAMS(data_args))	\
> -- 
> 2.0.1
> 
> 

