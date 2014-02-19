Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408AbaBSPi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 10:38:57 -0500
Received: from sauhun.de ([89.238.76.85]:51964 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754385AbaBSPiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 10:38:54 -0500
Date: Wed, 19 Feb 2014 16:38:50 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-i2c@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rui Wang <ruiv.wang@gmail.com>
Subject: Re: [PATCH v6 3/4] i2c_imc: New driver for Intel's iMC, found on
 LGA2011 chips
Message-ID: <20140219153850.GB13973@katana>
References: <cover.1387588711.git.luto@amacapital.net>
 <5508fef38f88601de1973d4252bc7aa98b54ea53.1387588711.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+g7M9IMkV8truYOl"
Content-Disposition: inline
In-Reply-To: <5508fef38f88601de1973d4252bc7aa98b54ea53.1387588711.git.luto@amacapital.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+g7M9IMkV8truYOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


> +config I2C_IMC
> +	tristate "Intel iMC (LGA 2011) SMBus Controller"
> +	depends on PCI && X86
> +	select I2C_DIMM_BUS
> +	help
> +	  If you say yes to this option, support will be included for the Intel
> +	  Integrated Memory Controller SMBus host controller interface.  This
> +	  controller is found on LGA 2011 Xeons and Core i7 Extremes.
> +
> +	  It is possibly, although unlikely, that the use of this driver will
> +	  interfere with your platform's RAM thermal management.

This sounds scary and thus needs some more detail :) How does that show?
What can happen? Anything to take care of?

> @@ -15,6 +15,7 @@ obj-$(CONFIG_I2C_AMD8111)	+= i2c-amd8111.o
>  obj-$(CONFIG_I2C_I801)		+= i2c-i801.o
>  obj-$(CONFIG_I2C_ISCH)		+= i2c-isch.o
>  obj-$(CONFIG_I2C_ISMT)		+= i2c-ismt.o
> +obj-$(CONFIG_I2C_IMC)		+= i2c-imc.o

This is not perfectly sorted.

>  obj-$(CONFIG_I2C_NFORCE2)	+= i2c-nforce2.o
>  obj-$(CONFIG_I2C_NFORCE2_S4985)	+= i2c-nforce2-s4985.o
>  obj-$(CONFIG_I2C_PIIX4)		+= i2c-piix4.o
> diff --git a/drivers/i2c/busses/i2c-imc.c b/drivers/i2c/busses/i2c-imc.c
> new file mode 100644
> index 0000000..c846077
> --- /dev/null
> +++ b/drivers/i2c/busses/i2c-imc.c
> @@ -0,0 +1,559 @@
> +/*
> + * Copyright (c) 2013 Andrew Lutomirski <luto@amacapital.net>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2
> + * as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

Please skip the address. And run checkpatch.pl --strict! It would have
warned you about this and other stuff:

total: 1 errors, 3 warnings, 2 checks, 587 lines checked


> +/*
> + * The datasheet can be found here, for example:
> + * http://www.intel.com/content/dam/www/public/us/en/documents/datasheets/xeon-e5-1600-2600-vol-2-datasheet.pdf
> + *
> + * There seem to be quite a few bugs or spec errors, though:

Kudos for the useful comments!

> +/* Register offsets (in PCI configuration space) */
> +#define SMBSTAT(i)			(0x180 + 0x10*i)
> +#define SMBCMD(i)			(0x184 + 0x10*i)
> +#define SMBCNTL(i)			(0x188 + 0x10*i)
> +#define SMB_TSOD_POLL_RATE_CNTR(i)	(0x18C + 0x10*i)
> +#define SMB_TSOD_POLL_RATE		(0x1A8)

Spaces around operators!

> +	int i;
> +	for (i = 0; i < 50; i++) {
> +		pci_read_config_dword(priv->pci_dev, SMBSTAT(chan), stat);
> +		if (!(*stat & SMBSTAT_SMB_BUSY))
> +			return 0;
> +		udelay(70);

usleep_range?

> +	}
> +
> +	return -ETIMEDOUT;
> +}
> +

...

> +static s32 imc_smbus_xfer(struct i2c_adapter *adap, u16 addr,
> +			  unsigned short flags, char read_write, u8 command,
> +			  int size, union i2c_smbus_data *data)
> +{
> +	int ret, chan;
> +	u32 cmd = 0, cntl, final_cmd, final_cntl, stat;
> +	struct imc_channel *ch;
> +	struct imc_priv *priv = i2c_get_adapdata(adap);
> +
> +	if (atomic_read(&imc_raced))
> +		return -EIO;  /* Minimize damage. */
> +
> +	chan = (adap == &priv->channels[0].adapter ? 0 : 1);
> +	ch = &priv->channels[chan];
> +
> +	if (addr > 0x7f)
> +		return -EOPNOTSUPP;  /* No large address support */

Unneeded. The core checks for that...

> +	if (flags)
> +		return -EOPNOTSUPP;  /* No PEC */

... and your code would bail out if I2C_M_TEN was set.

> +	if (size != I2C_SMBUS_BYTE_DATA && size != I2C_SMBUS_WORD_DATA)
> +		return -EOPNOTSUPP;
> +
> +	/* Encode CMD part of addresses and access size */
> +	cmd  |= ((u32)addr & 0x7) << SMBCMD_SA_SHIFT;
> +	cmd |= ((u32)command) << SMBCMD_BA_SHIFT;
> +	if (size == I2C_SMBUS_WORD_DATA)
> +		cmd |= SMBCMD_WORD_ACCESS;
> +
> +	/* Encode read/write and data to write */
> +	if (read_write == I2C_SMBUS_READ) {
> +		cmd |= SMBCMD_TYPE_READ;
> +	} else {
> +		cmd |= SMBCMD_TYPE_WRITE;
> +		cmd |= (size == I2C_SMBUS_WORD_DATA
> +			    ? swab16(data->word)
> +			    : data->byte);
> +	}
> +
> +	mutex_lock(&ch->mutex);

Why is the per-adapter lock not sufficient?

> +
> +	ret = imc_channel_claim(priv, chan);
> +	if (ret)
> +		goto out_unlock;
> +
> +	pci_read_config_dword(priv->pci_dev, SMBCNTL(chan), &cntl);
> +	cntl &= ~SMBCNTL_DTI_MASK;
> +	cntl |= ((u32)addr >> 3) << SMBCNTL_DTI_SHIFT;
> +	pci_write_config_dword(priv->pci_dev, SMBCNTL(chan), cntl);
> +
> +	/*
> +	 * This clears SMBCMD_PNTR_SEL.  We leave it cleared so that we don't
> +	 * need to think about keeping the TSOD pointer state consistent with
> +	 * the hardware's expectation.  This probably has some miniscule
> +	 * power cost, as TSOD polls will take 9 extra cycles.
> +	 */
> +	cmd |= SMBCMD_TRIGGER;
> +	pci_write_config_dword(priv->pci_dev, SMBCMD(chan), cmd);
> +
> +	if (imc_wait_not_busy(priv, chan, &stat) != 0) {
> +		/* Timeout.  TODO: Reset the controller? */
> +		ret = -EIO;
> +		dev_err(&priv->pci_dev->dev, "controller is wedged\n");
> +		goto out_release;
> +	}
> +
> +	/*
> +	 * Be paranoid: try to detect races.  This will only detect races
> +	 * against BIOS, not against hardware.  (I've never seen this happen.)
> +	 */
> +	pci_read_config_dword(priv->pci_dev, SMBCMD(chan), &final_cmd);
> +	pci_read_config_dword(priv->pci_dev, SMBCNTL(chan), &final_cntl);
> +	if (((cmd ^ final_cmd) & SMBCMD_OUR_BITS) ||
> +	    ((cntl ^ final_cntl) & SMBCNTL_OUR_BITS)) {
> +		WARN(1, "iMC SMBUS raced against firmware");
> +		dev_emerg(&priv->pci_dev->dev,
> +			  "Access to channel %d raced: cmd 0x%08X->0x%08X, cntl 0x%08X->0x%08X\n",
> +			  chan, cmd, final_cmd, cntl, final_cntl);

Ehrm, do we need WARN and dev_emerg? And the error message should be
updated. It should tell what the user should do next to handle the
emergency.


...

> +	if (!imc_channel_can_claim(priv, i)) {
> +		dev_warn(&priv->pci_dev->dev,
> +			 "iMC channel %d: we cannot control the HW.  Is CLTT on?\n",
> +			 i);

That should go on the previous line IMO. The 80 char limit may be broken
for readability reasons.

> +MODULE_AUTHOR("Andrew Lutomirski <luto@amacapital.net>");
> +MODULE_DESCRIPTION("iMC SMBus driver");
> +MODULE_LICENSE("GPL");

GPL v2 according to header.

Thanks,

   Wolfram


--+g7M9IMkV8truYOl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTBNAKAAoJEBQN5MwUoCm2AkYP/R/ZrPrsKZz3VKuL9rkUl55O
oLcVYoII/v+FVcRWWJL9H1kVsbbQ0ru6LPfHP+DOSLiCAmmrNxr+IRJKYPjSZ3Sd
8ZeUKserBPLDpez3XEAj1Qh4po87BGoihU8IzAA6/aD1v5h8ZsrPLN8x7esWPHmH
mJKyKaHuXw7LSYgiIndwqwX8HYuVYejkGXtqGMkCDbeCUAosRKBKIpYWNFfgzCuV
7Hbst76orys2PV0zpp08IXdYiVRL43o/9KauRgxHd/Ig0IxKaDYbGkr2ii6wgHg2
PjaGT6xO0mZfS/RarzDBDMMM9abicdQPPDWAeCcGVc5XrLuNssScEw3eblgIDcpV
bl40Izv0KVVfRckq15uDoqm3UXMHngv4W5jIteCtk78W3n59OmfZxwkWdof7waH0
R7IFhwAHQ5kczoWC6IlbNPQ4VQeyzEC2tCOfMUAeud1dwR0kzNybRCejt7wh3yZN
NmlHMi4IpdEzeBxJWj2LBsaiHnpqGUbzbqU/vOUjQuA8bs5DqAAuqzUz86aan7Es
IHIynXnS2wo9yxq9Jx7d/W/2lI4TiDk5bKcp1mueZWODk4Z5dN5lagPOOrMQT0LI
1dm0J8eN3WlRL/05RgUF2qm1Ga2uyqDk8wH7KyDlhGLnAkYsr8KrJBQAblxokJp8
I1JOjvgu29czP3ManVPk
=kp7H
-----END PGP SIGNATURE-----

--+g7M9IMkV8truYOl--
