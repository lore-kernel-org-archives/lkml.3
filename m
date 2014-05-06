Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbaEFVOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 17:14:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41040 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbaEFVOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 17:14:08 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Matthew Daley <mattd@bugfuzz.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 3/4] floppy: ignore kernel-only members in FDRAWCMD ioctl input
Date: Tue,  6 May 2014 14:13:54 -0700
Message-Id: <1399410835-24162-4-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399410835-24162-1-git-send-email-kamal@canonical.com>
References: <1399410835-24162-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Daley <mattd@bugfuzz.com>

commit ef87dbe7614341c2e7bfe8d32fcb7028cc97442c upstream.

Always clear out these floppy_raw_cmd struct members after copying the
entire structure from userspace so that the in-kernel version is always
valid and never left in an interdeterminate state.

Signed-off-by: Matthew Daley <mattd@bugfuzz.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
References: CVE-2014-1737
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/block/floppy.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 2ddd64a..7ca5d3d 100644
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
1.9.1

