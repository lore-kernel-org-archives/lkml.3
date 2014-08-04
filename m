Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbaHDMaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 08:30:20 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33473 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaHDMaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 08:30:17 -0400
Date: Mon, 4 Aug 2014 14:30:08 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/uv change for v3.17
Message-ID: <20140804123008.GA27612@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-uv-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-uv-for-linus

   # HEAD: a26fd71953711acb4884df84e393d52de57e4f17 x86/uv: Update the UV3 TLB shootdown logic

UV TLB shootdown logic updates for version of the UV architecture.

 Thanks,

	Ingo

------------------>
Cliff Wickman (1):
      x86/uv: Update the UV3 TLB shootdown logic


 arch/x86/include/asm/uv/uv_bau.h | 19 ++++++-----
 arch/x86/platform/uv/tlb_uv.c    | 69 ++++++++++++++++++++++------------------
 2 files changed, 49 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index 0b46ef2..2d60a78 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
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
@@ -322,8 +325,9 @@ struct uv1_bau_msg_header {
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
@@ -395,7 +399,7 @@ struct bau_desc {
 	 */
 	union bau_msg_header {
 		struct uv1_bau_msg_header	uv1_hdr;
-		struct uv2_bau_msg_header	uv2_hdr;
+		struct uv2_3_bau_msg_header	uv2_3_hdr;
 	} header;
 
 	struct bau_msg_payload			payload;
@@ -631,11 +635,6 @@ struct bau_control {
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
@@ -760,7 +759,11 @@ static inline int atomic_read_short(const struct atomic_short *v)
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
diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index dfe605a..ed161c6 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1,7 +1,7 @@
 /*
  *	SGI UltraViolet TLB flush routines.
  *
- *	(c) 2008-2012 Cliff Wickman <cpw@sgi.com>, SGI.
+ *	(c) 2008-2014 Cliff Wickman <cpw@sgi.com>, SGI.
  *
  *	This code is released under the GNU General Public License version 2 or
  *	later.
@@ -451,7 +451,7 @@ static inline unsigned long long cycles_2_ns(unsigned long long cyc)
 
 /*
  * The reverse of the above; converts a duration in ns to a duration in cycles.
- */ 
+ */
 static inline unsigned long long ns_2_cycles(unsigned long long ns)
 {
 	struct cyc2ns_data *data = cyc2ns_read_begin();
@@ -563,7 +563,7 @@ static int uv1_wait_completion(struct bau_desc *bau_desc,
  * UV2 could have an extra bit of status in the ACTIVATION_STATUS_2 register.
  * But not currently used.
  */
-static unsigned long uv2_read_status(unsigned long offset, int rshft, int desc)
+static unsigned long uv2_3_read_status(unsigned long offset, int rshft, int desc)
 {
 	unsigned long descriptor_status;
 
@@ -606,7 +606,7 @@ int handle_uv2_busy(struct bau_control *bcp)
 	return FLUSH_GIVEUP;
 }
 
-static int uv2_wait_completion(struct bau_desc *bau_desc,
+static int uv2_3_wait_completion(struct bau_desc *bau_desc,
 				unsigned long mmr_offset, int right_shift,
 				struct bau_control *bcp, long try)
 {
@@ -616,7 +616,7 @@ static int uv2_wait_completion(struct bau_desc *bau_desc,
 	long busy_reps = 0;
 	struct ptc_stats *stat = bcp->statp;
 
-	descriptor_stat = uv2_read_status(mmr_offset, right_shift, desc);
+	descriptor_stat = uv2_3_read_status(mmr_offset, right_shift, desc);
 
 	/* spin on the status MMR, waiting for it to go idle */
 	while (descriptor_stat != UV2H_DESC_IDLE) {
@@ -658,8 +658,7 @@ static int uv2_wait_completion(struct bau_desc *bau_desc,
 				/* not to hammer on the clock */
 				busy_reps = 0;
 				ttm = get_cycles();
-				if ((ttm - bcp->send_message) >
-						bcp->timeout_interval)
+				if ((ttm - bcp->send_message) > bcp->timeout_interval)
 					return handle_uv2_busy(bcp);
 			}
 			/*
@@ -667,8 +666,7 @@ static int uv2_wait_completion(struct bau_desc *bau_desc,
 			 */
 			cpu_relax();
 		}
-		descriptor_stat = uv2_read_status(mmr_offset, right_shift,
-									desc);
+		descriptor_stat = uv2_3_read_status(mmr_offset, right_shift, desc);
 	}
 	bcp->conseccompletes++;
 	return FLUSH_COMPLETE;
@@ -679,8 +677,7 @@ static int uv2_wait_completion(struct bau_desc *bau_desc,
  * which register to read and position in that register based on cpu in
  * current hub.
  */
-static int wait_completion(struct bau_desc *bau_desc,
-				struct bau_control *bcp, long try)
+static int wait_completion(struct bau_desc *bau_desc, struct bau_control *bcp, long try)
 {
 	int right_shift;
 	unsigned long mmr_offset;
@@ -695,11 +692,9 @@ static int wait_completion(struct bau_desc *bau_desc,
 	}
 
 	if (bcp->uvhub_version == 1)
-		return uv1_wait_completion(bau_desc, mmr_offset, right_shift,
-								bcp, try);
+		return uv1_wait_completion(bau_desc, mmr_offset, right_shift, bcp, try);
 	else
-		return uv2_wait_completion(bau_desc, mmr_offset, right_shift,
-								bcp, try);
+		return uv2_3_wait_completion(bau_desc, mmr_offset, right_shift, bcp, try);
 }
 
 /*
@@ -888,7 +883,7 @@ int uv_flush_send_and_wait(struct cpumask *flush_mask, struct bau_control *bcp,
 	struct ptc_stats *stat = bcp->statp;
 	struct bau_control *hmaster = bcp->uvhub_master;
 	struct uv1_bau_msg_header *uv1_hdr = NULL;
-	struct uv2_bau_msg_header *uv2_hdr = NULL;
+	struct uv2_3_bau_msg_header *uv2_3_hdr = NULL;
 
 	if (bcp->uvhub_version == 1) {
 		uv1 = 1;
@@ -902,27 +897,28 @@ int uv_flush_send_and_wait(struct cpumask *flush_mask, struct bau_control *bcp,
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
 
@@ -1080,8 +1076,10 @@ static int set_distrib_bits(struct cpumask *flush_mask, struct bau_control *bcp,
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
@@ -1268,6 +1266,7 @@ void uv_bau_message_interrupt(struct pt_regs *regs)
 		if (bcp->uvhub_version == 2)
 			process_uv2_message(&msgdesc, bcp);
 		else
+			/* no error workaround for uv1 or uv3 */
 			bau_process_message(&msgdesc, bcp, 1);
 
 		msg++;
@@ -1325,8 +1324,12 @@ static void __init enable_timeouts(void)
 		 */
 		mmr_image |= (1L << SOFTACK_MSHIFT);
 		if (is_uv2_hub()) {
+			/* do not touch the legacy mode bit */
 			/* hw bug workaround; do not use extended status */
 			mmr_image &= ~(1L << UV2_EXT_SHFT);
+		} else if (is_uv3_hub()) {
+			mmr_image &= ~(1L << PREFETCH_HINT_SHFT);
+			mmr_image |= (1L << SB_STATUS_SHFT);
 		}
 		write_mmr_misc_control(pnode, mmr_image);
 	}
@@ -1692,7 +1695,7 @@ static void activation_descriptor_init(int node, int pnode, int base_pnode)
 	struct bau_desc *bau_desc;
 	struct bau_desc *bd2;
 	struct uv1_bau_msg_header *uv1_hdr;
-	struct uv2_bau_msg_header *uv2_hdr;
+	struct uv2_3_bau_msg_header *uv2_3_hdr;
 	struct bau_control *bcp;
 
 	/*
@@ -1739,15 +1742,15 @@ static void activation_descriptor_init(int node, int pnode, int base_pnode)
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
@@ -1858,6 +1861,7 @@ static int calculate_destination_timeout(void)
 		ts_ns *= (mult1 * mult2);
 		ret = ts_ns / 1000;
 	} else {
+		/* same destination timeout for uv2 and uv3 */
 		/* 4 bits  0/1 for 10/80us base, 3 bits of multiplier */
 		mmr_image = uv_read_local_mmr(UVH_LB_BAU_MISC_CONTROL);
 		mmr_image = (mmr_image & UV_SA_MASK) >> UV_SA_SHFT;
@@ -2012,8 +2016,10 @@ static int scan_sock(struct socket_desc *sdp, struct uvhub_desc *bdp,
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
@@ -2138,9 +2144,10 @@ static int __init uv_bau_init(void)
 	}
 
 	vector = UV_BAU_MESSAGE;
-	for_each_possible_blade(uvhub)
+	for_each_possible_blade(uvhub) {
 		if (uv_blade_nr_possible_cpus(uvhub))
 			init_uvhub(uvhub, vector, uv_base_pnode);
+	}
 
 	alloc_intr_gate(vector, uv_bau_message_intr1);
 
