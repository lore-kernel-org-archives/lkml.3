Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbaHUWWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 18:22:20 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:51775 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473AbaHUWWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 18:22:19 -0400
Date: Thu, 21 Aug 2014 17:22:12 -0500
From: Tejun Heo <htejun@gmail.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Fengguang Wu <fengguang.wu@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>,
        Mike Travis <travis@sgi.com>
Subject: Re: percpu: Define this_cpu_cpumask_var_t_ptr
Message-ID: <20140821222212.GA7996@mtj.dyndns.org>
References: <alpine.DEB.2.11.1408070959250.28468@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1408070959250.28468@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Christoph.

On Thu, Aug 07, 2014 at 10:05:45AM -0500, Christoph Lameter wrote:
> @@ -666,10 +666,19 @@
>   *
>   * This code makes NR_CPUS length memcopy and brings to a memory corruption.
>   * cpumask_copy() provide safe copy functionality.
> + *
> + * Note that there is another evil here: If you define a cpumask_var_t
> + * as a percpu variable then the way to obtain the address of the cpumask
> + * structure differently influences what this_cpu_* operation needs to be
> + * used. Please use this_cpu_cpumask_var_t in those cases. The direct use
> + * of this_cpu_ptr() or this_cpu_read() will lead to failures when the
> + * other type of cpumask_var_t implementation is configured.
>   */
>  #ifdef CONFIG_CPUMASK_OFFSTACK
>  typedef struct cpumask *cpumask_var_t;
> 
> +#define this_cpu_cpumask_var_t_ptr(x) this_cpu_read(x)
> +
>  bool alloc_cpumask_var_node(cpumask_var_t *mask, gfp_t flags, int node);
>  bool alloc_cpumask_var(cpumask_var_t *mask, gfp_t flags);
>  bool zalloc_cpumask_var_node(cpumask_var_t *mask, gfp_t flags, int node);
> @@ -681,6 +690,8 @@
>  #else
>  typedef struct cpumask cpumask_var_t[1];
> 
> +#define this_cpu_cpumask_var_t_ptr(x) this_cpu_ptr(&x)

Urgh, this is nasty but yeah I can't think of any other way around it
either. :(

Do we need the "_t" in the name tho?  Maybe we can shorten the name to
this_cpumask_var_ptr(x)?  Also, wouldn't it be better to define it as
a static inline function so that the input type is explicit?

Thanks.

-- 
tejun
