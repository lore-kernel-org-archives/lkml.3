Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932130Ab3HMUxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:53:49 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:31298 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759076Ab3HMUxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:53:48 -0400
Date: Tue, 13 Aug 2013 16:53:32 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [Xen-devel] [PATCH] xen/hvc: If we use xen_raw_printk let it
 also work on HVM guests.
Message-ID: <20130813205332.GA10243@phenom.dumpdata.com>
References: <1376060133-6382-1-git-send-email-konrad.wilk@oracle.com>
 <1376425904.9273.25.camel@hastur.hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376425904.9273.25.camel@hastur.hellion.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 09:31:44PM +0100, Ian Campbell wrote:
> On Fri, 2013-08-09 at 10:55 -0400, Konrad Rzeszutek Wilk wrote:
> > The xen_raw_printk works great for debugging purposes and for
> > it print anything the Xen hypervisor has to be built with 'debug=y'.
> > 
> > As such there is no difference between a PV or an PVHVM guest
> > using the hypercall, so lets use it.
> >
> > Lastly if the hyper-page is not setup yet (for example during
> > early HVM boot), then use the 0xe9 port if it has detected
> > that it is running under an Xen hypervisor.
> 
> Does this really do what you say?
> 
> I think xen_pv_domain returns false for a PVHVM guest, meaning that we
> only use the hypercall for proper PV guests and for PVHVM we use port
> 0xe9 until the hypercall page is setup at which point we silently
> discard any attempt to print via this mechanism.
> 

'via this mechanism' refers to 0xe9 or dom0_write_console?

> or am I reading it wrong?

The code did have a bug as it would on HVM (after the hyper-page
was setup) still use 0xe9 instead of the dom0_write_console.

What it should be is:
> >  
> >  void xen_raw_console_write(const char *str)
> >  {
> > -	dom0_write_console(0, str, strlen(str));
> > +	if (!xen_domain())
> > +		return;
> > +
> > +	if (xen_pv_domain())
            xen_domain()

> > +		dom0_write_console(0, str, strlen(str));
> > +	else if (xen_hvm_domain() || xen_cpuid_base()) {
     
	else if (xen_cpuid_base()) {

> > +		/* The hyperpage has not been setup yet. */
> > +		int i, len = strlen(str);
> > +		for (i = 0; i < len; i++)
> > +			 outb(str[i], 0xe9);
> > +	}
> >  }

And then that should adhere to what I wrote up.
Thanks for pointing this out!
