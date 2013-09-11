Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab3IKKF2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 06:05:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:42177 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753238Ab3IKKFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 06:05:24 -0400
X-IronPort-AV: E=Sophos;i="4.90,883,1371052800"; 
   d="scan'208";a="8489693"
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
Subject: [PATCH v2 6/9] x86, acpi: Support allocate memory from bottom upwards in acpi_initrd_override().
Date: Wed, 11 Sep 2013 18:07:34 +0800
Message-Id: <1378894057-30946-7-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1378894057-30946-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1378894057-30946-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/11 18:02:51,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/11 18:02:58,
	Serialize complete at 2013/09/11 18:02:58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During early boot, if the bottom up mode is set, just
try allocating bottom up from the end of kernel image,
and if that fails, do normal top down allocation.

So in function acpi_initrd_override(), we add the
above logic.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 drivers/acpi/osl.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index e5f416c..978dcfa 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -632,6 +632,15 @@ void __init acpi_initrd_override(void *data, size_t size)
 	if (table_nr == 0)
 		return;
 
+	if (memblock_direction_bottom_up()) {
+		acpi_tables_addr = memblock_alloc_bottom_up(
+					MEMBLOCK_ALLOC_ACCESSIBLE,
+					max_low_pfn_mapped << PAGE_SHIFT,
+					all_tables_size, PAGE_SIZE);
+		if (acpi_tables_addr)
+			goto success;
+	}
+
 	acpi_tables_addr =
 		memblock_find_in_range(0, max_low_pfn_mapped << PAGE_SHIFT,
 				       all_tables_size, PAGE_SIZE);
@@ -639,6 +648,8 @@ void __init acpi_initrd_override(void *data, size_t size)
 		WARN_ON(1);
 		return;
 	}
+
+success:
 	/*
 	 * Only calling e820_add_reserve does not work and the
 	 * tables are invalid (memory got used) later.
-- 
1.7.1

