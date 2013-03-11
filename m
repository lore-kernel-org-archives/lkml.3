Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab3CKVQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:16:39 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:33617 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193Ab3CKVPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:15:50 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v5 17/44] tty: Bracket ldisc release with TTY_DEBUG_HANGUP messages
Date: Mon, 11 Mar 2013 16:44:37 -0400
Message-Id: <1363034704-28036-18-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
 <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Expected typical log output:
[    2.437211] tty_open: opening pts1...
[    2.443376] tty_open: opening pts5...
[    2.447830] tty_release: ptm0 (tty count=1)...
[    2.447849] pts0 vhangup...
[    2.447865] tty_release: ptm0: final close
[    2.447876] tty_release: ptm0: freeing structure...
[    2.451634] tty_release: tty1 (tty count=1)...
[    2.451638] tty_release: tty1: final close
[    2.451654] tty_release: tty1: freeing structure...
[    2.452505] tty_release: pts5 (tty count=2)...
[    2.453029] tty_open: opening pts0...

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 9e8ff84..2ac516d 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1790,7 +1790,7 @@ int tty_release(struct inode *inode, struct file *filp)
 		return 0;
 
 #ifdef TTY_DEBUG_HANGUP
-	printk(KERN_DEBUG "%s: freeing tty structure...\n", __func__);
+	printk(KERN_DEBUG "%s: %s: final close\n", __func__, tty_name(tty, buf));
 #endif
 	/*
 	 * Ask the line discipline code to release its structures
@@ -1802,6 +1802,9 @@ int tty_release(struct inode *inode, struct file *filp)
 	if (o_tty)
 		tty_flush_works(o_tty);
 
+#ifdef TTY_DEBUG_HANGUP
+	printk(KERN_DEBUG "%s: %s: freeing structure...\n", __func__, tty_name(tty, buf));
+#endif
 	/*
 	 * The release_tty function takes care of the details of clearing
 	 * the slots and preserving the termios structure. The tty_unlock_pair
-- 
1.8.1.2

