Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460Ab3FONVx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 09:21:53 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:43183 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab3FONVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 09:21:50 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v4 18/24] n_tty: Separate buffer indices to prevent cache-line sharing
Date: Sat, 15 Jun 2013 09:14:30 -0400
Message-Id: <1371302076-4688-19-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371302076-4688-1-git-send-email-peter@hurleysoftware.com>
References: <1366039168-8510-1-git-send-email-peter@hurleysoftware.com>
 <1371302076-4688-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the read buffer indices are in the same cache-line, cpus will
contended over the cache-line (so called 'false sharing').

Separate the producer-published fields from the consumer-published
fields; document the locks relevant to each field.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/n_tty.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index a6eea30..d0c8805 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -82,29 +82,38 @@
 #endif
 
 struct n_tty_data {
-	unsigned int column;
+	/* producer-published */
+	size_t read_head;
+	size_t canon_head;
+	DECLARE_BITMAP(process_char_map, 256);
+
+	/* private to n_tty_receive_overrun (single-threaded) */
 	unsigned long overrun_time;
 	int num_overrun;
 
 	/* non-atomic */
 	bool no_room;
 
+	/* must hold exclusive termios_rwsem to reset these */
 	unsigned char lnext:1, erasing:1, raw:1, real_raw:1, icanon:1;
 	unsigned char echo_overrun:1;
 
-	DECLARE_BITMAP(process_char_map, 256);
+	/* shared by producer and consumer */
+	char *read_buf;
 	DECLARE_BITMAP(read_flags, N_TTY_BUF_SIZE);
 
-	char *read_buf;
-	size_t read_head;
-	size_t read_tail;
 	int minimum_to_wake;
 
+	/* consumer-published */
+	size_t read_tail;
+
+	/* protected by echo_lock */
 	unsigned char *echo_buf;
 	unsigned int echo_pos;
 	unsigned int echo_cnt;
 
-	size_t canon_head;
+	/* protected by output lock */
+	unsigned int column;
 	unsigned int canon_column;
 
 	struct mutex atomic_read_lock;
-- 
1.8.1.2

