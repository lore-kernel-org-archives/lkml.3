Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781Ab3BLQgC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 11:36:02 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:51033 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933386Ab3BLQgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 11:36:00 -0500
Message-ID: <511A6F6C.8090205@wwwdotorg.org>
Date: Tue, 12 Feb 2013 09:35:56 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Hiroshi Doyu <hdoyu@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "marvin24@gmx.de" <marvin24@gmx.de>, "balbi@ti.com" <balbi@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [v2 3/3] ARM: tegra: Unify Device tree board files
References: <5119849B.1070300@wwwdotorg.org> <5119C958.1030304@wwwdotorg.org> <20130212.070456.532657136988541923.hdoyu@nvidia.com> <201302121350.15683.arnd@arndb.de>
In-Reply-To: <201302121350.15683.arnd@arndb.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 06:50 AM, Arnd Bergmann wrote:
> On Tuesday 12 February 2013, Hiroshi Doyu wrote:
>>>>>>  static void __init paz00_init(void)
>>>>>> @@ -129,6 +128,9 @@ static void __init tegra_dt_init_late(void)
>>>>>>  
>>>>>>   tegra_init_late();
>>>>>>  
>>>>>> + if (IS_ENABLED(CONFIG_PCI) && IS_ENABLED(CONFIG_ARCH_TEGRA_2x_SOC))
>>>>>> +         return;
>>>>>
>>>>> I don't think that's going to help any link issues, so I'd drop it and
>>>>> keep this function simple.
>>>>
>>>> As explained in the above, a complier will drop unnecessary functions
>>>> automatically with this IS_ENABLED(), which could save many ifdefs.
>>>
>>> That sounds extremely brittle. Have you validated this on a wide variety
>>> of compiler versions?
>>
>> I verified with gcc-4.6.
>> IIRC, that's the point of IS_ENABLED() being introduced. Arnd?
> 
> It's certainly expected to work with all compilers, yes. If a compiler
> cannot remove conditional function calls that depend on a constant
> expression, we have a lot of other problems alredy.

Removing the function calls isn't guaranteed to remove the body of the
functions though. Those functions aren't implemented in some separate
file that's optionally included, but rather are implemented in the same
object file, now unconditionally, and they in turn reference (with no
IS_ENABLED logic) other functions that are implemented in conditionally
linked files.

> However, from what I see above, you have the logic reversed (it
> should return if neither TEGRA_2x nor PCI are enabled, rather
> than return if one of them is enabled). and it becomes a little
> confusing to read.
> 
> If you want to get rid of the #ifdef here, I would suggest you put those
> into the functions directly, like
> 
> static void __init harmony_init(void)
> {
>         int ret = 0;
> 
>         if (IS_ENABLED(CONFIG_PCI) && IS_ENABLED(CONFIG_ARCH_TEGRA_2x_SOC))
> 		ret = harmony_pcie_init();
>         if (ret)
>                 pr_err("harmony_pcie_init() failed: %d\n", ret);
> }
> 
> which will turn into an empty function if one of the two is disabled.

That would work.

However I'd like to avoid changing the body of those two functions at
all if possible, since I hope the PCIe driver rework will be merged in
3.10, and that will allow the Harmony and TrimSlice init functions to be
removed entirely. I'd rather not have conflicts with the removal patch.

> Since we are not going to add any other board specfic init functions, you
> can also unroll the loop and put everything into tegra_dt_init_late:

That's not necessarily true. While we certainly don't plan to, I don't
think we can rule it out; after all, we don't have rfkill bindings and
yet other boards will need them.

