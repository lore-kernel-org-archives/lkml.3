Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab3EYJJ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 05:09:57 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:41801 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372Ab3EYJJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 05:09:55 -0400
MIME-Version: 1.0
In-Reply-To: <519F8B02.1080000@wwwdotorg.org>
References: <1368690525-32252-1-git-send-email-linus.walleij@stericsson.com>
	<519A8A57.9060007@wwwdotorg.org>
	<CACRpkdZieCmFnHCGUkv8EqcAtb3DA7dSZpimSdB4P81tZPJRoQ@mail.gmail.com>
	<519F8B02.1080000@wwwdotorg.org>
Date: Sat, 25 May 2013 11:09:54 +0200
Message-ID: <CACRpkdYxvBvYAnmp-p5WwB3QD0rd83qDcdg-BMhN7-2Jv8Oo_w@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: sink pinctrldev_list_mutex
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: ext Tony Lindgren <tony@atomide.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 24, 2013 at 5:45 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 05/24/2013 02:04 AM, Linus Walleij wrote:

>> Prevention of module unloading of pin controllers has never
>> been working properly, as there is no way to release the
>> pinctrl handles taken by different drivers.
>>
>> I think that is why most pin controller drivers are bool rather
>> than tristate.
>
> Once we get to multi-platform distro kernels, we will probably want all
> the pinctrl drivers to be modules so only the correct one gets loaded
> from an initrd. Hence, we'll want to move things to tristate rather than
> away from it.

OK ... As some kind of excuse I think the current situation is an
outgrowth of the fact that all the custom set-up used to be in machines
down in arch/arm/* and inevitably done at machine init.

> If we know the pinctrl subsystem doesn't yet work correctly with module
> unloads, should we modify pinctrl_register() to simply take a lock on
> the driver module and never drop it, so that we guarantee we don't try
> to unload the module later? Or, is this effectively already in place?

Hm, it won't happen with anything but pinctrl-single for sure.
But I know that Tony used it at one point, however I still
suspect that he was only using hogs.

We should maybe take the lock at the instant we instatiate a
pinctrl handle from something else than a hog, so as to mark
that we then have external dependencies that make unloading
impossible.

But it'd be even cooler to actually just iterate over the
pinctrl_list och handles and orphan them, and later recouple
them if a driver is loaded back in.

It can surely be done, but at the cost of introducing a state
lock in struct pinctrl and some pieces of hairy code in the
core.

Yours,
Linus Walleij
