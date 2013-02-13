Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965406Ab3BMSOL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:14:11 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:49163 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965027Ab3BMR56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:57:58 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Wed, 13 Feb 2013 09:51:32 -0800
Message-Id: <1360777934-5663-43-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX18ml9fefy6jp8AQmt/2CaSv4NdWg+c+SqI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2665]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 
X-Spam-Combo: **;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 43/85] sunrpc: Use kuid_t and kgid_t where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Convert variables that store uids and gids to be of type
kuid_t and kgid_t instead of type uid_t and gid_t.

Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 include/linux/sunrpc/auth.h    |    7 ++++---
 include/linux/sunrpc/svcauth.h |    4 ++--
 net/sunrpc/auth_gss/auth_gss.c |    8 ++++----
 net/sunrpc/auth_unix.c         |    4 ++--
 net/sunrpc/svcauth_unix.c      |    8 ++++----
 5 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/include/linux/sunrpc/auth.h b/include/linux/sunrpc/auth.h
index f25ba92..58fda1c 100644
--- a/include/linux/sunrpc/auth.h
+++ b/include/linux/sunrpc/auth.h
@@ -17,14 +17,15 @@
 
 #include <linux/atomic.h>
 #include <linux/rcupdate.h>
+#include <linux/uidgid.h>
 
 /* size of the nodename buffer */
 #define UNX_MAXNODENAME	32
 
 /* Work around the lack of a VFS credential */
 struct auth_cred {
-	uid_t	uid;
-	gid_t	gid;
+	kuid_t	uid;
+	kgid_t	gid;
 	struct group_info *group_info;
 	const char *principal;
 	unsigned char machine_cred : 1;
@@ -48,7 +49,7 @@ struct rpc_cred {
 	unsigned long		cr_flags;	/* various flags */
 	atomic_t		cr_count;	/* ref count */
 
-	uid_t			cr_uid;
+	kuid_t			cr_uid;
 
 	/* per-flavor data */
 };
diff --git a/include/linux/sunrpc/svcauth.h b/include/linux/sunrpc/svcauth.h
index dd74084..ff374ab 100644
--- a/include/linux/sunrpc/svcauth.h
+++ b/include/linux/sunrpc/svcauth.h
@@ -18,8 +18,8 @@
 #include <linux/cred.h>
 
 struct svc_cred {
-	uid_t			cr_uid;
-	gid_t			cr_gid;
+	kuid_t			cr_uid;
+	kgid_t			cr_gid;
 	struct group_info	*cr_group_info;
 	u32			cr_flavor; /* pseudoflavor */
 	char			*cr_principal; /* for gss */
diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
index 6e5c824..4daab81 100644
--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -256,7 +256,7 @@ err:
 
 struct gss_upcall_msg {
 	atomic_t count;
-	uid_t	uid;
+	kuid_t	uid;
 	struct rpc_pipe_msg msg;
 	struct list_head list;
 	struct gss_auth *auth;
@@ -303,7 +303,7 @@ gss_release_msg(struct gss_upcall_msg *gss_msg)
 }
 
 static struct gss_upcall_msg *
-__gss_find_upcall(struct rpc_pipe *pipe, uid_t uid)
+__gss_find_upcall(struct rpc_pipe *pipe, kuid_t uid)
 {
 	struct gss_upcall_msg *pos;
 	list_for_each_entry(pos, &pipe->in_downcall, list) {
@@ -445,7 +445,7 @@ static void gss_encode_msg(struct gss_upcall_msg *gss_msg,
 
 static struct gss_upcall_msg *
 gss_alloc_msg(struct gss_auth *gss_auth, struct rpc_clnt *clnt,
-		uid_t uid, const char *service_name)
+		kuid_t uid, const char *service_name)
 {
 	struct gss_upcall_msg *gss_msg;
 	int vers;
@@ -475,7 +475,7 @@ gss_setup_upcall(struct rpc_clnt *clnt, struct gss_auth *gss_auth, struct rpc_cr
 	struct gss_cred *gss_cred = container_of(cred,
 			struct gss_cred, gc_base);
 	struct gss_upcall_msg *gss_new, *gss_msg;
-	uid_t uid = cred->cr_uid;
+	kuid_t uid = cred->cr_uid;
 
 	gss_new = gss_alloc_msg(gss_auth, clnt, uid, gss_cred->gc_principal);
 	if (IS_ERR(gss_new))
diff --git a/net/sunrpc/auth_unix.c b/net/sunrpc/auth_unix.c
index 2f86270..372d915 100644
--- a/net/sunrpc/auth_unix.c
+++ b/net/sunrpc/auth_unix.c
@@ -18,8 +18,8 @@
 
 struct unx_cred {
 	struct rpc_cred		uc_base;
-	gid_t			uc_gid;
-	gid_t			uc_gids[NFS_NGROUPS];
+	kgid_t			uc_gid;
+	kgid_t			uc_gids[NFS_NGROUPS];
 };
 #define uc_uid			uc_base.cr_uid
 
diff --git a/net/sunrpc/svcauth_unix.c b/net/sunrpc/svcauth_unix.c
index c8cb5dc..caae662 100644
--- a/net/sunrpc/svcauth_unix.c
+++ b/net/sunrpc/svcauth_unix.c
@@ -415,7 +415,7 @@ svcauth_unix_info_release(struct svc_xprt *xpt)
 
 struct unix_gid {
 	struct cache_head	h;
-	uid_t			uid;
+	kuid_t			uid;
 	struct group_info	*gi;
 };
 
@@ -475,7 +475,7 @@ static int unix_gid_upcall(struct cache_detail *cd, struct cache_head *h)
 	return sunrpc_cache_pipe_upcall(cd, h, unix_gid_request);
 }
 
-static struct unix_gid *unix_gid_lookup(struct cache_detail *cd, uid_t uid);
+static struct unix_gid *unix_gid_lookup(struct cache_detail *cd, kuid_t uid);
 
 static int unix_gid_parse(struct cache_detail *cd,
 			char *mesg, int mlen)
@@ -615,7 +615,7 @@ void unix_gid_cache_destroy(struct net *net)
 	cache_destroy_net(cd, net);
 }
 
-static struct unix_gid *unix_gid_lookup(struct cache_detail *cd, uid_t uid)
+static struct unix_gid *unix_gid_lookup(struct cache_detail *cd, kuid_t uid)
 {
 	struct unix_gid ug;
 	struct cache_head *ch;
@@ -628,7 +628,7 @@ static struct unix_gid *unix_gid_lookup(struct cache_detail *cd, uid_t uid)
 		return NULL;
 }
 
-static struct group_info *unix_gid_find(uid_t uid, struct svc_rqst *rqstp)
+static struct group_info *unix_gid_find(kuid_t uid, struct svc_rqst *rqstp)
 {
 	struct unix_gid *ug;
 	struct group_info *gi;
-- 
1.7.5.4

