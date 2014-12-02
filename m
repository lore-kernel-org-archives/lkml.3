Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932985AbaLBEEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 23:04:35 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:34578 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932964AbaLBEEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 23:04:32 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH] fs: sync_file_range: avoid overflowing signed calculation
Date: Mon,  1 Dec 2014 23:04:10 -0500
Message-Id: <1417493050-13594-6-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1417493050-13594-1-git-send-email-sasha.levin@oracle.com>
References: <1417493050-13594-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When calculating the end byte for the sync we preform an addition which might
result in an overflow, which is undefined. Avoid it by doing unsigned
addition.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 fs/sync.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/sync.c b/fs/sync.c
index 6ccfc38..f9cb38f 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -286,7 +286,7 @@ SYSCALL_DEFINE4(sync_file_range, int, fd, loff_t, offset, loff_t, nbytes,
 	if (flags & ~VALID_FLAGS)
 		goto out;
 
-	endbyte = offset + nbytes;
+	endbyte = offset + (u64)nbytes;
 
 	if ((s64)offset < 0)
 		goto out;
-- 
1.7.10.4

