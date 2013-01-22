Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab3AVLrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 06:47:00 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61946 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752624Ab3AVLqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 06:46:52 -0500
X-IronPort-AV: E=Sophos;i="4.84,514,1355068800"; 
   d="scan'208";a="6628488"
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
Subject: [PATCH Bug fix 4/5] cpu-hotplug,memory-hotplug: clear cpu_to_node() when offlining the node
Date: Tue, 22 Jan 2013 19:45:55 +0800
Message-Id: <1358855156-6126-5-git-send-email-tangchen@cn.fujitsu.com>
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

When the node is offlined, there is no memory/cpu on the node. If a
sleep task runs on a cpu of this node, it will be migrated to the
cpu on the other node. So we can clear cpu-to-node mapping.

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
 mm/memory_hotplug.c |   30 +++++++++++++++++++++++++++++-
 1 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index edd1773..022583b 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1702,6 +1702,34 @@ static int check_cpu_on_node(void *data)
 	return 0;
 }
 
+static void unmap_cpu_on_node(void *data)
+{
+#ifdef CONFIG_ACPI_NUMA
+	struct pglist_data *pgdat = data;
+	int cpu;
+
+	for_each_possible_cpu(cpu)
+		if (cpu_to_node(cpu) == pgdat->node_id)
+			numa_clear_node(cpu);
+#endif
+}
+
+static int check_and_unmap_cpu_on_node(void *data)
+{
+	int ret = check_cpu_on_node(data);
+
+	if (ret)
+		return ret;
+
+	/*
+	 * the node will be offlined when we come here, so we can clear
+	 * the cpu_to_node() now.
+	 */
+
+	unmap_cpu_on_node(data);
+	return 0;
+}
+
 /* offline the node if all memory sections of this node are removed */
 void try_offline_node(int nid)
 {
@@ -1728,7 +1756,7 @@ void try_offline_node(int nid)
 		return;
 	}
 
-	if (stop_machine(check_cpu_on_node, pgdat, NULL))
+	if (stop_machine(check_and_unmap_cpu_on_node, pgdat, NULL))
 		return;
 
 	/*
-- 
1.7.1

