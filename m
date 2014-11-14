Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965137AbaKNI6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 03:58:39 -0500
Received: from regular1.263xmail.com ([211.150.99.132]:47019 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964989AbaKNI6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 03:58:38 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: kever.yang@rock-chips.com
X-FST-TO: sboyd@codeaurora.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: kever.yang@rock-chips.com
X-UNIQUE-TAG: <731671984248185a53d7e03892921c67>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <5465C432.4050202@rock-chips.com>
Date: Fri, 14 Nov 2014 16:58:26 +0800
From: Kever Yang <kever.yang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        Doug Anderson <dianders@chromium.org>
CC: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        Sonny Rao <sonnyrao@chromium.org>, Addy Ke <addy.ke@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, ZhenFu Fang <fzf@rock-chips.com>,
        Yakir Yang <ykk@rock-chips.com>, yzq@rock-chips.com,
        dkl@rock-chips.com, Tao Huang <huangtao@rock-chips.com>,
        linux-rockchip@lists.infradead.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, tomeu.vizoso@collabora.com,
        sboyd@codeaurora.org
Subject: Re: [PATCH 0/5] clk: rockchip: add full support for HDMI clock on
 rk3288
References: <1415087559-19444-1-git-send-email-kever.yang@rock-chips.com> <48806799.thBSifdUp8@diego> <54647142.4080800@rock-chips.com> <CAD=FV=Vzec3Qm-kc6zZ4VxSREoZbzVkWbzp-noHYdcEVrLYYSw@mail.gmail.com> <20141114014605.25314.49766@quantum>
In-Reply-To: <20141114014605.25314.49766@quantum>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On 11/14/2014 09:46 AM, Mike Turquette wrote:
>>>> Looking through the clock-tree there are a lot more components possibly
>>>> > >>using
>>>> > >>(or wanting to use) the npll: of course the VOPs, the edp, hdmi, isp,
>>>> > >>hevc,
>>>> > >>gpu, tsp uart0 and gmac. So I'm slightly uncomfortable with somehow
>>>> > >>reserving
>>>> > >>the npll for VOP0 alone.
I understand the concern for other module clocks which may use NPLL as
parent, we have to make sure all these clocks can get what they want even
if NPLL is not available for them. So, let's have a look at them(without 
NPLL):
with CPLL 400M and GPLL 594M,

GPU/HEVC/ISP/TSP can get 100/200/400 from CPLL, and ~300/600 from GPLL,
        and ~500 from usbphy480m, these should be enough for those modules.

DCLK_VOP1 for eDP/MIPI/LVDS, these clock can accept maybe more than 5%
margin, we can get enough frequency for them now, we can change the CPLL
to 800MHz for more option if it's needed one day.

GMAC can get 50M from CPLL, usually we use external clock for GMAC.

uart0 have frac divider, so we don't need to worry too much for it.



>>> > >
>>> > >It's true that I customized the usage of npll for VOP0 when we need some
>>> > >very special frequency, but it doesn't means other modules can't use the
>>> > >npll, it will always decided by clock core for module clocks that which
>>> > >parent
>>> > >is the best.
>> >
>> >We will just need to be very careful.  As I've mentioned in the past
>> >we'll need to think about what happens to other clocks that happen to
>> >be parented by NPLL whenever we change it.
>> >
>> >So if we do this:
>> >
>> >1. NPLL happens to be 500MHz.
>> >2. We set GPU to be 500MHz and it picks NPLL.
>> >3. We change NPLL to a different speed (like 600MHz).
>> >
>> >...I believe in this scenario the GPU would start running at 600MHz
>> >immediately.  We'd need to add special code to watch out for this and
>> >pick an alternate clock for the GPU (like the USB 480) before the NPLL
>> >change.  If NPLL later changes back to 500MHz and the GPU still wanted
>> >500MHz, we'd have to decide what to do.
>> >
>> >
>> >The summary is: it's pretty complicated
It's complicated if there are more than one clock share the PLL and
one of the clock wants to change the PLL output rate.

Most of module clocks can't be changed during they are work, and it
is better to route those clocks to a parent that would not change.

Some of PLLs should not be changed after system initialized and they
can be source for most of module clocks while some of PLLs have to
change for some special requirement like HDMI that we can know
the required frequency only when the device is plug in at run time.

To make it simple, we can use the NPLL exclusively for HDMI/VOP0,
just like what we do for APLL for cpu and DPLL for DDR, although what
I though was share NPLL with other clocks in most of time, maybe we
can use this case in the product like OTT BOX which will always have
HDMI pluged.

Maybe we can add an attribute for clock like NPLL in this way?
There is an owner children for NPLL(for example VOP0) which can change 
NPLL's rate,
and there it a fixed_rate attribute to describe if this clock is fixed 
or not.

If VOP0 is not enabled, NPLL output is unfixed, other children clock can
decide if they want to use a parent with unfixed output or another 
parent with
fixed output.

If VOP0 is enabled, then the NPLL's output has decide by the VOP0 and it 
become
a fixed output parent.

> +Stephen Boyd & Tomeu Vizoso
>
> Managing shared clocks is a subset of the general problems with clock
> constraints. Maybe Stephen or Tomeu have some comment here?


