Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967600Ab3DRQN4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 12:13:56 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34239 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935973Ab3DRQNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 12:13:55 -0400
Date: Thu, 18 Apr 2013 17:13:42 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, will.deacon@arm.com,
        arnd@arndb.de, nicolas.pitre@linaro.org, rob.herring@calxeda.com,
        marc.zyngier@arm.com, nico@linaro.org
Subject: Re: [PATCH v6 1/4] arm: introduce psci_smp_ops
Message-ID: <20130418161341.GB14496@n2100.arm.linux.org.uk>
References: <alpine.DEB.2.02.1304031239550.5078@kaball.uk.xensource.com> <1365167495-18508-1-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365167495-18508-1-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 05, 2013 at 02:11:32PM +0100, Stefano Stabellini wrote:
> +	psci_init();
>  #ifdef CONFIG_SMP
>  	if (is_smp()) {
> -		smp_set_ops(mdesc->smp);
> +		if (mdesc->smp)
> +			smp_set_ops(mdesc->smp);
> +		else if (psci_smp_available())
> +			smp_set_ops(&psci_smp_ops);

So, I have a vague recollection that the ordering of the above got discussed
but I can't find it amongst the 21k of messages so far this year.

The above looks weird to me.  Surely this should be:

		if (psci_smp_available())
			smp_set_ops(&psci_smp_ops);
		else if (mdesc->smp)
			smp_set_ops(mdesc->ops);

This means that if PSCI is available, and provides a set of operations,
we override whatever the platform has statically provided.

Remember, we're trying to move away from using "mdesc"s for platform
stuff, relying on things like DT and such like.  We really should not
be going for mdesc-overriding-newstuff but newstuff-overriding-mdesc.

Now, if the psci stuff can't be relied upon to provide the correct
functionality, then that's a separate problem which needs addressing
differently.

This should allow the Xen problem to be resolved, because Xen will
provide the PSCI operations, and it's correct in that case to override
the platform's SMP operations.
