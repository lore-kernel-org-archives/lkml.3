Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762062Ab3DBRe3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 13:34:29 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:36599 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759090Ab3DBReZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 13:34:25 -0400
Date: Tue, 2 Apr 2013 13:34:22 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        rob.herring@calxeda.com
Subject: Re: [PATCH v5 3/3] xen/arm: introduce xen_early_init, use PSCI on
 xen
In-Reply-To: <1364919374-7836-3-git-send-email-stefano.stabellini@eu.citrix.com>
Message-ID: <alpine.LFD.2.03.1304021325230.1171@syhkavp.arg>
References: <alpine.DEB.2.02.1304021700380.5078@kaball.uk.xensource.com> <1364919374-7836-3-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Apr 2013, Stefano Stabellini wrote:

> Split xen_guest_init in two functions, one of them (xen_early_init) is
> going to be called very early from setup_arch.
> 
> Change machine_desc->smp_init to xen_smp_init if Xen is present on the
> platform. xen_smp_init just sets smp_ops to psci_smp_ops.
> 
> Introduce a dependency for ARM_PSCI in XEN.

The Kconfig stuff should be more understandable to "normal" users 
configuring the kernel.  Hence it might make more sense for Xen to 
select PSCI rather than making it a prerequisite.

[...]
> @@ -176,27 +178,30 @@ static int __init xen_secondary_init(unsigned int cpu)
>  	return 0;
>  }
>  
> +static void __init xen_smp_init(void)
> +{
> +	if (psci_smp_available())
> +		smp_set_ops(&psci_smp_ops);
> +}
> +

I still don't understand why you need to do this.  Why can't you just 
rely on the next priority which is to set PSCI ops by default if 
available?  Using this hook for Xen doesn't look justified. As it is, 
you break MCPM.

As I explained to you, MCPM will end up using PSCI as well when 
available, which I think should be sufficient for your concern.


Nicolas
