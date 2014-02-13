Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbaBMAHB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 19:07:01 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:43460 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbaBMAG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 19:06:58 -0500
Message-ID: <52FC0CA1.5000004@codeaurora.org>
Date: Wed, 12 Feb 2014 16:06:57 -0800
From: Laura Abbott <lauraa@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: devicetree@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC/PATCH 0/3] Add devicetree scanning for randomness
References: <1392168805-14200-1-git-send-email-lauraa@codeaurora.org> <201402121251.06280.arnd@arndb.de>
In-Reply-To: <201402121251.06280.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/12/2014 3:51 AM, Arnd Bergmann wrote:
> On Wednesday 12 February 2014, Laura Abbott wrote:
>> This is an RFC to seed the random number pool earlier when using devicetree.
>> The big issue this is trying to solve is the fact that the stack canary for
>> ARM tends to be the same across bootups of the same device. This is because
>> the random number pools do not get initialized until after the canary has
>> been set up. The canary can be moved later, but in general there is still
>> no way to reliably get random numbers early for other features (e.g. vector
>> randomization).
>
> Implementation-wise this looks reasonable, and it obviously addresses a
> very real problem.
>
>> The goal here is to allow devices to add to the random pools via
>> add_device_randomness or some other method of their chosing at FDT time.
>> I realize that ARCH_RANDOM is already available but this didn't work because
>> 1) ARCH_RANDOM is not multi-platform compatible without added
>> infrastructure to ARM
>
> That could certainly be done, but I agree that a more generic
> approach like you did is nicer. One thing that might be useful
> would be to wire up your OF_RANDOM infrastructure as a generic
> implementation of ARCH_RANDOM, and merge your header file into
> include/asm-generic/archrandom.h, with an added way to call
> arch_get_random_long() for the devices you add.
>

I originally tried that approach but ran into some hiccups related to 
mapping for access to the HWRNG. early_ioremap would be needed to access 
hardware registers but on ARM early_ioremap does not persist across 
paging init. I couldn't come up with a sufficiently not terrible way to 
unmap the early mapping and re-map with a proper ioremap.

>> The big reason to skip ARCH_RANDOM though is that the random number generation
>> we have would be reasonable if only seeded earlier.
>
> Yes, makes sense.
>
> I also wonder if we should add a 'trivial' implementation that just
> reads a DT property full of random numbers to use as either an initial
> seed, or to feed into arch_get_random_long(). This would allow the
> boot loader to pass any entropy it has already gathered into the kernel,
> but leaves the danger that people might pass static not-so-random data
> through a precompiled dtb file ;-). If we get the boot loaders to be
> smart enough, doing only this would be a much simpler kernel implementation
> than your suggestion, but I'm not sure how far I want to trust boot loaders.
>

This was similar to an option discussed internally (passing a seed on 
the command line). Ultimately, it was concluded that relying on the 
bootloader to do this would be too much overhead vs. doing all the work 
in the kernel.

> Another possibilitiy is to mix in the any contents of a "local-mac-address"
> property into the entropy at early DT probing, which would still be
> deterministic for a given machine and should not count as entropty,
> but at least give each machine with this property a unique seed in the
> absence of any other entropy source.

Is this typically updated by the bootloader as well? I'm looking at the 
tree and most of the instances of local-mac-address I see are all zero.

>
> 	Arnd

Thanks,
Laura


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
