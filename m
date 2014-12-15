Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751178AbaLOLEt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 06:04:49 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:55871 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704AbaLOLEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 06:04:46 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1412141801050.3102@utopia.booyaka.com>
References: <1418130912-24725-1-git-send-email-tomeu.vizoso@collabora.com>
 <1418130912-24725-3-git-send-email-tomeu.vizoso@collabora.com> <alpine.DEB.2.02.1412141801050.3102@utopia.booyaka.com>
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Date: Mon, 15 Dec 2014 12:04:23 +0100
X-Google-Sender-Auth: pbJChjqAGMhVQL1Xyy2DqupGOVo
Message-ID: <CAAObsKBYN03dAz9WqkCP4jB6myAOnbjmObMyQhCqzbe==JLAZg@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] PM / devfreq: tegra: add devfreq driver for Tegra
 Activity Monitor
To: Paul Walmsley <paul@pwsan.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Alexandre Courbot <gnurou@gmail.com>,
        Mikko Perttunen <mikko.perttunen@kapsi.fi>,
        Arto Merilainen <amerilainen@nvidia.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        khilman@linaro.org, afrid@nvidia.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 December 2014 at 19:26, Paul Walmsley <paul@pwsan.com> wrote:
> Hi
>
> I have not reviewed this code closely, but a few items just caught my eye
> at a brief glance.
>
> On Tue, 9 Dec 2014, Tomeu Vizoso wrote:
>
>> The ACTMON block can monitor several counters, providing averaging and firing
>> interrupts based on watermarking configuration. This implementation monitors
>> the MCALL and MCCPU counters to choose an appropriate frequency for the
>> external memory clock.
>>
>> This patch is based on work by Alex Frid <afrid@nvidia.com> and Mikko
>> Perttunen <mikko.perttunen@kapsi.fi>.
>
> It's important to put people in the Cc: section, either when you're basing
> your code off of their work, or when you mention them in the patch
> description.  This means including specific Cc: lines in the
> Signed-off-by: section at the bottom of the patch -- not just mentioning
> them in the patch description.  That way, any further followup from others
> after the patch is committed is more likely to be appropriately copied to
> those people.
>
> For some reason this doesn't happen with many Tegra upstream-bound patches
> -- from a variety of submitters, including NVIDIA submitters! -- but it
> needs to start happening.
>
> Also I see that Aleks Frid wasn't cc'ed at all in the E-mail headers;
> fixing at least that point.

Point taken.

>> +static struct tegra_devfreq_device_config actmon_device_configs[] = {
>> +     {
>> +             /* MCALL: All memory accesses (including from the CPUs) */
>> +             .offset = 0x1c0,
>> +             .irq_mask = 1 << 26,
>> +             .boost_up_coeff = 200,
>> +             .boost_down_coeff = 50,
>> +             .boost_up_threshold = 60,
>> +             .boost_down_threshold = 40,
>> +     },
>> +     {
>> +             /* MCCPU: memory accesses from the CPUs */
>> +             .offset = 0x200,
>> +             .irq_mask = 1 << 25,
>> +             .boost_up_coeff = 800,
>> +             .boost_down_coeff = 90,
>> +             .boost_up_threshold = 27,
>> +             .boost_down_threshold = 10,
>> +             .avg_dependency_threshold = 50000,
>> +     },
>> +};
>
> This data represents PM policy.  In other words, it is use-case sensitive.
> Different users may wish to change these values depending on their
> application characteristics -- and it does not represent unchangeable
> hardware fact.
>
> On the other hand...
>
>> +static u32 actmon_readl(struct tegra_devfreq *tegra, u32 offset)
>> +{
>> +     return readl(tegra->regs + offset);
>> +}
>> +
>> +static void actmon_writel(struct tegra_devfreq *tegra, u32 val, u32 offset)
>> +{
>> +     writel(val, tegra->regs + offset);
>> +}
>> +
>> +static u32 device_readl(struct tegra_devfreq_device *dev, u32 offset)
>> +{
>> +     return readl(dev->regs + offset);
>> +}
>> +
>> +static void device_writel(struct tegra_devfreq_device *dev, u32 val,
>> +                       u32 offset)
>> +{
>> +     writel(val, dev->regs + offset);
>> +}
>> +
>> +static unsigned long do_percent(unsigned long val, unsigned int pct)
>> +{
>> +     return val * pct / 100;
>> +}
>> +
>> +static void tegra_devfreq_update_avg_wmark(struct tegra_devfreq *tegra,
>> +                                        struct tegra_devfreq_device *dev)
>> +{
>> +     u32 avg = dev->avg_count;
>> +     u32 avg_band_freq = tegra->max_freq * ACTMON_DEFAULT_AVG_BAND / KHZ;
>> +     u32 band = avg_band_freq * ACTMON_SAMPLING_PERIOD;
>> +
>> +     device_writel(dev, avg + band, ACTMON_DEV_AVG_UPPER_WMARK);
>> +
>> +     avg = max(dev->avg_count, band);
>> +     device_writel(dev, avg - band, ACTMON_DEV_AVG_LOWER_WMARK);
>> +}
>> +
>> +static void tegra_devfreq_update_wmark(struct tegra_devfreq *tegra,
>> +                                    struct tegra_devfreq_device *dev)
>> +{
>> +     u32 val = tegra->cur_freq * ACTMON_SAMPLING_PERIOD;
>> +
>> +     device_writel(dev, do_percent(val, dev->config->boost_up_threshold),
>> +                   ACTMON_DEV_UPPER_WMARK);
>> +
>> +     device_writel(dev, do_percent(val, dev->config->boost_down_threshold),
>> +                   ACTMON_DEV_LOWER_WMARK);
>> +}
>> +
>> +static void actmon_write_barrier(struct tegra_devfreq *tegra)
>> +{
>> +     /* ensure the update has reached the ACTMON */
>> +     wmb();
>> +     actmon_readl(tegra, ACTMON_GLB_STATUS);
>> +}
>> +
>> +static irqreturn_t actmon_isr(int irq, void *data)
>> +{
>> +     struct tegra_devfreq *tegra = data;
>> +     struct tegra_devfreq_device *dev = NULL;
>> +     unsigned long flags;
>> +     u32 val, intr_status, dev_ctrl;
>> +     unsigned int i;
>> +
>> +     val = actmon_readl(tegra, ACTMON_GLB_STATUS);
>> +
>> +     for (i = 0; i < ARRAY_SIZE(tegra->devices); i++) {
>> +             if (val & tegra->devices[i].config->irq_mask) {
>> +                     dev = tegra->devices + i;
>> +                     break;
>> +             }
>> +     }
>> +
>> +     if (!dev)
>> +             return IRQ_NONE;
>> +
>> +     spin_lock_irqsave(&tegra->lock, flags);
>> +
>> +     dev->avg_count = device_readl(dev, ACTMON_DEV_AVG_COUNT);
>> +     tegra_devfreq_update_avg_wmark(tegra, dev);
>> +
>> +     intr_status = device_readl(dev, ACTMON_DEV_INTR_STATUS);
>> +     dev_ctrl = device_readl(dev, ACTMON_DEV_CTRL);
>> +
>> +     if (intr_status & ACTMON_DEV_INTR_CONSECUTIVE_UPPER) {
>> +             /*
>> +              * new_boost = min(old_boost * up_coef + step, max_freq)
>> +              */
>> +             dev->boost_freq = do_percent(dev->boost_freq,
>> +                                          dev->config->boost_up_coeff);
>> +             dev->boost_freq += ACTMON_BOOST_FREQ_STEP;
>> +
>> +             dev_ctrl |= ACTMON_DEV_CTRL_CONSECUTIVE_BELOW_WMARK_EN;
>> +
>> +             if (dev->boost_freq >= tegra->max_freq)
>> +                     dev->boost_freq = tegra->max_freq;
>> +             else
>> +                     dev_ctrl |= ACTMON_DEV_CTRL_CONSECUTIVE_ABOVE_WMARK_EN;
>> +     } else if (intr_status & ACTMON_DEV_INTR_CONSECUTIVE_LOWER) {
>> +             /*
>> +              * new_boost = old_boost * down_coef
>> +              * or 0 if (old_boost * down_coef < step / 2)
>> +              */
>> +             dev->boost_freq = do_percent(dev->boost_freq,
>> +                                          dev->config->boost_down_coeff);
>> +
>> +             dev_ctrl |= ACTMON_DEV_CTRL_CONSECUTIVE_ABOVE_WMARK_EN;
>> +
>> +             if (dev->boost_freq < (ACTMON_BOOST_FREQ_STEP >> 1))
>> +                     dev->boost_freq = 0;
>> +             else
>> +                     dev_ctrl |= ACTMON_DEV_CTRL_CONSECUTIVE_BELOW_WMARK_EN;
>> +     }
>> +
>> +     if (dev->config->avg_dependency_threshold) {
>> +             if (dev->avg_count >= dev->config->avg_dependency_threshold)
>> +                     dev_ctrl |= ACTMON_DEV_CTRL_CONSECUTIVE_BELOW_WMARK_EN;
>> +             else if (dev->boost_freq == 0)
>> +                     dev_ctrl &= ~ACTMON_DEV_CTRL_CONSECUTIVE_BELOW_WMARK_EN;
>> +     }
>> +
>> +     device_writel(dev, dev_ctrl, ACTMON_DEV_CTRL);
>> +
>> +     device_writel(dev, ACTMON_INTR_STATUS_CLEAR, ACTMON_DEV_INTR_STATUS);
>> +
>> +     actmon_write_barrier(tegra);
>> +
>> +     spin_unlock_irqrestore(&tegra->lock, flags);
>> +
>> +     return IRQ_WAKE_THREAD;
>> +}
>
> ... all this code is clearly low level device driver code and is intended
> to represent immutable hardware fact.  It is use-case independent, PM
> policy-invariant, and in theory should be verifiable against the Tegra TRM
> (or whatever).
>
> The policy code and data should be separated into a separate file and/or
> subsystem from the low-level ACTMON device driver.  The policy code should
> be easily swappable or tunable by end-users without touching the
> underlying device driver.
>
> So these entities should use some kind of Linux generic subsystem/function
> call interface to loosely couple the policy with the low-level device
> driver. I have not combed the tree to see what makes the most sense.  But
> the perf subsystem comes to mind as one strong candidate.

I agree with your concern, but I'm wary to expose this to userspace at
this point in time because we hope for devfreq to eventually gain
better support for these kind of activity monitors and having to
maintain compatibility would limit us for little gain. Besides, we
don't have yet a good idea of how userspace would use these knobs
(both chromeos and l4t seem to be happy to just leave those defaults
as they are now).

We need to hardcode some sane defaults anyway, so I think that it
makes sense to leave things as they are until we have one more SoC
with similar functionality, and some idea of how userspace would want
to tweak them.

Regards,

Tomeu
