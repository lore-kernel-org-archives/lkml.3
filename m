Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679Ab3HHDiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 23:38:12 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:40533 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab3HHDiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 23:38:10 -0400
MIME-Version: 1.0
In-Reply-To: <52027F39.5050805@wwwdotorg.org>
References: <1374039105-17777-1-git-send-email-sonic.adi@gmail.com>
	<CACRpkdZMCO9Cw=SMk4cq8k0+eqYrK=kKsjfAHut1=PXjxS_6jA@mail.gmail.com>
	<52027F39.5050805@wwwdotorg.org>
Date: Thu, 8 Aug 2013 11:38:08 +0800
Message-ID: <CAJxxZ0OaXH1QTuwoHs0zHxhL8CXNRmpo2zZ+SQJB+z_7U8MLrQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: pinmux: Don't free pins requested by other devices
From: Sonic Zhang <sonic.adi@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Axel Lin <axel.lin@ingics.com>,
        Grant Likely <grant.likely@linaro.org>,
        Steven Miao <realmz6@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        "buildroot-devel@blackfin.uclinux.org" 
	<buildroot-devel@blackfin.uclinux.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, Aug 8, 2013 at 1:09 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 08/07/2013 10:23 AM, Linus Walleij wrote:
>> On Wed, Jul 17, 2013 at 7:31 AM, Sonic Zhang <sonic.adi@gmail.com> wrote:
>>
>> I'd like Stephen and Axel to have a look at this as well...
>>
>>> From: Sonic Zhang <sonic.zhang@analog.com>
>>>
>>> in pinmux_disable_setting after current device fails to request
>>> the same pins.
>>>
>>> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
>>
>> I don't quite understand the patch. Can you provide more context?
>
> Yes, the commit description needs to describe the problem this solves.
>
> I'm *guessing* the issue is:
>
> Something tries to enable a new mux setting on some pins. One of those
> pins is already owned by something else. So, applying the current
> setting fails. So, pinctrl core attempts to unapply the partially
> applied setting. This ends up incorrectly over-writing the conflicting
> ownership of the pins with NULL, and hence forgetting about it.
>
> I think a better change would be something more along the lines of:
>
>   for (i = 0; i < num_pins; i++)
> +       if (this_device_owns_pin(pins[i])
>                 pin_free(pctldev, pins[i], NULL);
>
> ?
>
> Where this_device_owns_pin() might be someting like:
>
>         desc->owning_setting == setting
>
> (which would be a new field that needed to be assigned during
> pinmux_enable_setting).
>
> Or perhaps the strcmp() is fine.
>

You are right. One peripheral may share part of its pins with the 2nd
peripheral and the other pins with the 3rd. If it requests all pins
when part of them has already be requested and owned by the 2nd
peripheral, this request fails and pinmux_disable_setting() is called.
The pinmux_disable_setting() frees all pins of the first peripheral
without checking if the pin is owned by itself or the 2nd, which
results in the malfunction of the 2nd peripheral driver.

I am fine to compare owner's pinctrl_setting structure other than name string.

Regards,

Sonic
