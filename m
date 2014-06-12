Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932949AbaFLJdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 05:33:11 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:54867 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932750AbaFLJdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 05:33:09 -0400
From: Zhouyi Zhou <zhouzhouyi@gmail.com>
To: <rientjes@google.com>, <joe@perches.com>, <tglx@linutronix.de>,
        <hpa@zytor.com>, <x86@kernel.org>, <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>, <cpw@sgi.com>
Cc: Zhouyi Zhou <zhouzhouyi@gmail.com>, Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Subject: [PATCH v2]x86/tlb_uv: Fixing all memory allocation failure handling in UV
Date: Thu, 12 Jun 2014 17:32:34 +0800
Message-Id: <1402565554-30298-1-git-send-email-zhouzhouyi@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to Peter, Thomas, Joe and David's advices, try fixing all memory allocation 
failure handling in tlb_uv.c

compiled in x86_64
Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
---
 arch/x86/platform/uv/tlb_uv.c |  122 +++++++++++++++++++++++++++++------------
 1 file changed, 87 insertions(+), 35 deletions(-)

diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index dfe605a..1a45dfa 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1680,7 +1680,7 @@ static int __init uv_ptc_init(void)
 /*
  * Initialize the sending side's sending buffers.
  */
-static void activation_descriptor_init(int node, int pnode, int base_pnode)
+static int activation_descriptor_init(int node, int pnode, int base_pnode)
 {
 	int i;
 	int cpu;
@@ -1701,7 +1701,9 @@ static void activation_descriptor_init(int node, int pnode, int base_pnode)
 	 */
 	dsize = sizeof(struct bau_desc) * ADP_SZ * ITEMS_PER_DESC;
 	bau_desc = kmalloc_node(dsize, GFP_KERNEL, node);
-	BUG_ON(!bau_desc);
+	if (!bau_desc)
+		return -ENOMEM;
+
 
 	gpa = uv_gpa(bau_desc);
 	n = uv_gpa_to_gnode(gpa);
@@ -1756,6 +1758,8 @@ static void activation_descriptor_init(int node, int pnode, int base_pnode)
 		bcp = &per_cpu(bau_control, cpu);
 		bcp->descriptor_base = bau_desc;
 	}
+
+	return 0;
 }
 
 /*
@@ -1764,7 +1768,7 @@ static void activation_descriptor_init(int node, int pnode, int base_pnode)
  * - node is first node (kernel memory notion) on the uvhub
  * - pnode is the uvhub's physical identifier
  */
-static void pq_init(int node, int pnode)
+static int pq_init(int node, int pnode)
 {
 	int cpu;
 	size_t plsize;
@@ -1776,12 +1780,16 @@ static void pq_init(int node, int pnode)
 	unsigned long last;
 	struct bau_pq_entry *pqp;
 	struct bau_control *bcp;
+	int ret = 0;
 
 	plsize = (DEST_Q_SIZE + 1) * sizeof(struct bau_pq_entry);
 	vp = kmalloc_node(plsize, GFP_KERNEL, node);
-	pqp = (struct bau_pq_entry *)vp;
-	BUG_ON(!pqp);
+	if (!vp) {
+		ret =  -ENOMEM;
+		goto fail;
+	}
 
+	pqp = (struct bau_pq_entry *)vp;
 	cp = (char *)pqp + 31;
 	pqp = (struct bau_pq_entry *)(((unsigned long)cp >> 5) << 5);
 
@@ -1808,29 +1816,40 @@ static void pq_init(int node, int pnode)
 
 	/* in effect, all msg_type's are set to MSG_NOOP */
 	memset(pqp, 0, sizeof(struct bau_pq_entry) * DEST_Q_SIZE);
+
+	return 0;
+fail:
+	return ret;
 }
 
 /*
  * Initialization of each UV hub's structures
  */
-static void __init init_uvhub(int uvhub, int vector, int base_pnode)
+static int __init init_uvhub(int uvhub, int vector, int base_pnode)
 {
 	int node;
 	int pnode;
 	unsigned long apicid;
+	int ret;
 
 	node = uvhub_to_first_node(uvhub);
 	pnode = uv_blade_to_pnode(uvhub);
 
-	activation_descriptor_init(node, pnode, base_pnode);
+	ret = activation_descriptor_init(node, pnode, base_pnode);
+	if (ret)
+		return ret;
 
-	pq_init(node, pnode);
+	ret = pq_init(node, pnode);
+	if (ret)
+		return ret;
 	/*
 	 * The below initialization can't be in firmware because the
 	 * messaging IRQ will be determined by the OS.
 	 */
 	apicid = uvhub_to_first_apicid(uvhub) | uv_apicid_hibits;
 	write_mmr_data_config(pnode, ((apicid << 32) | vector));
+
+	return 0;
 }
 
 /*
@@ -1926,7 +1945,7 @@ static int __init get_cpu_topology(int base_pnode,
 			printk(KERN_EMERG
 				"cpu %d pnode %d-%d beyond %d; BAU disabled\n",
 				cpu, pnode, base_pnode, UV_DISTRIBUTION_SIZE);
-			return 1;
+			return -EINVAL;
 		}
 
 		bcp->osnode = cpu_to_node(cpu);
@@ -1950,7 +1969,7 @@ static int __init get_cpu_topology(int base_pnode,
 		if (sdp->num_cpus > MAX_CPUS_PER_SOCKET) {
 			printk(KERN_EMERG "%d cpus per socket invalid\n",
 				sdp->num_cpus);
-			return 1;
+			return -EINVAL;
 		}
 	}
 	return 0;
@@ -1959,29 +1978,29 @@ static int __init get_cpu_topology(int base_pnode,
 /*
  * Each socket is to get a local array of pnodes/hubs.
  */
-static void make_per_cpu_thp(struct bau_control *smaster)
+static int make_per_cpu_thp(struct bau_control *smaster)
 {
 	int cpu;
 	size_t hpsz = sizeof(struct hub_and_pnode) * num_possible_cpus();
-
+	int ret;
 	smaster->thp = kmalloc_node(hpsz, GFP_KERNEL, smaster->osnode);
+	if (!smaster->thp) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
 	memset(smaster->thp, 0, hpsz);
 	for_each_present_cpu(cpu) {
 		smaster->thp[cpu].pnode = uv_cpu_hub_info(cpu)->pnode;
 		smaster->thp[cpu].uvhub = uv_cpu_hub_info(cpu)->numa_blade_id;
 	}
-}
-
-/*
- * Each uvhub is to get a local cpumask.
- */
-static void make_per_hub_cpumask(struct bau_control *hmaster)
-{
-	int sz = sizeof(cpumask_t);
 
-	hmaster->cpumask = kzalloc_node(sz, GFP_KERNEL, hmaster->osnode);
+	return 0;
+fail:
+	return ret;
 }
 
+
 /*
  * Initialize all the per_cpu information for the cpu's on a given socket,
  * given what has been gathered into the socket_desc struct.
@@ -2014,14 +2033,14 @@ static int scan_sock(struct socket_desc *sdp, struct uvhub_desc *bdp,
 			bcp->uvhub_version = 2;
 		else {
 			printk(KERN_EMERG "uvhub version not 1 or 2\n");
-			return 1;
+			return -EINVAL;
 		}
 		bcp->uvhub_master = *hmasterp;
 		bcp->uvhub_cpu = uv_cpu_hub_info(cpu)->blade_processor_id;
 		if (bcp->uvhub_cpu >= MAX_CPUS_PER_UVHUB) {
 			printk(KERN_EMERG "%d cpus per uvhub invalid\n",
 				bcp->uvhub_cpu);
-			return 1;
+			return -EINVAL;
 		}
 	}
 	return 0;
@@ -2037,6 +2056,7 @@ static int __init summarize_uvhub_sockets(int nuvhubs,
 	int socket;
 	int uvhub;
 	unsigned short socket_mask;
+	int ret = 0;
 
 	for (uvhub = 0; uvhub < nuvhubs; uvhub++) {
 		struct uvhub_desc *bdp;
@@ -2053,16 +2073,30 @@ static int __init summarize_uvhub_sockets(int nuvhubs,
 			struct socket_desc *sdp;
 			if ((socket_mask & 1)) {
 				sdp = &bdp->socket[socket];
-				if (scan_sock(sdp, bdp, &smaster, &hmaster))
-					return 1;
-				make_per_cpu_thp(smaster);
+				ret = scan_sock(sdp, bdp, &smaster, &hmaster);
+				if (ret)
+					goto fail;
+				ret = make_per_cpu_thp(smaster);
+				if (ret)
+					goto fail;
 			}
 			socket++;
 			socket_mask = (socket_mask >> 1);
 		}
-		make_per_hub_cpumask(hmaster);
+/*
+ * Each uvhub is to get a local cpumask.
+ */
+		hmaster->cpumask = kzalloc_node(
+			sizeof(cpumask_t), GFP_KERNEL, hmaster->osnode);
+		if (!hmaster->cpumask) {
+			ret = -ENOMEM;
+			goto fail;
+		}
 	}
 	return 0;
+
+fail:
+	return ret;
 }
 
 /*
@@ -2073,15 +2107,25 @@ static int __init init_per_cpu(int nuvhubs, int base_part_pnode)
 	unsigned char *uvhub_mask;
 	void *vp;
 	struct uvhub_desc *uvhub_descs;
+	int ret = 0;
 
 	timeout_us = calculate_destination_timeout();
 
-	vp = kmalloc(nuvhubs * sizeof(struct uvhub_desc), GFP_KERNEL);
+	vp = kcalloc(nuvhubs, sizeof(struct uvhub_desc), GFP_KERNEL);
+	if (!vp) {
+		ret = -ENOMEM;
+		goto fail_descs;
+	}
 	uvhub_descs = (struct uvhub_desc *)vp;
-	memset(uvhub_descs, 0, nuvhubs * sizeof(struct uvhub_desc));
+
 	uvhub_mask = kzalloc((nuvhubs+7)/8, GFP_KERNEL);
+	if (!uvhub_mask) {
+		ret = -ENOMEM;
+		goto fail_mask;
+	}
 
-	if (get_cpu_topology(base_part_pnode, uvhub_descs, uvhub_mask))
+	ret = get_cpu_topology(base_part_pnode, uvhub_descs, uvhub_mask);
+	if (ret)
 		goto fail;
 
 	if (summarize_uvhub_sockets(nuvhubs, uvhub_descs, uvhub_mask))
@@ -2093,9 +2137,11 @@ static int __init init_per_cpu(int nuvhubs, int base_part_pnode)
 	return 0;
 
 fail:
-	kfree(uvhub_descs);
 	kfree(uvhub_mask);
-	return 1;
+fail_mask:
+	kfree(uvhub_descs);
+fail_descs:
+	return ret;
 }
 
 /*
@@ -2110,13 +2156,16 @@ static int __init uv_bau_init(void)
 	int cpus;
 	int vector;
 	cpumask_var_t *mask;
+	int ret;
 
 	if (!is_uv_system())
 		return 0;
 
 	for_each_possible_cpu(cur_cpu) {
 		mask = &per_cpu(uv_flush_tlb_mask, cur_cpu);
-		zalloc_cpumask_var_node(mask, GFP_KERNEL, cpu_to_node(cur_cpu));
+		if (!zalloc_cpumask_var_node(
+			    mask, GFP_KERNEL, cpu_to_node(cur_cpu)))
+			return -ENOMEM;
 	}
 
 	nuvhubs = uv_num_possible_blades();
@@ -2139,8 +2188,11 @@ static int __init uv_bau_init(void)
 
 	vector = UV_BAU_MESSAGE;
 	for_each_possible_blade(uvhub)
-		if (uv_blade_nr_possible_cpus(uvhub))
-			init_uvhub(uvhub, vector, uv_base_pnode);
+		if (uv_blade_nr_possible_cpus(uvhub)) {
+			ret = init_uvhub(uvhub, vector, uv_base_pnode);
+			if (ret)
+				return ret;
+		}
 
 	alloc_intr_gate(vector, uv_bau_message_intr1);
 
-- 
1.7.10.4

