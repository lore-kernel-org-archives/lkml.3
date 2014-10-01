Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaJAOX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 10:23:57 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:50160 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751382AbaJAOX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 10:23:56 -0400
Date: Wed, 1 Oct 2014 15:23:41 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Mark Brown <broonie@kernel.org>, Dave Airlie <airlied@gmail.com>,
        Andrew Jackson <Andrew.Jackson@arm.com>, Jyri Sarha <jsarha@ti.com>,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/2] drm/i2c:tda998x: Use the HDMI audio CODEC
Message-ID: <20141001142340.GR5182@n2100.arm.linux.org.uk>
References: <cover.1411547014.git.moinejf@free.fr> <4b3d35a14461ed164956b7f5aa77b29170bc393d.1411547014.git.moinejf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b3d35a14461ed164956b7f5aa77b29170bc393d.1411547014.git.moinejf@free.fr>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 10:11:21AM +0200, Jean-Francois Moine wrote:
> This patch interfaces the HDMI transmitter with the audio system.
...

> +struct tda998x_priv2 {
> +	struct tda998x_priv base;
> +	struct drm_encoder encoder;
> +	struct drm_connector connector;
>  };

NAK on moving this up here.  It was specifically placed below the core
and below the older drm_slave_encoder code because nothing but the new
component based interfaces to TDA998x have any business knowing that
these are packaged up in this way.

> +static void tda998x_create_audio_codec(struct tda998x_priv *priv)
> +{
> +	struct platform_device *pdev;
> +	struct module *module;
> +
> +	request_module("snd-soc-hdmi-codec");
> +	pdev = platform_device_register_resndata(&priv->hdmi->dev,
> +						 "hdmi-audio-codec",
> +						  PLATFORM_DEVID_NONE,
> +						  NULL, 0,
> +						  &tda998x_hdmi_data,
> +						  sizeof tda998x_hdmi_data);
> +	if (IS_ERR(pdev)) {
> +		dev_err(&priv->hdmi->dev, "cannot create codec: %ld\n",
> +			PTR_ERR(pdev));
> +		return;
> +	}
> +
> +	priv->pdev_codec = pdev;
> +	module = pdev->dev.driver->owner;
> +	if (module)
> +		try_module_get(module);

This is really not on.  Firstly, registering a platform device has no
guarantee that it will bind to a driver.  So, pdev->dev.driver may be
NULL here -> kernel oops.

Secondly, what's the purpose of the unchecked try_module_get() there?
You can't stop the device being unbound from its driver, so all you're
doing is possibly locking the module into module space for no other
benefit.

> @@ -1167,12 +1390,19 @@ tda998x_encoder_set_property(struct drm_encoder *encoder,
>  
>  static void tda998x_destroy(struct tda998x_priv *priv)
>  {
> +	struct module *module;
> +
>  	/* disable all IRQs and free the IRQ handler */
>  	cec_write(priv, REG_CEC_RXSHPDINTENA, 0);
>  	reg_clear(priv, REG_INT_FLAGS_2, INT_FLAGS_2_EDID_BLK_RD);
>  	if (priv->hdmi->irq)
>  		free_irq(priv->hdmi->irq, priv);
>  
> +	if (priv->pdev_codec) {
> +		module = priv->pdev_codec->dev.driver->owner;
> +		module_put(module);

This is wrong for all the reasons the other part above is wrong.
Userspace can decide to unbind the platform device from the associated
platform driver whenever it wishes.  At that point,
priv->pdev_codec->dev.driver becomes NULL.

So, please get rid of this.

> +		platform_device_del(priv->pdev_codec);

This leaks the memory associated with the platform device.

> @@ -1395,15 +1660,13 @@ static int tda998x_encoder_init(struct i2c_client *client,
>  	encoder_slave->slave_priv = priv;
>  	encoder_slave->slave_funcs = &tda998x_encoder_slave_funcs;
>  
> +	/* set the drvdata pointer to priv2 for CODEC calls */
> +	dev_set_drvdata(&client->dev,
> +			container_of(priv, struct tda998x_priv2, base));
> +
>  	return 0;
>  }
>  
> -struct tda998x_priv2 {
> -	struct tda998x_priv base;
> -	struct drm_encoder encoder;
> -	struct drm_connector connector;
> -};
> -

I would prefer this structure to stay here, as code above this point should
have no business knowing how these are packaged together.  I would suggest
either:

- moving the audio codec code below this point, or
- storing struct tda998x_priv in the device private pointer, and
  converting it to struct tda998x_priv2 via container_of() where
  necessary below this point.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
