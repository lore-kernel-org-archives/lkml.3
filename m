Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904Ab3J1Psp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 11:48:45 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:37106 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab3J1Pso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 11:48:44 -0400
Date: Mon, 28 Oct 2013 11:48:37 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: Julien Grall <julien.grall@linaro.org>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [Xen-devel] [PATCH] xen/hvc-console: Make it work with HVM
 guests.
Message-ID: <20131028154837.GC4353@phenom.dumpdata.com>
References: <5245FD71.3080408@linaro.org>
 <20130930144513.GM3106@phenom.dumpdata.com>
 <5251CD98.70807@linaro.org>
 <20131023161518.GA28413@phenom.dumpdata.com>
 <526848C1.5030705@linaro.org>
 <20131024144921.GB29944@phenom.dumpdata.com>
 <52694B3F.5090008@linaro.org>
 <1382633034.22417.121.camel@hastur.hellion.org.uk>
 <20131025193812.GA6256@phenom.dumpdata.com>
 <1382776028.22417.174.camel@hastur.hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382776028.22417.174.camel@hastur.hellion.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 26, 2013 at 09:27:08AM +0100, Ian Campbell wrote:
> On Fri, 2013-10-25 at 15:38 -0400, Konrad Rzeszutek Wilk wrote:
> > On Thu, Oct 24, 2013 at 05:43:54PM +0100, Ian Campbell wrote:
> > > But stepping back how/why is this function called on x86 when not
> > > running under Xen? Wouldn't the use have to be using console=hvc or
> > > earlyprintk=xen or something -- which strikes me as user error... IOW
> > > can we not just nuke the check
> > 
> > It shouldn't - ever. On x86 it is called from the early PV bootup code.
> > 
> > I occasionaly use it when developing/debugging and as such want it working
> > in HVM even during early bootup.
> 
> Does earlyprintk=ttyS0,cough not Just Work for HVM guests? That would
> avoid all of this stuff and assuming it works would be preferable IMHO.

It works OK. But this is an alternative avenue of using 'xen_raw_printk'
for both PV and HVM.

> 
> Anyway, if not, then given that the xen_cpuid_base case is entirely x86
> specific perhaps we can abstract this as something like:
> 
> 	if (xen_arch_raw_console(str))
> 		return
> 
> 	dom0_write_console(...)
> 
> Then ARM:
> 	#define xen_arch_raw_console 0
> and x86
> 	static inline int xen_arch_raw_console(str)
> 	{
> 		if (xen_domain())
> 			return 0;
> 
> 		/* Do the outb thing */
> 		return 1;
> 	}
> 
> This would also avoid the need for #ifdef x86 in the main function which
> Julien pointed out.

OK.
> 
> Ian.
> 
