Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933088AbaEEOsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 10:48:46 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:61194 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932448AbaEEOsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 10:48:43 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, arnd@arndb.de,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH] tty: serial: uartlite: Specify time for sending chars
Date: Mon,  5 May 2014 16:48:26 +0200
Message-Id: <4c1854686987185d547d1d548f89248cb27ba40c.1399301297.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-4835-1399301306-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-4835-1399301306-0001

Xilinx MDM (Microblaze Debug Module) also contains
uart interface via JTAG which is compatible with
uartlite driver. This interface is really slow
that's why timeout is setup to 1s.

Make this time delay not to be cpu speed dependent.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---

RFC sent here:
https://lkml.org/lkml/2013/9/30/250
I finally got HW design which is just slow to be able
to test it.

---
 drivers/tty/serial/uartlite.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/uartlite.c b/drivers/tty/serial/uartlite.c
index 5f90ef24d475..723a6b79cd14 100644
--- a/drivers/tty/serial/uartlite.c
+++ b/drivers/tty/serial/uartlite.c
@@ -418,14 +418,20 @@ static struct uart_ops ulite_ops = {
 #ifdef CONFIG_SERIAL_UARTLITE_CONSOLE
 static void ulite_console_wait_tx(struct uart_port *port)
 {
-	int i;
 	u8 val;
+	unsigned long timeout;

 	/* Spin waiting for TX fifo to have space available */
-	for (i = 0; i < 100000; i++) {
+	timeout = jiffies + msecs_to_jiffies(1000);
+	while (1) {
 		val = uart_in32(ULITE_STATUS, port);
 		if ((val & ULITE_STATUS_TXFULL) == 0)
 			break;
+		if (time_after(jiffies, timeout)) {
+			dev_warn(port->dev,
+				 "timeout waiting for TX buffer empty\n");
+			break;
+		}
 		cpu_relax();
 	}
 }
--
1.8.2.3


--=_mimegpg-monstr-desktop-4835-1399301306-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlNnpLoACgkQykllyylKDCH/5ACeILvWyFYbL5v0PW4/HC+WilTH
So8An2C8Jlcq8hnO444Sy+PnngcabCjz
=L/+W
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-4835-1399301306-0001--
