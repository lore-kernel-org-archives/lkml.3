Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab3CKVS3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:18:29 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:33601 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868Ab3CKVPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:15:46 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v5 13/44] tty: Don't reenable already enabled ldisc
Date: Mon, 11 Mar 2013 16:44:33 -0400
Message-Id: <1363034704-28036-14-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
 <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty_ldisc_hangup() guarantees the ldisc is enabled (or that there
is no ldisc). Since __tty_hangup() was the only user, re-define
tty_ldisc_enable() in file-scope.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_io.c    | 1 -
 drivers/tty/tty_ldisc.c | 2 +-
 include/linux/tty.h     | 2 --
 3 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index fd47363..1ee318a 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -666,7 +666,6 @@ static void __tty_hangup(struct tty_struct *tty)
 	 */
 	set_bit(TTY_HUPPED, &tty->flags);
 	clear_bit(TTY_HUPPING, &tty->flags);
-	tty_ldisc_enable(tty);
 
 	tty_unlock(tty);
 
diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 37671fcc..9c727da 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -373,7 +373,7 @@ static inline void tty_ldisc_put(struct tty_ldisc *ld)
  *	Clearing directly is allowed.
  */
 
-void tty_ldisc_enable(struct tty_struct *tty)
+static void tty_ldisc_enable(struct tty_struct *tty)
 {
 	clear_bit(TTY_LDISC_HALTED, &tty->flags);
 	set_bit(TTY_LDISC, &tty->flags);
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 7aa4be6..bfa6fca 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -527,8 +527,6 @@ extern void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty);
 extern void tty_ldisc_init(struct tty_struct *tty);
 extern void tty_ldisc_deinit(struct tty_struct *tty);
 extern void tty_ldisc_begin(void);
-/* This last one is just for the tty layer internals and shouldn't be used elsewhere */
-extern void tty_ldisc_enable(struct tty_struct *tty);
 
 
 /* n_tty.c */
-- 
1.8.1.2

