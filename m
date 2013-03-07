Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297Ab3CGJtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 04:49:35 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:39065 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286Ab3CGJta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 04:49:30 -0500
Message-ID: <513862A5.7060600@linaro.org>
Date: Thu, 07 Mar 2013 10:49:25 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Chuansheng Liu <chuansheng.liu@intel.com>
CC: lenb@kernel.org, len.brown@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel_idle: set the state_tables array into __initdata
 to save mem
References: <1362674529.31506.17.camel@cliu38-desktop-build>
In-Reply-To: <1362674529.31506.17.camel@cliu38-desktop-build>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2013 05:42 PM, Chuansheng Liu wrote:
> 
> Currently, in intel_idle.c, there are 5 state_tables array, every
> array size is sizeof(struct cpuidle_state) * CPUIDLE_STATE_MAX.
> 
> But after intel_idle_probe(), just only one array is useful.
> 
> Here we can just define one static state_table, and initialize it
> in intel_idle_probe(), and set other data state_tables as __initdata.
> 
> It can save about 3K, which also benefits mobile devices.
> 
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> ---
>  drivers/idle/intel_idle.c |   19 ++++++++++++-------
>  1 files changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
> index 5d66750..0642bfe 100644
> --- a/drivers/idle/intel_idle.c
> +++ b/drivers/idle/intel_idle.c
> @@ -99,7 +99,7 @@ static int intel_idle(struct cpuidle_device *dev,
>  			struct cpuidle_driver *drv, int index);
>  static int intel_idle_cpu_init(int cpu);
>  
> -static struct cpuidle_state *cpuidle_state_table;
> +static struct cpuidle_state cpuidle_state_table[CPUIDLE_STATE_MAX];
>  
>  /*
>   * Set this flag for states where the HW flushes the TLB for us
> @@ -124,7 +124,7 @@ static struct cpuidle_state *cpuidle_state_table;
>   * which is also the index into the MWAIT hint array.
>   * Thus C0 is a dummy.
>   */
> -static struct cpuidle_state nehalem_cstates[CPUIDLE_STATE_MAX] = {
> +static struct cpuidle_state nehalem_cstates[CPUIDLE_STATE_MAX] __initdata = {
>  	{
>  		.name = "C1-NHM",
>  		.desc = "MWAIT 0x00",
> @@ -157,7 +157,7 @@ static struct cpuidle_state nehalem_cstates[CPUIDLE_STATE_MAX] = {
>  		.enter = NULL }
>  };
>  
> -static struct cpuidle_state snb_cstates[CPUIDLE_STATE_MAX] = {
> +static struct cpuidle_state snb_cstates[CPUIDLE_STATE_MAX] __initdata = {
>  	{
>  		.name = "C1-SNB",
>  		.desc = "MWAIT 0x00",
> @@ -197,7 +197,7 @@ static struct cpuidle_state snb_cstates[CPUIDLE_STATE_MAX] = {
>  		.enter = NULL }
>  };
>  
> -static struct cpuidle_state ivb_cstates[CPUIDLE_STATE_MAX] = {
> +static struct cpuidle_state ivb_cstates[CPUIDLE_STATE_MAX] __initdata = {
>  	{
>  		.name = "C1-IVB",
>  		.desc = "MWAIT 0x00",
> @@ -237,7 +237,7 @@ static struct cpuidle_state ivb_cstates[CPUIDLE_STATE_MAX] = {
>  		.enter = NULL }
>  };
>  
> -static struct cpuidle_state hsw_cstates[CPUIDLE_STATE_MAX] = {
> +static struct cpuidle_state hsw_cstates[CPUIDLE_STATE_MAX] __initdata = {
>  	{
>  		.name = "C1-HSW",
>  		.desc = "MWAIT 0x00",
> @@ -277,7 +277,7 @@ static struct cpuidle_state hsw_cstates[CPUIDLE_STATE_MAX] = {
>  		.enter = NULL }
>  };
>  
> -static struct cpuidle_state atom_cstates[CPUIDLE_STATE_MAX] = {
> +static struct cpuidle_state atom_cstates[CPUIDLE_STATE_MAX] __initdata = {
>  	{
>  		.name = "C1E-ATM",
>  		.desc = "MWAIT 0x00",
> @@ -504,7 +504,12 @@ static int intel_idle_probe(void)
>  	pr_debug(PREFIX "MWAIT substates: 0x%x\n", mwait_substates);
>  
>  	icpu = (const struct idle_cpu *)id->driver_data;
> -	cpuidle_state_table = icpu->state_table;
> +	/* Copy the icpu->state_table into cpuidle_state_table,
> +	 * The pointing array by icpu->state_table is with __initdata,
> +	 * which will be freed after kernel init ending.
> +	 */
> +	memcpy(cpuidle_state_table, icpu->state_table,
> +			sizeof(cpuidle_state_table));

The idea is good but it could be pushed a bit further.

Instead of changing cpuidle_state_table to an array, change it to an
initdata and the functions intel_idle_cpuidle_driver_init,
intel_idle_probe to init functions.

That would also be nice to get rid of a global variable to store the
current cpu data and let the intel_idle_probe to return the pointer to
the right table.


>  	if (boot_cpu_has(X86_FEATURE_ARAT))	/* Always Reliable APIC Timer */
>  		lapic_timer_reliable_states = LAPIC_TIMER_ALWAYS_RELIABLE;
> 


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

