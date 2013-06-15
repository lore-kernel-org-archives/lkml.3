Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab3FON6i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 09:58:38 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:40064 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab3FON54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 09:57:56 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 12/16] tty: Avoid false-sharing flip buffer ptrs
Date: Sat, 15 Jun 2013 09:36:12 -0400
Message-Id: <1371303376-5028-13-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371303376-5028-1-git-send-email-peter@hurleysoftware.com>
References: <1371302076-4688-1-git-send-email-peter@hurleysoftware.com>
 <1371303376-5028-1-git-send-email-peter@hurleysoftware.com>
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
index 1d5bacc..b8e8adf 100644
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

