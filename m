Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828AbaIYB2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 21:28:23 -0400
Received: from regular1.263xmail.com ([211.150.99.131]:35070 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaIYB2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 21:28:22 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: kever.yang@rock-chips.com
X-FST-TO: linux-arm-kernel@lists.infradead.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: kever.yang@rock-chips.com
X-UNIQUE-TAG: <0eb333135573ce961177d571e3bb8f74>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <54236FAE.5090903@rock-chips.com>
Date: Thu, 25 Sep 2014 09:28:14 +0800
From: Kever Yang <kever.yang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Tao Huang <huangtao@rock-chips.com>, Addy Ke <addy.ke@rock-chips.com>,
        Mike Turquette <mturquette@linaro.org>,
        =?windows-1252?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-rockchip@lists.infradead.org, Jianqun Xu <xjq@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, han jiang <hj@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 3/3] clk: rockchip: add clock node in PD_VIDEO
References: <1411572802-22042-1-git-send-email-kever.yang@rock-chips.com> <1411572802-22042-4-git-send-email-kever.yang@rock-chips.com> <CAD=FV=UqB26_GzP14ueHHpmjgJqX7sPpR0T+SR60e=i_YbWitQ@mail.gmail.com>
In-Reply-To: <CAD=FV=UqB26_GzP14ueHHpmjgJqX7sPpR0T+SR60e=i_YbWitQ@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

On 09/25/2014 03:48 AM, Doug Anderson wrote:
> Kever,
>
> On Wed, Sep 24, 2014 at 8:33 AM, Kever Yang <kever.yang@rock-chips.com> wrote:
>> This patch add the clock node in PD_VIDEO
>>
>> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
>> Reviewed-by: Heiko Stuebner <heiko@sntech.de>
>> ---
>>
>> Changes in v2:
>> - split out the patch
>>
>>   drivers/clk/rockchip/clk-rk3288.c | 11 +++++++++++
>>   1 file changed, 11 insertions(+)
>>
>> diff --git a/drivers/clk/rockchip/clk-rk3288.c b/drivers/clk/rockchip/clk-rk3288.c
>> index d691a56..2cfcfb6 100644
>> --- a/drivers/clk/rockchip/clk-rk3288.c
>> +++ b/drivers/clk/rockchip/clk-rk3288.c
>> @@ -296,6 +296,17 @@ static struct rockchip_clk_branch rk3288_clk_branches[] __initdata = {
>>          COMPOSITE(0, "aclk_vdpu", mux_pll_src_cpll_gpll_usb480m_p, 0,
>>                          RK3288_CLKSEL_CON(32), 14, 2, MFLAGS, 8, 5, DFLAGS,
>>                          RK3288_CLKGATE_CON(3), 11, GFLAGS),
>> +       /*
>> +        * We use aclk_vdpu by default GRF_SOC_CON0[7] setting in system,
>> +        * so we ignore the mux and make clocks nodes as following,
> I guess we can't add the mux for now because it's in the GRF and not
> in the clock area and the current clock tables don't have support for
> that.  I guess that OK for now, but eventually we should probably add
> it in.
The mux setting moved to GRF because it switch the clock source and some 
other
controller logic.
The VCODEC can be used as encoder or decoder, we use it as decoder by 
default,
so I guess we can ignore the decoder part before the clock module can 
handle this.
>
>
>> +        * NOTE THAT hclk_vcodec is fix div by 4 from aclk_vcodec_pre.
> Typo: from "aclk_vcodec_pre" or from "hclk_vcodec_pre"?
hclk_vcodec_pre is /4 from aclk_vcodec_pre, and hclk_vcodec has a gate 
from hclk_vcodec_pre.
I should fix this.
>
>> +        */
>> +       GATE(ACLK_VCODEC, "aclk_vcodec", "aclk_vdpu", 0,
>> +               RK3288_CLKGATE_CON(9), 0, GFLAGS),
>> +       GATE(0, "hclk_vcodec_pre", "aclk_vdpu", 0,
>> +               RK3288_CLKGATE_CON(3), 10, GFLAGS),
>> +       GATE(HCLK_VCODEC, "hclk_vcodec", "hclk_vcodec_pre", 0,
>> +               RK3288_CLKGATE_CON(9), 1, GFLAGS),
> Shouldn't there be a fixed "/ 4" clock somewhere in here?  That way
> the clock rate will be reported correctly?
>
> I guess the cleanest would be to add support to rockchip/clk.c to call
> clk_register_fixed_factor() somehow.  I guess I'll leave it to you and
> Heiko to decide what you want to do here.
There is a fixed "/4" that not add to this tree, which makes we get a 4 
times
of real rate when we get the HCLK_VCODEC, that is why I write a commend
with "NOTE THAT" before.

I know there is a clk_register_fixed_factor(), but I'm not sure how to use
it here, this is a table.
I'll try to add the clk_register_fixed_factor() today.

-Kever

