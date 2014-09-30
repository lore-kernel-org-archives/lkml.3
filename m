Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbaI3V72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:59:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60919 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684AbaI3VhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:37:19 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 074/103] jbd2: fix infinite loop when recovering corrupt journal blocks
Date: Tue, 30 Sep 2014 14:31:19 -0700
Message-Id: <1412112708-27356-75-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 022eaa7517017efe4f6538750c2b59a804dc7df7 upstream.

When recovering the journal, don't fall into an infinite loop if we
encounter a corrupt journal block.  Instead, just skip the block and
return an error, which fails the mount and thus forces the user to run
a full filesystem fsck.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/jbd2/recovery.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index 3b6bb19..00e9703 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -426,6 +426,7 @@ static int do_one_pass(journal_t *journal,
 	int			tag_bytes = journal_tag_bytes(journal);
 	__u32			crc32_sum = ~0; /* Transactional Checksums */
 	int			descr_csum_size = 0;
+	int			block_error = 0;
 
 	/*
 	 * First thing is to establish what we expect to find in the log
@@ -598,7 +599,8 @@ static int do_one_pass(journal_t *journal,
 						       "checksum recovering "
 						       "block %llu in log\n",
 						       blocknr);
-						continue;
+						block_error = 1;
+						goto skip_write;
 					}
 
 					/* Find a buffer for the new
@@ -797,7 +799,8 @@ static int do_one_pass(journal_t *journal,
 				success = -EIO;
 		}
 	}
-
+	if (block_error && success == 0)
+		success = -EIO;
 	return success;
 
  failed:
-- 
1.9.1

