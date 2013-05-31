Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab3EaPXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:23:52 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:22705 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159Ab3EaPXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:23:40 -0400
X-IronPort-AV: E=Sophos;i="4.87,779,1363132800"; 
   d="scan'208";a="27189827"
Date: Fri, 31 May 2013 16:23:20 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "Ian.Campbell@citrix.com" <Ian.Campbell@citrix.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [PATCH RFC 5/6] arm64/xen: implement xen_remap on arm64
In-Reply-To: <alpine.DEB.2.02.1305311530440.4799@kaball.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1305311622150.4799@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1305301705500.4799@kaball.uk.xensource.com> <1369930713-6063-5-git-send-email-stefano.stabellini@eu.citrix.com> <20130531105915.GC18045@localhost.cambridge.arm.com> <alpine.DEB.2.02.1305311419280.4799@kaball.uk.xensource.com>
 <20130531141601.GC15551@arm.com> <alpine.DEB.2.02.1305311530440.4799@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 May 2013, Stefano Stabellini wrote:
> On Fri, 31 May 2013, Catalin Marinas wrote:
> > On Fri, May 31, 2013 at 02:21:16PM +0100, Stefano Stabellini wrote:
> > > On Fri, 31 May 2013, Catalin Marinas wrote:
> > > > On Thu, May 30, 2013 at 05:18:32PM +0100, Stefano Stabellini wrote:
> > > > > --- a/arch/arm/include/asm/xen/page.h
> > > > > +++ b/arch/arm/include/asm/xen/page.h
> > > > > @@ -90,6 +90,10 @@ static inline bool set_phys_to_machine(unsigned long pfn, unsigned long mfn)
> > > > >  	return __set_phys_to_machine(pfn, mfn);
> > > > >  }
> > > > >  
> > > > > +#ifdef CONFIG_ARM64
> > > > > +#define xen_remap(cookie, size) __ioremap((cookie), (size), __pgprot(PROT_NORMAL))
> > > > > +#else
> > > > >  #define xen_remap(cookie, size) __arm_ioremap((cookie), (size), MT_MEMORY);
> > > > > +#endif
> > > > 
> > > > Now I saw the ARM-specific part. Can you not use something like
> > > > ioremap_cached() which would give normal cacheable memory (at least on
> > > > ARMv7).
> > > 
> > > No, I cannot because ioremap_cached uses MT_DEVICE_CACHED, while this
> > > needs to be MT_MEMORY. It is used for normal memory pages, not device
> > > memory.
> > 
> > MT_DEVICE_CACHED is Normal memory for ARMv7.
> 
> I didn't realize that MT_DEVICE_CACHED and MT_MEMORY end up having the
> same AttrIndx encoding!
> In that case yes, I should be able to use it.
> I take that I should just implement ioremap_cached on arm64 as well?
> 

Should just use MT_MEMORY and call it PROT_NORMAL?

#define PROT_NORMAL     (PROT_DEFAULT | PTE_ATTRINDX(MT_NORMAL))
#define ioremap_cached(addr, size)     __ioremap((addr), (size), __pgprot(PROT_NORMAL))
