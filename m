Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760682Ab3BMR6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:58:32 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:59553 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965060Ab3BMR6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:58:08 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Wed, 13 Feb 2013 09:51:34 -0800
Message-Id: <1360777934-5663-45-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX19J0Q8dEEZAmyXhIybvkn35Ftn0z0ezgBA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2834]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 45/85] sunrpc: Simplify auth_unix now that everything is a kgid_t
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

In unx_create_cred directly assign gids from acred->group_info
to cred->uc_gids.

In unx_match directly compare uc_gids with group_info.

Now that both group_info and unx_cred gids are stored as kgids
this is valid and the extra layer of translation can be removed.

Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 net/sunrpc/auth_unix.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/net/sunrpc/auth_unix.c b/net/sunrpc/auth_unix.c
index 8365a9c..9f38857 100644
--- a/net/sunrpc/auth_unix.c
+++ b/net/sunrpc/auth_unix.c
@@ -79,11 +79,8 @@ unx_create_cred(struct rpc_auth *auth, struct auth_cred *acred, int flags)
 		groups = NFS_NGROUPS;
 
 	cred->uc_gid = acred->gid;
-	for (i = 0; i < groups; i++) {
-		gid_t gid;
-		gid = from_kgid(&init_user_ns, GROUP_AT(acred->group_info, i));
-		cred->uc_gids[i] = gid;
-	}
+	for (i = 0; i < groups; i++)
+		cred->uc_gids[i] = GROUP_AT(acred->group_info, i);
 	if (i < NFS_NGROUPS)
 		cred->uc_gids[i] = INVALID_GID;
 
@@ -130,12 +127,9 @@ unx_match(struct auth_cred *acred, struct rpc_cred *rcred, int flags)
 		groups = acred->group_info->ngroups;
 	if (groups > NFS_NGROUPS)
 		groups = NFS_NGROUPS;
-	for (i = 0; i < groups ; i++) {
-		gid_t gid;
-		gid = from_kgid(&init_user_ns, GROUP_AT(acred->group_info, i));
-		if (cred->uc_gids[i] != gid)
+	for (i = 0; i < groups ; i++)
+		if (!gid_eq(cred->uc_gids[i], GROUP_AT(acred->group_info, i)))
 			return 0;
-	}
 	if (groups < NFS_NGROUPS &&
 	    cred->uc_gids[groups] != INVALID_GID)
 		return 0;
-- 
1.7.5.4

