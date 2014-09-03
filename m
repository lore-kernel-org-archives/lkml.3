Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934045AbaICWUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 18:20:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46224 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933922AbaICWS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:18:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Theodore Tso <tytso@mit.edu>
Subject: [PATCH 3.16 100/125] jbd2: fix infinite loop when recovering corrupt journal blocks
Date: Wed,  3 Sep 2014 15:07:37 -0700
Message-Id: <20140903220626.698014586@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220623.649748296@linuxfoundation.org>
References: <20140903220623.649748296@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 022eaa7517017efe4f6538750c2b59a804dc7df7 upstream.

When recovering the journal, don't fall into an infinite loop if we
encounter a corrupt journal block.  Instead, just skip the block and
return an error, which fails the mount and thus forces the user to run
a full filesystem fsck.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/jbd2/recovery.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -426,6 +426,7 @@ static int do_one_pass(journal_t *journa
 	int			tag_bytes = journal_tag_bytes(journal);
 	__u32			crc32_sum = ~0; /* Transactional Checksums */
 	int			descr_csum_size = 0;
+	int			block_error = 0;
 
 	/*
 	 * First thing is to establish what we expect to find in the log
@@ -598,7 +599,8 @@ static int do_one_pass(journal_t *journa
 						       "checksum recovering "
 						       "block %llu in log\n",
 						       blocknr);
-						continue;
+						block_error = 1;
+						goto skip_write;
 					}
 
 					/* Find a buffer for the new
@@ -797,7 +799,8 @@ static int do_one_pass(journal_t *journa
 				success = -EIO;
 		}
 	}
-
+	if (block_error && success == 0)
+		success = -EIO;
 	return success;
 
  failed:


