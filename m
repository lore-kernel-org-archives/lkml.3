Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933628AbaJDA0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:26:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45325 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968AbaJCVnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:43:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 3.16 155/357] nfsd4: fix rd_dircount enforcement
Date: Fri,  3 Oct 2014 14:29:01 -0700
Message-Id: <20141003212938.124166492@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit aee3776441461c14ba6d8ed9e2149933e65abb6e upstream.

Commit 3b299709091b "nfsd4: enforce rd_dircount" totally misunderstood
rd_dircount; it refers to total non-attribute bytes returned, not number
of directory entries returned.

Bring the code into agreement with RFC 3530 section 14.2.24.

Fixes: 3b299709091b "nfsd4: enforce rd_dircount"
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4xdr.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2662,6 +2662,7 @@ nfsd4_encode_dirent(void *ccdv, const ch
 	struct xdr_stream *xdr = cd->xdr;
 	int start_offset = xdr->buf->len;
 	int cookie_offset;
+	u32 name_and_cookie;
 	int entry_bytes;
 	__be32 nfserr = nfserr_toosmall;
 	__be64 wire_offset;
@@ -2723,7 +2724,14 @@ nfsd4_encode_dirent(void *ccdv, const ch
 	cd->rd_maxcount -= entry_bytes;
 	if (!cd->rd_dircount)
 		goto fail;
-	cd->rd_dircount--;
+	/*
+	 * RFC 3530 14.2.24 describes rd_dircount as only a "hint", so
+	 * let's always let through the first entry, at least:
+	 */
+	name_and_cookie = 4 * XDR_QUADLEN(namlen) + 8;
+	if (name_and_cookie > cd->rd_dircount && cd->cookie_offset)
+		goto fail;
+	cd->rd_dircount -= min(cd->rd_dircount, name_and_cookie);
 	cd->cookie_offset = cookie_offset;
 skip_entry:
 	cd->common.err = nfs_ok;
@@ -3333,6 +3341,10 @@ nfsd4_encode_readdir(struct nfsd4_compou
 	}
 	maxcount = min_t(int, maxcount-16, bytes_left);
 
+	/* RFC 3530 14.2.24 allows us to ignore dircount when it's 0: */
+	if (!readdir->rd_dircount)
+		readdir->rd_dircount = INT_MAX;
+
 	readdir->xdr = xdr;
 	readdir->rd_maxcount = maxcount;
 	readdir->common.err = 0;


