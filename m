Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbaKUVEJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 16:04:09 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:64502 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbaKUVEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 16:04:05 -0500
MIME-Version: 1.0
In-Reply-To: <CAD=FV=Ve1TY4+8quq1=18A1YOFvOWuFGrBmHLwMCwdWBSqzxOw@mail.gmail.com>
References: <1415109789-7046-1-git-send-email-addy.ke@rock-chips.com>
	<1415678573-6093-1-git-send-email-addy.ke@rock-chips.com>
	<CAPDyKFqUoBjhsbz8rkLa9PY_dpgMxnimz3k7OoA5WVhi7MacPQ@mail.gmail.com>
	<CAD=FV=VQHZ6YmcoeAb1OEVLYRrYBnc_dM5Kjt1TZX_CQJC=EfA@mail.gmail.com>
	<5464152E.7040209@rock-chips.com>
	<CAPDyKFrzGfDew0eLLEcA+_iS_mo-O2bFU58fjirfXXA8AJ9UYQ@mail.gmail.com>
	<CAD=FV=Ve1TY4+8quq1=18A1YOFvOWuFGrBmHLwMCwdWBSqzxOw@mail.gmail.com>
Date: Fri, 21 Nov 2014 13:04:03 -0800
X-Google-Sender-Auth: DAOmmjM-OwCi3emHKEVT01oi3Oc
Message-ID: <CAD=FV=UJT5zBkcj2a03Y_RWxad9+Pu83G_z79Xzzn74V=eRqww@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: try pick the exact same voltage as vmmc for vqmmc
From: Doug Anderson <dianders@chromium.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: addy ke <addy.ke@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "tgih.jun@samsung.com" <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <chris@printf.net>,
        Dinh Nguyen <dinguyen@altera.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Alexandru Stan <amstan@chromium.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "zhenfu.fang" <zhenfu.fang@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, lintao <lintao@rock-chips.com>,
        chenfen <chenfen@rock-chips.com>, zyf <zyf@rock-chips.com>,
        Jianqun Xu <xjq@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Chris Zhong <zyw@rock-chips.com>,
        =?UTF-8?B?5aea5pm65oOF?= <yzq@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Kever Yang <kever.yang@rock-chips.com>,
        zhangqing <zhangqing@rock-chips.com>, Lin Huang <hl@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Nov 21, 2014 at 9:42 AM, Doug Anderson <dianders@chromium.org> wrote:
> Ulf,
>
> On Fri, Nov 21, 2014 at 4:06 AM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
>> [...]
>>
>>> Sure
>>> If the first card is sd2.0 since startup, dw_mci_switch_voltage will not be called,
>>
>> That can't be right. mmc_power_up() should trigger
>> dw_mci_switch_voltage() to be invoked.
>
> Hmmm, I think you're right.  Addy: can you double check if it's only
> the 2nd card for you?  I was thinking that if a regulator is currently
> 3.3V and you request 2.7 - 3.3V the regulator framework will treat
> that as a noop.  ...but that definitely doesn't appear to be the case.
> When I boot up the first time even with no SD card plugged in, I see
> this at bootup:
>
> [    3.042234] vccio_sd: 1800 <--> 3300 mV at 3300 mV
>
> ...showing that it started at 3.3V.  Then I see:
>
> $ grep "" /sys/class/regulator/regulator.16/{name,microvolts}
> /sys/class/regulator/regulator.16/name:vccio_sd
> /sys/class/regulator/regulator.16/microvolts:2700000
>
> ...so it is certainly getting changed even with no card plugged in.
>
>
> BTW: I don't actually have one of these failing cards--all of mine
> work.  Addy, do you know the make and model of the card you have that
> fails?

Just as a bit of a followup, I did some more digging...

1. It looks as if we now have a bit of "opposite" logic for vmmc vs.
vqmmc.  In mmc_power_up() I see that it sets the initial voltage as:

  host->ios.vdd = fls(ocr) - 1;

That actually means that we're going to pick the maximum voltage for
vmmc (of the supported voltages).  For vqmmc dw_mmc is using the
regulator framework which (as described in my previous message) will
pick the minimum.

2. Several people I've talked to have expressed concerns that our
minimum value is 2.7V.  Apparently that's really on the edge and makes
EEs a little nervous.  The quick sample of cards sitting on my desk
shows that they seem to claim 0x00ff8000, which doesn't include 2.7V.


Both of the above make me feel like dw_mmc should try its best to pick
a value for vqmmc that is closest to the value of vmmc (and >= 2.7V).
That also happens to make us work exactly like hosts where vmmc and
vqmmc are supplied by the same supply.


-Doug
