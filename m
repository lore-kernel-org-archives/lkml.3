Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965153AbaH0Ulv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 16:41:51 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:59192 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964892AbaH0Ult (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 16:41:49 -0400
Message-ID: <53FE4286.3050305@gmail.com>
Date: Wed, 27 Aug 2014 22:41:42 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] regulator: max77802: set opmode to normal if off
 is read from hw
References: <1409053061-22568-1-git-send-email-javier.martinez@collabora.co.uk> <53FE2446.3040402@gmail.com> <20140827183733.GN17528@sirena.org.uk> <53FE25EB.7060702@gmail.com> <20140827184705.GO17528@sirena.org.uk> <53FE2901.50508@gmail.com> <20140827191526.GS17528@sirena.org.uk> <53FE2F9E.80501@gmail.com> <20140827194411.GU17528@sirena.org.uk> <53FE387F.3030302@gmail.com> <20140827202554.GW17528@sirena.org.uk>
In-Reply-To: <20140827202554.GW17528@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.08.2014 22:25, Mark Brown wrote:
> On Wed, Aug 27, 2014 at 09:58:55PM +0200, Tomasz Figa wrote:
>> On 27.08.2014 21:44, Mark Brown wrote:
> 
>>> The point is that if anything was setting the mode to something other
>>> than normal it was almost certainly a previously running copy of Linux
>>> and one would expect that if the mode does need to be changed the new
>>> copy will be doing that anyway.  It's rare enough to need to actively
>>> manage modes in the first place.
> 
>> From what I know based on my experience with Samsung boards we used, the
>> opmodes of regulators are preconfigured by board bootloader to certain
>> values based on power design of the board (i.e. there is no need to keep
>> a regulator in full power mode, if on given board only a little fraction
>> of it is needed).
> 
> Well, presumably the bootloader is going to run again even for a warm
> reboot?

This is strange, but apparently it's not the case for the hardware which
this patch is supposed to fix or at least this is how I understood it.

> 
>> Now Linux should not change this mode (excluding cases when the values
>> in the bootloader are wrong - they happen unfortunately), so I'm not
>> getting why you say that it is Linux which changes the mode to something
>> other than normal. Linux should only toggle between the value resulting
>> from power design and off.
> 
> It's not in general true that Linux should never change the mode (the
> main case for toggling modes is usually going between an idle/suspend
> state and active state)

I believe this is yet another reason why we should have a way to specify
opmodes in DT, now not only active but also suspend/idle opmodes.

However on many PMICs this is a bit more complicated. There are opmodes
such as

1) Regulator powered off.
2) Regulator powered off if certain pin is active, regulator powered
   on otherwise.
3) Regulator powered on.

some of them might also have more interesting combinations, e.g.

4) Regulator powered off if certain pin is active, regulator powered on
   in low power mode otherwise.
5) Regulator powered on in lower power mode if certain pin is active,
   regulator powered on in full power mode otherwise.

They all go to the same opmode field, as "off", "low power", "normal"
mentioned earlier in this thread.

> and for practical purposes bootloader and
> hardware defaults tend to be the same.

Not on the boards I worked with. At least when it's just about the
difference between normal and low power modes. I believe the hardware
will always default to normal just to be safe, so to optimize power on
the board, the bootloader will switch those which don't need full power
to low power mode.

I believe we shouldn't even rely on the bootloader here, as we all know
that often all you can expect from them is to load and jump to your
kernel and even some of them can't do this properly...

> You're talking about the case
> where the bootloader does set something but avoids doing so on warm
> reboots only here.

>From Javier's description I understood this is the case for the board
for which he develops.

> 
> Besides, even if we did have a way of specifying modes in DT (with all
> the problems that brings) we still have to pick a default if that's not
> used).

Sure we do and we can define the binding to default to something (e.g.
normal mode) if respective property is not present. Btw. the issue with
opmode also affects other PMIC chips such as Samsung S5M ones.

Best regards,
Tomasz
