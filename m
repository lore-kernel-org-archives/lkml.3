Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbaAJCEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 21:04:31 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:49681 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751745AbaAJCE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 21:04:29 -0500
From: Neil Zhang <zhangwm@marvell.com>
To: Gerhard Sittig <gsi@denx.de>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "gnurou@gmail.com" <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 9 Jan 2014 18:04:18 -0800
Subject: RE: [PATCH] gpio: pxa: fix bug when get gpio value
Thread-Topic: [PATCH] gpio: pxa: fix bug when get gpio value
Thread-Index: Ac8NKAOINAv3OekORZaoM6zWeueMugAfw67Q
Message-ID: <175CCF5F49938B4D99B2E3EF7F558EBE540BD53A96@SC-VEXCH4.marvell.com>
References: <1389259557-1731-1-git-send-email-zhangwm@marvell.com>
 <20140109104604.GT20094@book.gsilab.sittig.org>
In-Reply-To: <20140109104604.GT20094@book.gsilab.sittig.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-01-09_07:2014-01-09,2014-01-09,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1401090208
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s0A24ZAl006111

Gerhard

Firstly thanks for your comments.

> -----Original Message-----
> From: Gerhard Sittig [mailto:gsi@denx.de]
> Sent: 2014Äê1ÔÂ9ÈÕ 18:46
> To: Neil Zhang
> Cc: linus.walleij@linaro.org; gnurou@gmail.com; linux-gpio@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] gpio: pxa: fix bug when get gpio value
> 
> On Thu, Jan 09, 2014 at 17:25 +0800, Neil Zhang wrote:
> >
> > gpio_get_value should return 0 or 1.
> >
> > I have checked mach-mmp / mach-pxa / plat-pxa / plat-orion / mach-orion5x.
> > It's OK for all of them to change this function to return 0 and 1.
> >
> > [ ... ]
> >
> >  static int pxa_gpio_get(struct gpio_chip *chip, unsigned offset)  {
> > -	return readl_relaxed(gpio_chip_base(chip) + GPLR_OFFSET) & (1 <<
> offset);
> > +	u32 gplr = readl_relaxed(gpio_chip_base(chip) + GPLR_OFFSET);
> > +	return !!(gplr & (1 << offset));
> >  }
> 
> This may be a stupid question, but isn't the "!!value" syntax just replacing one
> kind of "zero or non-zero" with another kind of "zero or non-zero"?  This
> phrase is used to normalize booleans, but ISTR there is no guarantee that true
> needs to equal the value of 1.
> 
> Here is why I'm asking:  Is there a need from GPIO get_value() routines to
> return normalized values, and if so should not more drivers receive an update?
> Or need get_value() routines just return the usual integer zero/non-zero values
> (as is the convention in the C programming language) and GPIO using callers
> should know that they are not exactly 0 and 1?
>
> The latter would make this change for PXA unneeded (nice to have but not
> essential), and both the commit message as well as the subject line at least need
> to get re-phrased, as the "bug" is in the caller's expectation and not in the GPIO
> chip driver.
>

Yes, the API doesn't mandatory expect 0 and 1 as I can see.
But actually many driver will return a normalized value.
So people may think it's return value is 0 or 1.
It would be convenient to normalized the return value for gpio-pxa too.

You are right, it's not appropriate to use "bug" in the patch title, thanks.

> Please note that I'm not questioning the patches' being applicable, but am trying
> to find out what else needs to be done which previously may have gone
> unnoticed.  A doc update maybe, to make GPIO users aware that the return
> value may not be exactly 1, and to clear up where such an assumption is wrongly
> made.
> 
> If the GPIO subsystem's API wants to guarantee values of 0 and 1 (which I think it
> doesn't), then I feel the adjustment should be done in the gpio_get_value()
> routines (in all its public variants, or a common routine which all of them pass
> through), and certainly not in individual chip drivers.
> 
> 
> virtually yours
> Gerhard Sittig
> --
> DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
> HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
> Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de

Best Regards,
Neil Zhang
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
