Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbaL3Pjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 10:39:42 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:64480 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbaL3Pjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 10:39:40 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Shreyas Bethur <shreyas.bethur@ni.com>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2] tty: Prevent hw state corruption in exclusive mode reopen
Date: Tue, 30 Dec 2014 10:39:25 -0500
Message-Id: <1419953965-16494-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1419942873-6779-1-git-send-email-peter@hurleysoftware.com>
References: <1419942873-6779-1-git-send-email-peter@hurleysoftware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exclusive mode ttys (TTY_EXCLUSIVE) do not allow further reopens;
fail the condition before associating the file pointer and calling
the driver open() method.

Prevents DTR programming when the tty is already in exclusive mode.

Reported-by: Shreyas Bethur <shreyas.bethur@ni.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 4f35b43..51f066a 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1464,6 +1464,9 @@ static int tty_reopen(struct tty_struct *tty)
 	    driver->subtype == PTY_TYPE_MASTER)
 		return -EIO;
 
+	if (test_bit(TTY_EXCLUSIVE, &tty->flags) && !capable(CAP_SYS_ADMIN))
+		return -EBUSY;
+
 	tty->count++;
 
 	WARN_ON(!tty->ldisc);
@@ -2106,10 +2109,6 @@ retry_open:
 		retval = -ENODEV;
 	filp->f_flags = saved_flags;
 
-	if (!retval && test_bit(TTY_EXCLUSIVE, &tty->flags) &&
-						!capable(CAP_SYS_ADMIN))
-		retval = -EBUSY;
-
 	if (retval) {
 #ifdef TTY_DEBUG_HANGUP
 		printk(KERN_DEBUG "%s: error %d in opening %s...\n", __func__,
-- 
2.2.1

