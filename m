Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894AbaCTSNk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 14:13:40 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48443 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731AbaCTSNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 14:13:39 -0400
Date: Thu, 20 Mar 2014 13:11:45 -0500
From: Felipe Balbi <balbi@ti.com>
To: Peter Hurley <peter@hurleysoftware.com>
CC: <balbi@ti.com>, Marcel Holtmann <marcel@holtmann.org>,
        Alan Cox <alan@linux.intel.com>, Greg KH <gregkh@linuxfoundation.org>,
        Muralidharan Karicheri <m-karicheri2@ti.com>,
        <linux-bluetooth@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>
Subject: Re: hci_ldsic nested locking problem
Message-ID: <20140320181145.GC3959@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140320163435.GH32692@saruman.home>
 <1395333736.22077.32.camel@acox1-desk.ger.corp.intel.com>
 <20140320171621.GA2827@saruman.home>
 <532B25FC.3070408@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z4+8/lEcDcG5Ke9S"
Content-Disposition: inline
In-Reply-To: <532B25FC.3070408@hurleysoftware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--z4+8/lEcDcG5Ke9S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 20, 2014 at 01:31:40PM -0400, Peter Hurley wrote:
> [ +cc Huang Shijie ]
>=20
> On 03/20/2014 01:16 PM, Felipe Balbi wrote:
> >On Thu, Mar 20, 2014 at 04:42:16PM +0000, Alan Cox wrote:
> >>On Thu, 2014-03-20 at 11:34 -0500, Felipe Balbi wrote:
> >>>Hi,
> >>>
> >>>when 8250 driver calls uart_write_wakeup(), the tty port lock is alrea=
dy
> >>>taken. hci_ldisc.c's implementation of ->write_wakeup() calls
> >>>tty->ops->write() to actually send the characters, but that call will
> >>>try to acquire the same port lock again.
> >>>
> >>>Looking at other line disciplines that looks like a bug in hci_ldisc.c.
> >>>Am I correct to assume that ->write_wakeup() is supposed to *just*
> >>>wakeup the bottom half so we handle ->write() in another context ?
> >>>
> >>>Is it legal to call tty->ops->write() from within ->write_wakeup() ?
> >>
> >>It isn't because you might send all the bytes and go
> >>
> >>	write
> >>		write_wakeup
> >>			write
> >>				write wakeup
> >>					...
> >>
> >>and recurse
> >
> >cool, so there really is a bug in hci_ldisc. Marcel, any tips on how do
> >you want this to be sorted out ?
>=20
> hci_uart_tx_wakeup() should perform the I/O as work.
> FWIW, this was reported by Huang Shijie back on Dec 6.
>=20
> I'd fix it but I have no way to test it.

here's a build-tested only patch which is waiting for testing from other
colleagues who've got a platform to reproduce the problem:

diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index bc68a44..789000d 100644
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
@@ -289,6 +296,7 @@ static int hci_uart_tty_open(struct tty_struct *tty)
 	tty->receive_room =3D 65536;
=20
 	INIT_WORK(&hu->init_ready, hci_uart_init_work);
+	INIT_WORK(&hu->write_work, hci_uart_write_work);
=20
 	spin_lock_init(&hu->rx_lock);
=20
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
balbi

--z4+8/lEcDcG5Ke9S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTKy9hAAoJEIaOsuA1yqREkbAQAKWISHPHVeBofhEuz77+3HUD
3EIuJNaDlgMNy7hxi6sQZiHZ0A/HQsyyOOzkCGzYlF2asTktV993Yl5eBeMR9aqp
gL52KLhQw3aMnmVWc0CuAYlEDPPl6YxsndGgqUwUHy0knE6KDUBcm0k5Ac9RP9G2
kgz4BsF6mYNtKjIDNKZ+guMUWdn+GEde7eNW7OFsCe1R+Ri0Ju30WBzxxp7NhcLl
A092w/AzEKG43Ndrt3uAUBZ/yzUs1FTG5bFNIa6cwSTyLAVbZcw/5Idq0Ks8cp+q
6aNNdHA2kvuJXJ4RbtBAtrFfW05pyX7rE/Zah108bb2tb3nwYFvL4GlM7yF5J8Nb
BND6PenE1oOn9UbIxhV1Pumx/rG/RapDgX+0EDXEJcKF213Cej9MVfQ9d+Q/boCi
Ll5n+SXfK0VqZEraBcDXzigJtkanTNGO65aa9B+8U9MGtmS/uIJgVhjfWrr1DSIq
vTsqF00CsZmHLIFw0sPBcclGGS0I6hEZiY13yYzCUy1OlGig371DaW6HHp0JIa2P
7Pz1LMu9Or+zV+dzu+ADhUyZX8bjWxzgwDdfxFuDMnsmmhZ5eI+VYyfxKu0DAqMP
oabKGQ4uXq3fZ90wPqhKWjTFB3hjrTjJiKZ+jr3mhatCdn3KoWopj5yXukqQKTQo
uAI3KGMr8ZiemGBLvyG8
=K1es
-----END PGP SIGNATURE-----

--z4+8/lEcDcG5Ke9S--
