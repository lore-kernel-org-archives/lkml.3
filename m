Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964807AbaCTTFw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 15:05:52 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55970 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933548AbaCTTFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 15:05:50 -0400
Date: Thu, 20 Mar 2014 14:03:57 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Peter Hurley <peter@hurleysoftware.com>,
        Marcel Holtmann <marcel@holtmann.org>, Alan Cox <alan@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Muralidharan Karicheri <m-karicheri2@ti.com>,
        <linux-bluetooth@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>
Subject: Re: hci_ldsic nested locking problem
Message-ID: <20140320190357.GG3959@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140320163435.GH32692@saruman.home>
 <1395333736.22077.32.camel@acox1-desk.ger.corp.intel.com>
 <20140320171621.GA2827@saruman.home>
 <532B25FC.3070408@hurleysoftware.com>
 <20140320181145.GC3959@saruman.home>
 <532B319D.4090208@hurleysoftware.com>
 <20140320182528.GE3959@saruman.home>
 <20140320190154.GF3959@saruman.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fnm8lRGFTVS/3GuM"
Content-Disposition: inline
In-Reply-To: <20140320190154.GF3959@saruman.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Fnm8lRGFTVS/3GuM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Mar 20, 2014 at 02:01:54PM -0500, Felipe Balbi wrote:
> > @@ -318,6 +326,8 @@ static void hci_uart_tty_close(struct tty_struct *t=
ty)
> >  	if (hdev)
> >  		hci_uart_close(hdev);
> > =20
> > +	cancel_work_sync(&hy->write_work);
>=20
> forgot to commit, darn it

here it is:

=46rom eaf7ff6f2d224f202369e4820b76a03fa664fab0 Mon Sep 17 00:00:00 2001
=46rom: Felipe Balbi <balbi@ti.com>
Date: Thu, 20 Mar 2014 13:20:10 -0500
Subject: [PATCH] bluetooth: hci_ldisc: fix deadlock condition

LDISCs shouldn't call tty->ops->write() from within
->write_wakeup().

->write_wakeup() is called with port lock taken and
IRQs disabled, tty->ops->write() will try to acquire
the same port lock and we will deadlock.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/bluetooth/hci_ldisc.c | 20 +++++++++++++++-----
 drivers/bluetooth/hci_uart.h  |  1 +
 2 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index 6e06f6f..5a53e50 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -118,10 +118,6 @@ static inline struct sk_buff *hci_uart_dequeue(struct =
hci_uart *hu)
=20
 int hci_uart_tx_wakeup(struct hci_uart *hu)
 {
-	struct tty_struct *tty =3D hu->tty;
-	struct hci_dev *hdev =3D hu->hdev;
-	struct sk_buff *skb;
-
 	if (test_and_set_bit(HCI_UART_SENDING, &hu->tx_state)) {
 		set_bit(HCI_UART_TX_WAKEUP, &hu->tx_state);
 		return 0;
@@ -129,6 +125,18 @@ int hci_uart_tx_wakeup(struct hci_uart *hu)
=20
 	BT_DBG("");
=20
+	schedule_work(&hu->write_work);
+
+	return 0;
+}
+
+static void hci_uart_write_work(struct work_struct *work)
+{
+	struct hci_uart *hu =3D container_of(work, struct hci_uart, init_ready);
+	struct tty_struct *tty =3D hu->tty;
+	struct hci_dev *hdev =3D hu->hdev;
+	struct sk_buff *skb;
+
 restart:
 	clear_bit(HCI_UART_TX_WAKEUP, &hu->tx_state);
=20
@@ -153,7 +161,6 @@ restart:
 		goto restart;
=20
 	clear_bit(HCI_UART_SENDING, &hu->tx_state);
-	return 0;
 }
=20
 static void hci_uart_init_work(struct work_struct *work)
@@ -281,6 +288,7 @@ static int hci_uart_tty_open(struct tty_struct *tty)
 	tty->receive_room =3D 65536;
=20
 	INIT_WORK(&hu->init_ready, hci_uart_init_work);
+	INIT_WORK(&hu->write_work, hci_uart_write_work);
=20
 	spin_lock_init(&hu->rx_lock);
=20
@@ -318,6 +326,8 @@ static void hci_uart_tty_close(struct tty_struct *tty)
 	if (hdev)
 		hci_uart_close(hdev);
=20
+	cancel_work_sync(&hu->write_work);
+
 	if (test_and_clear_bit(HCI_UART_PROTO_SET, &hu->flags)) {
 		if (hdev) {
 			if (test_bit(HCI_UART_REGISTERED, &hu->flags))
diff --git a/drivers/bluetooth/hci_uart.h b/drivers/bluetooth/hci_uart.h
index fffa61f..12df101 100644
--- a/drivers/bluetooth/hci_uart.h
+++ b/drivers/bluetooth/hci_uart.h
@@ -68,6 +68,7 @@ struct hci_uart {
 	unsigned long		hdev_flags;
=20
 	struct work_struct	init_ready;
+	struct work_struct	write_work;
=20
 	struct hci_uart_proto	*proto;
 	void			*priv;
--=20
1.9.1.286.g5172cb3


--=20
balbi

--Fnm8lRGFTVS/3GuM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTKzudAAoJEIaOsuA1yqRE4cwP/3pUTISIhQVOzyYIwCwwIEw/
lWxnQjhaGuoYYlL1sFoAucj0vh9AHDH3zE74/ltSoBR5GT+mx2HxvrYmTRCpMVD8
pD0bcRnVWx5j3tJbDVZVC/DuiL06TTTn/MRVcs36U4CRtXF2hurBqx3mAtalt1FO
MzTf7pH6wpUEFEbnqnOY3lrfKrtATn8fP/GXSIcnButY3z4C/FiAwsDqOTdKb0+J
zmVsdeRYv8HDMfOuLuNEttFcBIOMMW5p1UEvYmSksr1VNtEhm1pL7E7mGPW69Mr2
VoSMkeSAyJosNs+4TCcvWkuOJrZjZTeTibf96C3uhILFM+sJOP9O+rCHRaveBphM
Q5+0FmZ6bSC+/ZGhWQAeQjG0NocoSL6KEpMirABLhDQmvCyt+PBYLH6ztrV8wyZD
0eFqqIqGiCnQL1rWgzNMlWCdqiBefc5trBAbTElTPcfOYRV3GnnUyi/CRV5WExg8
zLPm5NaslZdD7/TCX6h2F4zkiTQe6LV3s7u6NPA8g1L8BNhqX/3Vs28ePi90Lluj
qEe4SvO1fa5261EsipfmdRj6YzjIVE24TZY5SCUrpEWuCpaWAPPOUK3lb5+b7D2q
HbvFsfTmIhsGefHqP5SoC3UfLrous67B7PZOovYLYDNQ64WZuF4+JwdZVuv8XaY0
M2KFvQMahyVBnz19sgIi
=sTPQ
-----END PGP SIGNATURE-----

--Fnm8lRGFTVS/3GuM--
