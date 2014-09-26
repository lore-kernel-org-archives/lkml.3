Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbaIZKhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:37:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32933 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754688AbaIZJp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:45:56 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 016/142] jbd2: fix infinite loop when recovering corrupt journal blocks
Date: Fri, 26 Sep 2014 11:43:47 +0200
Message-Id: <9a8bd0aadcc9ba76c897696df51300a77d32f109.1411724723.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 022eaa7517017efe4f6538750c2b59a804dc7df7 upstream.

When recovering the journal, don't fall into an infinite loop if we
encounter a corrupt journal block.  Instead, just skip the block and
return an error, which fails the mount and thus forces the user to run
a full filesystem fsck.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/jbd2/recovery.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index 3929c50428b1..9070e485e9e6 100644
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
2.1.0

