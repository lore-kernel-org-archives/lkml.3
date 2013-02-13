Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965078Ab3BMR6I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:58:08 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:56830 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965060Ab3BMR6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:58:02 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Wed, 13 Feb 2013 09:51:38 -0800
Message-Id: <1360777934-5663-49-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1/lhQyjHgFHYixNHMxsNdGKn67WdjSEv9U=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0366]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 49/85] sunrpc: Update svcgss xdr handle to rpsec_contect cache
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

For each received uid call make_kuid and validate the result.
For each received gid call make_kgid and validate the result.

Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 net/sunrpc/auth_gss/svcauth_gss.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index 73e9573..ecd1d58 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -418,6 +418,7 @@ static int rsc_parse(struct cache_detail *cd,
 {
 	/* contexthandle expiry [ uid gid N <n gids> mechname ...mechdata... ] */
 	char *buf = mesg;
+	int id;
 	int len, rv;
 	struct rsc rsci, *rscp = NULL;
 	time_t expiry;
@@ -444,7 +445,7 @@ static int rsc_parse(struct cache_detail *cd,
 		goto out;
 
 	/* uid, or NEGATIVE */
-	rv = get_int(&mesg, &rsci.cred.cr_uid);
+	rv = get_int(&mesg, &id);
 	if (rv == -EINVAL)
 		goto out;
 	if (rv == -ENOENT)
@@ -452,8 +453,16 @@ static int rsc_parse(struct cache_detail *cd,
 	else {
 		int N, i;
 
+		/* uid */
+		rsci.cred.cr_uid = make_kuid(&init_user_ns, id);
+		if (!uid_valid(rsci.cred.cr_uid))
+			goto out;
+
 		/* gid */
-		if (get_int(&mesg, &rsci.cred.cr_gid))
+		if (get_int(&mesg, &id))
+			goto out;
+		rsci.cred.cr_gid = make_kgid(&init_user_ns, id);
+		if (!gid_valid(rsci.cred.cr_gid))
 			goto out;
 
 		/* number of additional gid's */
@@ -467,11 +476,10 @@ static int rsc_parse(struct cache_detail *cd,
 		/* gid's */
 		status = -EINVAL;
 		for (i=0; i<N; i++) {
-			gid_t gid;
 			kgid_t kgid;
-			if (get_int(&mesg, &gid))
+			if (get_int(&mesg, &id))
 				goto out;
-			kgid = make_kgid(&init_user_ns, gid);
+			kgid = make_kgid(&init_user_ns, id);
 			if (!gid_valid(kgid))
 				goto out;
 			GROUP_AT(rsci.cred.cr_group_info, i) = kgid;
-- 
1.7.5.4

