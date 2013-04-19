Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142Ab3DSJbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 05:31:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:31313 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S968000Ab3DSJ3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 05:29:23 -0400
X-IronPort-AV: E=Sophos;i="4.87,508,1363104000"; 
   d="scan'208";a="7095291"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        dhowells@redhat.com, davej@redhat.com, agordeev@redhat.com,
        suresh.b.siddha@intel.com, mst@redhat.com, yinghai@kernel.org,
        penberg@kernel.org, jacob.shin@amd.com, wency@cn.fujitsu.com,
        trenn@suse.de, liwanp@linux.vnet.ibm.com,
        isimatu.yasuaki@jp.fujitsu.com, rientjes@google.com, tj@kernel.org,
        laijs@cn.fujitsu.com, hannes@cmpxchg.org, davem@davemloft.net,
        mgorman@suse.de, minchan@kernel.org, m.szyprowski@samsung.com,
        mina86@mina86.com
Cc: x86@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH v1 03/12] page_alloc, mem-hotplug: Improve movablecore to {en|dis}able using SRAT.
Date: Fri, 19 Apr 2013 17:31:40 +0800
Message-Id: <1366363909-12771-4-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1366363909-12771-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1366363909-12771-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/19 17:27:26,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/19 17:27:28,
	Serialize complete at 2013/04/19 17:27:28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Hot-Pluggable Fired in SRAT specified which memory ranges are hotpluggable.
We will arrange hotpluggable memory as ZONE_MOVABLE for users who want to use
memory hotplug functionality. But this will cause NUMA performance decreased
because kernel cannot use ZONE_MOVABLE.

So we improve movablecore boot option to allow those who want to use memory
hotplug functionality to enable using SRAT info to arrange movable memory.

Users can specify "movablecore=acpi" in kernel commandline to enable this
functionality.

For those who don't use memory hotplug or who don't want to lose their NUMA
performance, just don't specify anything. The kernel will work as before.

Suggested-by: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 include/linux/memory_hotplug.h |    3 +++
 mm/page_alloc.c                |   13 +++++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index b6a3be7..18fe2a3 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -33,6 +33,9 @@ enum {
 	ONLINE_MOVABLE,
 };
 
+/* Enable/disable SRAT in movablecore boot option */
+extern bool movablecore_enable_srat;
+
 /*
  * pgdat resizing functions
  */
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f368db4..b9ea143 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -208,6 +208,8 @@ static unsigned long __initdata required_kernelcore;
 static unsigned long __initdata required_movablecore;
 static unsigned long __meminitdata zone_movable_pfn[MAX_NUMNODES];
 
+bool __initdata movablecore_enable_srat = false;
+
 /* movable_zone is the "real" zone pages in ZONE_MOVABLE are taken from */
 int movable_zone;
 EXPORT_SYMBOL(movable_zone);
@@ -5025,6 +5027,12 @@ void __init free_area_init_nodes(unsigned long *max_zone_pfn)
 	}
 }
 
+static void __init cmdline_movablecore_srat(char *p)
+{
+	if (p && !strcmp(p, "acpi"))
+		movablecore_enable_srat = true;
+}
+
 static int __init cmdline_parse_core(char *p, unsigned long *core)
 {
 	unsigned long long coremem;
@@ -5055,6 +5063,11 @@ static int __init cmdline_parse_kernelcore(char *p)
  */
 static int __init cmdline_parse_movablecore(char *p)
 {
+	cmdline_movablecore_srat(p);
+
+	if (movablecore_enable_srat)
+		return 0;
+
 	return cmdline_parse_core(p, &required_movablecore);
 }
 
-- 
1.7.1

