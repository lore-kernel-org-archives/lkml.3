Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756587Ab3A3Rql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 12:46:41 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:37335 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756327Ab3A3RqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 12:46:25 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Ilya Zykov <ilya@ilyx.ru>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 4/4] pty: Ignore slave open count for master pty open
Date: Wed, 30 Jan 2013 12:43:52 -0500
Message-Id: <1359567832-25318-5-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359567832-25318-1-git-send-email-peter@hurleysoftware.com>
References: <1359567832-25318-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Multiple slave pty opens may be performed in parallel with the
master open. Of course, all the slave opens will fail because the
master pty is still locked but during this time the slave pty
count will be artificially greater than 1. This is should not
cause the master pty open to fail.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/pty.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 6eb3e80..7a18600 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -256,7 +256,7 @@ static int pty_open(struct tty_struct *tty, struct file *filp)
 		goto out;
 	if (test_bit(TTY_PTY_LOCK, &tty->link->flags))
 		goto out;
-	if (tty->link->count != 1)
+	if (tty->driver->subtype == PTY_TYPE_SLAVE && tty->link->count != 1)
 		goto out;
 
 	clear_bit(TTY_IO_ERROR, &tty->flags);
-- 
1.8.1.1

