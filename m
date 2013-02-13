Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965348Ab3BMSJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:09:10 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:60181 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965054Ab3BMSCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:02:52 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Wed, 13 Feb 2013 09:51:52 -0800
Message-Id: <1360777934-5663-63-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX19Mg5qjSazuJpU5WhlagUgsjUA54jyCvjY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0013]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 63/85] nfsd: idmap use u32 not uid_t as the intermediate type
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

u32 and uid_t have the same size and semantics so this change
should have no operational effect.  This just removes the WTF
factor when looking at variables that hold both uids and gids
whos type is uid_t.

Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/nfsd/nfs4idmap.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/nfs4idmap.c b/fs/nfsd/nfs4idmap.c
index a1f10c0..7e84dfa 100644
--- a/fs/nfsd/nfs4idmap.c
+++ b/fs/nfsd/nfs4idmap.c
@@ -65,7 +65,7 @@ MODULE_PARM_DESC(nfs4_disable_idmapping,
 struct ent {
 	struct cache_head h;
 	int               type;		       /* User / Group */
-	uid_t             id;
+	u32               id;
 	char              name[IDMAP_NAMESZ];
 	char              authname[IDMAP_NAMESZ];
 };
@@ -540,7 +540,7 @@ rqst_authname(struct svc_rqst *rqstp)
 
 static __be32
 idmap_name_to_id(struct svc_rqst *rqstp, int type, const char *name, u32 namelen,
-		uid_t *id)
+		u32 *id)
 {
 	struct ent *item, key = {
 		.type = type,
@@ -564,7 +564,7 @@ idmap_name_to_id(struct svc_rqst *rqstp, int type, const char *name, u32 namelen
 }
 
 static int
-idmap_id_to_name(struct svc_rqst *rqstp, int type, uid_t id, char *name)
+idmap_id_to_name(struct svc_rqst *rqstp, int type, u32 id, char *name)
 {
 	struct ent *item, key = {
 		.id = id,
@@ -587,7 +587,7 @@ idmap_id_to_name(struct svc_rqst *rqstp, int type, uid_t id, char *name)
 }
 
 static bool
-numeric_name_to_id(struct svc_rqst *rqstp, int type, const char *name, u32 namelen, uid_t *id)
+numeric_name_to_id(struct svc_rqst *rqstp, int type, const char *name, u32 namelen, u32 *id)
 {
 	int ret;
 	char buf[11];
@@ -603,7 +603,7 @@ numeric_name_to_id(struct svc_rqst *rqstp, int type, const char *name, u32 namel
 }
 
 static __be32
-do_name_to_id(struct svc_rqst *rqstp, int type, const char *name, u32 namelen, uid_t *id)
+do_name_to_id(struct svc_rqst *rqstp, int type, const char *name, u32 namelen, u32 *id)
 {
 	if (nfs4_disable_idmapping && rqstp->rq_cred.cr_flavor < RPC_AUTH_GSS)
 		if (numeric_name_to_id(rqstp, type, name, namelen, id))
@@ -616,7 +616,7 @@ do_name_to_id(struct svc_rqst *rqstp, int type, const char *name, u32 namelen, u
 }
 
 static int
-do_id_to_name(struct svc_rqst *rqstp, int type, uid_t id, char *name)
+do_id_to_name(struct svc_rqst *rqstp, int type, u32 id, char *name)
 {
 	if (nfs4_disable_idmapping && rqstp->rq_cred.cr_flavor < RPC_AUTH_GSS)
 		return sprintf(name, "%u", id);
-- 
1.7.5.4

