Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528Ab3GWODB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 10:03:01 -0400
Received: from ozlabs.org ([203.10.76.45]:51642 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757154Ab3GWODA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 10:03:00 -0400
Date: Wed, 24 Jul 2013 00:02:57 +1000
From: Michael Ellerman <michael@ellerman.id.au>
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
Cc: PowerPC email list <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Preeti Murthy <preeti@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: cpuidle/pseries: Fix kernel command line parameter
 smt-snooze-delay
Message-ID: <20130723140256.GH31944@concordia>
References: <51EE0C65.6020903@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51EE0C65.6020903@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 10:23:57AM +0530, Deepthi Dharwar wrote:
> smt-snooze-delay is a tun-able provided currently on powerpc to delay the
> entry of an idle cpu to NAP state. By default, the value is 100us,
> which is entry criteria for NAP state i.e only if the idle period is
> above 100us it would enter NAP. Value of -1 disables entry into NAP.
> This value can be set either through sysfs, ppc64_cpu util or by
> passing it via kernel command line. Currently this feature is broken
> when the value is passed via the kernel command line.

Has it always been broken? Or just since some commit?
 
> This patch aims to fix this, by taking the appropriate action
> based on the value after the pseries driver is registered.
> This check is carried on in the back-end driver rather than
> setup_smt_snooze_delay(), as one is not sure if the cpuidle driver
> is even registered when setup routine is executed.
> Also, this fixes re-enabling of NAP states by setting appropriate
> value without having to reboot using smt-snooze-delay parameter.
> 
> Also, to note is, smt-snooze-delay is per-cpu variable.
> This can be used to enable/disable NAP on per-cpu
> basis using sysfs but when this variable is passed
> via kernel command line or using the smt-snooze-delay
> it applies to all the cpus. Per-cpu tuning can
> only be done via sysfs.
> 
> Signed-off-by: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
> ---
>  arch/powerpc/platforms/pseries/processor_idle.c |   34 ++++++++++++++++++-----
>  1 file changed, 27 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/pseries/processor_idle.c b/arch/powerpc/platforms/pseries/processor_idle.c
> index 4644efa0..8133f50 100644
> --- a/arch/powerpc/platforms/pseries/processor_idle.c
> +++ b/arch/powerpc/platforms/pseries/processor_idle.c
> @@ -170,18 +170,36 @@ static struct cpuidle_state shared_states[MAX_IDLE_STATE_COUNT] = {
>  void update_smt_snooze_delay(int cpu, int residency)
>  {
>  	struct cpuidle_driver *drv = cpuidle_get_driver();
> -	struct cpuidle_device *dev = per_cpu(cpuidle_devices, cpu);
> +	struct cpuidle_device *dev;
>  
>  	if (cpuidle_state_table != dedicated_states)
>  		return;
>  
> -	if (residency < 0) {
> -		/* Disable the Nap state on that cpu */
> -		if (dev)
> -			dev->states_usage[1].disable = 1;
> -	} else
> -		if (drv)
> +	if (!drv)
> +		return;
> +
> +	if (cpu == -1) {
> +		if (residency < 0) {
> +			/* Disable NAP on all cpus */
> +			drv->states[1].disabled = true;
> +		} else {
>  			drv->states[1].target_residency = residency;
> +			drv->states[1].disabled = false;
> +		}
> +		return;
> +	}
> +
> +	dev = per_cpu(cpuidle_devices, cpu);
> +	if (!dev)
> +		return;
> +
> +	if (residency < 0)
> +		dev->states_usage[1].disable = 1;
> +	else {
> +		drv->states[1].target_residency = residency;
> +		drv->states[1].disabled = false;
> +		dev->states_usage[1].disable = 0;

Why are we indexing into all these array with '1' ?

cheers
