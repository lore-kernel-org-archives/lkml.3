Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233Ab3HOOks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 10:40:48 -0400
Received: from smtp.citrix.com ([66.165.176.89]:9419 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757535Ab3HOOkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 10:40:46 -0400
X-IronPort-AV: E=Sophos;i="4.89,885,1367971200"; 
   d="scan'208";a="44578068"
Message-ID: <1376577638.9273.188.camel@hastur.hellion.org.uk>
Subject: Re: [Xen-devel] [PATCH] xen/hvc: If we use xen_raw_printk let it
 also work on HVM guests.
From: Ian Campbell <ian.campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
Date: Thu, 15 Aug 2013 15:40:38 +0100
In-Reply-To: <20130814124647.GD10764@phenom.dumpdata.com>
References: <1376060133-6382-1-git-send-email-konrad.wilk@oracle.com>
	 <1376425904.9273.25.camel@hastur.hellion.org.uk>
	 <20130813205332.GA10243@phenom.dumpdata.com>
	 <1376427570.9273.39.camel@hastur.hellion.org.uk>
	 <1376432405.9273.54.camel@hastur.hellion.org.uk>
	 <20130814001050.GA10492@phenom.dumpdata.com>
	 <1376464556.9273.75.camel@hastur.hellion.org.uk>
	 <20130814124647.GD10764@phenom.dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-14 at 08:46 -0400, Konrad Rzeszutek Wilk wrote:
> On Wed, Aug 14, 2013 at 08:15:56AM +0100, Ian Campbell wrote:
> > On Tue, 2013-08-13 at 20:10 -0400, Konrad Rzeszutek Wilk wrote:
> > > On Tue, Aug 13, 2013 at 11:20:05PM +0100, Ian Campbell wrote:
> > > > On Tue, 2013-08-13 at 21:59 +0100, Ian Campbell wrote:
> > > > 
> > > > > > What it should be is:
> > > > > > > >  
> > > > > > > >  void xen_raw_console_write(const char *str)
> > > > > > > >  {
> > > > > > > > -	dom0_write_console(0, str, strlen(str));
> > > > > > > > +	if (!xen_domain())
> > > > > > > > +		return;
> > > > > > > > +
> > > > > > > > +	if (xen_pv_domain())
> > > > > >             xen_domain()
> > > > > > 
> > > > > > > > +		dom0_write_console(0, str, strlen(str));
> > > > > > > > +	else if (xen_hvm_domain() || xen_cpuid_base()) {
> > > > > >      
> > > > > > 	else if (xen_cpuid_base()) {
> > > > > > 
> > > > > > > > +		/* The hyperpage has not been setup yet. */
> > > > > > > > +		int i, len = strlen(str);
> > > > > > > > +		for (i = 0; i < len; i++)
> > > > > > > > +			 outb(str[i], 0xe9);
> > > > > > > > +	}
> > > > > > > >  }
> > > > > > 
> > > > > > And then that should adhere to what I wrote up.
> > > > > 
> > > > > I think it does too.
> > > > 
> > > > Except as Daniel notes in <520A7145.5010306@tycho.nsa.gov> for unrelated
> > > > reasons:
> > > > 
> > > > >         HVM guests can still use the PV output - they just need to use the console
> > > > >         write hypercall instead of the HVM I/O port. I would think that PVH guests
> > > > >         would default to using the hypercall as it is more efficient (it takes a
> > > > >         string rather than one character per write).
> > > > >         
> > > > >         Actually, checking... the console_io hypercall would need to be added to
> > > > >         the hvm_hypercall{32,64}_table for an HVM guest to be able to use it; they
> > > > >         currently must use the I/O port. I didn't check the PVH patches.
> > > > 
> > > > Or did you actually try this code and it worked?
> > > 
> > > The one I typed up above - no. The one I had sent - yes.
> > > 
> > > But with that above mentioned comment from Daniel I think it is still
> > > worth trying to do dom0_write_console and if the hypercall returns -ENOSYS 
> > > then fall back on 0xe9.
> > > 
> > > And lastly send an patch to make hypercall_io work under HVM.
> > 
> > So you didn't try under PVHVM? That's what I was asking when I asked if
> > you tried it, since that is the point of this patch.
> 
> Not the one I typed up above. Just the one I sent.

And did it work? ecause if the console_io hypercall isn't wired up in
the hypervisor I can't see how it can have done...

Oh the original patch would buggily never have tried to use console_io,
and you probably didn't notice the lack of output after the hypercall
page was setup.

Ian.

