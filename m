Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab3FONBU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 09:01:20 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:42012 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009Ab3FONBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 09:01:19 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH] tty: Reset itty for other pty
Date: Sat, 15 Jun 2013 09:01:00 -0400
Message-Id: <1371301260-4535-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360098530-7018-1-git-send-email-peter@hurleysoftware.com>
References: <1360098530-7018-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 19ffd68f816878aed456d5e87697f43bd9e3bd2b
('pty: Remove redundant itty reset') introduced a regression
whereby the other pty's linkage is not cleared on teardown.
This triggers a false positive diagnostic in testing.

Properly reset the itty linkage.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index b83c5c5..2174698 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1616,6 +1616,8 @@ static void release_tty(struct tty_struct *tty, int idx)
 	tty_free_termios(tty);
 	tty_driver_remove_tty(tty->driver, tty);
 	tty->port->itty = NULL;
+	if (tty->link)
+		tty->link->port->itty = NULL;
 	cancel_work_sync(&tty->port->buf.work);
 
 	if (tty->link)
-- 
1.8.1.2

