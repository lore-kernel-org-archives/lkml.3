Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab3J3KTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 06:19:00 -0400
Received: from multi.imgtec.com ([194.200.65.239]:11972 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753Ab3J3KS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 06:18:59 -0400
From: James Hogan <james.hogan@imgtec.com>
To: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-next@vger.kernel.org>,
        James Hogan <james.hogan@imgtec.com>, <linux-metag@vger.kernel.org>
Subject: [RFC PATCH -next] Fix printk_once build errors due to __read_mostly
Date: Wed, 30 Oct 2013 10:18:21 +0000
Message-ID: <1383128301-20231-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_10_30_10_18_56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 3e39c1ab04ba (printk: mark printk_once test variable
__read_mostly) added __read_mostly to the __print_once bool in the
printk_once() macro, but __read_mostly is defined in <linux/cache.h>
which isn't included from <linux/printk.h>. This results in build errors
like this:

arch/metag/mm/l2cache.c: In function 'meta_l2c_setup':
arch/metag/mm/l2cache.c:56: error: '__read_mostly' undeclared

This is fixed by adding an include of <linux/cache.h> from
<linux/printk.h> since I don't think printk_once() users should need to
include <linux/cache.h> for it to work.

Note that this actually adds a recursive include, since <linux/cache.h>
includes <linux/kernel.h>, which includes <linux/printk.h>. The actual
dependencies are all in macros so it doesn't actually seem to result in
any build failures, but it's clearly less than ideal.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-metag@vger.kernel.org
---
This build failure was caught in today's linux-next.

I'm not too keen on this due to the recursive include. Is it better to
just workaround the problem by including <linux/cache.h> from the .c
file that fails to build, or should the original patch be removed
instead?

 include/linux/printk.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index abd42dd..b13d00e 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -2,6 +2,7 @@
 #define __KERNEL_PRINTK__
 
 #include <stdarg.h>
+#include <linux/cache.h>
 #include <linux/init.h>
 #include <linux/kern_levels.h>
 #include <linux/linkage.h>
-- 
1.8.1.2


