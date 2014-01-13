Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611AbaAMOoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:44:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51469 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbaAMO0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:26:33 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>, ocfs2-devel@oss.oracle.com,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 64/96] jbd2: don't BUG but return ENOSPC if a handle runs out of space
Date: Mon, 13 Jan 2014 14:24:27 +0000
Message-Id: <1389623099-18783-65-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit f6c07cad081ba222d63623d913aafba5586c1d2c upstream.

If a handle runs out of space, we currently stop the kernel with a BUG
in jbd2_journal_dirty_metadata().  This makes it hard to figure out
what might be going on.  So return an error of ENOSPC, so we can let
the file system layer figure out what is going on, to make it more
likely we can get useful debugging information).  This should make it
easier to debug problems such as the one which was reported by:

    https://bugzilla.kernel.org/show_bug.cgi?id=44731

The only two callers of this function are ext4_handle_dirty_metadata()
and ocfs2_journal_dirty().  The ocfs2 function will trigger a
BUG_ON(), which means there will be no change in behavior.  The ext4
function will call ext4_error_inode() which will print the useful
debugging information and then handle the situation using ext4's error
handling mechanisms (i.e., which might mean halting the kernel or
remounting the file system read-only).

Also, since both file systems already call WARN_ON(), drop the WARN_ON
from jbd2_journal_dirty_metadata() to avoid two stack traces from
being displayed.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: ocfs2-devel@oss.oracle.com
Acked-by: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/jbd2/transaction.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 81203d1..edfb1ec 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1126,7 +1126,10 @@ int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
 		 * once a transaction -bzzz
 		 */
 		jh->b_modified = 1;
-		J_ASSERT_JH(jh, handle->h_buffer_credits > 0);
+		if (handle->h_buffer_credits <= 0) {
+			ret = -ENOSPC;
+			goto out_unlock_bh;
+		}
 		handle->h_buffer_credits--;
 	}
 
@@ -1209,7 +1212,6 @@ out_unlock_bh:
 	jbd2_journal_put_journal_head(jh);
 out:
 	JBUFFER_TRACE(jh, "exit");
-	WARN_ON(ret);	/* All errors are bugs, so dump the stack */
 	return ret;
 }
 
-- 
1.8.3.2

