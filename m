Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013Ab3FTIMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 04:12:42 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:49293 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353Ab3FTIMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 04:12:38 -0400
Date: Thu, 20 Jun 2013 11:12:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Imre Deak <imre.deak@intel.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [patch] lib/scatterlist: error handling in __sg_alloc_table()
Message-ID: <20130620081218.GC15095@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was reviewing code which I suspected might allocate a zero size SG
table.  That will cause memory corruption.  Also we can't return before
doing the memset or we could end up using uninitialized memory in the
cleanup path.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index a1cf8ca..d39178b 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -247,13 +247,15 @@ int __sg_alloc_table(struct sg_table *table, unsigned int nents,
 	struct scatterlist *sg, *prv;
 	unsigned int left;
 
+	memset(table, 0, sizeof(*table));
+
+	if (nents == 0)
+		return -EINVAL;
 #ifndef ARCH_HAS_SG_CHAIN
 	if (WARN_ON_ONCE(nents > max_ents))
 		return -EINVAL;
 #endif
 
-	memset(table, 0, sizeof(*table));
-
 	left = nents;
 	prv = NULL;
 	do {
