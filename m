Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbaI3WXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 18:23:40 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:44542 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbaI3WXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 18:23:37 -0400
MIME-Version: 1.0
In-Reply-To: <54290E21.2030007@rock-chips.com>
References: <1411801888-3152-1-git-send-email-addy.ke@rock-chips.com>
	<CAD=FV=XnM-2CuctP-L=-gj7TPyMXrkhsDS9Tmxeq+9Mx5p7PZA@mail.gmail.com>
	<54290E21.2030007@rock-chips.com>
Date: Tue, 30 Sep 2014 15:23:36 -0700
X-Google-Sender-Auth: WLWxy1M6WPLSgbFQq3b4IAzTTks
Message-ID: <CAD=FV=URH+jCspEmjDjF01DW2AfO=k5Nw9mt1BYiCMm8rrNDPw@mail.gmail.com>
Subject: Re: [PATCH v2] i2c: rk3x: adjust the LOW divison based on
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

On Mon, Sep 29, 2014 at 12:45 AM, addy ke <addy.ke@rock-chips.com> wrote:
> Hi Doug
>
> On 2014/9/29 12:39, Doug Anderson wrote:
>> Addy,
>>
>> On Sat, Sep 27, 2014 at 12:11 AM, Addy Ke <addy.ke@rock-chips.com> wrote:
>>> From: Addy <addy.ke@rock-chips.com>
>>>
>>> As show in I2C specification:
>>> - Standard-mode: the minimum HIGH period of the scl clock is 4.0us
>>>                  the minimum LOW period of the scl clock is 4.7us
>>> - Fast-mode: the minimum HIGH period of the scl clock is 0.6us
>>>              the minimum LOW period of the scl clock is 1.3us
>>>
>>> I have measured i2c SCL waveforms in fast-mode by oscilloscope
>>> on rk3288-pinky board. the LOW period of the scl clock is 1.3us.
>>> It is so critical that we must adjust LOW division to increase
>>> the LOW period of the scl clock.
>>>
>>> After put this patch, we can find that min_low_ns is about
>>> 5.4us in Standard-mode and 1.6us in Fast-mode.
>>>
>>> Thanks Doug for the suggestion about division formulas.
>>>
>>> Signed-off-by: Addy <addy.ke@rock-chips.com>
>>> ---
>>> Changes in v2:
>>> - remove Fast-mode plus and HS-mode
>>> - use new formulas suggested by Doug
>>>
>>>  drivers/i2c/busses/i2c-rk3x.c | 104 +++++++++++++++++++++++++++++++++++++++---
>>>  1 file changed, 97 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/drivers/i2c/busses/i2c-rk3x.c b/drivers/i2c/busses/i2c-rk3x.c
>>> index e637c32..81672a8 100644
>>> --- a/drivers/i2c/busses/i2c-rk3x.c
>>> +++ b/drivers/i2c/busses/i2c-rk3x.c
>>> @@ -428,19 +428,109 @@ out:
>>>         return IRQ_HANDLED;
>>>  }
>>>
>>> +static void rk3x_i2c_get_min_ns(unsigned int scl_rate,
>>> +                               unsigned long *min_low_ns,
>>> +                               unsigned long *min_high_ns)
>>> +{
>>> +       WARN_ON(scl_rate > 400000);
>>> +
>>> +       /* As show in I2C specification:
>>> +        * - Standard-mode(100KHz):
>>> +        *   min_low_ns is 4700ns
>>> +        *   min_high_ns is 4000ns
>>> +        * - Fast-mode(400KHz):
>>> +        *   min_low_ns is 1300ns
>>> +        *   min_high_ns is 600ns
>>> +        *
>>> +        * (min_low_ns + min_high_ns) up to 10000ns in Standard-mode
>>> +        * and 2500ns in Fast-mode
>>> +        */
>>> +       if (scl_rate <= 100000) {
>>> +               *min_low_ns = 4700 + 650;
>>> +               *min_high_ns = 4000 + 650;
>>> +       } else {
>>> +               *min_low_ns = 1300 + 300;
>>> +               *min_high_ns = 600 + 300;
>>
>> Wait, where did the extra 650 and 300 come from here?  Are you just
>> trying to balance things out?  That's not the right way to do things.
>> Please explain what you were trying to accomplish and we can figure
>> out a better way.
>>
>> ...maybe this helped make thins nicer in the clock rates you tried,
>> but I'd bet that I can find clock rates that this is broken for...
>>
>>
> 650 = [(1000000000/100K) ns - min_low_ns_100k - min_high_ns_100k] / 2
> 300 = [(1000000000/300K) ns - min_low_ns_400k - min_high_ns_400k] / 2
>
> if there is no extra 650 and 300:
> extra_div is 3 in fast-mode and 11 in standard-mode.

Umm, OK.  Except that "min_low_ns" is no longer the actual minimum
"ns" we need according to the spec.  That will mean that you're
sometimes going to end up with a clock rate that's slower than you
want.


>   1)if all of the "extra" is asssigned to the high part, the LOW period is too close to min_low.
>     In my test:
>     400k, scl_low_ns: 1440ns, scl_high_ns: 1120ns
>     100k, scl_low_ns: 4800ns, scl_high_ns: 5120ns

Why does it matter if it's close to "min_low"?  It's above the minimum
so it's fine, right?  If you need a buffer, add an explicit buffer to
the calculations.


>   2)if not, dato hold time is too close to min_hold_time(400khz, 900ns)
>     In my test:
>     400k, scl_low_ns: 1760ns, scl_high_ns: 800ns
>     100k, scl_low_ns: 5304ns, scl_high_ns: 4368ns
>
>     hold_time_ns ~= scl_low_ns / 2 = 880ns

It's still under, though.  Why does this matter?  Again, if you need a
buffer then add a buffer.


> So I think we must decrease min_low_ns:min_high_ns to decrease scl_low in case 2
>
> So I set the extra 650 and 300.
>
> After this, in my test:
>    400k, scl_low_ns: 1600ns, scl_high_ns: 960ns
>    100k, scl_low_ns: 5200ns, scl_hign_ns: 4576ns
>
> I think this value is more reasonable.

You're testing with a very particular clock input rate.  The function
needs to be general and work across a lot of different input clock
rates.  That's why my python code has loops in it to test the results
over a huge variety of input clock rates...

---

Here are a few examples of differences (SEP 30 is my new proposal below):

With this example your code produces a slightly slower clock rate than
desirable:

SEP 30: CLK = 74250000, Req = 100000, act = 99798.39, 5.49 us low,
4.53 us high, low/high = 1.21 (50 41)
AddyV2: CLK = 74250000, Req = 100000, act = 98736.70, 5.39 us low,
4.74 us high, low/high = 1.14 (49 43)

Here's another example where your patch doesn't produce ideal timings
(in this case the difference is more pronounced)

SEP 30: CLK = 66380000, Req = 400000, act = 395119.05, 1.69 us low,
0.84 us high, low/high = 2.00 (13 6)
AddyV2: CLK = 66380000, Req = 400000, act = 377159.09, 1.69 us low,
0.96 us high, low/high = 1.75 (13 7)

Here's an example your code violates timings (true, a 1.61MHz clock
isn't super realistic in rk3288, but it does show a non-ideal case):

SEP 30: CLK = 1610000, Req = 100000, act = 67083.33, 4.97 us low, 9.94
us high, low/high = 0.50 (0 1)
AddyV2: CLK = 1610000, Req = 100000, act = 67083.33, 9.94 us low, 4.97
us high, low/high = 2.00 (1 0)
...ERROR: low too long 9.94 us > 6.85 us (/2 4.97 us > 3.42 us) (conflicting=0)

---

I'll paste new code here with a proposal that adds a buffer (could be
0) and also send you an attachment in a separate email (I can't quite
believe that the lists will handle attachments).

One thing you'll notice is that with sufficiently slow input clocks
it's possible to get into a state where we can't meet both the minimum
and maximum times for SCL being low.  This probably isn't super
realistic, but the code could certainly have a warning.

---

def DIV_ROUND_UP(a, b): return (a + b - 1) // b

# This is bassed on v2 sent by Addy (fixed DIV_ROUND_UP)
def test_it_addy_v2(min_low_ns, min_high_ns, max_low_ns, i2c_rate, scl_rate):
  # Add the buffer in suggested by addy
  if min_low_ns == 4700:
    min_low_ns += 650
    min_high_ns += 650
  else:
    min_low_ns += 300
    min_high_ns += 300

  min_total_ns = min_low_ns + min_high_ns

  # Adjust to avoid overflow
  i2c_rate_khz = DIV_ROUND_UP(i2c_rate, 1000)
  scl_rate_khz = DIV_ROUND_UP(scl_rate, 1000)

  # We need the total div to be >= this number so we don't clock too fast.
  min_total_div = DIV_ROUND_UP(i2c_rate_khz, scl_rate_khz * 8);

  # These are the min dividers needed for min hold times.
  min_low_div = DIV_ROUND_UP(i2c_rate_khz * min_low_ns, 8 * 1000000)
  min_high_div = DIV_ROUND_UP(i2c_rate_khz * min_high_ns, 8 * 1000000)
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
    ideal_low_div = DIV_ROUND_UP(i2c_rate_khz * min_low_ns,
                                 scl_rate_khz * 8 * min_total_ns)

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

  return div_low, div_high, False # Note: we don't calculate "conflicting"

# test_it_sep30 - Sept 30th proposal for i2c stuff
#
# min_low_ns:  The minimum number of ns we need to hold low to meet i2c spec
# min_high_ns: The minimum number of ns we need to hold high to meet i2c spec
# max_low_ns:  The maximum number of ns we can hold low to meet i2c spec
#
# Note: max_low_ns should be (max data hold time * 2 - buffer)
#       This is because the i2c host on Rockchip holds the data line for
#       half the low time.
def test_it_sep30(min_low_ns, min_high_ns, max_low_ns, i2c_rate, scl_rate):
  min_total_ns = min_low_ns + min_high_ns

  # Adjust to avoid overflow
  i2c_rate_khz = DIV_ROUND_UP(i2c_rate, 1000)
  scl_rate_khz = DIV_ROUND_UP(scl_rate, 1000)

  # We need the total div to be >= this number so we don't clock too fast.
  min_total_div = DIV_ROUND_UP(i2c_rate_khz, scl_rate_khz * 8);

  # These are the min dividers needed for min hold times.
  min_low_div = DIV_ROUND_UP(i2c_rate_khz * min_low_ns, 8 * 1000000)
  min_high_div = DIV_ROUND_UP(i2c_rate_khz * min_high_ns, 8 * 1000000)
  min_div_for_hold = (min_low_div + min_high_div)

  # This is the maximum divider so we don't go over the max.  We don't round up
  # here (we round down) since this is a max.
  max_low_div = i2c_rate_khz * max_low_ns / (8 * 1000000)

  # Giving different rounding, it's possible that min > max (!?!)  We're
  # totally out of luck in that case, so let's go with getting clocks
  # right I guess...
  if min_low_div > max_low_div:
    # print "WARNING: conflicting restrictions"
    conflicting = True
    max_low_div = min_low_div
  else:
    conflicting = False

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
    ideal_low_div = DIV_ROUND_UP(i2c_rate_khz * min_low_ns,
                                 scl_rate_khz * 8 * min_total_ns)

    # Don't allow it to go over the max
    if ideal_low_div > max_low_div:
      ideal_low_div = max_low_div

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

  return div_low, div_high, conflicting

def print_it(label, min_low_ns, min_high_ns, max_low_ns, i2c_rate, scl_rate,
             div_low, div_high, conflicting):
  T_pclk_us = 1000000. / i2c_rate
  T_sclk_us = 1000000. / scl_rate

  T_low_us = T_pclk_us * (div_low + 1) * 8
  T_high_us = T_pclk_us * (div_high + 1) * 8

  T_tot_us = (T_high_us + T_low_us)
  freq = 1000000. / T_tot_us

  print "%s: CLK = %d, Req = %d, act = %.2f, %.2f us low, " \
        "%.2f us high, low/high = %.2f (%d %d)" % (
        label,
        i2c_rate, scl_rate, freq, T_low_us,
        T_high_us, T_low_us / T_high_us, div_low, div_high)

  if T_low_us * 1000 < min_low_ns:
    print "...ERROR: not low long enough"
  if T_high_us * 1000 < min_high_ns:
    print "...ERROR: not high long enough"

  if T_low_us * 1000 > max_low_ns:
    print "...ERROR: low too long %.2f us > %.2f us " \
      "(/2 %.2f us > %.2f us) (conflicting=%d)" % (
      T_low_us, max_low_ns / 1000.,
      T_low_us / 2., max_low_ns / 2000.,
      conflicting)
  elif conflicting:
    print "...Conflicting, but not low too long?"

  return (i2c_rate, scl_rate, freq, T_low_us, T_high_us)


def test_it(min_low_ns, min_high_ns, max_low_ns, i2c_rate, scl_rate):
  sep30 = test_it_sep30(min_low_ns, min_high_ns, max_low_ns,
                        i2c_rate, scl_rate)
  addy_v2 = test_it_addy_v2(min_low_ns, min_high_ns, max_low_ns,
                            i2c_rate, scl_rate)

  print_it("SEP 30", min_low_ns, min_high_ns, max_low_ns,
           i2c_rate, scl_rate, sep30[0], sep30[1], sep30[2])
  print_it("AddyV2", min_low_ns, min_high_ns, max_low_ns,
           i2c_rate, scl_rate, addy_v2[0], addy_v2[1], addy_v2[2])

  # Test to see where results are differet
  #if (sep30[0], sep30[1]) != (addy_v2[0], addy_v2[1]):
  #  print_it("SEP 30", min_low_ns, min_high_ns, max_low_ns,
  #           i2c_rate, scl_rate, sep30[0], sep30[1], sep30[2])
  #  print_it("AddyV2", min_low_ns, min_high_ns, max_low_ns,
  #           i2c_rate, scl_rate, addy_v2[0], addy_v2[1], addy_v2[2])

  # Test to see where clock rates are different.
  #if (sep30[0] + sep30[1]) != (addy_v2[0] + addy_v2[1]):
  #  print_it("SEP 30", min_low_ns, min_high_ns, max_low_ns,
  #           i2c_rate, scl_rate, sep30[0], sep30[1], sep30[2])
  #  print_it("AddyV2", min_low_ns, min_high_ns, max_low_ns,
  #           i2c_rate, scl_rate, addy_v2[0], addy_v2[1], addy_v2[2])


min_low_std_ns = 4700
min_high_std_ns = 4000
max_data_hold_std_ns = 3450
data_hold_buffer_std_ns = 50

min_low_fast_ns =  1300
min_high_fast_ns = 600
max_data_hold_fast_ns = 900
data_hold_buffer_fast_ns = 50

test_it(min_low_std_ns, min_high_std_ns,
        max_data_hold_std_ns * 2 - data_hold_buffer_std_ns, 74250000, 100000)
test_it(min_low_std_ns, min_high_std_ns,
        max_data_hold_std_ns * 2 - data_hold_buffer_std_ns,  2000001, 100000)
test_it(min_low_std_ns, min_high_std_ns,
        max_data_hold_std_ns * 2 - data_hold_buffer_std_ns,  1610000, 100000)
test_it(min_low_std_ns, min_high_std_ns,
        max_data_hold_std_ns * 2 - data_hold_buffer_std_ns,  1484000, 100000)

test_it(min_low_fast_ns, min_high_fast_ns,
        max_data_hold_fast_ns * 2 - data_hold_buffer_fast_ns, 66380000, 400000)
test_it(min_low_fast_ns, min_high_fast_ns,
        max_data_hold_fast_ns * 2 - data_hold_buffer_fast_ns, 74250000, 400000)
test_it(min_low_fast_ns, min_high_fast_ns,
        max_data_hold_fast_ns * 2 - data_hold_buffer_fast_ns, 12800000, 400000)
test_it(min_low_fast_ns, min_high_fast_ns,
        max_data_hold_fast_ns * 2 - data_hold_buffer_fast_ns,  9400000, 400000)
test_it(min_low_fast_ns, min_high_fast_ns,
        max_data_hold_fast_ns * 2 - data_hold_buffer_fast_ns,  6400000, 400000)
test_it(min_low_fast_ns, min_high_fast_ns,
        max_data_hold_fast_ns * 2 - data_hold_buffer_fast_ns,  5000000, 400000)
test_it(min_low_fast_ns, min_high_fast_ns,
        max_data_hold_fast_ns * 2 - data_hold_buffer_fast_ns,  3200000, 400000)
test_it(min_low_fast_ns, min_high_fast_ns,
        max_data_hold_fast_ns * 2 - data_hold_buffer_fast_ns,  1600000, 400000)
test_it(min_low_fast_ns, min_high_fast_ns,
        max_data_hold_fast_ns * 2 - data_hold_buffer_fast_ns,   800000, 400000)

#for i in xrange(74250000, 800000, -100):
#  test_it(min_low_std_ns, min_high_std_ns,
#          max_data_hold_std_ns * 2 - data_hold_buffer_std_ns,  i, 100000)
#
#for i in xrange(74250000, 800000, -100):
#  test_it(min_low_fast_ns, min_high_fast_ns,
#          max_data_hold_fast_ns * 2 - data_hold_buffer_fast_ns, i, 400000)

---

-Doug
