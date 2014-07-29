Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbaG2PtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:49:14 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:59158 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006AbaG2PtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:49:12 -0400
Message-ID: <53D7C276.2080204@wwwdotorg.org>
Date: Tue, 29 Jul 2014 09:49:10 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mikko Perttunen <mperttunen@nvidia.com>
CC: Andrew Bresticker <abrestic@chromium.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5/8] of: Add Tegra124 EMC bindings
References: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com>	<1405088313-20048-6-git-send-email-mperttunen@nvidia.com>	<CAL1qeaGHfjQhLHvgzt85hmbuY4FOG5-k=f80=CNvzPDEgi9_6w@mail.gmail.com>	<53CD860B.7030800@wwwdotorg.org>	<CAL1qeaHtGQxCO3cGdeCRUYuk6mxei6z1B63-iZdBECEbFqGhHw@mail.gmail.com>	<53CE9514.1050903@wwwdotorg.org> <CAL1qeaEkL+mxb0S4JhQbXBjyNyKJndffTSjMaAFQD6ooDJPd+Q@mail.gmail.com> <53CEA093.6060106@wwwdotorg.org> <53D75B90.7050501@nvidia.com>
In-Reply-To: <53D75B90.7050501@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2014 02:30 AM, Mikko Perttunen wrote:
> Looks like the TRM doesn't document this either. I'll add an option
> ("nvidia,short-ram-code" ?) for the next version.

Using the 2-bit RAM code field as the RAM code is normal operation, so I 
wouldn't call this "short".

Using the 2-bit boot device code field as extra RAM code bits is 
non-standard.

I would suggest nvidia,use-4-bit-ram-code or 
nvidia,use-boot-device-code-as-ram-code-msbs(!) as the property.

I see that the TRM implies the whole 4-bit field is RAM code, rather 
than there being 2 separate 2-bit fields for RAM code and boot device 
code. Can you please file a bug against the TRM to document this 
correctly? (The details of which bits are which are visible on the 
Jetson TK1 schematics for example).

> On 22/07/14 20:34, Stephen Warren wrote:
>> On 07/22/2014 11:22 AM, Andrew Bresticker wrote:
>>> On Tue, Jul 22, 2014 at 9:45 AM, Stephen Warren
>>> <swarren@wwwdotorg.org> wrote:
>>>>
>>>> Does the bootloader adjust the DT that's passed to the kernel so that
>>>> only the relevant single set of EMC timings is contained in the DT?
>>>
>>> No, the DT contains all possible EMC timings for that board.
>>>
>>>> On a system where the boot ROM initializes RAM, and where the HW design
>>>> might have multiple SDRAM configuration, here's what usually happens:
>>>>
>>>> a) The BCT contains N sets of SDRAM configurations.
>>>>
>>>> b) The boot ROM reads the SDRAM strapping bits, and uses them to pick
>>>> the correct SDRAM configuration from the N sets in the BCT.
>>>>
>>>> c) The kernel DT has N sets of SDRAM configurations.
>>>>
>>>> d) The kernel reads the SDRAM strapping bits, and uses them to pick the
>>>> correct SDRAM configuration from the N sets in the DT.
>>>>
>>>> On the ChromeOS boards (so (a) and (b) above are irrelevant) where N is
>>>> too large to fit into APBDEV_PMC_STRAPPING_OPT_A_0[7:4], (c) and (d)
>>>> won't work. I assume the kernel DT therefore must be adjusted to only
>>>> contain the single SDRAM configuration that is relevant for the
>>>> current HW?
>>>>
>>>> (isn't STRAPPING_OPT_A split into 2 2-bit fields; 2 bits for SDRAM
>>>> index
>>>> and 2 bits for boot flash index, so max N is quite small?)
>>>
>>> Right, there are normally only 2 SDRAM strapping bits available.
>>> ChromeOS gets around this by having 4 identical boot device entries in
>>> the BCT, so all possible values of STRAPPING_OPT_A[7:6] map to the
>>> same boot device.  This allows us to use all 4 strapping bits in
>>> coreboot to pick the SDRAM configuration.
>>
>> OK, that explains how it works.
>>
>> But that means that when the kernel reads the strapping options, it will
>> have to know if it uses just 2 bits (standard) or all 4 bits
>> (non-standard) to index into the DT's array of SDRAM configurations.
>> We'll need a DT property to represent that.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

