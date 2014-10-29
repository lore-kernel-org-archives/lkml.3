Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbaJ2Cpl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 22:45:41 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:36791 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752943AbaJ2Cpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 22:45:39 -0400
X-Sasl-enc: 57qi2Av11V81II/RyyxoD9mF+XV3B0stg04clQvpF38Q 1414550738
Date: Wed, 29 Oct 2014 10:44:26 +0800
From: Greg KH <greg@kroah.com>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org
Subject: Re: [PATCH 2/2] cpufreq: Guard against not-yet-initialized policies
 in cpufreq_cpu_get
Message-ID: <20141029024426.GA7468@kroah.com>
References: <1414510008-7262-1-git-send-email-tomeu.vizoso@collabora.com>
 <1414510008-7262-2-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414510008-7262-2-git-send-email-tomeu.vizoso@collabora.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 04:26:48PM +0100, Tomeu Vizoso wrote:
> There's a substantial window of opportunity from the time the policy objects
> are created until they are initialized, causing this:
> 
> [    4.651435] ------------[ cut here ]------------
> [    4.651453] WARNING: CPU: 1 PID: 64 at include/linux/kref.h:47 kobject_get+0x64/0x70()
> [    4.651463] Modules linked in:
> [    4.651473] CPU: 1 PID: 64 Comm: irq/77-tegra-ac Not tainted 3.18.0-rc1-next-20141027ccu-00049-g21a0041 #248
> [    4.651497] [<c0016fac>] (unwind_backtrace) from [<c001272c>] (show_stack+0x10/0x14)
> [    4.651505] [<c001272c>] (show_stack) from [<c0601920>] (dump_stack+0x98/0xd8)
> [    4.651515] [<c0601920>] (dump_stack) from [<c00288d8>] (warn_slowpath_common+0x70/0x8c)
> [    4.651522] [<c00288d8>] (warn_slowpath_common) from [<c0028990>] (warn_slowpath_null+0x1c/0x24)
> [    4.651530] [<c0028990>] (warn_slowpath_null) from [<c02227bc>] (kobject_get+0x64/0x70)
> [    4.651539] [<c02227bc>] (kobject_get) from [<c03e5238>] (cpufreq_cpu_get+0x88/0xc8)
> [    4.651547] [<c03e5238>] (cpufreq_cpu_get) from [<c03e52ec>] (cpufreq_get+0xc/0x64)
> [    4.651555] [<c03e52ec>] (cpufreq_get) from [<c0287818>] (actmon_thread_isr+0x140/0x1a4)
> [    4.651563] [<c0287818>] (actmon_thread_isr) from [<c0068a68>] (irq_thread_fn+0x1c/0x40)
> [    4.651570] [<c0068a68>] (irq_thread_fn) from [<c0068d84>] (irq_thread+0x134/0x174)
> [    4.651579] [<c0068d84>] (irq_thread) from [<c0040284>] (kthread+0xdc/0xf4)
> [    4.651587] [<c0040284>] (kthread) from [<c000f4b8>] (ret_from_fork+0x14/0x3c)
> [    4.651591] ---[ end trace 7f6a15d1272e6ef3 ]---
> 
> This commit checks that the policy object has been initialized already before
> trying to ref it.
> 
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> ---
>  drivers/cpufreq/cpufreq.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 644b54e..37cd6c9 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -214,8 +214,12 @@ struct cpufreq_policy *cpufreq_cpu_get(unsigned int cpu)
>  	if (cpufreq_driver) {
>  		/* get the CPU */
>  		policy = per_cpu(cpufreq_cpu_data, cpu);
> -		if (policy)
> -			kobject_get(&policy->kobj);
> +		if (policy) {
> +			if (!kobject_initialized(&policy->kobj))
> +				policy = NULL;
> +			else
> +				kobject_get(&policy->kobj);
> +		}

Something else is going on here, sorry, this isn't the correct fix, as
you are using kobjects incorrectly if this ever happens...

thanks,

greg k-h
