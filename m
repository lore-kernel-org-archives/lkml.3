Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab3CHUCW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 15:02:22 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:28941 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149Ab3CHUCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 15:02:21 -0500
Date: Fri, 8 Mar 2013 15:01:49 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: [PATCH v2 15/26] xen, irq: call irq_realloc_desc_at() at first
Message-ID: <20130308200149.GA21611@phenom.dumpdata.com>
References: <1360351703-20571-1-git-send-email-yinghai@kernel.org>
 <1360351703-20571-16-git-send-email-yinghai@kernel.org>
 <20130308194357.GA6622@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130308194357.GA6622@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 02:43:57PM -0500, Konrad Rzeszutek Wilk wrote:
> On Fri, Feb 08, 2013 at 11:28:12AM -0800, Yinghai Lu wrote:
> > We will pre-reserve irq for all gsi at first for x86, so we have to
> > use realloc with it.
> 
> Where are the GSI's pre-allocated?

And the answer is in arch_probe_nr_irqs and determined by nr_irqs_gsi.
That data then feeds in early_irq_init which sets the bitmap.

Could you add that please in the git commit if it is not too much
trouble?
> 
> > 
> > Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> > Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > Cc: xen-devel@lists.xensource.com
> > ---
> >  drivers/xen/events.c |    8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/xen/events.c b/drivers/xen/events.c
> > index 0be4df3..dda38db 100644
> > --- a/drivers/xen/events.c
> > +++ b/drivers/xen/events.c
> > @@ -482,8 +482,12 @@ static int __must_check xen_allocate_irq_gsi(unsigned gsi)
> >  	/* Legacy IRQ descriptors are already allocated by the arch. */
> >  	if (gsi < NR_IRQS_LEGACY)
> >  		irq = gsi;
> > -	else
> > -		irq = irq_alloc_desc_at(gsi, -1);
> > +	else {
> > +		/* for x86, irq already get reserved for gsi */
> > +		irq = irq_realloc_desc_at(gsi, -1);
> > +		if (irq < 0)
> > +			irq = irq_alloc_desc_at(gsi, -1);
> > +	}
> >  
> >  	xen_irq_init(irq);
> >  
> > -- 
> > 1.7.10.4
> > 
