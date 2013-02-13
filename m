Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965372Ab3BMSMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:12:21 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:60017 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965156Ab3BMSCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:02:43 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Wed, 13 Feb 2013 09:51:56 -0800
Message-Id: <1360777934-5663-67-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1+dk33QldrORdved1trnShBsgLXKVCxAuY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1387]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 67/85] nfsd: Convert nfsxdr to use kuids and kgids
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

When reading uids and gids off the wire convert them to
kuids and kgids.  If the conversion results in an invalid
result don't set the ATTR_UID or ATTR_GID.

When putting kuids and kgids onto the wire first convert
them to uids and gids the other side will understand.

Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/nfsd/nfsxdr.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
index 1e51e70..4201ede 100644
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -100,12 +100,14 @@ decode_sattr(__be32 *p, struct iattr *iap)
 		iap->ia_mode = tmp;
 	}
 	if ((tmp = ntohl(*p++)) != (u32)-1) {
-		iap->ia_valid |= ATTR_UID;
-		iap->ia_uid = tmp;
+		iap->ia_uid = make_kuid(&init_user_ns, tmp);
+		if (uid_valid(iap->ia_uid))
+			iap->ia_valid |= ATTR_UID;
 	}
 	if ((tmp = ntohl(*p++)) != (u32)-1) {
-		iap->ia_valid |= ATTR_GID;
-		iap->ia_gid = tmp;
+		iap->ia_gid = make_kgid(&init_user_ns, tmp);
+		if (gid_valid(iap->ia_gid))
+			iap->ia_valid |= ATTR_GID;
 	}
 	if ((tmp = ntohl(*p++)) != (u32)-1) {
 		iap->ia_valid |= ATTR_SIZE;
@@ -151,8 +153,8 @@ encode_fattr(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fhp,
 	*p++ = htonl(nfs_ftypes[type >> 12]);
 	*p++ = htonl((u32) stat->mode);
 	*p++ = htonl((u32) stat->nlink);
-	*p++ = htonl((u32) stat->uid);
-	*p++ = htonl((u32) stat->gid);
+	*p++ = htonl((u32) from_kuid(&init_user_ns, stat->uid));
+	*p++ = htonl((u32) from_kgid(&init_user_ns, stat->gid));
 
 	if (S_ISLNK(type) && stat->size > NFS_MAXPATHLEN) {
 		*p++ = htonl(NFS_MAXPATHLEN);
-- 
1.7.5.4

