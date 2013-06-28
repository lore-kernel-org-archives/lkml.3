Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361Ab3F1Swe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:52:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41490 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab3F1Sw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:52:26 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "J. Bruce Fields" <bfields@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 009/105] nfsd4: don't allow owner override on 4.1 CLAIM_FH opens
Date: Fri, 28 Jun 2013 11:50:31 -0700
Message-Id: <1372445527-24414-10-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 9f415eb25574db4b73a9a712a4438e41dc284922 upstream.

The Linux client is using CLAIM_FH to implement regular opens, not just
recovery cases, so it depends on the server to check permissions
correctly.

Therefore the owner override, which may make sense in the delegation
recovery case, isn't right in the CLAIM_FH case.

Symptoms: on a client with 49f9a0fafd844c32f2abada047c0b9a5ba0d6255
"NFSv4.1: Enable open-by-filehandle", Bryan noticed this:

	touch test.txt
	chmod 000 test.txt
	echo test > test.txt

succeeding.

Reported-by: Bryan Schumaker <bjschuma@netapp.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/nfsd/nfs4proc.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index ec668e1..de60696 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -271,6 +271,7 @@ static __be32
 do_open_fhandle(struct svc_rqst *rqstp, struct svc_fh *current_fh, struct nfsd4_open *open)
 {
 	__be32 status;
+	int accmode = 0;
 
 	/* We don't know the target directory, and therefore can not
 	* set the change info
@@ -284,9 +285,19 @@ do_open_fhandle(struct svc_rqst *rqstp, struct svc_fh *current_fh, struct nfsd4_
 
 	open->op_truncate = (open->op_iattr.ia_valid & ATTR_SIZE) &&
 		(open->op_iattr.ia_size == 0);
+	/*
+	 * In the delegation case, the client is telling us about an
+	 * open that it *already* performed locally, some time ago.  We
+	 * should let it succeed now if possible.
+	 *
+	 * In the case of a CLAIM_FH open, on the other hand, the client
+	 * may be counting on us to enforce permissions (the Linux 4.1
+	 * client uses this for normal opens, for example).
+	 */
+	if (open->op_claim_type == NFS4_OPEN_CLAIM_DELEG_CUR_FH)
+		accmode = NFSD_MAY_OWNER_OVERRIDE;
 
-	status = do_open_permission(rqstp, current_fh, open,
-				    NFSD_MAY_OWNER_OVERRIDE);
+	status = do_open_permission(rqstp, current_fh, open, accmode);
 
 	return status;
 }
-- 
1.8.1.2

