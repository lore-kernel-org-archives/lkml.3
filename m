Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753928AbaKRLAE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 06:00:04 -0500
Received: from www.linutronix.de ([62.245.132.108]:38181 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbaKRLAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 06:00:01 -0500
Date: Tue, 18 Nov 2014 11:59:39 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: Jiang Liu <jiang.liu@linux.intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Ingo Molnar <mingo@redhat.com>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org, LAK <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] asm-generic: Add msi.h
In-Reply-To: <1703620.E5bhVDQPHc@wuerfel>
Message-ID: <alpine.DEB.2.11.1411181149350.3909@nanos>
References: <alpine.DEB.2.11.1411181133080.3909@nanos> <1703620.E5bhVDQPHc@wuerfel>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2014, Arnd Bergmann wrote:

> On Tuesday 18 November 2014 11:34:37 Thomas Gleixner wrote:
> > To support MSI irq domains we want a generic data structure for
> > allocation, but we need the option to provide an architecture specific
> > version of it. So instead of playing #ifdef games in linux/msi.h we
> > add a generic header file and let architectures decide whether to
> > include it or to provide their own implementation and provide the
> > required typedef.
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> for merging the asm-generic file
> 
> > I know that typedefs are not really nice, but in this case there are no
> > forward declarations required and it's the simplest solution.
> 
> I must be missing the obvious: what problem does the typedef solve
> that you would have with just a struct?

It's not obvious. :)

The irqdomain stuff is pretty device tree centric, but the new stacked
irqdomains are to be used by x86 as well. So we made some of the
interfaces opaque, i.e. void *allocation_arg.

Now MSI is a bit differnet as it cannot be decribed by DT, so we want
a proper generic data structure for it and of course we want to have a
type for it.

Now x86 has a bit more convoluted requirements where we prefer for
simplicity reasons to reuse the allocation data structure which we
have alredy for the non MSI cases, so it can be handed down to the
opaque interfaces as well.

So we have the generic:
 
struct msi_alloc_info {
       ....
};

and 

struct x86_alloc_info {
       ...
};

So we either can do in x86:

struct msi_alloc_info {
       struct x86_alloc_info info;
};

or use a typedef which maps x86_alloc_info to msi_alloc_info_t.

I think the typedef is more sane in that case.

Thanks,

	tglx




