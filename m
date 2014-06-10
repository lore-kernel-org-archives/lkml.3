Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934801AbaFJHf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 03:35:57 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:39898 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933814AbaFJHfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 03:35:55 -0400
From: Zhouyi Zhou <zhouzhouyi@gmail.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <x86@kernel.org>, <peterz@infradead.org>, <cpw@sgi.com>,
        <linux-kernel@vger.kernel.org>
Cc: Zhouyi Zhou <zhouzhouyi@gmail.com>, Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Subject: [PATCH] x86/tlb_uv: Fixing some memory allocation failure in x86 UV
Date: Tue, 10 Jun 2014 15:35:23 +0800
Message-Id: <1402385723-23138-1-git-send-email-zhouzhouyi@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing some memory allocation failure handling in x86 UV

Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
---
 arch/x86/platform/uv/tlb_uv.c |   17 +++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index dfe605a..a434768 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1965,6 +1966,10 @@ static void make_per_cpu_thp(struct bau_control *smaster)
 	size_t hpsz = sizeof(struct hub_and_pnode) * num_possible_cpus();
 
 	smaster->thp = kmalloc_node(hpsz, GFP_KERNEL, smaster->osnode);
+	if (!smaster->thp) {
+		pr_err("ERROR: out of memory, can not create hub and pnode!\n");
+		return;
+	}
 	memset(smaster->thp, 0, hpsz);
 	for_each_present_cpu(cpu) {
 		smaster->thp[cpu].pnode = uv_cpu_hub_info(cpu)->pnode;
@@ -1980,6 +1985,8 @@ static void make_per_hub_cpumask(struct bau_control *hmaster)
 	int sz = sizeof(cpumask_t);
 
 	hmaster->cpumask = kzalloc_node(sz, GFP_KERNEL, hmaster->osnode);
+	if (!hmaster->cpumask)
+		pr_err("ERROR: out of memory, can not create cpumask!\n");
 }
 
 /*
@@ -2056,11 +2063,15 @@ static int __init summarize_uvhub_sockets(int nuvhubs,
 				if (scan_sock(sdp, bdp, &smaster, &hmaster))
 					return 1;
 				make_per_cpu_thp(smaster);
+				if (!smaster->thp)
+					return 1;
 			}
 			socket++;
 			socket_mask = (socket_mask >> 1);
 		}
 		make_per_hub_cpumask(hmaster);
+		if (!hmaster->cpumask)
+			return 1;
 	}
 	return 0;
 }
@@ -2077,9 +2088,16 @@ static int __init init_per_cpu(int nuvhubs, int base_part_pnode)
 	timeout_us = calculate_destination_timeout();
 
 	vp = kmalloc(nuvhubs * sizeof(struct uvhub_desc), GFP_KERNEL);
+	if (!vp)
+		return 1;
+
 	uvhub_descs = (struct uvhub_desc *)vp;
 	memset(uvhub_descs, 0, nuvhubs * sizeof(struct uvhub_desc));
 	uvhub_mask = kzalloc((nuvhubs+7)/8, GFP_KERNEL);
+	if (!uvhub_mask) {
+		kfree(uvhub_descs);
+		return 1;
+	}
 
 	if (get_cpu_topology(base_part_pnode, uvhub_descs, uvhub_mask))
 		goto fail;
-- 
1.7.10.4

