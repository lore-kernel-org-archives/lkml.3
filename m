Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758133Ab3CFMVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 07:21:40 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:43054 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab3CFMVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 07:21:38 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Sasha Levin <levinsasha928@gmail.com>, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 2/5] tty: Fix spinlock flavor in non-atomic __tty_hangup()
Date: Wed,  6 Mar 2013 07:20:54 -0500
Message-Id: <1362572457-29993-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362572457-29993-1-git-send-email-peter@hurleysoftware.com>
References: <1362572457-29993-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__tty_hangup() and tty_vhangup() cannot be called from atomic context,
so locks do not need to preserve the interrupt state (although,
still disable interrupts).

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index e454f1a..f9d4acf 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -605,7 +605,6 @@ static void __tty_hangup(struct tty_struct *tty)
 	struct file *filp, *f = NULL;
 	struct tty_file_private *priv;
 	int    closecount = 0, n;
-	unsigned long flags;
 	int refs;
 
 	if (!tty)
@@ -654,7 +653,7 @@ static void __tty_hangup(struct tty_struct *tty)
 	while (refs--)
 		tty_kref_put(tty);
 
-	spin_lock_irqsave(&tty->ctrl_lock, flags);
+	spin_lock_irq(&tty->ctrl_lock);
 	clear_bit(TTY_THROTTLED, &tty->flags);
 	clear_bit(TTY_PUSH, &tty->flags);
 	clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
@@ -663,7 +662,7 @@ static void __tty_hangup(struct tty_struct *tty)
 	tty->session = NULL;
 	tty->pgrp = NULL;
 	tty->ctrl_status = 0;
-	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+	spin_unlock_irq(&tty->ctrl_lock);
 
 	/*
 	 * If one of the devices matches a console pointer, we
-- 
1.8.1.2

