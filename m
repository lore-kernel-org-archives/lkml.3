Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab3KGTWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 14:22:41 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:43900 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab3KGTWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 14:22:24 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH] n_tty: Protect minimum_to_wake reset for concurrent readers
Date: Thu,  7 Nov 2013 14:01:57 -0500
Message-Id: <1383850917-24416-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With multiple, concurrent readers (each waiting to acquire the
atomic_read_lock mutex), a departing reader may mistakenly reset
minimum_to_wake after a new reader has already set a new value.

Protect the minimum_to_wake reset with the atomic_read_lock critical
section.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index ce11cd5..bf9650d 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -2253,12 +2253,12 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 	n_tty_set_room(tty);
 	up_read(&tty->termios_rwsem);
 
-	mutex_unlock(&ldata->atomic_read_lock);
 	remove_wait_queue(&tty->read_wait, &wait);
-
 	if (!waitqueue_active(&tty->read_wait))
 		ldata->minimum_to_wake = minimum;
 
+	mutex_unlock(&ldata->atomic_read_lock);
+
 	__set_current_state(TASK_RUNNING);
 	if (b - buf)
 		retval = b - buf;
-- 
1.8.1.2

