Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759922Ab3IHDlM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:41:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56165 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756678Ab3IHDTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:19:16 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Theodore Ts'o" <tytso@mit.edu>,
        "Sage Weil" <sage@inktank.com>, "Jan Kara" <jack@suse.cz>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.132647878@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [067/121] jbd2: Fix use after free after error in jbd2_journal_dirty_metadata()
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/ext4_jbd2.c | 8 ++++----
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

