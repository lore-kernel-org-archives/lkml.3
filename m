Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933114AbbA1UbF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:31:05 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:42290 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759636AbbA1UbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:31:01 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH v2] vfs: read file_handle only once in handle_to_path
Date: Wed, 28 Jan 2015 15:30:43 -0500
Message-Id: <1422477048-4550-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We used to read file_handle twice. Once to get the amount of extra bytes, and
once to fetch the entire structure.

This may be problematic since we do size verifications only after the first
read, so if the number of extra bytes changes in userspace between the first
and second calls, we'll have an incoherent view of file_handle.

Instead, read the constant size once, and copy that over to the final
structure without having to re-read it again.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
Change in v2:
 - Use the f_handle pointer rather than size of struct

 fs/fhandle.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/fhandle.c b/fs/fhandle.c
index 999ff5c..d59712d 100644
--- a/fs/fhandle.c
+++ b/fs/fhandle.c
@@ -195,8 +195,9 @@ static int handle_to_path(int mountdirfd, struct file_handle __user *ufh,
 		goto out_err;
 	}
 	/* copy the full handle */
-	if (copy_from_user(handle, ufh,
-			   sizeof(struct file_handle) +
+	*handle = f_handle;
+	if (copy_from_user(&handle->f_handle,
+			   &ufh->f_handle,
 			   f_handle.handle_bytes)) {
 		retval = -EFAULT;
 		goto out_handle;
-- 
1.7.10.4

