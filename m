Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933500Ab3LERrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:47:32 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38339 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757356Ab3LERhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:37:46 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "J. Bruce Fields" <bfields@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 62/90] nfsd4: fix xdr decoding of large non-write compounds
Date: Thu,  5 Dec 2013 17:35:44 +0000
Message-Id: <1386264972-5399-63-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5: simply revert 2475008 "nfsd4: fix decoding of
  compounds across page boundaries":
  - adjusted 1st hunk to modify read_buf() instead of next_decode_page()
  - dropped 2nd hunk ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/nfsd/nfs4xdr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 65ed9bf..b2ae2da 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -161,8 +161,8 @@ static __be32 *read_buf(struct nfsd4_compoundargs *argp, u32 nbytes)
 	 */
 	memcpy(p, argp->p, avail);
 	/* step to next page */
-	argp->pagelist++;
 	argp->p = page_address(argp->pagelist[0]);
+	argp->pagelist++;
 	if (argp->pagelen < PAGE_SIZE) {
 		argp->end = argp->p + (argp->pagelen>>2);
 		argp->pagelen = 0;
-- 
1.8.3.2

