Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbaJPTeA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 15:34:00 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:43295 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752659AbaJPTdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 15:33:55 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 7/9] pty: Hold ctrl_lock for packet mode updates
Date: Thu, 16 Oct 2014 15:33:28 -0400
Message-Id: <1413488010-16885-8-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413488010-16885-1-git-send-email-peter@hurleysoftware.com>
References: <1413488010-16885-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updates to the packet mode enable require holding the ctrl_lock;
the serialization prevents corruption of adjacent fields.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/pty.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index bcec4c7..7a1a538 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -47,7 +47,9 @@ static void pty_close(struct tty_struct *tty, struct file *filp)
 	set_bit(TTY_IO_ERROR, &tty->flags);
 	wake_up_interruptible(&tty->read_wait);
 	wake_up_interruptible(&tty->write_wait);
+	spin_lock_irq(&tty->ctrl_lock);
 	tty->packet = 0;
+	spin_unlock_irq(&tty->ctrl_lock);
 	/* Review - krefs on tty_link ?? */
 	if (!tty->link)
 		return;
-- 
2.1.1

