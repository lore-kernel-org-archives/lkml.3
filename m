Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbaGVQpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 12:45:15 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60420 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbaGVQpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 12:45:13 -0400
Message-ID: <53CE9514.1050903@wwwdotorg.org>
Date: Tue, 22 Jul 2014 10:45:08 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>
CC: Mikko Perttunen <mperttunen@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5/8] of: Add Tegra124 EMC bindings
References: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com>	<1405088313-20048-6-git-send-email-mperttunen@nvidia.com>	<CAL1qeaGHfjQhLHvgzt85hmbuY4FOG5-k=f80=CNvzPDEgi9_6w@mail.gmail.com>	<53CD860B.7030800@wwwdotorg.org> <CAL1qeaHtGQxCO3cGdeCRUYuk6mxei6z1B63-iZdBECEbFqGhHw@mail.gmail.com>
In-Reply-To: <CAL1qeaHtGQxCO3cGdeCRUYuk6mxei6z1B63-iZdBECEbFqGhHw@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2014 04:52 PM, Andrew Bresticker wrote:
> On Mon, Jul 21, 2014 at 2:28 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
>> On 07/11/2014 10:43 AM, Andrew Bresticker wrote:
>>> On Fri, Jul 11, 2014 at 7:18 AM, Mikko Perttunen <mperttunen@nvidia.com> wrote:
>>>> Add binding documentation for the nvidia,tegra124-emc device tree
>>>> node.
>>>
>>>> diff --git a/Documentation/devicetree/bindings/memory-controllers/tegra-emc.txt b/Documentation/devicetree/bindings/memory-controllers/tegra-emc.txt
>>>
>>>> +Required properties :
>>>> +- compatible : "nvidia,tegra124-emc".
>>>> +- reg : Should contain 1 or 2 entries:
>>>> +  - EMC register set
>>>> +  - MC register set : Required only if no node with
>>>> +    'compatible = "nvidia,tegra124-mc"' exists. The MC register set
>>>> +    is first read from the MC node. If it doesn't exist, it is read
>>>> +    from this property.
>>>> +- timings : Should contain 1 entry for each supported clock rate.
>>>> +  Entries should be named "timing@n" where n is a 0-based increasing
>>>> +  number. The timings must be listed in rate-ascending order.
>>>
>>> There are upcoming boards which support multiple DRAM configurations
>>> and require a separate set of timings for each configuration.  Could
>>> we instead have multiple sets of timings with the proper one selected
>>> at runtime by RAM code, as reported by PMC_STRAPPING_OPT_A_0?
>>> Something like:
>>>
>>> emc {
>>>         emc-table@0 {
>>>                 nvidia,ram-code = <0>;
>>>                 timing@0 {
>>>                         ...
>>>                 };
>>>                 ...
>>>         };
>>
>> Until recently, there was a binding for Tegra20 EMC in mainline. We
>> should make sure the Tegra124 driver (or rather binding...) is at least
>> as feature-ful as that was.
>>
>> Furthermore, I thought that with some boards, there were more RAM
>> options that there were available RAM code strap bits. I assume that in
>> mainline, we'll simply have different base DT files for the different
>> sets of configurations? Or, will we want to add another level to the DT
>> to represent different sets of RAM code values? I'm not sure what data
>> source the bootloader uses to determine which set of RAM configuration
>> to use when there aren't enough entries in the BCT for the boot ROM to
>> do this automatically, and whether we have any way to get that value
>> into the kernel, so it could use it for the extra DT level lookup?
> 
> For the ChromeOS boards at least we are neither limited by the number
> of strapping bits (4) nor the number of BCT entries supported by the
> boot ROM (since coreboot does not rely on the boot ROM for SDRAM
> initialization), so having a single set of SDRAM configurations for
> each board, indexed by APBDEV_PMC_STRAPPING_OPT_A_0[7:4] works just
> fine.

Does the bootloader adjust the DT that's passed to the kernel so that
only the relevant single set of EMC timings is contained in the DT?

On a system where the boot ROM initializes RAM, and where the HW design
might have multiple SDRAM configuration, here's what usually happens:

a) The BCT contains N sets of SDRAM configurations.

b) The boot ROM reads the SDRAM strapping bits, and uses them to pick
the correct SDRAM configuration from the N sets in the BCT.

c) The kernel DT has N sets of SDRAM configurations.

d) The kernel reads the SDRAM strapping bits, and uses them to pick the
correct SDRAM configuration from the N sets in the DT.

On the ChromeOS boards (so (a) and (b) above are irrelevant) where N is
too large to fit into APBDEV_PMC_STRAPPING_OPT_A_0[7:4], (c) and (d)
won't work. I assume the kernel DT therefore must be adjusted to only
contain the single SDRAM configuration that is relevant for the current HW?

(isn't STRAPPING_OPT_A split into 2 2-bit fields; 2 bits for SDRAM index
and 2 bits for boot flash index, so max N is quite small?)
