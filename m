Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965420Ab3BMSON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:14:13 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:56713 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964964Ab3BMR55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:57:57 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Wed, 13 Feb 2013 09:51:33 -0800
Message-Id: <1360777934-5663-44-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX187tdwH+wsCnbK5In9Nuwq//3hTjiZsoMc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 
X-Spam-Combo: **;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 44/85] sunrpc: Use uid_eq and gid_eq where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

When comparing uids use uid_eq instead of ==.
When comparing gids use gid_eq instead of ==.

And unfortunate cost of type safety.

Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 net/sunrpc/auth_generic.c      |    8 ++++----
 net/sunrpc/auth_gss/auth_gss.c |    4 ++--
 net/sunrpc/auth_unix.c         |    2 +-
 net/sunrpc/svcauth_unix.c      |    2 +-
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/sunrpc/auth_generic.c b/net/sunrpc/auth_generic.c
index 9d2e0b0..bff3e47 100644
--- a/net/sunrpc/auth_generic.c
+++ b/net/sunrpc/auth_generic.c
@@ -129,8 +129,8 @@ machine_cred_match(struct auth_cred *acred, struct generic_cred *gcred, int flag
 {
 	if (!gcred->acred.machine_cred ||
 	    gcred->acred.principal != acred->principal ||
-	    gcred->acred.uid != acred->uid ||
-	    gcred->acred.gid != acred->gid)
+	    !uid_eq(gcred->acred.uid, acred->uid) ||
+	    !gid_eq(gcred->acred.gid, acred->gid))
 		return 0;
 	return 1;
 }
@@ -147,8 +147,8 @@ generic_match(struct auth_cred *acred, struct rpc_cred *cred, int flags)
 	if (acred->machine_cred)
 		return machine_cred_match(acred, gcred, flags);
 
-	if (gcred->acred.uid != acred->uid ||
-	    gcred->acred.gid != acred->gid ||
+	if (!uid_eq(gcred->acred.uid, acred->uid) ||
+	    !gid_eq(gcred->acred.gid, acred->gid) ||
 	    gcred->acred.machine_cred != 0)
 		goto out_nomatch;
 
diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
index 4daab81..1b8b3e4 100644
--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -307,7 +307,7 @@ __gss_find_upcall(struct rpc_pipe *pipe, kuid_t uid)
 {
 	struct gss_upcall_msg *pos;
 	list_for_each_entry(pos, &pipe->in_downcall, list) {
-		if (pos->uid != uid)
+		if (!uid_eq(pos->uid, uid))
 			continue;
 		atomic_inc(&pos->count);
 		dprintk("RPC:       %s found msg %p\n", __func__, pos);
@@ -1115,7 +1115,7 @@ out:
 	}
 	if (gss_cred->gc_principal != NULL)
 		return 0;
-	return rc->cr_uid == acred->uid;
+	return uid_eq(rc->cr_uid, acred->uid);
 }
 
 /*
diff --git a/net/sunrpc/auth_unix.c b/net/sunrpc/auth_unix.c
index 372d915..8365a9c 100644
--- a/net/sunrpc/auth_unix.c
+++ b/net/sunrpc/auth_unix.c
@@ -123,7 +123,7 @@ unx_match(struct auth_cred *acred, struct rpc_cred *rcred, int flags)
 	unsigned int i;
 
 
-	if (cred->uc_uid != acred->uid || cred->uc_gid != acred->gid)
+	if (!uid_eq(cred->uc_uid, acred->uid) || !gid_eq(cred->uc_gid, acred->gid))
 		return 0;
 
 	if (acred->group_info != NULL)
diff --git a/net/sunrpc/svcauth_unix.c b/net/sunrpc/svcauth_unix.c
index caae662..92166b5 100644
--- a/net/sunrpc/svcauth_unix.c
+++ b/net/sunrpc/svcauth_unix.c
@@ -433,7 +433,7 @@ static int unix_gid_match(struct cache_head *corig, struct cache_head *cnew)
 {
 	struct unix_gid *orig = container_of(corig, struct unix_gid, h);
 	struct unix_gid *new = container_of(cnew, struct unix_gid, h);
-	return orig->uid == new->uid;
+	return uid_eq(orig->uid, new->uid);
 }
 static void unix_gid_init(struct cache_head *cnew, struct cache_head *citem)
 {
-- 
1.7.5.4

