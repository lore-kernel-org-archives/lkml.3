Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168AbaHGQw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 12:52:56 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:23676 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932330AbaHGQwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 12:52:53 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-4c-53e3aee4ef20
Subject: [PATCH 3/3] Smack: remove unneeded NULL-termination from securtity
 label
From: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Date: Thu, 07 Aug 2014 20:52:49 +0400
Message-id: <20140807165249.13463.60191.stgit@buzz>
In-reply-to: <20140807165233.13463.55258.stgit@buzz>
References: <20140807165233.13463.55258.stgit@buzz>
User-Agent: StGit/0.17.1-dirty
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t/xy7pP1j0ONji5h8/i3rZfbBZ9j4Ms
	fuzsZbW4vGsOm8WHnkdsFucvnGN3YPO4tjvS4+PTWywefVtWMXoc3b+IzePzJrkA1igum5TU
	nMyy1CJ9uwSujN8np7MWNPNUTJ3QyN7AeIOzi5GDQ0LAROL1fr8uRk4gU0ziwr31bF2MXBxC
	AksZJU5cWcMO4TQySeza9JIdpEpYIFji0a8rzCA2m4CZxLZ9txlBbBEBHYl9e56DNTALzGSU
	2Lr+FBNIgkVAVWLDzidgzbwCxhLNjQuZQTZzAm0+Oa8QJCwEFF744BwLiC0qICex8nILK0S5
	oMSPyfdYQMqZBdQlpkzJBQkzC8hLbF7zlnkCo8AsJFWzEKpmIalawMi8ilE0tTS5oDgpPddI
	rzgxt7g0L10vOT93EyMkpL/uYFx6zOoQowAHoxIPr8Leu8FCrIllxZW5hxglOJiVRHh1ux8H
	C/GmJFZWpRblxxeV5qQWH2Jk4uCUamBUsu7WCGP1f6lTJOTvnH3C/ZTDg+2uNvcEnrQIPz+Z
	F3bsQm3fvoBKhQMabmGd1x4Kxl1ieyZ6811jCff2FdpsTrOmfzs07dgClbkzhVKyPz16aDj9
	5PNy+/Uv/6os+rqEnXVSNLsht49I3Ps5olvkj7Sv+mDIml/zxS723pfnXvkla+eJhpUosRRn
	JBpqMRcVJwIAkGTB2kcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Values of extended attributes are stored as binary blobs. NULL-termination
of them isn't required. It just wastes disk space and confuses command-line
tools like getfattr because they have to print that zero byte at the end.

This patch removes terminating zero byte from initial security label in
smack_inode_init_security and cuts it out in function smack_inode_getsecurity
which is used by syscall getxattr. This change seems completely safe, because
function smk_parse_smack ignores everything after first zero byte.

Signed-off-by: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
---
 security/smack/smack_lsm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index afa5ad0..16ae853 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -672,7 +672,7 @@ static int smack_inode_init_security(struct inode *inode, struct inode *dir,
 	}
 
 	if (len)
-		*len = strlen(isp) + 1;
+		*len = strlen(isp);
 
 	return 0;
 }
@@ -1076,7 +1076,7 @@ static int smack_inode_getsecurity(const struct inode *inode,
 
 	if (strcmp(name, XATTR_SMACK_SUFFIX) == 0) {
 		isp = smk_of_inode(inode);
-		ilen = strlen(isp) + 1;
+		ilen = strlen(isp);
 		*buffer = isp;
 		return ilen;
 	}
@@ -1101,7 +1101,7 @@ static int smack_inode_getsecurity(const struct inode *inode,
 	else
 		return -EOPNOTSUPP;
 
-	ilen = strlen(isp) + 1;
+	ilen = strlen(isp);
 	if (rc == 0) {
 		*buffer = isp;
 		rc = ilen;

