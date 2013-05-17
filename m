Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab3EQHMk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 03:12:40 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:58085 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab3EQHMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 03:12:39 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Holler <holler@ahsoftware.de>,
        Peter Hurley <peter@hurleysoftware.com>, Jiri Slaby <jslaby@suse.cz>,
        <stable@vger.kernel.org>
Subject: [PATCH] tty: make sure a BUG is hit if tty_port will be destroyed before tty
Date: Fri, 17 May 2013 09:12:08 +0200
Message-Id: <1368774728-4817-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <5195B561.3090503@ahsoftware.de>
References: <5195B561.3090503@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty depends on tty_port until tty_release() was called. Make sure a BUG
will be hit, if tty_port will be destroyed before tty.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
Cc: Peter Hurley <peter@hurleysoftware.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: <stable@vger.kernel.org>
---

 Currently things are changing fast in the tty subsystem, therefor I don't
 know if the patch should be applied to kernel 3.10 too because the
 reference to tty_port in tty_ldisc_halt() is gone in 3.10-rc1.

 So it might be a patch only for the stable kernels since commit
 ecbbfd4 (kernels 3.8 and 3.9).

 drivers/tty/tty_port.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index 121aeb9..a40c52b 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -140,6 +140,8 @@ EXPORT_SYMBOL(tty_port_destroy);
 static void tty_port_destructor(struct kref *kref)
 {
 	struct tty_port *port = container_of(kref, struct tty_port, kref);
+	/* tty_port has to live until tty_release() was called. */
+	BUG_ON(port->itty);
 	if (port->xmit_buf)
 		free_page((unsigned long)port->xmit_buf);
 	tty_port_destroy(port);
-- 
1.8.1.4

