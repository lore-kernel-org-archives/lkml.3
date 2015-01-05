Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbbAEOUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 09:20:08 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:51573 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923AbbAEOUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 09:20:04 -0500
MIME-Version: 1.0
In-Reply-To: <1420463396.2652.8.camel@perches.com>
References: <1420071030-888-1-git-send-email-ktsai@capellamicro.com>
	<CAEnQRZBD2NMYRp1cW0J2ssT4CT=0jSM=X6ByHQiUrA0ueV8fRA@mail.gmail.com>
	<1420463396.2652.8.camel@perches.com>
Date: Mon, 5 Jan 2015 16:20:02 +0200
X-Google-Sender-Auth: nJUvFZVp_J2wpKqVsSF5yYgUB88
Message-ID: <CAEnQRZBmwurFCJU4E4ArO8waU+YcGWrRYr3DRVxq9haduX2t=w@mail.gmail.com>
Subject: Re: [PATCH V1 1/1] iio: Added Capella cm3232 ambient light sensor driver.
From: Daniel Baluta <daniel.baluta@intel.com>
To: Joe Perches <joe@perches.com>
Cc: Daniel Baluta <daniel.baluta@intel.com>,
        Kevin Tsai <ktsai@capellamicro.com>, Wolfram Sang <wsa@the-dreams.de>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jonathan Cameron <jic23@kernel.org>,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Antti Palosaari <crope@iki.fi>,
        Archana Patni <archana.patni@linux.intel.com>,
        linux-i2c@vger.kernel.org, devicetree@vger.kernel.org,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 3:09 PM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2015-01-05 at 12:51 +0200, Daniel Baluta wrote:
>> On Thu, Jan 1, 2015 at 2:10 AM, Kevin Tsai <ktsai@capellamicro.com> wrote:
>> > CM3232 is an advanced ambient light sensor with I2C protocol interface.
>> > The I2C slave address is internally hardwired as 0x10 (7-bit).  Writing
>> > to configure register is byte mode, but reading ALS register requests to
>> > use word mode for 16-bit resolution.
>>
>> This looks good to me.  Few comments inline.
> []
>> > diff --git a/drivers/iio/light/cm3232.c b/drivers/iio/light/cm3232.c
> []
>> > +/**
>> > + * cm3232_reg_init() - Initialize CM3232 registers
>> > + * @chip:      pointer of struct cm3232.
>> > + *
>> > + * Initialize CM3232 ambient light sensor register to default values.
>> > + *
>> > +  Return: 0 for success; otherwise for error code.
>> > + */
>> > +static int cm3232_reg_init(struct cm3232_chip *chip)
>> > +{
>> > +       struct i2c_client *client = chip->client;
>> > +       struct cm3232_als_info *als_info;
>> > +       s32 ret;
>> > +
>> > +       /* Identify device */
>> > +       ret = i2c_smbus_read_word_data(client, CM3232_REG_ADDR_ID);
>> > +       if (ret < 0)
>> > +               return ret;
>> > +       if ((ret & 0xFF) != 0x32)
>> > +               return -ENODEV;
>> > +
>> > +       /* Disable and reset device */
>> > +       chip->regs_cmd = CM3232_CMD_ALS_DISABLE | CM3232_CMD_ALS_RESET;
>> > +       ret = i2c_smbus_write_byte_data(client, CM3232_REG_ADDR_CMD,
>> > +                               chip->regs_cmd);
>> > +       if (ret < 0)
>> > +               return ret;
>> > +
>> > +       /* Initialization */
>> > +       als_info = chip->als_info = &cm3232_als_info_default;
>> > +       chip->regs_cmd = CM3232_CMD_DEFAULT;
>> > +
>> > +       /* Configure register */
>> > +       ret = i2c_smbus_write_byte_data(client, CM3232_REG_ADDR_CMD,
>> > +                               chip->regs_cmd);
>>
>> You could directly return i2c_smbus_write_byte_data(..).
>
> Sometimes it's better to return a specific value
> for the error instead of depending on correctness
> of all the indirect functions in the call chain.
>
> In this case, all the smbus_xfer functions must
> return 0 on success.  Do they?

Yes.

http://lxr.free-electrons.com/source/drivers/i2c/i2c-core.c#L2845

>
> Inspecting the codebase for correctness or not
> depending on that correctness is sometimes better
> to avoid doing.

You have a valid point. Anyhow, AFAIK the code from IIO
prefers a direct return.

Also, I guess kbuild test robot will complain about it, like here:

http://marc.info/?l=linux-kernel&m=141963536230419&w=2

thanks,
Daniel.
