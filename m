Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab3KGTWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 14:22:31 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:43898 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab3KGTWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 14:22:24 -0500
X-Greylist: delayed 1313 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Nov 2013 14:22:24 EST
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mikael Pettersson <mikpelinux@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>,
        stable@kernel.org
Subject: [PATCH] n_tty: Ensure reader restarts worker for next reader
Date: Thu,  7 Nov 2013 13:59:46 -0500
Message-Id: <1383850796-24300-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <20131017211236.GA6155@kroah.com>
References: <20131017211236.GA6155@kroah.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A departing reader must restart a flush_to_ldisc() worker _before_
the next reader enters the read loop; this is to avoid the new reader
concluding no more i/o is available and prematurely exiting, when the
old reader simply hasn't re-started the worker yet.

Cc: stable@kernel.org # 3.12
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 7a744b6..ce11cd5 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -2250,6 +2250,9 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 		if (time)
 			timeout = time;
 	}
+	n_tty_set_room(tty);
+	up_read(&tty->termios_rwsem);
+
 	mutex_unlock(&ldata->atomic_read_lock);
 	remove_wait_queue(&tty->read_wait, &wait);
 
@@ -2260,8 +2263,6 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 	if (b - buf)
 		retval = b - buf;
 
-	n_tty_set_room(tty);
-	up_read(&tty->termios_rwsem);
 	return retval;
 }
 
-- 
1.8.1.2

