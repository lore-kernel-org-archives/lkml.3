Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab3KSOsP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:48:15 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:26983 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393Ab3KSOsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:48:10 -0500
Date: Tue, 19 Nov 2013 09:46:30 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Elena Ufimtseva <ufimtseva@gmail.com>, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, akpm@linux-foundation.org,
        tangchen@cn.fujitsu.com, wency@cn.fujitsu.com, ian.campbell@citrix.com,
        stefano.stabellini@eu.citrix.com, mukesh.rathor@oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v2 2/2] xen: enable vnuma for PV guest
Message-ID: <20131119144630.GA5780@phenom.dumpdata.com>
References: <1384811922-14642-1-git-send-email-ufimtseva@gmail.com>
 <1384811922-14642-3-git-send-email-ufimtseva@gmail.com>
 <528B5160.5010902@citrix.com>
 <20131119141620.GD5332@phenom.dumpdata.com>
 <528B774F.7090902@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528B774F.7090902@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 02:35:59PM +0000, David Vrabel wrote:
> On 19/11/13 14:16, Konrad Rzeszutek Wilk wrote:
> > On Tue, Nov 19, 2013 at 11:54:08AM +0000, David Vrabel wrote:
> >> On 18/11/13 21:58, Elena Ufimtseva wrote:
> >>> Enables numa if vnuma topology hypercall is supported and it is domU.
> >> [...]
> >>> --- a/arch/x86/xen/setup.c
> >>> +++ b/arch/x86/xen/setup.c
> >>> @@ -20,6 +20,7 @@
> >>>  #include <asm/numa.h>
> >>>  #include <asm/xen/hypervisor.h>
> >>>  #include <asm/xen/hypercall.h>
> >>> +#include <asm/xen/vnuma.h>
> >>>  
> >>>  #include <xen/xen.h>
> >>>  #include <xen/page.h>
> >>> @@ -598,6 +599,9 @@ void __init xen_arch_setup(void)
> >>>  	WARN_ON(xen_set_default_idle());
> >>>  	fiddle_vdso();
> >>>  #ifdef CONFIG_NUMA
> >>> -	numa_off = 1;
> >>> +	if (!xen_initial_domain() && xen_vnuma_supported())
> >>> +		numa_off = 0;
> >>> +	else
> >>> +		numa_off = 1;
> >>>  #endif
> >>>  }
> >>
> >> I think this whole #ifdef CONFIG_NUMA can be removed and hence
> >> xen_vnuma_supported() can be removed as well.
> >>
> >> For any PV guest we can call the xen_numa_init() and it will do the
> >> right thing.
> >>
> >> For dom0, the hypercall will either: return something sensible (if in
> >> the future Xen sets something up), or it will error.
> >>
> >> If Xen does not have vnuma support, the hypercall will error.
> >>
> >> In both error cases, the dummy numa node is setup as required.
> > 
> > Incorrect. It will end up calling:
> > 
> >                  if (!numa_init(amd_numa_init))                                  
> > 
> > which will crash dom0 (see 8d54db795 "xen/boot: Disable NUMA for PV guests.")
> > as that amd_numa_init is called before the dummy node init.
> 
> No it won't.  Any error path after the check for a PV guest will add the
> dummy node and return success, skipping any of the hardware-specific setup.

Duh! I totally missed 'return' at the end of the check!

However, even with that (so the return), that means
this part won't be called:

649         numa_init(dummy_numa_init);                                             

Which means there won't be any dummy numa setup?

