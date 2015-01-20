Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440AbbATFpK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 00:45:10 -0500
Received: from ozlabs.org ([103.22.144.67]:44834 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704AbbATFpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 00:45:09 -0500
In-Reply-To: <20150119113251.23984.16931.stgit@preeti.in.ibm.com>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>, rafael.j.wysocki@intel.com
From: Michael Ellerman <mpe@ellerman.id.au>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: cpuidle/powernv: Read target_residency value of idle states from DT if available
Message-Id: <20150120054506.F13591402E0@ozlabs.org>
Date: Tue, 20 Jan 2015 16:45:06 +1100 (AEDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-19-01 at 11:32:51 UTC, Preeti U Murthy wrote:
> The device tree now exposes the residency values for different idle states. Read
> these values instead of calculating residency from the latency values. The values
> exposed in the DT are validated for optimal power efficiency. However to maintain
> compatibility with the older firmware code which does not expose residency
> values, use default values as a fallback mechanism. While at it, clump
> the common parts of device tree parsing into one chunk.
> 
> Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
> ---
> 
>  drivers/cpuidle/cpuidle-powernv.c |   39 ++++++++++++++++++++++++-------------
>  1 file changed, 25 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/cpuidle/cpuidle-powernv.c b/drivers/cpuidle/cpuidle-powernv.c
> index 2726663..9e732e1 100644
> --- a/drivers/cpuidle/cpuidle-powernv.c
> +++ b/drivers/cpuidle/cpuidle-powernv.c
> @@ -162,7 +162,8 @@ static int powernv_add_idle_states(void)
>  	int dt_idle_states;
>  	const __be32 *idle_state_flags;
>  	const __be32 *idle_state_latency;
> -	u32 len_flags, flags, latency_ns;
> +	const __be32 *idle_state_residency;
> +	u32 len_flags, flags, latency_ns, residency_ns;
>  	int i;
>  
>  	/* Currently we have snooze statically defined */
> @@ -186,14 +187,21 @@ static int powernv_add_idle_states(void)
>  		return nr_idle_states;
>  	}
>  
> +	idle_state_residency = of_get_property(power_mgt,
> +			"ibm,cpu-idle-state-residency-ns", NULL);
> +	if (!idle_state_residency) {
> +		pr_warn("DT-PowerMgmt: missing ibm,cpu-idle-state-residency-ns\n");
> +		pr_warn("Falling back to default values\n");
> +	}

This would be better done with something like:

	rc = of_read_property_u32(power_mgt, "ibm,cpu-idle-state-residency-ns", &residency_ns);
	if (!rc) {
		pr_info("cpuidle-powernv: missing ibm,cpu-idle-state-residency-ns\n");
		residency_ns = 300000;
	}

cheers
