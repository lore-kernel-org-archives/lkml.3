Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752907AbaAWDV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 22:21:58 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:44116 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbaAWDV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 22:21:56 -0500
Date: Wed, 22 Jan 2014 19:21:49 -0800
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: boris.ostrovsky@oracle.com, david.vrabel@citrix.com, roger.pau@citrix.com,
        Xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [V0 PATCH] xen/pvh: set some cr flags upon vcpu start
Message-ID: <20140122192149.5f9205f7@mantra.us.oracle.com>
In-Reply-To: <20140120150930.GA4598@phenom.dumpdata.com>
References: <1390011895-28123-1-git-send-email-mukesh.rathor@oracle.com>
	<1390011895-28123-2-git-send-email-mukesh.rathor@oracle.com>
	<20140120150930.GA4598@phenom.dumpdata.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.18.9; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jan 2014 10:09:30 -0500
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> On Fri, Jan 17, 2014 at 06:24:55PM -0800, Mukesh Rathor wrote:
> > pvh was designed to start with pv flags, but a commit in xen tree
> 
> Thank you for posting this!
> 
> > 51e2cac257ec8b4080d89f0855c498cbbd76a5e5 removed some of the flags
> > as
> 
> You need to always include the title of said commit.
> 
> > they are not necessary. As a result, these CR flags must be set in
> > the guest.
> 
> I sent out replies to this over the weekend but somehow they are not
> showing up.
> 

Well, they finally showed up today... US mail must be slow :)...


> 
> > +
> > +	if (!cpu)
> > +		return;
> 
> And what happens if don't have this check? Will be bad if do multiple
> cr4 writes?

no, but just confuses the reader/debugger of the code IMO :)... 


> Fyi, this (cr4) should have been a seperate patch. I fixed it up that
> way.
> > +	/*
> > +	 * Unlike PV, for pvh xen does not set: PSE PGE OSFXSR
> > OSXMMEXCPT
> > +	 * For BSP, PSE PGE will be set in probe_page_size_mask(),
> > for AP
> > +	 * set them here. For all, OSFXSR OSXMMEXCPT will be set
> > in fpu_init
> > +	 */
> > +	if (cpu_has_pse)
> > +		set_in_cr4(X86_CR4_PSE);
> > +
> > +	if (cpu_has_pge)
> > +		set_in_cr4(X86_CR4_PGE);
> > +}
> 
> Seperate patch and since the PGE part is more complicated that just
> setting the CR4 - you also have to tweak this:
> 
> 1512         /* Prevent unwanted bits from being set in PTEs.
> */ 1513         __supported_pte_mask &=
> ~_PAGE_GLOBAL;                                  
> 
> I think it should be done once we have actually confirmed that you can
> do 2MB pages within the guest. (might need some more tweaking?)

Umm... well, the above is just setting the PSE and PGE in the APs, the
BSP is already doing that in probe_page_size_mask, and setting 
__supported_pte_mask which needs to be set just once. So, because it's
being set in the BSP, it's already broken/untested if we add expose of PGE
from xen to a linux PVH guest... 

IOW, leaving above is no more harm, or we should 'if (pvh)' the code in 
probe_page_size_mask() for PSE, and wait till we can test it...

thanks
Mukesh

