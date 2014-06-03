Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932508AbaFCMRp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:17:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43329 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211AbaFCLki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:40:38 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christoph Hellwig <hch@lst.de>, Chuck Lever <chuck.lever@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 029/138] posix_acl: handle NULL ACL in posix_acl_equiv_mode
Date: Tue,  3 Jun 2014 12:37:55 +0100
Message-Id: <1401795584-22664-30-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.9.1

