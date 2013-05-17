Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443Ab3EQWXH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:23:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54059 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756885Ab3EQVhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bryan Schumaker <bjschuma@netapp.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [ 024/102] nfsd4: dont allow owner override on 4.1 CLAIM_FH opens
Date: Fri, 17 May 2013 14:35:39 -0700
Message-Id: <20130517213246.933001307@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4proc.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -271,6 +271,7 @@ static __be32
 do_open_fhandle(struct svc_rqst *rqstp, struct svc_fh *current_fh, struct nfsd4_open *open)
 {
 	__be32 status;
+	int accmode = 0;
 
 	/* We don't know the target directory, and therefore can not
 	* set the change info
@@ -284,9 +285,19 @@ do_open_fhandle(struct svc_rqst *rqstp,
 
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


