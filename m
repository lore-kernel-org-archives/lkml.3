Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880AbaKYVUJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 16:20:09 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:40039 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303AbaKYVUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 16:20:07 -0500
MIME-Version: 1.0
In-Reply-To: <CAD=FV=U9Hh-OR2aGh6Q9YAwnP8AuAbQtogD=7wQxgg9XvoWTMw@mail.gmail.com>
References: <1415109789-7046-1-git-send-email-addy.ke@rock-chips.com>
 <1415678573-6093-1-git-send-email-addy.ke@rock-chips.com> <CAPDyKFqUoBjhsbz8rkLa9PY_dpgMxnimz3k7OoA5WVhi7MacPQ@mail.gmail.com>
 <CAD=FV=VQHZ6YmcoeAb1OEVLYRrYBnc_dM5Kjt1TZX_CQJC=EfA@mail.gmail.com>
 <5464152E.7040209@rock-chips.com> <CAPDyKFrzGfDew0eLLEcA+_iS_mo-O2bFU58fjirfXXA8AJ9UYQ@mail.gmail.com>
 <CAD=FV=Ve1TY4+8quq1=18A1YOFvOWuFGrBmHLwMCwdWBSqzxOw@mail.gmail.com>
 <CAD=FV=UJT5zBkcj2a03Y_RWxad9+Pu83G_z79Xzzn74V=eRqww@mail.gmail.com>
 <CAPDyKFqt4rrwi940KAPyPONpjixK1730QmHEsN27V97jyHH+Qw@mail.gmail.com>
 <5473EB8B.3000803@rock-chips.com> <CAD=FV=U9Hh-OR2aGh6Q9YAwnP8AuAbQtogD=7wQxgg9XvoWTMw@mail.gmail.com>
From: Alexandru Stan <amstan@chromium.org>
Date: Tue, 25 Nov 2014 13:11:43 -0800
Message-ID: <CAHNYxRwT8YeR-AUa-BVPraufLWZtEaeLdNjGBs77CfkMWVCNqg@mail.gmail.com>
Subject: Re: [PATCH] mmc: dw_mmc: try pick the exact same voltage as vmmc for vqmmc
To: Doug Anderson <dianders@chromium.org>
Cc: Addy <addy.ke@rock-chips.com>, Ulf Hansson <ulf.hansson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "tgih.jun@samsung.com" <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <chris@printf.net>,
        Dinh Nguyen <dinguyen@altera.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
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

>From what I understand... High speed SD cards have 1.8V regulators
inside them(sourced by vmmc (what we power the SD card with)). So in
terms of the SD card IO pins they will either use exactly vmmc or
1.8V. It doesn't make sense for vqmmc (the voltage we use to power the
AP block connected to the SD cards) to be anything but exactly equal
to vmmc or 1.8V. If vqmmc differs from vmmc(or 1.8V, depending on
mode) by more than a little (~100-200mV), both up or down, you start
getting leaks into the input protection diodes of the pins(either the
AP or the SD card) which is a pretty BAD thing (you're essentially
powering the sd card through the IO pins, or the SD card is powering
the IO block on the AP).

Alexandru Stan (amstan)

On Mon, Nov 24, 2014 at 9:36 PM, Doug Anderson <dianders@chromium.org> wrote:
> Addy,
>
> On Mon, Nov 24, 2014 at 6:38 PM, Addy <addy.ke@rock-chips.com> wrote:
>>> In worst case scenario, VDD = 3.6V and VIO = 2.7V. That gives as the
>>> factor of 0.75, thus we are inside spec but without margins.
>>
>> * From eMMC4.5 spec:
>>   1. (VDDF)vcc: Supply voltage for flash memory,  which is  2.7v -- 3.3v
>>   2. (VDD)vccq: Supply voltage for memory controller, which is  1.7v --
>> 1.95v  and 2,7v -- 3.6v
>>
>> * And from RK3288 datasheet:
>>   Digtial GPIO Power(SDMMC0_VDD --> vccq) is 3.0v -- 3.6v and 1.62v - 1.98v
>>
>> So I think:
>> 3.3v:  (2.7v < vccq < 3.6v)   &&  (3.0v < vccq < 3.6v)  ==> (3.0v < vccq <
>> 3.6v)
>> 1.8v:  (1.7v < vccq < 1.95v)  && (1.62v < vccq < 1.98v) ==> (1.7v < vccq <
>> 1.95v)
>>
>> and (2.7v < vcc < 3.3v)
>>
>> * And according to our hardware engineer:
>>   All of supply voltage must have +/- 10% cushion.
>>
>> * And we have found in some worse card that there is 200mv voltage collapse
>> when these card is insert.
>>
>> So I think the best resolution is that vcc and vccq is configurable int dt
>> table.
>
> Ah, interesting.  ...so what we really need to be able to do is to say
> that the regulator we for vqmmc have supports the ranges 3.0V - 3.3V
> and 1.7V - 1.95V but not anything in between 1.95V ad 3.0V.  I have no
> idea how to express that in the regulator framework.
>
> Technically you could take the IO Voltage Domains code (responsible
> for choosing the 1.8V range or the 3.3V range) and have it communicate
> the requirements to the regulator framework if you could figure out
> how to communicate them.
>
>
> ...of course if you implemented my suggestion of keeping vqmmc as the
> highest voltage <= vmmc then maybe the whole point is moot and we
> don't have to figure it out.  Just make sure that vmmc never goes
> below 3.0V.
>
>
> -Doug
