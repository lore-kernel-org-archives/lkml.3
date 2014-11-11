Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbaKKGhv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 01:37:51 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:9941 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaKKGht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 01:37:49 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 10 Nov 2014 22:38:09 -0800
Message-ID: <5461AEB7.70507@nvidia.com>
Date: Tue, 11 Nov 2014 15:37:43 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mikko Perttunen <mikko.perttunen@kapsi.fi>, <swarren@wwwdotorg.org>,
        <thierry.reding@gmail.com>, <gnurou@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, <wni@nvidia.com>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: Re: [PATCH v4 REPOST 1/5] of: Add descriptions of thermtrip properties
 to Tegra PMC bindings
References: <1415625137-4791-1-git-send-email-mikko.perttunen@kapsi.fi> <1415625137-4791-2-git-send-email-mikko.perttunen@kapsi.fi>
In-Reply-To: <1415625137-4791-2-git-send-email-mikko.perttunen@kapsi.fi>
X-NVConfidentiality: public
X-Originating-IP: [10.19.57.128]
X-ClientProxiedBy: DRBGMAIL103.nvidia.com (10.18.16.22) To
 HKMAIL102.nvidia.com (10.18.16.11)
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2014 10:12 PM, Mikko Perttunen wrote:
> From: Mikko Perttunen <mperttunen@nvidia.com>
>
> Hardware-triggered thermal reset requires configuring the I2C
> reset procedure. This configuration is read from the device tree,
> so document the relevant properties in the binding documentation.
>
> Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
> Reviewed-by: Wei Ni <wni@nvidia.com>
> Tested-by: Wei Ni <wni@nvidia.com>
> ---
>   .../bindings/arm/tegra/nvidia,tegra20-pmc.txt      | 24 ++++++++++++++++++++++
>   1 file changed, 24 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.txt b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.txt
> index 68ac65f..dc13fb0 100644
> --- a/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.txt
> +++ b/Documentation/devicetree/bindings/arm/tegra/nvidia,tegra20-pmc.txt
> @@ -47,6 +47,21 @@ Required properties when nvidia,suspend-mode=<0>:
>     sleep mode, the warm boot code will restore some PLLs, clocks and then
>     bring up CPU0 for resuming the system.
>
> +Hardware-triggered thermal reset:
> +On Tegra30, Tegra114 and Tegra124, if the 'i2c-thermtrip' subnode exists,
> +hardware-triggered thermal reset will be enabled.
> +
> +Required properties for hardware-triggered thermal reset (inside 'i2c-thermtrip'):
> +- nvidia,i2c-bus : Phandle to I2C bus containing the PMU
> +- nvidia,bus-addr : Bus address of the PMU on the I2C bus
> +- nvidia,reg-addr : I2C register address to write poweroff command to
> +- nvidia,reg-data : Poweroff command to write to PMU

This binding is taking two different routes to provide values to the driver:

1) It uses a phandle for i2c-bus (which must then be provided by another 
binding implemented in the two following patches)

2) It uses direct values for bus-addr, reg-addr and reg-data.

Do we need to use both approaches? bus-addr could just as well be 
obtained through a phandle to the i2c device and reading its reg 
property. From this phandle you could also go back up to the bus, making 
the i2c-bus property unnecessary. reg-addr and reg-data cannot be 
specified that way, obviously.

Actually I think I'd prefer to see i2c-bus become an integer property 
instead of a phandle, because at the end of the day it is a value field 
of a particular register and the reference is only used to retrieve that 
value. It is not like we are actually going to call functions on the bus 
instance or change its state. And for the single purpose of retrieving 
that value, this binding requires the addition of a new property on the 
bus node that will probably never be used for something else.

We can also imagine that some design may not have a PMIC device in the 
DT but still want to use the thermal reset feature. In this case, it is 
again preferable to use direct values.

