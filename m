Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756605Ab3A2Dft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 22:35:49 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:43205 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756501Ab3A2Dfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 22:35:44 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 07/11] staging/fwserial: Don't use deprecated alloc_tty_driver()
Date: Mon, 28 Jan 2013 22:34:41 -0500
Message-Id: <1359430485-5301-7-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359430485-5301-1-git-send-email-peter@hurleysoftware.com>
References: <1359430485-5301-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use tty_alloc_driver() instead.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/staging/fwserial/fwserial.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
index 66463d1..912b17a 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -2882,9 +2882,10 @@ static int __init fwserial_init(void)
 		num_ttys = MAX_CARD_PORTS - num_loops;
 	num_ports = num_ttys + num_loops;
 
-	fwtty_driver = alloc_tty_driver(MAX_TOTAL_PORTS);
-	if (!fwtty_driver) {
-		err = -ENOMEM;
+	fwtty_driver = tty_alloc_driver(MAX_TOTAL_PORTS, TTY_DRIVER_REAL_RAW
+					| TTY_DRIVER_DYNAMIC_DEV);
+	if (IS_ERR(fwtty_driver)) {
+		err = PTR_ERR(fwtty_driver);
 		return err;
 	}
 
@@ -2894,9 +2895,6 @@ static int __init fwserial_init(void)
 	fwtty_driver->minor_start	= 0;
 	fwtty_driver->type		= TTY_DRIVER_TYPE_SERIAL;
 	fwtty_driver->subtype		= SERIAL_TYPE_NORMAL;
-	fwtty_driver->flags		= TTY_DRIVER_REAL_RAW |
-						TTY_DRIVER_DYNAMIC_DEV;
-
 	fwtty_driver->init_termios	    = tty_std_termios;
 	fwtty_driver->init_termios.c_cflag  |= CLOCAL;
 	tty_set_operations(fwtty_driver, &fwtty_ops);
@@ -2908,9 +2906,11 @@ static int __init fwserial_init(void)
 	}
 
 	if (create_loop_dev) {
-		fwloop_driver = alloc_tty_driver(MAX_TOTAL_PORTS / num_ports);
-		if (!fwloop_driver) {
-			err = -ENOMEM;
+		fwloop_driver = tty_alloc_driver(MAX_TOTAL_PORTS / num_ports,
+						 TTY_DRIVER_REAL_RAW
+						 | TTY_DRIVER_DYNAMIC_DEV);
+		if (IS_ERR(fwloop_driver)) {
+			err = PTR_ERR(fwloop_driver);
 			goto unregister_driver;
 		}
 
@@ -2920,9 +2920,6 @@ static int __init fwserial_init(void)
 		fwloop_driver->minor_start	= 0;
 		fwloop_driver->type		= TTY_DRIVER_TYPE_SERIAL;
 		fwloop_driver->subtype		= SERIAL_TYPE_NORMAL;
-		fwloop_driver->flags		= TTY_DRIVER_REAL_RAW |
-							TTY_DRIVER_DYNAMIC_DEV;
-
 		fwloop_driver->init_termios	    = tty_std_termios;
 		fwloop_driver->init_termios.c_cflag  |= CLOCAL;
 		tty_set_operations(fwloop_driver, &fwloop_ops);
-- 
1.8.1.1

