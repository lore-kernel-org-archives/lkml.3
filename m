Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455Ab3C0Rpe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 13:45:34 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:58717 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203Ab3C0Rpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 13:45:30 -0400
Message-ID: <51533037.5060004@gmail.com>
Date: Wed, 27 Mar 2013 12:45:27 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Will Deacon <will.deacon@arm.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        "nico@linaro.org" <nico@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3] [RFC] arm: use PSCI if available
References: <1364388639-11210-1-git-send-email-stefano.stabellini@eu.citrix.com> <20130327133811.GE18429@mudshark.cambridge.arm.com> <alpine.DEB.2.02.1303271610430.4430@kaball.uk.xensource.com> <51531FE3.8010905@gmail.com> <alpine.DEB.2.02.1303271642340.4430@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1303271642340.4430@kaball.uk.xensource.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2013 12:10 PM, Stefano Stabellini wrote:
> On Wed, 27 Mar 2013, Rob Herring wrote:
>> On 03/27/2013 11:23 AM, Stefano Stabellini wrote:
>>> Would you agree on a patch that moves virt_smp_ops out of mach-virt and
>>> renames them to psci_smp_ops (maybe to arch/arm/kernel/psci_smp_ops.c)?
>>>
>>> Would you agree on initializing psci from setup_arch, right after the
>>> call to arm_dt_init_cpu_maps()?
>>>
>>> Finally the most controversial point: would you agree on using
>>> psci_smp_ops by default if they are available?
>>> If not, would you at least agree on letting Xen overwrite the default
>>> machine smp_ops?
>>> We need one or the other for dom0 support.
>>
>> It should not be *always* use PSCI smp ops if available, but use them
>> only if the platform does not define its own smp ops.
> 
> Well, that is the one additional problem that we have on Xen.
> 
> On x86 Xen replaces a lot of core native function calls with its own
> implementations (see paravirt_ops).
> On ARM we only need *one* set of calls: the smp_ops calls.
> 
> So if we don't want to give priority to PSCI over the platform smp_ops,
> then we need a simple workaround just for Xen in common code like the
> one appended below.
> Not pretty, but at least small:
> 
> diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> index 3f6cbb2..08cf7e0 100644
> --- a/arch/arm/kernel/setup.c
> +++ b/arch/arm/kernel/setup.c
> @@ -43,6 +43,8 @@
>  #include <asm/cacheflush.h>
>  #include <asm/cachetype.h>
>  #include <asm/tlbflush.h>
> +#include <xen/xen.h>
> +#include <asm/xen/hypervisor.h>
>  
>  #include <asm/prom.h>
>  #include <asm/mach/arch.h>
> @@ -766,9 +768,13 @@ void __init setup_arch(char **cmdline_p)
>  	unflatten_device_tree();
>  
>  	arm_dt_init_cpu_maps();
> +	xen_early_init();
>  #ifdef CONFIG_SMP
>  	if (is_smp()) {
> -		smp_set_ops(mdesc->smp);
> +		if (xen_domain())
> +			smp_set_ops(&xen_smp_ops);
> +		else
> +			smp_set_ops(mdesc->smp);

No, I was thinking in the case of Xen and mach-virt, you would not set
mdesc->smp. So you would have something like this:

if (mdesc->smp)
	smp_set_ops(mdesc->smp);
else
	smp_set_ops(&psci_smp_ops);


Rob

