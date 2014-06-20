Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934477AbaFTF0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 01:26:49 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:8556 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbaFTF0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 01:26:47 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 19 Jun 2014 22:21:00 -0700
Message-ID: <53A3C613.8030207@nvidia.com>
Date: Fri, 20 Jun 2014 14:26:43 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, Stephen Warren <swarren@wwwdotorg.org>
CC: Thierry Reding <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: tegra: TN7: relax some regulators
References: <1403164154-1362-1-git-send-email-acourbot@nvidia.com> <53A308C8.2070004@wwwdotorg.org> <20140619175643.GR5099@sirena.org.uk>
In-Reply-To: <20140619175643.GR5099@sirena.org.uk>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2014 02:56 AM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Thu, Jun 19, 2014 at 09:59:04AM -0600, Stephen Warren wrote:
>> On 06/19/2014 01:49 AM, Alexandre Courbot wrote:
>
>>> Remove the regulator-always-on property from some regulators that do not
>>> need it. On recent kernels fixed regulators which supply is always on
>>> fail registration.
>
>> That sounds like a bug in the regulator core, which should be fixed there.
>
> Please actually describe the problem you believe you are seeing - I've
> seen no reports and I can't tell anything from what you've described,
> nor can I see any obvious way that a regulator being fixed would have
> any effect on its supply.

Here is some more information about what happens.

We have a fixed regulator defined as follows:

vdd_lcd: regulator@2 {
         compatible = "regulator-fixed";
         reg = <2>;
         regulator-name = "VD_LCD_1V8";
         regulator-min-microvolt = <1800000>;
         regulator-max-microvolt = <1800000>;
         gpio = <&palmas_gpio 4 GPIO_ACTIVE_HIGH>;
         enable-active-high;
         vin-supply = <&vdd_1v8>;
         regulator-boot-on;
};

Its vin-supply is part of the palmas device:

vdd_1v8: smps8 {
         regulator-name = "vs-pmu-1v8";
         regulator-min-microvolt = <1800000>;
         regulator-max-microvolt = <1800000>;
         regulator-always-on;
         regulator-boot-on;
};

When vdd_lcd is registered, set_supply() is called, which creates a new 
regulator for vdd_1v8. In create_regulator(), 
_regulator_can_change_status() returns false (as it should since the 
regulator is always_on) and _regulator_is_enabled() *also* returns 
false, so as a result regulator->always_on remains false for vdd_1v8.

Later in regulator_register(), we try to enable the supply. Since 
regulator->always_on is false, _regulator_enable() is called on vdd_1v8, 
and the pair _regulator_is_enabled() / _regulator_can_change_status() is 
called again with the same result, which causes _regulator_enable() to 
return -EPERM. This prevents vdd_lcd from being registered.

So I can see three questions here:

1) Why does _regulator_enable() on vdd_1v8 return 0 while everything 
suggests that it is enabled (this regulator powers lot of devices, like 
eMMC, which are working fine). This may be an issue with the palmas driver.

2) When an always-on regulator that is not yet enabled is registered, 
shouldn't it be switched on by the regulator framework?

3) When a boot-on regulator is registered and _regulator_is_enabled() 
returns contradictory information, what should be done?

Note that whether the regulator-boot-on property is present or not does 
not change anything.

I tried to find a recent patch that could have introduced a change of 
behavior, but could not find anything so far. Bisecting is made harder 
by the fact this happens on a newly-introduced board which requires a 
bunch of patches of its own, but it we need more information I can try 
to do it anyway.

Thanks,
Alex.

