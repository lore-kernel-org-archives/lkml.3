Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365AbaELBny (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:43:54 -0400
Received: from 1wt.eu ([62.212.114.60]:34747 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754304AbaELBnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:43:52 -0400
Message-Id: <20140512003206.645375802@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:34:23 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Matthew Daley <mattd@bugfuzz.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 143/143] floppy: dont write kernel-only members to FDRAWCMD ioctl output
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Daley <mattd@bugfuzz.com>

Do not leak kernel-only floppy_raw_cmd structure members to userspace.
This includes the linked-list pointer and the pointer to the allocated
DMA space.

Signed-off-by: Matthew Daley <mattd@bugfuzz.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
(cherry picked from commit 2145e15e0557a01b9195d1c7199a1b92cb9be81f)
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/block/floppy.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 19d45e6..f959aad 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3162,7 +3162,12 @@ static inline int raw_cmd_copyout(int cmd, char __user *param,
 	int ret;
 
 	while (ptr) {
-		COPYOUT(*ptr);
+		struct floppy_raw_cmd cmd = *ptr;
+		cmd.next = NULL;
+		cmd.kernel_data = NULL;
+		ret = copy_to_user((void __user *)param, &cmd, sizeof(cmd));
+		if (ret)
+			return -EFAULT;
 		param += sizeof(struct floppy_raw_cmd);
 		if ((ptr->flags & FD_RAW_READ) && ptr->buffer_length) {
 			if (ptr->length >= 0
-- 
1.7.12.2.21.g234cd45.dirty



