Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598Ab3HGRm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 13:42:57 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53837 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071Ab3HGRmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 13:42:54 -0400
Message-ID: <52028719.8070908@wwwdotorg.org>
Date: Wed, 07 Aug 2013 11:42:49 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@sisk.pl, swarren@nvidia.com, linaro-kernel@lists.linaro.org,
        patches@linaro.org, cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mturquette@linaro.org,
        linux-arm-kernel@lists.infradead.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Mark Rutland <Mark.Rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 2/6] ARM: Tegra: Add CPU's OPPs for using cpufreq-cpu0
 driver
References: <cover.1375886595.git.viresh.kumar@linaro.org> <d4cd498d9b63d761039b025216e65278dc8e0e37.1375886595.git.viresh.kumar@linaro.org>
In-Reply-To: <d4cd498d9b63d761039b025216e65278dc8e0e37.1375886595.git.viresh.kumar@linaro.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 08:46 AM, Viresh Kumar wrote:
> cpufreq-cpu0 driver needs OPPs to be present in DT which can be probed by it to
> get frequency table. This patch adds OPPs and clock-latency to tegra cpu0 node
> for multiple SoCs.
> 
> Voltage levels aren't used until now for tegra and so a flat value which would
> eventually be ignored is used to represent voltage.

This patch is problematic w.r.t. DT being an ABI.

We can certainly add new optional properties to a DT binding that enable
new features. However, a new version of a binding can't require new
properties to exist that didn't before, since that means that old DTs
won't work with new kernels that require the new properties.

As such, I believe we do need some Tegra-specific piece of code that
defines these OPP tables in the kernel, so that the operating-points
property is not needed.

Similarly, we can't put invalid voltages into the DT, since if a later
kernel version starts actually using that field, the HW will no longer
work correctly. Unless perhaps we put 0 into the DT and make the binding
define that 0 means "you can't change the voltage at all away from the
boot value"?

Is the operating-points property documented in
Documentation/devicetree/bindings/ somewhere?

(Also Cc'ing the DT mailing list and maintainers)

> diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114.dtsi
> index abf6c40..730e0d9 100644
> --- a/arch/arm/boot/dts/tegra114.dtsi
> +++ b/arch/arm/boot/dts/tegra114.dtsi
> @@ -438,6 +438,18 @@
>  			device_type = "cpu";
>  			compatible = "arm,cortex-a15";
>  			reg = <0>;
> +			operating-points = <
> +				/* kHz    ignored */
> +				 216000   1000000
> +				 312000   1000000
> +				 456000   1000000
> +				 608000   1000000
> +				 760000   1000000
> +				 816000   1000000
> +				 912000   1000000
> +				 1000000  1000000
> +			>;
> +			clock-latency = <300000>;
>  		};

