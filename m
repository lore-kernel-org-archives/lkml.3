Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934298AbaHZJre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 05:47:34 -0400
Received: from regular1.263xmail.com ([211.150.99.139]:46847 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262AbaHZJrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 05:47:32 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: zyw@rock-chips.com
X-FST-TO: dianders@chromium.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: zyw@rock-chips.com
X-UNIQUE-TAG: <f8c1090dfa5ecd4ff08242a9b424bf57>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <53FC579C.50507@rock-chips.com>
Date: Tue, 26 Aug 2014 17:47:08 +0800
From: Chris Zhong <zyw@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Mike Turquette <mturquette@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com, Grant Likely <grant.likely@linaro.org>,
        Lin Huang <hl@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, zhangqing <zhangqing@rock-chips.com>,
        xxx <xxx@rock-chips.com>,
        =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Dmitry Torokhov <dtor@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kever Yang <kever.yang@rock-chips.com>
Subject: Re: [PATCH v5 3/5] RTC: RK808: add RTC driver for RK808
References: <1408973668-21436-1-git-send-email-zyw@rock-chips.com> <CAD=FV=VYJvgXXcYkq+vcpZkXZBDbgfRGNyF8GA6MnvMAGaAebQ@mail.gmail.com>
In-Reply-To: <CAD=FV=VYJvgXXcYkq+vcpZkXZBDbgfRGNyF8GA6MnvMAGaAebQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 08/26/2014 11:22 AM, Doug Anderson wrote:
>> +       int ret;
>> >+
>> >+       /* Has the RTC been programmed? */
>> >+       ret = regmap_update_bits(rk808->regmap, RK808_RTC_CTRL_REG,
>> >+                                BIT_RTC_CTRL_REG_RTC_V_OPT_M, 0);
> Can you explain what you're doing here?  The comment seems wrong since
> it implies that you're checking something.
>
> >From what I can tell from the manual you're setting "RTC_READSEL" to 0
> which means "Read access directly to dynamic registers.".  That's not
> clear here, and RTC_V_OPT_M makes no sense to me.

RK808 has a shadowed register for saving a "frozen" RTC time.
When user setting "RTC_READSEL" to 1, the time will save in this 
shadowed register.
In this case, user read rtc time register, actually get the time of that 
moment.
So, I move it to probe, this bit needn't clear every time
>> >+       tm->tm_min = bcd2bin(rtc_data[1]) & MINUTES_REG_MAK;
>> >+       tm->tm_hour = bcd2bin(rtc_data[2]) & HOURS_REG_MSK;
>> >+       tm->tm_mday = bcd2bin(rtc_data[3]) & DAYS_REG_MSK;
>> >+       tm->tm_mon = (bcd2bin(rtc_data[4]) & MONTHS_REG_MSK) - 1;
>> >+       tm->tm_year = (bcd2bin(rtc_data[5]) & YEARS_REG_MSK) + 100;
>> >+       tm->tm_wday = bcd2bin(rtc_data[6]) & WEEKS_REG_MSK;
>> >+       dev_dbg(dev, "RTC date/time %4d-%02d-%02d(%d) %02d:%02d:%02d\n",
>> >+               1900 + tm->tm_year, tm->tm_mon + 1, tm->tm_mday,
>> >+               tm->tm_wday, tm->tm_hour , tm->tm_min, tm->tm_sec);
>> >+
>> >+       return 0;
>> >+}
>> >+
>> >+/*
>> >+ * Set current time and date in RTC
>> >+ */
>> >+static int rk808_rtc_set_time(struct device *dev, struct rtc_time *tm)
> Make this "const struct rtc_time *tm"
It will be a warning if add const.
It should be match
int (*set_time)(struct device *, struct rtc_time *);
in rtc.h
>
>> +               rk808_rtc_set_time(&pdev->dev, &tm_def);
>> >+       }
>> >+
>> >+       device_init_wakeup(&pdev->dev, 1);
> You can skip this.  We'll set "wakeup-source" in the device tree.
> That will set I2C_CLIENT_WAKE.  That will cause the i2c core to call
> device_init_wakeup() for you.
If I remove it, wakealarm is disappear, even though I add 
"wakeup-source" in device tree.
So, I keep it temporarily
>
>> +       if (IS_ERR(rk808_rtc->rtc)) {
>> >+               ret = PTR_ERR(rk808_rtc->rtc);
>> >+               return ret;
>> >+       }
>> >+
>> >+       alm_irq  = platform_get_irq(pdev, 0);
> Are you sure that platform_get_irq() works in this case?  In Javier's
> in-flight max77802 driver he use regmap_irq_get_virq().
>
> ...oh, maybe your way does work!  You've got the rtc_resources to
> specify things, so that looks good...
>
> ...but I tried testing it by doing:
>
> cd /sys/class/rtc/rtc0
> echo +2 > wakealarm
> sleep 5
> grep 808 /proc/interrupts
>
> ...and I didn't see an interrupt go off.  Any idea why?
It works well.





