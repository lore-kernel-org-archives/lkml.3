Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbaKFKdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 05:33:12 -0500
Received: from mail-qg0-f50.google.com ([209.85.192.50]:36293 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbaKFKdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 05:33:09 -0500
MIME-Version: 1.0
In-Reply-To: <545B2D6B.9030001@nvidia.com>
References: <1414599796-30597-1-git-send-email-tomeu.vizoso@collabora.com>
 <1414599796-30597-6-git-send-email-tomeu.vizoso@collabora.com> <545B2D6B.9030001@nvidia.com>
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Date: Thu, 6 Nov 2014 11:32:47 +0100
X-Google-Sender-Auth: YkKBEThPY64soohsdqHcUUK4y04
Message-ID: <CAAObsKD_XxP2Ny7X8=NsB2YqnAJqFHZs=xz8TWt6S8mJ41nsYA@mail.gmail.com>
Subject: Re: [PATCH v3 05/13] of: Document timings subnode of nvidia,tegra-mc
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 November 2014 09:12, Alexandre Courbot <acourbot@nvidia.com> wrote:
> On 10/30/2014 01:22 AM, Tomeu Vizoso wrote:
>>
>> The MC driver needs some timing-specific information to program the EMEM
>> during
>> a rate change of the EMC clock.
>>
>> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
>> ---
>>   .../memory-controllers/nvidia,tegra-mc.txt         | 46
>> +++++++++++++++++++++-
>>   1 file changed, 44 insertions(+), 2 deletions(-)
>>
>> diff --git
>> a/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra-mc.txt
>> b/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra-mc.txt
>> index f3db93c..8467b8c 100644
>> ---
>> a/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra-mc.txt
>> +++
>> b/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra-mc.txt
>> @@ -15,9 +15,26 @@ Required properties:
>>   This device implements an IOMMU that complies with the generic IOMMU
>> binding.
>>   See ../iommu/iommu.txt for details.
>>
>> -Example:
>> ---------
>> +The node should contain a "timings" subnode for each supported RAM type
>> (see
>> +field RAM_CODE in register PMC_STRAPPING_OPT_A), with its unit address
>> being its
>> +RAM_CODE.
>>
>> +Required properties for "timings" nodes :
>> +- nvidia,ram-code : Should contain the value of RAM_CODE this timing set
>> is used
>> +for.
>> +
>> +Each "timings" node should contain a "timing" subnode for every supported
>> EMC
>> +clock rate. The "timing" subnodes should have the clock rate in Hz as
>> their unit
>> +address.
>
>
> In patch 04, a similar sub-node is named "emc-timings". Shouldn't the same
> name be used here for consistency?

Yeah, agreed.

> Also, it seems like there is a need for timing nodes in the MC to have match
> timing nodes in the CAR. It would be nice to add that information in all
> related bindings files.

Well, rather than the timing subnodes in a node having to match the
ones in another nodes, I think that all of them should match the
frequencies at which the EMC can run, which I think is clear enough
like this (already in each of the three bindings):

+Each "timings" node should contain a "timing" subnode for every
supported EMC clock rate.

>> +
>> +Required properties for "timing" nodes :
>> +- clock-frequency : Should contain the memory clock rate in Hz.
>> +- nvidia,emem-configuration : Values to be written to the EMEM register
>> block,
>> +as specified by the board documentation.
>
>
> Could you add some more information about which range of registers we are
> talking about, and whether they must all be specified or only part of them?
>
>
>> +
>> +Example SoC include file:
>> +
>> +/ {
>>         mc: memory-controller@0,70019000 {
>>                 compatible = "nvidia,tegra124-mc";
>>                 reg = <0x0 0x70019000 0x0 0x1000>;
>> @@ -34,3 +51,28 @@ Example:
>>                 ...
>>                 iommus = <&mc TEGRA_SWGROUP_SDMMC1A>;
>>         };
>> +};
>> +
>> +Example board file:
>> +
>> +/ {
>> +       memory-controller@0,70019000 {
>> +               timings@3 {
>> +                       nvidia,ram-code = <3>;
>> +
>> +                       timing@12750000 {
>> +                               clock-frequency = <12750000>;
>> +
>> +                               nvidia,emem-configuration = <
>> +                                       0x40040001 /* MC_EMEM_ARB_CFG */
>> +                                       0x8000000a /*
>> MC_EMEM_ARB_OUTSTANDING_REQ */
>> +                                       0x00000001 /*
>> MC_EMEM_ARB_TIMING_RCD */
>> +                                       0x00000001 /*
>> MC_EMEM_ARB_TIMING_RP */
>> +                                       0x00000002 /*
>> MC_EMEM_ARB_TIMING_RC */
>> +                                       0x00000000 /*
>> MC_EMEM_ARB_TIMING_RAS */
>> +                                       0x00000002 /*
>> MC_EMEM_ARB_TIMING_FAW */
>> +                               >;
>
>
> Looking at the actual board files I suppose this example here is incomplete.
> It would be nice to make this explicit, maybe by adding "..." on a new line
> to indicate more registers are expected.

Sounds good.

Thanks!

Tomeu


> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
