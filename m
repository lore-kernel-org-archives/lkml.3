Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751247Ab3GJGs1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 02:48:27 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17845 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab3GJGsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 02:48:25 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 09 Jul 2013 23:47:48 -0700
Message-ID: <51DD03C8.1090207@nvidia.com>
Date: Wed, 10 Jul 2013 14:48:40 +0800
From: Wei Ni <wni@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Eduardo Valentin <eduardo.valentin@ti.com>
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "durgadoss.r@intel.com" <durgadoss.r@intel.com>,
        "amit.daniel@samsung.com" <amit.daniel@samsung.com>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 2/4] thermal: introduce device tree parser
References: <1373378414-28086-1-git-send-email-eduardo.valentin@ti.com> <1373378414-28086-3-git-send-email-eduardo.valentin@ti.com>
In-Reply-To: <1373378414-28086-3-git-send-email-eduardo.valentin@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2013 10:00 PM, Eduardo Valentin wrote:
> In order to be able to build thermal policies
> based on generic sensors, like I2C device, that
> can be places in different points on different boards,
> there is a need to have a way to feed board dependent
> data into the thermal framework.
> 
> This patch introduces a thermal data parser for device
> tree. The parsed data is used to build thermal zones
> and thermal binding parameters. The output data
> can then be used to deploy thermal policies.
> 
> This patch adds also documentation regarding this
> API and how to define define tree nodes to use
> this infrastructure.

It looks good, with this infrastructure, we can add generic sensor
driver into the thermal fw easily.


> +
> +Below is an example:
> +thermal_zone {
> +            type = "CPU";
> +            mask = <0x03>; /* trips writability */
> +            passive_delay = <250>; /* milliseconds */
> +            polling_delay = <1000>; /* milliseconds */
> +            governor = "step_wise";
> +            trips {
> +                    alert@100000{
> +                            temperature = <100000>; /* milliCelsius */
> +                            hysteresis = <0>; /* milliCelsius */
> +                            type = <1>;

how about to use the trip type name directly, such as named as
"passive-trip;", I think it's more readable. for example:
trip0 {
....
passive-trip;
}
trip1 {
....
active-trip;
}

> +                    };
> +                    crit@125000{
> +                            temperature = <125000>; /* milliCelsius */
> +                            hysteresis = <0>; /* milliCelsius */
> +                            type = <3>;
> +                    };
> +            };
> +            bind_params {
> +                    action@0{
> +                            cooling_device = "thermal-cpufreq";
> +                            weight = <100>; /* percentage */
> +                            mask = <0x01>;
> +                    };
> +            };
> +};

as we know, thermal_zone_bind_cooling_device() will set the upper/lower
in the thermal_instance. In the default .bind function, it just set to
THERMAL_NO_LIMIT, but for some platform, it need to set these
upper/lower values for different cooling device and trips, how to pass
these values in DT? how about to set:
action@0 {
...
mask = <0x03>; //or you can remove this property;
trip0 = <&alert 1 2>; //1 is lower value, 2 is upper value;
trip1 = <&crit 3 4>;
}


Thanks.
Wei.

