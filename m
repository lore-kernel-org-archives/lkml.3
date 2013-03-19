Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538Ab3CSUFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 16:05:08 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:33334 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757207Ab3CSUFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 16:05:07 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>, David Howells <dhowells@redhat.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Sasha Levin <levinsasha928@gmail.com>,
        Dave Jones <davej@redhat.com>, Michel Lespinasse <walken@google.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 5/7] tty: Fix hangup race with TIOCSETD ioctl
Date: Tue, 19 Mar 2013 15:26:07 -0400
Message-Id: <1363721169-22445-6-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363721169-22445-1-git-send-email-peter@hurleysoftware.com>
References: <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
 <1363721169-22445-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hangup may already have happened; check for that state also.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ldisc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 9ace119..84ba790 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -543,10 +543,8 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 	old_ldisc = tty->ldisc;
 	tty_lock(tty);
 
-	/* FIXME: for testing only */
-	WARN_ON(test_bit(TTY_HUPPED, &tty->flags));
-
-	if (test_bit(TTY_HUPPING, &tty->flags)) {
+	if (test_bit(TTY_HUPPING, &tty->flags) ||
+	    test_bit(TTY_HUPPED, &tty->flags)) {
 		/* We were raced by the hangup method. It will have stomped
 		   the ldisc data and closed the ldisc down */
 		tty_ldisc_enable_pair(tty, o_tty);
-- 
1.8.1.2

