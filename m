Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947157Ab3BHVDK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 16:03:10 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:51926 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947057Ab3BHVDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 16:03:08 -0500
Date: Fri, 8 Feb 2013 13:03:03 -0800
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 4/6] idr: make idr_layer larger
Message-ID: <20130208210303.GD26660@mtj.dyndns.org>
References: <20130208210050.GA26660@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130208210050.GA26660@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With recent preloading changes, idr no longer keeps full layer cache
per each idr instance (used to be ~6.5k per idr on 64bit) and the
previous patch removed restriction on the bitmap size.  Both now allow
us to have larger layers.

Increase IDR_BITS to 8 regardless of BITS_PER_LONG.  Each layer is
slightly larger than 2k on 64bit and 1k on 32bit and carries 256
entries.  The size isn't too large, especially compared to what we
used to waste on per-idr caches, and 256 entries should be able to
serve most use cases with single layer.  The max tree depth is 4 which
is much better than the previous 6 on 64bit and 7 on 32bit.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/idr.h |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -17,14 +17,13 @@
 #include <linux/init.h>
 #include <linux/rcupdate.h>
 
-#if BITS_PER_LONG == 32
-# define IDR_BITS 5
-#elif BITS_PER_LONG == 64
-# define IDR_BITS 6
-#else
-# error "BITS_PER_LONG is not 32 or 64"
-#endif
-
+/*
+ * We want shallower trees and thus more bits covered at each layer.  8
+ * bits gives us large enough first layer for most use cases and maximum
+ * tree depth of 4.  Each idr_layer is slightly larger than 2k on 64bit and
+ * 1k on 32bit.
+ */
+#define IDR_BITS 8
 #define IDR_SIZE (1 << IDR_BITS)
 #define IDR_MASK ((1 << IDR_BITS)-1)
 
