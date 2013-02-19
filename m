Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758293Ab3BSNC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 08:02:27 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:36788 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756934Ab3BSNCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 08:02:24 -0500
X-IronPort-AV: E=Sophos;i="4.84,695,1355068800"; 
   d="scan'208";a="6730209"
From: Tang Chen <tangchen@cn.fujitsu.com>
To: akpm@linux-foundation.org, jiang.liu@huawei.com, wujianguo@huawei.com,
        hpa@zytor.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        linfeng@cn.fujitsu.com, yinghai@kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, rob@landley.net,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, guz.fnst@cn.fujitsu.com, rusty@rustcorp.com.au,
        lliubbo@gmail.com, jaegeuk.hanse@gmail.com, tony.luck@intel.com,
        glommer@parallels.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [Bug fix PATCH 1/2] acpi, movablemem_map: Do not zero numa_meminfo in numa_init().
Date: Tue, 19 Feb 2013 21:01:43 +0800
Message-Id: <1361278904-8690-2-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1361278904-8690-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1361278904-8690-1-git-send-email-tangchen@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 21:01:42,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 21:01:43,
	Serialize complete at 2013/02/19 21:01:43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

early_parse_srat() is called before numa_init(), and has initialized
numa_meminfo. So do not zero numa_meminfo in numa_init(), otherwise
we will lose memory numa info.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
---
 arch/x86/mm/numa.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 3545585..ff3633c 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -559,10 +559,12 @@ static int __init numa_init(int (*init_func)(void))
 	for (i = 0; i < MAX_LOCAL_APIC; i++)
 		set_apicid_to_node(i, NUMA_NO_NODE);
 
-	/* Do not clear numa_nodes_parsed because SRAT was parsed earlier. */
+	/*
+	 * Do not clear numa_nodes_parsed or zero numa_meminfo here, because
+	 * SRAT was parsed earlier in early_parse_srat().
+	 */
 	nodes_clear(node_possible_map);
 	nodes_clear(node_online_map);
-	memset(&numa_meminfo, 0, sizeof(numa_meminfo));
 	WARN_ON(memblock_set_node(0, ULLONG_MAX, MAX_NUMNODES));
 	numa_reset_distance();
 
-- 
1.7.1

