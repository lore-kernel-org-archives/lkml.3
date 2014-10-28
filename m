Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbaJ1RQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:16:35 -0400
Received: from mail-oi0-f54.google.com ([209.85.218.54]:49064 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647AbaJ1RQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:16:33 -0400
MIME-Version: 1.0
In-Reply-To: <544FBD20.5000604@metafoo.de>
References: <1414436825-19416-1-git-send-email-jcmvbkbc@gmail.com>
	<544FBD20.5000604@metafoo.de>
Date: Tue, 28 Oct 2014 20:16:33 +0300
Message-ID: <CAMo8Bf+mbQpP0bmbq=2mK5X1ZYVOXTywJjrsT7A-zmch3b6+3Q@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH] ASoC: add xtensa xtfpga I2S interface and platform
From: Max Filippov <jcmvbkbc@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: alsa-devel@alsa-project.org, Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        Takashi Iwai <tiwai@suse.de>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Mark Brown <broonie@kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars-Peter,

On Tue, Oct 28, 2014 at 6:58 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> On 10/27/2014 08:07 PM, Max Filippov wrote:
>
> A few minor things.
>
> [...]
>
>> +static irqreturn_t xtfpga_i2s_interrupt(int irq, void *dev_id)
>> +       if (tx_active) {
>> +               if (i2s->tx_fifo_high < 256)
>> +                       xtfpga_i2s_refill_fifo(i2s);
>> +               else
>> +                       tasklet_hi_schedule(&i2s->refill_fifo);
>
> Maybe use threaded IRQs instead of IRQ + tasklet.

Ok, I'll look at it.

>> +static int xtfpga_pcm_trigger(struct snd_pcm_substream *substream, int

> If you don't do anything you don't need the handler. The core will handle
> things if it is NULL.

Ok.

>> +static struct snd_pcm_ops xtfpga_pcm_ops = {
>
> const

Ok.

>> +static int xtfpga_i2s_probe(struct platform_device *pdev)
>> +       dev_set_drvdata(&pdev->dev, i2s);
>
> platform_set_drvdata(...)

Ok.

>> +       i2s->dev = &pdev->dev;
>> +       dev_dbg(&pdev->dev, "dev: %p, i2s: %p\n", &pdev->dev, i2s);
>> +
>> +       mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +       if (!mem) {
>> +               dev_err(&pdev->dev, "No memory resource\n");
>> +               err = -ENODEV;
>> +               goto err;
>> +       }
>
> devm_ioremap_resource will check if mem is NULL and print a error message,
> so the check above can be removed.

Ok.

>> +       irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
>
> platform_get_irq(...)

Ok.

>> +       err = devm_request_irq(&pdev->dev, irq->start,
>> xtfpga_i2s_interrupt,
>> +                              IRQF_SHARED, pdev->name, i2s);
>> +       if (err < 0) {
>> +               dev_err(&pdev->dev, "request_irq failed\n");
>> +               goto err;
>> +       }
>> +       tasklet_init(&i2s->refill_fifo, xtfpga_i2s_refill_fifo_tasklet,
>> +                    (unsigned long)i2s);
>> +
>
>
> Since the tasklet is is used in the interrupt handler it should initialized
> before the IRQ is requested.

Ok.

>> +static int xtfpga_i2s_remove(struct platform_device *pdev)
>> +{
>> +       struct xtfpga_i2s *i2s = dev_get_drvdata(&pdev->dev);
>> +
>> +       if (i2s) {
>
>
> This will always be non NULL.

Ok.

-- 
Thanks.
-- Max
