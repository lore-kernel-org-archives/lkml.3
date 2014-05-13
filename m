Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761158AbaEMK3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:29:18 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33415 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760744AbaEMKLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:11:12 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Matthew Daley <mattd@bugfuzz.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 127/182] floppy: ignore kernel-only members in FDRAWCMD ioctl input
Date: Tue, 13 May 2014 11:27:59 +0200
Message-Id: <1cb1f240bf6d961ae26a583256e85a6e6bc09e39.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Daley <mattd@bugfuzz.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit ef87dbe7614341c2e7bfe8d32fcb7028cc97442c upstream.

Always clear out these floppy_raw_cmd struct members after copying the
entire structure from userspace so that the in-kernel version is always
valid and never left in an interdeterminate state.

Signed-off-by: Matthew Daley <mattd@bugfuzz.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/block/floppy.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 690011de912a..b836e1a9047f 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3107,10 +3107,11 @@ loop:
 		return -ENOMEM;
 	*rcmd = ptr;
 	ret = copy_from_user(ptr, param, sizeof(*ptr));
-	if (ret)
-		return -EFAULT;
 	ptr->next = NULL;
 	ptr->buffer_length = 0;
+	ptr->kernel_data = NULL;
+	if (ret)
+		return -EFAULT;
 	param += sizeof(struct floppy_raw_cmd);
 	if (ptr->cmd_count > 33)
 			/* the command may now also take up the space
@@ -3126,7 +3127,6 @@ loop:
 	for (i = 0; i < 16; i++)
 		ptr->reply[i] = 0;
 	ptr->resultcode = 0;
-	ptr->kernel_data = NULL;
 
 	if (ptr->flags & (FD_RAW_READ | FD_RAW_WRITE)) {
 		if (ptr->length <= 0)
-- 
1.9.3

