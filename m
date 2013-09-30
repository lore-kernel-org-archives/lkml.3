Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab3I3KLw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 06:11:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43351 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab3I3KLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 06:11:38 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bruce Fields <bfields@fieldses.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 004/104] SUNRPC: Fix memory corruption issue on 32-bit highmem systems
Date: Mon, 30 Sep 2013 11:09:41 +0100
Message-Id: <1380535881-9239-5-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
References: <1380535881-9239-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <Trond.Myklebust@netapp.com>

commit 347e2233b7667e336d9f671f1a52dfa3f0416e2c upstream.

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
Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
Tested-by: Matt Craighead <mcraighead@nvidia.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/sunrpc/xdr.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/sunrpc/xdr.c b/net/sunrpc/xdr.c
index fddcccf..78ad0f6 100644
--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -233,10 +233,13 @@ _shift_data_right_pages(struct page **pages, size_t pgto_base,
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
1.8.3.2

