Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158Ab3F3QSp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 12:18:45 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:50640 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab3F3QSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 12:18:44 -0400
Date: Sun, 30 Jun 2013 19:17:48 +0300
From: Mika Westerberg <mika.westerberg@iki.fi>
To: Ryan Mallon <rmallon@gmail.com>
Cc: H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net, broonie@kernel.org,
        grant.likely@linaro.org
Subject: Re: [PATCH 4/8] spi: spi-ep93xx: remove bits_per_word() helper
Message-ID: <20130630161748.GB786@mwesterb-mobl.lan>
References: <201306281144.04549.hartleys@visionengravers.com>
 <51CE1A8C.7070703@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51CE1A8C.7070703@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 29, 2013 at 09:21:48AM +1000, Ryan Mallon wrote:
> On 29/06/13 04:44, H Hartley Sweeten wrote:
> 
> > This inline helper function is only used to determine the bus width
> > of the current transfer (8 or 16 bit). Add a bool flag to the private
> > structure and set it appropriately for each transfer.
> > 
> > Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> > Cc: Ryan Mallon <rmallon@gmail.com>
> > Cc: Mika Westerberg <mika.westerberg@iki.fi>
> > Cc: Mark Brown <broonie@kernel.org>
> > Cc: Grant Likely <grant.likely@linaro.org>
> > ---
> >  drivers/spi/spi-ep93xx.c | 16 +++++-----------
> >  1 file changed, 5 insertions(+), 11 deletions(-)
> > 
> > diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
> > index bcfd35a..4fab3bb 100644
> > --- a/drivers/spi/spi-ep93xx.c
> > +++ b/drivers/spi/spi-ep93xx.c
> > @@ -116,6 +116,7 @@ struct ep93xx_spi {
> >  	unsigned long			min_rate;
> >  	unsigned long			max_rate;
> >  	bool				running;
> > +	bool				word_xfer;
> 
> 
> I think this is a slightly confusing name. Maybe something like
> is_16bit_xfer would be better?
> 
> >  	struct workqueue_struct		*wq;
> >  	struct work_struct		msg_work;
> >  	struct completion		wait;
> > @@ -407,17 +408,9 @@ static void ep93xx_spi_chip_setup(const struct ep93xx_spi *espi,
> >  	writew(cr0, espi->regs_base + SSPCR0);
> >  }
> >  
> > -static inline int bits_per_word(const struct ep93xx_spi *espi)
> > -{
> > -	struct spi_message *msg = espi->current_msg;
> > -	struct spi_transfer *t = msg->state;
> > -
> > -	return t->bits_per_word;
> > -}
> > -
> >  static void ep93xx_do_write(struct ep93xx_spi *espi, struct spi_transfer *t)
> >  {
> > -	if (bits_per_word(espi) > 8) {
> > +	if (espi->word_xfer) {
> >  		u16 tx_val = 0;
> >  
> >  		if (t->tx_buf)
> > @@ -436,7 +429,7 @@ static void ep93xx_do_write(struct ep93xx_spi *espi, struct spi_transfer *t)
> >  
> >  static void ep93xx_do_read(struct ep93xx_spi *espi, struct spi_transfer *t)
> >  {
> > -	if (bits_per_word(espi) > 8) {
> > +	if (espi->word_xfer) {
> >  		u16 rx_val;
> >  
> >  		rx_val = readw(espi->regs_base + SSPDR);
> > @@ -522,7 +515,7 @@ ep93xx_spi_dma_prepare(struct ep93xx_spi *espi, enum dma_transfer_direction dir)
> >  	size_t len = t->len;
> >  	int i, ret, nents;
> >  
> > -	if (bits_per_word(espi) > 8)
> > +	if (espi->word_xfer)
> >  		buswidth = DMA_SLAVE_BUSWIDTH_2_BYTES;
> >  	else
> >  		buswidth = DMA_SLAVE_BUSWIDTH_1_BYTE;
> > @@ -699,6 +692,7 @@ static void ep93xx_spi_process_transfer(struct ep93xx_spi *espi,
> >  
> >  	ep93xx_spi_chip_setup(espi, chip);
> >  
> > +	espi->word_xfer = (t->bits_per_word > 8) ? true : false;
> 
> 
> 	espi->word_xfer = (t->bits_per_word > 8);

Or even
	espi->word_xfer = t->bits_per_word > 8;

> This patch is fine, but not sure it is entirely worth it. The
> information is already stored in t->bits_per_word and the cost
> of retrieving it is pretty minimal.

I agree.
