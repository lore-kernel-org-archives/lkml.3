Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbaKESNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 13:13:45 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:60991 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751338AbaKESMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 13:12:00 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 1/5] tty: Allow safe access to termios for set_ldisc() handlers
Date: Wed,  5 Nov 2014 13:11:41 -0500
Message-Id: <1415211105-16668-2-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415211105-16668-1-git-send-email-peter@hurleysoftware.com>
References: <1415211105-16668-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow a tty driver to safely access termios settings while handling
the set_ldisc() notification. UART drivers use the set_ldisc()
notification to check if the N_PPS line discipline is being enabled;
if so, modem status interrupts may also need to be enabled. Conversely,
modem status interrupts may need to be disabled if switching away
from the N_PPS line discipline.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_ldisc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index b66a81d..3737f55 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -572,8 +572,11 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 		tty_ldisc_restore(tty, old_ldisc);
 	}
 
-	if (tty->ldisc->ops->num != old_ldisc->ops->num && tty->ops->set_ldisc)
+	if (tty->ldisc->ops->num != old_ldisc->ops->num && tty->ops->set_ldisc) {
+		down_read(&tty->termios_rwsem);
 		tty->ops->set_ldisc(tty);
+		up_read(&tty->termios_rwsem);
+	}
 
 	/* At this point we hold a reference to the new ldisc and a
 	   reference to the old ldisc, or we hold two references to
-- 
2.1.3

