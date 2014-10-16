Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbaJPU1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:27:41 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:36343 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752844AbaJPUZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:25:50 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 06/27] pty: Always return -EIO if slave BSD pty opened first
Date: Thu, 16 Oct 2014 16:25:04 -0400
Message-Id: <1413491125-20134-7-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
References: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Opening the slave BSD pty first already returns -EIO from the slave
pty_open(), which in turn causes the newly installed tty pair to be
released before returning from tty_open(). However, this can also
cause a parallel master BSD pty open to fail because the pty pair
destruction may already been taking place in tty_release().

Failing at driver->install() if the slave pty is opened first ensures
that a pty master open cannot fail, because the driver tables will
not have been updated so tty_driver_lookup_tty() won't find the
master pty (and attempt to "re-open" it).

In turn, this guarantees that any tty with a tty->count == 0 is
in final close (rather than never opened).

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/pty.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 7a1a538..bdb8fd1 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -383,6 +383,10 @@ static int pty_common_install(struct tty_driver *driver, struct tty_struct *tty,
 	int idx = tty->index;
 	int retval = -ENOMEM;
 
+	/* Opening the slave first has always returned -EIO */
+	if (driver->subtype != PTY_TYPE_MASTER)
+		return -EIO;
+
 	ports[0] = kmalloc(sizeof **ports, GFP_KERNEL);
 	ports[1] = kmalloc(sizeof **ports, GFP_KERNEL);
 	if (!ports[0] || !ports[1])
@@ -419,8 +423,6 @@ static int pty_common_install(struct tty_driver *driver, struct tty_struct *tty,
 	 * Everything allocated ... set up the o_tty structure.
 	 */
 	tty_driver_kref_get(driver->other);
-	if (driver->subtype == PTY_TYPE_MASTER)
-		o_tty->count++;
 	/* Establish the links in both directions */
 	tty->link   = o_tty;
 	o_tty->link = tty;
@@ -432,6 +434,7 @@ static int pty_common_install(struct tty_driver *driver, struct tty_struct *tty,
 
 	tty_driver_kref_get(driver);
 	tty->count++;
+	o_tty->count++;
 	return 0;
 err_free_termios:
 	if (legacy)
-- 
2.1.1

