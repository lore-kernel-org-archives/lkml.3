Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057Ab3IKKIH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 06:08:07 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:28826 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752136Ab3IKKFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 06:05:22 -0400
X-IronPort-AV: E=Sophos;i="4.90,883,1371052800"; 
   d="scan'208";a="8489689"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: tj@kernel.org, rjw@sisk.pl, lenb@kernel.org, tglx@linutronix.de,
        mingo@elte.hu, hpa@zytor.com, akpm@linux-foundation.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, toshi.kani@hp.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: [PATCH v2 3/9] x86, dma: Support allocate memory from bottom upwards in dma_contiguous_reserve().
Date: Wed, 11 Sep 2013 18:07:31 +0800
Message-Id: <1378894057-30946-4-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1378894057-30946-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1378894057-30946-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/11 18:02:50,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/11 18:02:57,
	Serialize complete at 2013/09/11 18:02:57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During early boot, if the bottom up mode is set, just
try allocating bottom up from the end of kernel image,
and if that fails, do normal top down allocation.

So in function dma_contiguous_reserve(), we add the
above logic.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 drivers/base/dma-contiguous.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
index 6c9cdaa..3b4e031 100644
--- a/drivers/base/dma-contiguous.c
+++ b/drivers/base/dma-contiguous.c
@@ -260,17 +260,28 @@ int __init dma_declare_contiguous(struct device *dev, phys_addr_t size,
 			goto err;
 		}
 	} else {
+		phys_addr_t addr;
+
+		if (memblock_direction_bottom_up()) {
+			addr = memblock_alloc_bottom_up(
+						MEMBLOCK_ALLOC_ACCESSIBLE,
+						limit, size, alignment);
+			if (addr)
+				goto success;
+		}
+
 		/*
 		 * Use __memblock_alloc_base() since
 		 * memblock_alloc_base() panic()s.
 		 */
-		phys_addr_t addr = __memblock_alloc_base(size, alignment, limit);
+		addr = __memblock_alloc_base(size, alignment, limit);
 		if (!addr) {
 			base = -ENOMEM;
 			goto err;
-		} else {
-			base = addr;
 		}
+
+success:
+		base = addr;
 	}
 
 	/*
-- 
1.7.1

