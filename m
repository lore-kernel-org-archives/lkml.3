Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab3A3J2v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 04:28:51 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:55249 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262Ab3A3J1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 04:27:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Matt Porter <mporter@ti.com>
Subject: Re: [PATCH v6 07/10] dmaengine: add dma_request_slave_channel_compat()
Date: Wed, 30 Jan 2013 09:27:18 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-1-generic; KDE/4.3.2; x86_64; ; )
Cc: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, Rob Landley <rob@landley.net>,
        Chris Ball <cjb@laptop.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Dan Williams <djbw@fb.com>, Rob Herring <rob.herring@calxeda.com>
References: <1359529229-22207-1-git-send-email-mporter@ti.com> <1359529229-22207-8-git-send-email-mporter@ti.com>
In-Reply-To: <1359529229-22207-8-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301300927.18509.arnd@arndb.de>
X-Provags-ID: V02:K0:YPk11cMVDqQR0rcvcgGHN/3HScOb8LsNd4Ah8TLDMI4
 /kJuUypDCxcshZV0z+FfAIlop9QcwJvqc2dRaD6XMYvS2K5eaE
 /77sY8zTfN4YUbsXkm5O9yR241GIjTHqHnN/iQi3EbW4KH08ZC
 6KYeOP09Py781AxgmSDeYw2MljnQp9J28AoRT2NwfqfoI4ZwwQ
 RkTTbvfHzTOqbZmbo+6vIMMCw/RqaP+tdJF/SPYSYiEGG7jHrM
 XtC+bw0Ccebu+LQTjs+A4xnGJeOm/CiKXr2X22ePk+LXk8U3+F
 mPIcvEuMdM75GZa2EzCW6LHlsszrnNg2qzMjifYkrmbINCy7ae
 EDdUUWz2DErU8dOaEH+8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 January 2013, Matt Porter wrote:
> Adds a dma_request_slave_channel_compat() wrapper which accepts
> both the arguments from dma_request_channel() and
> dma_request_slave_channel(). Based on whether the driver is
> instantiated via DT, the appropriate channel request call will be
> made.
> 
> This allows for a much cleaner migration of drivers to the
> dmaengine DT API as platforms continue to be mixed between those
> that boot using DT and those that do not.
> 
> Suggested-by: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Matt Porter <mporter@ti.com>
> Acked-by: Tony Lindgren <tony@atomide.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>

> @@ -1001,6 +1001,22 @@ void dma_run_dependencies(struct dma_async_tx_descriptor *tx);
>  struct dma_chan *dma_find_channel(enum dma_transaction_type tx_type);
>  struct dma_chan *net_dma_find_channel(void);
>  #define dma_request_channel(mask, x, y) __dma_request_channel(&(mask), x, y)
> +#define dma_request_slave_channel_compat(mask, x, y, dev, name) \
> +	__dma_request_slave_channel_compat(&(mask), x, y, dev, name)
> +
> +static inline struct dma_chan
> +*__dma_request_slave_channel_compat(dma_cap_mask_t *mask, dma_filter_fn fn,
> +				  void *fn_param, struct device *dev,
> +				  char *name)
> +{
> +	struct dma_chan *chan;
> +
> +	chan = dma_request_slave_channel(dev, name);
> +	if (chan)
> +		return chan;
> +
> +	return __dma_request_channel(mask, fn, fn_param);
> +}

After I have spent some more time with implementing the code for dw_dma,
I think the mask is actually unnecessary here, the helper could just
always set it to DMA_SLAVE before calling __dma_request_channel.

It's not a bug to do it this way though, and it may help convert drivers
a little easier if there is less to change.

	Arnd
