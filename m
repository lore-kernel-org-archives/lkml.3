Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab3L2CgR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:36:17 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55465 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752985Ab3L2CKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:44 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "J. Bruce Fields" <bfields@redhat.com>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.900042915@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 074/185] nfsd4: fix xdr decoding of large non-write
 compounds
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit 365da4adebb1c012febf81019ad3dc5bb52e2a13 upstream.

This fixes a regression from 247500820ebd02ad87525db5d9b199e5b66f6636
"nfsd4: fix decoding of compounds across page boundaries".  The previous
code was correct: argp->pagelist is initialized in
nfs4svc_deocde_compoundargs to rqstp->rq_arg.pages, and is therefore a
pointer to the page *after* the page we are currently decoding.

The reason that patch nevertheless fixed a problem with decoding
compounds containing write was a bug in the write decoding introduced by
5a80a54d21c96590d013378d8c5f65f879451ab4 "nfsd4: reorganize write
decoding", after which write decoding no longer adhered to the rule that
argp->pagelist point to the next page.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
[bwh: Backported to 3.2: adjust context; there is only one instance to fix]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfsd/nfs4xdr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -177,8 +177,8 @@ static __be32 *read_buf(struct nfsd4_com
 	 */
 	memcpy(p, argp->p, avail);
 	/* step to next page */
-	argp->pagelist++;
 	argp->p = page_address(argp->pagelist[0]);
+	argp->pagelist++;
 	if (argp->pagelen < PAGE_SIZE) {
 		argp->end = argp->p + (argp->pagelen>>2);
 		argp->pagelen = 0;

