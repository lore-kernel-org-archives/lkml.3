Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965193Ab3DJRXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 13:23:19 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57238 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964846Ab3DJRXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 13:23:17 -0400
Message-ID: <5165A001.9030408@wwwdotorg.org>
Date: Wed, 10 Apr 2013 11:23:13 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jay Agarwal <jagarwal@nvidia.com>
CC: linux@arm.linux.org.uk, thierry.reding@avionic-design.de,
        ldewangan@nvidia.com, bhelgaas@google.com, olof@lixom.net,
        hdoyu@nvidia.com, pgaikwad@nvidia.com, mturquette@linaro.org,
        pdeschrijver@nvidia.com, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, jtukkinen@nvidia.com, kthota@nvidia.com
Subject: Re: [PATCH 1/3] ARM: tegra: pcie: Add tegra3 support
References: <1365435688-4179-1-git-send-email-jagarwal@nvidia.com>
In-Reply-To: <1365435688-4179-1-git-send-email-jagarwal@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2013 09:41 AM, Jay Agarwal wrote:
> Signed-off-by: Jay Agarwal <jagarwal@nvidia.com>
> 
> - Enable pcie root port 2 for cardhu
> - Make private data structure for each SOC
> - Add required tegra3 clocks and regulators
> - Add tegra3 specific code in enable controller
> - Modify clock tree to get clocks based on device
> - Based on git://gitorious.org/thierryreding/linux.git

Did you test these patches? They don't work for me on my Cardhu A04.

First off, I had to change the num-lanes properties to match Cardhu's
actual configuration:

> diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi b/arch/arm/boot/dts/tegra30-cardhu.dtsi
> index d64d12c..6426226 100644
> --- a/arch/arm/boot/dts/tegra30-cardhu.dtsi
> +++ b/arch/arm/boot/dts/tegra30-cardhu.dtsi
> @@ -143,8 +143,17 @@
>                 vdd-supply = <&ldo1_reg>;
>                 avdd-supply = <&ldo2_reg>;
>  
> +               pci@1,0 {
> +                       nvidia,num-lanes = <4>;
> +               };
> +
> +               pci@2,0 {
> +                       nvidia,num-lanes = <1>;
> +               };
> +
>                 pci@3,0 {
>                         status = "okay";
> +                       nvidia,num-lanes = <1>;
>                 };
>         };
>  

However, even after doing that, the driver doesn't detect anything
attached to port@3,0, even though I have the board plugged into the
docking station, and hence the PCI Ethernet should be detected:

> [    3.103860] tegra-pcie 3000.pcie-controller: 4x1, 1x2 configuration
> [    3.113755] tegra-pcie 3000.pcie-controller: probing port 2, using 1 lanes
> [    3.324364] tegra-pcie 3000.pcie-controller: link 2 down, retrying
> [    3.534249] tegra-pcie 3000.pcie-controller: link 2 down, retrying
> [    3.744160] tegra-pcie 3000.pcie-controller: link 2 down, retrying
> [    3.751359] tegra-pcie 3000.pcie-controller: link 2 down, ignoring

(I see the same messages even without fixing the lane configuration,
exception for the first configuration message obviously prints something
different).

Are you testing with U-Boot, or using our binary bootloader? Upstream
code must be tested with U-Boot, to make sure it doesn't rely on any HW
programming performed by the bootloader.
