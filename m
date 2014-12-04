Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616AbaLDAYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 19:24:36 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:44565 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbaLDAYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 19:24:35 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org
Subject: [PATCH] mm: shmem: avoid overflowing in shmem_fallocate
Date: Wed,  3 Dec 2014 19:24:07 -0500
Message-Id: <1417652657-1801-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 2.1.0
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"offset + len" has the potential of overflowing. Validate this user input
first to avoid undefined behaviour.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 mm/shmem.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index 185836b..5a0e344 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2098,6 +2098,9 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 	}
 
 	/* We need to check rlimit even when FALLOC_FL_KEEP_SIZE */
+	error = -EOVERFLOW;
+	if ((u64)len + offset < (u64)len)
+		goto out;
 	error = inode_newsize_ok(inode, offset + len);
 	if (error)
 		goto out;
-- 
1.7.10.4

