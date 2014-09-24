Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868AbaIXRNY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:13:24 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:35899 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753460AbaIXRNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:13:19 -0400
MIME-Version: 1.0
In-Reply-To: <54227F93.7000507@rock-chips.com>
References: <1411523743-3444-1-git-send-email-addy.ke@rock-chips.com>
	<CAD=FV=WiHR+KcTWHnma6TdPQcc3oc4wqAofj5kF=Sgec_5kGAQ@mail.gmail.com>
	<54227F93.7000507@rock-chips.com>
Date: Wed, 24 Sep 2014 10:13:18 -0700
X-Google-Sender-Auth: wqv8wF___Zn1b1kIE099nmJ8o2Q
Message-ID: <CAD=FV=Uq9AteUcpMvcU5tmyGZbVYWM6PNmevZXSVCkYB8rqSsQ@mail.gmail.com>
Subject: Re: [PATCH] i2c: rk3x: adjust the LOW divison based on
 characteristics of SCL
From: Doug Anderson <dianders@chromium.org>
To: addy ke <addy.ke@rock-chips.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Max Schwarz <max.schwarz@online.de>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-rockchip@lists.infradead.org, Eddie Cai <cf@rock-chips.com>,
        Jianqun Xu <xjq@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Chris <zyw@rock-chips.com>,
        =?UTF-8?B?5aea5pm65oOF?= <yzq@rock-chips.com>,
        han jiang <hj@rock-chips.com>, Kever Yang <kever.yang@rock-chips.com>,
        Lin Huang <hl@rock-chips.com>,
        =?UTF-8?B?5pmT6IW+546L?= <caesar.wang@rock-chips.com>,
        Shunqian Zheng <zhengsq@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Addy,

On Wed, Sep 24, 2014 at 1:23 AM, addy ke <addy.ke@rock-chips.com> wrote:
>
>
> On 2014/9/24 12:10, Doug Anderson wrote:
>> Addy,
>>
>> On Tue, Sep 23, 2014 at 6:55 PM, Addy Ke <addy.ke@rock-chips.com> wrote:
>>> As show in I2C specification:
>>> - Standard-mode:
>>>   the minimum HIGH period of the scl clock is 4.0us
>>>   the minimum LOW period of the scl clock is 4.7us
>>> - Fast-mode:
>>>   the minimum HIGH period of the scl clock is 0.6us
>>>   the minimum LOW period of the scl clock is 1.3us
>>> - Fast-mode plus:
>>>   the minimum HIGH period of the scl clock is 0.26us
>>>   the minimum LOW period of the scl clock is 0.5us
>>> - HS-mode(<1.7MHz):
>>>   the minimum HIGH period of the scl clock is 0.12us
>>>   the minimum LOW period of the scl clock is 0.32us
>>> - HS-mode(<3.4MHz):
>>>   the minimum HIGH period of the scl clock is 0.06us
>>>   the minimum LOW period of the scl clock is 0.16us
>>>
>>> I have measured i2c SCL waveforms in fast-mode by oscilloscope
>>> on rk3288-pinky board. the LOW period of the scl clock is 1.3us.
>>> It is so critical that we must adjust LOW division to increase
>>> the LOW period of the scl clock.
>>>
>>> Thanks Doug for the suggestion about division formula.
>>>
>>> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
>>> ---
>>>  drivers/i2c/busses/i2c-rk3x.c | 79 +++++++++++++++++++++++++++++++++++++++----
>>>  1 file changed, 72 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/drivers/i2c/busses/i2c-rk3x.c b/drivers/i2c/busses/i2c-rk3x.c
>>> index 93cfc83..49d67b7 100644
>>> --- a/drivers/i2c/busses/i2c-rk3x.c
>>> +++ b/drivers/i2c/busses/i2c-rk3x.c
>>> @@ -428,18 +428,83 @@ out:
>>>         return IRQ_HANDLED;
>>>  }
>>>
>>> +static void rk3x_i2c_get_ratios(unsigned long scl_rate,
>>> +                               unsigned long *high_ratio,
>>> +                               unsigned long *low_ratio)
>>> +{
>>> +       /* As show in I2C specification:
>>> +        * - Standard-mode:
>>> +        *   the minimum HIGH period of the scl clock is 4.0us
>>> +        *   the minimum LOW period of the scl clock is 4.7us
>>> +        * - Fast-mode:
>>> +        *   the minimum HIGH period of the scl clock is 0.6us
>>> +        *   the minimum LOW period of the scl clock is 1.3us
>>> +        * - Fast-mode plus:
>>> +        *   the minimum HIGH period of the scl clock is 0.26us
>>> +        *   the minimum LOW period of the scl clock is 0.5us
>>> +        * - HS-mode(<1.7MHz):
>>> +        *   the minimum HIGH period of the scl clock is 0.12us
>>> +        *   the minimum LOW period of the scl clock is 0.32us
>>> +        * - HS-mode(<3.4MHz):
>>> +        *   the minimum HIGH period of the scl clock is 0.06us
>>> +        *   the minimum LOW period of the scl clock is 0.16us
>>
>> Is the rest of the driver ready for Fast-mode plus or HS mode?  If not
>> then maybe leave those off?  If nothing else the commit message should
>> indicate that this is just being forward thinking.
>>
>>> +        */
>>> +       if (scl_rate <= 100000) {
>>> +               *high_ratio = 40;
>>> +               *low_ratio = 47;
>>> +       } else if (scl_rate <= 400000) {
>>> +               *high_ratio = 6;
>>> +               *low_ratio = 13;
>>> +       } else if (scl_rate <= 1000000) {
>>> +               *high_ratio = 26;
>>> +               *low_ratio = 50;
>>> +       } else if (scl_rate <= 1700000) {
>>> +               *high_ratio = 12;
>>> +               *low_ratio = 32;
>>> +       } else {
>>> +               *high_ratio = 6;
>>> +               *low_ratio = 16;
>>
>> Since it's only the ratio of high to low that matters, you can combine
>> the last two.  12 : 32 == 6 : 16
>>
>>> +       }
>>> +}
>>> +
>>> +static void rk3x_i2c_calc_divs(unsigned long i2c_rate, unsigned long scl_rate,
>>> +                              unsigned long *divh, unsigned long *divl)
>>> +{
>>> +       unsigned long high_ratio, low_ratio;
>>> +       unsigned long ratio_sum;
>>> +
>>> +       rk3x_i2c_get_ratios(scl_rate, &high_ratio, &low_ratio);
>>> +       ratio_sum = high_ratio + low_ratio;
>>> +
>>> +       /* T_high = T_clk * (divh + 1) * 8
>>> +        * T_low = T_clk * (divl + 1) * 8
>>> +        * T_scl = T_high + T_low
>>> +        * T_scl = 1 / scl_rate
>>> +        * T_clk = 1 / i2c_rate
>>> +        * T_high : T_low = high_ratio : low_ratio
>>> +        * ratio_sum = high_ratio + low_ratio
>>> +        *
>>> +        * so:
>>> +        * divh = (i2c_rate * high_ratio) / (scl_rate * ratio_sum * 8) - 1
>>> +        * divl = (i2c_rate * low_ratio) / (scl_rate * ratio_sum * 8) - 1
>>> +        */
>>> +       *divh = DIV_ROUND_UP(i2c_rate * high_ratio, scl_rate * ratio_sum * 8);
>>> +       if (*divh)
>>> +               *divh = *divh - 1;
>>> +
>>> +       *divl = DIV_ROUND_UP(i2c_rate * low_ratio, scl_rate * ratio_sum * 8);
>>> +       if (*divl)
>>> +               *divl = *divl - 1;
>>
>> When I sent you the sample formulas I purposely did it differently
>> than this.  Any reason you changed from my formulas?
>>
>>   div_low = DIV_ROUND_UP(clk_rate * low_ratio, scl_rate * 8 * ratio_sum)
>>   div_high = DIV_ROUND_UP(clk_rate, scl_rate * 8) - div_low
>>
>>   div_low -= 1
>>   if div_high:
>>     div_high -= 1
>>
>> Why did I do it that way?
>>
>> * Assuming i2c_rate and the ratio is non-zero then you can assume that
>> DIV_ROUND_UP gives a value that is >= 1.  No need to test the result
>> against 0.
>>
>> * (I think) you'll get a more accurate clock rate by subtracting.
>>
>> Try running your formula vs. my formula with a ratio of 13 : 6, an i2c
>> rate of 12800000, and an scl rate of 400000
>>
>> Mine will get:
>>   Req = 400000, act = 400000, 1.88 us low, 0.62 us high, low/high = 3.00
>>
>> Yours will get:
>>   Req = 400000, act = 320000, 1.88 us low, 1.25 us high, low/high = 1.50
>>
> yes, you are right. yours is closer to the scl clock what we want to set.
>
> But if (clk_rate * low_ratio) can not be divisible by (scl_rate * 8 * ratio_sum),
> div_low will be round up, and div _high will be round down.
> The gap between div_low and div_high is increased.

Is that important?  As far as I can tell as long as we are meeting the
minimum requirements for low and high hold times then we're OK.


> so maybe we can set:
> div_high = DIV_ROUND_UP(clk_rate * high_ratio, scl_rate * 8 * ratio_sum)
> div_low = DIV_ROUND_UP(clk_rate, scl_rate * 8) - div_low
>
> i2c rate is 128Mhz:
> 1) calculate div_high first:
> div_high = DIV_ROUND_UP(clk_rate * high_ratio, scl_rate * 8 * ratio_sum)
> div_low = DIV_ROUND_UP(clk_rate, scl_rate * 8) - div_low
>
> req = 400000, act = 400000, div_high = 13, div_low = 27
>
> 2) calculate div_low first:
> div_low = DIV_ROUND_UP(clk_rate * low_ratio, scl_rate * 8 * ratio_sum)
> div_high = DIV_ROUND_UP(clk_rate, scl_rate * 8) - div_low
>
> req = 400000, act = 400000, div_high = 12, div_high = 28
>
> I think that the first is more appropriate.

I guess I was biasing towards making low a little longer instead of
biasing towards keeping high and low the same.  I'm not sure the bias
is terribly critical.

In any case, I spent more time testing and I realized that my old
formulas could potentially violate hold times because I wasn't careful
enough.  I've crafted some new code that is more careful to ensure
_both_ minimum hold times and minimum clock rate times.

Do you want to spin your patch with these new formulas, or do you
think I should?


(anyone else on the thread listening, feel free to comment).

---

def test_it(min_low_ns, min_high_ns, clk_rate, scl_rate):
  min_total_ns = min_low_ns + min_high_ns

  # We need the total div to be >= this number so we don't clock too fast.
  min_total_div = DIV_ROUND_UP(clk_rate, scl_rate * 8);

  # These are the min dividers needed for hold times.
  min_low_div = DIV_ROUND_UP(clk_rate * min_low_ns, 8 * 1000000000)
  min_high_div = DIV_ROUND_UP(clk_rate * min_high_ns, 8 * 1000000000)
  min_div_for_hold = (min_low_div + min_high_div)

  if min_div_for_hold > min_total_div:
    # Time needed to meet hold requirements is important.  Just use that
    div_low = min_low_div
    div_high = min_high_div
  else:
    # We've got to distribute some time among the low and high so we
    # don't run too fast.
    extra_div = min_total_div - min_div_for_hold

    # We'll try to split things up perfectly evenly, biasing slightly
    # towards having a higher div for low (spend more time low).
    ideal_low_div = DIV_ROUND_UP(clk_rate * min_low_ns,
                                 scl_rate * 8 * min_total_ns)

    # Handle when the ideal low div is going to take up more than we have
    if ideal_low_div > min_low_div + extra_div:
      assert ideal_low_div == min_low_div + extra_div + 1
      ideal_low_div = min_low_div + extra_div

    # Give low the "ideal" and give high whatever extra is left.
    div_low = ideal_low_div
    div_high = min_high_div + (extra_div - (ideal_low_div - min_low_div))

  # Adjust to the fact that the hardware has an implicit "+1".
  # NOTE: Above calculations always produce div_low > 0 and  div_high > 0.
  div_low -= 1
  div_high -= 1

  T_pclk_us = 1000000. / clk_rate
  T_sclk_us = 1000000. / scl_rate

  T_low_us = T_pclk_us * (div_low + 1) * 8
  T_high_us = T_pclk_us * (div_high + 1) * 8

  T_tot_us = (T_high_us + T_low_us)
  freq = 1000000. / T_tot_us

  if T_low_us * 1000 < min_low_ns:
    print "ERROR: not low long enough"
  if T_high_us * 1000 < min_high_ns:
    print "ERROR: not high long enough"

  print "CLK = %d, Req = %d, act = %.2f, %.2f us low, " \
        "%.2f us high, low/high = %.2f" % (
        clk_rate, scl_rate, freq, T_low_us,
        T_high_us, T_low_us / T_high_us)

  return (clk_rate, scl_rate, freq, T_low_us, T_high_us)

test_it(4700, 4000, 1484000, 100000)
test_it(4700, 4000, 2000001, 100000)
test_it(4700, 4000, 74250000, 99799)
test_it(4700, 4000, 74250000, 99798)
test_it(4700, 4000, 74250000, 99797)
test_it(4700, 4000, 74250000, 100000)

test_it(1300, 600,   5000000, 400000)
test_it(1300, 600,   9400000, 400000)

test_it(1300,  600, 74250000, 400000)
test_it(1300,  600, 12800000, 400000)
test_it(1300,  600,  6400000, 400000)
test_it(1300,  600,  3200000, 400000)
test_it(1300,  600,  1600000, 400000)
test_it(1300,  600,   800000, 400000)

for i in xrange(800000, 74250000, 100):
  test_it(4700, 4000, i, 100000)

for i in xrange(800000, 74250000, 100):
  test_it(1300, 600, i, 400000)
