Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258Ab3IBJMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 05:12:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37680 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758325Ab3IBIzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:55:02 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 13/58] jbd2: Fix use after free after error in jbd2_journal_dirty_metadata()
Date: Mon,  2 Sep 2013 09:53:58 +0100
Message-Id: <1378112083-9475-14-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
References: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.21 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/ext4_jbd2.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index f4f0ee6..a202728 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -109,10 +109,10 @@ int __ext4_handle_dirty_metadata(const char *where, unsigned int line,
 
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
-- 
1.8.3.2

