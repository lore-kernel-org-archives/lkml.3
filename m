Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964873Ab3BMR5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:57:41 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:59128 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760292Ab3BMR5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:57:40 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Wed, 13 Feb 2013 09:51:35 -0800
Message-Id: <1360777934-5663-46-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1/tW6xby5oWq7hBXA4XU/4VlTo16NiDs4Q=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4990]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 46/85] sunrpc: Convert kuids and kgids to uids and gids for printing
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

When printing kuids and kgids for debugging purpropses convert them
to ordinary integers so their values can be fed to the oridnary
print functions.

Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 net/sunrpc/auth_generic.c      |    4 +++-
 net/sunrpc/auth_gss/auth_gss.c |   13 ++++++++-----
 net/sunrpc/auth_unix.c         |    3 ++-
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/sunrpc/auth_generic.c b/net/sunrpc/auth_generic.c
index bff3e47..b6badaf 100644
--- a/net/sunrpc/auth_generic.c
+++ b/net/sunrpc/auth_generic.c
@@ -96,7 +96,9 @@ generic_create_cred(struct rpc_auth *auth, struct auth_cred *acred, int flags)
 
 	dprintk("RPC:       allocated %s cred %p for uid %d gid %d\n",
 			gcred->acred.machine_cred ? "machine" : "generic",
-			gcred, acred->uid, acred->gid);
+			gcred,
+			from_kuid(&init_user_ns, acred->uid),
+			from_kgid(&init_user_ns, acred->gid));
 	return &gcred->gc_base;
 }
 
diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
index 1b8b3e4..afbbcfb 100644
--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -517,7 +517,7 @@ gss_refresh_upcall(struct rpc_task *task)
 	int err = 0;
 
 	dprintk("RPC: %5u %s for uid %u\n",
-		task->tk_pid, __func__, cred->cr_uid);
+		task->tk_pid, __func__, from_kuid(&init_user_ns, cred->cr_uid));
 	gss_msg = gss_setup_upcall(task->tk_client, gss_auth, cred);
 	if (PTR_ERR(gss_msg) == -EAGAIN) {
 		/* XXX: warning on the first, under the assumption we
@@ -549,7 +549,8 @@ gss_refresh_upcall(struct rpc_task *task)
 	gss_release_msg(gss_msg);
 out:
 	dprintk("RPC: %5u %s for uid %u result %d\n",
-		task->tk_pid, __func__, cred->cr_uid, err);
+		task->tk_pid, __func__,
+		from_kuid(&init_user_ns, cred->cr_uid),	err);
 	return err;
 }
 
@@ -562,7 +563,8 @@ gss_create_upcall(struct gss_auth *gss_auth, struct gss_cred *gss_cred)
 	DEFINE_WAIT(wait);
 	int err = 0;
 
-	dprintk("RPC:       %s for uid %u\n", __func__, cred->cr_uid);
+	dprintk("RPC:       %s for uid %u\n",
+		__func__, from_kuid(&init_user_ns, cred->cr_uid));
 retry:
 	gss_msg = gss_setup_upcall(gss_auth->client, gss_auth, cred);
 	if (PTR_ERR(gss_msg) == -EAGAIN) {
@@ -604,7 +606,7 @@ out_intr:
 	gss_release_msg(gss_msg);
 out:
 	dprintk("RPC:       %s for uid %u result %d\n",
-		__func__, cred->cr_uid, err);
+		__func__, from_kuid(&init_user_ns, cred->cr_uid), err);
 	return err;
 }
 
@@ -1059,7 +1061,8 @@ gss_create_cred(struct rpc_auth *auth, struct auth_cred *acred, int flags)
 	int err = -ENOMEM;
 
 	dprintk("RPC:       %s for uid %d, flavor %d\n",
-		__func__, acred->uid, auth->au_flavor);
+		__func__, from_kuid(&init_user_ns, acred->uid),
+		auth->au_flavor);
 
 	if (!(cred = kzalloc(sizeof(*cred), GFP_NOFS)))
 		goto out_err;
diff --git a/net/sunrpc/auth_unix.c b/net/sunrpc/auth_unix.c
index 9f38857..55b6ca6 100644
--- a/net/sunrpc/auth_unix.c
+++ b/net/sunrpc/auth_unix.c
@@ -65,7 +65,8 @@ unx_create_cred(struct rpc_auth *auth, struct auth_cred *acred, int flags)
 	unsigned int i;
 
 	dprintk("RPC:       allocating UNIX cred for uid %d gid %d\n",
-			acred->uid, acred->gid);
+			from_kuid(&init_user_ns, acred->uid),
+			from_kgid(&init_user_ns, acred->gid));
 
 	if (!(cred = kmalloc(sizeof(*cred), GFP_NOFS)))
 		return ERR_PTR(-ENOMEM);
-- 
1.7.5.4

