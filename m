Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759325Ab3BLUwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:52:24 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:35098 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757413Ab3BLUwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:52:21 -0500
Message-ID: <511AAB81.4000306@wwwdotorg.org>
Date: Tue, 12 Feb 2013 13:52:17 -0700
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
References: <5119849B.1070300@wwwdotorg.org> <201302121350.15683.arnd@arndb.de> <511A6F6C.8090205@wwwdotorg.org> <201302121732.14960.arnd@arndb.de>
In-Reply-To: <201302121732.14960.arnd@arndb.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 10:32 AM, Arnd Bergmann wrote:
> On Tuesday 12 February 2013, Stephen Warren wrote:
>>>>>>> I don't think that's going to help any link issues, so I'd drop it and
>>>>>>> keep this function simple.
>>>>>>
>>>>>> As explained in the above, a complier will drop unnecessary functions
>>>>>> automatically with this IS_ENABLED(), which could save many ifdefs.
>>>>>
>>>>> That sounds extremely brittle. Have you validated this on a wide variety
>>>>> of compiler versions?
>>>>
>>>> I verified with gcc-4.6.
>>>> IIRC, that's the point of IS_ENABLED() being introduced. Arnd?
>>>
>>> It's certainly expected to work with all compilers, yes. If a compiler
>>> cannot remove conditional function calls that depend on a constant
>>> expression, we have a lot of other problems alredy.
>>
>> Removing the function calls isn't guaranteed to remove the body of the
>> functions though. Those functions aren't implemented in some separate
>> file that's optionally included, but rather are implemented in the same
>> object file, now unconditionally, and they in turn reference (with no
>> IS_ENABLED logic) other functions that are implemented in conditionally
>> linked files.
> 
> I think gcc should remove all of that in this case, since board_init_funcs
> becomes unused when the only code that references it cannot be reached,
> and when that array is gone, the now unused functions would be removed
> as well.
> 
> We have had bugs with prerelease gcc versions that did not handle cases
> like this in the way we want it, but I think all releases get it right.
> I don't think it's mandated anywhere in the C99 standard that this is
> what happens, but we do rely on it anyway AFAIK.

Hmmm. Very surprisingly (to me), this does indeed work fine, even with
an older gcc-4.4.1 I had lying around (after fixing the test inversion
in tegra_dt_init_late).

I believe U-Boot enabled -ffunction-sections -fdata-sections or similar
(recently?) to get this kind of behaviour. I wonder why the kernel
didn't need that. Perhaps -O2 is more aggressive (within a file at
least) than I thought.

I did note a few warnings due to the ifdefs in tegra_auxdata_lookup[]:

arch/arm/mach-tegra/tegra.c:47: warning: 'tegra_ehci1_pdata' defined but
not used
arch/arm/mach-tegra/tegra.c:58: warning: 'tegra_ehci2_pdata' defined but
not used
arch/arm/mach-tegra/tegra.c:65: warning: 'tegra_ehci3_pdata' defined but
not used

(I built a tegra_defconfig kernel and modified it to enable
Tegra30+Tegra114, disable Tegra20, disable DRM)
