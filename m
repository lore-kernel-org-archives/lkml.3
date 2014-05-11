Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934113AbaEKTcl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:32:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48504 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934019AbaEKT0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:26:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Matthew Daley <mattd@bugfuzz.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.4 02/22] floppy: ignore kernel-only members in FDRAWCMD ioctl input
Date: Sun, 11 May 2014 21:21:10 +0200
Message-Id: <20140511192104.071185991@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511192103.733723493@linuxfoundation.org>
References: <20140511192103.733723493@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Daley <mattd@bugfuzz.com>

commit ef87dbe7614341c2e7bfe8d32fcb7028cc97442c upstream.

Always clear out these floppy_raw_cmd struct members after copying the
entire structure from userspace so that the in-kernel version is always
valid and never left in an interdeterminate state.

Signed-off-by: Matthew Daley <mattd@bugfuzz.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/floppy.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3112,10 +3112,11 @@ loop:
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
@@ -3131,7 +3132,6 @@ loop:
 	for (i = 0; i < 16; i++)
 		ptr->reply[i] = 0;
 	ptr->resultcode = 0;
-	ptr->kernel_data = NULL;
 
 	if (ptr->flags & (FD_RAW_READ | FD_RAW_WRITE)) {
 		if (ptr->length <= 0)


