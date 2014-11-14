Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934952AbaKNDMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 22:12:45 -0500
Received: from mailgw01.mediatek.com ([218.249.47.110]:51342 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932755AbaKNDMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 22:12:43 -0500
X-Listener-Flag: 11101
Message-ID: <1415934752.2152.58.camel@mhfsdcap03>
Subject: Re: [PATCH v2 0/3] ARM: mediatek: Add driver for Mediatek I2C
 controller
From: xudong chen <xudong.chen@mediatek.com>
To: Wolfram Sang <wsa@the-dreams.de>
CC: Mark Rutland <mark.rutland@arm.com>, <arm@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <srv_heupstream@mediatek.com>, Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        "Grant Likely" <grant.likely@linaro.org>,
        Jean Delvare <jdelvare@suse.de>, "Arnd Bergmann" <arnd@arndb.de>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-i2c@vger.kernel.org>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        "Eddie Huang" <eddie.huang@mediatek.com>,
        Nathan Chung <nathan.chung@mediatek.com>,
        YH Chen <yh.chen@mediatek.com>
Date: Fri, 14 Nov 2014 11:12:32 +0800
In-Reply-To: <20141113183122.GH1275@katana>
References: <1415078977-18374-1-git-send-email-xudong.chen@mediatek.com>
	 <20141113183122.GH1275@katana>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-13 at 19:31 +0100, Wolfram Sang wrote:
> > MTK I2C HW has some limitation.
> > 1. If the i2c_msg number is more than one, STOP will be issued instead of
> > RS(Repeat Start) between each message.
> > 
> > 2. Mediatek I2C controller support WRRD(write then read) mode, in WRRD
> > mode the Repeat Start will be issued between 2 messages.
> > In this driver if 2 messages is first write then read, the driver will
> > combine 2 messages using Write-Read mode so the RS will be issued between
> > the 2 messages.
> > Ex: W/R/R, driver will combine first W/R and then R.
> > 
> > 3. Due to HW limitation, in this version the max transfer data length is 255
> > in one message.
> 
> This looks to me more like an SMBUS controller instead of I2C. Maybe you
> should populate smbus_xfer rather than master_xfer?

This is the HW limitation, we will try to workaround this in the
separate patch.

> 
> > MT8135 and MT6589 can control I2C pins on PMIC(MT6397) by setting the i2c
> > registers in MT8135 side.
> 
> I still didn't get this, even after reading the mail thread of old
> series. Can someone maybe draw me a nice ASCII picture showing the setup
> which is going on here?
> 

1. The DIR_PATH register is in MT8135.
2. All the registers used in the driver are in MT8135.
3. If want I2C wave go/from PMIC need to set the DIR_PATH register bit^0
to 1 extra.

>From the picture:
If MT8135 connected to PMIC(MT6397), when set the DIR_PATH register
bit^0 to 1, the HW will transfer the i2c wave from pins(SDA4_pmic &
SCL4_pmic) on MT6397 side.
If want use pins(SDA4 & SCL4) on 8135 side directly, we should set the
DIR_PATH register bit^0 to 0.

_______       ________
|      |______|       |
|      |      |  PMIC |
| 8135 |______| (6397)|___SDA4_pmic
|      |      |       |___SCL4_pmic
!______!      !_______!
  |   |
SDA4 SCL4


Thanks!







