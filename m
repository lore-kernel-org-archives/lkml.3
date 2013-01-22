Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab3AVLs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 06:48:57 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:39067 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752894Ab3AVLqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 06:46:52 -0500
X-IronPort-AV: E=Sophos;i="4.84,514,1355068800"; 
   d="scan'208";a="6628486"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: akpm@linux-foundation.org, rjw@sisk.pl, len.brown@intel.com,
        mingo@redhat.com, tglx@linutronix.de, minchan.kim@gmail.com,
        rientjes@google.com, benh@kernel.crashing.org, paulus@samba.org,
        cl@linux.com, kosaki.motohiro@jp.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, wujianguo@huawei.com,
        wency@cn.fujitsu.com, hpa@zytor.com, linfeng@cn.fujitsu.com,
        laijs@cn.fujitsu.com, mgorman@suse.de, yinghai@kernel.org,
        glommer@parallels.com, jiang.liu@huawei.com, julian.calaby@gmail.com,
        sfr@canb.auug.org.au
Cc: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH Bug fix 3/5] cpu-hotplug, memory-hotplug: try offline the node when hotremoving a cpu
Date: Tue, 22 Jan 2013 19:45:54 +0800
Message-Id: <1358855156-6126-4-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1358855156-6126-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1358855156-6126-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/22 19:45:51,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/22 19:45:53,
	Serialize complete at 2013/01/22 19:45:53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wen Congyang <wency@cn.fujitsu.com>

The node will be offlined when all memory/cpu on the node is hotremoved.
So we should try offline the node when hotremoving a cpu on the node.

Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 drivers/acpi/processor_driver.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index a24ee43..81745f1 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -45,6 +45,7 @@
 #include <linux/cpuidle.h>
 #include <linux/slab.h>
 #include <linux/acpi.h>
+#include <linux/memory_hotplug.h>
 
 #include <asm/io.h>
 #include <asm/cpu.h>
@@ -641,6 +642,7 @@ static int acpi_processor_remove(struct acpi_device *device, int type)
 
 	per_cpu(processors, pr->id) = NULL;
 	per_cpu(processor_device_array, pr->id) = NULL;
+	try_offline_node(cpu_to_node(pr->id));
 
 free:
 	free_cpumask_var(pr->throttling.shared_cpu_map);
-- 
1.7.1

