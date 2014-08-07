Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807AbaHGNTD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 09:19:03 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:51153 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757564AbaHGNTB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 09:19:01 -0400
Date: Thu, 7 Aug 2014 15:18:42 +0200
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: "fugang.duan@freescale.com" <fugang.duan@freescale.com>
Cc: Yao Yuan <yao.yuan@freescale.com>, "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "marex@denx.de" <marex@denx.de>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "Frank.Li@freescale.com" <Frank.Li@freescale.com>
Subject: Re: [PATCH v6 1/2] i2c: imx: add DMA support for freescale i2c
 driver
Message-ID: <20140807151842.1dddaf24@ipc1.ka-ro>
In-Reply-To: <6537011f698c4c7faaf5b66b870afbd2@BLUPR03MB373.namprd03.prod.outlook.com>
References: <1407232563-10856-1-git-send-email-yao.yuan@freescale.com>
	<1407232563-10856-2-git-send-email-yao.yuan@freescale.com>
	<41705e1e4c604240ba96333a03d5c544@BLUPR03MB373.namprd03.prod.outlook.com>
	<14d042bbcfb04308bfb3a1db18e46bec@BL2PR03MB338.namprd03.prod.outlook.com>
	<31f8f5504fc24d999f5af74338602bed@BLUPR03MB373.namprd03.prod.outlook.com>
	<c9727eaf22dc40f796793c6b127dfb9e@BL2PR03MB338.namprd03.prod.outlook.com>
	<6537011f698c4c7faaf5b66b870afbd2@BLUPR03MB373.namprd03.prod.outlook.com>
Organization: Ka-Ro electronics GmbH
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

fugang.duan@freescale.com wrote:
> From: Yuan Yao-B46683 Data: Thursday, August 07, 2014 4:05 PM
> >To: Duan Fugang-B38611; wsa@the-dreams.de; marex@denx.de
> >Cc: LW@KARO-electronics.de; mark.rutland@arm.com; shawn.guo@linaro.org;
> >linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux-
> >i2c@vger.kernel.org; Li Frank-B20596
> >Subject: RE: [PATCH v6 1/2] i2c: imx: add DMA support for freescale i2c
> >driver
> >
> >Hi Fugang,
> >
> >> >> >+	/* Waiting for Transfer complete. */
> >> >> >+	while (timeout--) {
> >> >> >+		temp = imx_i2c_read_reg(i2c_imx, IMX_I2C_I2SR);
> >> >> >+		if (temp & I2SR_ICF)
> >> >> >+			break;
> >> >> >+		udelay(10);
> >> >> >+	}
> >> >> Whether there have better method like interrupt to avoid dead wait
> >> >> here until timeout ?
> >> >
> >> >Can you give me more suggestion? We have discussed it with our team,
> >> >It seems the short query wait is necessary.
> >> >
> >> At least, you can use schdule_timeout() instead of udelay() ?
> >
> >In fact, the waiting time normally is less than 10-50us, but the minimum
> >time interval for schdule_timeout() is 1 jiffies.
> >So maybe schdule_timeout() is not very necessary?
> >
> Oh, if the waiting time is 10 ~ 50us, you can use usleep_range(10, 50).
>
The loop is not meant to generate a certain delay, but to wait for some
HW flag to change within a certain time frame. So usleep_range() is
rather inadequate here!


But looking a little closer at the function, the timeout value seems to
be rather bogus to me. The loop counter 'timeout' is initialized from 
the constant IMX_I2C_DMA_TIMEOUT which is also used in
|wait_for_completion_interruptible_timeout(
|                               &i2c_imx->dma->cmd_complete,
|                               msecs_to_jiffies(IMX_I2C_DMA_TIMEOUT));
 				                 ^^^^^^^^^^^^^^^^^^^
as a number of milliseconds to wait for DMA completion.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
