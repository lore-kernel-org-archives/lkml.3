Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbaAMQBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:01:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:52898 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbaAMQB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:01:28 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 024/208] ext4: call ext4_error_inode() if jbd2_journal_dirty_metadata() fails
Date: Mon, 13 Jan 2014 15:57:45 +0000
Message-Id: <1389628849-1614-25-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit ae1495b12df1897d4f42842a7aa7276d920f6290 upstream.

While it's true that errors can only happen if there is a bug in
jbd2_journal_dirty_metadata(), if a bug does happen, we need to halt
the kernel or remount the file system read-only in order to avoid
further data loss.  The ext4_journal_abort_handle() function doesn't
do any of this, and while it's likely that this call (since it doesn't
adjust refcounts) will likely result in the file system eventually
deadlocking since the current transaction will never be able to close,
it's much cleaner to call let ext4's error handling system deal with
this situation.

There's a separate bug here which is that if certain jbd2 errors
errors occur and file system is mounted errors=continue, the file
system will probably eventually end grind to a halt as described
above.  But things have been this way in a long time, and usually when
we have these sorts of errors it's pretty much a disaster --- and
that's why the jbd2 layer aggressively retries memory allocations,
which is the most likely cause of these jbd2 errors.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/ext4_jbd2.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 17ac112..3fe29de 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -259,6 +259,15 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
 		if (WARN_ON_ONCE(err)) {
 			ext4_journal_abort_handle(where, line, __func__, bh,
 						  handle, err);
+			ext4_error_inode(inode, where, line,
+					 bh->b_blocknr,
+					 "journal_dirty_metadata failed: "
+					 "handle type %u started at line %u, "
+					 "credits %u/%u, errcode %d",
+					 handle->h_type,
+					 handle->h_line_no,
+					 handle->h_requested_credits,
+					 handle->h_buffer_credits, err);
 		}
 	} else {
 		if (inode)
-- 
1.8.3.2

