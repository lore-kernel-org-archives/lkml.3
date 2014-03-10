Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbaCJKkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 06:40:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43967 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbaCJKkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 06:40:12 -0400
Date: Mon, 10 Mar 2014 10:40:07 +0000
From: =?iso-8859-1?Q?Lu=EDs?= Henriques <luis.henriques@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tony Breeds <tony@bakeyournoodle.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 3.4 25/99] powerpc/le: Ensure that the stop-self RTAS
 token is handled correctly
Message-ID: <20140310104007.GB2742@hercules>
References: <20140308010611.468206150@linuxfoundation.org>
 <20140308010612.425643961@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140308010612.425643961@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 05:07:21PM -0800, Greg Kroah-Hartman wrote:
> 3.4-stable review patch.  If anyone has any objections, please let me know.
> 

As per Tony request, I've dropped this patch from the 3.5 kernel.  Looks
like it is applicable to kernels >= 3.10, so I guess you can drop it from
3.4 as well.

Cheers,
--
Luís

> ------------------
> 
> From: Tony Breeds <tony@bakeyournoodle.com>
> 
> commit 41dd03a94c7d408d2ef32530545097f7d1befe5c upstream.
> 
> Currently we're storing a host endian RTAS token in
> rtas_stop_self_args.token.  We then pass that directly to rtas.  This is
> fine on big endian however on little endian the token is not what we
> expect.
> 
> This will typically result in hitting:
> 	panic("Alas, I survived.\n");
> 
> To fix this we always use the stop-self token in host order and always
> convert it to be32 before passing this to rtas.
> 
> Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  arch/powerpc/platforms/pseries/hotplug-cpu.c |   22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> --- a/arch/powerpc/platforms/pseries/hotplug-cpu.c
> +++ b/arch/powerpc/platforms/pseries/hotplug-cpu.c
> @@ -34,12 +34,7 @@
>  #include "offline_states.h"
>  
>  /* This version can't take the spinlock, because it never returns */
> -static struct rtas_args rtas_stop_self_args = {
> -	.token = RTAS_UNKNOWN_SERVICE,
> -	.nargs = 0,
> -	.nret = 1,
> -	.rets = &rtas_stop_self_args.args[0],
> -};
> +static int rtas_stop_self_token = RTAS_UNKNOWN_SERVICE;
>  
>  static DEFINE_PER_CPU(enum cpu_state_vals, preferred_offline_state) =
>  							CPU_STATE_OFFLINE;
> @@ -92,15 +87,20 @@ void set_default_offline_state(int cpu)
>  
>  static void rtas_stop_self(void)
>  {
> -	struct rtas_args *args = &rtas_stop_self_args;
> +	struct rtas_args args = {
> +		.token = cpu_to_be32(rtas_stop_self_token),
> +		.nargs = 0,
> +		.nret = 1,
> +		.rets = &args.args[0],
> +	};
>  
>  	local_irq_disable();
>  
> -	BUG_ON(args->token == RTAS_UNKNOWN_SERVICE);
> +	BUG_ON(rtas_stop_self_token == RTAS_UNKNOWN_SERVICE);
>  
>  	printk("cpu %u (hwid %u) Ready to die...\n",
>  	       smp_processor_id(), hard_smp_processor_id());
> -	enter_rtas(__pa(args));
> +	enter_rtas(__pa(&args));
>  
>  	panic("Alas, I survived.\n");
>  }
> @@ -383,10 +383,10 @@ static int __init pseries_cpu_hotplug_in
>  		}
>  	}
>  
> -	rtas_stop_self_args.token = rtas_token("stop-self");
> +	rtas_stop_self_token = rtas_token("stop-self");
>  	qcss_tok = rtas_token("query-cpu-stopped-state");
>  
> -	if (rtas_stop_self_args.token == RTAS_UNKNOWN_SERVICE ||
> +	if (rtas_stop_self_token == RTAS_UNKNOWN_SERVICE ||
>  			qcss_tok == RTAS_UNKNOWN_SERVICE) {
>  		printk(KERN_INFO "CPU Hotplug not supported by firmware "
>  				"- disabling.\n");
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
