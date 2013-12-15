Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab3LOJs3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 04:48:29 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:37795 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab3LOJs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 04:48:27 -0500
Message-ID: <52AD7AE7.7070301@linux.com>
Date: Sun, 15 Dec 2013 10:48:23 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Alexander Shiyan <shc_work@mail.ru>, linux-kernel@vger.kernel.org
CC: Mark Brown <broonie@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] regmap: irq: Allow using zero value for ack_base
References: <1387100211-19101-1-git-send-email-shc_work@mail.ru>
In-Reply-To: <1387100211-19101-1-git-send-email-shc_work@mail.ru>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2013 10:36 AM, Alexander Shiyan wrote:
> In some cases, clear interrupt register may be at address 0.
> This patch allows to use such configurations by adding additional
> configuration bit to indicate this.
> 
> Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
> ---
>  drivers/base/regmap/regmap-irq.c | 6 +++---
>  include/linux/regmap.h           | 5 ++++-
>  2 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
> index 763c60d..8269206 100644
> --- a/drivers/base/regmap/regmap-irq.c
> +++ b/drivers/base/regmap/regmap-irq.c
> @@ -113,7 +113,7 @@ static void regmap_irq_sync_unlock(struct irq_data *data)
>  		 * OR if there is masked interrupt which hasn't been Acked,
>  		 * it'll be ignored in irq handler, then may introduce irq storm
>  		 */
> -		if (d->mask_buf[i] && d->chip->ack_base) {
> +		if (d->mask_buf[i] && (d->chip->ack_base || d->chip->use_ack)) {
>  			reg = d->chip->ack_base +
>  				(i * map->reg_stride * d->irq_reg_stride);
>  			ret = regmap_write(map, reg, d->mask_buf[i]);
> @@ -271,7 +271,7 @@ static irqreturn_t regmap_irq_thread(int irq, void *d)
>  	for (i = 0; i < data->chip->num_regs; i++) {
>  		data->status_buf[i] &= ~data->mask_buf[i];
>  
> -		if (data->status_buf[i] && chip->ack_base) {
> +		if (data->status_buf[i] && (chip->ack_base || chip->use_ack)) {
>  			reg = chip->ack_base +
>  				(i * map->reg_stride * data->irq_reg_stride);
>  			ret = regmap_write(map, reg, data->status_buf[i]);
> @@ -448,7 +448,7 @@ int regmap_add_irq_chip(struct regmap *map, int irq, int irq_flags,
>  			goto err_alloc;
>  		}
>  
> -		if (d->status_buf[i] && chip->ack_base) {
> +		if (d->status_buf[i] && (chip->ack_base || chip->use_ack)) {
>  			reg = chip->ack_base +
>  				(i * map->reg_stride * d->irq_reg_stride);
>  			ret = regmap_write(map, reg,
> diff --git a/include/linux/regmap.h b/include/linux/regmap.h
> index e559078..3a36f61 100644
> --- a/include/linux/regmap.h
> +++ b/include/linux/regmap.h
> @@ -497,11 +497,13 @@ struct regmap_irq {
>   *
>   * @status_base: Base status register address.
>   * @mask_base:   Base mask register address.
> - * @ack_base:    Base ack address.  If zero then the chip is clear on read.
> + * @ack_base:    Base ack address. If zero then the chip is clear on read.
> + *               Using zero value is possible with @use_ack bit.
>   * @wake_base:   Base address for wake enables.  If zero unsupported.
>   * @irq_reg_stride:  Stride to use for chips where registers are not contiguous.
>   * @init_ack_masked: Ack all masked interrupts once during initalization.

Oh a typo!  'initalization' should be 'initialization'
>   * @mask_invert: Inverted mask register: cleared bits are masked out.
> + * @use_ack:     Use @ack register even it zero.
'even it zero' should be 'even if it is zero'


>   * @wake_invert: Inverted wake register: cleared bits are wake enabled.
>   * @runtime_pm:  Hold a runtime PM lock on the device when accessing it.
>   *
> @@ -520,6 +522,7 @@ struct regmap_irq_chip {
>  	unsigned int irq_reg_stride;
>  	bool init_ack_masked:1;
>  	bool mask_invert:1;
> +	bool use_ack:1;
I think this will break something. Better use 0 as default value.
Reason I think so, is because in the above code you effectively add a new
possibility for most code to run.

-- 
Regards,
Levente Kurusa
