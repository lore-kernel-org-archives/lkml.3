Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168Ab3LIDU1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 22:20:27 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:16556 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932109Ab3LIDUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 22:20:25 -0500
From: "Li, Zhen-Hua" <zhen-hual@hp.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, <linux-kernel@vger.kernel.org>
Cc: "Li, Zhen-Hua" <zhen-hual@hp.com>
Subject: [PATCH 1/1] drivers/tty: Fix missed unlocks for tty_release
Date: Mon,  9 Dec 2013 11:20:28 +0800
Message-Id: <1386559228-26880-1-git-send-email-zhen-hual@hp.com>
X-Mailer: git-send-email 1.8.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In function tty_release, there are two unlock not called while
breaking from a while. This may cause problems.
This patch fixed this problem , adding the two unlocks before
break is called.

Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
---
 drivers/tty/tty_io.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index c74a00a..d41b0da 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1777,9 +1777,11 @@ int tty_release(struct inode *inode, struct file *filp)
 				do_sleep++;
 			}
 		}
-		if (!do_sleep)
+		if (!do_sleep) {
+			tty_unlock_pair(tty, o_tty);
+			mutex_unlock(&tty_mutex);
 			break;
-
+		}
 		printk(KERN_WARNING "%s: %s: read/write wait queue active!\n",
 				__func__, tty_name(tty, buf));
 		tty_unlock_pair(tty, o_tty);
-- 
1.8.4.3

