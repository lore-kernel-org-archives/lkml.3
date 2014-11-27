Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751081AbaK0OBD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 09:01:03 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:33044 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750780AbaK0OBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 09:01:00 -0500
X-Listener-Flag: 11101
Subject: Re: [PATCH v3 0/2] ARM: mediatek: Add driver for Mediatek I2C
 controller
From: Yingjoe Chen <yingjoe.chen@mediatek.com>
To: Wolfram Sang <wsa@the-dreams.de>
CC: Xudong Chen <xudong.chen@mediatek.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <srv_heupstream@mediatek.com>, Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Jean Delvare <jdelvare@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-i2c@vger.kernel.org>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Nathan Chung <nathan.chung@mediatek.com>,
        YH Chen <yh.chen@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>
In-Reply-To: <20141124121555.GG3733@katana>
References: <1416821928-11453-1-git-send-email-xudong.chen@mediatek.com>
	 <20141124121555.GG3733@katana>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Nov 2014 22:00:56 +0800
Message-ID: <1417096856.12707.59.camel@mtksdaap41>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-MTK: N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Mon, 2014-11-24 at 13:15 +0100, Wolfram Sang wrote:
> Hi,
> 
> some very high level remarks:
> 
> On Mon, Nov 24, 2014 at 05:38:46PM +0800, Xudong Chen wrote:
> > This series is the third version of Mediatek SoCs I2C controller common
> > bus driver.
> > Compared to the second version,
> > 1. Add comments for clock in dt-bindings file i2c-mt6577.txt.
> > 2. Remove mt8135.dtsi because of the dependency on pinctrl and clock.
> > 3. Encode the feature have-dcm in i2c-mt65xx.c by checking the compatible.
> > 
> > This driver is based on 3.18-rc1.
> > 
> > MTK I2C HW has some limitation.
> > 1. If the i2c_msg number is more than one, STOP will be issued instead of
> > RS(Repeat Start) between each message.
> > Such as: "START + ADDR + DATA_n + STOP + START + ADDR + DATA_n + STOP ..."
> > 
> > 2. Mediatek I2C controller support WRRD(write then read) mode, in WRRD
> > mode the Repeat Start will be issued between 2 messages.
> > In this driver if 2 messages is first write then read, the driver will
> > combine 2 messages using Write-Read mode so the RS will be issued between
> > the 2 messages.
> > Ex: W/R/R, driver will combine first W/R and then R.
> > The data series will be:
> > "START + WriteADDR + DATA + RS + ReadADDR + DATA + STOP + START + ReadADDR +
> > DATA + STOP".
> 
> I think there are now 3 drivers in my queue which are not fully I2C
> compatible but more supporting the very minimum to, say, read an eeprom.
> I am not feeling well to allow them to use I2C_FUNC_I2C. So, I want to
> think about ways how to communicate deficiencies like "only 255 byte" or
> "only WRRD messages" to users of that I2C controller. This is most
> likely not happening before 3.19. But assistance is very welcome.

Let's us know what we could help :)


> > 3. Due to HW limitation, in this version the max transfer data length is 255
> > in one message. If want to transfer more than 255 bytes, HW needs the SW
> > driver to split the data. Take 600 bytes for example, the data need to be
> > divided into 3 parts 255 + 255 + 90. The data series will be:
> > "START + ADDR + DATA_255 + RS + ADDR + DATA_255 + RS + ADDR +  DATA_90 + STOP"
> > instead of "START + ADDR + DATA_900 + STOP".
> > We haven't implement this yet, we will do this in the separate patch.
> 
> I don't like this idea. If somebody wants to send 1 message with 600
> bytes and we can't do this, we should simply say so. Sending 3 messages
> is not the same.

Agreed. I think this should only happen when we know the device can
support that.
However, from our experience, many i2c devices do support it. Do you
think it is OK to add a flag in i2c_msg(eg, I2C_M_ALLOW_SPLIT) and only
do message split when this flag is on?

> > MT8135 and MT6589 can control I2C pins on PMIC(MT6397) by setting the i2c
> > registers in MT8135 side. In this case, driver should set OFFSET_PATH_DIR
> > bit first, the operation on other registers are still the same.
> > For now MT6589/MT8135 support this, MT6577/MT6595/MT8127 do not support.
> > For example, If want to use I2C4/5/6 pins on MT8135 just need to enable
> > the pinmux, else if want to use I2C pins on PMIC(MT6397) need to add
> > "mediatek,have-pmic" property in the .dts file of each platform.
> 
> What about Sascha's idea of using a pinctrl driver?

We are working on mt6397 pmic pinctrl driver. It depends on mt8135
pinctrl driver [1] and pmic pwrap driver [2]. There are some discussion
about pinctrl bindings, we'll send pmic pinctrl driver when that is
settled.

Just to make it clear, the pinctrl driver only handle pin mux, we still
need to set mediatek,have-pmic to send i2c data through pmic.

Joe.C

[1]
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/301417.html
[2]
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-November/302984.html


