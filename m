Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222AbaJPU15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:27:57 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:42453 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752830AbaJPUZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:25:49 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        linux-serial@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 05/27] tty: Check tty->count instead of TTY_CLOSING in tty_reopen()
Date: Thu, 16 Oct 2014 16:25:03 -0400
Message-Id: <1413491125-20134-6-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
References: <1413491125-20134-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although perhaps not obvious, the TTY_CLOSING bit is set when the
tty count has been decremented to 0 (which occurs while holding
tty_lock). The only other case when tty count is 0 during a re-open
is when a legacy BSD pty master has been opened in parallel but
after the pty slave, which is unsupported and returns an error.

Thus !tty->count contains the complete set of degenerate conditions
under which a tty open fails.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 5b6253f..52bcdd3 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1452,7 +1452,7 @@ static int tty_reopen(struct tty_struct *tty)
 {
 	struct tty_driver *driver = tty->driver;
 
-	if (test_bit(TTY_CLOSING, &tty->flags))
+	if (!tty->count)
 		return -EIO;
 
 	if (driver->type == TTY_DRIVER_TYPE_PTY &&
-- 
2.1.1

