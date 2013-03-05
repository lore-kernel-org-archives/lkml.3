Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933127Ab3CEDsS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 22:48:18 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:35597 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932843Ab3CEDsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 22:48:14 -0500
X-IronPort-AV: E=Sophos;i="4.84,784,1355097600"; 
   d="scan'208";a="10565635"
Message-ID: <1362455124.8941.19.camel@hastur.hellion.org.uk>
Subject: Re: [PATCH LINUX v5] xen: event channel arrays are xen_ulong_t and
 not unsigned long
From: Ian Campbell <ian.campbell@citrix.com>
To: Will Deacon <will.deacon@arm.com>
CC: Rob Herring <robherring2@gmail.com>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "Keir (Xen.org)" <keir@xen.org>,
        "Stefano Stabellini" <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Tim (Xen.org)" <tim@xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Nicolas Pitre <nico@fluxnic.net>
Date: Tue, 5 Mar 2013 03:45:24 +0000
In-Reply-To: <20130305030436.GA18040@mudshark.cambridge.arm.com>
References: <1361285327.1051.115.camel@zakaz.uk.xensource.com>
	 <1361360886-2956-1-git-send-email-ian.campbell@citrix.com>
	 <51340ACD.70904@gmail.com>
	 <20130305030436.GA18040@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-05 at 03:04 +0000, Will Deacon wrote:
> Hi guys,
> 
> On Mon, Mar 04, 2013 at 02:45:33AM +0000, Rob Herring wrote:
> > On 02/20/2013 05:48 AM, Ian Campbell wrote:
> > > On ARM we want these to be the same size on 32- and 64-bit.
> > > 
> > > This is an ABI change on ARM. X86 does not change.
> > > 
> > > Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> > > Cc: Jan Beulich <JBeulich@suse.com>
> > > Cc: Keir (Xen.org) <keir@xen.org>
> > > Cc: Tim Deegan <tim@xen.org>
> > > Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > > Cc: linux-arm-kernel@lists.infradead.org
> > > Cc: xen-devel@lists.xen.org
> > > Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> [...]
> 
> > I'm seeing some some build failures on randconfig builds with this change:
> > 
> > /tmp/ccJaIZOW.s: Assembler messages:
> > /tmp/ccJaIZOW.s:831: Error: even register required -- `ldrexd r5,r6,[r4]'
> > 
> > This is with ubuntu 12.04 cross compiler (gcc version 4.6.3
> > (Ubuntu/Linaro 4.6.3-1ubuntu5)).
> > 
> > This register restriction is on ARM, but not Thumb builds. Comparing
> > this to atomic64_cmpxchg, I don't see how to fix this. Perhaps Will or
> > Nico have thoughts.
> 
> [...]
> 
> > > +	asm volatile("@ xchg_xen_ulong\n"
> > > +		"1:     ldrexd  %0, %H0, [%3]\n"
> > > +		"       strexd  %1, %2, %H2, [%3]\n"
> > > +		"       teq     %1, #0\n"
> > > +		"       bne     1b"
> > > +		: "=&r" (oldval), "=&r" (tmp)
> > > +		: "r" (val), "r" (ptr)
> > > +		: "memory", "cc");
> 
> I also can't immediately see why GCC would allocate oldval to an odd base
> register. Can you share your .config please?

I fixed something along these lines before v5 of this patch, although I
must confess I don't recall what it was that I changed (and looking at
the older versions of the patch isn't giving me any clues). I can't
reproduce it now though :-(

I'm using the 4.6.3 cross compiler from kernel.org:
ftp://ftp.kernel.org/pub/tools/crosstool/files/bin/x86_64/4.6.3/

Ian.

