Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874AbaLBEEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 23:04:25 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:34530 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932655AbaLBEEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 23:04:24 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH] vfs: calculate seek offsets using unsigned variables
Date: Mon,  1 Dec 2014 23:04:07 -0500
Message-Id: <1417493050-13594-3-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1417493050-13594-1-git-send-email-sasha.levin@oracle.com>
References: <1417493050-13594-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding two loff_ts means adding two signed integers. Adding two such integers
when they are unchecked might cause an overflow which is undefined for
signed integers.

Avoid it by doing the math using unsigned cast and casting it back implicitly
into loff_t.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 fs/read_write.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index c0805c9..54311f4 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -91,7 +91,7 @@ generic_file_llseek_size(struct file *file, loff_t offset, int whence,
 {
 	switch (whence) {
 	case SEEK_END:
-		offset += eof;
+		offset += (u64)eof;
 		break;
 	case SEEK_CUR:
 		/*
@@ -108,7 +108,7 @@ generic_file_llseek_size(struct file *file, loff_t offset, int whence,
 		 * like SEEK_SET.
 		 */
 		spin_lock(&file->f_lock);
-		offset = vfs_setpos(file, file->f_pos + offset, maxsize);
+		offset = vfs_setpos(file, (u64)file->f_pos + offset, maxsize);
 		spin_unlock(&file->f_lock);
 		return offset;
 	case SEEK_DATA:
-- 
1.7.10.4

