Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab3IKKHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 06:07:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:42177 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752785Ab3IKKFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 06:05:22 -0400
X-IronPort-AV: E=Sophos;i="4.90,883,1371052800"; 
   d="scan'208";a="8489690"
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
Subject: [PATCH v2 4/9] x86: Support allocate memory from bottom upwards in setup_log_buf().
Date: Wed, 11 Sep 2013 18:07:32 +0800
Message-Id: <1378894057-30946-5-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1378894057-30946-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1378894057-30946-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/11 18:02:51,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/11 18:02:57,
	Serialize complete at 2013/09/11 18:02:57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During early boot, if the bottom up mode is set, just
try allocating bottom up from the end of kernel image,
and if that fails, do normal top down allocation.

So in function setup_log_buf(), we add the above logic.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
---
 kernel/printk/printk.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index b4e8500..2958118 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -759,9 +759,20 @@ void __init setup_log_buf(int early)
 	if (early) {
 		unsigned long mem;
 
+		if (memblock_direction_bottom_up()) {
+			mem = memblock_alloc_bottom_up(
+						MEMBLOCK_ALLOC_ACCESSIBLE,
+						MEMBLOCK_ALLOC_ACCESSIBLE,
+						new_log_buf_len, PAGE_SIZE);
+			if (mem)
+				goto success;
+		}
+
 		mem = memblock_alloc(new_log_buf_len, PAGE_SIZE);
 		if (!mem)
 			return;
+
+success:
 		new_log_buf = __va(mem);
 	} else {
 		new_log_buf = alloc_bootmem_nopanic(new_log_buf_len);
-- 
1.7.1

