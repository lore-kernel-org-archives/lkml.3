Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965298Ab3BMSHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:07:31 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:52193 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965195Ab3BMSC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:02:57 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Steve French <smfrench@gmail.com>
Date: Wed, 13 Feb 2013 09:52:13 -0800
Message-Id: <1360777934-5663-84-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1/nbYsP2q1NTY6o6NP6rRikNOLyFIkeAUs=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0002]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 84/85] cifs: Convert struct cifs_ses to use a kuid_t and a kgid_t
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: Steve French <smfrench@gmail.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/cifs/cifs_spnego.c |    6 ++++--
 fs/cifs/cifsglob.h    |    4 ++--
 fs/cifs/connect.c     |    2 +-
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifs_spnego.c b/fs/cifs/cifs_spnego.c
index 086f381..10e7747 100644
--- a/fs/cifs/cifs_spnego.c
+++ b/fs/cifs/cifs_spnego.c
@@ -149,10 +149,12 @@ cifs_get_spnego_key(struct cifs_ses *sesInfo)
 		goto out;
 
 	dp = description + strlen(description);
-	sprintf(dp, ";uid=0x%x", sesInfo->linux_uid);
+	sprintf(dp, ";uid=0x%x",
+		from_kuid_munged(&init_user_ns, sesInfo->linux_uid));
 
 	dp = description + strlen(description);
-	sprintf(dp, ";creduid=0x%x", sesInfo->cred_uid);
+	sprintf(dp, ";creduid=0x%x",
+		from_kuid_munged(&init_user_ns, sesInfo->cred_uid));
 
 	if (sesInfo->user_name) {
 		dp = description + strlen(description);
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index e308e8b..aaef57b 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -702,8 +702,8 @@ struct cifs_ses {
 	char *serverNOS;	/* name of network operating system of server */
 	char *serverDomain;	/* security realm of server */
 	__u64 Suid;		/* remote smb uid  */
-	uid_t linux_uid;        /* overriding owner of files on the mount */
-	uid_t cred_uid;		/* owner of credentials */
+	kuid_t linux_uid;	/* overriding owner of files on the mount */
+	kuid_t cred_uid;	/* owner of credentials */
 	unsigned int capabilities;
 	char serverName[SERVER_NAME_LEN_WITH_NULL * 2];	/* BB make bigger for
 				TCP names - will ipv6 and sctp addresses fit? */
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 01279b8..067b0e1 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2271,7 +2271,7 @@ static int match_session(struct cifs_ses *ses, struct smb_vol *vol)
 {
 	switch (ses->server->secType) {
 	case Kerberos:
-		if (vol->cred_uid != ses->cred_uid)
+		if (!uid_eq(vol->cred_uid, ses->cred_uid))
 			return 0;
 		break;
 	default:
-- 
1.7.5.4

