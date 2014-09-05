Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbaIEKR2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 06:17:28 -0400
Received: from regular1.263xmail.com ([211.150.99.132]:34567 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840AbaIEKR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 06:17:26 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: dianders@chromium.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <60621e7f61bd4ac5f20107fbfe2d4399>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <54098DA6.4090704@rock-chips.com>
Date: Fri, 05 Sep 2014 18:17:10 +0800
From: addy ke <addy.ke@rock-chips.com>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: dianders@chromium.org
CC: wsa@the-dreams.de, max.schwarz@online.de, heiko@sntech.de, olof@lixom.net,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, cf@rock-chips.com,
        xjq@rock-chips.com, huangtao@rock-chips.com, zyw@rock-chips.com,
        yzq@rock-chips.com, hj@rock-chips.com, kever.yang@rock-chips.com,
        hl@rock-chips.com, caesar.wang@rock-chips.com, zhengsq@rock-chips.com
Subject: Re: [PATCH] i2c: rk3x: fix divisor calculation for SCL frequency
References: <1409884333-3544-1-git-send-email-addy.ke@rock-chips.com> <CAD=FV=W3JJM38v-X=pyLUjAzY3Ti88xUgWp9bMsX5dqp1gubpg@mail.gmail.com>
In-Reply-To: <CAD=FV=W3JJM38v-X=pyLUjAzY3Ti88xUgWp9bMsX5dqp1gubpg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Addy,
> 
> On Thu, Sep 4, 2014 at 7:32 PM, Addy Ke <addy.ke@rock-chips.com> wrote:
>> I2C_CLKDIV register descripted in the previous version of
>> RK3x chip manual is incorrect. Plus 1 is required.
>>
>> The correct formula:
>> - T(SCL_HIGH) = T(PCLK) * (CLKDIVH + 1) * 8
>> - T(SCL_LOW) = T(PCLK) * (CLKDIVL + 1) * 8
>> - (SCL Divsor) = 8 * ((CLKDIVL + 1) + (CLKDIVH + 1))
>> - SCL = PCLK / (CLK Divsor)
> 
> I'll trust that you tested this with a scope
> 
Yes ,I have tested on RK3188 and RK3288, and confirmed by oscilloscope.
> 
>> It will be updated to the latest version of chip manual.
>>
>> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
>> ---
>>  drivers/i2c/busses/i2c-rk3x.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/i2c/busses/i2c-rk3x.c b/drivers/i2c/busses/i2c-rk3x.c
>> index e637c32..76b6604 100644
>> --- a/drivers/i2c/busses/i2c-rk3x.c
>> +++ b/drivers/i2c/busses/i2c-rk3x.c
>> @@ -433,8 +433,8 @@ static void rk3x_i2c_set_scl_rate(struct rk3x_i2c *i2c, unsigned long scl_rate)
>>         unsigned long i2c_rate = clk_get_rate(i2c->clk);
>>         unsigned int div;
>>
>> -       /* SCL rate = (clk rate) / (8 * DIV) */
>> -       div = DIV_ROUND_UP(i2c_rate, scl_rate * 8);
>> +       /* SCL rate = (clk rate) / (8 * (DIV + 2)) */
>> +       div = DIV_ROUND_UP(i2c_rate, scl_rate * 8) - 2;
> 
> Given the bug I just fixed in the Rockchip SPI driver, I was a little
> worried about div becoming -1 (and thus being a really large positive
> number since div is unsigned).
> 
> However, it seems that you get saved by the next statement:
>   div = DIV_ROUND_UP(div, 2);
> 
> In the testing I did with the Linux macros, that magically transformed
> a div of 0xFFFFFFFF (-1) to 0, so it's not technically a bug.  ...but
> it's very non-obvious.  Can you do something a little cleaner?

The following modifications is reasonable?

static void rk3x_i2c_set_scl_rate(struct rk3x_i2c *i2c, unsigned long scl_rate)
{
        unsigned long i2c_rate = clk_get_rate(i2c->clk);
        unsigned int div;

        /* set DIV = DIVH = DIVL
         * SCL rate = (clk rate) / (8 * (DIVH + 1 + DIVL + 1))
         *          = (clk rate) / (16 * (DIV + 1))
         */
        div = DIV_ROUND_UP(i2c_rate, scl_rate * 16) - 1;

        i2c_writel(i2c, (div << 16) | (div & 0xffff), REG_CLKDIV);
}
> 
> -Doug
> 
> 
> 

