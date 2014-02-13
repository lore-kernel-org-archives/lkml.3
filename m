Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbaBMQlK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 11:41:10 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:63175 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbaBMQlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 11:41:08 -0500
Message-ID: <52FCF59E.3090100@gmail.com>
Date: Thu, 13 Feb 2014 17:41:02 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/13] pinctrl: mvebu: restructure resource allocation
References: <1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com> <1392220776-30851-1-git-send-email-sebastian.hesselbarth@gmail.com> <20140213172620.76e760ba@skate>
In-Reply-To: <20140213172620.76e760ba@skate>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/14 17:26, Thomas Petazzoni wrote:
> Thanks again for working on this! I have boot tested this successfully
> on an Armada XP platform, and it seems to behave normally, the debugfs
> pinctrl contents make sense.

I guess this is a Tested-by ?

> I have a few comments below, though.
>
> On Wed, 12 Feb 2014 16:59:23 +0100, Sebastian Hesselbarth wrote:
>
>> Also, in the meantime, pinctrl driver stubs for new Armada 375/28x have
>> been posted [3]. Before any of this patches move to a stable branch, I
>> plan to send an updated version comprising the required patches for the
>> new SoCs. As the new driver stubs are very much like what we already have
>> for Armada 370/XP, let's only discuss the general approach now and add
>> the branch dependency and patches later.
>
> I am not sure what you mean here in terms of the ordering for the
> patches. I'm attaching several patches, and the first three patches
> adapt your patch series to also cover 375 and 38x, assuming the pinctrl
> support for 375 and 38x is merged before your patch series.

Right. If 375/38x pinctrl goes in first (what I expect), I'd have to add
corresponding patches. You already sent them, I'll pick them up.

> With these patches, I have
>
>> Patches 1-3 first deal with the way we handle unnamed "generic" mpp
>> controls. Patch 1 consolidates the per-control allocation of name buffers
>> to counting unnamed controls first and then allocate a global name buffer
>> for all those controls. Patch 2 then removes the now obsolete per-control
>> allocation of name buffers. Patch 3 then makes the common driver to
>> identify "generic" mpp controls by an empty name and adds some valuable
>> comments about that special treatment.
>
> I must say I dislike quite a bit this unnamed mpp controls mechanism.
> Why isn't the name statically defined in the source code by the
> MPP_MODE macro, which already takes as first argument the pin number?

Honestly, the unnamed mpp control thing is a bit odd. But if you tell
me how to create ~60 statically defined one pin groups out of a
single-line macro, we can change that easily.

Back when that unnamed mpp control thing was invented, I must have been
to lazy to write e.g.

MPP_FUNC_CTRL(0, 0, "mpp0", armada_xp_mpp_ctrl),
MPP_FUNC_CTRL(1, 1, "mpp1", armada_xp_mpp_ctrl),
MPP_FUNC_CTRL(2, 2, "mpp2", armada_xp_mpp_ctrl),
...
MPP_FUNC_CTRL(66, 66, "mpp66", armada_xp_mpp_ctrl),

instead of

MPP_FUNC_CTRL(0, 66, NULL, armada_xp_mpp_ctrl),

and generate the 66 names dynamically.

> All the calculation of the buffer size, generating the names and so on,
> looks like a lot of unnecessary code to me. But well, this unnamed
> thing was already here, so I'm not saying your patch series should do
> anything about it.

If you come up with a cool idea, we can shove it in now.

>> Patch 4 removes passing struct mvebu_mpp_ctrl to the special callback
>> as the only relevant information in that struct for the callback is the
>> pin number which is passed directly instead.
>>
>> Patches 5-9 then add some global defines and provide SoC specific
>> callbacks even for the "generic" mpp controls. This allows Patch 10 to
>> move resource allocation to SoC specific drivers and remove the common
>> generic callbacks in Patch 11.
>
> This is definitely good, but I'm wondering why the core cannot provide
> helper functions for the generic case where we have 4 bits per pin in
> contiguous registers. This would avoid duplicating the helper function
> six times (you have four in your patch series, and we'll need two more
> for A375 and A38x).

I thought about it too, but we would need a soc specific callback
anyway as you'll have to pass the base address somehow (and that is now
known by soc specific stub only). My quick rule of thumb was that the
amount of code replication would be almost the same.

> I've also attached other patches:
>
>   * One patch that fixes your Armada XP handling, which missed the
>     mv78230 and mv78260 cases (PATCH 4)
>
>   * One patch that removes MPP_REG_CTRL (PATCH 5)
>
>   * One patch that adjusts a comment in the code that was no longer true
>     (PATCH 6)
>
> Feel free to squash these patches into the appropriate patches.

Yep, thanks for these! I'll squash them in and send an updated v4 as
soon as the discussion here stalls.

Sebastian

