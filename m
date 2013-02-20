Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964821Ab3BTUPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:15:33 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:54724 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935858Ab3BTUPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:15:25 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Shawn Guo <shawn.guo@linaro.org>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v4 17/32] tty: Bracket ldisc release with TTY_DEBUG_HANGUP messages
Date: Wed, 20 Feb 2013 15:03:04 -0500
Message-Id: <1361390599-15195-18-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
References: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
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
index f1303da..cfcd849 100644
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

