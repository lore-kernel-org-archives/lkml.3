Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752539AbaKPWHE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 17:07:04 -0500
Received: from 1wt.eu ([62.212.114.60]:47959 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbaKPWBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 17:01:08 -0500
Message-Id: <20141116215329.855680109@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sun, 16 Nov 2014 22:53:57 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Willy Tarreau <w@1wt.eu>
Subject: [ 29/48] Revert "nfsd: correctly handle return value from
In-Reply-To: <28c765bc23bd4bae1611534e510f49f8@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 nfsd_map_name_to_*"

From: Willy Tarreau <w@1wt.eu>

This reverts commit 63d059e73ff4574b79bd8aa252b5fc00b6326ddf.

On Wed, Sep 03, 2014 at 11:28:43AM +1000, NeilBrown wrote:
>
> 2.6.32.30 contains:
>
> commit 63d059e73ff4574b79bd8aa252b5fc00b6326ddf
> Author: NeilBrown <neilb@suse.de>
> Date:   Wed Feb 16 13:08:35 2011 +1100
>
>     nfsd: correctly handle return value from nfsd_map_name_to_*
>
>     commit 47c85291d3dd1a51501555000b90f8e281a0458e upstream.
>
>     These functions return an nfs status, not a host_err.  So don't
>     try to convert  before returning.
>
>     This is a regression introduced by
>     3c726023402a2f3b28f49b9d90ebf9e71151157d; I fixed up two of the callers,
>     but missed these two.
>
>     Reported-by: Herbert Poetzl <herbert@13thfloor.at>
>     Signed-off-by: NeilBrown <neilb@suse.de>
>     Signed-off-by: J. Bruce Fields <bfields@redhat.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
>
> But it does *not* contain a backport of
> 3c726023402a2f3b28f49b9d90ebf9e71151157d.
>
> So rather an fixing a regression, it introduces one.
>
> This patch should be reverted.
>
> See also https://bugzilla.novell.com/show_bug.cgi?id=893787
>
> NeilBrown
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/nfsd/nfs4xdr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index ab87b05..05990b6 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -323,8 +323,8 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 		READ_BUF(dummy32);
 		len += (XDR_QUADLEN(dummy32) << 2);
 		READMEM(buf, dummy32);
-		if ((status = nfsd_map_name_to_uid(argp->rqstp, buf, dummy32, &iattr->ia_uid)))
-			return status;
+		if ((host_err = nfsd_map_name_to_uid(argp->rqstp, buf, dummy32, &iattr->ia_uid)))
+			goto out_nfserr;
 		iattr->ia_valid |= ATTR_UID;
 	}
 	if (bmval[1] & FATTR4_WORD1_OWNER_GROUP) {
@@ -334,8 +334,8 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 		READ_BUF(dummy32);
 		len += (XDR_QUADLEN(dummy32) << 2);
 		READMEM(buf, dummy32);
-		if ((status = nfsd_map_name_to_gid(argp->rqstp, buf, dummy32, &iattr->ia_gid)))
-			return status;
+		if ((host_err = nfsd_map_name_to_gid(argp->rqstp, buf, dummy32, &iattr->ia_gid)))
+			goto out_nfserr;
 		iattr->ia_valid |= ATTR_GID;
 	}
 	if (bmval[1] & FATTR4_WORD1_TIME_ACCESS_SET) {
-- 
1.7.12.2.21.g234cd45.dirty



