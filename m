Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbaGIHvH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 03:51:07 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:41452 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755115AbaGIHvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 03:51:03 -0400
Message-ID: <53BCF463.3000604@linaro.org>
Date: Wed, 09 Jul 2014 08:50:59 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Stephen Warren <swarren@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: a case for a common efuse API?
References: <53BC4DD7.20906@codeaurora.org>
In-Reply-To: <53BC4DD7.20906@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 08/07/14 21:00, Stephen Boyd wrote:
> Hi,
>
> On MSM chips we have some efuses (called qfprom) where we store things
> like calibration data, speed bins, etc. We need to read out data from
> the efuses in various drivers like the cpufreq, thermal, etc. This
> essentially boils down to a bunch of readls on the efuse from a handful
> of different drivers. In devicetree this looks a little odd because
> these drivers end up having an extra reg property (or two) that points
> to a register in the efuse and some length, i.e you see this:
>
> 	thermal-sensor@34000 {
> 		compatible = "sensor";
> 		reg = <0x34000 0x1000>, <0x10018 0xc>;
> 		reg-names = "sensor", "efuse_calib";
> 	}
>
>
> I imagine in DT we want something more like this:
>
> 	efuse: efuse@10000 {
> 		compatible = "efuse";
> 		reg = <0x10000 0x1000>;
> 	}
>
> 	thermal-sensor@34000 {
> 		compatible = "sensor";
> 		reg = <0x34000 0x1000>;
> 		efuse = <&efuse 0x18>;
> 	}
>
>
> Where we can point to the efuse and give an address offset. From code we
> could then call some efuse_read() function to read the sensor's
> calibration data.
>
> It's been suggested that we use syscon for this, but I wonder if that is
> the right thing to do. With a syscon you're usually writing some
> registers that got lumped together with other registers that aren't
> directly related to your driver. It doesn't seem like syscon is made for
> reading fuses or other things like eeproms. Maybe I'm wrong though.
>

I remember there was a similar discussion some time last year about 
this:  https://lkml.org/lkml/2013/7/5/361


> Using syscon would probably work if we could add a way to point to
> offsets within the syscon node (the 0x18 part in the example). In my
> specific use-case the calibration data may have different offsets
> depending on which SoC the hardware is instantiated in so we could also
> make syscon work if the compatible field for the sensor node indicates
> which SoC it is.

Something like this:

	efuse: efuse@10000 {
  		compatible = "efuse", "syscon";
  		reg = <0x10000 0x1000>;
  	}

  	thermal-sensor@34000 {
  		compatible = "sensor", "soc-xyz";
  		reg = <0x34000 0x1000>;
		syscon = <&efuse>;
  	}

sensor driver could add of_data for the soc-xyz which would contain soc 
specific efuse offsets.


--srini

>
> I added Tegra folks because I see that on Tegra this hardware is exposed
> via an SoC specific API, tegra_fuse_readl(), and an associated driver in
> drivers/misc/fuse/tegra/. Unfortunately I don't see any users of the API
> outside of the speedo code in the same directory and the sysfs bin
> attribute that may or may not be in use by some userspace code.
>
