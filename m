Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760539Ab3BMR6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:58:05 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:59424 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964917Ab3BMR6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:58:02 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>
Date: Wed, 13 Feb 2013 09:51:05 -0800
Message-Id: <1360777934-5663-16-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX188KYvcc3hgWYaH9+0qArdj7wAxqsxHsd4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 16/85] afs: Support interacting with multiple user namespaces
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Modify struct afs_file_status to store owner as a kuid_t and group as
a kgid_t.

In xdr_decode_AFSFetchStatus as owner is now a kuid_t and group is now
a kgid_t don't use the EXTRACT macro.  Instead perform the work of
the extract macro explicitly.  Read the value with ntohl and
convert it to the appropriate type with make_kuid or make_kgid.
Test if the value is different from what is stored in status and
update changed.   Update the value in status.

In xdr_encode_AFS_StoreStatus call from_kuid or from_kgid as
we are computing the on the wire encoding.

Initialize uids with GLOBAL_ROOT_UID instead of 0.
Initialize gids with GLOBAL_ROOT_GID instead of 0.

Cc: David Howells <dhowells@redhat.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/afs/afs.h      |    4 ++--
 fs/afs/fsclient.c |   14 ++++++++++----
 fs/afs/inode.c    |    6 +++---
 init/Kconfig      |    1 -
 4 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/fs/afs/afs.h b/fs/afs/afs.h
index 3d8fd35..3c462ff 100644
--- a/fs/afs/afs.h
+++ b/fs/afs/afs.h
@@ -119,8 +119,8 @@ struct afs_file_status {
 	u64			size;		/* file size */
 	afs_dataversion_t	data_version;	/* current data version */
 	u32			author;		/* author ID */
-	u32			owner;		/* owner ID */
-	u32			group;		/* group ID */
+	kuid_t			owner;		/* owner ID */
+	kgid_t			group;		/* group ID */
 	afs_access_t		caller_access;	/* access rights for authenticated caller */
 	afs_access_t		anon_access;	/* access rights for unauthenticated caller */
 	umode_t			mode;		/* UNIX mode */
diff --git a/fs/afs/fsclient.c b/fs/afs/fsclient.c
index b960ff0..c2e930e 100644
--- a/fs/afs/fsclient.c
+++ b/fs/afs/fsclient.c
@@ -42,6 +42,8 @@ static void xdr_decode_AFSFetchStatus(const __be32 **_bp,
 	umode_t mode;
 	u64 data_version, size;
 	u32 changed = 0; /* becomes non-zero if ctime-type changes seen */
+	kuid_t owner;
+	kgid_t group;
 
 #define EXTRACT(DST)				\
 	do {					\
@@ -56,7 +58,9 @@ static void xdr_decode_AFSFetchStatus(const __be32 **_bp,
 	size = ntohl(*bp++);
 	data_version = ntohl(*bp++);
 	EXTRACT(status->author);
-	EXTRACT(status->owner);
+	owner = make_kuid(&init_user_ns, ntohl(*bp++));
+	changed |= !uid_eq(owner, status->owner);
+	status->owner = owner;
 	EXTRACT(status->caller_access); /* call ticket dependent */
 	EXTRACT(status->anon_access);
 	EXTRACT(status->mode);
@@ -65,7 +69,9 @@ static void xdr_decode_AFSFetchStatus(const __be32 **_bp,
 	bp++; /* seg size */
 	status->mtime_client = ntohl(*bp++);
 	status->mtime_server = ntohl(*bp++);
-	EXTRACT(status->group);
+	group = make_kgid(&init_user_ns, ntohl(*bp++));
+	changed |= !gid_eq(group, status->group);
+	status->group = group;
 	bp++; /* sync counter */
 	data_version |= (u64) ntohl(*bp++) << 32;
 	EXTRACT(status->lock_count);
@@ -181,12 +187,12 @@ static void xdr_encode_AFS_StoreStatus(__be32 **_bp, struct iattr *attr)
 
 	if (attr->ia_valid & ATTR_UID) {
 		mask |= AFS_SET_OWNER;
-		owner = attr->ia_uid;
+		owner = from_kuid(&init_user_ns, attr->ia_uid);
 	}
 
 	if (attr->ia_valid & ATTR_GID) {
 		mask |= AFS_SET_GROUP;
-		group = attr->ia_gid;
+		group = from_kgid(&init_user_ns, attr->ia_gid);
 	}
 
 	if (attr->ia_valid & ATTR_MODE) {
diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index 95cffd3..789bc25 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -69,7 +69,7 @@ static int afs_inode_map_status(struct afs_vnode *vnode, struct key *key)
 
 	set_nlink(inode, vnode->status.nlink);
 	inode->i_uid		= vnode->status.owner;
-	inode->i_gid		= 0;
+	inode->i_gid		= GLOBAL_ROOT_GID;
 	inode->i_size		= vnode->status.size;
 	inode->i_ctime.tv_sec	= vnode->status.mtime_server;
 	inode->i_ctime.tv_nsec	= 0;
@@ -175,8 +175,8 @@ struct inode *afs_iget_autocell(struct inode *dir, const char *dev_name,
 	inode->i_mode		= S_IFDIR | S_IRUGO | S_IXUGO;
 	inode->i_op		= &afs_autocell_inode_operations;
 	set_nlink(inode, 2);
-	inode->i_uid		= 0;
-	inode->i_gid		= 0;
+	inode->i_uid		= GLOBAL_ROOT_UID;
+	inode->i_gid		= GLOBAL_ROOT_GID;
 	inode->i_ctime.tv_sec	= get_seconds();
 	inode->i_ctime.tv_nsec	= 0;
 	inode->i_atime		= inode->i_mtime = inode->i_ctime;
diff --git a/init/Kconfig b/init/Kconfig
index 394d24f..4570b02 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1071,7 +1071,6 @@ config UIDGID_CONVERTED
 	default y
 
 	# Filesystems
-	depends on AFS_FS = n
 	depends on CIFS = n
 	depends on CODA_FS = n
 	depends on GFS2_FS = n
-- 
1.7.5.4

