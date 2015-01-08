Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631AbbAHOV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 09:21:56 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:36657 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbbAHOVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 09:21:54 -0500
Date: Thu, 8 Jan 2015 14:21:36 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Ezequiel Garcia <ezequiel.garcia@imgtec.com>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        James Hartley <james.hartley@imgtec.com>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pwm@vger.kernel.org>,
        Naidu Tellapati <Naidu.Tellapati@imgtec.com>,
        Arul Ramasamy <Arul.Ramasamy@imgtec.com>
Subject: Re: [PATCH v7 3/4] pdm: Imagination Technologies PDM DAC driver
Message-ID: <20150108142136.757eaeef@lxorguk.ukuu.org.uk>
In-Reply-To: <1420651215-3836-4-git-send-email-ezequiel.garcia@imgtec.com>
References: <1420651215-3836-1-git-send-email-ezequiel.garcia@imgtec.com>
	<1420651215-3836-4-git-send-email-ezequiel.garcia@imgtec.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Jan 2015 14:20:14 -0300
Ezequiel Garcia <ezequiel.garcia@imgtec.com> wrote:

> From: Naidu Tellapati <Naidu.Tellapati@imgtec.com>
> 
> The Pistachio SOC from Imagination Technologies includes a Pulse Density
> Modulation DAC which produces a form of analogue output according to the
> relative density of output pulses to the intended analogue signal amplitude.
> Four PDM outputs are provided that can be used to control targets such as LCD
> backlight.


> +int img_pdm_channel_config(struct img_pdm_channel *chan, unsigned int val)
> +{
> +	struct img_pdm_device *pdm_dev;
> +
> +	if (!chan)
> +		return -EINVAL;

If this is a can't happen case then either let it crash or WARN_ON it so
that it doesn't get ignored and lead to nastier failures elsewhere

> +
> +static struct img_pdm_channel *img_pdm_channel_request(unsigned int pdm_id)
> +{
> +	unsigned int i;
> +	struct img_pdm_device *pdm_dev;
> +	struct img_pdm_channel *chan = NULL;
> +
> +	mutex_lock(&pdm_lock);
> +
> +	if (pdm_id < 0 || pdm_id >= IMG_NUM_PDM || !pdm_channels)
> +		return NULL;

You return with the mutex held in this case.



> +int img_pdm_channel_enable(struct img_pdm_channel *chan, bool state)
> +{
> +	struct img_pdm_device *pdm_dev;
> +
> +	if (!chan)
> +		return -EINVAL;

Same comment about hiding errors being bad

> +	pdm_dev = chan->pdm_dev;
> +
> +	if (!test_bit(PDM_CHANNEL_REQUESTED, &chan->flags)) {
> +		dev_err(&pdm_dev->pdev->dev, "channel not requested\n");
> +		return -EINVAL;
> +	}
> +
> +	if (state) {
> +		regmap_update_bits(pdm_dev->periph_regs,
> +				   PERIP_PWM_PDM_CONTROL,
> +				   PERIP_PWM_PDM_CONTROL_CH_MASK <<
> +				   PERIP_PWM_PDM_CONTROL_CH_SHIFT(chan->pdm_id),
> +				   1);
> +		set_bit(PDM_CHANNEL_ENABLED, &chan->flags);
> +	} else {
> +		regmap_write(pdm_dev->periph_regs,
> +			     PERIP_PDM0_VAL +
> +			     PERIP_PDM_CH_ADDR_SHIFT(chan->pdm_id), 0);
> +		regmap_update_bits(pdm_dev->periph_regs,
> +				   PERIP_PWM_PDM_CONTROL,
> +				   PERIP_PWM_PDM_CONTROL_CH_MASK <<
> +				   PERIP_PWM_PDM_CONTROL_CH_SHIFT(chan->pdm_id),
> +				   0);
> +		clear_bit(PDM_CHANNEL_ENABLED, &chan->flags);
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(img_pdm_channel_enable);

You export these functions but they don't appear to do any internal
locking in them, so how is the caller expected to use them ?

If there is a reason no locking is needed in this case document why and
the assumptions.

> +
> +static ssize_t img_pdm_enable_read(struct kobject *kobj,
> +				   struct kobj_attribute *attr, char *buf)
> +{
> +	int ret;
> +	unsigned int ch_num;
> +	unsigned char kobj_name[2];
> +	struct platform_device *pdev;
> +	struct img_pdm_device *pdm_dev;
> +	struct img_pdm_channel *chan;
> +
> +	pdev = to_platform_device(kobj_to_dev(kobj->parent));
> +	pdm_dev = platform_get_drvdata(pdev);
> +	kobj_name[0] = *(kobj->name+3);
> +	kobj_name[1] = '\0';
> +
> +	ret = kstrtou32(kobj_name, 10, &ch_num);

This is C not java. 

	ch_num = kobj->name[3] - '0';

> +	if (ret) {
> +		dev_err(&pdev->dev, "could not parse channel number string\n");
> +		return ret;
> +	}
> +
> +	chan = &pdm_channels[ch_num];
> +	return sprintf(buf, "%d\n",
> +		       test_bit(PDM_CHANNEL_ENABLED, &chan->flags) ? 1 : 0);
> +}
> +
> +static ssize_t img_pdm_pulse_in_read(struct kobject *kobj,
> +				     struct kobj_attribute *attr, char *buf)
> +{
> +	int ret;
> +	unsigned int ch_num, val;
> +	unsigned char kobj_name[2];
> +	struct platform_device *pdev;
> +	struct img_pdm_device *pdm_dev;
> +	struct img_pdm_channel *chan;
> +
> +	pdev = to_platform_device(kobj_to_dev(kobj->parent));
> +	pdm_dev = platform_get_drvdata(pdev);
> +	kobj_name[0] = *(kobj->name+3);
> +	kobj_name[1] = '\0';
> +	ret = kstrtou32(kobj_name, 10, &ch_num);

Ditto (in fact why not just have a helper to range check and print the
error and share the string)

> +static ssize_t img_pdm_enable_write(struct kobject *kobj,
> +				    struct kobj_attribute *attr,
> +				    const char *buf, size_t size)
> +{
> +	int ret;
> +	unsigned int ch_num, enable;
> +	unsigned char kobj_name[2];
> +	struct platform_device *pdev;
> +	struct img_pdm_device *pdm_dev;
> +
> +	pdev = to_platform_device(kobj_to_dev(kobj->parent));
> +	pdm_dev = platform_get_drvdata(pdev);
> +
> +	kobj_name[0] = *(kobj->name+3);
> +	kobj_name[1] = '\0';
> +	ret = kstrtou32(kobj_name, 10, &ch_num);
> +	if (ret) {
> +		dev_err(&pdev->dev, "could not parse channel number string\n");
> +		return ret;
> +	}

And again

> +static ssize_t img_pdm_pulse_in_write(struct kobject *kobj,
> +				      struct kobj_attribute *attr,
> +				      const char *buf, size_t size)
> +{
> +	int ret;
> +	unsigned int pulse_in, ch_num;
> +	unsigned char kobj_name[2];
> +	struct platform_device *pdev;
> +	struct img_pdm_device *pdm_dev;
> +
> +	pdev = to_platform_device(kobj_to_dev(kobj->parent));
> +	pdm_dev = platform_get_drvdata(pdev);
> +
> +	kobj_name[0] = *(kobj->name+3);
> +	kobj_name[1] = '\0';
> +	ret = kstrtou32(kobj_name, 10, &ch_num);
> +	if (ret) {
> +		dev_err(&pdev->dev, "could not parse channel number string\n");
> +		return ret;
> +	}

and - you get the idea 8)

