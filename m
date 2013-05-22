Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab3EVVWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 17:22:53 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:34648 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757148Ab3EVVWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 17:22:52 -0400
From: Felipe Ferreri Tonello <eu@felipetonello.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-mmc@vger.kernel.org, ben-linux@fluff.org, cjb@laptop.org,
        arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mmc: sdhci: Added set_power sdhci_ops handler.
Date: Wed, 22 May 2013 14:22:45 -0700
Message-ID: <2537252.KzShHU8h54@localhost.localdomain>
User-Agent: KMail/4.10.2 (Linux/3.9.2-200.fc18.x86_64; KDE/4.10.2; x86_64; ; )
In-Reply-To: <Pine.LNX.4.64.1305222230050.19558@axis700.grange>
References: <1369244832-23868-1-git-send-email-eu@felipetonello.com> <1369244832-23868-2-git-send-email-eu@felipetonello.com> <Pine.LNX.4.64.1305222230050.19558@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guennadi,

On Wednesday, May 22, 2013 10:30:40 PM Guennadi Liakhovetski wrote:
> On Wed, 22 May 2013, Felipe F. Tonello wrote:
> > From: "Felipe F. Tonello" <eu@felipetonello.com>
> > 
> > This is useful for power managment purposes if a sdhci child host wants to
> > turn off some other peripheral also.
> 
> Sorry, could you elaborate a bit? In what situations is it exactly useful?
> And why cannot the regulator API be used there?

Sorry about that.

One example that I can think of is when you have a wifi module connected as a 
mmc card via sdio. So you can register a callback function in your machine 
source code to turn on/off the wifi module based on the mmc host power.

I've seen this implementation in others mmc hosts, such as omap.

Regards,

Felipe

> 
> Thanks
> Guennadi
> 
> > Signed-off-by: Felipe F. Tonello <eu@felipetonello.com>
> > ---
> > 
> >  drivers/mmc/host/sdhci.c | 8 ++++++++
> >  drivers/mmc/host/sdhci.h | 1 +
> >  2 files changed, 9 insertions(+)
> > 
> > diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> > index 2ea429c..0a026c6 100644
> > --- a/drivers/mmc/host/sdhci.c
> > +++ b/drivers/mmc/host/sdhci.c
> > @@ -1244,6 +1244,10 @@ static int sdhci_set_power(struct sdhci_host *host,
> > unsigned short power)> 
> >  	u8 pwr = 0;
> >  	
> >  	if (power != (unsigned short)-1) {
> > 
> > +
> > +		if (host->ops->set_power)
> > +			host->ops->set_power(host, true);
> > +
> > 
> >  		switch (1 << power) {
> >  		
> >  		case MMC_VDD_165_195:
> >  			pwr = SDHCI_POWER_180;
> > 
> > @@ -1259,6 +1263,10 @@ static int sdhci_set_power(struct sdhci_host *host,
> > unsigned short power)> 
> >  		default:
> >  			BUG();
> >  		
> >  		}
> > 
> > +	} else {
> > +
> > +		if (host->ops->set_power)
> > +			host->ops->set_power(host, false);
> > 
> >  	}
> >  	
> >  	if (host->pwr == pwr)
> > 
> > diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
> > index 379e09d..293d56d 100644
> > --- a/drivers/mmc/host/sdhci.h
> > +++ b/drivers/mmc/host/sdhci.h
> > @@ -294,6 +294,7 @@ struct sdhci_ops {
> > 
> >  	void	(*platform_resume)(struct sdhci_host *host);
> >  	void    (*adma_workaround)(struct sdhci_host *host, u32 intmask);
> >  	void	(*platform_init)(struct sdhci_host *host);
> > 
> > +	void	(*set_power)(struct sdhci_host *host, bool power);
> > 
> >  };
> >  
> >  #ifdef CONFIG_MMC_SDHCI_IO_ACCESSORS
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
