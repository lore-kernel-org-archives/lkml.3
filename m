Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333Ab3E1Dzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:55:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52493 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758790Ab3E1DyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:54:16 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Bryan Schumaker" <bjschuma@netapp.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Date: Tue, 28 May 2013 04:49:53 +0100
Message-ID: <lsq.1369712993.372500701@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [09/94] nfsd4: don't allow owner override on 4.1 CLAIM_FH opens
In-Reply-To: <lsq.1369712992.755341692@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.46-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfsd/nfs4proc.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -267,6 +267,7 @@ static __be32
 do_open_fhandle(struct svc_rqst *rqstp, struct svc_fh *current_fh, struct nfsd4_open *open)
 {
 	__be32 status;
+	int accmode = 0;
 
 	/* Only reclaims from previously confirmed clients are valid */
 	if ((status = nfs4_check_open_reclaim(&open->op_clientid)))
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

