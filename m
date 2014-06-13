Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbaFMWuM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 18:50:12 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:44505 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797AbaFMWuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 18:50:08 -0400
MIME-Version: 1.0
In-Reply-To: <20140613220421.GD5099@sirena.org.uk>
References: <1402464739-19044-1-git-send-email-tushar.b@samsung.com>
	<1402464739-19044-4-git-send-email-tushar.b@samsung.com>
	<CAD=FV=XqqP7+xDOAKCixivzgaO0xvJX7L+CCN+unAEuf-6aUbQ@mail.gmail.com>
	<20140613170511.GA20112@sirena.org.uk>
	<CAD=FV=VvkvH1TPiKttm9VXbBRnBo7kmTVK8bZZvexK=bAvaO4Q@mail.gmail.com>
	<CAD=FV=XCk9E-7VPV=LQrdLU5fKsFHviQf79MBmC8va3gsg=Ydw@mail.gmail.com>
	<20140613220421.GD5099@sirena.org.uk>
Date: Fri, 13 Jun 2014 15:50:07 -0700
Message-ID: <CAD=FV=U06JioDvvSqHyC5BZp_sKppk4i=s7DERCXG7rGHBe=xQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] ARM: dts: Enable audio support for Peach-pi board
From: Doug Anderson <dianders@google.com>
To: Mark Brown <broonie@kernel.org>
Cc: Tushar Behera <tushar.b@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Kevin Hilman <khilman@linaro.org>, Tushar Behera <trblinux@gmail.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark,

On Fri, Jun 13, 2014 at 3:04 PM, Mark Brown <broonie@kernel.org> wrote:
> On Fri, Jun 13, 2014 at 02:58:26PM -0700, Doug Anderson wrote:
>
>> Anyway, suffice to say that the i2c core needs to be extended to
>> handle the idea that a single device has more than one "compatible"
>> string.  I'll leave it to an eager reader of this thread to implement
>> this since we can also fix our own problem by just listing "max98091"
>> in "sound/soc/codecs/max98090.c" like has always been done in the
>> past.
>
> Why do you need to register multiple compatible strings (I guess for
> fallback purposes?).

I'm no expert, but I think that's part of device tree isn't it?

In the case of max98090 and max98091, they are incredibly similar
pieces of hardware (I think the max98091 simply has more microphones).
If you've got a driver for a max98090 it will work just fine for a
max98091 but you just won't get the extra microphones.

In cases like this then device tree theory says that you should list
both compatible strings: max98091 and max98090, right?  If your OS has
a driver for max98091 it will use it.  ...if it doesn't but it has a
max98090 driver it will try that one.

As far as I understand we _shouldn't_ lie and just say that we have a
max98090 when we really have a max98091.  The device tree is supposed
to describe the hardware and isn't support to care that the OS has a
driver for max98090 but not max98091.

Ironically in our case we have a driver that supports both the 98090
and the 98091 via autodetect.  However, it doesn't know about the
98091 compatible string so if you list yourself as compatible with
98091 then it won't find the driver.

> A quick fix that is about as good is to take the
> first compatible only.

That's how the code works today, actually.  ...but as per above the
current 98090 driver doesn't know about the 98091 compatible string,
so:

compatible = "maxim,max98091", "maxim,max98090";

...won't find the right driver.

--

The quick fix is to add max98091 to the max98090 driver and is what
I'd suggest in this case.  ...but I still think that the above logic
is valid and eventually the i2c core should be fixed.  Please correct
me if I'm wrong.

-Doug
