Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442AbaJNODQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 10:03:16 -0400
Received: from regular1.263xmail.com ([211.150.99.134]:53213 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180AbaJNODM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 10:03:12 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: caesar.wang@rock-chips.com
X-FST-TO: zhengsq@rock-chips.com
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: caesar.wang@rock-chips.com
X-UNIQUE-TAG: <225c76894833154c3ba531a8ea0efd1b>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <543D2D14.7000706@rock-chips.com>
Date: Tue, 14 Oct 2014 22:03:00 +0800
From: Caesar Wang <caesar.wang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        zyf <zyf@rock-chips.com>, linux-rockchip@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Eddie Cai <cf@rock-chips.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Derek Basehore <dbasehore@chromium.org>,
        Tao Huang <huangtao@rock-chips.com>,
        =?UTF-8?B?6ZmI5riQ6aOe?= <cjf@rock-chips.com>,
        Shunqian Zheng <zhengsq@rock-chips.com>
Subject: Re: [PATCH v9 1/5] thermal: rockchip: add driver for thermal
References: <1413012563-7690-1-git-send-email-caesar.wang@rock-chips.com>	<1413012563-7690-2-git-send-email-caesar.wang@rock-chips.com> <CAD=FV=XHe65wwf8Q9RA0ZDgb5oQLdyjuZDFy4mD01_t6G6WnHQ@mail.gmail.com>
In-Reply-To: <CAD=FV=XHe65wwf8Q9RA0ZDgb5oQLdyjuZDFy4mD01_t6G6WnHQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug,

在 2014年10月14日 00:11, Doug Anderson 写道:
> Caesar,
>
> On Sat, Oct 11, 2014 at 12:29 AM, Caesar Wang
> <caesar.wang@rock-chips.com> wrote:
>
>> +static void rk_tsadcv2_initialize(int reset_mode, int chn, void __iomem *regs,
>> +                                 unsigned long hw_shut_temp)
>> +{
>> +       u32 shutdown_value;
>> +
>> +       shutdown_value = rk_tsadcv2_temp_to_code(hw_shut_temp);
>> +
>> +       /* Enable measurements at ~ 10 Hz */
>> +       writel_relaxed(0 | TSADCV2_AUTO_TSHUT_POLARITY_HIGH, regs +
>> +                      TSADCV2_AUTO_CON);
>> +       writel_relaxed(TSADCV2_AUTO_PERIOD_TIME, regs + TSADCV2_AUTO_PERIOD);
>> +       writel_relaxed(TSADCV2_AUTO_PERIOD_HT_TIME, regs +
>> +                      TSADCV2_AUTO_PERIOD_HT);
>> +       writel_relaxed(shutdown_value, regs + TSADCV2_COMP_SHUT(chn));
>> +       writel_relaxed(TSADCV2_HIGHT_INT_DEBOUNCE_TIME, regs +
>> +                      TSADCV2_HIGHT_INT_DEBOUNCE);
>> +       writel_relaxed(TSADCV2_HIGHT_TSHUT_DEBOUNCE_TIME, regs +
>> +                      TSADCV2_HIGHT_TSHUT_DEBOUNCE);
>> +
>> +       if (reset_mode == GPIO)
>> +               writel_relaxed(TSADCV2_SHUT_2GPIO_SRC_EN(chn) |
>> +                              TSADCV2_INT_SRC_EN(chn), regs +
>> +                              TSADCV2_INT_EN);
>> +       else
>> +               writel_relaxed(TSADCV2_SHUT_2CRU_SRC_EN(chn) |
>> +                              TSADCV2_INT_SRC_EN(chn) , regs +
>> +                              TSADCV2_INT_EN);
>> +
>> +       writel_relaxed(TSADCV2_AUTO_SRC_EN(chn) | TSADCV2_AUTO_EN, regs +
>> +                      TSADCV2_AUTO_CON);
> Aren't you clobbering the polarity here?
>
> NOTE: I didn't do a full review of this driver, just noticed that
> while looking at another patch and figure'd I'd respond here, too.
>
Fixed. Maybe I should fix as follows:

/**
  * rk_tsadcv2_get_tshut_polarity - get the tshut polarity
  * the bit 8 is tshut polarity,default is low active.
  * 0: low active, 1: high active
  */
static bool rk_tsadcv2_get_tshut_polarity(void __iomem *regs)
{
     u32 val;
     bool tshut_polarity;

     val = readl_relaxed(regs + TSADCV2_AUTO_CON);
     tshut_polarity = (val & BIT(8))? 1 : 0;

     return tshut_polarity;
}
...
....

writel_relaxed(TSADCV2_AUTO_SRC_EN(chn) & (tshut_polarity << 8) |
		       TSADCV2_AUTO_EN, regs + TSADCV2_AUTO_CON);

>

-- 
Best regards,
Caesar


