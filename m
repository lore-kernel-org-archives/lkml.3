Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab3LBT0F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:26:05 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:44397 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454Ab3LBTZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:25:54 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 tty-next 8/8] n_tty: Trace echo output with separate trace configuration
Date: Mon,  2 Dec 2013 14:24:48 -0500
Message-Id: <1386012288-5079-9-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1386012288-5079-1-git-send-email-peter@hurleysoftware.com>
References: <1385135965-4235-1-git-send-email-peter@hurleysoftware.com>
 <1386012288-5079-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add trace support for echo output but leave it separately selectable/
buildable from the base trace support.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 26ae9d7..bd01d97 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -94,6 +94,13 @@
 # define n_tty_trace(tty, f, args...)	do { } while (0)
 #endif
 
+#undef N_TTY_TRACE_ECHOES
+#ifdef N_TTY_TRACE_ECHOES
+# define n_tty_trace_echoes(tty, f, args...)	_n_tty_trace(tty, f, args)
+#else
+# define n_tty_trace_echoes(tty, f, args...)	do { } while (0)
+#endif
+
 struct n_tty_data {
 	/* producer-published */
 	size_t read_head;
@@ -791,13 +798,18 @@ static size_t __process_echoes(struct tty_struct *tty)
 		}
 	}
 
+	n_tty_trace_echoes(tty, "echoes:%zu,%zu commit:%zu head:%zu\n",
+			   ldata->echo_tail, tail, ldata->echo_commit,
+			   ldata->echo_head);
+
 	/* If the echo buffer is nearly full (so that the possibility exists
 	 * of echo overrun before the next commit), then discard enough
 	 * data at the tail to prevent a subsequent overrun */
 	while (ldata->echo_commit - tail >= ECHO_DISCARD_WATERMARK) {
 
-		n_tty_trace(tty, "discard echoes (%zu - %zu > %d)\n",
-			    ldata->echo_commit, tail, ECHO_DISCARD_WATERMARK);
+		n_tty_trace_echoes(tty, "discard echoes (%zu - %zu > %d)\n",
+				   ldata->echo_commit, tail,
+				   ECHO_DISCARD_WATERMARK);
 
 		if (echo_buf(ldata, tail) == ECHO_OP_START) {
 			if (echo_buf(ldata, tail + 1) == ECHO_OP_ERASE_TAB)
-- 
1.8.1.2

