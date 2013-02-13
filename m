Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964975Ab3BMSSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:18:38 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:59277 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964967Ab3BMR5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:57:52 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Jan Harkes <jaharkes@cs.cmu.edu>
Date: Wed, 13 Feb 2013 09:51:08 -0800
Message-Id: <1360777934-5663-19-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX18JtCEAB4jy2LkGRbfzRFUiIs2YVRgoE0U=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0017]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 19/85] coda: Cache permisions in struct coda_inode_info in a kuid_t.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

- Change c_uid in struct coda_indoe_info from a vuid_t to a kuid_t.
- Initialize c_uid to GLOBAL_ROOT_UID instead of 0.
- Use uid_eq to compare cached kuids.

Cc: Jan Harkes <jaharkes@cs.cmu.edu>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/coda/cache.c     |    4 ++--
 fs/coda/coda_fs_i.h |    2 +-
 fs/coda/inode.c     |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/coda/cache.c b/fs/coda/cache.c
index 958ae0e..1da168c 100644
--- a/fs/coda/cache.c
+++ b/fs/coda/cache.c
@@ -33,7 +33,7 @@ void coda_cache_enter(struct inode *inode, int mask)
 
 	spin_lock(&cii->c_lock);
 	cii->c_cached_epoch = atomic_read(&permission_epoch);
-	if (cii->c_uid != current_fsuid()) {
+	if (!uid_eq(cii->c_uid, current_fsuid())) {
 		cii->c_uid = current_fsuid();
                 cii->c_cached_perm = mask;
         } else
@@ -65,7 +65,7 @@ int coda_cache_check(struct inode *inode, int mask)
 	
 	spin_lock(&cii->c_lock);
 	hit = (mask & cii->c_cached_perm) == mask &&
-	    cii->c_uid == current_fsuid() &&
+	    uid_eq(cii->c_uid, current_fsuid()) &&
 	    cii->c_cached_epoch == atomic_read(&permission_epoch);
 	spin_unlock(&cii->c_lock);
 
diff --git a/fs/coda/coda_fs_i.h b/fs/coda/coda_fs_i.h
index b24fdfd..c640752 100644
--- a/fs/coda/coda_fs_i.h
+++ b/fs/coda/coda_fs_i.h
@@ -25,7 +25,7 @@ struct coda_inode_info {
 	u_short	           c_flags;     /* flags (see below) */
 	unsigned int	   c_mapcount;  /* nr of times this inode is mapped */
 	unsigned int	   c_cached_epoch; /* epoch for cached permissions */
-	vuid_t		   c_uid;	/* fsuid for cached permissions */
+	kuid_t		   c_uid;	/* fsuid for cached permissions */
 	unsigned int       c_cached_perm; /* cached access permissions */
 	spinlock_t	   c_lock;
 	struct inode	   vfs_inode;
diff --git a/fs/coda/inode.c b/fs/coda/inode.c
index 77bbaf4..cf674e9 100644
--- a/fs/coda/inode.c
+++ b/fs/coda/inode.c
@@ -49,7 +49,7 @@ static struct inode *coda_alloc_inode(struct super_block *sb)
 		return NULL;
 	memset(&ei->c_fid, 0, sizeof(struct CodaFid));
 	ei->c_flags = 0;
-	ei->c_uid = 0;
+	ei->c_uid = GLOBAL_ROOT_UID;
 	ei->c_cached_perm = 0;
 	spin_lock_init(&ei->c_lock);
 	return &ei->vfs_inode;
-- 
1.7.5.4

