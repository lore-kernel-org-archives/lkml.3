Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab3GIIlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 04:41:09 -0400
Received: from smtp205.alice.it ([82.57.200.101]:40378 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701Ab3GIIlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 04:41:06 -0400
X-Greylist: delayed 322 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Jul 2013 04:41:05 EDT
Date: Tue, 9 Jul 2013 10:35:35 +0200
From: Gianluca Anzolin <gianluca@sottospazio.it>
To: jslaby@suse.cz
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix refcount leak in tty_port.c
Message-ID: <20130709083535.GA30227@debian.seek.priv>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

In linux 3.10 in the file drivers/tty/tty_port.c the function
tty_port_tty_hangup may leak a tty reference:

        struct tty_struct *tty = tty_port_tty_get(port);

        if (tty && (!check_clocal || !C_CLOCAL(tty))) {
                tty_hangup(tty);
                tty_kref_put(tty);
        }

If tty != NULL and the second condition is false we never call tty_kref_put and
the reference is leaked.

Fix by nesting two if statements.

Signed-off-by: Gianluca Anzolin <gianluca@sottospazio.it>

--wRRV7LY7NUeQGEoC
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="tty_port.patch"

diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index 121aeb9..2198f7d 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -256,8 +256,9 @@ void tty_port_tty_hangup(struct tty_port *port, bool check_clocal)
 {
 	struct tty_struct *tty = tty_port_tty_get(port);
 
-	if (tty && (!check_clocal || !C_CLOCAL(tty))) {
-		tty_hangup(tty);
+	if (tty) {
+		if (!check_clocal || !C_CLOCAL(tty))
+			tty_hangup(tty);
 		tty_kref_put(tty);
 	}
 }

--wRRV7LY7NUeQGEoC--
