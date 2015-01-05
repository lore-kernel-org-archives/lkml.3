Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbbAENKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 08:10:04 -0500
Received: from smtprelay0157.hostedemail.com ([216.40.44.157]:46296 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751511AbbAENKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 08:10:02 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 10,1,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1406:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1801:1894:2189:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:4605:5007:6261:6742:6743:7875:8660:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12740:13148:13230:13972:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: dock62_39d367bc9b000
X-Filterd-Recvd-Size: 4181
Message-ID: <1420463396.2652.8.camel@perches.com>
Subject: Re: [PATCH V1 1/1] iio: Added Capella cm3232 ambient light sensor
 driver.
From: Joe Perches <joe@perches.com>
To: Daniel Baluta <daniel.baluta@intel.com>
Cc: Kevin Tsai <ktsai@capellamicro.com>, Wolfram Sang <wsa@the-dreams.de>,
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
Date: Mon, 05 Jan 2015 05:09:56 -0800
In-Reply-To: <CAEnQRZBD2NMYRp1cW0J2ssT4CT=0jSM=X6ByHQiUrA0ueV8fRA@mail.gmail.com>
References: <1420071030-888-1-git-send-email-ktsai@capellamicro.com>
	 <CAEnQRZBD2NMYRp1cW0J2ssT4CT=0jSM=X6ByHQiUrA0ueV8fRA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-05 at 12:51 +0200, Daniel Baluta wrote:
> On Thu, Jan 1, 2015 at 2:10 AM, Kevin Tsai <ktsai@capellamicro.com> wrote:
> > CM3232 is an advanced ambient light sensor with I2C protocol interface.
> > The I2C slave address is internally hardwired as 0x10 (7-bit).  Writing
> > to configure register is byte mode, but reading ALS register requests to
> > use word mode for 16-bit resolution.
> 
> This looks good to me.  Few comments inline.
[]
> > diff --git a/drivers/iio/light/cm3232.c b/drivers/iio/light/cm3232.c
[]
> > +/**
> > + * cm3232_reg_init() - Initialize CM3232 registers
> > + * @chip:      pointer of struct cm3232.
> > + *
> > + * Initialize CM3232 ambient light sensor register to default values.
> > + *
> > +  Return: 0 for success; otherwise for error code.
> > + */
> > +static int cm3232_reg_init(struct cm3232_chip *chip)
> > +{
> > +       struct i2c_client *client = chip->client;
> > +       struct cm3232_als_info *als_info;
> > +       s32 ret;
> > +
> > +       /* Identify device */
> > +       ret = i2c_smbus_read_word_data(client, CM3232_REG_ADDR_ID);
> > +       if (ret < 0)
> > +               return ret;
> > +       if ((ret & 0xFF) != 0x32)
> > +               return -ENODEV;
> > +
> > +       /* Disable and reset device */
> > +       chip->regs_cmd = CM3232_CMD_ALS_DISABLE | CM3232_CMD_ALS_RESET;
> > +       ret = i2c_smbus_write_byte_data(client, CM3232_REG_ADDR_CMD,
> > +                               chip->regs_cmd);
> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       /* Initialization */
> > +       als_info = chip->als_info = &cm3232_als_info_default;
> > +       chip->regs_cmd = CM3232_CMD_DEFAULT;
> > +
> > +       /* Configure register */
> > +       ret = i2c_smbus_write_byte_data(client, CM3232_REG_ADDR_CMD,
> > +                               chip->regs_cmd);
> 
> You could directly return i2c_smbus_write_byte_data(..).

Sometimes it's better to return a specific value
for the error instead of depending on correctness
of all the indirect functions in the call chain.

In this case, all the smbus_xfer functions must
return 0 on success.  Do they?

Inspecting the codebase for correctness or not
depending on that correctness is sometimes better
to avoid doing.

> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       return 0;
> > +}


