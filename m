Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933413AbaFIIzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:55:13 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58587 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932244AbaFIIv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:27 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Chuck Lever <chuck.lever@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 066/146] posix_acl: handle NULL ACL in posix_acl_equiv_mode
Date: Mon,  9 Jun 2014 10:50:01 +0200
Message-Id: <4a0f6231c2ba573a0471f69139e4eaff848ce2ce.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 50c6e282bdf5e8dabf8d7cf7b162545a55645fd9 upstream.

Various filesystems don't bother checking for a NULL ACL in
posix_acl_equiv_mode, and thus can dereference a NULL pointer when it
gets passed one. This usually happens from the NFS server, as the ACL tools
never pass a NULL ACL, but instead of one representing the mode bits.

Instead of adding boilerplat to all filesystems put this check into one place,
which will allow us to remove the check from other filesystems as well later
on.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Ben Greear <greearb@candelatech.com>
Reported-by: Marco Munderloh <munderl@tnt.uni-hannover.de>,
Cc: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/posix_acl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/posix_acl.c b/fs/posix_acl.c
index 8bd2135b7f82..3542f1f814e2 100644
--- a/fs/posix_acl.c
+++ b/fs/posix_acl.c
@@ -158,6 +158,12 @@ posix_acl_equiv_mode(const struct posix_acl *acl, umode_t *mode_p)
 	umode_t mode = 0;
 	int not_equiv = 0;
 
+	/*
+	 * A null ACL can always be presented as mode bits.
+	 */
+	if (!acl)
+		return 0;
+
 	FOREACH_ACL_ENTRY(pa, acl, pe) {
 		switch (pa->e_tag) {
 			case ACL_USER_OBJ:
-- 
1.9.3

