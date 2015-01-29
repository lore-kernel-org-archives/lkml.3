Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067AbbA2BVJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:21:09 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:55707 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbbA2BVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:21:03 -0500
MIME-Version: 1.0
In-Reply-To: <CAPDyKFqjG=yxDcwnk4jbXMZ05hMkWR2x37uVpRNd_11-eB4G7w@mail.gmail.com>
References: <1422271175-19445-1-git-send-email-addy.ke@rock-chips.com>
	<1422271175-19445-2-git-send-email-addy.ke@rock-chips.com>
	<CAPDyKFp=5epMggHu0+u_LU7ETujcoeP2xOpB7iD6JF2bs8BnEA@mail.gmail.com>
	<CAD=FV=X9x0gW5TyLi4ERm8nxixQB__Y=5bRAtOax-_w+T33rCg@mail.gmail.com>
	<CAPDyKFqjG=yxDcwnk4jbXMZ05hMkWR2x37uVpRNd_11-eB4G7w@mail.gmail.com>
Date: Wed, 28 Jan 2015 16:55:28 -0800
X-Google-Sender-Auth: QsjzPaToXWOu4OxagdDhZOtXP4Y
Message-ID: <CAD=FV=VQg+sQUpgbKw7Zz=-f+jPM=6O-+3gUpohWhj8JeSPu6Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] mmc: core: use card pointer as the first parameter of execute_tuning()
From: Doug Anderson <dianders@chromium.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Addy Ke <addy.ke@rock-chips.com>, Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?Q?Pawe=C5=82_Moll?= <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
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
        Han Jiang <hj@rock-chips.com>, Kever Yang <kever.yang@rock-chips.com>,
        zhangqing <zhangqing@rock-chips.com>, Lin Huang <hl@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulf,

On Tue, Jan 27, 2015 at 7:18 AM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
>> I asked Addy to post upstream against mmc_send_tuning(), but I guess
>> he didn't (he posted against Alex's NAKed patch instead).
>>
>> ...when I talked to him about it, Addy was asserting that when tuning
>> fails it is important (at least on dw_mmc on rk3288) that we wait for
>> the card to stop being busy and that the way to detect was using
>> mmc_send_status().
>
> So, could that be due to the internal logic of the error handling in
> dw_mmc driver? Or you think this is a generic issue?
>
> According to the specifications (eMMC and SD) both states that the
> tuning command has an R1 response. So, there shouldn't be any busy
> signalling involved - at least according to spec.

I did a bit of digging into this issue myself.  What I found was that
a "response CRC" and "end of transfer".  This was why I posted up
<https://patchwork.kernel.org/patch/5623071/>.  From that patch:

> Specifically it looks like in certain error conditions (I saw this
> with Response CRC errors) that data keeps showing up in the FIFO even
> after the error is reported and the CD (command done) bit is set.  If
> we don't wait for this data to finish transferring then it confuses
> the next transaction.  In the specific failure case I ran into I found
> that I could monitor the data_state_mc_busy bit and wait for it to
> clear, but in other failure cases this bit was stuck at busy when we
> saw an error.  Hence a generic big delay seems like the only option.

...Addy instead fixed the problem using mmc_send_status() to try to
detect when the transfer was all done and it apparently worked, but it
seemed odd to me.  My MMC "expertise" pretty much ends with looking
for simple logic errors in the MMC driver, so my hope was that one of
you guys would know this better...


>> That would mean that against upstream you'd need to change
>> mmc_send_tuning() to take in the card as well (or move the "host->card
>> = card" assignment to before UHS init, which seems less desirable?)
>>
>> What do you think about that?  Is there a better solution?
>
> Why do we need to change mmc_send_tuning()? I thought the issue was
> that mmc_send_status(), which currently takes "card" as a parameter.

Well, if mmc_send_tuning() needed to call mmc_send_status() then
mmc_send_tuning() would need the card parameter, right?


Doug
