Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932538AbaJNO10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 10:27:26 -0400
Received: from mail-oi0-f49.google.com ([209.85.218.49]:61929 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932425AbaJNO0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 10:26:13 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>
Subject: [PATCH v4 3/5] fuse: Restrict allow_other to uids already controlled by the user
Date: Tue, 14 Oct 2014 16:25:54 +0200
Message-Id: <1413296756-25071-4-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1413296756-25071-1-git-send-email-seth.forshee@canonical.com>
References: <1413296756-25071-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unprivileged users are normally restricted from mounting with the
allow_other option by system policy, but this could be bypassed
for a mount done with user namespace root permissions. In such
cases allow_other should not allow users outside the user
namespace to access the mount as doing so would give the
unprivileged user the ability to manipulate processes it would
otherwise be unable to manipulate.

Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Serge H. Hallyn <serge.hallyn@ubuntu.com>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 fs/fuse/dir.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 123db1e06c78..e3123bfbc711 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1089,12 +1089,20 @@ int fuse_reverse_inval_entry(struct super_block *sb, u64 parent_nodeid,
  */
 int fuse_allow_current_process(struct fuse_conn *fc)
 {
-	const struct cred *cred;
+	const struct cred *cred = current_cred();
 
-	if (fc->flags & FUSE_ALLOW_OTHER)
-		return 1;
+	if (fc->flags & FUSE_ALLOW_OTHER) {
+		if (kuid_has_mapping(fc->user_ns, cred->euid) &&
+		    kuid_has_mapping(fc->user_ns, cred->suid) &&
+		    kuid_has_mapping(fc->user_ns, cred->uid) &&
+		    kgid_has_mapping(fc->user_ns, cred->egid) &&
+		    kgid_has_mapping(fc->user_ns, cred->sgid) &&
+		    kgid_has_mapping(fc->user_ns, cred->gid))
+			return 1;
+
+		return 0;
+	}
 
-	cred = current_cred();
 	if (uid_eq(cred->euid, fc->user_id) &&
 	    uid_eq(cred->suid, fc->user_id) &&
 	    uid_eq(cred->uid,  fc->user_id) &&
-- 
2.1.0

