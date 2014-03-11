Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981AbaCKSUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 14:20:50 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:62280 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744AbaCKSUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 14:20:46 -0400
Date: Tue, 11 Mar 2014 14:20:35 -0400 (EDT)
From: Jon Ringle <jon@ringle.org>
X-X-Sender: jringle@jringle-ubuntu
To: Alexander Shiyan <shc_work@mail.ru>
cc: Jon Ringle <jon@ringle.org>, gregkh@linuxfoundation.org, jslaby@suse.cz,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jon Ringle <jringle@gridpoint.com>
Subject: Re: [PATCH] RFC: WIP: sc16is7xx [v0.4]
In-Reply-To: <1394468076.709210210@f170.i.mail.ru>
Message-ID: <alpine.DEB.2.02.1403111401440.17021@jringle-ubuntu>
References: <1394432777-13005-1-git-send-email-jon@ringle.org> <1394434945.519725450@f256.i.mail.ru> <alpine.DEB.2.02.1403100744230.23103@jringle-ubuntu> <1394468076.709210210@f170.i.mail.ru>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-2047570118-1394562044=:17021"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-2047570118-1394562044=:17021
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT



On Mon, 10 Mar 2014, Alexander Shiyan wrote:

> Понедельник, 10 марта 2014, 7:50 -04:00 от Jon Ringle <jon@ringle.org>:
> > 
> > On Mon, 10 Mar 2014, Alexander Shiyan wrote:
> > 
> > > Понедельник, 10 марта 2014, 2:26 -04:00 от jon@ringle.org:
> > > > From: Jon Ringle <jringle@gridpoint.com>
> > > ...
> > > > +config SERIAL_SC16IS7XX
> > > > +	tristate "SC16IS7xx RS485 serial support"
> > > > +	  select SERIAL_CORE
> > > > +	  default n
> > > > +	  help
> > > > +	  This selects support for SC16IS7xx for use as a RS485 serial port
> > > 
> > > Documentation says:
> > > The SC16IS740/750/760 is a slave I²C-bus/SPI interface to a single-channel
> > > high performance UART.
> > > ...
> > > The SC16IS740/750/760 also provides additional advanced features such
> > > as auto hardware and software flow control, automatic RS-485 support...
> > > 
> > > So why do you position this chip as RS485 only? Automatic direction for
> > > RS485 is just a feature as an addition for standart UART.
> > 
> > You're right. This is just how we are using the chip in our board. Would a 
> > configuration flag in platform_data make sense to use the auto rs485 
> > direction?
> 
> You don't need a flag, just use IOCTLs.
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/drivers/tty/serial/max310x.c?id=55367c620aed6bc27a82bb1763366931d7f2ee66
> 
> > Any thoughts as to the latency issue I report?
> 
> I do not understand why you chose the sccnxp driver as a template.
> Use as a template max310x driver from linux-next branch.
> I'm sure it will be better.

I followed your advice on using max310x as a template. One thing that I'm 
struggling to get right is the regmap. The datasheet[1] specifies the 
register bits as follows:

	Table 33. Register address byte (I2C)
	Bit	Name	Function
	7 	-	not used
	6:3 	A[3:0]	UART's internal register select
	2:1	CH1,0	channel select: CH1 = 0, CH0 = 0
			Other values are reserved and should not be used.
	0	-	not used

So, I need to shift the register address by 3. Here is how I have defined 
the regmap stuff:

------>8 [relevant code] >8-------
/* SC16IS7XX register definitions */
#define SC16IS7XX_RHR_REG		(0x00) /* RX FIFO */
#define SC16IS7XX_THR_REG		(0x00) /* TX FIFO */
#define SC16IS7XX_IER_REG		(0x01) /* Interrupt enable */
#define SC16IS7XX_IIR_REG		(0x02) /* Interrupt Ident */
#define SC16IS7XX_FCR_REG		(0x02) /* FIFO control */
#define SC16IS7XX_LCR_REG		(0x03) /* Line Control */
#define SC16IS7XX_MCR_REG		(0x04) /* Modem Control */
#define SC16IS7XX_LSR_REG		(0x05) /* Line Status */
#define SC16IS7XX_MSR_REG		(0x06) /* Modem Status */
#define SC16IS7XX_SPR_REG		(0x07) /* Scratch Pad */
#define SC16IS7XX_TXLVL_REG		(0x08) /* TX FIFO level */
#define SC16IS7XX_RXLVL_REG		(0x09) /* RX FIFO level */
#define SC16IS7XX_IODIR_REG		(0x0a) /* I/O Dir (750/760) */
#define SC16IS7XX_IOSTATE_REG		(0x0b) /* I/O State (750/760) */
#define SC16IS7XX_IOINTENA_REG		(0x0c) /* I/O Int Enable (750/760) */
#define SC16IS7XX_IOCONTROL_REG		(0x0e) /* I/O Control (750/760) */
#define SC16IS7XX_EFCR_REG		(0x0f) /* Extra Feature Control */

/* TX/Trigger Registers: Only if ((MCR[2] == 0) && (EFR[4] == 1)) */
#define SC16IS7XX_TCR_REG		(0x06) /* Transmit control */
#define SC16IS7XX_TLR_REG		(0x07) /* Trigger level */

/* Special Register set: Only if ((LCR[7] == 1) && (LCR != 0xBF)) */
#define SC16IS7XX_DLL_REG		(0x00) /* Divisor Latch Low */
#define SC16IS7XX_DLH_REG		(0x01) /* Divisor Latch High */

/* Enhanced Register set: Only if (LCR == 0xBF) */
#define SC16IS7XX_EFR_REG		(0x02) /* Enhanced Features */
#define SC16IS7XX_XON1_REG		(0x04) /* Xon1 word */
#define SC16IS7XX_XON2_REG		(0x05) /* Xon2 word */
#define SC16IS7XX_XOFF1_REG		(0x06) /* Xoff1 word */
#define SC16IS7XX_XOFF2_REG		(0x07) /* Xoff2 word */

#define SC16IS7XX_REG_SHIFT		3

static bool sc16is7xx_reg_writeable(struct device *dev, unsigned int reg)
{
	switch ((reg >> SC16IS7XX_REG_SHIFT) & 0xf) {
	case SC16IS7XX_LSR_REG:
	case SC16IS7XX_MSR_REG:
	case SC16IS7XX_TXLVL_REG:
	case SC16IS7XX_RXLVL_REG:
		return false;
	default:
		break;
	}

	return true;
}

static bool sc16is7xx_reg_volatile(struct device *dev, unsigned int reg)
{
	switch ((reg >> SC16IS7XX_REG_SHIFT) & 0xf) {
	case SC16IS7XX_RHR_REG:
	case SC16IS7XX_IIR_REG:
	case SC16IS7XX_LSR_REG:
	case SC16IS7XX_MSR_REG:
	case SC16IS7XX_TXLVL_REG:
	case SC16IS7XX_RXLVL_REG:
	case SC16IS7XX_IOSTATE_REG:
		return true;
	default:
		break;
	}

	return false;
}

static bool sc16is7xx_reg_precious(struct device *dev, unsigned int reg)
{
	switch ((reg >> SC16IS7XX_REG_SHIFT) & 0xf) {
	case SC16IS7XX_RHR_REG:
	case SC16IS7XX_IIR_REG:
	case SC16IS7XX_MSR_REG:
		return true;
	default:
		break;
	}

	return false;
}

static struct regmap_config regcfg = {
	.reg_bits = 8,
	.reg_stride = (1 << SC16IS7XX_REG_SHIFT),
	.val_bits = 8,
	.max_register = (0xf << SC16IS7XX_REG_SHIFT),
	.cache_type = REGCACHE_RBTREE,
	.writeable_reg = sc16is7xx_reg_writeable,
	.volatile_reg = sc16is7xx_reg_volatile,
	.precious_reg = sc16is7xx_reg_precious,
};
------------->8-----------------

I'm not sure that I have this defined correctly. I also saw in 
regmap_config pad_bits, which I've tried setting to SC16IS7XX_REG_SHIFT, 
but when I do that, I get -EINVAL failure.

Thanks,
Jon

[1] http://www.nxp.com/documents/data_sheet/SC16IS740_750_760.pdf
--8323329-2047570118-1394562044=:17021--
