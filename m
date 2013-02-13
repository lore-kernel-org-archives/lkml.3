Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965328Ab3BMSEc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:04:32 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:52285 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965198Ab3BMSDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:03:01 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Wed, 13 Feb 2013 09:51:53 -0800
Message-Id: <1360777934-5663-64-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX18LYycD5HLxZikOTUJKD5wdG9PcqwXZIrE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 64/85] nfsd: Convert idmap to use kuids and kgids
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Convert nfsd_map_name_to_uid to return a kuid_t value.
Convert nfsd_map_name_to_gid to return a kgid_t value.
Convert nfsd_map_uid_to_name to take a kuid_t parameter.
Convert nfsd_map_gid_to_name to take a kgid_t paramater.

Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/nfsd/idmap.h     |    8 ++++----
 fs/nfsd/nfs4idmap.c |   26 ++++++++++++++++++++------
 2 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/fs/nfsd/idmap.h b/fs/nfsd/idmap.h
index 9d513ef..bf95f6b 100644
--- a/fs/nfsd/idmap.h
+++ b/fs/nfsd/idmap.h
@@ -54,9 +54,9 @@ static inline void nfsd_idmap_shutdown(struct net *net)
 }
 #endif
 
-__be32 nfsd_map_name_to_uid(struct svc_rqst *, const char *, size_t, __u32 *);
-__be32 nfsd_map_name_to_gid(struct svc_rqst *, const char *, size_t, __u32 *);
-int nfsd_map_uid_to_name(struct svc_rqst *, __u32, char *);
-int nfsd_map_gid_to_name(struct svc_rqst *, __u32, char *);
+__be32 nfsd_map_name_to_uid(struct svc_rqst *, const char *, size_t, kuid_t *);
+__be32 nfsd_map_name_to_gid(struct svc_rqst *, const char *, size_t, kgid_t *);
+int nfsd_map_uid_to_name(struct svc_rqst *, kuid_t, char *);
+int nfsd_map_gid_to_name(struct svc_rqst *, kgid_t, char *);
 
 #endif /* LINUX_NFSD_IDMAP_H */
diff --git a/fs/nfsd/nfs4idmap.c b/fs/nfsd/nfs4idmap.c
index 7e84dfa..0ce1234 100644
--- a/fs/nfsd/nfs4idmap.c
+++ b/fs/nfsd/nfs4idmap.c
@@ -625,26 +625,40 @@ do_id_to_name(struct svc_rqst *rqstp, int type, u32 id, char *name)
 
 __be32
 nfsd_map_name_to_uid(struct svc_rqst *rqstp, const char *name, size_t namelen,
-		__u32 *id)
+		kuid_t *uid)
 {
-	return do_name_to_id(rqstp, IDMAP_TYPE_USER, name, namelen, id);
+	__be32 status;
+	u32 id = -1;
+	status = do_name_to_id(rqstp, IDMAP_TYPE_USER, name, namelen, &id);
+	*uid = make_kuid(&init_user_ns, id);
+	if (!uid_valid(*uid))
+		status = nfserr_badowner;
+	return status;
 }
 
 __be32
 nfsd_map_name_to_gid(struct svc_rqst *rqstp, const char *name, size_t namelen,
-		__u32 *id)
+		kgid_t *gid)
 {
-	return do_name_to_id(rqstp, IDMAP_TYPE_GROUP, name, namelen, id);
+	__be32 status;
+	u32 id = -1;
+	status = do_name_to_id(rqstp, IDMAP_TYPE_GROUP, name, namelen, &id);
+	*gid = make_kgid(&init_user_ns, id);
+	if (!gid_valid(*gid))
+		status = nfserr_badowner;
+	return status;
 }
 
 int
-nfsd_map_uid_to_name(struct svc_rqst *rqstp, __u32 id, char *name)
+nfsd_map_uid_to_name(struct svc_rqst *rqstp, kuid_t uid, char *name)
 {
+	u32 id = from_kuid(&init_user_ns, uid);
 	return do_id_to_name(rqstp, IDMAP_TYPE_USER, id, name);
 }
 
 int
-nfsd_map_gid_to_name(struct svc_rqst *rqstp, __u32 id, char *name)
+nfsd_map_gid_to_name(struct svc_rqst *rqstp, kgid_t gid, char *name)
 {
+	u32 id = from_kgid(&init_user_ns, gid);
 	return do_id_to_name(rqstp, IDMAP_TYPE_GROUP, id, name);
 }
-- 
1.7.5.4

