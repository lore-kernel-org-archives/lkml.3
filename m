Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161204AbaKNQS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 11:18:26 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:47884 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161157AbaKNQSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 11:18:24 -0500
MIME-Version: 1.0
In-Reply-To: <20141112154549.GF26488@ulmo>
References: <1415779051-26410-1-git-send-email-tomeu.vizoso@collabora.com>
 <1415779051-26410-11-git-send-email-tomeu.vizoso@collabora.com> <20141112154549.GF26488@ulmo>
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Date: Fri, 14 Nov 2014 17:18:01 +0100
X-Google-Sender-Auth: MCjqwBJangr1DFME5PfbgCancKk
Message-ID: <CAAObsKAeFLhXsndm4+WoXCTwGBEZr1tf25rheBegYrRqgvryjg@mail.gmail.com>
Subject: Re: [PATCH v4 10/13] memory: tegra: Add EMC (external memory
 controller) driver
To: Thierry Reding <thierry.reding@gmail.com>
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Mikko Perttunen <mikko.perttunen@kapsi.fi>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 November 2014 16:45, Thierry Reding <thierry.reding@gmail.com> wrote:
> On Wed, Nov 12, 2014 at 08:56:33AM +0100, Tomeu Vizoso wrote:

<snip>

>> +struct emc_timing {
>> +     unsigned long rate;
>> +
>> +     /*
>> +      * Store EMC burst data in a union to minimize mistakes. This allows
>> +      * us to use the same burst data lists as used by the downstream and
>> +      * ChromeOS kernels.
>
> I don't understand what this means. Can you elaborate?

I have removed the union and added properties to the DT for those
three registers.

>> +
>> +     struct emc_timing last_timing;
>
> struct emc_timing is rather big, can this be a pointer to an entry in
> the timings array instead?

I'm leaving this as-is following Mikko's explanation.

>> +     writel(1, tegra->emc_regs + EMC_TIMING_CONTROL);
>> +
>> +     for (i = 0; i < EMC_STATUS_UPDATE_TIMEOUT; ++i) {
>> +             if (!(readl(tegra->emc_regs + EMC_STATUS) &
>> +                 EMC_STATUS_TIMING_UPDATE_STALLED))
>> +                     return;
>> +     }
>
> You're busy-looping 1000 times here. What are the real criteria here?
> How long is this allowed to take? Should this not be a timed loop where
> the number of iterations doesn't matter?

Have done some digging and my understanding is that the vendor
recommends polling for at least 1 millisecond.

https://groups.google.com/a/chromium.org/forum/#!msg/chromium-os-reviews/ZtYLn04i53M/98VKBEh2Xd4J

The only thing I have in the TRM is this:

"Programming of this register does not trigger the shadow register update event
immediately. To prevent shadow register programming issued after
programming this
register from being latched accidentally, always poll for
TIMING_UPDATE_STALLED==0
after programming this register."

Both ChromeOS and L4T loop 1000 times with a delay of 1us. I will be
updating the patch to match this, and also add a comment.

>> +
>> +     dev_err(&tegra->pdev->dev, "timing update failed\n");
>> +}
>
> Should this return an error that can be propagated?

I frankly don't know how this could be handled, as we are in the
middle of the sequence and AFAIK there's no way to back up the changes
done until this point. TTBOMK, the best we can do is to print an error
message that can help with debugging.

Maybe someone with knowledge of the internals can comment?

>> +     /* DDR3: predict MRS long wait count */
>> +
>> +     if (tegra->dram_type == DRAM_TYPE_DDR3 && dll_change == DLL_CHANGE_ON) {
>> +             u32 cnt = 32;
>> +
>> +             if (timing->emc_zcal_interval != 0 &&
>> +                 tegra->last_timing.emc_zcal_interval == 0)
>> +                     cnt -= tegra->dram_num * 256;
>
> Hmm... I don't understand this: cnt == 32 at the beginning, now you're
> subtracting something that's >= 256 if dram_num > 0. Is that really
> intended?

Yeah, seems like it should be s/32/512.

>> +
>> +     return 0;
>> +}
>> +
>> +static const struct of_device_id tegra_emc_of_match[] = {
>> +     { .compatible = "nvidia,tegra124-emc" },
>> +     {}
>> +};
>> +MODULE_DEVICE_TABLE(of, tegra_emc_of_match);
>> +
>> +static struct tegra_emc *emc_instance;
>
> Can we find a way around this global variable? I suppose that somebody
> is going to call the tegra_emc_{prepare,complete}_timing_change() below,
> so perhaps the caller needs to get a reference to the EMC and pass that
> in?

Ok, it's a bit problematic because the car driver gets probed very
early but I will see at getting a reference to the emc driver lazily.

>> +}
>> +
>> +int tegra_emc_prepare_timing_change(unsigned long rate)
>> +{
>> +     struct emc_timing *timing = tegra_emc_find_timing(rate);
>> +
>> +     if (!timing)
>> +             return -ENOENT;
>> +
>> +     emc_prepare_timing_change(emc_instance, timing);
>> +
>> +     return 0;
>> +}
>
> It seems like this really ought to return an error if
> emc_prepare_timing_change() fails.

Currently emc_prepare_timing_change() cannot fail.

>> +
>> +     ram_code = tegra_read_ram_code();
>> +
>> +     tegra->num_timings = 0;
>> +
>> +     for_each_child_of_node(pdev->dev.of_node, node) {
>> +             err = of_property_read_u32(node, "nvidia,ram-code", &node_ram_code);
>> +             if (err || (node_ram_code != ram_code))
>> +                     continue;
>> +
>> +             err = load_timings_from_dt(tegra, node);
>> +             if (err)
>> +                     return err;
>> +             break;
>> +     }
>> +
>> +     if (tegra->num_timings == 0)
>> +             dev_warn(&pdev->dev, "no memory timings for ram code %u registered\n", ram_code);
>
> Isn't this an error? What's the use of proceeding if this happens?
>
> This is slightly more complicated than I think it should be. Perhaps
> split this into a helper function that finds a node matching the RAM
> code, then:
>
>         node = tegra_emc_find_node_by_ram_code(pdev->dev.of_node, ram_code);
>         if (!node)
>                 return -ENOENT;
>
>         err = load_timings_from_dt(tegra, node);
>         if (err)
>                 return err;
>
> Also I think you need to of_node_put() the node when you're done with
> it.

Yes, now looks better.

>> +
>> +     err = emc_init(tegra);
>> +     if (err) {
>> +             dev_err(&pdev->dev, "initialization failed: %d\n", err);
>> +             return err;
>> +     }
>> +
>> +     platform_set_drvdata(pdev, tegra);
>> +
>> +     emc_instance = tegra;
>> +
>> +     return 0;
>> +};
>> +
>> +static struct platform_driver tegra_emc_driver = {
>> +     .probe = tegra_emc_probe,
>> +     .driver = {
>> +             .name = "tegra-emc",
>> +             .of_match_table = tegra_emc_of_match,
>
> Perhaps you also want to add a ".suppress_bind_attrs = true;" here to
> avoid people from causing oopses by unbinding via sysfs.

Ok, done.

Thanks for the great review!

Regards,

Tomeu
