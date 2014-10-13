Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbaJMAdB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 20:33:01 -0400
Received: from regular1.263xmail.com ([211.150.99.138]:57268 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbaJMAdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 20:33:00 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: xjq@rock-chips.com
X-FST-TO: cf@rock-chips.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: xjq@rock-chips.com
X-UNIQUE-TAG: <4dc46581f5704b76110a7d05c3949d1f>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <543B1DB2.6070300@rock-chips.com>
Date: Mon, 13 Oct 2014 08:32:50 +0800
From: Jianqun <xjq@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        Jianqun <jay.xu@rock-chips.com>
CC: mturquette@linaro.org, dianders@chromium.org, kever.yang@rock-chips.com,
        dbasehore@chromium.org, mark.yao@rock-chips.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        huangtao@rock-chips.com, cf@rock-chips.com
Subject: Re: [PATCH] clk: rockchip: rk3288: i2s_frac adds flag to set parent's
 rate
References: <1412046724-28069-1-git-send-email-jay.xu@rock-chips.com> <1489993.9j1G9iMIhJ@phil>
In-Reply-To: <1489993.9j1G9iMIhJ@phil>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


在 10/12/2014 02:54 AM, Heiko Stübner 写道:
> Hi Jianqun,
>
> Am Dienstag, 30. September 2014, 11:12:04 schrieb Jianqun:
>> The relation of i2s nodes as follows:
>>           i2s_src               0           0            594000000  0
>>              i2s_frac           0           0            11289600   0
>>                 i2s_pre         0           0            11289600   0
>>                    sclk_i2s0    0           0            11289600   0
>>                    i2s0_clkout  0           0            11289600   0
>>                       hclk_i2s0 1           1            99000000   0
>>
>> sclk_i2s0 is the master clock, when to set rate of sclk_i2s0, should
>> allow to set its parent's rate, by add flag CLK_SET_RATE_PARENT for
>> "i2s_frac", "i2s_pre", "i2s0_clkout" and "sclk_i2s0".
>>
>> Tested on rk3288 board using max98090, with command "aplay <music.wav>"
>>
>> Change-Id: I12faad082566532b65a7de8c0a6845e1c17870e6
> Please no "Change-Id"s in upstream patches.
ok
>
>
>> Signed-off-by: Jianqun <jay.xu@rock-chips.com>
>> ---
>>  drivers/clk/rockchip/clk-rk3288.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/clk/rockchip/clk-rk3288.c
>> b/drivers/clk/rockchip/clk-rk3288.c index c770de0..baf19b4 100644
>> --- a/drivers/clk/rockchip/clk-rk3288.c
>> +++ b/drivers/clk/rockchip/clk-rk3288.c
>> @@ -301,15 +301,15 @@ static struct rockchip_clk_branch
>> rk3288_clk_branches[] __initdata = { COMPOSITE(0, "i2s_src",
>> mux_pll_src_cpll_gpll_p, 0,
>>  			RK3288_CLKSEL_CON(4), 15, 1, MFLAGS, 0, 7, DFLAGS,
>>  			RK3288_CLKGATE_CON(4), 1, GFLAGS),
>> -	COMPOSITE_FRAC(0, "i2s_frac", "i2s_src", 0,
>> +	COMPOSITE_FRAC(0, "i2s_frac", "i2s_src", CLK_SET_RATE_PARENT,
>>  			RK3288_CLKSEL_CON(8), 0,
>>  			RK3288_CLKGATE_CON(4), 2, GFLAGS),
>> -	MUX(0, "i2s_pre", mux_i2s_pre_p, 0,
>> +	MUX(0, "i2s_pre", mux_i2s_pre_p, CLK_SET_RATE_PARENT,
>>  			RK3288_CLKSEL_CON(4), 8, 2, MFLAGS),
>> -	COMPOSITE_NODIV(0, "i2s0_clkout", mux_i2s_clkout_p, 0,
>> +	COMPOSITE_NODIV(0, "i2s0_clkout", mux_i2s_clkout_p, CLK_SET_RATE_PARENT,
> are you sure it is correct that i2s0_clkout should also be able to set the 
> core i2s clock?
>
> I.e. as it is now, the i2s controller could set one frequency through 
> sclk_i2s0 and whatever uses i2s0_clkout would be able to set it to something 
> completely different, which may call for trouble.
>
> So in my mind, it might be better to limit i2s0_clkout to select between its 
> two parent without being able influence the core i2s clock?
ok, you are right, here is the new clock tree with your suggestion, when play music
          i2s_src               1           1            594000000  0                                                                                                                                     
             i2s_frac           1           1            11289600   0                                                                                                                                     
                i2s_pre         1           1            11289600   0                                                                                                                                     
                   sclk_i2s0    1           1            11289600   0                                                                                                                                     
                   i2s0_clkout  0           0            11289600   0                                                                                                                                     
                      hclk_i2s0 1           1            148500000  0

I'll make an patch v2 soon
>
> Heiko
>
>
>>  			RK3288_CLKSEL_CON(4), 12, 1, MFLAGS,
>>  			RK3288_CLKGATE_CON(4), 0, GFLAGS),
>> -	GATE(SCLK_I2S0, "sclk_i2s0", "i2s_pre", 0,
>> +	GATE(SCLK_I2S0, "sclk_i2s0", "i2s_pre", CLK_SET_RATE_PARENT,
>>  			RK3288_CLKGATE_CON(4), 3, GFLAGS),
>>
>>  	MUX(0, "spdif_src", mux_pll_src_cpll_gpll_p, 0,
>
>
>

-- 
Jianqun Xu

****************************************************************************
*IMPORTANT NOTICE:*This email is from Fuzhou Rockchip Electronics Co.,
Ltd .The contents of this email and any attachments may contain
information that is privileged, confidential and/or exempt from
disclosure under applicable law and relevant NDA. If you are not the
intended recipient, you are hereby notified that any disclosure,
copying, distribution, or use of the information is STRICTLY PROHIBITED.
Please immediately contact the sender as soon as possible and destroy
the material in its entirety in any format. Thank you.
****************************************************************************


