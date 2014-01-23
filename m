Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326AbaAWPGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 10:06:45 -0500
Received: from mail-we0-f169.google.com ([74.125.82.169]:59240 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363AbaAWPGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 10:06:41 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2] tty: uartps: Initialize ports according to aliases
Date: Thu, 23 Jan 2014 16:06:33 +0100
Message-Id: <225c74aa791dc09c72267f6718323cbcc36fef95.1390489583.git.michal.simek@xilinx.com>
X-Mailer: git-send-email 1.8.2.3
Content-Type: multipart/signed;
    boundary="=_mimegpg-monstr-desktop-9931-1390489594-0001";
    micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME GnuPG-signed message.  If you see this text, it means that
your E-mail or Usenet software does not support MIME signed messages.
The Internet standard for MIME PGP messages, RFC 2015, was published in 1996.
To open this message correctly you will need to install E-mail or Usenet
software that supports modern Internet standards.

--=_mimegpg-monstr-desktop-9931-1390489594-0001

Register port numbers according to order in DT aliases.
If aliases are not defined, order in DT is used.
If aliases are defined, register port id based
on that.
This patch ensures proper ttyPS0/1 assignment.

Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
This patch should by applied on the top of:
http://www.spinics.net/lists/arm-kernel/msg302143.html
http://www.spinics.net/lists/arm-kernel/msg302144.html

Changes in v2:
- Fix my fault by sending incorrect version

 drivers/tty/serial/xilinx_uartps.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/serial/xilinx_uartps.c b/drivers/tty/serial/xilinx_uartps.c
index 528f16a..d8f46e8 100644
--- a/drivers/tty/serial/xilinx_uartps.c
+++ b/drivers/tty/serial/xilinx_uartps.c
@@ -1031,17 +1031,21 @@ static struct uart_port xuartps_port[2];
  * xuartps_get_port - Configure the port from the platform device resource
  *			info
  *
+ * @id: Port id
+ *
  * Return: a pointer to a uart_port or NULL for failure
  */
-static struct uart_port *xuartps_get_port(void)
+static struct uart_port *xuartps_get_port(int id)
 {
 	struct uart_port *port;
-	int id;

-	/* Find the next unused port */
-	for (id = 0; id < XUARTPS_NR_PORTS; id++)
-		if (xuartps_port[id].mapbase == 0)
-			break;
+	/* Try the given port id if failed use default method */
+	if (xuartps_port[id].mapbase != 0) {
+		/* Find the next unused port */
+		for (id = 0; id < XUARTPS_NR_PORTS; id++)
+			if (xuartps_port[id].mapbase == 0)
+				break;
+	}

 	if (id >= XUARTPS_NR_PORTS)
 		return NULL;
@@ -1333,6 +1337,7 @@ static int xuartps_probe(struct platform_device *pdev)
 	struct uart_port *port;
 	struct resource *res, *res2;
 	struct xuartps *xuartps_data;
+	int id;

 	xuartps_data = devm_kzalloc(&pdev->dev, sizeof(*xuartps_data),
 			GFP_KERNEL);
@@ -1380,9 +1385,15 @@ static int xuartps_probe(struct platform_device *pdev)
 				&xuartps_data->clk_rate_change_nb))
 		dev_warn(&pdev->dev, "Unable to register clock notifier.\n");
 #endif
+	/* Look for a serialN alias */
+	id = of_alias_get_id(pdev->dev.of_node, "serial");
+	if (id < 0) {
+		dev_warn(&pdev->dev, "failed to get alias id, errno %d\n", id);
+		id = 0;
+	}

 	/* Initialize the port structure */
-	port = xuartps_get_port();
+	port = xuartps_get_port(id);

 	if (!port) {
 		dev_err(&pdev->dev, "Cannot get uart_port structure\n");
--
1.8.2.3


--=_mimegpg-monstr-desktop-9931-1390489594-0001
Content-Type: application/pgp-signature
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAlLhL/oACgkQykllyylKDCFcVACfcJl5CNQLF7FrJHiaekI4cey+
ZkYAnRmjGC/BScPV86pkL164wFTn6uCl
=QHE/
-----END PGP SIGNATURE-----

--=_mimegpg-monstr-desktop-9931-1390489594-0001--
