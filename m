Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583AbaJ2Sgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 14:36:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:47050 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756493AbaJ2Sgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 14:36:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,278,1413270000"; 
   d="scan'208";a="613605847"
Subject: [RFC PATCH 1/5] block, ioprio: include caching advice via ionice
From: "Jason B. Akers" <jason.b.akers@intel.com>
To: linux-ide@vger.kernel.org
Cc: axboe@fb.com, kapil.karkra@intel.com, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org
Date: Wed, 29 Oct 2014 11:23:45 -0700
Message-ID: <20141029182345.4879.98373.stgit@stg-AndroidDev-VirtualBox>
In-Reply-To: <20141029180454.4879.75088.stgit@stg-AndroidDev-VirtualBox>
References: <20141029180454.4879.75088.stgit@stg-AndroidDev-VirtualBox>
User-Agent: StGit/0.17.1-4-g4a0c1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>

Steal one unused bit from the priority class and two bits from the
priority data, to implement a 3 bit cache-advice field.  Similar to the
page cache advice from fadvise() these hints are meant to be consumed
by hybrid drives.  Solid State Hyrbid-Drives, as defined by the SATA-IO
Specification, implement up to a 4-bit cache priority that can be
specified along with a FPDMA command.

	IOPRIO_ADV_NONE: default if ionice hint is not provided

	IOPRIO_ADV_EVICT: indicate that if the lba's associated with
			this command are in the cache, write them back
			and invalidate.
	IOPRIO_ADV_DONTNEED: caching this data has little value, but no
	need to actively evict

	IOPRIO_ADV_NORMAL: perform best-effort / device-default caching

	IOPRIO_ADV_RESERVED1: reserved for future use, potentially
	IOPRIO_ADV_RESERVED2: permit the kernel to use these for
	IOPRIO_ADV_RESERVED3: internal cache priorities, but userspace
				owns highest priority override

	IOPRIO_ADV_WILLNEED: cache this data at the highest possible priority

The expectation is that a table in the driver is responsible for
translating this advice into transport/device specific priority value.

Signed-off-by: Kapil Karkra <kapil.karkra@intel.com>
Signed-off-by: Jason B. Akers <jason.b.akers@intel.com>
---
 include/linux/ioprio.h |   32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/include/linux/ioprio.h b/include/linux/ioprio.h
index beb9ce1..752813d 100644
--- a/include/linux/ioprio.h
+++ b/include/linux/ioprio.h
@@ -5,17 +5,27 @@
 #include <linux/iocontext.h>
 
 /*
- * Gives us 8 prio classes with 13-bits of data for each class
+ * Gives us 4 prio classes with 11-bits of data for each class
+ * ...additionally a prio can indicate one of 7 cacheability hints
  */
 #define IOPRIO_BITS		(16)
+#define IOPRIO_CACHE_SHIFT	(15) /* msb of the cache-advice mask */
 #define IOPRIO_CLASS_SHIFT	(13)
-#define IOPRIO_PRIO_MASK	((1UL << IOPRIO_CLASS_SHIFT) - 1)
+#define IOPRIO_ADV_SHIFT	(11)
+#define IOPRIO_PRIO_MASK	((1UL << IOPRIO_ADV_SHIFT) - 1)
 
-#define IOPRIO_PRIO_CLASS(mask)	((mask) >> IOPRIO_CLASS_SHIFT)
+#define IOPRIO_PRIO_CLASS(mask)	(((mask) >> IOPRIO_CLASS_SHIFT) & 3)
 #define IOPRIO_PRIO_DATA(mask)	((mask) & IOPRIO_PRIO_MASK)
+#define IOPRIO_ADVICE(mask)     ((((mask) >> IOPRIO_ADV_SHIFT) & 3) | \
+				(((mask) >> IOPRIO_CACHE_SHIFT & 1) << 2))
 #define IOPRIO_PRIO_VALUE(class, data)	(((class) << IOPRIO_CLASS_SHIFT) | data)
+#define IOPRIO_ADVISE(class, data, advice) \
+	((IOPRIO_PRIO_VALUE(class, data) | ((advice) & 3) << IOPRIO_ADV_SHIFT)\
+	| (((advice) & 4)  << (IOPRIO_CACHE_SHIFT - 2)))
 
-#define ioprio_valid(mask)	(IOPRIO_PRIO_CLASS((mask)) != IOPRIO_CLASS_NONE)
+#define ioprio_valid(mask)	(IOPRIO_PRIO_CLASS((mask)) != \
+						IOPRIO_CLASS_NONE)
+#define ioprio_advice_valid(mask) (IOPRIO_ADVICE(mask) != IOPRIO_ADV_NONE)
 
 /*
  * These are the io priority groups as implemented by CFQ. RT is the realtime
@@ -31,6 +41,20 @@ enum {
 };
 
 /*
+ * Four cacheability hints that map to their fadvise(2) equivalents
+ */
+enum {
+	IOPRIO_ADV_NONE,
+	IOPRIO_ADV_EVICT, /* actively discard cached data */
+	IOPRIO_ADV_DONTNEED, /* caching this data has little value */
+	IOPRIO_ADV_NORMAL, /* best-effort / device-default cache priority */
+	IOPRIO_ADV_RESERVED1, /* reserved for future use */
+	IOPRIO_ADV_RESERVED2,
+	IOPRIO_ADV_RESERVED3,
+	IOPRIO_ADV_WILLNEED, /* high temporal locality or cache valuable */
+};
+
+/*
  * 8 best effort priority levels are supported
  */
 #define IOPRIO_BE_NR	(8)

