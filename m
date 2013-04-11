Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936525Ab3DKVIa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:08:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9226 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935679Ab3DKUtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:49:11 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=3BRh_vqWWtsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=faD4RiZyQDsA:10 a=PtDNVHqPAAAA:8 a=VwQbUJbxAAAA:8 a=DfNHnWVPAAAA:8 a=YWODpuaXHh98yajew5wA:9 a=wYE_KDyynt4A:10 a=lBRciGGoxdUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202604.352966800@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:26:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Serge Hallyn <serge.hallyn@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [ 110/171 ] vfs: Add a mount flag to lock read only bind mounts
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0110-vfs-Add-a-mount-flag-to-lock-read-only-bind-mounts.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

[ Upstream commit 90563b198e4c6674c63672fae1923da467215f45 ]

When a read-only bind mount is copied from mount namespace in a higher
privileged user namespace to a mount namespace in a lesser privileged
user namespace, it should not be possible to remove the the read-only
restriction.

Add a MNT_LOCK_READONLY mount flag to indicate that a mount must
remain read-only.

CC: stable@vger.kernel.org
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/namespace.c        |    3 +++
 include/linux/mount.h |    2 ++
 2 files changed, 5 insertions(+)

diff --git a/fs/namespace.c b/fs/namespace.c
index c48b0d3..48c7edb 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1702,6 +1702,9 @@ static int change_mount_flags(struct vfsmount *mnt, int ms_flags)
 	if (readonly_request == __mnt_is_readonly(mnt))
 		return 0;
 
+	if (mnt->mnt_flags & MNT_LOCK_READONLY)
+		return -EPERM;
+
 	if (readonly_request)
 		error = mnt_make_readonly(real_mount(mnt));
 	else
diff --git a/include/linux/mount.h b/include/linux/mount.h
index d7029f4..73005f9 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -47,6 +47,8 @@ struct mnt_namespace;
 
 #define MNT_INTERNAL	0x4000
 
+#define MNT_LOCK_READONLY	0x400000
+
 struct vfsmount {
 	struct dentry *mnt_root;	/* root of the mounted tree */
 	struct super_block *mnt_sb;	/* pointer to superblock */
-- 
1.7.10.4


