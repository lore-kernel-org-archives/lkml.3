Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965465Ab3BMSWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:22:17 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:59153 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964882Ab3BMR5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:57:42 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Wed, 13 Feb 2013 09:51:31 -0800
Message-Id: <1360777934-5663-42-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1/7m5FR7fVMLDft8VBIEhgrbC8fN0F36x8=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1271]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 42/85] sunrpc: Use userns friendly constants.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Instead of (uid_t)0 use GLOBAL_ROOT_UID.
Instead of (gid_t)0 use GLOBAL_ROOT_GID.
Instead of (uid_t)-1 use INVALID_UID
Instead of (gid_t)-1 use INVALID_GID.
Instead of NOGROUP use INVALID_GID.

Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 net/sunrpc/auth.c         |    4 ++--
 net/sunrpc/auth_generic.c |    4 ++--
 net/sunrpc/auth_unix.c    |    6 +++---
 net/sunrpc/svcauth_unix.c |    4 ++--
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/sunrpc/auth.c b/net/sunrpc/auth.c
index b5c067b..4cd0ecf 100644
--- a/net/sunrpc/auth.c
+++ b/net/sunrpc/auth.c
@@ -519,8 +519,8 @@ rpcauth_bind_root_cred(struct rpc_task *task, int lookupflags)
 {
 	struct rpc_auth *auth = task->tk_client->cl_auth;
 	struct auth_cred acred = {
-		.uid = 0,
-		.gid = 0,
+		.uid = GLOBAL_ROOT_UID,
+		.gid = GLOBAL_ROOT_GID,
 	};
 
 	dprintk("RPC: %5u looking up %s cred\n",
diff --git a/net/sunrpc/auth_generic.c b/net/sunrpc/auth_generic.c
index 6ed6f20..9d2e0b0 100644
--- a/net/sunrpc/auth_generic.c
+++ b/net/sunrpc/auth_generic.c
@@ -18,8 +18,8 @@
 # define RPCDBG_FACILITY	RPCDBG_AUTH
 #endif
 
-#define RPC_MACHINE_CRED_USERID		((uid_t)0)
-#define RPC_MACHINE_CRED_GROUPID	((gid_t)0)
+#define RPC_MACHINE_CRED_USERID		GLOBAL_ROOT_UID
+#define RPC_MACHINE_CRED_GROUPID	GLOBAL_ROOT_GID
 
 struct generic_cred {
 	struct rpc_cred gc_base;
diff --git a/net/sunrpc/auth_unix.c b/net/sunrpc/auth_unix.c
index 52c5abd..2f86270 100644
--- a/net/sunrpc/auth_unix.c
+++ b/net/sunrpc/auth_unix.c
@@ -85,7 +85,7 @@ unx_create_cred(struct rpc_auth *auth, struct auth_cred *acred, int flags)
 		cred->uc_gids[i] = gid;
 	}
 	if (i < NFS_NGROUPS)
-		cred->uc_gids[i] = NOGROUP;
+		cred->uc_gids[i] = INVALID_GID;
 
 	return &cred->uc_base;
 }
@@ -137,7 +137,7 @@ unx_match(struct auth_cred *acred, struct rpc_cred *rcred, int flags)
 			return 0;
 	}
 	if (groups < NFS_NGROUPS &&
-	    cred->uc_gids[groups] != NOGROUP)
+	    cred->uc_gids[groups] != INVALID_GID)
 		return 0;
 	return 1;
 }
@@ -166,7 +166,7 @@ unx_marshal(struct rpc_task *task, __be32 *p)
 	*p++ = htonl((u32) cred->uc_uid);
 	*p++ = htonl((u32) cred->uc_gid);
 	hold = p++;
-	for (i = 0; i < 16 && cred->uc_gids[i] != (gid_t) NOGROUP; i++)
+	for (i = 0; i < 16 && cred->uc_gids[i] != INVALID_GID; i++)
 		*p++ = htonl((u32) cred->uc_gids[i]);
 	*hold = htonl(p - hold - 1);		/* gid array length */
 	*base = htonl((p - base - 1) << 2);	/* cred length */
diff --git a/net/sunrpc/svcauth_unix.c b/net/sunrpc/svcauth_unix.c
index 4d01292..c8cb5dc 100644
--- a/net/sunrpc/svcauth_unix.c
+++ b/net/sunrpc/svcauth_unix.c
@@ -750,8 +750,8 @@ svcauth_null_accept(struct svc_rqst *rqstp, __be32 *authp)
 	}
 
 	/* Signal that mapping to nobody uid/gid is required */
-	cred->cr_uid = (uid_t) -1;
-	cred->cr_gid = (gid_t) -1;
+	cred->cr_uid = INVALID_UID;
+	cred->cr_gid = INVALID_GID;
 	cred->cr_group_info = groups_alloc(0);
 	if (cred->cr_group_info == NULL)
 		return SVC_CLOSE; /* kmalloc failure - client must retry */
-- 
1.7.5.4

