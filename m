Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbaACOdg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 09:33:36 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:55506 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752067AbaACOdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 09:33:35 -0500
Date: Fri, 3 Jan 2014 14:31:04 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Mark Salter <msalter@redhat.com>, catalin.marinas@arm.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        Chen Baozi <baozich@gmail.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm64/xen: redefine xen_remap on arm64
Message-ID: <20140103143104.GN7383@n2100.arm.linux.org.uk>
References: <1388386511-32276-1-git-send-email-baozich@gmail.com> <1388431259.2564.15.camel@deneb.redhat.com> <alpine.DEB.2.02.1401031310100.8667@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401031310100.8667@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 03, 2014 at 01:13:57PM +0000, Stefano Stabellini wrote:
> On Mon, 30 Dec 2013, Mark Salter wrote:
> > On Mon, 2013-12-30 at 14:55 +0800, Chen Baozi wrote:
> > > xen_remap used to be defined as ioremap_cached on arm64. In commit
> > > c04e8e2fe, a new ioremap_cache was implemented, and ioremap_cached
> > > was deleted, while xen_remap stays the same. This would lead to
> > > the failure when building with CONFIG_HVC_XEN. Redefined xen_remap
> > > on arm64 as ioremap_cache on arm64 to fix it.
> > > 
> > 
> > I missed that include of arm header by arm64 when looking for users
> > of arm64's ioremap_cached() when working on commit c04e8e2fe. Anyway,
> > grepping the kernel tree, I see:
> > 
> >   ioremap_cached()
> >     defined by: arm, metag, unicore32
> >     used by: arch/arm/include/asm/xen/page.h
> >              drivers/mtd/maps/pxa2xx-flash.c
> > 
> >   ioremap_cache()
> >     defined by: arm64, sh, xtensa, ia64, x86
> >     used by: drivers/video/vesafb.c
> >              drivers/char/toshiba.c
> >              drivers/acpi/apei
> >              drivers/lguest/lguest_device.c
> >              drivers/sfi/sfi_core.c
> >              include/linux/acpi_io.h
> > 
> > I think it would be better to just avoid the confusion and the ifdef in
> > asm/xen/page.h by globally changing ioremap_cached to ioremap_cache.
> 
> While I welcome the suggestion, this is a critical fix for a regression
> that I think should go in as soon as possible, maybe 3.13-rc7, while I
> don't think that a global s/ioremap_cached/ioremap_cache would be
> acceptable at this stage.

Since it's just one driver, just make the change for ARM (provided the
grep is accurate.)  pxa2xx-flash is only used on ARM and not the other
two listed there, so looks like metag and unicore just decided to copy
ARM.

My grep concurs with yours.

So... just change ioremap_cached -> ioremap_cache in
arch/arm/include/asm/io.h
arch/arm/include/asm/xen/page.h
drivers/mtd/maps/pxa2xx-flash.c

to fix the problem.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
