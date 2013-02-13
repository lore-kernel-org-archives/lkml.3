Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965396Ab3BMSLt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:11:49 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:60083 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965177Ab3BMSCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:02:46 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Wed, 13 Feb 2013 09:51:55 -0800
Message-Id: <1360777934-5663-66-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1/BoJhyQFR/TLOuv4qRmoUCU0nk1t2CeSo=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2112]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 66/85] nfsd: Convert nfs3xdr to use kuids and kgids
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

When reading uids and gids off the wire convert them to kuids and
kgids.

When putting kuids and kgids onto the wire first convert them to uids
and gids the other side will understand.

Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/nfsd/nfs3xdr.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 1884a3f..925c944 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -105,12 +105,14 @@ decode_sattr3(__be32 *p, struct iattr *iap)
 		iap->ia_mode = ntohl(*p++);
 	}
 	if (*p++) {
-		iap->ia_valid |= ATTR_UID;
-		iap->ia_uid = ntohl(*p++);
+		iap->ia_uid = make_kuid(&init_user_ns, ntohl(*p++));
+		if (uid_valid(iap->ia_uid))
+			iap->ia_valid |= ATTR_UID;
 	}
 	if (*p++) {
-		iap->ia_valid |= ATTR_GID;
-		iap->ia_gid = ntohl(*p++);
+		iap->ia_gid = make_kgid(&init_user_ns, ntohl(*p++));
+		if (gid_valid(iap->ia_gid))
+			iap->ia_valid |= ATTR_GID;
 	}
 	if (*p++) {
 		u64	newsize;
@@ -167,8 +169,8 @@ encode_fattr3(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fhp,
 	*p++ = htonl(nfs3_ftypes[(stat->mode & S_IFMT) >> 12]);
 	*p++ = htonl((u32) stat->mode);
 	*p++ = htonl((u32) stat->nlink);
-	*p++ = htonl((u32) stat->uid);
-	*p++ = htonl((u32) stat->gid);
+	*p++ = htonl((u32) from_kuid(&init_user_ns, stat->uid));
+	*p++ = htonl((u32) from_kgid(&init_user_ns, stat->gid));
 	if (S_ISLNK(stat->mode) && stat->size > NFS3_MAXPATHLEN) {
 		p = xdr_encode_hyper(p, (u64) NFS3_MAXPATHLEN);
 	} else {
-- 
1.7.5.4

