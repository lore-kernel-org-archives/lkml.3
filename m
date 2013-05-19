Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab3ESUqH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 16:46:07 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:53410 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab3ESUqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 16:46:05 -0400
Date: Sun, 19 May 2013 21:45:52 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: David Airlie <airlied@linux.ie>, Rob Clark <robdclark@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] drm: i2c: add irq handler for tda998x slave encoder
Message-ID: <20130519204552.GT18614@n2100.arm.linux.org.uk>
References: <1368982162-10126-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368982162-10126-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 19, 2013 at 06:49:22PM +0200, Sebastian Hesselbarth wrote:
> This adds an irq handler for HPD to the tda998x slave encoder driver
> to trigger HPD change instead of polling. The gpio connected to int
> pin of tda998x is passed through platform_data of the i2c client. As
> HPD will ultimately cause EDID read and that will raise an
> EDID_READ_DONE interrupt, the irq handling is done threaded with a
> workqueue to notify drm backend of HPD events.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Okay, I think I get this..  Some comments:

> +static irqreturn_t tda998x_irq_thread(int irq, void *data)
> +{
> +	struct drm_encoder *encoder = data;
> +	struct tda998x_priv *priv;
> +	uint8_t sta, cec, hdmi, lev;
> +
> +	if (!encoder)
> +		return IRQ_HANDLED;

This won't ever be NULL.  The IRQ layer stores the pointer you passed
in request_threaded_irq() and that pointer will continue to point at
that memory until the IRQ is freed.  The only way it could be NULL is
if you register using a NULL pointer.

...
> +	if (priv->irq < 0) {
> +		for (i = 100; i > 0; i--) {
> +			uint8_t val = reg_read(encoder, REG_INT_FLAGS_2);

IRQ 0 is the cross-arch "no interrupt" number.  So just use !priv->irq
here and encourage anyone who uses -1 or NO_IRQ to fix their stuff. :)

> +	struct tda998x_priv *priv = to_tda998x_priv(encoder);
> +
> +	/* announce polling if no irq is available */
> +	if (priv->irq < 0)

Same here.

> @@ -1122,7 +1197,9 @@ tda998x_encoder_init(struct i2c_client *client,
>  
>  	priv->current_page = 0;
>  	priv->cec = i2c_new_dummy(client->adapter, 0x34);
> +	priv->irq = -EINVAL;

And just initialize to zero.  (it's allocated by kzalloc already right?
So that shouldn't be necessary.)

> diff --git a/include/drm/i2c/tda998x.h b/include/drm/i2c/tda998x.h
> index 41f799f..1838703 100644
> --- a/include/drm/i2c/tda998x.h
> +++ b/include/drm/i2c/tda998x.h
> @@ -20,4 +20,8 @@ struct tda998x_encoder_params {
>  	int swap_f, mirr_f;
>  };
>  
> +struct tda998x_platform_data {
> +	int int_gpio;
> +};
> +

Should be combined with tda998x_encoder_params - the platform data is
really supposed to be passed to set_config - see this in drm_encoder_slave.c:

 * If @info->platform_data is non-NULL it will be used as the initial
 * slave config.
...
        err = encoder_drv->encoder_init(client, dev, encoder);
        if (err)
                goto fail_unregister;

        if (info->platform_data)
                encoder->slave_funcs->set_config(&encoder->base,
                                                 info->platform_data);

So any platform data set will be passed into the set_config function...
