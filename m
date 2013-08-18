Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab3HRUdl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:33:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43597 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649Ab3HRUde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:33:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sage Weil <sage@inktank.com>, Jan Kara <jack@suse.cz>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 34/34] jbd2: Fix use after free after error in jbd2_journal_dirty_metadata()
Date: Sun, 18 Aug 2013 13:34:47 -0700
Message-Id: <20130818203302.013900260@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203259.653403173@linuxfoundation.org>
References: <20130818203259.653403173@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 91aa11fae1cf8c2fd67be0609692ea9741cdcc43 upstream.

When jbd2_journal_dirty_metadata() returns error,
__ext4_handle_dirty_metadata() stops the handle. However callers of this
function do not count with that fact and still happily used now freed
handle. This use after free can result in various issues but very likely
we oops soon.

The motivation of adding __ext4_journal_stop() into
__ext4_handle_dirty_metadata() in commit 9ea7a0df seems to be only to
improve error reporting. So replace __ext4_journal_stop() with
ext4_journal_abort_handle() which was there before that commit and add
WARN_ON_ONCE() to dump stack to provide useful information.

Reported-by: Sage Weil <sage@inktank.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/ext4_jbd2.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -109,10 +109,10 @@ int __ext4_handle_dirty_metadata(const c
 
 	if (ext4_handle_valid(handle)) {
 		err = jbd2_journal_dirty_metadata(handle, bh);
-		if (err) {
-			/* Errors can only happen if there is a bug */
-			handle->h_err = err;
-			__ext4_journal_stop(where, line, handle);
+		/* Errors can only happen if there is a bug */
+		if (WARN_ON_ONCE(err)) {
+			ext4_journal_abort_handle(where, line, __func__, bh,
+						  handle, err);
 		}
 	} else {
 		if (inode)


