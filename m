Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964814AbaKMW7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 17:59:09 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:35107 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964781AbaKMW7H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 17:59:07 -0500
MIME-Version: 1.0
In-Reply-To: <54647142.4080800@rock-chips.com>
References: <1415087559-19444-1-git-send-email-kever.yang@rock-chips.com>
	<48806799.thBSifdUp8@diego>
	<54647142.4080800@rock-chips.com>
Date: Thu, 13 Nov 2014 14:59:06 -0800
X-Google-Sender-Auth: 6B4VXRB2swiOXIeOMjaaPkGkLqA
Message-ID: <CAD=FV=Vzec3Qm-kc6zZ4VxSREoZbzVkWbzp-noHYdcEVrLYYSw@mail.gmail.com>
Subject: Re: [PATCH 0/5] clk: rockchip: add full support for HDMI clock on rk3288
From: Doug Anderson <dianders@chromium.org>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Mike Turquette <mturquette@linaro.org>,
        Sonny Rao <sonnyrao@chromium.org>, Addy Ke <addy.ke@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, ZhenFu Fang <fzf@rock-chips.com>,
        Yakir Yang <ykk@rock-chips.com>,
        =?UTF-8?B?5aea5pm65oOF?= <yzq@rock-chips.com>,
        =?UTF-8?B?5oi05YWL6ZyWIChKYWNrKQ==?= <dkl@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Nov 13, 2014 at 12:52 AM, Kever Yang <kever.yang@rock-chips.com> wrote:
> Hi Heiko,
>
> On 11/07/2014 05:06 AM, Heiko Stübner wrote:
>>
>> Hi Kever,
>>
>> Am Dienstag, 4. November 2014, 15:52:34 schrieb Kever Yang:
>>>
>>> we are going to make a clock usage solution for rk3288:
>>> 1. CPLL and GPLL always not change after assign init;
>>> 2. NPLL default as 500MHz, may used for most scene;
>>> 3. NPLL may be changed by VOP(HDMI) clock for some special
>>>     frequency requirement.
>>>
>>>      I test it with rk3288 evb on top of Heiko's clk-for-next
>>
>> In general I'm not really sure if allowing one component to arbitarily
>> change
>> a shared clock wouldn't result in trouble.
>>
>> At the moment only dclk_vop0 is included in your series, while the hdmi
>> controller can connect to both vop0 and vop1.
>> And as Doug mentioned the gpu also has the npll as one possible source.
>
> I think the problem GPU HANGs with 480MHz clock from usbphy has
> been fixed with my patch to gerrit:
> https://chromium-review.googlesource.com/#/c/229554/
>>
>>
>> Looking through the clock-tree there are a lot more components possibly
>> using
>> (or wanting to use) the npll: of course the VOPs, the edp, hdmi, isp,
>> hevc,
>> gpu, tsp uart0 and gmac. So I'm slightly uncomfortable with somehow
>> reserving
>> the npll for VOP0 alone.
>
> It's true that I customized the usage of npll for VOP0 when we need some
> very special frequency, but it doesn't means other modules can't use the
> npll, it will always decided by clock core for module clocks that which
> parent
> is the best.

We will just need to be very careful.  As I've mentioned in the past
we'll need to think about what happens to other clocks that happen to
be parented by NPLL whenever we change it.

So if we do this:

1. NPLL happens to be 500MHz.
2. We set GPU to be 500MHz and it picks NPLL.
3. We change NPLL to a different speed (like 600MHz).

...I believe in this scenario the GPU would start running at 600MHz
immediately.  We'd need to add special code to watch out for this and
pick an alternate clock for the GPU (like the USB 480) before the NPLL
change.  If NPLL later changes back to 500MHz and the GPU still wanted
500MHz, we'd have to decide what to do.


The summary is: it's pretty complicated
