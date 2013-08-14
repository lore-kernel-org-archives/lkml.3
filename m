Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932486Ab3HNMq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 08:46:58 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:35561 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932438Ab3HNMq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 08:46:56 -0400
Date: Wed, 14 Aug 2013 08:46:47 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] xen/hvc: If we use xen_raw_printk let it
 also work on HVM guests.
Message-ID: <20130814124647.GD10764@phenom.dumpdata.com>
References: <1376060133-6382-1-git-send-email-konrad.wilk@oracle.com>
 <1376425904.9273.25.camel@hastur.hellion.org.uk>
 <20130813205332.GA10243@phenom.dumpdata.com>
 <1376427570.9273.39.camel@hastur.hellion.org.uk>
 <1376432405.9273.54.camel@hastur.hellion.org.uk>
 <20130814001050.GA10492@phenom.dumpdata.com>
 <1376464556.9273.75.camel@hastur.hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376464556.9273.75.camel@hastur.hellion.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 08:15:56AM +0100, Ian Campbell wrote:
> On Tue, 2013-08-13 at 20:10 -0400, Konrad Rzeszutek Wilk wrote:
> > On Tue, Aug 13, 2013 at 11:20:05PM +0100, Ian Campbell wrote:
> > > On Tue, 2013-08-13 at 21:59 +0100, Ian Campbell wrote:
> > > 
> > > > > What it should be is:
> > > > > > >  
> > > > > > >  void xen_raw_console_write(const char *str)
> > > > > > >  {
> > > > > > > -	dom0_write_console(0, str, strlen(str));
> > > > > > > +	if (!xen_domain())
> > > > > > > +		return;
> > > > > > > +
> > > > > > > +	if (xen_pv_domain())
> > > > >             xen_domain()
> > > > > 
> > > > > > > +		dom0_write_console(0, str, strlen(str));
> > > > > > > +	else if (xen_hvm_domain() || xen_cpuid_base()) {
> > > > >      
> > > > > 	else if (xen_cpuid_base()) {
> > > > > 
> > > > > > > +		/* The hyperpage has not been setup yet. */
> > > > > > > +		int i, len = strlen(str);
> > > > > > > +		for (i = 0; i < len; i++)
> > > > > > > +			 outb(str[i], 0xe9);
> > > > > > > +	}
> > > > > > >  }
> > > > > 
> > > > > And then that should adhere to what I wrote up.
> > > > 
> > > > I think it does too.
> > > 
> > > Except as Daniel notes in <520A7145.5010306@tycho.nsa.gov> for unrelated
> > > reasons:
> > > 
> > > >         HVM guests can still use the PV output - they just need to use the console
> > > >         write hypercall instead of the HVM I/O port. I would think that PVH guests
> > > >         would default to using the hypercall as it is more efficient (it takes a
> > > >         string rather than one character per write).
> > > >         
> > > >         Actually, checking... the console_io hypercall would need to be added to
> > > >         the hvm_hypercall{32,64}_table for an HVM guest to be able to use it; they
> > > >         currently must use the I/O port. I didn't check the PVH patches.
> > > 
> > > Or did you actually try this code and it worked?
> > 
> > The one I typed up above - no. The one I had sent - yes.
> > 
> > But with that above mentioned comment from Daniel I think it is still
> > worth trying to do dom0_write_console and if the hypercall returns -ENOSYS 
> > then fall back on 0xe9.
> > 
> > And lastly send an patch to make hypercall_io work under HVM.
> 
> So you didn't try under PVHVM? That's what I was asking when I asked if
> you tried it, since that is the point of this patch.

Not the one I typed up above. Just the one I sent. I have a habit of
sending patches that have been tested first - and I hadn't had the chance
yet to redo it the way above.

> 
> Ian.
> 
> Ian.
> 
