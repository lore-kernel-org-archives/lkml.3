Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330AbaELBl5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:41:57 -0400
Received: from 1wt.eu ([62.212.114.60]:34424 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbaELBlx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:41:53 -0400
Message-Id: <20140512003206.604381637@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:34:22 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Matthew Daley <mattd@bugfuzz.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 142/143] floppy: ignore kernel-only members in FDRAWCMD ioctl input
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Daley <mattd@bugfuzz.com>

Always clear out these floppy_raw_cmd struct members after copying the
entire structure from userspace so that the in-kernel version is always
valid and never left in an interdeterminate state.

Signed-off-by: Matthew Daley <mattd@bugfuzz.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
(cherry picked from commit ef87dbe7614341c2e7bfe8d32fcb7028cc97442c)
[wt: be careful in 2.6.32 we still have the ugly macros everywhere]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/block/floppy.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 5c01f74..19d45e6 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3209,9 +3209,12 @@ static inline int raw_cmd_copyin(int cmd, char __user *param,
 		if (!ptr)
 			return -ENOMEM;
 		*rcmd = ptr;
-		COPYIN(*ptr);
+		ret = copy_from_user(ptr, (void __user *)param, sizeof(*ptr));
 		ptr->next = NULL;
 		ptr->buffer_length = 0;
+		ptr->kernel_data = NULL;
+		if (ret)
+			return -EFAULT;
 		param += sizeof(struct floppy_raw_cmd);
 		if (ptr->cmd_count > 33)
 			/* the command may now also take up the space
-- 
1.7.12.2.21.g234cd45.dirty



