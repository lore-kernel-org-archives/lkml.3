Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089AbaFGPcb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 11:32:31 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:64296 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821AbaFGPc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 11:32:28 -0400
From: Max Schwarz <max.schwarz@online.de>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH v4] i2c: add driver for Rockchip RK3xxx SoC I2C adapter
Date: Sat, 07 Jun 2014 17:32:09 +0200
Message-ID: <1468105.xYIQWVNzVZ@typ>
User-Agent: KMail/4.13 (Linux/3.13.0-29-generic; KDE/4.13.0; x86_64; ; )
In-Reply-To: <20140602120854.GA2654@katana>
References: <5192968.EzcUiXba22@typ> <1547619.upPdAXDT0W@typ> <20140602120854.GA2654@katana>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:dfMSLv4FO5bC2WScD5v8GZpKjw1B+I0GxLKLpQ14UfL
 xEtdKFU7QmlkLnDTBDDjxPGGE8PYfyaGB+6vVSIZkXx6xEcl2I
 ba9pFFf7xb/bnVbyjBQ4Xsr/SJLjW9LnJgvpeOmSBRCzgBGokT
 eimmnU5ZrgKvP3I/m7ViL8qnI0J3YAjIIsikK8+HPHpkmDrHLO
 smMVsYd8DD5Ifpd4hLvWxzldGUxnNhyplwT/hqA19BD4LkeXHp
 fQOxGoT6nvzdeFg5rjKX41RiRA7IybaFUvW5Ezxv7hM51gEp2E
 p/vQG2dqZKyAUWBKJ+H1IBbkXblyGl6EwpP+roLrW/0YoEVgA=
 =
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

thanks for the review!

> > +
> > +	/* Settings */
> > +	unsigned int scl_frequency;
> > +
> > +	/* Synchronization & notification */
> > +	spinlock_t lock;
> 
> Why the lock? The core has per-adapter locks anyhow.

I'm using it to lock the rk3x_i2c struct during interrupts. It's needed there 
because an operation can timeout, which means the interrupt can occur at any 
time and possibly conflict with the cleanup I do after a timeout.

I looked around in i2c-exynos5.c, i2c-pxa.c and others, and they do it the 
same way. Could you explain in more detail why it's not needed?

> > +static void rk3x_i2c_handle_write(struct rk3x_i2c *i2c, unsigned int ipd)
> > +{
> > +	if (!(ipd & REG_INT_MBTF)) {
> > +		rk3x_i2c_stop(i2c, -ENXIO);
> > +		dev_err(i2c->dev, "unexpected irq in WRITE: 0x%x\n", ipd);
> > +		rk3x_i2c_clean_ipd(i2c);
> > +		return;
> > +	}
> > +
> > +	/* ack interrupt */
> > +	i2c_writel(i2c, REG_INT_MBTF, REG_IPD);
> > +
> > +	/* are we finished? */
> > +	if (i2c->processed == i2c->msg->len)
> > +		rk3x_i2c_stop(i2c, i2c->error);
> > +	else
> > +		rk3x_i2c_fill_transmit_buf(i2c);
> 
> It looks to me that you STOP after every message? You should use
> REPEATED_START inbetween messages and only stop after the last message
> of a transfer.

I had a fight with the hw today and finally got it to issue a REPEATED_START 
for multiple "boring" messages. Will be included in the next version.

> > +/**
> > + * Setup I2C registers for an I2C operation specified by msgs, num.
> > + *
> > + * Must be called with i2c->lock held.
> > + *
> > + * @msgs: I2C msgs to process
> > + * @num: Number of msgs
> > + *
> > + * returns: Number of I2C msgs processed or negative in case of error
> > + */
> > +static int rk3x_i2c_setup(struct rk3x_i2c *i2c, struct i2c_msg *msgs, int
> > num) +{
> > +	u32 addr = (msgs[0].addr & 0x7f) << 1;
> > +	int ret = 0;
> > +
> > +	/*
> > +	 * The I2C adapter can issue a small (len < 4) write packet before
> > +	 * reading. This speeds up SMBus-style register reads.
> > +	 * The MRXADDR/MRXRADDR hold the slave address and the slave register
> > +	 * address in this case.
> > +	 */
> > +
> > +	if (num >= 2 && msgs[0].len < 4
> > +	    && !(msgs[0].flags & I2C_M_RD)
> > +	    && (msgs[1].flags & I2C_M_RD)) {
> > +		u32 reg_addr = 0;
> > +
> > +		dev_dbg(i2c->dev, "Combined write/read from addr 0x%x\n",
> > +			addr >> 1);
> > +
> > +		if (msgs[0].len == 0)
> > +			return -EINVAL;
> 
> Can the controller do SMBUS_QUICK (len == 0) in general? For the case it
> cannot do it only in this multi-packet mode, then you should fall back
> to the "boring" mode.

Actually, I wasn't aware that (len == 0) is a valid case. The hw supports it 
in both modes, I just tested that. So the check is going away.

I'm cleaning up now and you can expect a new version of the patch today.

Cheers,
  Max
