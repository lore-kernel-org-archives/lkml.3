Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415AbaKFIWF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 03:22:05 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:10689 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaKFIWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 03:22:02 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 06 Nov 2014 00:22:47 -0800
Message-ID: <545B2D6B.9030001@nvidia.com>
Date: Thu, 6 Nov 2014 17:12:27 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>, <linux-tegra@vger.kernel.org>
CC: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 05/13] of: Document timings subnode of nvidia,tegra-mc
References: <1414599796-30597-1-git-send-email-tomeu.vizoso@collabora.com> <1414599796-30597-6-git-send-email-tomeu.vizoso@collabora.com>
In-Reply-To: <1414599796-30597-6-git-send-email-tomeu.vizoso@collabora.com>
X-NVConfidentiality: public
X-Originating-IP: [10.19.57.128]
X-ClientProxiedBy: HKMAIL101.nvidia.com (10.18.16.10) To
 HKMAIL102.nvidia.com (10.18.16.11)
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2014 01:22 AM, Tomeu Vizoso wrote:
> The MC driver needs some timing-specific information to program the EMEM during
> a rate change of the EMC clock.
>
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> ---
>   .../memory-controllers/nvidia,tegra-mc.txt         | 46 +++++++++++++++++++++-
>   1 file changed, 44 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra-mc.txt b/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra-mc.txt
> index f3db93c..8467b8c 100644
> --- a/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra-mc.txt
> +++ b/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra-mc.txt
> @@ -15,9 +15,26 @@ Required properties:
>   This device implements an IOMMU that complies with the generic IOMMU binding.
>   See ../iommu/iommu.txt for details.
>
> -Example:
> ---------
> +The node should contain a "timings" subnode for each supported RAM type (see
> +field RAM_CODE in register PMC_STRAPPING_OPT_A), with its unit address being its
> +RAM_CODE.
>
> +Required properties for "timings" nodes :
> +- nvidia,ram-code : Should contain the value of RAM_CODE this timing set is used
> +for.
> +
> +Each "timings" node should contain a "timing" subnode for every supported EMC
> +clock rate. The "timing" subnodes should have the clock rate in Hz as their unit
> +address.

In patch 04, a similar sub-node is named "emc-timings". Shouldn't the 
same name be used here for consistency?

Also, it seems like there is a need for timing nodes in the MC to have 
match timing nodes in the CAR. It would be nice to add that information 
in all related bindings files.

> +
> +Required properties for "timing" nodes :
> +- clock-frequency : Should contain the memory clock rate in Hz.
> +- nvidia,emem-configuration : Values to be written to the EMEM register block,
> +as specified by the board documentation.

Could you add some more information about which range of registers we 
are talking about, and whether they must all be specified or only part 
of them?

> +
> +Example SoC include file:
> +
> +/ {
>   	mc: memory-controller@0,70019000 {
>   		compatible = "nvidia,tegra124-mc";
>   		reg = <0x0 0x70019000 0x0 0x1000>;
> @@ -34,3 +51,28 @@ Example:
>   		...
>   		iommus = <&mc TEGRA_SWGROUP_SDMMC1A>;
>   	};
> +};
> +
> +Example board file:
> +
> +/ {
> +	memory-controller@0,70019000 {
> +		timings@3 {
> +			nvidia,ram-code = <3>;
> +
> +			timing@12750000 {
> +				clock-frequency = <12750000>;
> +
> +				nvidia,emem-configuration = <
> +					0x40040001 /* MC_EMEM_ARB_CFG */
> +					0x8000000a /* MC_EMEM_ARB_OUTSTANDING_REQ */
> +					0x00000001 /* MC_EMEM_ARB_TIMING_RCD */
> +					0x00000001 /* MC_EMEM_ARB_TIMING_RP */
> +					0x00000002 /* MC_EMEM_ARB_TIMING_RC */
> +					0x00000000 /* MC_EMEM_ARB_TIMING_RAS */
> +					0x00000002 /* MC_EMEM_ARB_TIMING_FAW */
> +				>;

Looking at the actual board files I suppose this example here is 
incomplete. It would be nice to make this explicit, maybe by adding 
"..." on a new line to indicate more registers are expected.
