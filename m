Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965250Ab3BMSIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:08:49 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:34323 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965209Ab3BMSCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:02:54 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Wed, 13 Feb 2013 09:51:48 -0800
Message-Id: <1360777934-5663-59-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX1/sfnxyyDzTk3oOMWAiB1wxQrnEUeVfdE4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2689]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 59/85] nfs: Convert nfs4xdr to use kuids and kgids
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

When reading uids and gids off the wire convert them to
kuids and kgids.

When putting kuids and kgids onto the wire first convert
them to uids and gids the other side will understand.

When printing kuids and kgids convert them to values in
the initial user namespace then use normal printf formats.

Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/nfs/nfs4xdr.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/nfs/nfs4xdr.c b/fs/nfs/nfs4xdr.c
index 26b1439..e3edda5 100644
--- a/fs/nfs/nfs4xdr.c
+++ b/fs/nfs/nfs4xdr.c
@@ -1002,7 +1002,7 @@ static void encode_attrs(struct xdr_stream *xdr, const struct iattr *iap, const
 		owner_namelen = nfs_map_uid_to_name(server, iap->ia_uid, owner_name, IDMAP_NAMESZ);
 		if (owner_namelen < 0) {
 			dprintk("nfs: couldn't resolve uid %d to string\n",
-					iap->ia_uid);
+					from_kuid(&init_user_ns, iap->ia_uid));
 			/* XXX */
 			strcpy(owner_name, "nobody");
 			owner_namelen = sizeof("nobody") - 1;
@@ -1014,7 +1014,7 @@ static void encode_attrs(struct xdr_stream *xdr, const struct iattr *iap, const
 		owner_grouplen = nfs_map_gid_to_group(server, iap->ia_gid, owner_group, IDMAP_NAMESZ);
 		if (owner_grouplen < 0) {
 			dprintk("nfs: couldn't resolve gid %d to string\n",
-					iap->ia_gid);
+					from_kgid(&init_user_ns, iap->ia_gid));
 			strcpy(owner_group, "nobody");
 			owner_grouplen = sizeof("nobody") - 1;
 			/* goto out; */
@@ -3778,14 +3778,14 @@ out_overflow:
 }
 
 static int decode_attr_owner(struct xdr_stream *xdr, uint32_t *bitmap,
-		const struct nfs_server *server, uint32_t *uid,
+		const struct nfs_server *server, kuid_t *uid,
 		struct nfs4_string *owner_name)
 {
 	uint32_t len;
 	__be32 *p;
 	int ret = 0;
 
-	*uid = -2;
+	*uid = make_kuid(&init_user_ns, -2);
 	if (unlikely(bitmap[1] & (FATTR4_WORD1_OWNER - 1U)))
 		return -EIO;
 	if (likely(bitmap[1] & FATTR4_WORD1_OWNER)) {
@@ -3813,7 +3813,7 @@ static int decode_attr_owner(struct xdr_stream *xdr, uint32_t *bitmap,
 					__func__, len);
 		bitmap[1] &= ~FATTR4_WORD1_OWNER;
 	}
-	dprintk("%s: uid=%d\n", __func__, (int)*uid);
+	dprintk("%s: uid=%d\n", __func__, (int)from_kuid(&init_user_ns, *uid));
 	return ret;
 out_overflow:
 	print_overflow_msg(__func__, xdr);
@@ -3821,14 +3821,14 @@ out_overflow:
 }
 
 static int decode_attr_group(struct xdr_stream *xdr, uint32_t *bitmap,
-		const struct nfs_server *server, uint32_t *gid,
+		const struct nfs_server *server, kgid_t *gid,
 		struct nfs4_string *group_name)
 {
 	uint32_t len;
 	__be32 *p;
 	int ret = 0;
 
-	*gid = -2;
+	*gid = make_kgid(&init_user_ns, -2);
 	if (unlikely(bitmap[1] & (FATTR4_WORD1_OWNER_GROUP - 1U)))
 		return -EIO;
 	if (likely(bitmap[1] & FATTR4_WORD1_OWNER_GROUP)) {
@@ -3856,7 +3856,7 @@ static int decode_attr_group(struct xdr_stream *xdr, uint32_t *bitmap,
 					__func__, len);
 		bitmap[1] &= ~FATTR4_WORD1_OWNER_GROUP;
 	}
-	dprintk("%s: gid=%d\n", __func__, (int)*gid);
+	dprintk("%s: gid=%d\n", __func__, (int)from_kgid(&init_user_ns, *gid));
 	return ret;
 out_overflow:
 	print_overflow_msg(__func__, xdr);
-- 
1.7.5.4

