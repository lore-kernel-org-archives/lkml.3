Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbaIJXNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 19:13:00 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:45194 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbaIJXM6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 19:12:58 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Heiko =?utf-8?Q?St=C3=BCbner?= <heiko@sntech.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Mark Brown <broonie@kernel.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Addy Ke <addy.ke@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree\@vger.kernel.org" <devicetree@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Andy Gross <agross@codeaurora.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sandeep Nair <sandeep_n@ti.com>, Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Thierry Reding <treding@nvidia.com>, Nishanth Menon <nm@ti.com>
Subject: Re: [PATCH 0/2] IO voltage domain support for rk3188 and rk3288
References: <1409254565-10677-1-git-send-email-dianders@chromium.org>
	<53FF9E93.3040601@ti.com>
	<CAD=FV=Vcj+tAno92c38Prviyi-v2CmuGSzak1ppETL033KAF4w@mail.gmail.com>
	<1450179.xJuMFg9Vvn@diego>
	<CACRpkda-XS0XLSkAZ-16=JvD8FbRJNuN4UVL4dMyV71bfU5T2A@mail.gmail.com>
Date: Wed, 10 Sep 2014 16:12:55 -0700
In-Reply-To: <CACRpkda-XS0XLSkAZ-16=JvD8FbRJNuN4UVL4dMyV71bfU5T2A@mail.gmail.com>
	(Linus Walleij's message of "Thu, 4 Sep 2014 18:51:47 +0200")
Message-ID: <7hlhprqdc8.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij <linus.walleij@linaro.org> writes:

> On Sat, Aug 30, 2014 at 1:27 PM, Heiko Stübner <heiko@sntech.de> wrote:
>> Am Freitag, 29. August 2014, 21:51:46 schrieb Doug Anderson:
>>> On Thu, Aug 28, 2014 at 2:26 PM, Santosh Shilimkar
>>>
>>> <santosh.shilimkar@ti.com> wrote:
>>> > On Thursday 28 August 2014 03:36 PM, Doug Anderson wrote:
>>> >> These two patches add support for automatically configuring the IO
>>> >> voltage domains on rk3188 and rk3288 SoCs.  The first patch adds some
>>> >> new notification types to the regulator code.  It's used by the second
>>> >> patch which actually implements the IO voltage domain driver.
>>> >>
>>> >> These two patches were co-developed by Heiko Stübner and Doug Anderson
>>> >> (proof of concept patches were written by Heiko).  They were tested in
>>> >> a private branch on an rk3288 board using rk808 instead of mainline
>>> >> since rk808 support isn't finalized in mainline yet.
>>> >>
>>> >> (sorry if you got this series twice; my mailer seems unhappy with me)
>>> >>
>>> >> Heiko Stübner (2):
>>> >>   regulator: core: Add REGULATOR_EVENT_PRE_VOLTAGE_CHANGE (and ABORT)
>>> >>   soc/rockchip: io-domain: add driver handling io domains
>>> >
>>> > Sorry to shot down but your IO domains are nothing but voltage domains
>>> > and you should really build something in the drivers/power/*
>>>
>>> If everyone agrees that this belongs in drivers/power that's totally
>>> OK.  Neither Heiko nor I was confident that it should be in
>>> drivers/soc.  I had even though that the code wouldn't be totally out
>>> of place in the Rockchip pinctrl driver (adding Linus W since I think
>>> some SoCs did add code to handle 3.3V vs. 1.8V in pinctrl).
>>
>> a bit of context for Linus ...
>>
>> This is essentially the continuation of  the thread "io-domain voltages as
>> regulators?" from the beginning of august. After more discussions we found out
>> that the io voltage selection I asked about is not an independent supply, but
>> instead has to reflect the voltage of the real supplying regulator.
>>
>> And setting the io-voltage setting to 1.8V while the regulator is supplying
>> 3.3V for example may actually damage the chip.
>>
>>
>> So in our current approach here, we added a driver that tracks voltage changes
>> of the supplying regulator via a notifier and sets the register bits
>> accordingly.
>
> I feel I'm not smart enough for this. You need the PM people to look
> at this stuff, like Rafael Wysocki, Kevin Hilman and Ulf Hansson.

I think the best fit for this is along with the Adaptive Voltage Scaling
(AVS) stuff we currently have in drivers/power/avs.  It's not exactly
adaptive in the same sense as the TI/SmartReflex is because there's no
hardware being configured to dynamically make micro-adjustments to the
regulators.  But, it is adaptive in the sense that there's SoC-specific
"stuff" to do right around the same time the voltage is scaled.

So I would suggest drivers/power/avs.

Kevin









