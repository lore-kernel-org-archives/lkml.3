Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab3IKE61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:58:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13847 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab3IKE45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:56:57 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=M-IOeofJHbkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=XbiVAmPvLeYA:10 a=DswfTcTIAAAA:8 a=VwQbUJbxAAAA:8 a=JtJ8RSbh8HISCLW2knAA:9 a=JfjM6313LcIA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042927.917364952@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sage Weil <sage@inktank.com>, Jan Kara <jack@suse.cz>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [215/251] jbd2: Fix use after free after error in
 jbd2_journal_dirty_metadata()
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0215-jbd2-Fix-use-after-free-after-error-in-jbd2_journal_.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 91aa11fae1cf8c2fd67be0609692ea9741cdcc43 ]

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
Cc: stable@vger.kernel.org	# 3.2+
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/ext4/ext4_jbd2.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index b4323ba..6d7abb1 100644
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
1.7.10.4


