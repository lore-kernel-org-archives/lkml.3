Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530Ab3EHRE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 13:04:29 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44985 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924Ab3EHRE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 13:04:27 -0400
Message-ID: <518A8596.7070702@wwwdotorg.org>
Date: Wed, 08 May 2013 11:04:22 -0600
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
Subject: Re: [PATCH 4/4] ARM: tegra: pcie: Enable PCIe controller on Cardhu
References: <1368010660-31465-1-git-send-email-jagarwal@nvidia.com> <1368010660-31465-4-git-send-email-jagarwal@nvidia.com>
In-Reply-To: <1368010660-31465-4-git-send-email-jagarwal@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2013 04:57 AM, Jay Agarwal wrote:
> - Enable PCIe controller on Cardhu
> - Only port 2 is connected on this board
> - Add regulators required for Tegra30
> - Patch is based on remotes/gitorious_thierryreding_linux/tegra/next
> - and should be applied on top of this.

> diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi b/arch/arm/boot/dts/tegra30-cardhu.dtsi

> +	pcie-controller {
> +		status = "okay";
> +		pex-clk-supply = <&pex_hvdd_3v3_reg>;
> +		vdd-supply = <&ldo1_reg>;
> +		avdd-supply = <&ldo2_reg>;
> +
> +		pci@3,0 {
> +			status = "okay";
> +		};
> +	};

So, if I apply this series, I do see the PCIe bridge and Ethernet device
get enumerated, but I don't see the USB3 controller get enumerated. I
believe that is a PCIe device behind the same bridge on the same Tegra
PCIe port. Shouldn't this device show up?

The Ethernet interface gets an IP address by DHCP, so some amount of
data must be flowing. However, I cannot ping anything. If I run the same
kernel on a Tegra20 TrimSlice board, which has the same Ethernet chip,
then everything works as expected. Have you fully tested network
connectivity with these patches applied? Perhaps this is related to the
next problem:

According to the Cardhu schematics, the PCIe link to the dock is a
single lane. Hence, I believe that the Cardhu DT should describe a 411
port configuration. However, the Cardhu DT doesn't describe any
particular link configuration, but just inherits the default from
tegra30.dtsi, which describes a 222 link configuration. I would have
expected the following in the Cardhu DT:

		pci@1,0 {
			nvidia,num-lanes = <4>;
		};

		pci@2,0 {
			nvidia,num-lanes = <1>;
		};

		pci@3,0 {
			status = "okay";
			nvidia,num-lanes = <1>;
		};

However, if I put that there, no PCIe links are detected at all. Why
does the driver work with the wrong link configuration, but fail with
the correct one?

Related, I notice that in Thierry's patches which you're building on,
tegra_pcie_get_xbar_config() still has a bug where a zero return value
is treated as an error, even though it's a valid HW register value.
Perhaps this is related?
