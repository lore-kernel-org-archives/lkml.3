Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab3CMKzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 06:55:38 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:44187 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877Ab3CMKzg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 06:55:36 -0400
X-Auth-Info: mixXE37a/acT8rDbXZRJ0b3/O6xpfz7RarMSxtdjLw4=
Date: Wed, 13 Mar 2013 11:55:33 +0100
From: Anatolij Gustschin <agust@denx.de>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>, linux-fbdev@vger.kernel.org,
        "'Stefano Babic'" <sbabic@denx.de>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>
Subject: Re: [PATCH] video: add ili922x lcd driver
Message-ID: <20130313115533.7fb339da@crub>
In-Reply-To: <00c701ce029a$e42d3470$ac879d50$%han@samsung.com>
References: <1359729703-24915-1-git-send-email-agust@denx.de>
 <00c701ce029a$e42d3470$ac879d50$%han@samsung.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Feb 2013 14:45:51 +0900
Jingoo Han <jg1.han@samsung.com> wrote:
...
> > diff --git a/drivers/video/backlight/ili922x.c b/drivers/video/backlight/ili922x.c
> > new file mode 100644
> > index 0000000..18c33df
> > --- /dev/null
> > +++ b/drivers/video/backlight/ili922x.c
> > @@ -0,0 +1,586 @@
> > +/*
> > + * (C) Copyright 2008
> > + * Stefano Babic, DENX Software Engineering, sbabic@denx.de.
> > + *
> > + * This program is free software; you can redistribute it and/or
> > + * modify it under the terms of the GNU General Public License as
> > + * published by the Free Software Foundation; either version 2 of
> > + * the License, or (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 59 Temple Place, Suite 330, Boston,
> > + * MA 02111-1307 USA
> 
> Please remove this comment. It is hard to keep track of the address of
> Free Software Foundation.
> Also, above mentioned address is not the same with the current address.

okay, will do.

> > + *
> > + * This driver implements a lcd device for the ILITEK 922x display
> > + * controller. The interface to the display is SPI and the display's
> > + * memory is cyclically updated
> > + */
> > +
> > +#include <linux/module.h>
> > +#include <linux/kernel.h>
> > +#include <linux/errno.h>
> > +#include <linux/string.h>
> > +#include <linux/slab.h>
> > +#include <linux/delay.h>
> > +#include <linux/fb.h>
> > +#include <linux/init.h>
> > +#include <linux/lcd.h>
> > +#include <linux/of.h>
> > +#include <linux/spi/spi.h>
> 
> Would you order inclusions of <linux/xxx.h> according to alphabetical
> ordering, for readability?

I'll do it in the next patch version.


...
> > +	xfer.bits_per_word = 8;
> > +	xfer.len = NUM_DUMMY_BYTES;
> > +	spi_message_add_tail(&xfer, &m);
> > +	ret = spi_sync(spi, &m);
> > +
> > +	udelay(10);
> 
> How about replacing udelay() with usleep_range()?

as I see now the send_dummy() is a nop, I'll remove it entirely.


...
> > +static u16 read_status(struct spi_device *spi)
> > +{
> > +	struct spi_message m;
> 
> Would you replace 'm' with 'msg' or 'message' for the readability?
> It's too short, even though 'm' is used in include/linux/spi/spi.h.
> 
> 	struct spi_message msg;

okay.

...
> > +static int read_reg(struct spi_device *spi, u8 reg, u16 *rx)
> > +{
> > +	struct spi_message m;
> > +	struct spi_transfer xfer_regindex, xfer_regvalue;
> > +	unsigned char tbuf[CMD_BUFSIZE];
> > +	unsigned char rbuf[CMD_BUFSIZE];
> > +	int ret = 0, len = 0, i, send_bytes;
> > +
> > +	send_dummy(spi);
> > +
> > +	memset(&xfer_regindex, 0, sizeof(struct spi_transfer));
> > +	memset(&xfer_regvalue, 0, sizeof(struct spi_transfer));
> > +	spi_message_init(&m);
> > +	xfer_regindex.tx_buf = tbuf;
> > +	xfer_regindex.rx_buf = rbuf;
> > +	xfer_regindex.cs_change = 1;
> > +	CHECK_FREQ_REG(spi, &xfer_regindex);
> > +
> > +	tbuf[0] = set_tx_byte(START_BYTE(ili922x_id, START_RS_INDEX,
> > +					 START_RW_WRITE));
> > +	tbuf[1] = set_tx_byte(0);
> > +	tbuf[2] = set_tx_byte(reg);
> > +	xfer_regindex.bits_per_word = 8;
> > +	len = xfer_regindex.len = 3;
> > +	spi_message_add_tail(&xfer_regindex, &m);
> > +
> > +	send_bytes = len;
> > +
> > +	tbuf[len++] = set_tx_byte(START_BYTE(ili922x_id, START_RS_REG,
> > +					     START_RW_READ));
> > +	for (i = len; i < CMD_BUFSIZE; i++)
> > +		tbuf[i] = set_tx_byte(0);	/* dummy */
> > +
> > +	xfer_regvalue.cs_change = 1;
> > +	xfer_regvalue.len = 4;
> 
> I don't understand why length 4 is necessary.
> In my opinion, length 3 seems to be enough.
> - tbuf[4] is used for sending 'START_BYTE(ili922x_id, START_RS_REG, START_RW_READ)'.
> - rbuf[5] and rbuf[6] are used for receiving value as below.
>    *rx = (rbuf[1 + send_bytes] << 8) + rbuf[2 + send_bytes];
> 
> However, tbuf[7] or rbuf[7] seems to be unnecessary.
> If I'm wrong, please let me know kindly.

will fix, thanks.

...
> > +static void ili922x_reg_dump(struct spi_device *spi)
> > +{
> > +	u8 reg;
> > +	u16 rx;
> > +
> > +	pr_info("ILI922x configuration registers:\n");
> 
> Please replace pr_info() with dev_info() as below.
> 
> 	dev_err(&spi->dev, "ILI922x configuration registers:\n");

okay, I'll use dev_dbg().

> 
> > +	for (reg = REG_START_OSCILLATION;
> > +	     reg <= REG_OTP_PROGRAMMING_ID_KEY; reg++) {
> > +		read_reg(spi, reg, &rx);
> > +		pr_info("reg @ 0x%02X: 0x%04X\n", reg, rx);
> 
> Same as above.

will change.


...
> > +static int ili922x_poweron(struct spi_device *spi)
> > +{
> > +	int ret = 0;
> 
> Initialization is not necessary.
> Just declare it as below:
> 	int ret;

okay.

> > +
> > +	/* Power on */
> > +	ret = write_reg(spi, REG_POWER_CONTROL_1, 0x0000);
> > +	mdelay(10);
> > +	ret += write_reg(spi, REG_POWER_CONTROL_2, 0x0000);
> > +	ret += write_reg(spi, REG_POWER_CONTROL_3, 0x0000);
> > +	mdelay(40);
> > +	ret += write_reg(spi, REG_POWER_CONTROL_4, 0x0000);
> > +	mdelay(40);
> > +	ret += write_reg(spi, 0x56, 0x080F);
> 
> Would you replace this hard-coded address with the bit definition?

It is an undocumented register. I do not know what to use for the
bit definition. Do you know where this register is documented?
Otherwise I'll add a comment that it is not documented.

...
> > +	ret += write_reg(spi, REG_POWER_CONTROL_1, 0x4240);
> > +	mdelay(10);
> > +	ret += write_reg(spi, REG_POWER_CONTROL_2, 0x0000);
> > +	ret += write_reg(spi, REG_POWER_CONTROL_3, 0x0014);
> > +	mdelay(40);
> > +	ret += write_reg(spi, REG_POWER_CONTROL_4, 0x1319);
> > +	mdelay(40);
> 
> How about replacing mdelay() with msleep()?

will fix.

...
> > +static int ili922x_poweroff(struct spi_device *spi)
> > +{
> > +	int ret = 0;
> 
> Initialization is not necessary.
> Just declare it as below:
> 	int ret;
> 
> 
> > +
> > +	/* Power off */
> > +	ret = write_reg(spi, REG_POWER_CONTROL_1, 0x0000);
> > +	mdelay(10);
> > +	ret += write_reg(spi, REG_POWER_CONTROL_2, 0x0000);
> > +	ret += write_reg(spi, REG_POWER_CONTROL_3, 0x0000);
> > +	mdelay(40);
> > +	ret += write_reg(spi, REG_POWER_CONTROL_4, 0x0000);
> > +	mdelay(40);
> 
> Same as above.

...
> > +static void ili922x_display_init(struct spi_device *spi)
> > +{
> > +	write_reg(spi, REG_START_OSCILLATION, 1);
> > +	mdelay(10);
> 
> Same as above.

okay, will change.

Thanks,

Anatolij
