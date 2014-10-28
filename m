Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707AbaJ1HSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:18:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45217 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbaJ1Dn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:43:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kinglong Mee <kinglongmee@gmail.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 3.16 053/127] nfsd4: reserve adequate space for LOCK op
Date: Tue, 28 Oct 2014 11:34:48 +0800
Message-Id: <20141028033423.208932070@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033420.925922046@linuxfoundation.org>
References: <20141028033420.925922046@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "J. Bruce Fields" <bfields@redhat.com>

commit f7b43d0c992c3ec3e8d9285c3fb5e1e0eb0d031a upstream.

As of  8c7424cff6 "nfsd4: don't try to encode conflicting owner if low
on space", we permit the server to process a LOCK operation even if
there might not be space to return the conflicting lockowner, because
we've made returning the conflicting lockowner optional.

However, the rpc server still wants to know the most we might possibly
return, so we need to take into account the possible conflicting
lockowner in the svc_reserve_space() call here.

Symptoms were log messages like "RPC request reserved 88 but used 108".

Fixes: 8c7424cff6 "nfsd4: don't try to encode conflicting owner if low on space"
Reported-by: Kinglong Mee <kinglongmee@gmail.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfs4xdr.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -1675,6 +1675,14 @@ nfsd4_decode_compound(struct nfsd4_compo
 			readbytes += nfsd4_max_reply(argp->rqstp, op);
 		} else
 			max_reply += nfsd4_max_reply(argp->rqstp, op);
+		/*
+		 * OP_LOCK may return a conflicting lock.  (Special case
+		 * because it will just skip encoding this if it runs
+		 * out of xdr buffer space, and it is the only operation
+		 * that behaves this way.)
+		 */
+		if (op->opnum == OP_LOCK)
+			max_reply += NFS4_OPAQUE_LIMIT;
 
 		if (op->status) {
 			argp->opcnt = i+1;


