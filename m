Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951AbaEVJAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 05:00:47 -0400
Received: from sauhun.de ([89.238.76.85]:55762 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043AbaEVJAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 05:00:45 -0400
Date: Thu, 22 May 2014 11:00:41 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Cc: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ding, Garrett" <g-ding@ti.com>, "Nori, Sekhar" <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Subject: Re: [PATCH] i2c: davinci: Add block read functionality for IPMI
Message-ID: <20140522090041.GA2573@katana>
References: <1398970186-12204-1-git-send-email-m-karicheri2@ti.com>
 <3E54258959B69E4282D79E01AB1F32B70472F6AC@DFLE11.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
In-Reply-To: <3E54258959B69E4282D79E01AB1F32B70472F6AC@DFLE11.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

thanks for the patch.

> >+/* capabilities */
> >+#define I2C_CAPABILITIES	(I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL | \
> >+				 I2C_FUNC_SMBUS_READ_BLOCK_DATA)

I don't see the need for a seperate define.

> >+
> > struct davinci_i2c_dev {
> > 	struct device           *dev;
> > 	void __iomem		*base;
> >@@ -318,7 +322,13 @@ i2c_davinci_xfer_msg(struct i2c_adapter *adap, struct i2c_msg
> >*msg, int stop)
> > 	davinci_i2c_write_reg(dev, DAVINCI_I2C_SAR_REG, msg->addr);
> >
> > 	dev->buf = msg->buf;
> >-	dev->buf_len = msg->len;
> >+
> >+	 /* if first received byte is length, set buf_len = 0xffff as flag */
> >+	if (msg->flags & I2C_M_RECV_LEN)
> >+		dev->buf_len = 0xffff;

a) this magic value should be a define instead of a comment
b) i2c messages easily have a 16 bit range, so 0xffff is a troublesome
choice.

> >+	else
> >+		dev->buf_len = msg->len;
> >+
> > 	dev->stop = stop;
> >
> > 	davinci_i2c_write_reg(dev, DAVINCI_I2C_CNT_REG, dev->buf_len); @@ -456,7
> >+466,7 @@ i2c_davinci_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[], int num)
> >
> > static u32 i2c_davinci_func(struct i2c_adapter *adap)  {
> >-	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
> >+	return I2C_CAPABILITIES;
> > }
> >
> > static void terminate_read(struct davinci_i2c_dev *dev) @@ -528,10 +538,32 @@ static
> >irqreturn_t i2c_davinci_isr(int this_irq, void *dev_id)
> >
> > 		case DAVINCI_I2C_IVR_RDR:
> > 			if (dev->buf_len) {
> >-				*dev->buf++ =
> >-				    davinci_i2c_read_reg(dev,
> >-							 DAVINCI_I2C_DRR_REG);
> >+				*dev->buf++ = davinci_i2c_read_reg(dev,
> >+							DAVINCI_I2C_DRR_REG);
> >+				/*
> >+				 * check if the first received byte is message
> >+				 * length, i.e, I2C_M_RECV_LEN
> >+				 */
> >+				if (dev->buf_len == 0xffff)
> >+					dev->buf_len = *(dev->buf - 1) + 1;

Please rework the code to get rid of the '- 1' and '+ 1'. They look
hackish and make the code less readable.

> >+
> > 				dev->buf_len--;
> >+				/*
> >+				 * send NACK/STOP bits BEFORE last byte is
> >+				 * received
> >+				 */
> >+				if (dev->buf_len == 1) {
> >+					w = davinci_i2c_read_reg(dev,
> >+							DAVINCI_I2C_MDR_REG);
> >+					w |= DAVINCI_I2C_MDR_NACK;
> >+					davinci_i2c_write_reg(dev,
> >+							DAVINCI_I2C_MDR_REG, w);
> >+
> >+					w |= DAVINCI_I2C_MDR_STP;
> >+					davinci_i2c_write_reg(dev,
> >+							DAVINCI_I2C_MDR_REG, w);
> >+				}
> >+

Looks like an unreleated change to me? Why is this I2C_M_RECV_LEN
specific?

Kind regards,

   Wolfram

--9amGYk9869ThD9tj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTfby4AAoJEBQN5MwUoCm2F+MQALJXKUaaQfaA294HKDsSqxyt
WSgP93rEtZldxKLQu20QfytyBCBq2fpumBK5UEpsTnbZ7CQltPrY2u0ojc5RaA+R
IZ42+OU6K0MarbYaEHgOq8w7GkE7YgXSojQShk1bXjd5SAinO1/2Egb1u/IufrFp
EVWagX/RfkaS5CoHbWKEebbKXtMmpGShDqOwjZjZ4MvUW6t1navDpyjaKpGCjy2P
JFkadJBzQC/k47jY6+oj7r8hMRhhEReyw4337AvrY/YPPf2IcRU9jAf9IN5dc+IX
rkekRzWO+dsyl8ObxMSEGassoA/6bVad0XVhi9+9Cfg3mtsP8jY1NKpfi+fA1XuE
FTmeeOjEv+si6AR3sadVZbwz118nZZvo4RDJ2gE7I1U+F4FhaFd+HGm5zJ+Vbn0l
e2X0jmZklYXGth4AUxYjmhkA3nyEjHpghWbYcyXEt1O6SO+CjQNyrucogfs4Vanm
1zlRcNxbEHiunuvAeJj6onZzz6NDgEa2rb6DhYKpAK7AYvg+tDyTwkpdpuHPt6MJ
/9aESi8sKQUa/HX0jOmqz2iZ4SC7S4KZE6uc7Syv+5yhfsDnrJ1h+It4F8Q65mjr
T+5vSYK6FL31DeHs39B8cHA6V/OI5DO0josiecA0hJScbptWrOokB6ga1nzN4exy
bKcVRV6Hd2zmpaJQSXLv
=Dux2
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
