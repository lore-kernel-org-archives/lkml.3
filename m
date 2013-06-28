Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839Ab3F1XWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 19:22:17 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:58501 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab3F1XWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 19:22:16 -0400
Message-ID: <51CE1A8C.7070703@gmail.com>
Date: Sat, 29 Jun 2013 09:21:48 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        spi-devel-general@lists.sourceforge.net, mika.westerberg@iki.fi,
        broonie@kernel.org, grant.likely@linaro.org
Subject: Re: [PATCH 4/8] spi: spi-ep93xx: remove bits_per_word() helper
References: <201306281144.04549.hartleys@visionengravers.com>
In-Reply-To: <201306281144.04549.hartleys@visionengravers.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/06/13 04:44, H Hartley Sweeten wrote:

> This inline helper function is only used to determine the bus width
> of the current transfer (8 or 16 bit). Add a bool flag to the private
> structure and set it appropriately for each transfer.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ryan Mallon <rmallon@gmail.com>
> Cc: Mika Westerberg <mika.westerberg@iki.fi>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Grant Likely <grant.likely@linaro.org>
> ---
>  drivers/spi/spi-ep93xx.c | 16 +++++-----------
>  1 file changed, 5 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
> index bcfd35a..4fab3bb 100644
> --- a/drivers/spi/spi-ep93xx.c
> +++ b/drivers/spi/spi-ep93xx.c
> @@ -116,6 +116,7 @@ struct ep93xx_spi {
>  	unsigned long			min_rate;
>  	unsigned long			max_rate;
>  	bool				running;
> +	bool				word_xfer;


I think this is a slightly confusing name. Maybe something like
is_16bit_xfer would be better?

>  	struct workqueue_struct		*wq;
>  	struct work_struct		msg_work;
>  	struct completion		wait;
> @@ -407,17 +408,9 @@ static void ep93xx_spi_chip_setup(const struct ep93xx_spi *espi,
>  	writew(cr0, espi->regs_base + SSPCR0);
>  }
>  
> -static inline int bits_per_word(const struct ep93xx_spi *espi)
> -{
> -	struct spi_message *msg = espi->current_msg;
> -	struct spi_transfer *t = msg->state;
> -
> -	return t->bits_per_word;
> -}
> -
>  static void ep93xx_do_write(struct ep93xx_spi *espi, struct spi_transfer *t)
>  {
> -	if (bits_per_word(espi) > 8) {
> +	if (espi->word_xfer) {
>  		u16 tx_val = 0;
>  
>  		if (t->tx_buf)
> @@ -436,7 +429,7 @@ static void ep93xx_do_write(struct ep93xx_spi *espi, struct spi_transfer *t)
>  
>  static void ep93xx_do_read(struct ep93xx_spi *espi, struct spi_transfer *t)
>  {
> -	if (bits_per_word(espi) > 8) {
> +	if (espi->word_xfer) {
>  		u16 rx_val;
>  
>  		rx_val = readw(espi->regs_base + SSPDR);
> @@ -522,7 +515,7 @@ ep93xx_spi_dma_prepare(struct ep93xx_spi *espi, enum dma_transfer_direction dir)
>  	size_t len = t->len;
>  	int i, ret, nents;
>  
> -	if (bits_per_word(espi) > 8)
> +	if (espi->word_xfer)
>  		buswidth = DMA_SLAVE_BUSWIDTH_2_BYTES;
>  	else
>  		buswidth = DMA_SLAVE_BUSWIDTH_1_BYTE;
> @@ -699,6 +692,7 @@ static void ep93xx_spi_process_transfer(struct ep93xx_spi *espi,
>  
>  	ep93xx_spi_chip_setup(espi, chip);
>  
> +	espi->word_xfer = (t->bits_per_word > 8) ? true : false;


	espi->word_xfer = (t->bits_per_word > 8);

This patch is fine, but not sure it is entirely worth it. The
information is already stored in t->bits_per_word and the cost
of retrieving it is pretty minimal.

~Ryan
