Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043AbaLBMLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 07:11:45 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:61777 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbaLBMLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 07:11:43 -0500
MIME-Version: 1.0
In-Reply-To: <20141202125539.42f22074@notabene.brown>
References: <20141108000919.5629.55381.stgit@notabene.brown>
	<20141108001411.5629.25179.stgit@notabene.brown>
	<CAPDyKFrx98NspRU1nV3uJ6XwTuA4tZQkrYTfDoeXGR+f5htODQ@mail.gmail.com>
	<20141202125539.42f22074@notabene.brown>
Date: Tue, 2 Dec 2014 13:11:42 +0100
Message-ID: <CAPDyKFozQrbcYm9KdbhjwmO+j+MQcGS3bDhkvb2WPkd-T21zcA@mail.gmail.com>
Subject: Re: [PATCH 1/2] mmc: core: allow a reset gpio to be configured.
From: Ulf Hansson <ulf.hansson@linaro.org>
To: NeilBrown <neilb@suse.de>
Cc: Chris Ball <chris@printf.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        GTA04 owners <gta04-owner@goldelico.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 December 2014 at 02:55, NeilBrown <neilb@suse.de> wrote:
> On Fri, 28 Nov 2014 12:56:33 +0100 Ulf Hansson <ulf.hansson@linaro.org> wrote:
>
>> On 8 November 2014 at 01:14, NeilBrown <neilb@suse.de> wrote:
>> > If the regulator supplying an SDIO device is shared
>> > with another device, the turning the regulator 'on' and 'off'
>> > will not actually cycle power and so will not reset
>> > the device.
>> >
>> > This is particularly a problem for some wi2si wireless modules which
>> > have a BT module on chip and can share power lines.
>> > Without the power-cycle, subsequent reset commands fail.
>> >
>> > So allow a 'reset' gpio to be specified.  If provided, the
>> > line is asserted during power-up.
>>
>> There have been several attempts to fix similar issues as this patch
>> does. The latest one I posted a few month ago, which wasn't accepted.
>> http://comments.gmane.org/gmane.linux.power-management.general/46635
>
> Thanks for that link.
>
>>
>> There has also been some off-list discussions on especially how we
>> should describe this in DT and there were actually some consensus made
>> around that. Still I haven't seen any patches on the mailing lists.
>
> Wish I could have a link for those off-list discussions :-)
>
> Based on what I read and my own thoughts about other devices that I'm having
> trouble managing I wonder if the right approach might be to admit that these
> buses are *not* 100% discoverable.
>
> i.e. you can discover what is there once it is turned on, but you cannot
> discover how to turn it on.
>
> So the *fix* is to allow attached devices to be explicitly listed.
> In my case I would create a child node of the mmc1 node, which is
> compatible="libertas,wifi" (or whatever the proper name is).
>
> Then when the mmc1 wants to power-up, it does:
>
>    device_for_each_child(mmc_dev, NULL, power_up)
>
> where:
>
> static int power_up(struct device *dev, void *data)
> {
>        pm_runtime_get_sync(dev);

No. We must not rely on runtime PM to be able to power up the device.

>        return 0;
> }
>
> Then I can put my reset-line management in the libertas driver instead of
> trying to include some of it in the mmc driver.

Well, "somewhere" we need to handle the different power up scenarios.
These scenarios should be considered as SOC specific, and if we could
keep that as a separate piece of code, that would be the best.

So, I agree that we shouldn't pollute mmc host drivers with such code,
but I also think SDIO func drivers should be remained untouched.

Instead, my plan is to let the mmc core handle it.

>
> This has the advantage of the devicetree actually describing the hardware
> (there is a libertas wifi SDIO chip attached) rather than the behaviour
> (please turn on this regulator and toggle this GPIO to initialise the device).

I think both ways are viable, since they are both describing the
hardware and the characteristics of it.

>
> I want to do a very similar thing for UARTs (so my GPS and Bluetooth turn on
> when /dev/ttyO? is opened), and I've been thinking about something similar
> for USB - I have a USB attached GSM module, but it also has an Audio link and
> some reset/interrupt lines that need to be configured.
> If I could say to device tree "This USB port has this device attached", I
> think it would be a step in the right direction.
>
>
>
>>
>> So to summarize, I am really concerned that we keep having these power
>> sequence issues for SDIO devices and right now the discussion has been
>> on hold. I am considering to hack on it myself, since I am tired of
>> waiting. :-)
>
> Please Cc me if you do.  Meanwhile I'll try to hack together code supporting
> my latest idea and let you know if I get anywhere.

Sounds good. I have started hacking on it as well, let's see where we end up.

Kind regards
Uffe
