Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbaEMTBh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 15:01:37 -0400
Received: from relay3.sgi.com ([192.48.152.1]:40061 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752573AbaEMTBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 15:01:31 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: UV3 tlb shootdown update
Cc: mingo@elte.hu, hpa@zytor.com, x86@kernel.org
Message-Id: <E1WkHxA-0003Kg-Sl@eag09.americas.sgi.com>
From: cpw <cpw@sgi.com>
Date: Tue, 13 May 2014 14:01:28 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Wickman <cpw@sgi.com>

Update of TLB shootdown code for UV3.

Kernel function native_flush_tlb_others() calls uv_flush_tlb_others() on UV to
invalidate tlb page definitions on remote cpus. The UV systems have a hardware
'broadcast assist unit' which can be used to broadcast shootdown messages to
all cpu's of selected nodes.

The behavior of the BAU has changed only slightly with UV3:         
- UV3 is recognized with is_uv3_hub().
- UV2 functions and structures (uv2_xxx) are in most cases simply renamed to uv2_3_xxx.
- Some UV2 error workarounds are not needed for UV3.
  (see uv_bau_message_interrupt and enable_timeouts)

Signed-off-by: Cliff Wickman <cpw@sgi.com>
 
---
 arch/x86/include/asm/uv/uv_bau.h |   20 +++++++------
 arch/x86/platform/uv/tlb_uv.c    |   59 +++++++++++++++++++++++----------------
 2 files changed, 48 insertions(+), 31 deletions(-)

Index: linux/arch/x86/include/asm/uv/uv_bau.h
===================================================================
--- linux.orig/arch/x86/include/asm/uv/uv_bau.h
+++ linux/arch/x86/include/asm/uv/uv_bau.h
@@ -73,6 +73,7 @@
 #define UV_INTD_SOFT_ACK_TIMEOUT_PERIOD	(is_uv1_hub() ?			\
 		UV1_INTD_SOFT_ACK_TIMEOUT_PERIOD :			\
 		UV2_INTD_SOFT_ACK_TIMEOUT_PERIOD)
+/* assuming UV3 is the same */
 
 #define BAU_MISC_CONTROL_MULT_MASK	3
 
@@ -93,6 +94,8 @@
 #define SOFTACK_MSHIFT UVH_LB_BAU_MISC_CONTROL_ENABLE_INTD_SOFT_ACK_MODE_SHFT
 #define SOFTACK_PSHIFT UVH_LB_BAU_MISC_CONTROL_INTD_SOFT_ACK_TIMEOUT_PERIOD_SHFT
 #define SOFTACK_TIMEOUT_PERIOD UV_INTD_SOFT_ACK_TIMEOUT_PERIOD
+#define PREFETCH_HINT_SHFT UV3H_LB_BAU_MISC_CONTROL_ENABLE_INTD_PREFETCH_HINT_SHFT
+#define SB_STATUS_SHFT UV3H_LB_BAU_MISC_CONTROL_ENABLE_EXTENDED_SB_STATUS_SHFT
 #define write_gmmr	uv_write_global_mmr64
 #define write_lmmr	uv_write_local_mmr
 #define read_lmmr	uv_read_local_mmr
@@ -153,6 +156,7 @@
 #define UV2_ACK_MASK			0x7UL
 #define UV2_ACK_UNITS_SHFT		3
 #define UV2_EXT_SHFT UV2H_LB_BAU_MISC_CONTROL_ENABLE_EXTENDED_SB_STATUS_SHFT
+#define UV2_LEG_SHFT UV2H_LB_BAU_MISC_CONTROL_USE_LEGACY_DESCRIPTOR_FORMATS_SHFT
 
 /*
  * number of entries in the destination side payload queue
@@ -322,8 +326,9 @@ struct uv1_bau_msg_header {
 /*
  * UV2 Message header:  16 bytes (128 bits) (bytes 0x30-0x3f of descriptor)
  * see figure 9-2 of harp_sys.pdf
+ * assuming UV3 is the same
  */
-struct uv2_bau_msg_header {
+struct uv2_3_bau_msg_header {
 	unsigned int	base_dest_nasid:15;	/* nasid of the first bit */
 	/* bits 14:0 */				/* in uvhub map */
 	unsigned int	dest_subnodeid:5;	/* must be 0x10, for the LB */
@@ -395,7 +400,7 @@ struct bau_desc {
 	 */
 	union bau_msg_header {
 		struct uv1_bau_msg_header	uv1_hdr;
-		struct uv2_bau_msg_header	uv2_hdr;
+		struct uv2_3_bau_msg_header	uv2_3_hdr;
 	} header;
 
 	struct bau_msg_payload			payload;
@@ -631,11 +636,6 @@ struct bau_control {
 	struct hub_and_pnode	*thp;
 };
 
-static inline unsigned long read_mmr_uv2_status(void)
-{
-	return read_lmmr(UV2H_LB_BAU_SB_ACTIVATION_STATUS_2);
-}
-
 static inline void write_mmr_data_broadcast(int pnode, unsigned long mmr_image)
 {
 	write_gmmr(pnode, UVH_BAU_DATA_BROADCAST, mmr_image);
@@ -760,7 +760,11 @@ static inline int atomic_read_short(cons
  */
 static inline int atom_asr(short i, struct atomic_short *v)
 {
-	return i + xadd(&v->counter, i);
+	short __i = i;
+	asm volatile(LOCK_PREFIX "xaddw %0, %1"
+			: "+r" (i), "+m" (v->counter)
+			: : "memory");
+	return i + __i;
 }
 
 /*
Index: linux/arch/x86/platform/uv/tlb_uv.c
===================================================================
--- linux.orig/arch/x86/platform/uv/tlb_uv.c
+++ linux/arch/x86/platform/uv/tlb_uv.c
@@ -1,7 +1,7 @@
 /*
  *	SGI UltraViolet TLB flush routines.
  *
- *	(c) 2008-2012 Cliff Wickman <cpw@sgi.com>, SGI.
+ *	(c) 2008-2014 Cliff Wickman <cpw@sgi.com>, SGI.
  *
  *	This code is released under the GNU General Public License version 2 or
  *	later.
@@ -451,7 +451,7 @@ static inline unsigned long long cycles_
 
 /*
  * The reverse of the above; converts a duration in ns to a duration in cycles.
- */ 
+ */
 static inline unsigned long long ns_2_cycles(unsigned long long ns)
 {
 	struct cyc2ns_data *data = cyc2ns_read_begin();
@@ -563,7 +563,7 @@ static int uv1_wait_completion(struct ba
  * UV2 could have an extra bit of status in the ACTIVATION_STATUS_2 register.
  * But not currently used.
  */
-static unsigned long uv2_read_status(unsigned long offset, int rshft, int desc)
+static unsigned long uv2_3_read_status(unsigned long offset, int rshft, int desc)
 {
 	unsigned long descriptor_status;
 
@@ -606,7 +606,7 @@ int handle_uv2_busy(struct bau_control *
 	return FLUSH_GIVEUP;
 }
 
-static int uv2_wait_completion(struct bau_desc *bau_desc,
+static int uv2_3_wait_completion(struct bau_desc *bau_desc,
 				unsigned long mmr_offset, int right_shift,
 				struct bau_control *bcp, long try)
 {
@@ -616,7 +616,7 @@ static int uv2_wait_completion(struct ba
 	long busy_reps = 0;
 	struct ptc_stats *stat = bcp->statp;
 
-	descriptor_stat = uv2_read_status(mmr_offset, right_shift, desc);
+	descriptor_stat = uv2_3_read_status(mmr_offset, right_shift, desc);
 
 	/* spin on the status MMR, waiting for it to go idle */
 	while (descriptor_stat != UV2H_DESC_IDLE) {
@@ -667,7 +667,7 @@ static int uv2_wait_completion(struct ba
 			 */
 			cpu_relax();
 		}
-		descriptor_stat = uv2_read_status(mmr_offset, right_shift,
+		descriptor_stat = uv2_3_read_status(mmr_offset, right_shift,
 									desc);
 	}
 	bcp->conseccompletes++;
@@ -698,7 +698,7 @@ static int wait_completion(struct bau_de
 		return uv1_wait_completion(bau_desc, mmr_offset, right_shift,
 								bcp, try);
 	else
-		return uv2_wait_completion(bau_desc, mmr_offset, right_shift,
+		return uv2_3_wait_completion(bau_desc, mmr_offset, right_shift,
 								bcp, try);
 }
 
@@ -888,7 +888,7 @@ int uv_flush_send_and_wait(struct cpumas
 	struct ptc_stats *stat = bcp->statp;
 	struct bau_control *hmaster = bcp->uvhub_master;
 	struct uv1_bau_msg_header *uv1_hdr = NULL;
-	struct uv2_bau_msg_header *uv2_hdr = NULL;
+	struct uv2_3_bau_msg_header *uv2_3_hdr = NULL;
 
 	if (bcp->uvhub_version == 1) {
 		uv1 = 1;
@@ -902,27 +902,28 @@ int uv_flush_send_and_wait(struct cpumas
 	if (uv1)
 		uv1_hdr = &bau_desc->header.uv1_hdr;
 	else
-		uv2_hdr = &bau_desc->header.uv2_hdr;
+		/* uv2 and uv3 */
+		uv2_3_hdr = &bau_desc->header.uv2_3_hdr;
 
 	do {
 		if (try == 0) {
 			if (uv1)
 				uv1_hdr->msg_type = MSG_REGULAR;
 			else
-				uv2_hdr->msg_type = MSG_REGULAR;
+				uv2_3_hdr->msg_type = MSG_REGULAR;
 			seq_number = bcp->message_number++;
 		} else {
 			if (uv1)
 				uv1_hdr->msg_type = MSG_RETRY;
 			else
-				uv2_hdr->msg_type = MSG_RETRY;
+				uv2_3_hdr->msg_type = MSG_RETRY;
 			stat->s_retry_messages++;
 		}
 
 		if (uv1)
 			uv1_hdr->sequence = seq_number;
 		else
-			uv2_hdr->sequence = seq_number;
+			uv2_3_hdr->sequence = seq_number;
 		index = (1UL << AS_PUSH_SHIFT) | bcp->uvhub_cpu;
 		bcp->send_message = get_cycles();
 
@@ -1080,8 +1081,10 @@ static int set_distrib_bits(struct cpuma
  * done.  The returned pointer is valid till preemption is re-enabled.
  */
 const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
-				struct mm_struct *mm, unsigned long start,
-				unsigned long end, unsigned int cpu)
+						struct mm_struct *mm,
+						unsigned long start,
+						unsigned long end,
+						unsigned int cpu)
 {
 	int locals = 0;
 	int remotes = 0;
@@ -1268,6 +1271,7 @@ void uv_bau_message_interrupt(struct pt_
 		if (bcp->uvhub_version == 2)
 			process_uv2_message(&msgdesc, bcp);
 		else
+			/* no error workaround for uv1 or uv3 */
 			bau_process_message(&msgdesc, bcp, 1);
 
 		msg++;
@@ -1325,8 +1329,13 @@ static void __init enable_timeouts(void)
 		 */
 		mmr_image |= (1L << SOFTACK_MSHIFT);
 		if (is_uv2_hub()) {
+			/* do not use legacy mode */
+			mmr_image &= ~(1L << UV2_LEG_SHFT);
 			/* hw bug workaround; do not use extended status */
 			mmr_image &= ~(1L << UV2_EXT_SHFT);
+		} else if (is_uv3_hub()) {
+			mmr_image &= ~(1L << PREFETCH_HINT_SHFT);
+			mmr_image |= (1L << SB_STATUS_SHFT);
 		}
 		write_mmr_misc_control(pnode, mmr_image);
 	}
@@ -1692,7 +1701,7 @@ static void activation_descriptor_init(i
 	struct bau_desc *bau_desc;
 	struct bau_desc *bd2;
 	struct uv1_bau_msg_header *uv1_hdr;
-	struct uv2_bau_msg_header *uv2_hdr;
+	struct uv2_3_bau_msg_header *uv2_3_hdr;
 	struct bau_control *bcp;
 
 	/*
@@ -1739,15 +1748,15 @@ static void activation_descriptor_init(i
 			 */
 		} else {
 			/*
-			 * BIOS uses legacy mode, but UV2 hardware always
+			 * BIOS uses legacy mode, but uv2 and uv3 hardware always
 			 * uses native mode for selective broadcasts.
 			 */
-			uv2_hdr = &bd2->header.uv2_hdr;
-			uv2_hdr->swack_flag =	1;
-			uv2_hdr->base_dest_nasid =
+			uv2_3_hdr = &bd2->header.uv2_3_hdr;
+			uv2_3_hdr->swack_flag =	1;
+			uv2_3_hdr->base_dest_nasid =
 						UV_PNODE_TO_NASID(base_pnode);
-			uv2_hdr->dest_subnodeid =	UV_LB_SUBNODEID;
-			uv2_hdr->command =		UV_NET_ENDPOINT_INTD;
+			uv2_3_hdr->dest_subnodeid =	UV_LB_SUBNODEID;
+			uv2_3_hdr->command =		UV_NET_ENDPOINT_INTD;
 		}
 	}
 	for_each_present_cpu(cpu) {
@@ -1858,6 +1867,7 @@ static int calculate_destination_timeout
 		ts_ns *= (mult1 * mult2);
 		ret = ts_ns / 1000;
 	} else {
+		/* same destination timeout for uv2 and uv3 */
 		/* 4 bits  0/1 for 10/80us base, 3 bits of multiplier */
 		mmr_image = uv_read_local_mmr(UVH_LB_BAU_MISC_CONTROL);
 		mmr_image = (mmr_image & UV_SA_MASK) >> UV_SA_SHFT;
@@ -2012,8 +2022,10 @@ static int scan_sock(struct socket_desc
 			bcp->uvhub_version = 1;
 		else if (is_uv2_hub())
 			bcp->uvhub_version = 2;
+		else if (is_uv3_hub())
+			bcp->uvhub_version = 3;
 		else {
-			printk(KERN_EMERG "uvhub version not 1 or 2\n");
+			printk(KERN_EMERG "uvhub version not 1, 2 or 3\n");
 			return 1;
 		}
 		bcp->uvhub_master = *hmasterp;
@@ -2138,9 +2150,10 @@ static int __init uv_bau_init(void)
 	}
 
 	vector = UV_BAU_MESSAGE;
-	for_each_possible_blade(uvhub)
+	for_each_possible_blade(uvhub) {
 		if (uv_blade_nr_possible_cpus(uvhub))
 			init_uvhub(uvhub, vector, uv_base_pnode);
+	}
 
 	alloc_intr_gate(vector, uv_bau_message_intr1);
 
