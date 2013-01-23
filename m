Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab3AWW3k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 17:29:40 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:54910 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab3AWW3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 17:29:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Matt Porter <mporter@ti.com>
Subject: Re: [PATCH v5 07/14] dmaengine: add dma_request_slave_channel_compat()
Date: Wed, 23 Jan 2013 22:28:46 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
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
References: <1358281974-8411-1-git-send-email-mporter@ti.com> <1358281974-8411-8-git-send-email-mporter@ti.com>
In-Reply-To: <1358281974-8411-8-git-send-email-mporter@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301232228.46716.arnd@arndb.de>
X-Provags-ID: V02:K0:FKU9UoZs/61UN2WTXH0LuUALS1mSfU50NSDT4rCGfz/
 C25mCtL5unYXUeyVn3SbfeOQvT75Per9fnNlZLHTbY+1W+USV6
 R8uniTTYvJapiz7TJ6t3g19wNK2EpkhXFe3F0duxMKXT86LFdA
 c68uPHTPnGxASCgCqJJizObATjqr41FNL4mdqhxTgUkOI8/9+O
 TzfzyWfv1qa75u6b2ZfMHzBohz0ruKnJ+2xr45ZHxTUqIqgpwH
 l+Dm7q578uv5NQAZA1h/XA9dSKWTG/KpqxagWdTFnvBVakXLpi
 QqOpm39v30tHP5fUQ0c2lTJmwswDQwxCNx5Ym/zmWCg8hXJDHF
 lZKMbpslgvni6QKEP/EI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 January 2013, Matt Porter wrote:
> Adds a dma_request_slave_channel_compat() wrapper which accepts
> both the arguments from dma_request_channel() and
> dma_request_slave_channel(). Based on whether the driver is
> instantiated via DT, the appropriate channel request call will be
> made.
> 
> This allows for a much cleaner migration of drivers to the
> dmaengine DT API as platforms continue to be mixed between those
> that boot using DT and those that do not.

I noticed today some drivers in linux-next that rely on this patch,
but the patch itself still missing from -next.

> --- a/include/linux/dmaengine.h
> +++ b/include/linux/dmaengine.h
> @@ -1047,6 +1047,16 @@ void dma_run_dependencies(struct dma_async_tx_descriptor *tx);
>  struct dma_chan *dma_find_channel(enum dma_transaction_type tx_type);
>  struct dma_chan *net_dma_find_channel(void);
>  #define dma_request_channel(mask, x, y) __dma_request_channel(&(mask), x, y)
> +static inline struct dma_chan
> +*dma_request_slave_channel_compat(dma_cap_mask_t mask, dma_filter_fn fn,
> +                                 void *fn_param, struct device *dev,
> +                                 char *name)
> +{
> +       if (dev->of_node)
> +               return dma_request_slave_channel(dev, name);
> +       else
> +               return dma_request_channel(mask, fn, fn_param);
> +}

Hmm, dma_request_channel is actually a macro that passes mask by reference,
presumably because it can get modified by the filter function. Also, there
may be cases where we do have an of_node but don't use the dma binding
yet, or where dma_request_slave_channel doesn't actually use DT information
but rather one of the other methods that Vinod was talking about adding.

I think what it should look like instead is the below.

	Arnd

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index bfcdecb..b6ffd7d 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -993,6 +993,19 @@ static inline void dma_release_channel(struct dma_chan *chan)
 }
 #endif
 
+static inline struct dma_chan *__dma_request_slave_channel_compat(dma_cap_mask_t *mask,
+				dma_filter_fn fn, void *fn_param, struct device *dev,
+				 char *name)
+{
+	struct dma_chan *chan;
+
+	chan = dma_request_slave_channel(dev, name);
+	if (chan)
+		return chan;
+
+	return __dma_request_channel(mask, fn, fn_param);
+}
+
 /* --- DMA device --- */
 
 int dma_async_device_register(struct dma_device *device);
@@ -1001,6 +1014,8 @@ void dma_run_dependencies(struct dma_async_tx_descriptor *tx);
 struct dma_chan *dma_find_channel(enum dma_transaction_type tx_type);
 struct dma_chan *net_dma_find_channel(void);
 #define dma_request_channel(mask, x, y) __dma_request_channel(&(mask), x, y)
+#define dma_request_slave_channel_compat(mask, x, y, dev, name) \
+	 __dma_request_slave_channel_compat(&(mask), x, y, dev, name)
 
 /* --- Helper iov-locking functions --- */
 
