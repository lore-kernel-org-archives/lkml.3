Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab3E2PtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 11:49:15 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:57056 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870Ab3E2PtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 11:49:13 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-sh@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH v2 04/11] pwm: Add Renesas TPU PWM driver
Date: Wed, 29 May 2013 17:48:50 +0200
Message-ID: <22098838.zqKo9eB0Jt@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <20130523214517.GA18249@avionic-0098.adnet.avionic-design.de>
References: <1366836616-21475-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1366836616-21475-5-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <20130523214517.GA18249@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry,

On Thursday 23 May 2013 23:45:17 Thierry Reding wrote:
> On Wed, Apr 24, 2013 at 10:50:09PM +0200, Laurent Pinchart wrote:
> > The Timer Pulse Unit (TPU is a 4-channels 16-bit timer used to generate
> > waveforms. This driver exposes PWM functions through the PWM API for
> > other drivers to use.
> > 
> > The code is loosely based on the leds-renesas-tpu driver by Magnus Damm
> > and the TPU PWM driver shipped in the Armadillo EVA 800 kernel sources.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> > Tested-by: Simon Horman <horms@verge.net.au>
> 
> Sorry for taking so long to look at this...

No worries. Thank you for the review.

> > diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> > index 0e0bfa0..d57ef66 100644
> > --- a/drivers/pwm/Kconfig
> > +++ b/drivers/pwm/Kconfig
> > @@ -115,6 +115,13 @@ config PWM_PXA
> > 
> >  	  To compile this driver as a module, choose M here: the module
> >  	  will be called pwm-pxa.
> > 
> > +config PWM_RENESAS_TPU
> > +	tristate "Renesas TPU PWM support"
> > +	depends on ARCH_SHMOBILE
> > +	help
> > +	  This driver exposes the Timer Pulse Unit (TPU) PWM controller found
> > +	  in Renesas chips through the PWM API.
> 
> If the driver can be built, it'd be good to include a short sentence
> saying what it will be called, just like for the other drivers.

OK.

> > diff --git a/drivers/pwm/pwm-renesas-tpu.c b/drivers/pwm/pwm-renesas-tpu.c
> 
> [...]
> 
> > +struct tpu_pwm_device {
> > +	bool timer_on;			/* Whether the timer is running */
> > +
> > +	struct tpu_pwm_channel_data *pdata;
> > +	struct tpu_device *tpu;
> > +	unsigned int channel;		/* Channel number in the TPU */
> 
> I don't think you need this. The pwm_device.hwpwm field carries the same
> information.
> 
> > +
> > +	unsigned int prescaler;
> > +	u16 period;
> > +	u16 duty;
> > +};
> > +
> > +struct tpu_device {
> > +	struct platform_device *pdev;
> > +	struct pwm_chip chip;
> > +	spinlock_t lock;
> > +
> > +	void __iomem *base;
> > +	struct clk *clk;
> > +
> > +	struct tpu_pwm_device pwms[TPU_CHANNEL_MAX];
> > +};
> 
> Can't you reuse the infrastructure built into the PWM subsystem? You can
> associate chip-specific data with each PWM device. You can look at the
> pwm-atmel-tcb and pwm-bfin drivers for usage examples. In a nutshell you
> hook the .request() function and setup the driver-specific structure and
> associate them with the PWM using pwm_set_chip_data().
> 
> This has the advantage that you don't need the pwms array in tpu_device
> and you also don't need TPU_CHANNEL_MAX because only the pwm_chip.npwm
> field needs to contain the number of channels.

I've actually thought about that, but decided not to do so. It looked pretty 
weird to allocate PWM devices at .request() time, so I decided to allocate the 
devices once only at probe time. Is it considered better to allocate/free PWM 
devices every time they're requested/released ?

> > +static int tpu_pwm_timer_start(struct tpu_pwm_device *pwm)
> > +{
> > +	int ret;
> > +
> > +	if (!pwm->timer_on) {
> > +		/* Wake up device and enable clock. */
> > +		pm_runtime_get_sync(&pwm->tpu->pdev->dev);
> > +		ret = clk_prepare_enable(pwm->tpu->clk);
> > +		if (ret) {
> > +			dev_err(&pwm->tpu->pdev->dev, "cannot enable clock\n");
> > +			return ret;
> > +		}
> > +		pwm->timer_on = true;
> > +	}
> > +
> > +	/* Make sure the channel is stopped, as we need to reconfigure it
> > +	 * completely. First drive the pin to the inactive state to avoid
> > +	 * glitches.
> > +	 */
> 
> Can you please stick to the standard coding style for block comments?
> That is:
> 
> 	/*
> 	 * Make sure...
> 	 * ...
> 	 * glitches.
> 	 */

Sure.

> > +/* ----------------------------------------------------------------------
> > + * PWM API
> > + */
> 
> I find these separators more distracting than helpful. But if you have a
> strong preference for them I can live with it.

I wouldn't have put them here if they didn't help me reading the code :-) I 
can remove them if you have a strong objection.

> > +
> > +static int tpu_pwm_request(struct pwm_chip *chip, struct pwm_device
> > *_pwm)
> > +{
> > +	struct tpu_device *tpu = to_tpu_device(chip);
> > +	struct tpu_pwm_device *pwm = &tpu->pwms[_pwm->hwpwm];
> > +
> > +	return pwm->pdata == NULL ? -EPROBE_DEFER : 0;
> > +}
> 
> If you use the same method as the pwm-bfin or pwm-atmel-tcb drivers, you
> could initialize each PWM channel here and associated them with the PWM
> device using pwm_set_chip_data() (as I hinted at earlier).
> 
> > +static int tpu_pwm_config(struct pwm_chip *chip, struct pwm_device *_pwm,
> > +			  int duty_ns, int period_ns)
> 
> [...]
> 
> > +	if (period_ns <= 0 || duty_ns < 0 || duty_ns > period_ns)
> > +		return -EINVAL;
> 
> The core already performs these checks so they can be dropped.

Good point.

> > +	/* Pick a prescaler to avoid overflowing the counter.
> > +	 * TODO: Pick the highest acceptable prescaler.
> > +	 */
> > +	clk_prepare_enable(tpu->clk);
> 
> Shouldn't you check the return value here?

I will.

> > +	clk_rate = clk_get_rate(tpu->clk);
> > +	clk_disable_unprepare(pwm->tpu->clk);
> 
> And does the clock really need to be enabled to obtain the rate?

Actually it doesn't seem so. I'll test that and remove the enable/disable 
calls if possible.

> > +	for (prescaler = 0; prescaler < ARRAY_SIZE(prescalers); ++prescaler) 
{
> > +		period = clk_rate / prescalers[prescaler]
> > +		       / (NSEC_PER_SEC / period_ns);
> 
> I prefer to have the operator on the previous line, as in:
> 
> 		period = clk_rate / prescalers[prescaler] /
> 			 (NSEC_PER_SEC / period_ns);

And I prefer the opposite :-) I can change that if you insist.

> > +	duty_only = pwm->prescaler == prescaler && pwm->period == period;
> 
> Maybe the following would be easier to read?
> 
> 	if (prescaler == pwm->prescaler && period == pwm->period)
> 		duty_only = true;
> 
> And initialize duty_only = false when declaring it.

I agree, I'll change that.

> > +static int tpu_probe(struct platform_device *pdev)
> > +{
> > +	struct tpu_pwm_platform_data *pdata = pdev->dev.platform_data;
> > +	struct tpu_device *tpu;
> > +	struct resource *res;
> > +	unsigned int i;
> > +	int ret;
> > +
> > +	if (!pdata) {
> > +		dev_err(&pdev->dev, "missing platform data\n");
> > +		return -ENXIO;
> > +	}
> > +
> > +	tpu = devm_kzalloc(&pdev->dev, sizeof(*tpu), GFP_KERNEL);
> > +	if (tpu == NULL) {
> > +		dev_err(&pdev->dev, "failed to allocate driver data\n");
> > +		return -ENOMEM;
> > +	}
> > +
> > +	/* Map memory, get clock and pin control. */
> > +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	if (!res) {
> > +		dev_err(&pdev->dev, "failed to get I/O memory\n");
> > +		return -ENXIO;
> > +	}
> > +
> > +	tpu->base = devm_ioremap_nocache(&pdev->dev, res->start,
> > +					 resource_size(res));
> > +	if (tpu->base == NULL) {
> > +		dev_err(&pdev->dev, "failed to remap I/O memory\n");
> > +		return -ENXIO;
> > +	}
> 
> Isn't this mising a request_mem_region()? Couldn't you just use a call
> to devm_ioremap_resource() instead?

I will do so.

> > +static struct platform_driver tpu_driver = {
> > +	.probe		= tpu_probe,
> > +	.remove		= tpu_remove,
> > +	.driver		= {
> > +		.name	= "renesas_tpu_pwm",
> 
> Can this perhaps be renamed to "renesas-tpu-pwm" for consistency with
> other drivers?

Sure.

> And I think this is missing
> 
> 		.owner = THIS_MODULE,
> 
> as well. I know not all drivers have this either, but I have that on my
> TODO already.

Indeed. There was a discussion not too long ago on the linux arm kernel 
mailing list about setting the owner field in the module_platform_driver() 
macro (possibly by turning platform_register_driver() into a macro that sets 
the owner field). I think that's a good idea, but I'll initialize .owner here 
in the meantime.

> > diff --git a/include/linux/platform_data/pwm-renesas-tpu.h
> > b/include/linux/platform_data/pwm-renesas-tpu.h
> [...]
> 
> > +#define TPU_CHANNEL_MAX		4
> > +
> > +#define TPU_PWM_ID(device, channel) \
> > +	((device) * TPU_CHANNEL_MAX + (channel))
> 
> Please don't do this. It assumes a global namespace for PWM devices.
> However the global namespace is only for compatibility with legacy code
> and shouldn't be depended on by new drivers. You should be using either
> DT to dynamically refer to PWM devices or use a PWM lookup table. Refer
> to Documentation/pwm.txt for details.

The goal is to move everything to DT. In the meantime I'll use a lookup table.
> 
> > +struct tpu_pwm_channel_data {
> > +	bool enabled;
> > +	bool active_low;
> 
> Maybe this should be enum pwm_polarity?

Good idea. I will also add support for the .set_polarity() operation.
 
> > +};
> > +
> > +struct tpu_pwm_platform_data {
> > +	struct tpu_pwm_channel_data channels[TPU_CHANNEL_MAX];
> > +};
> 
> This could be a little difficult to handle in the absence of
> TPU_CHANNEL_MAX. Depending on the hardware, I suppose you could just
> handle it via the .request() function. In that case all channels would
> be disabled by default and enabled automatically when requested by a
> user driver.

I would still need to pass the initial polarity configuration for each 
channel, although we could argue that the client driver should be responsible 
for configuring the polarity.

-- 
Regards,

Laurent Pinchart
