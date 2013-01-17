Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758423Ab3AQCye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 21:54:34 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:46436 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756292Ab3AQCyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 21:54:31 -0500
Date: Thu, 17 Jan 2013 13:54:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: linux-next: manual merge of the char-misc tree with the tty tree
Message-Id: <20130117135420.8575233a25bdeb64c4b38d9d@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__17_Jan_2013_13_54_20_+1100_Z0Ko0bH/uuRpWvx2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__17_Jan_2013_13_54_20_+1100_Z0Ko0bH/uuRpWvx2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the char-misc tree got a conflict in
drivers/ipack/devices/ipoctal.c between commit 2e124b4a390c ("TTY: switch
tty_flip_buffer_push") from the tty tree and commits 7e5730d7c222
("ipack/devices/ipoctal: fix kernel bug when using pppd"),
e7e664fd688a ("ipack/devices/ipoctal: protect the channel data processing
with a spinlock") and b06073f963b7 ("ipack/devices/ipoctal: remove
redundant tty_flip_buffer_push()") from the char-misc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/ipack/devices/ipoctal.c
index ab20a08,0b3c4b8..0000000
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@@ -133,11 -123,11 +123,11 @@@ static int ipoctal_get_icount(struct tt
  	return 0;
  }
 =20
 -static void ipoctal_irq_rx(struct ipoctal_channel *channel,
 -			   struct tty_struct *tty, u8 sr)
 +static void ipoctal_irq_rx(struct ipoctal_channel *channel, u8 sr)
  {
 +	struct tty_port *port =3D &channel->tty_port;
  	unsigned char value;
- 	unsigned char flag =3D TTY_NORMAL;
+ 	unsigned char flag;
  	u8 isr;
 =20
  	do {
@@@ -208,11 -188,13 +188,8 @@@ static void ipoctal_irq_tx(struct ipoct
  static void ipoctal_irq_channel(struct ipoctal_channel *channel)
  {
  	u8 isr, sr;
 -	struct tty_struct *tty;
 -
 -	tty =3D tty_port_tty_get(&channel->tty_port);
 -	if (!tty)
 -		return;
 =20
- 	/* If there is no client, skip the check */
- 	if (!atomic_read(&channel->open))
- 		return;
-=20
+ 	spin_lock(&channel->lock);
  	/* The HW is organized in pair of channels.  See which register we need
  	 * to read from */
  	isr =3D ioread8(&channel->block_regs->r.isr);
@@@ -237,7 -218,8 +213,7 @@@
  	if ((isr & channel->isr_tx_rdy_mask) && (sr & SR_TX_READY))
  		ipoctal_irq_tx(channel);
 =20
- 	tty_flip_buffer_push(&channel->tty_port);
 -	tty_kref_put(tty);
+ 	spin_unlock(&channel->lock);
  }
 =20
  static irqreturn_t ipoctal_irq_handler(void *arg)

--Signature=_Thu__17_Jan_2013_13_54_20_+1100_Z0Ko0bH/uuRpWvx2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQ92fcAAoJEECxmPOUX5FEoiwQAJFY1lR0a5Lki7Lg10uQnGSv
zm0q8pWHFlSP7Y3UmYbl7XZuFSCwV6DY+bccLkgQ2aHATDRvIgKozNGC6d37N0Cv
OfU0/S3pzr1Rsw3zJbLzSzeVEG15HaFeig5l6u+YitkpphE2o+FTEqq/9j0kpMuE
1U4LvFKUneGPqlaIBDsvoXCqyi5rZmelSv91FeBeSHkefbzRt6Hfkb4Yh9jf1XtF
Q1hnFBI9ON0r9RvP9va811CHWr08/cc3dsLVp2/8JuBPW3GCUQc/7jasmRb1K2Ik
agmYJfwwgeFnXOBnVn8uX4XSEbtFcIFc3IgsZcGt2CWIntqnk4gfIP4hp8wQxg3G
7Mk966YB0KIZFoDlRDx/xLLHqE1ODhj3xJdR+tsLx/JNEpCw9iPn/V1rlY70gpkB
nPK48q1qmesAb3eA+cyWjj8OsBrFztq0l7Rm2Do7xh4rqBFipHGvyAAQwIjOHuZy
K3MVALe50yjVCltdqVpcH116yh4IHwwpofDd9Q+uAzZIVzQe5nvCu1roILRtA1W3
QcQdGB/9676v7e8O7eNzNQiHbHrcZa0ETDKC6ouSqkIhubZhi5rkf+wPYt+9mq9/
+s7iZB1BIvmvudBvOGhZkSdccoeyvPxAXBf4RrMA5792MNBV6hD+eaDe4zz2+rMm
/KkF80x0sSk93xiNDuDu
=RuU8
-----END PGP SIGNATURE-----

--Signature=_Thu__17_Jan_2013_13_54_20_+1100_Z0Ko0bH/uuRpWvx2--
