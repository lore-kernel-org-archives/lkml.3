Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab3IVQts (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 12:49:48 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:49752 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab3IVQtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 12:49:46 -0400
Date: Sun, 22 Sep 2013 12:49:42 -0400
From: Tejun Heo <tj@kernel.org>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pata_isapnp: Don't use invalid I/O ports
Message-ID: <20130922164942.GA30946@htj.dyndns.org>
References: <1379019689-21467-1-git-send-email-linux@rainbow-software.org>
 <201309132054.38278.linux@rainbow-software.org>
 <201309132344.27778.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201309132344.27778.linux@rainbow-software.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ondrej.

On Fri, Sep 13, 2013 at 11:44:27PM +0200, Ondrej Zary wrote:
> This is caused by skipping ata_sff_softreset() when ap->ioaddr.ctl_addr is
> unset so ata_devchk() is never called. This patch seems to fix the problem.
> Is it OK or can it cause more problems?
> 
> --- a/drivers/ata/libata-sff.c
> +++ b/drivers/ata/libata-sff.c
> @@ -2008,13 +2008,15 @@ static int ata_bus_softreset(struct ata_port *ap, unsigned int devmask,
>  
>  	DPRINTK("ata%u: bus reset via SRST\n", ap->print_id);
>  
> -	/* software reset.  causes dev0 to be selected */
> -	iowrite8(ap->ctl, ioaddr->ctl_addr);
> -	udelay(20);	/* FIXME: flush */
> -	iowrite8(ap->ctl | ATA_SRST, ioaddr->ctl_addr);
> -	udelay(20);	/* FIXME: flush */
> -	iowrite8(ap->ctl, ioaddr->ctl_addr);
> -	ap->last_ctl = ap->ctl;
> +	if (ap->ioaddr.ctl_addr) {
> +		/* software reset.  causes dev0 to be selected */
> +		iowrite8(ap->ctl, ioaddr->ctl_addr);
> +		udelay(20);	/* FIXME: flush */
> +		iowrite8(ap->ctl | ATA_SRST, ioaddr->ctl_addr);
> +		udelay(20);	/* FIXME: flush */
> +		iowrite8(ap->ctl, ioaddr->ctl_addr);
> +		ap->last_ctl = ap->ctl;
> +	}
>  
>  	/* wait the port to become ready */
>  	return ata_sff_wait_after_reset(&ap->link, devmask, deadline);
> @@ -2215,10 +2217,6 @@ void ata_sff_error_handler(struct ata_port *ap)
>  
>  	spin_unlock_irqrestore(ap->lock, flags);
>  
> -	/* ignore ata_sff_softreset if ctl isn't accessible */
> -	if (softreset == ata_sff_softreset && !ap->ioaddr.ctl_addr)
> -		softreset = NULL;
> -
>  	/* ignore built-in hardresets if SCR access is not available */
>  	if ((hardreset == sata_std_hardreset ||
>  	     hardreset == sata_sff_hardreset) && !sata_scr_valid(&ap->link))

Hmm... I'm unsure what to do with these patches.  It's a mostly dead
driver, so I don't wanna mess with it too much unless it's an obvious
fix.  What hardware are you playing with?

Thanks.

-- 
tejun
