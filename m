Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbaAFWip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 17:38:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47495 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932153AbaAFWim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:38:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Theodore Tso" <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Subject: [PATCH 3.12 050/144] ext4: call ext4_error_inode() if jbd2_journal_dirty_metadata() fails
Date: Mon,  6 Jan 2014 14:36:51 -0800
Message-Id: <20140106223746.779224913@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/ext4_jbd2.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -259,6 +259,15 @@ int __ext4_handle_dirty_metadata(const c
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


