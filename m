Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbaFMV6a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 17:58:30 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:44292 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbaFMV61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 17:58:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=FV=VvkvH1TPiKttm9VXbBRnBo7kmTVK8bZZvexK=bAvaO4Q@mail.gmail.com>
References: <1402464739-19044-1-git-send-email-tushar.b@samsung.com>
	<1402464739-19044-4-git-send-email-tushar.b@samsung.com>
	<CAD=FV=XqqP7+xDOAKCixivzgaO0xvJX7L+CCN+unAEuf-6aUbQ@mail.gmail.com>
	<20140613170511.GA20112@sirena.org.uk>
	<CAD=FV=VvkvH1TPiKttm9VXbBRnBo7kmTVK8bZZvexK=bAvaO4Q@mail.gmail.com>
Date: Fri, 13 Jun 2014 14:58:26 -0700
Message-ID: <CAD=FV=XCk9E-7VPV=LQrdLU5fKsFHviQf79MBmC8va3gsg=Ydw@mail.gmail.com>
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

On Fri, Jun 13, 2014 at 10:13 AM, Doug Anderson <dianders@google.com> wrote:
> Mark,
>
> On Fri, Jun 13, 2014 at 10:05 AM, Mark Brown <broonie@kernel.org> wrote:
>> On Fri, Jun 13, 2014 at 10:03:50AM -0700, Doug Anderson wrote:
>>> On Tue, Jun 10, 2014 at 10:32 PM, Tushar Behera <tushar.b@samsung.com> wrote:
>>
>>> > Peach-pi board has MAX98090 audio codec connected on HSI2C-7 bus.
>>
>>> If you want to be a stickler about it, peach-pi actually has a
>>> max98091.  That requires code changes to the i2c driver, though.
>>> ...and unfortunately listing two compatible strings for i2c devices is
>>> broken.  :(
>>
>> It is?  We should fix that if it's the case...
>
> Yah, I mentioned it to Mark Rutland at the last ELC and he said he
> might take a look at it, but I probably should have posted something
> up to the i2c list.
>
> I made a half-assed attempt to fix it locally in the ChromeOS but
> quickly found that it was going to be a much bigger job than I had
> time for...
>
> https://chromium-review.googlesource.com/#/c/184406/
>
> IIRC i2c_new_device didn't return an error like I thought it would,
> probably trying to deal with the fact that devices might show up at a
> later point in time.
>
>
> Hrm, now that I think about it I wonder if the right answer is just to
> call i2c_new_device for all the compatible strings even if it doesn't
> return an error.  I'd have to go back and try that and re-explore this
> code...

Nope, that didn't work either.  Now I remember trying that before,
too.  It doesn't like you registering two different devices with the
same address:

[    2.582539] DOUG: /i2c@12CD0000/codec@10 (0) max98091
[    2.587360] DOUG: /i2c@12CD0000/codec@10 (0) max98091
[    2.591160] DOUG: /i2c@12CD0000/codec@10 (1) max98090
[    2.596686] i2c i2c-7: Failed to register i2c client max98090 at 0x10 (-16)

If you hack out the check for address business:

sysfs: cannot create duplicate filename '/devices/12cd0000.i2c/i2c-7/7-0010'

Anyway, suffice to say that the i2c core needs to be extended to
handle the idea that a single device has more than one "compatible"
string.  I'll leave it to an eager reader of this thread to implement
this since we can also fix our own problem by just listing "max98091"
in "sound/soc/codecs/max98090.c" like has always been done in the
past.


-Doug
