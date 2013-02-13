Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964978Ab3BMSTX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:19:23 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:56591 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964950Ab3BMR5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:57:49 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jan Harkes <jaharkes@cs.cmu.edu>
Date: Wed, 13 Feb 2013 09:51:07 -0800
Message-Id: <1360777934-5663-18-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1/M9YPs5x77MHOTtNKacAG00VbtOmAbYS0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 18/85] coda: Restrict coda messages to the initial user namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Remove the slight chance that uids and gids in coda messages will be
interpreted in the wrong user namespace.

- Only allow processes in the initial user namespace to open the coda
  character device to communicate with coda filesystems.
- Explicitly convert the uids in the coda header into the initial user
  namespace.
- In coda_vattr_to_attr make kuids and kgids from the initial user
  namespace uids and gids in struct coda_vattr that just came from
  userspace.
- In coda_iattr_to_vattr convert kuids and kgids into uids and gids
  in the intial user namespace and store them in struct coda_vattr for
  sending to coda userspace programs.

Nothing needs to be changed with mounts as coda does not support
being mounted in anything other than the initial user namespace.

Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/coda/coda_linux.c       |    8 ++++----
 fs/coda/psdev.c            |    3 +++
 fs/coda/upcall.c           |    6 +++---
 include/linux/coda_psdev.h |    2 +-
 4 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/coda/coda_linux.c b/fs/coda/coda_linux.c
index 854ace7..2849f41 100644
--- a/fs/coda/coda_linux.c
+++ b/fs/coda/coda_linux.c
@@ -100,9 +100,9 @@ void coda_vattr_to_iattr(struct inode *inode, struct coda_vattr *attr)
 	if (attr->va_mode != (u_short) -1)
 	        inode->i_mode = attr->va_mode | inode_type;
         if (attr->va_uid != -1) 
-	        inode->i_uid = (uid_t) attr->va_uid;
+	        inode->i_uid = make_kuid(&init_user_ns, (uid_t) attr->va_uid);
         if (attr->va_gid != -1)
-	        inode->i_gid = (gid_t) attr->va_gid;
+	        inode->i_gid = make_kgid(&init_user_ns, (gid_t) attr->va_gid);
 	if (attr->va_nlink != -1)
 		set_nlink(inode, attr->va_nlink);
 	if (attr->va_size != -1)
@@ -171,10 +171,10 @@ void coda_iattr_to_vattr(struct iattr *iattr, struct coda_vattr *vattr)
                 vattr->va_mode = iattr->ia_mode;
 	}
         if ( valid & ATTR_UID ) {
-                vattr->va_uid = (vuid_t) iattr->ia_uid;
+                vattr->va_uid = (vuid_t) from_kuid(&init_user_ns, iattr->ia_uid);
 	}
         if ( valid & ATTR_GID ) {
-                vattr->va_gid = (vgid_t) iattr->ia_gid;
+                vattr->va_gid = (vgid_t) from_kgid(&init_user_ns, iattr->ia_gid);
 	}
         if ( valid & ATTR_SIZE ) {
                 vattr->va_size = iattr->ia_size;
diff --git a/fs/coda/psdev.c b/fs/coda/psdev.c
index dd60f90..ebc2bae 100644
--- a/fs/coda/psdev.c
+++ b/fs/coda/psdev.c
@@ -270,6 +270,9 @@ static int coda_psdev_open(struct inode * inode, struct file * file)
 	if (task_active_pid_ns(current) != &init_pid_ns)
 		return -EINVAL;
 
+	if (current_user_ns() != &init_user_ns)
+		return -EINVAL;
+
 	idx = iminor(inode);
 	if (idx < 0 || idx >= MAX_CODADEVS)
 		return -ENODEV;
diff --git a/fs/coda/upcall.c b/fs/coda/upcall.c
index 5c6d2cd..3a73197 100644
--- a/fs/coda/upcall.c
+++ b/fs/coda/upcall.c
@@ -52,7 +52,7 @@ static void *alloc_upcall(int opcode, int size)
         inp->ih.opcode = opcode;
 	inp->ih.pid = task_pid_nr_ns(current, &init_pid_ns);
 	inp->ih.pgid = task_pgrp_nr_ns(current, &init_pid_ns);
-	inp->ih.uid = current_fsuid();
+	inp->ih.uid = from_kuid(&init_user_ns, current_fsuid());
 
 	return (void*)inp;
 }
@@ -157,7 +157,7 @@ int venus_lookup(struct super_block *sb, struct CodaFid *fid,
 }
 
 int venus_close(struct super_block *sb, struct CodaFid *fid, int flags,
-		vuid_t uid)
+		kuid_t uid)
 {
 	union inputArgs *inp;
 	union outputArgs *outp;
@@ -166,7 +166,7 @@ int venus_close(struct super_block *sb, struct CodaFid *fid, int flags,
 	insize = SIZE(release);
 	UPARG(CODA_CLOSE);
 	
-	inp->ih.uid = uid;
+	inp->ih.uid = from_kuid(&init_user_ns, uid);
         inp->coda_close.VFid = *fid;
         inp->coda_close.flags = flags;
 
diff --git a/include/linux/coda_psdev.h b/include/linux/coda_psdev.h
index 8031d6e..5b8721e 100644
--- a/include/linux/coda_psdev.h
+++ b/include/linux/coda_psdev.h
@@ -34,7 +34,7 @@ int venus_lookup(struct super_block *sb, struct CodaFid *fid,
 		 const char *name, int length, int *type, 
 		 struct CodaFid *resfid);
 int venus_close(struct super_block *sb, struct CodaFid *fid, int flags,
-		vuid_t uid);
+		kuid_t uid);
 int venus_open(struct super_block *sb, struct CodaFid *fid, int flags,
 	       struct file **f);
 int venus_mkdir(struct super_block *sb, struct CodaFid *dirfid, 
-- 
1.7.5.4

