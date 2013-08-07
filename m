Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab3HGRJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 13:09:19 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46883 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab3HGRJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 13:09:18 -0400
Message-ID: <52027F39.5050805@wwwdotorg.org>
Date: Wed, 07 Aug 2013 11:09:13 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Sonic Zhang <sonic.adi@gmail.com>, Axel Lin <axel.lin@ingics.com>,
        Grant Likely <grant.likely@linaro.org>,
        Steven Miao <realmz6@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        buildroot-devel@blackfin.uclinux.org,
        adi-buildroot-devel@lists.sourceforge.net,
        Sonic Zhang <sonic.zhang@analog.com>
Subject: Re: [PATCH] pinctrl: pinmux: Don't free pins requested by other devices
References: <1374039105-17777-1-git-send-email-sonic.adi@gmail.com> <CACRpkdZMCO9Cw=SMk4cq8k0+eqYrK=kKsjfAHut1=PXjxS_6jA@mail.gmail.com>
In-Reply-To: <CACRpkdZMCO9Cw=SMk4cq8k0+eqYrK=kKsjfAHut1=PXjxS_6jA@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 10:23 AM, Linus Walleij wrote:
> On Wed, Jul 17, 2013 at 7:31 AM, Sonic Zhang <sonic.adi@gmail.com> wrote:
> 
> I'd like Stephen and Axel to have a look at this as well...
> 
>> From: Sonic Zhang <sonic.zhang@analog.com>
>>
>> in pinmux_disable_setting after current device fails to request
>> the same pins.
>>
>> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> 
> I don't quite understand the patch. Can you provide more context?

Yes, the commit description needs to describe the problem this solves.

I'm *guessing* the issue is:

Something tries to enable a new mux setting on some pins. One of those
pins is already owned by something else. So, applying the current
setting fails. So, pinctrl core attempts to unapply the partially
applied setting. This ends up incorrectly over-writing the conflicting
ownership of the pins with NULL, and hence forgetting about it.

I think a better change would be something more along the lines of:

  for (i = 0; i < num_pins; i++)
+ 	if (this_device_owns_pin(pins[i])
  		pin_free(pctldev, pins[i], NULL);

?

Where this_device_owns_pin() might be someting like:

	desc->owning_setting == setting

(which would be a new field that needed to be assigned during
pinmux_enable_setting).

Or perhaps the strcmp() is fine.

>> diff --git a/drivers/pinctrl/pinmux.c b/drivers/pinctrl/pinmux.c
>> index 88cc509..9ebcf3b 100644
>> --- a/drivers/pinctrl/pinmux.c
>> +++ b/drivers/pinctrl/pinmux.c
>> @@ -482,13 +482,14 @@ void pinmux_disable_setting(struct pinctrl_setting const *setting)
>>                                  pins[i]);
>>                         continue;
>>                 }
>> +               /* And release the pins */
>> +               if (desc->mux_usecount &&
>> +                       !strcmp(desc->mux_owner, setting->dev_name))
>> +                       pin_free(pctldev, pins[i], NULL);
>> +
>>                 desc->mux_setting = NULL;
>>         }
>>
>> -       /* And release the pins */
>> -       for (i = 0; i < num_pins; i++)
>> -               pin_free(pctldev, pins[i], NULL);
>> -
> 
> For pinmux_disable_setting() to inspect desc->mux_usecount seems
> assymetric. This is something pin_free() should do, shouldn't it?
> 
> Should not this codepath be kept and a change made inside pin_free()
> for the check above instead?

