Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062AbaJ3BLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 21:11:00 -0400
Received: from regular1.263xmail.com ([211.150.99.132]:44091 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788AbaJ3BK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 21:10:59 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: kever.yang@rock-chips.com
X-FST-TO: linux-kernel@vger.kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: kever.yang@rock-chips.com
X-UNIQUE-TAG: <8922f360dd118fa64c48e0ed59b35373>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <54519019.6010903@rock-chips.com>
Date: Thu, 30 Oct 2014 09:10:49 +0800
From: Kever Yang <kever.yang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        Doug Anderson <dianders@chromium.org>
CC: Sonny Rao <sonnyrao@chromium.org>, Addy Ke <addy.ke@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, Jianqun Xu <xjq@rock-chips.com>,
        han jiang <hj@rock-chips.com>,
        =?UTF-8?B?IuaItOWFi+mcliAoSmFjayki?= <dkl@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: rockchip: disable unused clocks
References: <1414577167-25666-1-git-send-email-kever.yang@rock-chips.com> <CAD=FV=Vnt7Pg9V_cE0S8u-2X2hDsPN8huwy8xKv1UwvWEo-Hyw@mail.gmail.com> <13348555.zj6gsMcCpK@diego>
In-Reply-To: <13348555.zj6gsMcCpK@diego>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On 10/30/2014 05:53 AM, Heiko Stübner wrote:
> Am Mittwoch, 29. Oktober 2014, 13:50:20 schrieb Doug Anderson:
>> Kever,
>>
>> On Wed, Oct 29, 2014 at 3:06 AM, Kever Yang <kever.yang@rock-chips.com>
> wrote:
>>> The rockchip clock driver use CLK_IGNORE_UNUSED flag to make sure
>>> all the clocks are available like default power on state.
>>> We have implement the clock manage in most of rockchip drivers,
>>> it is time to remove it for power save.
>>> Instead we add CLK_IGNORE_UNUSED for some clock nodes which should
>>> be on during boot or no module driver in kernel will initialize it.
>>>
>>> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
>>> ---
>>>
>>>   drivers/clk/rockchip/clk-rk3188.c |  32 ++++-----
>>>   drivers/clk/rockchip/clk-rk3288.c | 146
>>>   +++++++++++++++++++------------------- drivers/clk/rockchip/clk.c
>>>   |   9 ---
>>>   3 files changed, 90 insertions(+), 97 deletions(-)
>> Your patch didn't seem to apply to the top of Heiko's
>> "v3.19-clk/next".  Where should it apply to?
I apply the patch on the top of linux-next, I will apply it on Heiko's
"v3.19-clk/next" next version.
>>
>>> -       GATE(ACLK_CPU, "aclk_cpu", "aclk_cpu_pre", 0,
>>> +       GATE(0, "aclk_cpu", "aclk_cpu_pre", CLK_IGNORE_UNUSED,
>>>
>>>                          RK3288_CLKGATE_CON(0), 3, GFLAGS),
>> It seems strange to me that you're removing the ACLK_CPU ID here.  Was
>> that on purpose?
Sorry for that, I didn't mean to removing any ID here, will fix in next 
version.
>>
>>> -       COMPOSITE_NOMUX(PCLK_CPU, "pclk_cpu", "aclk_cpu_pre", 0,
>>> +       COMPOSITE_NOMUX(0, "pclk_cpu", "aclk_cpu_pre", CLK_IGNORE_UNUSED,
>>>
>>>                          RK3288_CLKSEL_CON(1), 12, 3, DFLAGS,
>>>                          RK3288_CLKGATE_CON(0), 5, GFLAGS),
>> Here too for PCLK_CPU.  There are a few others as well.
> yeah, they should keep their clock ids
>
>
>> I'll also say that when I applied this atop my local tree that USB
>> stopped working.  I just see:
>>
>> [ 1647.626747] hub 2-1:1.0: hub_port_status failed (err = -110)
>> [ 1657.626746] hub 2-1:1.0: hub_port_status failed (err = -110)
>>
>> ...over and over and over again.
> maybe Kever's dwc2 clock-handling patch [0] might help there, as the dwc2-host
> currently does not seem to do any clock handling at all.
I think Heiko is right, I test in my evb with following change and dwc2
works well:
--- a/drivers/clk/rockchip/clk-rk3288.c
+++ b/drivers/clk/rockchip/clk-rk3288.c
@@ -654,8 +654,8 @@ static struct rockchip_clk_branch 
rk3288_clk_branches[] __initdata = {

         /* hclk_peri gates */
         GATE(0, "hclk_peri_matrix", "hclk_peri", CLK_IGNORE_UNUSED, 
RK3288_CLKGATE_CON(6), 0, GFLAGS),
-       GATE(HCLK_OTG0, "hclk_otg0", "hclk_peri", 0, 
RK3288_CLKGATE_CON(7), 4, GFLAGS),
-       GATE(HCLK_USBHOST0, "hclk_host0", "hclk_peri", 0, 
RK3288_CLKGATE_CON(7), 6, GFLAGS),
+       GATE(HCLK_OTG0, "hclk_otg0", "hclk_peri", CLK_IGNORE_UNUSED, 
RK3288_CLKGATE_CON(7), 4, GFLAGS),
+       GATE(HCLK_USBHOST0, "hclk_host0", "hclk_peri", 
CLK_IGNORE_UNUSED, RK3288_CLKGATE_CON(7), 6, GFLAGS),
         GATE(HCLK_USBHOST1, "hclk_host1", "hclk_peri", 0, 
RK3288_CLKGATE_CON(7), 7, GFLAGS),
         GATE(HCLK_HSIC, "hclk_hsic", "hclk_peri", 0, 
RK3288_CLKGATE_CON(7), 8, GFLAGS),
         GATE(0, "hclk_usb_peri", "hclk_peri", CLK_IGNORE_UNUSED, 
RK3288_CLKGATE_CON(7), 9, GFLAGS),

- Kever

