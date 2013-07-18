Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758920Ab3GRNSf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 09:18:35 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44788 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754507Ab3GRNS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 09:18:29 -0400
Date: Thu, 18 Jul 2013 14:18:22 +0100
From: Mark Brown <broonie@kernel.org>
To: Sourav Poddar <sourav.poddar@ti.com>
Cc: spi-devel-general@lists.sourceforge.net, grant.likely@linaro.org,
        balbi@ti.com, rnayak@ti.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130718131822.GN22506@sirena.org.uk>
References: <1374141687-10790-1-git-send-email-sourav.poddar@ti.com>
 <1374141687-10790-3-git-send-email-sourav.poddar@ti.com>
 <20130718104233.GG22506@sirena.org.uk>
 <51E7D569.2010709@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MUgosN8HgFyWu2R6"
Content-Disposition: inline
In-Reply-To: <51E7D569.2010709@ti.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv4 2/3] drivers: spi: Add qspi flash controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MUgosN8HgFyWu2R6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 18, 2013 at 05:15:45PM +0530, Sourav Poddar wrote:
> On Thursday 18 July 2013 04:12 PM, Mark Brown wrote:

> >>+	list_for_each_entry(t,&m->transfers, transfer_list) {
> >>+		qspi->cmd |=3D QSPI_WLEN(t->bits_per_word);
> >>+		qspi->cmd |=3D QSPI_WC_CMD_INT_EN;
> >>+
> >>+		ret =3D qspi_transfer_msg(qspi, t);
> >>+		if (ret) {
> >>+			dev_dbg(qspi->dev, "transfer message failed\n");
> >>+			return -EINVAL;
> >>+		}
> >>+
> >>+		m->actual_length +=3D t->len;
> >>+
> >>+		if (list_is_last(&t->transfer_list,&m->transfers))
> >>+			goto out;
> >>+	}
> >The use of list_is_last() here is *realy* strange - what's going on
> >there?

> We are checking if there is any transfer left, if no we are signalling the
> flash device about the end of transfer.

Please be more specific.  How will you ever reach the end of the
transfer list in a way which wouldn't cause the for loop to terminate?

> >>+static irqreturn_t ti_qspi_isr(int irq, void *dev_id)
> >>+{
> >>+	struct ti_qspi *qspi =3D dev_id;
> >>+	u16 mask, stat;
> >>+
> >>+	irqreturn_t ret =3D IRQ_HANDLED;
> >>+
> >>+	spin_lock(&qspi->lock);
> >>+
> >>+	stat =3D ti_qspi_readl(qspi, QSPI_SPI_STATUS_REG);
> >>+	mask =3D ti_qspi_readl(qspi, QSPI_INTR_ENABLE_SET_REG);
> >>+
> >>+	if (stat&&  mask)
> >>+		ret =3D IRQ_WAKE_THREAD;
> >>+
> >>+	spin_unlock(&qspi->lock);
> >>+
> >>+	return ret;

> >According to the above code we might interrupt for masked events...
> >that's a bit worrying isn't it?

> Yes, there is WC interrupt enable bit which enables the interrupt.
> This interrupt
> gets disabled by writing to the CLEAR reg in the threaded irq.

So why do we report that we handled the interrupt then?  Shouldn't we at
least warn if we're getting spurious IRQs?

> >>+	ret =3D devm_request_threaded_irq(&pdev->dev, irq, ti_qspi_isr,
> >>+			ti_qspi_threaded_isr, IRQF_NO_SUSPEND | IRQF_ONESHOT,
> >>+			dev_name(&pdev->dev), qspi);
> >>+	if (ret<  0) {
> >>+		dev_err(&pdev->dev, "Failed to register ISR for IRQ %d\n",
> >>+				irq);
> >>+		goto free_master;
> >>+	}
> >Standard question about devm_request_threaded_irq() - how can we be
> >certain it's safe to use during removal?
> I am not sure about the exact flow. If we see the api description,
> it says about irq getting
> freed automatically.
> Practically, I will check that on removing the driver, cat
> /proc/interrupts  should not show
> the required interrupt getting registered.
> Though, I see an api also existing "devm_free_irq", which explicitly
> un allocate your irq requested
> through devm_* variants.

You're missing the point here - how can you be sure that the interrupt
can't fire?

>=20
>=20
>=20

--MUgosN8HgFyWu2R6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR5+saAAoJELSic+t+oim9ahIP/RiffQsGKM+PGMJD/A0lZUYT
njhqFLlCCDn9KdVEECzS+27d8kpnMFu+dsxndZDcZy8/LbA4gZbN7lNw9caTkAI2
ZUcJ2WDY7JZkputNFQRtJAbeq7JtztkM8obgsnOQiBBjfshCpbyZUlLAhbeuVUqb
udFgKmf0UdO2dg4F16OF1dkuctsBG777LqYKDESmyIBYc0LNjQTV36yiUuZsFtkt
yCw/aQOIJUBnU6yrtRz6GTvANDgp5vCdUTYoNWCYk7kkCgvHmkXxS31HyVjAWgLK
/OfRNAOxyWLwSwNcxbj0JENR+3z9o5sjvDmPVfAKFire07SGiIqyURmHcgz6LoCX
f2WpO3ksyEo/FOgHc4tAiMBfpufymHIOZk9tkMsrG9kQtvKsx3kc39oeTYu50dQL
VG1s6Aqol1o5bzmkB6GfOwHLhixUWD/jg/LrZPzMAKtvhiOUk9FUUrlGT3Vk8nf6
j/F62ALiIVdzLqASJvsBLZoCalU5SsD/UHf1FN0lEAbqW0ihWSCcDO9caCrqb6Rl
t/bveviWERGucikFYjPb4JScV74SqesSGELlVkecleOg5JbNEHyhOym+vhZEReFo
EBO6CkYzNkgkiNRbHgE1ejMgUGc1+VXTVEsz10PwKw24rzrCtqlWa/MEv5lBOOtO
GCkTB44I2HRxMH3h+XNt
=TYyn
-----END PGP SIGNATURE-----

--MUgosN8HgFyWu2R6--
