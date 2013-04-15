Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab3DOPac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:30:32 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:45634 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab3DOPa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:30:29 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 9/9] n_tty: Avoid false-sharing echo buffer indices
Date: Mon, 15 Apr 2013 11:29:47 -0400
Message-Id: <1366039787-8719-10-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366039787-8719-1-git-send-email-peter@hurleysoftware.com>
References: <1366039567-8620-1-git-send-email-peter@hurleysoftware.com>
 <1366039787-8719-1-git-send-email-peter@hurleysoftware.com>
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
index eb20777..aa63cd3 100644
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

