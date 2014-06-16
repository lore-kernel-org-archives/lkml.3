Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbaFPUCS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 16:02:18 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55611 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521AbaFPUCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 16:02:16 -0400
Message-ID: <539F4D44.3070309@wwwdotorg.org>
Date: Mon, 16 Jun 2014 14:02:12 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        David Airlie <airlied@linux.ie>,
        Mike Turquette <mturquette@linaro.org>, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH 1/4] memory: tegra124-emc: Add EMC driver
References: <1402925713-25426-1-git-send-email-tomeu.vizoso@collabora.com> <1402925713-25426-2-git-send-email-tomeu.vizoso@collabora.com>
In-Reply-To: <1402925713-25426-2-git-send-email-tomeu.vizoso@collabora.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2014 07:35 AM, Tomeu Vizoso wrote:
> Adds functionality for registering memory bandwidth needs and setting
> the EMC clock rate based on that.
> 
> Also adds API for setting floor and ceiling frequency rates.

> diff --git a/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra124-emc.txt b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra124-emc.txt
> new file mode 100644
> index 0000000..88e6a55
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra124-emc.txt
> @@ -0,0 +1,26 @@
> +Tegra124 External Memory Controller
> +
> +Properties:
> +- compatible : Should contain "nvidia,tegra124-emc".
> +- reg : Should contain the register range of the device
> +- #address-cells : Should be 1
> +- #size-cells : Should be 0
> +- nvidia,mc : phandle to the mc bus connected to EMC.
> +- clocks : phandle to EMC, EMC shared bus override, and all parent clocks.
> +- clock-names : name of each clock.
> +- nvidia,pmc : phandle to the PMC syscon node.
> +- max-clock-frequency : optional, specifies the maximum EMC rate in kHz.
> +
> +Child device nodes describe the memory settings for different configurations and
> +clock rates.

How do the child nodes do that? The binding needs to specify the format
of the child node. This binding looks quite anaemic vs.
Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-emc.txt; I
would expect that this binding needs all the EMC register data from the
tegra20-emc binding too. Can the two bindings be identical?

Can you explain what the nvidia,mc and nvidia,pmc references are needed
for? Hopefully, this driver isn't going to reach into those devices and
touch their registers directly.

> diff --git a/include/linux/platform_data/tegra_emc.h b/include/linux/platform_data/tegra_emc.h

A header file that defines platform data format isn't the correct place
to put the definitions of public APIs. I'd expect something more like
<linux/tegra-soc.h>.

> +#ifdef CONFIG_TEGRA124_EMC
> +int tegra124_emc_reserve_bandwidth(unsigned int consumer, unsigned long rate);
> +void tegra124_emc_set_floor(unsigned long freq);
> +void tegra124_emc_set_ceiling(unsigned long freq);
> +#else
> +int tegra124_emc_reserve_bandwidth(unsigned int consumer, unsigned long rate)
> +{ return -ENODEV; }
> +void tegra124_emc_set_floor(unsigned long freq)
> +{ return; }
> +void tegra124_emc_set_ceiling(unsigned long freq)
> +{ return; }
> +#endif

I'll repeat what I said off-list so that we can have the whole
conversation on the list:

That looks like a custom Tegra-specific API. I think it'd be much better
to integrate this into the common clock framework as a standard clock
constraints API. There are other use-cases for clock constraints besides
EMC scaling (e.g. some in audio on Tegra, and I'm sure many on other
SoCs too).

See https://lkml.org/lkml/2014/5/16/569 for some previous discussion on
this topic.
