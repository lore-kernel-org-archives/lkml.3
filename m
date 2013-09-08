Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759961Ab3IHDmY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:42:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56038 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757154Ab3IHDTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:19:15 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Cong Wang" <amwang@redhat.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.232612349@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [104/121] sunrpc: remove the second argument of k[un]map_atomic()
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <amwang@redhat.com>

commit b85417860172ff693dc115d7999805fc240cec1c upstream.

Signed-off-by: Cong Wang <amwang@redhat.com>
[bwh: Cherry-picked for 3.2 to let the next fix apply cleanly]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sunrpc/auth_gss/gss_krb5_wrap.c |  4 ++--
 net/sunrpc/socklib.c                |  4 ++--
 net/sunrpc/xdr.c                    | 20 ++++++++++----------
 net/sunrpc/xprtrdma/rpc_rdma.c      |  8 ++++----
 4 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/net/sunrpc/auth_gss/gss_krb5_wrap.c b/net/sunrpc/auth_gss/gss_krb5_wrap.c
index 2763e3e..38f388c 100644
--- a/net/sunrpc/auth_gss/gss_krb5_wrap.c
+++ b/net/sunrpc/auth_gss/gss_krb5_wrap.c
@@ -82,9 +82,9 @@ gss_krb5_remove_padding(struct xdr_buf *buf, int blocksize)
 					>>PAGE_CACHE_SHIFT;
 		unsigned int offset = (buf->page_base + len - 1)
 					& (PAGE_CACHE_SIZE - 1);
-		ptr = kmap_atomic(buf->pages[last], KM_USER0);
+		ptr = kmap_atomic(buf->pages[last]);
 		pad = *(ptr + offset);
-		kunmap_atomic(ptr, KM_USER0);
+		kunmap_atomic(ptr);
 		goto out;
 	} else
 		len -= buf->page_len;
diff --git a/net/sunrpc/socklib.c b/net/sunrpc/socklib.c
index 145e6784..0a648c5 100644
--- a/net/sunrpc/socklib.c
+++ b/net/sunrpc/socklib.c
@@ -114,7 +114,7 @@ ssize_t xdr_partial_copy_from_skb(struct xdr_buf *xdr, unsigned int base, struct
 		}
 
 		len = PAGE_CACHE_SIZE;
-		kaddr = kmap_atomic(*ppage, KM_SKB_SUNRPC_DATA);
+		kaddr = kmap_atomic(*ppage);
 		if (base) {
 			len -= base;
 			if (pglen < len)
@@ -127,7 +127,7 @@ ssize_t xdr_partial_copy_from_skb(struct xdr_buf *xdr, unsigned int base, struct
 			ret = copy_actor(desc, kaddr, len);
 		}
 		flush_dcache_page(*ppage);
-		kunmap_atomic(kaddr, KM_SKB_SUNRPC_DATA);
+		kunmap_atomic(kaddr);
 		copied += ret;
 		if (ret != len || !desc->count)
 			goto out;
diff --git a/net/sunrpc/xdr.c b/net/sunrpc/xdr.c
index 593f4c6..b97a3dd 100644
--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -122,9 +122,9 @@ xdr_terminate_string(struct xdr_buf *buf, const u32 len)
 {
 	char *kaddr;
 
-	kaddr = kmap_atomic(buf->pages[0], KM_USER0);
+	kaddr = kmap_atomic(buf->pages[0]);
 	kaddr[buf->page_base + len] = '\0';
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 }
 EXPORT_SYMBOL_GPL(xdr_terminate_string);
 
@@ -232,12 +232,12 @@ _shift_data_right_pages(struct page **pages, size_t pgto_base,
 		pgto_base -= copy;
 		pgfrom_base -= copy;
 
-		vto = kmap_atomic(*pgto, KM_USER0);
-		vfrom = kmap_atomic(*pgfrom, KM_USER1);
+		vto = kmap_atomic(*pgto);
+		vfrom = kmap_atomic(*pgfrom);
 		memmove(vto + pgto_base, vfrom + pgfrom_base, copy);
 		flush_dcache_page(*pgto);
-		kunmap_atomic(vfrom, KM_USER1);
-		kunmap_atomic(vto, KM_USER0);
+		kunmap_atomic(vfrom);
+		kunmap_atomic(vto);
 
 	} while ((len -= copy) != 0);
 }
@@ -267,9 +267,9 @@ _copy_to_pages(struct page **pages, size_t pgbase, const char *p, size_t len)
 		if (copy > len)
 			copy = len;
 
-		vto = kmap_atomic(*pgto, KM_USER0);
+		vto = kmap_atomic(*pgto);
 		memcpy(vto + pgbase, p, copy);
-		kunmap_atomic(vto, KM_USER0);
+		kunmap_atomic(vto);
 
 		len -= copy;
 		if (len == 0)
@@ -311,9 +311,9 @@ _copy_from_pages(char *p, struct page **pages, size_t pgbase, size_t len)
 		if (copy > len)
 			copy = len;
 
-		vfrom = kmap_atomic(*pgfrom, KM_USER0);
+		vfrom = kmap_atomic(*pgfrom);
 		memcpy(p, vfrom + pgbase, copy);
-		kunmap_atomic(vfrom, KM_USER0);
+		kunmap_atomic(vfrom);
 
 		pgbase += copy;
 		if (pgbase == PAGE_CACHE_SIZE) {
diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index 554d081..1776e57 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -338,9 +338,9 @@ rpcrdma_inline_pullup(struct rpc_rqst *rqst, int pad)
 			curlen = copy_len;
 		dprintk("RPC:       %s: page %d destp 0x%p len %d curlen %d\n",
 			__func__, i, destp, copy_len, curlen);
-		srcp = kmap_atomic(ppages[i], KM_SKB_SUNRPC_DATA);
+		srcp = kmap_atomic(ppages[i]);
 		memcpy(destp, srcp+page_base, curlen);
-		kunmap_atomic(srcp, KM_SKB_SUNRPC_DATA);
+		kunmap_atomic(srcp);
 		rqst->rq_svec[0].iov_len += curlen;
 		destp += curlen;
 		copy_len -= curlen;
@@ -639,10 +639,10 @@ rpcrdma_inline_fixup(struct rpc_rqst *rqst, char *srcp, int copy_len, int pad)
 			dprintk("RPC:       %s: page %d"
 				" srcp 0x%p len %d curlen %d\n",
 				__func__, i, srcp, copy_len, curlen);
-			destp = kmap_atomic(ppages[i], KM_SKB_SUNRPC_DATA);
+			destp = kmap_atomic(ppages[i]);
 			memcpy(destp + page_base, srcp, curlen);
 			flush_dcache_page(ppages[i]);
-			kunmap_atomic(destp, KM_SKB_SUNRPC_DATA);
+			kunmap_atomic(destp);
 			srcp += curlen;
 			copy_len -= curlen;
 			if (copy_len == 0)

