Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964913Ab3BTUQA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 15:16:00 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:54850 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935983Ab3BTUPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 15:15:54 -0500
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
Subject: [PATCH v4 32/32] tty: Drop "tty is NULL" flip buffer diagnostic
Date: Wed, 20 Feb 2013 15:03:19 -0500
Message-Id: <1361390599-15195-33-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
References: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
In-Reply-To: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
References: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
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

