Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759822Ab3HNMUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 08:20:24 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41513 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab3HNMUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 08:20:23 -0400
Date: Wed, 14 Aug 2013 13:20:08 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: David Airlie <airlied@linux.ie>, Darren Etheridge <detheridge@ti.com>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] drm/i2c: tda998x: add video and audio input
	configuration
Message-ID: <20130814122008.GC23840@n2100.arm.linux.org.uk>
References: <1375741218-10225-1-git-send-email-sebastian.hesselbarth@gmail.com> <1375741218-10225-6-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375741218-10225-6-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 12:20:15AM +0200, Sebastian Hesselbarth wrote:
> - also calculate CTS

This is wrong...

> +	/*
> +	 * HDMI 1.3a, 7.2.2 CTS parameter:
> +	 *  (avg cts) = (fTMDS * N) / (128 * fS)
> +	 */
> +	cts = n * mode->clock / p->audio_sample_rate;
> +	cts *= 1000;
> +	cts /= 128;

This only works if you can guarantee that the audio and video clocks are
synchronous - and that you know the audio sample rate.

I don't believe the audio and video clocks are synchronous on the cubox,
and also have no way to communicate the audio sample rate to the TDA998x
driver at present.

So, this calculation serves little purpose and wastes CPU cycles.

> +static ssize_t i2c_read_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t size)
> +{
> +	struct drm_encoder *encoder = dev_get_drvdata(dev);
> +	unsigned int page, addr;
> +	unsigned char val;
> +
> +	sscanf(buf, "%x %x", &page, &addr);
> +
> +	val = reg_read(encoder, REG(page, addr));
> +
> +	printk("i2c read %02x @ page:%02x address:%02x\n", val, page, addr);
> +	return size;
> +}
> +
> +static ssize_t i2c_write_store(struct device *dev, struct device_attribute *attr, const char *buf, size_t size)
> +{
> +	struct drm_encoder *encoder = dev_get_drvdata(dev);
> +	unsigned int page, addr, mask, val;
> +	unsigned char rval;
> +
> +	sscanf(buf, "%x %x %x %x", &page, &addr, &mask, &val);
> +
> +	rval = reg_read(encoder, REG(page, addr));
> +	rval &= ~mask;
> +	rval |= val & mask;
> +	reg_write(encoder, REG(page, addr), rval);
> +
> +	printk("i2c write %02x @ page:%02x address:%02x\n", rval, page, addr);
> +	return size;
> +}
> +
> +static DEVICE_ATTR(i2c_read, S_IWUSR, NULL, i2c_read_store);
> +static DEVICE_ATTR(i2c_write, S_IWUSR, NULL, i2c_write_store);
> +
>  static int
>  tda998x_encoder_init(struct i2c_client *client,
>  		    struct drm_device *dev,
> @@ -817,6 +1111,11 @@ tda998x_encoder_init(struct i2c_client *client,
>  {
>  	struct drm_encoder *encoder = &encoder_slave->base;
>  	struct tda998x_priv *priv;
> +/* debug */
> +	device_create_file(&client->dev, &dev_attr_i2c_read);
> +	device_create_file(&client->dev, &dev_attr_i2c_write);
> +	dev_set_drvdata(&client->dev, encoder);
> +/* debug end */

The above should probably be dropped from this patch; that's for debugging
and is unrelated to the rest of this patch.
