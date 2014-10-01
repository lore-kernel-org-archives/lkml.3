Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751148AbaJAF63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 01:58:29 -0400
Received: from ozlabs.org ([103.22.144.67]:53206 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbaJAF61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 01:58:27 -0400
Date: Wed, 1 Oct 2014 15:58:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>
Subject: linux-next: manual merge of the gpio tree with Linus Torlvads' tree
Message-ID: <20141001155818.53abfcb2@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/==e08Ajrmt=tTrLlbhKd=fg"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/==e08Ajrmt=tTrLlbhKd=fg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Today's linux-next merge of the gpio tree got a conflict in
drivers/gpio/gpiolib.c between commit 324b0398781e ("gpio: Fix
potential NULL handler data in chained irqchip handler") from Linus
Torvalds' tree and commit 3f97d5fcf99c ("gpio: handle also nested
irqchips in the chained handler set-up") from the gpio tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpio/gpiolib.c
index c68d037de656,6e00c82be142..000000000000
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@@ -413,12 -407,25 +407,25 @@@ void gpiochip_set_chained_irqchip(struc
  		return;
  	}
 =20
- 	/*
- 	 * The parent irqchip is already using the chip_data for this
- 	 * irqchip, so our callbacks simply use the handler_data.
- 	 */
- 	irq_set_handler_data(parent_irq, gpiochip);
- 	irq_set_chained_handler(parent_irq, parent_handler);
+ 	if (parent_handler) {
+ 		if (gpiochip->can_sleep) {
+ 			chip_err(gpiochip,
+ 				 "you cannot have chained interrupts on a "
+ 				 "chip that may sleep\n");
+ 			return;
+ 		}
 -		irq_set_chained_handler(parent_irq, parent_handler);
+ 		/*
+ 		 * The parent irqchip is already using the chip_data for this
+ 		 * irqchip, so our callbacks simply use the handler_data.
+ 		 */
+ 		irq_set_handler_data(parent_irq, gpiochip);
++		irq_set_chained_handler(parent_irq, parent_handler);
+ 	}
+=20
+ 	/* Set the parent IRQ for all affected IRQs */
+ 	for (offset =3D 0; offset < gpiochip->ngpio; offset++)
+ 		irq_set_parent(irq_find_mapping(gpiochip->irqdomain, offset),
+ 			       parent_irq);
  }
  EXPORT_SYMBOL_GPL(gpiochip_set_chained_irqchip);
 =20

--Sig_/==e08Ajrmt=tTrLlbhKd=fg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUK5gAAAoJEMDTa8Ir7ZwVkNYP/RQTiD0QcAIUkT96vc2HV5sy
nV/ptJhYa76UgXsYHxZehtxMHn2Mlt6Ng7pLkKB2K+hLlSxvqifOMrbIhJRbVM8f
DQLK4WwkVsYulVe4Q05MScZTIjseijr4Z0Gc/cJhG/EQk0pwmSpwWuxxlizzaTMb
Y6AGzHHrK5jLQnl7NVTkq3tcyVO3pdBZBKSXBbrvsXbtjq0FfdXhJDG5Hg4WE6qh
bqIShfboSF6q4xndP47gOrL2zt++0kP9pETuA0gshLucSfkrvZl/IedZ9MAkUNEq
7KxZGtB+pIiqhBRLquSXn+JmzRHzQlXIj6EtBaSIldOgV2SDloTMj9JWMKSwaYsp
ZW3U5iPJbUPi+EXq1HUsExH1RId2vZqECNF8Wni7/wfWM1/H1ioiHXrSWSdKtTpM
O5lZNlQ5am7dPbvDxJtIFETe+1YBaj5YmusuURvEr1msWijx0lUWk8lSHBPpyaer
CsRGp/mLMjOnmDmnMM9LV9CcIt1UrtjANTfgZxdaYhsZL2BMqeq7tcHoSbqULJJ1
TJWa5uIeG9RO9erU9A5AGkBFRCyzTONYG0ZjY1dnqQOf1JRi93RSBYM37sLo2jiY
r4RI0Wa3C+GRpqj+k/omHKHoDJoNXZUtxwVabOuAnPeAhLwLWEMfS9IeIv8o5RuQ
qMgHPdgD9maRFXEFvq20
=uhjV
-----END PGP SIGNATURE-----

--Sig_/==e08Ajrmt=tTrLlbhKd=fg--
