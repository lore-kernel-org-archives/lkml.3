Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab3CKVTO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:19:14 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:33571 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902Ab3CKVPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:15:41 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Sasha Levin <levinsasha928@gmail.com>, Dave Jones <davej@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v5 35/44] tty: Drop "tty is NULL" flip buffer diagnostic
Date: Mon, 11 Mar 2013 16:44:55 -0400
Message-Id: <1363034704-28036-36-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
 <1363034704-28036-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although this warning uncovered a multitude of races and errors
in the tty and ldisc layers, this diagnostic now has too many
false-positives.

An expected outcome of the separation of driver i/o paths from
tty lifetimes (added in 3.9) is that the tty may already be
in advanced stages of teardown when scheduled flip buffer work
runs. Ldisc i/o is prevented in this case because flush_to_ldisc()
cannot acquire an ldisc reference.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 0dd35ce..8e8d730 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -425,7 +425,7 @@ static void flush_to_ldisc(struct work_struct *work)
 	struct tty_ldisc *disc;
 
 	tty = port->itty;
-	if (WARN_RATELIMIT(tty == NULL, "tty is NULL\n"))
+	if (tty == NULL)
 		return;
 
 	disc = tty_ldisc_ref(tty);
-- 
1.8.1.2

