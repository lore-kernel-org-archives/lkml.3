Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933196AbaAFXn2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:43:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47904 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932582AbaAFWj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:39:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Theodore Tso" <tytso@mit.edu>, ocfs2-devel@oss.oracle.com,
        Joel Becker <jlbec@evilplan.org>
Subject: [PATCH 3.12 132/144] jbd2: dont BUG but return ENOSPC if a handle runs out of space
Date: Mon,  6 Jan 2014 14:38:13 -0800
Message-Id: <20140106223749.135145858@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/jbd2/transaction.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1290,7 +1290,10 @@ int jbd2_journal_dirty_metadata(handle_t
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
 
@@ -1373,7 +1376,6 @@ out_unlock_bh:
 	jbd2_journal_put_journal_head(jh);
 out:
 	JBUFFER_TRACE(jh, "exit");
-	WARN_ON(ret);	/* All errors are bugs, so dump the stack */
 	return ret;
 }
 


