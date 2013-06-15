Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab3FOOFo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 10:05:44 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:40223 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473Ab3FOOFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 10:05:12 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 9/9] n_tty: Avoid false-sharing echo buffer indices
Date: Sat, 15 Jun 2013 10:04:29 -0400
Message-Id: <1371305069-5366-10-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371305069-5366-1-git-send-email-peter@hurleysoftware.com>
References: <1371303376-5028-1-git-send-email-peter@hurleysoftware.com>
 <1371305069-5366-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate the head & commit indices from the tail index to avoid
cache-line contention (so called 'false-sharing') between concurrent
threads.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index e689026..b9ccb49 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -90,6 +90,8 @@ struct n_tty_data {
 	/* producer-published */
 	size_t read_head;
 	size_t canon_head;
+	size_t echo_head;
+	size_t echo_commit;
 	DECLARE_BITMAP(process_char_map, 256);
 
 	/* private to n_tty_receive_overrun (single-threaded) */
@@ -105,20 +107,17 @@ struct n_tty_data {
 	/* shared by producer and consumer */
 	char *read_buf;
 	DECLARE_BITMAP(read_flags, N_TTY_BUF_SIZE);
+	unsigned char *echo_buf;
 
 	int minimum_to_wake;
 
 	/* consumer-published */
 	size_t read_tail;
 
-	unsigned char *echo_buf;
-	size_t echo_head;
-	size_t echo_tail;
-	size_t echo_commit;
-
 	/* protected by output lock */
 	unsigned int column;
 	unsigned int canon_column;
+	size_t echo_tail;
 
 	struct mutex atomic_read_lock;
 	struct mutex output_lock;
-- 
1.8.1.2

