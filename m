Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967074Ab3DRJZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:25:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61446 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab3DRJZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:25:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH] mmc: mmci: Allow MMCI to request channels with information acquired from DT
Date: Thu, 18 Apr 2013 11:25:44 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org
References: <1366205534-25079-1-git-send-email-lee.jones@linaro.org> <20130418080238.GB3137@gmail.com> <20130418081549.GE14496@n2100.arm.linux.org.uk>
In-Reply-To: <20130418081549.GE14496@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304181125.44983.arnd@arndb.de>
X-Provags-ID: V02:K0:HGs4jvCbGiAZVBj7koLQ+ekcu3JmQlyLa0ClxHNqGUH
 DOgovapFBvIZ9um1xyweJL26Q4ij+1UAXQw/DUHByUyeltl2wo
 hXzqCGGL8XdGsEOD5ByXM6/KN3x4uX76VAvu+cXvNm7m5rKSKB
 SwBO8ChjjNUFTyl4XG2vsAGEG0kuvnK6O/3B9fX1nPwgfh47x/
 dWdx5zyz/H07w9srgnsPjN34zIbZ8/cB9YYfUlXYCagZJSk95c
 qUxyODh4GegRSAW+ZaTej6F9yeQRTPEkQnNbQoacfzt2onAeBO
 xC7gpbtf0WIe3KAjW0QwttmiwngmhzaNi6haP7sZGtsl4iOonp
 oJY1O0QM701DgkL/eQlw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 April 2013, Russell King - ARM Linux wrote:
> On Thu, Apr 18, 2013 at 09:02:38AM +0100, Lee Jones wrote:
> > @@ -321,19 +323,21 @@ static void mmci_dma_setup(struct mmci_host *host)
> >        * attempt to use it bidirectionally, however if it is
> >        * is specified but cannot be located, DMA will be disabled.
> >        */
> > -     if (plat->dma_rx_param) {
> > -             host->dma_rx_channel = dma_request_channel(mask,
> > -                                                        plat->dma_filter,
> > -                                                        plat->dma_rx_param);
> > +     if (plat->dma_rx_param || np) {
> > +             host->dma_rx_channel = dma_request_slave_channel_compat(mask,
> > +                                                             plat->dma_filter,
> > +                                                             plat->dma_rx_param,
> > +                                                             &dev->dev, "rx");
> >               /* E.g if no DMA hardware is present */
> >               if (!host->dma_rx_channel)
> >                       dev_err(mmc_dev(host->mmc), "no RX DMA channel\n");
> 
> I don't think this is right - I think Arnd has been leading you up the
> garden path saying that this can be simplified.  Why?
> 
> If you look at what this code does, the DMA channels are optional.  If
> they're not provided, then you don't get an error or a warning printk from
> the code.  However, after your conversion, if you use DT and avoid giving
> the DMA information (which you have to avoid on the majority of ARM
> platforms) then "np" will be non-NULL, and
> dma_request_slave_channel_compat() will return NULL, causing the error
> and/or warning to be printed.

Right, so I guess we should print the warning only if plat->dma_filter
is non-NULL, or we don't use dma_request_slave_channel_compat, which
does not actually simplify the code here.

	Arnd

diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
index 375c109..c97bc92 100644
--- a/drivers/mmc/host/mmci.c
+++ b/drivers/mmc/host/mmci.c
@@ -298,20 +298,11 @@ static void mmci_init_sg(struct mmci_host *host, struct mmc_data *data)
  * no custom DMA interfaces are supported.
  */
 #ifdef CONFIG_DMA_ENGINE
-static void mmci_dma_setup(struct mmci_host *host)
+static int mmci_dma_plat_setup(struct mmci_host *host)
 {
 	struct mmci_platform_data *plat = host->plat;
-	const char *rxname, *txname;
 	dma_cap_mask_t mask;
 
-	if (!plat || !plat->dma_filter) {
-		dev_info(mmc_dev(host->mmc), "no DMA platform data\n");
-		return;
-	}
-
-	/* initialize pre request cookie */
-	host->next_data.cookie = 1;
-
 	/* Try to acquire a generic DMA engine slave channel */
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
@@ -339,6 +330,25 @@ static void mmci_dma_setup(struct mmci_host *host)
 	} else {
 		host->dma_tx_channel = host->dma_rx_channel;
 	}
+}
+
+static void mmci_dma_setup(struct device *dev, struct mmci_host *host)
+{
+	const char *rxname, *txname;
+
+	host->dma_rx_channel = dma_request_slave_channel(dev, "rx");
+	host->dma_tx_channel = dma_request_slave_channel(dev, "tx");
+
+	if (!host->dma_rx_channel && !host->dma_tx_channel) {
+		if (host->plat && host->plat->dma_filter)
+			mmci_dma_plat_setup(host);
+		else
+			dev_info(mmc_dev(host->mmc), "no DMA platform data\n");
+			return;
+	}
+
+	/* initialize pre request cookie */
+	host->next_data.cookie = 1;
 
 	if (host->dma_rx_channel)
 		rxname = dma_chan_name(host->dma_rx_channel);
