Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965241Ab3BMSC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:02:59 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:52119 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965198Ab3BMSCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:02:52 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Wed, 13 Feb 2013 09:51:59 -0800
Message-Id: <1360777934-5663-70-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX18dBQABkGIdHSI/oX6rZCDiT2V9T51k0CM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0046]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 70/85] nfsd: Store ex_anon_uid and ex_anon_gid as kuids and kgids
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/nfsd/auth.c              |    2 +-
 fs/nfsd/export.c            |   22 ++++++++++++++--------
 include/linux/nfsd/export.h |    4 ++--
 3 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/fs/nfsd/auth.c b/fs/nfsd/auth.c
index 34a10d7..4d6642b 100644
--- a/fs/nfsd/auth.c
+++ b/fs/nfsd/auth.c
@@ -58,7 +58,7 @@ int nfsd_setuser(struct svc_rqst *rqstp, struct svc_export *exp)
 
 		for (i = 0; i < rqgi->ngroups; i++) {
 			if (gid_eq(GLOBAL_ROOT_GID, GROUP_AT(rqgi, i)))
-				GROUP_AT(gi, i) = make_kgid(&init_user_ns, exp->ex_anon_gid);
+				GROUP_AT(gi, i) = exp->ex_anon_gid;
 			else
 				GROUP_AT(gi, i) = GROUP_AT(rqgi, i);
 		}
diff --git a/fs/nfsd/export.c b/fs/nfsd/export.c
index a3946cf..5681c59 100644
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -544,13 +544,17 @@ static int svc_export_parse(struct cache_detail *cd, char *mesg, int mlen)
 		err = get_int(&mesg, &an_int);
 		if (err)
 			goto out3;
-		exp.ex_anon_uid= an_int;
+		exp.ex_anon_uid= make_kuid(&init_user_ns, an_int);
+		if (!uid_valid(exp.ex_anon_uid))
+			goto out3;
 
 		/* anon gid */
 		err = get_int(&mesg, &an_int);
 		if (err)
 			goto out3;
-		exp.ex_anon_gid= an_int;
+		exp.ex_anon_gid= make_kgid(&init_user_ns, an_int);
+		if (!gid_valid(exp.ex_anon_gid))
+			goto out3;
 
 		/* fsid */
 		err = get_int(&mesg, &an_int);
@@ -613,7 +617,7 @@ out:
 }
 
 static void exp_flags(struct seq_file *m, int flag, int fsid,
-		uid_t anonu, uid_t anong, struct nfsd4_fs_locations *fslocs);
+		kuid_t anonu, kgid_t anong, struct nfsd4_fs_locations *fslocs);
 static void show_secinfo(struct seq_file *m, struct svc_export *exp);
 
 static int svc_export_show(struct seq_file *m,
@@ -1179,15 +1183,17 @@ static void show_secinfo(struct seq_file *m, struct svc_export *exp)
 }
 
 static void exp_flags(struct seq_file *m, int flag, int fsid,
-		uid_t anonu, uid_t anong, struct nfsd4_fs_locations *fsloc)
+		kuid_t anonu, kgid_t anong, struct nfsd4_fs_locations *fsloc)
 {
 	show_expflags(m, flag, NFSEXP_ALLFLAGS);
 	if (flag & NFSEXP_FSID)
 		seq_printf(m, ",fsid=%d", fsid);
-	if (anonu != (uid_t)-2 && anonu != (0x10000-2))
-		seq_printf(m, ",anonuid=%u", anonu);
-	if (anong != (gid_t)-2 && anong != (0x10000-2))
-		seq_printf(m, ",anongid=%u", anong);
+	if (!uid_eq(anonu, make_kuid(&init_user_ns, (uid_t)-2)) &&
+	    !uid_eq(anonu, make_kuid(&init_user_ns, 0x10000-2)))
+		seq_printf(m, ",anonuid=%u", from_kuid(&init_user_ns, anonu));
+	if (!gid_eq(anong, make_kgid(&init_user_ns, (gid_t)-2)) &&
+	    !gid_eq(anong, make_kgid(&init_user_ns, 0x10000-2)))
+		seq_printf(m, ",anongid=%u", from_kgid(&init_user_ns, anong));
 	if (fsloc && fsloc->locations_count > 0) {
 		char *loctype = (fsloc->migrated) ? "refer" : "replicas";
 		int i;
diff --git a/include/linux/nfsd/export.h b/include/linux/nfsd/export.h
index 24c1392..7898c99 100644
--- a/include/linux/nfsd/export.h
+++ b/include/linux/nfsd/export.h
@@ -49,8 +49,8 @@ struct svc_export {
 	struct auth_domain *	ex_client;
 	int			ex_flags;
 	struct path		ex_path;
-	uid_t			ex_anon_uid;
-	gid_t			ex_anon_gid;
+	kuid_t			ex_anon_uid;
+	kgid_t			ex_anon_gid;
 	int			ex_fsid;
 	unsigned char *		ex_uuid; /* 16 byte fsid */
 	struct nfsd4_fs_locations ex_fslocs;
-- 
1.7.5.4

