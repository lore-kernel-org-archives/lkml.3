Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598Ab3IRRDl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 13:03:41 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:33940 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3IRRDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 13:03:38 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: balbi@ti.com
Subject: [PATCH usb 2/2] usb: musb: Call atomic_notifier_call_chain when status is changed
Date: Wed, 18 Sep 2013 19:03:34 +0200
User-Agent: KMail/1.13.7 (Linux/3.11.0-1+synaptics-generic; KDE/4.11.1; x86_64; ; )
Cc: Javier Martinez Canillas <martinez.javier@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Tony Lindgren <tony@atomide.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        freemangordon@abv.bg, Aaro Koskinen <aaro.koskinen@iki.fi>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com> <201309181843.49850@pali> <20130918164816.GN21559@radagast>
In-Reply-To: <20130918164816.GN21559@radagast>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2242568.xTFfqbM3Qu";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201309181903.34696@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2242568.xTFfqbM3Qu
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

More power supply drivers depends on vbus events and without it they not
working. Power supply drivers using usb_register_notifier, so to deliver
events it is needed to call atomic_notifier_call_chain.

So without atomic notifier power supply driver isp1704 not retrieving
vbus status and reporting bogus values to userspace and also to board
platform data functions. Without proper data charger drivers trying to
charge battery also when charger is disconnected or do not start charging
when wallcharger connects.

Atomic notifier in musb driver was used before v3.5 and was replaced with
omap mailbox. This patch adding atomic_notifier_call_chain call from
function omap_musb_set_mailbox.

Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>

diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index f44e8b5..5c40252 100644
=2D-- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -305,6 +305,9 @@ static void omap_musb_set_mailbox(struct omap2430_glue =
*glue)
 	default:
 		dev_dbg(dev, "ID float\n");
 	}
+
+	atomic_notifier_call_chain(&musb->xceiv->notifier,
+			musb->xceiv->last_event, NULL);
 }
=20

--nextPart2242568.xTFfqbM3Qu
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlI53OYACgkQi/DJPQPkQ1KpXQCfXn4HFtnSZFXIwAl+bEiXjLIt
yVUAn3O5cg2lvS6bW1JsKZeCOUSwgGH4
=7WR8
-----END PGP SIGNATURE-----

--nextPart2242568.xTFfqbM3Qu--
