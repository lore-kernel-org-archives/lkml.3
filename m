Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934607Ab3CZPF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:05:27 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:56496 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934567Ab3CZPF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:05:26 -0400
Date: Tue, 26 Mar 2013 15:04:44 +0000
From: Will Deacon <will.deacon@arm.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "arnd@arndb.de" <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "nico@linaro.org" <nico@linaro.org>
Subject: Re: [PATCH v2 6/6] [RFC] arm: use PSCI if available
Message-ID: <20130326150444.GI20252@mudshark.cambridge.arm.com>
References: <alpine.DEB.2.02.1303261423530.4430@kaball.uk.xensource.com>
 <1364308875-26484-6-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364308875-26484-6-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefano,

On Tue, Mar 26, 2013 at 02:41:15PM +0000, Stefano Stabellini wrote:
> Check for the presence of PSCI before setting smp_ops, use PSCI if it is
> available.
> 
> This is useful because at least when running on Xen it's possible to have a
> PSCI node for example on a Versatile Express or an Exynos5 machine. In these
> cases the PSCI SMP calls should be the ones to be called.
> 
> Remove virt_smp_ops and platsmp.c from mach-virt because they aren't needed
> anymore.

[...]

> +struct smp_operations __initdata psci_smp_ops = {
> +	.smp_init_cpus		= psci_smp_init_cpus,
> +	.smp_prepare_cpus	= psci_smp_prepare_cpus,
> +	.smp_secondary_init	= psci_secondary_init,
> +	.smp_boot_secondary	= psci_boot_secondary,
> +};

Whilst I like the idea of this, I don't think things will pan out this
nicely in practice. There will almost always be a level of indirection
required between the internal Linux SMP operations and the expectations of
the PSCI firmware, whether this is in CPU numbering or other,
platform-specific fields in various parameters.

Tying these two things together like this confuses the layering in my
opinion and will likely lead to potentially subtle breakages if platforms
start trying to adopt this.

If this can indeed work for the virtual platforms (Xen and KVM), then I
think it would be better expressed using `virt' smp_ops, which map directly
to PSCI, rather than putting them here. Even then, it's tying KVM and Xen
together on the firmware side of things...

Will
