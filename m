Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090Ab3DBRlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 13:41:21 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:57675 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758104Ab3DBRlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 13:41:20 -0400
Date: Tue, 2 Apr 2013 13:41:17 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, will.deacon@arm.com,
        arnd@arndb.de, rob.herring@calxeda.com, marc.zyngier@arm.com,
        linux@arm.linux.org.uk
Subject: Re: [PATCH v5 1/3] arm: introduce psci_smp_ops
In-Reply-To: <1364919374-7836-1-git-send-email-stefano.stabellini@eu.citrix.com>
Message-ID: <alpine.LFD.2.03.1304021336270.1171@syhkavp.arg>
References: <alpine.DEB.2.02.1304021700380.5078@kaball.uk.xensource.com> <1364919374-7836-1-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Apr 2013, Stefano Stabellini wrote:

> Rename virt_smp_ops to psci_smp_ops and move them to arch/arm/kernel/psci_smp.c.
> Remove mach-virt/platsmp.c, now unused.
> Compile psci_smp if CONFIG_ARM_PSCI and CONFIG_SMP.
> 
> Add a cpu_die smp_op based on psci_ops.cpu_off.
> 
> Initialize PSCI before setting smp_ops in setup_arch.
> Use psci_smp_ops if the platform doesn't provide its own smp_ops.

[...]

> @@ -766,9 +767,13 @@ void __init setup_arch(char **cmdline_p)
>  	unflatten_device_tree();
>  
>  	arm_dt_init_cpu_maps();
> +	psci_init();
>  #ifdef CONFIG_SMP
>  	if (is_smp()) {
> -		smp_set_ops(mdesc->smp);
> +		if (mdesc->smp)
> +			smp_set_ops(mdesc->smp);
> +		else if (psci_smp_available())
> +			smp_set_ops(&psci_smp_ops);

Didn't we agree to do this the other way around, i.e. 

	if (psci_smp_available())
		smp_set_ops(&psci_smp_ops);
	else if (mdesc->smp)
		smp_set_ops(mdesc->smp);

?

This way you won't need the ->smp_init for Xen and that won't conflict 
with MCPM.


Nicolas
