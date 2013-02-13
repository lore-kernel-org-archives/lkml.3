Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965303Ab3BMSDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:03:51 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:34475 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965250Ab3BMSDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:03:03 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-fsdevel@vger.kernel.org>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Wed, 13 Feb 2013 09:51:47 -0800
Message-Id: <1360777934-5663-58-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
References: <87621w14vs.fsf@xmission.com>
 <1360777934-5663-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX18ha41hHPrr/g0GyuLh1uZfFG98vphTthM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-fsdevel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 58/85] nfs: Convert nfs3xdr to use kuids and kgids
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

Add an additional failure mode incoming for uids or gids
that are invalid.

Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/nfs/nfs3xdr.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/nfs3xdr.c b/fs/nfs/nfs3xdr.c
index bffc324..fa6d721 100644
--- a/fs/nfs/nfs3xdr.c
+++ b/fs/nfs/nfs3xdr.c
@@ -592,13 +592,13 @@ static void encode_sattr3(struct xdr_stream *xdr, const struct iattr *attr)
 
 	if (attr->ia_valid & ATTR_UID) {
 		*p++ = xdr_one;
-		*p++ = cpu_to_be32(attr->ia_uid);
+		*p++ = cpu_to_be32(from_kuid(&init_user_ns, attr->ia_uid));
 	} else
 		*p++ = xdr_zero;
 
 	if (attr->ia_valid & ATTR_GID) {
 		*p++ = xdr_one;
-		*p++ = cpu_to_be32(attr->ia_gid);
+		*p++ = cpu_to_be32(from_kgid(&init_user_ns, attr->ia_gid));
 	} else
 		*p++ = xdr_zero;
 
@@ -657,8 +657,12 @@ static int decode_fattr3(struct xdr_stream *xdr, struct nfs_fattr *fattr)
 
 	fattr->mode = (be32_to_cpup(p++) & ~S_IFMT) | fmode;
 	fattr->nlink = be32_to_cpup(p++);
-	fattr->uid = be32_to_cpup(p++);
-	fattr->gid = be32_to_cpup(p++);
+	fattr->uid = make_kuid(&init_user_ns, be32_to_cpup(p++));
+	if (!uid_valid(fattr->uid))
+		goto out_uid;
+	fattr->gid = make_kgid(&init_user_ns, be32_to_cpup(p++));
+	if (!gid_valid(fattr->gid))
+		goto out_gid;
 
 	p = xdr_decode_size3(p, &fattr->size);
 	p = xdr_decode_size3(p, &fattr->du.nfs3.used);
@@ -675,6 +679,12 @@ static int decode_fattr3(struct xdr_stream *xdr, struct nfs_fattr *fattr)
 
 	fattr->valid |= NFS_ATTR_FATTR_V3;
 	return 0;
+out_uid:
+	dprintk("NFS: returned invalid uid\n");
+	return -EINVAL;
+out_gid:
+	dprintk("NFS: returned invalid gid\n");
+	return -EINVAL;
 out_overflow:
 	print_overflow_msg(__func__, xdr);
 	return -EIO;
-- 
1.7.5.4

