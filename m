Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab3IVTeM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 15:34:12 -0400
Received: from mail-1.atlantis.sk ([80.94.52.57]:32893 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab3IVTeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 15:34:10 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] pata_isapnp: Don't use invalid I/O ports
Date: Sun, 22 Sep 2013 21:33:29 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1379019689-21467-1-git-send-email-linux@rainbow-software.org> <201309132344.27778.linux@rainbow-software.org> <20130922164942.GA30946@htj.dyndns.org>
In-Reply-To: <20130922164942.GA30946@htj.dyndns.org>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201309222133.29741.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sunday 22 September 2013 18:49:42 Tejun Heo wrote:
> Hello, Ondrej.
>
> On Fri, Sep 13, 2013 at 11:44:27PM +0200, Ondrej Zary wrote:
> > This is caused by skipping ata_sff_softreset() when ap->ioaddr.ctl_addr
> > is unset so ata_devchk() is never called. This patch seems to fix the
> > problem. Is it OK or can it cause more problems?
> >
> > --- a/drivers/ata/libata-sff.c
> > +++ b/drivers/ata/libata-sff.c
> > @@ -2008,13 +2008,15 @@ static int ata_bus_softreset(struct ata_port *ap,
> > unsigned int devmask,
> >
> >  	DPRINTK("ata%u: bus reset via SRST\n", ap->print_id);
> >
> > -	/* software reset.  causes dev0 to be selected */
> > -	iowrite8(ap->ctl, ioaddr->ctl_addr);
> > -	udelay(20);	/* FIXME: flush */
> > -	iowrite8(ap->ctl | ATA_SRST, ioaddr->ctl_addr);
> > -	udelay(20);	/* FIXME: flush */
> > -	iowrite8(ap->ctl, ioaddr->ctl_addr);
> > -	ap->last_ctl = ap->ctl;
> > +	if (ap->ioaddr.ctl_addr) {
> > +		/* software reset.  causes dev0 to be selected */
> > +		iowrite8(ap->ctl, ioaddr->ctl_addr);
> > +		udelay(20);	/* FIXME: flush */
> > +		iowrite8(ap->ctl | ATA_SRST, ioaddr->ctl_addr);
> > +		udelay(20);	/* FIXME: flush */
> > +		iowrite8(ap->ctl, ioaddr->ctl_addr);
> > +		ap->last_ctl = ap->ctl;
> > +	}
> >
> >  	/* wait the port to become ready */
> >  	return ata_sff_wait_after_reset(&ap->link, devmask, deadline);
> > @@ -2215,10 +2217,6 @@ void ata_sff_error_handler(struct ata_port *ap)
> >
> >  	spin_unlock_irqrestore(ap->lock, flags);
> >
> > -	/* ignore ata_sff_softreset if ctl isn't accessible */
> > -	if (softreset == ata_sff_softreset && !ap->ioaddr.ctl_addr)
> > -		softreset = NULL;
> > -
> >  	/* ignore built-in hardresets if SCR access is not available */
> >  	if ((hardreset == sata_std_hardreset ||
> >  	     hardreset == sata_sff_hardreset) && !sata_scr_valid(&ap->link))
>
> Hmm... I'm unsure what to do with these patches.  It's a mostly dead
> driver, so I don't wanna mess with it too much unless it's an obvious
> fix.  What hardware are you playing with?

IMHO, the first patch (invalid I/O ports) is an obvious fix. That bug causes 
problems with ES968 sound cards.

The second patch is not-so-obvious. Only few ATA controllers don't have 
control register, but they're all broken now. I'm not sure if the patch is 
100% correct but it seems to work fine and it does not affect most 
controllers.

-- 
Ondrej Zary
