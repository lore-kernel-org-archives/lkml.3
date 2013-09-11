Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993Ab3IKE5e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:57:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011Ab3IKE4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:56:47 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=K1To-U8uYu4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=P_mcBTHB8mkA:10 a=JDjsHSkAAAAA:8 a=Ikd4Dj_1AAAA:8 a=mJjC6ScEAAAA:8 a=VwQbUJbxAAAA:8 a=nbw4QO9JrEnshcIXSTQA:9 a=Hf6muOzgCGQA:10 a=B7-YBXcGuVcA:10 a=2NEUOfxDfW4A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042933.906336826@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:31:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mark Young <MYoung@nvidia.com>, Matt Craighead <mcraighead@nvidia.com>,
        Bruce Fields <bfields@fieldses.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [248/251] SUNRPC: Fix memory corruption issue on 32-bit highmem systems
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0248-SUNRPC-Fix-memory-corruption-issue-on-32-bit-highmem.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

[ Upstream commit 347e2233b7667e336d9f671f1a52dfa3f0416e2c ]

Some architectures, such as ARM-32 do not return the same base address
when you call kmap_atomic() twice on the same page.
This causes problems for the memmove() call in the XDR helper routine
"_shift_data_right_pages()", since it defeats the detection of
overlapping memory ranges, and has been seen to corrupt memory.

The fix is to distinguish between the case where we're doing an
inter-page copy or not. In the former case of we know that the memory
ranges cannot possibly overlap, so we can additionally micro-optimise
by replacing memmove() with memcpy().

Reported-by: Mark Young <MYoung@nvidia.com>
Reported-by: Matt Craighead <mcraighead@nvidia.com>
Cc: Bruce Fields <bfields@fieldses.org>
Cc: stable@vger.kernel.org
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Tested-by: Matt Craighead <mcraighead@nvidia.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/sunrpc/xdr.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/sunrpc/xdr.c b/net/sunrpc/xdr.c
index 0afba1b..7e99acd 100644
--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -207,10 +207,13 @@ _shift_data_right_pages(struct page **pages, size_t pgto_base,
 		pgfrom_base -= copy;
 
 		vto = kmap_atomic(*pgto);
-		vfrom = kmap_atomic(*pgfrom);
-		memmove(vto + pgto_base, vfrom + pgfrom_base, copy);
+		if (*pgto != *pgfrom) {
+			vfrom = kmap_atomic(*pgfrom);
+			memcpy(vto + pgto_base, vfrom + pgfrom_base, copy);
+			kunmap_atomic(vfrom);
+		} else
+			memmove(vto + pgto_base, vto + pgfrom_base, copy);
 		flush_dcache_page(*pgto);
-		kunmap_atomic(vfrom);
 		kunmap_atomic(vto);
 
 	} while ((len -= copy) != 0);
-- 
1.7.10.4


