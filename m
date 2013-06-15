Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab3FON55 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 09:57:57 -0400
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:40058 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370Ab3FON5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 09:57:54 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 16/16] tty: Remove private constant from global namespace
Date: Sat, 15 Jun 2013 09:36:16 -0400
Message-Id: <1371303376-5028-17-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371303376-5028-1-git-send-email-peter@hurleysoftware.com>
References: <1371302076-4688-1-git-send-email-peter@hurleysoftware.com>
 <1371303376-5028-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TTY_BUFFER_PAGE is only used within drivers/tty/tty_buffer.c;
relocate to that file scope.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/tty_buffer.c | 10 ++++++++++
 include/linux/tty.h      | 11 -----------
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index f22e116..c043136f 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -28,6 +28,16 @@
  */
 #define TTYB_MEM_LIMIT	65536
 
+/*
+ * We default to dicing tty buffer allocations to this many characters
+ * in order to avoid multiple page allocations. We know the size of
+ * tty_buffer itself but it must also be taken into account that the
+ * the buffer is 256 byte aligned. See tty_buffer_find for the allocation
+ * logic this must match
+ */
+
+#define TTY_BUFFER_PAGE	(((PAGE_SIZE - sizeof(struct tty_buffer)) / 2) & ~0xFF)
+
 
 /**
  *	tty_buffer_lock_exclusive	-	gain exclusive access to buffer
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 7a9a3b0..5fd5d6f 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -53,17 +53,6 @@ static inline char *flag_buf_ptr(struct tty_buffer *b, int ofs)
 	return (char *)char_buf_ptr(b, ofs) + b->size;
 }
 
-/*
- * We default to dicing tty buffer allocations to this many characters
- * in order to avoid multiple page allocations. We know the size of
- * tty_buffer itself but it must also be taken into account that the
- * the buffer is 256 byte aligned. See tty_buffer_find for the allocation
- * logic this must match
- */
-
-#define TTY_BUFFER_PAGE	(((PAGE_SIZE - sizeof(struct tty_buffer)) / 2) & ~0xFF)
-
-
 struct tty_bufhead {
 	struct tty_buffer *head;	/* Queue head */
 	struct work_struct work;
-- 
1.8.1.2

