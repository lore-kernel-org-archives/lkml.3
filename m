Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329AbaEFEqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 00:46:36 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:65326 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbaEFEqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 00:46:34 -0400
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org
Cc: Michal Simek <monstr@monstr.eu>, Michal Simek <michal.simek@xilinx.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, arnd@arndb.de,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH v2] tty: serial: uartlite: Specify time for sending chars
Date: Tue,  6 May 2014 06:46:15 +0200
Message-Id: <f5c4b014d747ea39928d940a579cb4e44d6bbd9a.1399351570.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-7379-1399351575-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-7379-1399351575-0001

Xilinx MDM (Microblaze Debug Module) also contains
uart interface via JTAG which is compatible with
uartlite driver. This interface is really slow
that's why timeout is setup to 1s.

Make this time delay not to be cpu speed dependent.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Acked-by: Peter Korsgaard <peter@korsgaard.com>
---

Changes in v2:
- Add Peter's ACK
- Extend commentary

RFC sent here:
https://lkml.org/lkml/2013/9/30/250
I finally got HW design which is just slow to be able
to test it.

---
 drivers/tty/serial/uartlite.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/uartlite.c b/drivers/tty/serial/uartlite.c
index 5f90ef24d475..dce27f34937e 100644
--- a/drivers/tty/serial/uartlite.c
+++ b/drivers/tty/serial/uartlite.c
@@ -418,14 +418,23 @@ static struct uart_ops ulite_ops = {
 #ifdef CONFIG_SERIAL_UARTLITE_CONSOLE
 static void ulite_console_wait_tx(struct uart_port *port)
 {
-	int i;
 	u8 val;
-
-	/* Spin waiting for TX fifo to have space available */
-	for (i = 0; i < 100000; i++) {
+	unsigned long timeout;
+
+	/*
+	 * Spin waiting for TX fifo to have space available.
+	 * When using the Microblaze Debug Module this can take up to 1s
+	 */
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


--=_mimegpg-monstr-desktop-7379-1399351575-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlNoaRcACgkQykllyylKDCENEwCfcsU0iMxo8iGmkrcOdnJa/4UO
iFQAniTB5hXs/tjFLOmm+cyoQB1zbvd/
=CMoJ
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-7379-1399351575-0001--
