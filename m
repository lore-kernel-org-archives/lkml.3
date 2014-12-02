Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748AbaLBGFn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 01:05:43 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.216]:40512 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141AbaLBGFm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 01:05:42 -0500
X-RZG-AUTH: :JGIXVUS7cutRB/49FwqZ7WcKdUCnXG6JabOfSXKWrat/gNPvz+GM
X-RZG-CLASS-ID: mo00
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [Gta04-owner] [PATCH 1/2] mmc: core: allow a reset gpio to be configured.
From: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20141202125539.42f22074@notabene.brown>
Date: Tue, 2 Dec 2014 07:05:24 +0100
Cc: Ulf Hansson <ulf.hansson@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        Doug Anderson <dianders@chromium.org>, Chris Ball <chris@printf.net>,
        Mark Brown <broonie@kernel.org>, Olof Johansson <olof@lixom.net>
Content-Transfer-Encoding: 8BIT
Message-Id: <C98E0E67-23ED-4A4F-A90C-9BEEC6921544@goldelico.com>
References: <20141108000919.5629.55381.stgit@notabene.brown> <20141108001411.5629.25179.stgit@notabene.brown> <CAPDyKFrx98NspRU1nV3uJ6XwTuA4tZQkrYTfDoeXGR+f5htODQ@mail.gmail.com> <20141202125539.42f22074@notabene.brown>
To: List for communicating with real GTA04 owners 
	<gta04-owner@goldelico.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

Am 02.12.2014 um 02:55 schrieb NeilBrown <neilb@suse.de>:

> On Fri, 28 Nov 2014 12:56:33 +0100 Ulf Hansson <ulf.hansson@linaro.org> wrote:
> 
>> On 8 November 2014 at 01:14, NeilBrown <neilb@suse.de> wrote:
>>> If the regulator supplying an SDIO device is shared
>>> with another device, the turning the regulator 'on' and 'off'
>>> will not actually cycle power and so will not reset
>>> the device.
>>> 
>>> This is particularly a problem for some wi2si wireless modules which
>>> have a BT module on chip and can share power lines.
>>> Without the power-cycle, subsequent reset commands fail.
>>> 
>>> So allow a 'reset' gpio to be specified.  If provided, the
>>> line is asserted during power-up.
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

Indeed.

> 
> So the *fix* is to allow attached devices to be explicitly listed.
> In my case I would create a child node of the mmc1 node, which is
> compatible=“libertas,wifi" (or whatever the proper name is).

Sounds like a good idea to me.

> 
> Then when the mmc1 wants to power-up, it does:
> 
>   device_for_each_child(mmc_dev, NULL, power_up)
> 
> where:
> 
> static int power_up(struct device *dev, void *data)
> {
>       pm_runtime_get_sync(dev);
>       return 0;
> }
> 
> Then I can put my reset-line management in the libertas driver instead of
> trying to include some of it in the mmc driver.
> 
> This has the advantage of the devicetree actually describing the hardware
> (there is a libertas wifi SDIO chip attached) rather than the behaviour
> (please turn on this regulator and toggle this GPIO to initialise the device).
> 
> I want to do a very similar thing for UARTs (so my GPS and Bluetooth turn on
> when /dev/ttyO? is opened), and I've been thinking about something similar
> for USB - I have a USB attached GSM module, but it also has an Audio link and
> some reset/interrupt lines that need to be configured.
> If I could say to device tree "This USB port has this device attached", I
> think it would be a step in the right direction.

Thinking a little further, it could either be the core driver of the device/bus/protocol
or a special driver that only does power management. Or audio.

And we should consider using a list of strings in the compatible entry so that
several drivers can be loaded if the subsystem structure shows that this is simpler.

It could be one for power, one for audio. Or in the case of the libertas a separate
power&reset driver for a specific chip that uses the libertas driver so that chip
specific reset management is not introduced into the libertas core but separate.

For the usb connected modem the subnode to be attached is likely the PHY
where the self-powered device is connected to.

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
> 
>> 
>> Regarding this patch, I don't intent to apply it.
> 
> Fair enough, I’m starting to not like it so much anyway.
> 

BR,
Nikolaus

