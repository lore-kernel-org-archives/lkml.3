Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759741Ab3IHDim (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:38:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56162 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756664Ab3IHDTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:19:21 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Matt Craighead" <mcraighead@nvidia.com>,
        "Trond Myklebust" <Trond.Myklebust@netapp.com>,
        "Mark Young" <MYoung@nvidia.com>,
        "Bruce Fields" <bfields@fieldses.org>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.901404264@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [105/121] SUNRPC: Fix memory corruption issue on 32-bit highmem
 systems
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/sunrpc/xdr.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -233,10 +233,13 @@ _shift_data_right_pages(struct page **pa
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

