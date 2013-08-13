Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373Ab3HMWUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 18:20:11 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:12668 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759255Ab3HMWUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 18:20:08 -0400
X-IronPort-AV: E=Sophos;i="4.89,873,1367971200"; 
   d="scan'208";a="41891402"
Message-ID: <1376432405.9273.54.camel@hastur.hellion.org.uk>
Subject: Re: [Xen-devel] [PATCH] xen/hvc: If we use xen_raw_printk let it
 also work on HVM guests.
From: Ian Campbell <ian.campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
Date: Tue, 13 Aug 2013 23:20:05 +0100
In-Reply-To: <1376427570.9273.39.camel@hastur.hellion.org.uk>
References: <1376060133-6382-1-git-send-email-konrad.wilk@oracle.com>
	 <1376425904.9273.25.camel@hastur.hellion.org.uk>
	 <20130813205332.GA10243@phenom.dumpdata.com>
	 <1376427570.9273.39.camel@hastur.hellion.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-13 at 21:59 +0100, Ian Campbell wrote:

> > What it should be is:
> > > >  
> > > >  void xen_raw_console_write(const char *str)
> > > >  {
> > > > -	dom0_write_console(0, str, strlen(str));
> > > > +	if (!xen_domain())
> > > > +		return;
> > > > +
> > > > +	if (xen_pv_domain())
> >             xen_domain()
> > 
> > > > +		dom0_write_console(0, str, strlen(str));
> > > > +	else if (xen_hvm_domain() || xen_cpuid_base()) {
> >      
> > 	else if (xen_cpuid_base()) {
> > 
> > > > +		/* The hyperpage has not been setup yet. */
> > > > +		int i, len = strlen(str);
> > > > +		for (i = 0; i < len; i++)
> > > > +			 outb(str[i], 0xe9);
> > > > +	}
> > > >  }
> > 
> > And then that should adhere to what I wrote up.
> 
> I think it does too.

Except as Daniel notes in <520A7145.5010306@tycho.nsa.gov> for unrelated
reasons:

>         HVM guests can still use the PV output - they just need to use the console
>         write hypercall instead of the HVM I/O port. I would think that PVH guests
>         would default to using the hypercall as it is more efficient (it takes a
>         string rather than one character per write).
>         
>         Actually, checking... the console_io hypercall would need to be added to
>         the hvm_hypercall{32,64}_table for an HVM guest to be able to use it; they
>         currently must use the I/O port. I didn't check the PVH patches.

Or did you actually try this code and it worked?

Ian.

