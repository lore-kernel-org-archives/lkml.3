Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab3JWKre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 06:47:34 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:62474 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752408Ab3JWKrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 06:47:33 -0400
Message-ID: <1382525244.5283.3.camel@pippen.local.home>
Subject: Re: [PATCH] kernel: context_tracking: use extern function instead
 of static inline function for user_enter/exit()
From: Steven Rostedt <rostedt@goodmis.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, khilman@linaro.org,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 23 Oct 2013 06:47:24 -0400
In-Reply-To: <5267A72B.7060808@asianux.com>
References: <5267A72B.7060808@asianux.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-23 at 18:38 +0800, Chen Gang wrote:

> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  include/linux/context_tracking.h |   14 ++------------
>  kernel/context_tracking.c        |   12 ++++++++++++
>  2 files changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/context_tracking.h b/include/linux/context_tracking.h
> index 1581587..bf220f7 100644
> --- a/include/linux/context_tracking.h
> +++ b/include/linux/context_tracking.h
> @@ -10,23 +10,13 @@
>  #ifdef CONFIG_CONTEXT_TRACKING
>  extern void context_tracking_cpu_set(int cpu);
>  
> +extern void user_enter(void);
> +extern void user_exit(void);
>  extern void context_tracking_user_enter(void);
>  extern void context_tracking_user_exit(void);
>  extern void __context_tracking_task_switch(struct task_struct *prev,
>  					   struct task_struct *next);
>  
> -static inline void user_enter(void)
> -{
> -	if (static_key_false(&context_tracking_enabled))
> -		context_tracking_user_enter();
> -
> -}
> -static inline void user_exit(void)
> -{
> -	if (static_key_false(&context_tracking_enabled))
> -		context_tracking_user_exit();
> -}
> -
>  static inline enum ctx_state exception_enter(void)
>  {
>  	enum ctx_state prev_ctx;
> diff --git a/kernel/context_tracking.c b/kernel/context_tracking.c
> index 013161f..c03d0d6 100644
> --- a/kernel/context_tracking.c
> +++ b/kernel/context_tracking.c
> @@ -29,6 +29,18 @@ EXPORT_SYMBOL_GPL(context_tracking_enabled);
>  DEFINE_PER_CPU(struct context_tracking, context_tracking);
>  EXPORT_SYMBOL_GPL(context_tracking);
>  
> +void user_enter(void)
> +{
> +	if (static_key_false(&context_tracking_enabled))
> +		context_tracking_user_enter();
> +}
> +
> +void user_exit(void)
> +{
> +	if (static_key_false(&context_tracking_enabled))
> +		context_tracking_user_exit();
> +}
> +
>  void context_tracking_cpu_set(int cpu)
>  {
>  	if (!per_cpu(context_tracking.active, cpu)) {

Ug, you just put an unneeded function call into a fast path because of a
failure with a particular arch.

If you need the assembly to call this code, then make yourself a wrapper
function to call that does the user_enter/exit() calls.

void arch_user_enter(void)
{
	user_enter();
}

-- Steve


