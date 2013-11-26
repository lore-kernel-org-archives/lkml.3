Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072Ab3KZO0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 09:26:19 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:28739 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754797Ab3KZO0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 09:26:16 -0500
X-AuditID: cbfec7f5-b7f706d0000017c2-58-5294af8638b6
Message-id: <1385475972.30026.3.camel@AMDC1943>
Subject: Re: [PATCH 1/5] rtc: s5m: Fix register updating by adding regmap for
 RTC
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Date: Tue, 26 Nov 2013 15:26:12 +0100
In-reply-to: <CAMuHMdWdu2TsvUwmJ4rk3xhMXn4L7MQxdTWRvt80hNttt2sAfA@mail.gmail.com>
References: <1385473828-31078-1-git-send-email-k.kozlowski@samsung.com>
 <1385473828-31078-2-git-send-email-k.kozlowski@samsung.com>
 <CAMuHMdWdu2TsvUwmJ4rk3xhMXn4L7MQxdTWRvt80hNttt2sAfA@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t/xq7pt66cEGbzt5LdYcvEqu8WzW3uZ
	LM42vWG3uP/1KKPF5V1z2CzWHrnLbrG/s4PR4nQ3q8XFFV+YHDg99kw8yeZx59oeNo9DhzsY
	PeadDPTo27KK0WP6vJ9MHp83yQWwR3HZpKTmZJalFunbJXBlvO95wViwhrdi3ad7zA2Ma7m6
	GDk4JARMJO5cz+ti5AQyxSQu3FvP1sXIxSEksJRR4uG7U8wgCSGBz4wSX+aUg9i8AvoSzdc/
	s4HYwgLBEgeWHWUEsdkEjCU2L1/CBjJTREBXYs5PJpA5zAKXmCTOH3nEAlLDIqAqMev+czCb
	E6j31s9nLBDLzjBKHDnbyQSSYBZQl5g0bxEzxEVKErvbO9kh4vISm9e8ZYY4QlDix+R7LBMY
	BWYhaZmFpGwWkrIFjMyrGEVTS5MLipPSc430ihNzi0vz0vWS83M3MUIi4esOxqXHrA4xCnAw
	KvHwSnRODhJiTSwrrsw9xCjBwawkwhs7fUqQEG9KYmVValF+fFFpTmrxIUYmDk6pBka35MI9
	ZstaphcI5k1PP9zn7aWSO+nowYuaN/9/Nn3qliwbtVAnJf+7oG/U5FKjrBPrdZcJMT9dtzNr
	+s6gCZvul5/+8tR6r0XcZv7SJt2t+g2Nmt3T7k5+fIObedn9HueXD2582/Do6e+DR2ZdW8+2
	ZeXe37wPbCvsmgsnP7YUX8O93mFionysEktxRqKhFnNRcSIAv2MnhGICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-26 at 15:07 +0100, Geert Uytterhoeven wrote:
> On Tue, Nov 26, 2013 at 2:50 PM, Krzysztof Kozlowski
> <k.kozlowski@samsung.com> wrote:
> > On S5M8767A registers were not properly updated and read due to usage of
> > the same regmap as the PMIC. This could be observed in various hangs,
> > e.g. in infinite loop during waiting for UDR field change.
> >
> > On this chip family the RTC has different I2C address than PMIC so
> > additional regmap is needed.
> >
> > Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  drivers/mfd/sec-core.c           |   14 ++++++++++++++
> >  drivers/rtc/rtc-s5m.c            |    2 +-
> >  include/linux/mfd/samsung/core.h |    1 +
> >  3 files changed, 16 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
> > index 34c18fb..a1a413a 100644
> > --- a/drivers/mfd/sec-core.c
> > +++ b/drivers/mfd/sec-core.c
> > @@ -166,6 +166,11 @@ static struct regmap_config s5m8767_regmap_config = {
> >         .cache_type = REGCACHE_FLAT,
> >  };
> >
> > +static struct regmap_config sec_rtc_regmap_config = {
> 
> const please

Sure.

> > --- a/include/linux/mfd/samsung/core.h
> > +++ b/include/linux/mfd/samsung/core.h
> > @@ -40,6 +40,7 @@ struct sec_pmic_dev {
> >         struct device *dev;
> >         struct sec_platform_data *pdata;
> >         struct regmap *regmap;
> > +       struct regmap *regmap_rtc;
> 
> Do you think it makes sense to rename the plain "regmap" to "regmap_pmic"?

Yes, I think it would make the code more readable. I'll change it.

Best regards,
Krzysztof

