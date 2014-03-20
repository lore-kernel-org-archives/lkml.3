Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759752AbaCTT1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 15:27:37 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55310 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271AbaCTT1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 15:27:34 -0400
Date: Thu, 20 Mar 2014 14:25:33 -0500
From: Felipe Balbi <balbi@ti.com>
To: Peter Hurley <peter@hurleysoftware.com>
CC: <balbi@ti.com>, Marcel Holtmann <marcel@holtmann.org>,
        Alan Cox <alan@linux.intel.com>, Greg KH <gregkh@linuxfoundation.org>,
        Muralidharan Karicheri <m-karicheri2@ti.com>,
        <linux-bluetooth@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Huang Shijie <b32955@freescale.com>
Subject: Re: hci_ldsic nested locking problem
Message-ID: <20140320192533.GK3959@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140320163435.GH32692@saruman.home>
 <1395333736.22077.32.camel@acox1-desk.ger.corp.intel.com>
 <20140320171621.GA2827@saruman.home>
 <532B25FC.3070408@hurleysoftware.com>
 <20140320181145.GC3959@saruman.home>
 <532B319D.4090208@hurleysoftware.com>
 <20140320182528.GE3959@saruman.home>
 <532B3E93.7060902@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IuJpT0rwbUevm2bB"
Content-Disposition: inline
In-Reply-To: <532B3E93.7060902@hurleysoftware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--IuJpT0rwbUevm2bB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Mar 20, 2014 at 03:16:35PM -0400, Peter Hurley wrote:
> On 03/20/2014 02:25 PM, Felipe Balbi wrote:
> >On Thu, Mar 20, 2014 at 02:21:17PM -0400, Peter Hurley wrote:
> >>On 03/20/2014 02:11 PM, Felipe Balbi wrote:
> >>>On Thu, Mar 20, 2014 at 01:31:40PM -0400, Peter Hurley wrote:
> >>>>[ +cc Huang Shijie ]
> >>>>
> >>>>On 03/20/2014 01:16 PM, Felipe Balbi wrote:
> >>>>>On Thu, Mar 20, 2014 at 04:42:16PM +0000, Alan Cox wrote:
> >>>>>>On Thu, 2014-03-20 at 11:34 -0500, Felipe Balbi wrote:
> >>>>>>>Hi,
> >>>>>>>
> >>>>>>>when 8250 driver calls uart_write_wakeup(), the tty port lock is a=
lready
> >>>>>>>taken. hci_ldisc.c's implementation of ->write_wakeup() calls
> >>>>>>>tty->ops->write() to actually send the characters, but that call w=
ill
> >>>>>>>try to acquire the same port lock again.
> >>>>>>>
> >>>>>>>Looking at other line disciplines that looks like a bug in hci_ldi=
sc.c.
> >>>>>>>Am I correct to assume that ->write_wakeup() is supposed to *just*
> >>>>>>>wakeup the bottom half so we handle ->write() in another context ?
> >>>>>>>
> >>>>>>>Is it legal to call tty->ops->write() from within ->write_wakeup()=
 ?
> >>>>>>
> >>>>>>It isn't because you might send all the bytes and go
> >>>>>>
> >>>>>>	write
> >>>>>>		write_wakeup
> >>>>>>			write
> >>>>>>				write wakeup
> >>>>>>					...
> >>>>>>
> >>>>>>and recurse
> >>>>>
> >>>>>cool, so there really is a bug in hci_ldisc. Marcel, any tips on how=
 do
> >>>>>you want this to be sorted out ?
> >>>>
> >>>>hci_uart_tx_wakeup() should perform the I/O as work.
> >>>>FWIW, this was reported by Huang Shijie back on Dec 6.
> >>>>
> >>>>I'd fix it but I have no way to test it.
> >>>
> >>>here's a build-tested only patch which is waiting for testing from oth=
er
> >>>colleagues who've got a platform to reproduce the problem:
> >>
> >>Where's the cancel_work_sync() on teardown?
> >
> >here, as a patch too this time:
>=20
> Thanks. Minor edits below but, strictly speaking, not necessary.
>=20
> Reviewed-by: Peter Hurley <peter@hurleysoftware.com>
>=20
>=20
> > From 3ee6b74833f154df64a6164476b854846206a3f2 Mon Sep 17 00:00:00 2001
> >From: Felipe Balbi <balbi@ti.com>
> >Date: Thu, 20 Mar 2014 13:20:10 -0500
> >Subject: [PATCH] bluetooth: hci_ldisc: fix deadlock condition
> >
> >LDISCs shouldn't call tty->ops->write() from within
> >->write_wakeup().
> >
> >->write_wakeup() is called with port lock taken and
> >IRQs disabled, tty->ops->write() will try to acquire
> >the same port lock and we will deadlock.
> >
>=20
> I know you found it independently but ?
>=20
> Reported-by: Huang Shijie <b32955@freescale.com>

I will never add any *-by tags without seeing it in the mailing list.
Now I can add it to the patch and send it as a real patch (git
send-email it).

> >Signed-off-by: Felipe Balbi <balbi@ti.com>
> >---
> >  drivers/bluetooth/hci_ldisc.c | 20 +++++++++++++++-----
> >  drivers/bluetooth/hci_uart.h  |  1 +
> >  2 files changed, 16 insertions(+), 5 deletions(-)
> >
> >diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc=
=2Ec
> >index 6e06f6f..ecdd765 100644
> >--- a/drivers/bluetooth/hci_ldisc.c
> >+++ b/drivers/bluetooth/hci_ldisc.c
> >@@ -118,10 +118,6 @@ static inline struct sk_buff *hci_uart_dequeue(stru=
ct hci_uart *hu)
> >
> >  int hci_uart_tx_wakeup(struct hci_uart *hu)
> >  {
> >-	struct tty_struct *tty =3D hu->tty;
> >-	struct hci_dev *hdev =3D hu->hdev;
> >-	struct sk_buff *skb;
> >-
> >  	if (test_and_set_bit(HCI_UART_SENDING, &hu->tx_state)) {
> >  		set_bit(HCI_UART_TX_WAKEUP, &hu->tx_state);
> >  		return 0;
> >@@ -129,6 +125,18 @@ int hci_uart_tx_wakeup(struct hci_uart *hu)
> >
> >  	BT_DBG("");
> >
> >+	schedule_work(&hu->write_work);
> >+
> >+	return 0;
> >+}
> >+
> >+static void hci_uart_write_work(struct work_struct *work)
> >+{
> >+	struct hci_uart *hu =3D container_of(work, struct hci_uart, init_ready=
);
> >+	struct tty_struct *tty =3D hu->tty;
> >+	struct hci_dev *hdev =3D hu->hdev;
> >+	struct sk_buff *skb;
> >+
>=20
> +	/* FIXME: if bad skb length or tty->ops->write() returns < 0 ??? */
>=20
> >  restart:
> >  	clear_bit(HCI_UART_TX_WAKEUP, &hu->tx_state);
> >
> >@@ -153,7 +161,6 @@ restart:
> >  		goto restart;
> >
> >  	clear_bit(HCI_UART_SENDING, &hu->tx_state);
> >-	return 0;
> >  }
> >
> >  static void hci_uart_init_work(struct work_struct *work)
> >@@ -281,6 +288,7 @@ static int hci_uart_tty_open(struct tty_struct *tty)
> >  	tty->receive_room =3D 65536;
> >
> >  	INIT_WORK(&hu->init_ready, hci_uart_init_work);
> >+	INIT_WORK(&hu->write_work, hci_uart_write_work);
> >
> >  	spin_lock_init(&hu->rx_lock);
> >
> >@@ -318,6 +326,8 @@ static void hci_uart_tty_close(struct tty_struct *tt=
y)
> >  	if (hdev)
> >  		hci_uart_close(hdev);
> >
> >+	cancel_work_sync(&hy->write_work);
> >+
> >  	if (test_and_clear_bit(HCI_UART_PROTO_SET, &hu->flags)) {
> >  		if (hdev) {
> >  			if (test_bit(HCI_UART_REGISTERED, &hu->flags))
> >diff --git a/drivers/bluetooth/hci_uart.h b/drivers/bluetooth/hci_uart.h
> >index fffa61f..12df101 100644
> >--- a/drivers/bluetooth/hci_uart.h
> >+++ b/drivers/bluetooth/hci_uart.h
> >@@ -68,6 +68,7 @@ struct hci_uart {
> >  	unsigned long		hdev_flags;
> >
> >  	struct work_struct	init_ready;
> >+	struct work_struct	write_work;
> >
> >  	struct hci_uart_proto	*proto;
> >  	void			*priv;
> >
>=20

--=20
balbi

--IuJpT0rwbUevm2bB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTK0CtAAoJEIaOsuA1yqRESTcQALFnk4AN9xnWTgDUn2oRcM9n
CfJlNRpjcLjbv1YgrYY6wE0Cmib/QWtm5LJbOp12LvlWyq9YfQA11bIrBs4ef0Ox
ESI5IcNNJwvhd/BoiaRm/wb7S2ql6fU+MxQOPh8wM4U20XLK1LOcUduaaNPrCkyu
6DbiaGaRulNt/Utknu91upsdnQ+zhALQw2Lz2fM3ab6Poh16kcMjWUexe9v/jXIc
UwPHPje0QugrKoe8xs2FKAmtEZsKstzggvVfTAsFgRJ2nFWoh/jT6/2Q+wZ+Zkv8
0f/gl11VYjUmEyo6kG6z93wgj/A7MmLETZnkDDekIHKkSgADMjyRsHme17E9TUcv
pGPoW90Yxz9/5RZSTIUKHRDoAg3+FY1f4JFvXoIIeKpP/23M+ebw7EVjFwkj+fxY
ndOKmq6E8AW5MxkplQ3N90ftlFQ8J8QOsnSlfiqmMzQUrQndWsz8ST37XopESa/1
sWtJRrnpr8uJYaoziWNvCy3l3yunhplfZbvjYJ6qWCjGJ6iOdspqTEtyeV/NrYla
Y13kEhl8s8igF/4YT7UAInM+7Oe2MZtaJOTOoYhEOi8q0TYf8LzSMm4DeLuGFj+I
QItJOvFf0usq2tZDducrN6dI/kT1QD0XAE6UxfEpCMNMw3PxRfSIK0SlQSP/hoh9
xx9zlUpDuZi7YVzqnDwt
=gpFl
-----END PGP SIGNATURE-----

--IuJpT0rwbUevm2bB--
