Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965165Ab3BMSTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:19:42 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:56583 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964936Ab3BMR5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:57:49 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Wed, 13 Feb 2013 09:51:37 -0800
Message-Id: <1360777934-5663-48-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1/62N1TOvRb1w3o1kJYUZJ8SGxTGUqQpqE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 48/85] sunrpc: Update gss uid to security context mapping.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

- Use from_kuid when generating the on the wire uid values.
- Use make_kuid when reading on the wire values.

In gss_encode_v0_msg, since the uid in gss_upcall_msg is now a kuid_t
generate the necessary uid_t value on the stack copy it into
gss_msg->databuf where it can safely live until the message is no
longer needed.

Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 net/sunrpc/auth_gss/auth_gss.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/net/sunrpc/auth_gss/auth_gss.c b/net/sunrpc/auth_gss/auth_gss.c
index afbbcfb..a360067 100644
--- a/net/sunrpc/auth_gss/auth_gss.c
+++ b/net/sunrpc/auth_gss/auth_gss.c
@@ -395,8 +395,11 @@ gss_upcall_callback(struct rpc_task *task)
 
 static void gss_encode_v0_msg(struct gss_upcall_msg *gss_msg)
 {
-	gss_msg->msg.data = &gss_msg->uid;
-	gss_msg->msg.len = sizeof(gss_msg->uid);
+	uid_t uid = from_kuid(&init_user_ns, gss_msg->uid);
+	memcpy(gss_msg->databuf, &uid, sizeof(uid));
+	gss_msg->msg.data = gss_msg->databuf;
+	gss_msg->msg.len = sizeof(uid);
+	BUG_ON(sizeof(uid) > UPCALL_BUF_LEN);
 }
 
 static void gss_encode_v1_msg(struct gss_upcall_msg *gss_msg,
@@ -409,7 +412,7 @@ static void gss_encode_v1_msg(struct gss_upcall_msg *gss_msg,
 
 	gss_msg->msg.len = sprintf(gss_msg->databuf, "mech=%s uid=%d ",
 				   mech->gm_name,
-				   gss_msg->uid);
+				   from_kuid(&init_user_ns, gss_msg->uid));
 	p += gss_msg->msg.len;
 	if (clnt->cl_principal) {
 		len = sprintf(p, "target=%s ", clnt->cl_principal);
@@ -620,7 +623,8 @@ gss_pipe_downcall(struct file *filp, const char __user *src, size_t mlen)
 	struct gss_upcall_msg *gss_msg;
 	struct rpc_pipe *pipe = RPC_I(filp->f_dentry->d_inode)->pipe;
 	struct gss_cl_ctx *ctx;
-	uid_t uid;
+	uid_t id;
+	kuid_t uid;
 	ssize_t err = -EFBIG;
 
 	if (mlen > MSG_BUF_MAXSIZE)
@@ -635,12 +639,18 @@ gss_pipe_downcall(struct file *filp, const char __user *src, size_t mlen)
 		goto err;
 
 	end = (const void *)((char *)buf + mlen);
-	p = simple_get_bytes(buf, end, &uid, sizeof(uid));
+	p = simple_get_bytes(buf, end, &id, sizeof(id));
 	if (IS_ERR(p)) {
 		err = PTR_ERR(p);
 		goto err;
 	}
 
+	uid = make_kuid(&init_user_ns, id);
+	if (!uid_valid(uid)) {
+		err = -EINVAL;
+		goto err;
+	}
+
 	err = -ENOMEM;
 	ctx = gss_alloc_context();
 	if (ctx == NULL)
-- 
1.7.5.4

