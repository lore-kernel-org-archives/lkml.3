Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383AbaJPDgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 23:36:20 -0400
Received: from [42.62.48.242] ([42.62.48.242]:7234 "EHLO manager.mioffice.cn"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750993AbaJPDgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 23:36:17 -0400
From: Hui Zhu <zhuhui@xiaomi.com>
To: <rjw@rjwysocki.net>, <len.brown@intel.com>, <pavel@ucw.cz>,
        <m.szyprowski@samsung.com>, <akpm@linux-foundation.org>,
        <mina86@mina86.com>, <aneesh.kumar@linux.vnet.ibm.com>,
        <iamjoonsoo.kim@lge.com>, <hannes@cmpxchg.org>, <riel@redhat.com>,
        <mgorman@suse.de>, <minchan@kernel.org>, <nasa4836@gmail.com>,
        <ddstreet@ieee.org>, <hughd@google.com>, <mingo@kernel.org>,
        <rientjes@google.com>, <peterz@infradead.org>, <keescook@chromium.org>,
        <atomlin@redhat.com>, <raistlin@linux.it>, <axboe@fb.com>,
        <paulmck@linux.vnet.ibm.com>, <kirill.shutemov@linux.intel.com>,
        <n-horiguchi@ah.jp.nec.com>, <k.khlebnikov@samsung.com>,
        <msalter@redhat.com>, <deller@gmx.de>, <tangchen@cn.fujitsu.com>,
        <ben@decadent.org.uk>, <akinobu.mita@gmail.com>,
        <lauraa@codeaurora.org>, <vbabka@suse.cz>, <sasha.levin@oracle.com>,
        <vdavydov@parallels.com>, <suleiman@google.com>
CC: <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-mm@kvack.org>, Hui Zhu <zhuhui@xiaomi.com>
Subject: [PATCH 1/4] (CMA_AGGRESSIVE) Add CMA_AGGRESSIVE to Kconfig
Date: Thu, 16 Oct 2014 11:35:48 +0800
Message-ID: <1413430551-22392-2-git-send-email-zhuhui@xiaomi.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413430551-22392-1-git-send-email-zhuhui@xiaomi.com>
References: <1413430551-22392-1-git-send-email-zhuhui@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.27.14.101]
X-ClientProxiedBy: CNCAS1.mioffice.cn (10.237.8.131) To cnbox4.mioffice.cn
 (10.237.8.144)
X-EsetResult: clean, is OK
X-EsetId: 587748382C4597170C3011
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add CMA_AGGRESSIVE config that depend on CMA to Linux kernel config.
Add CMA_AGGRESSIVE_PHY_MAX, CMA_AGGRESSIVE_FREE_MIN and CMA_AGGRESSIVE_SHRINK
that depend on CMA_AGGRESSIVE.

If physical memory size (not include CMA memory) in byte less than or equal to
CMA_AGGRESSIVE_PHY_MAX, CMA aggressive switch (sysctl vm.cma-aggressive-switch)
will be opened.

When system boot, this value will set to sysctl "vm.cma-aggressive-free-min".

If this value is true, sysctl "vm.cma-aggressive-shrink-switch" will be set to
true when Linux boot.

Signed-off-by: Hui Zhu <zhuhui@xiaomi.com>
---
 mm/Kconfig | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/mm/Kconfig b/mm/Kconfig
index 1d1ae6b..940f5f3 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -527,6 +527,49 @@ config CMA_AREAS
 
 	  If unsure, leave the default value "7".
 
+config CMA_AGGRESSIVE
+	bool "CMA aggressive"
+	depends on CMA
+	default n
+	help
+	  Be more aggressive about taking memory from CMA when allocate MOVABLE
+	  page.
+	  Sysctl "vm.cma-aggressive-switch", "vm.cma-aggressive-alloc-max"
+	  and "vm.cma-aggressive-shrink-switch" can control this function.
+	  If unsure, say "n".
+
+config CMA_AGGRESSIVE_PHY_MAX
+	hex "Physical memory size in Bytes that auto turn on the CMA aggressive switch"
+	depends on CMA_AGGRESSIVE
+	default 0x40000000
+	help
+	  If physical memory size (not include CMA memory) in byte less than or
+	  equal to this value, CMA aggressive switch will be opened.
+	  After the Linux boot, sysctl "vm.cma-aggressive-switch" can control
+	  the CMA AGGRESSIVE switch.
+
+config CMA_AGGRESSIVE_FREE_MIN
+	int "The minimum free CMA page number that CMA aggressive work"
+	depends on CMA_AGGRESSIVE
+	default 500
+	help
+	  When system boot, this value will set to sysctl
+	  "vm.cma-aggressive-free-min".
+	  If the number of CMA free pages is small than this sysctl value,
+	  CMA aggressive will not work.
+
+config CMA_AGGRESSIVE_SHRINK
+	bool "CMA aggressive shrink"
+	depends on CMA_AGGRESSIVE
+	default y
+	help
+	  If this value is true, sysctl "vm.cma-aggressive-shrink-switch" will
+	  be set to true when Linux boot.
+	  If sysctl "vm.cma-aggressive-shrink-switch" is true and free normal
+	  memory's size is smaller than the size that it want to allocate,
+	  do memory shrink before driver allocate pages from CMA.
+	  If unsure, say "y".
+
 config MEM_SOFT_DIRTY
 	bool "Track memory changes"
 	depends on CHECKPOINT_RESTORE && HAVE_ARCH_SOFT_DIRTY && PROC_FS
-- 
1.9.1

