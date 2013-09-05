Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920Ab3IEUdM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 16:33:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52195 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757543Ab3IEU2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 16:28:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mark Young <MYoung@nvidia.com>, Matt Craighead <mcraighead@nvidia.com>,
        Bruce Fields <bfields@fieldses.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [ 09/14] SUNRPC: Fix memory corruption issue on 32-bit highmem systems
Date: Thu,  5 Sep 2013 13:28:20 -0700
Message-Id: <20130905202615.503113715@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130905202614.354156084@linuxfoundation.org>
References: <20130905202614.354156084@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/xdr.c |    9 ++++++---
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


