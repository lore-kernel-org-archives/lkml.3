Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934588Ab3CZPJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:09:07 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:50577 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757506Ab3CZPJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:09:05 -0400
X-IronPort-AV: E=Sophos;i="4.84,911,1355097600"; 
   d="scan'208";a="14904334"
Date: Tue, 26 Mar 2013 15:09:02 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Arnd Bergmann <arnd@arndb.de>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "nico@linaro.org" <nico@linaro.org>
Subject: Re: [PATCH v2 6/6] [RFC] arm: use PSCI if available
In-Reply-To: <201303261458.55183.arnd@arndb.de>
Message-ID: <alpine.DEB.2.02.1303261508370.4430@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1303261423530.4430@kaball.uk.xensource.com> <1364308875-26484-6-git-send-email-stefano.stabellini@eu.citrix.com> <201303261458.55183.arnd@arndb.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Mar 2013, Arnd Bergmann wrote:
> On Tuesday 26 March 2013, Stefano Stabellini wrote:
> > Check for the presence of PSCI before setting smp_ops, use PSCI if it is
> > available.
> > 
> > This is useful because at least when running on Xen it's possible to have a
> > PSCI node for example on a Versatile Express or an Exynos5 machine. In these
> > cases the PSCI SMP calls should be the ones to be called.
> > 
> > Remove virt_smp_ops and platsmp.c from mach-virt because they aren't needed
> > anymore.
> 
> Very nice, I had a similar idea but had not gotten around to write a patch.
> This fits in nicely with my plans to make all fields of machine_desc optional.
> 
> >  void __init smp_set_ops(struct smp_operations *ops)
> >  {
> > -       if (ops)
> > +       int rc = -ENODEV;
> > +#ifdef CONFIG_ARM_PSCI
> > +       rc = psci_init(&smp_ops);
> > +#endif
> > +       if (rc && ops)
> >                smp_ops = *ops;
> >  };
> 
> Could you move this into the caller, i.e. setup_arch() so we call smp_set_ops
> either for psci_smp_ops or for machine_desc->smp?

Sure, I can do that.
