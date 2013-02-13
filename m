Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965381Ab3BMSEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:04:41 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:34425 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965242Ab3BMSC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:02:59 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Wed, 13 Feb 2013 09:51:58 -0800
Message-Id: <1360777934-5663-69-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX19jZuqNr/ruYIDv/n0YiLMP1HursC2vbRE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0018]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 69/85] nfsd: Modify nfsd4_cb_sec to use kuids and kgids
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Change uid and gid in struct nfsd4_cb_sec to be of type kuid_t and
kgid_t.

In nfsd4_decode_cb_sec when reading uids and gids off the wire convert
them to kuids and kgids, and if they don't convert to valid kuids or
valid kuids ignore RPC_AUTH_UNIX and don't fill in any of the fields.

Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/nfsd/nfs4xdr.c |   13 ++++++++++---
 fs/nfsd/state.h   |    4 ++--
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 3812b06..2d1d06b 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -464,9 +464,16 @@ static __be32 nfsd4_decode_cb_sec(struct nfsd4_compoundargs *argp, struct nfsd4_
 			READ32(dummy);
 			READ_BUF(dummy * 4);
 			if (cbs->flavor == (u32)(-1)) {
-				cbs->uid = uid;
-				cbs->gid = gid;
-				cbs->flavor = RPC_AUTH_UNIX;
+				kuid_t kuid = make_kuid(&init_user_ns, uid);
+				kgid_t kgid = make_kgid(&init_user_ns, gid);
+				if (uid_valid(kuid) && gid_valid(kgid)) {
+					cbs->uid = kuid;
+					cbs->gid = kgid;
+					cbs->flavor = RPC_AUTH_UNIX;
+				} else {
+					dprintk("RPC_AUTH_UNIX with invalid"
+						"uid or gid ignoring!\n");
+				}
 			}
 			break;
 		case RPC_AUTH_GSS:
diff --git a/fs/nfsd/state.h b/fs/nfsd/state.h
index d1c229f..1a8c739 100644
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -152,8 +152,8 @@ struct nfsd4_channel_attrs {
 
 struct nfsd4_cb_sec {
 	u32	flavor; /* (u32)(-1) used to mean "no valid flavor" */
-	u32	uid;
-	u32	gid;
+	kuid_t	uid;
+	kgid_t	gid;
 };
 
 struct nfsd4_create_session {
-- 
1.7.5.4

