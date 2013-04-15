Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933454Ab3DOPcv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:32:51 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:45899 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933250Ab3DOPcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:32:47 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 12/16] tty: Avoid false-sharing flip buffer ptrs
Date: Mon, 15 Apr 2013 11:26:03 -0400
Message-Id: <1366039567-8620-13-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366039567-8620-1-git-send-email-peter@hurleysoftware.com>
References: <1366039168-8510-1-git-send-email-peter@hurleysoftware.com>
 <1366039567-8620-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate the head and tail ptrs to avoid cache-line contention
(so called 'false-sharing') between concurrent threads.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 include/linux/tty.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/tty.h b/include/linux/tty.h
index 094a909..08633e0 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -65,13 +65,13 @@ static inline char *flag_buf_ptr(struct tty_buffer *b, int ofs)
 
 
 struct tty_bufhead {
+	struct tty_buffer *head;	/* Queue head */
 	struct work_struct work;
 	struct mutex flush_mutex;
 	struct tty_buffer sentinel;
-	struct tty_buffer *head;	/* Queue head */
-	struct tty_buffer *tail;	/* Active buffer */
 	struct llist_head free;		/* Free queue head */
 	atomic_t	   memory_used; /* In-use buffers excluding free list */
+	struct tty_buffer *tail;	/* Active buffer */
 };
 /*
  * When a break, frame error, or parity error happens, these codes are
-- 
1.8.1.2

