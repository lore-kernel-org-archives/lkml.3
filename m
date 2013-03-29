Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab3C2B5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 21:57:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32298 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623Ab3C2B5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 21:57:43 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=eIhxMilvRf8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=fh4mg5NFAAAA:8 a=jZVsG21pAAAA:8 a=Z4Rwk6OoAAAA:8 a=VwQbUJbxAAAA:8 a=ag1SF4gXAAAA:8 a=M5GUcnROAAAA:8 a=5ABLVTJeYE3OttFEGj4A:9 a=QEXdDO2ut3YA:10 a=Im-eZXwrtqoA:10 a=v-EnS7xDjQoA:10 a=9RRF0ttvEvMA:10 a=HDH4eZIHFMA4etf2:21 a=Sho0pQ1ZLuBqhSjn:21 a=9e83vTEVy6w7GE4f:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1364522261.10629.7.camel@gandalf.local.home>
Subject: Re: Linux 3.6.11.1
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: stable <stable@vger.kernel.org>
Date: Thu, 28 Mar 2013 21:57:41 -0400
In-Reply-To: <1364522205.10629.6.camel@gandalf.local.home>
References: <1364522205.10629.6.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/MAINTAINERS b/MAINTAINERS
index 9a6c4da..61ed6f7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2697,7 +2697,7 @@ S:	Maintained
 F:	drivers/net/ethernet/i825xx/eexpress.*
 
 ETHERNET BRIDGE
-M:	Stephen Hemminger <shemminger@vyatta.com>
+M:	Stephen Hemminger <stephen@networkplumber.org>
 L:	bridge@lists.linux-foundation.org
 L:	netdev@vger.kernel.org
 W:	http://www.linuxfoundation.org/en/Net:Bridge
@@ -4420,7 +4420,7 @@ S:	Maintained
 
 MARVELL GIGABIT ETHERNET DRIVERS (skge/sky2)
 M:	Mirko Lindner <mlindner@marvell.com>
-M:	Stephen Hemminger <shemminger@vyatta.com>
+M:	Stephen Hemminger <stephen@networkplumber.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/marvell/sk*
@@ -4664,7 +4664,7 @@ S:	Supported
 F:	drivers/infiniband/hw/nes/
 
 NETEM NETWORK EMULATOR
-M:	Stephen Hemminger <shemminger@vyatta.com>
+M:	Stephen Hemminger <stephen@networkplumber.org>
 L:	netem@lists.linux-foundation.org
 S:	Maintained
 F:	net/sched/sch_netem.c
diff --git a/Makefile b/Makefile
index 50dc4d1..fd753ca 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 6
 SUBLEVEL = 11
-EXTRAVERSION =
+EXTRAVERSION = .1
 NAME = Terrified Chipmunk
 
 # *DOCUMENTATION*
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 67f1f6f..0133b1b 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -56,6 +56,7 @@ config SPARC64
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
 	select HAVE_SYSCALL_WRAPPERS
+	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_SYSCALL_TRACEPOINTS
diff --git a/arch/sparc/include/asm/hugetlb.h b/arch/sparc/include/asm/hugetlb.h
index 1770610..f368cef 100644
--- a/arch/sparc/include/asm/hugetlb.h
+++ b/arch/sparc/include/asm/hugetlb.h
@@ -58,14 +58,20 @@ static inline pte_t huge_pte_wrprotect(pte_t pte)
 static inline void huge_ptep_set_wrprotect(struct mm_struct *mm,
 					   unsigned long addr, pte_t *ptep)
 {
-	ptep_set_wrprotect(mm, addr, ptep);
+	pte_t old_pte = *ptep;
+	set_huge_pte_at(mm, addr, ptep, pte_wrprotect(old_pte));
 }
 
 static inline int huge_ptep_set_access_flags(struct vm_area_struct *vma,
 					     unsigned long addr, pte_t *ptep,
 					     pte_t pte, int dirty)
 {
-	return ptep_set_access_flags(vma, addr, ptep, pte, dirty);
+	int changed = !pte_same(*ptep, pte);
+	if (changed) {
+		set_huge_pte_at(vma->vm_mm, addr, ptep, pte);
+		flush_tlb_page(vma, addr);
+	}
+	return changed;
 }
 
 static inline pte_t huge_ptep_get(pte_t *ptep)
diff --git a/arch/sparc/mm/tsb.c b/arch/sparc/mm/tsb.c
index c52add7..7c2d9ac 100644
--- a/arch/sparc/mm/tsb.c
+++ b/arch/sparc/mm/tsb.c
@@ -331,7 +331,7 @@ void tsb_grow(struct mm_struct *mm, unsigned long tsb_index, unsigned long rss)
 retry_tsb_alloc:
 	gfp_flags = GFP_KERNEL;
 	if (new_size > (PAGE_SIZE * 2))
-		gfp_flags = __GFP_NOWARN | __GFP_NORETRY;
+		gfp_flags |= __GFP_NOWARN | __GFP_NORETRY;
 
 	new_tsb = kmem_cache_alloc_node(tsb_caches[new_cache_index],
 					gfp_flags, numa_node_id());
diff --git a/drivers/atm/iphase.h b/drivers/atm/iphase.h
index 6a0955e..53ecac5 100644
--- a/drivers/atm/iphase.h
+++ b/drivers/atm/iphase.h
@@ -636,82 +636,82 @@ struct rx_buf_desc {
 #define SEG_BASE IPHASE5575_FRAG_CONTROL_REG_BASE  
 #define REASS_BASE IPHASE5575_REASS_CONTROL_REG_BASE  
 
-typedef volatile u_int  freg_t;
+typedef volatile u_int	ffreg_t;
 typedef u_int   rreg_t;
 
 typedef struct _ffredn_t {
-        freg_t  idlehead_high;  /* Idle cell header (high)              */
-        freg_t  idlehead_low;   /* Idle cell header (low)               */
-        freg_t  maxrate;        /* Maximum rate                         */
-        freg_t  stparms;        /* Traffic Management Parameters        */
-        freg_t  abrubr_abr;     /* ABRUBR Priority Byte 1, TCR Byte 0   */
-        freg_t  rm_type;        /*                                      */
-        u_int   filler5[0x17 - 0x06];
-        freg_t  cmd_reg;        /* Command register                     */
-        u_int   filler18[0x20 - 0x18];
-        freg_t  cbr_base;       /* CBR Pointer Base                     */
-        freg_t  vbr_base;       /* VBR Pointer Base                     */
-        freg_t  abr_base;       /* ABR Pointer Base                     */
-        freg_t  ubr_base;       /* UBR Pointer Base                     */
-        u_int   filler24;
-        freg_t  vbrwq_base;     /* VBR Wait Queue Base                  */
-        freg_t  abrwq_base;     /* ABR Wait Queue Base                  */
-        freg_t  ubrwq_base;     /* UBR Wait Queue Base                  */
-        freg_t  vct_base;       /* Main VC Table Base                   */
-        freg_t  vcte_base;      /* Extended Main VC Table Base          */
-        u_int   filler2a[0x2C - 0x2A];
-        freg_t  cbr_tab_beg;    /* CBR Table Begin                      */
-        freg_t  cbr_tab_end;    /* CBR Table End                        */
-        freg_t  cbr_pointer;    /* CBR Pointer                          */
-        u_int   filler2f[0x30 - 0x2F];
-        freg_t  prq_st_adr;     /* Packet Ready Queue Start Address     */
-        freg_t  prq_ed_adr;     /* Packet Ready Queue End Address       */
-        freg_t  prq_rd_ptr;     /* Packet Ready Queue read pointer      */
-        freg_t  prq_wr_ptr;     /* Packet Ready Queue write pointer     */
-        freg_t  tcq_st_adr;     /* Transmit Complete Queue Start Address*/
-        freg_t  tcq_ed_adr;     /* Transmit Complete Queue End Address  */
-        freg_t  tcq_rd_ptr;     /* Transmit Complete Queue read pointer */
-        freg_t  tcq_wr_ptr;     /* Transmit Complete Queue write pointer*/
-        u_int   filler38[0x40 - 0x38];
-        freg_t  queue_base;     /* Base address for PRQ and TCQ         */
-        freg_t  desc_base;      /* Base address of descriptor table     */
-        u_int   filler42[0x45 - 0x42];
-        freg_t  mode_reg_0;     /* Mode register 0                      */
-        freg_t  mode_reg_1;     /* Mode register 1                      */
-        freg_t  intr_status_reg;/* Interrupt Status register            */
-        freg_t  mask_reg;       /* Mask Register                        */
-        freg_t  cell_ctr_high1; /* Total cell transfer count (high)     */
-        freg_t  cell_ctr_lo1;   /* Total cell transfer count (low)      */
-        freg_t  state_reg;      /* Status register                      */
-        u_int   filler4c[0x58 - 0x4c];
-        freg_t  curr_desc_num;  /* Contains the current descriptor num  */
-        freg_t  next_desc;      /* Next descriptor                      */
-        freg_t  next_vc;        /* Next VC                              */
-        u_int   filler5b[0x5d - 0x5b];
-        freg_t  present_slot_cnt;/* Present slot count                  */
-        u_int   filler5e[0x6a - 0x5e];
-        freg_t  new_desc_num;   /* New descriptor number                */
-        freg_t  new_vc;         /* New VC                               */
-        freg_t  sched_tbl_ptr;  /* Schedule table pointer               */
-        freg_t  vbrwq_wptr;     /* VBR wait queue write pointer         */
-        freg_t  vbrwq_rptr;     /* VBR wait queue read pointer          */
-        freg_t  abrwq_wptr;     /* ABR wait queue write pointer         */
-        freg_t  abrwq_rptr;     /* ABR wait queue read pointer          */
-        freg_t  ubrwq_wptr;     /* UBR wait queue write pointer         */
-        freg_t  ubrwq_rptr;     /* UBR wait queue read pointer          */
-        freg_t  cbr_vc;         /* CBR VC                               */
-        freg_t  vbr_sb_vc;      /* VBR SB VC                            */
-        freg_t  abr_sb_vc;      /* ABR SB VC                            */
-        freg_t  ubr_sb_vc;      /* UBR SB VC                            */
-        freg_t  vbr_next_link;  /* VBR next link                        */
-        freg_t  abr_next_link;  /* ABR next link                        */
-        freg_t  ubr_next_link;  /* UBR next link                        */
-        u_int   filler7a[0x7c-0x7a];
-        freg_t  out_rate_head;  /* Out of rate head                     */
-        u_int   filler7d[0xca-0x7d]; /* pad out to full address space   */
-        freg_t  cell_ctr_high1_nc;/* Total cell transfer count (high)   */
-        freg_t  cell_ctr_lo1_nc;/* Total cell transfer count (low)      */
-        u_int   fillercc[0x100-0xcc]; /* pad out to full address space   */
+	ffreg_t	idlehead_high;	/* Idle cell header (high)		*/
+	ffreg_t	idlehead_low;	/* Idle cell header (low)		*/
+	ffreg_t	maxrate;	/* Maximum rate				*/
+	ffreg_t	stparms;	/* Traffic Management Parameters	*/
+	ffreg_t	abrubr_abr;	/* ABRUBR Priority Byte 1, TCR Byte 0	*/
+	ffreg_t	rm_type;	/*					*/
+	u_int	filler5[0x17 - 0x06];
+	ffreg_t	cmd_reg;	/* Command register			*/
+	u_int	filler18[0x20 - 0x18];
+	ffreg_t	cbr_base;	/* CBR Pointer Base			*/
+	ffreg_t	vbr_base;	/* VBR Pointer Base			*/
+	ffreg_t	abr_base;	/* ABR Pointer Base			*/
+	ffreg_t	ubr_base;	/* UBR Pointer Base			*/
+	u_int	filler24;
+	ffreg_t	vbrwq_base;	/* VBR Wait Queue Base			*/
+	ffreg_t	abrwq_base;	/* ABR Wait Queue Base			*/
+	ffreg_t	ubrwq_base;	/* UBR Wait Queue Base			*/
+	ffreg_t	vct_base;	/* Main VC Table Base			*/
+	ffreg_t	vcte_base;	/* Extended Main VC Table Base		*/
+	u_int	filler2a[0x2C - 0x2A];
+	ffreg_t	cbr_tab_beg;	/* CBR Table Begin			*/
+	ffreg_t	cbr_tab_end;	/* CBR Table End			*/
+	ffreg_t	cbr_pointer;	/* CBR Pointer				*/
+	u_int	filler2f[0x30 - 0x2F];
+	ffreg_t	prq_st_adr;	/* Packet Ready Queue Start Address	*/
+	ffreg_t	prq_ed_adr;	/* Packet Ready Queue End Address	*/
+	ffreg_t	prq_rd_ptr;	/* Packet Ready Queue read pointer	*/
+	ffreg_t	prq_wr_ptr;	/* Packet Ready Queue write pointer	*/
+	ffreg_t	tcq_st_adr;	/* Transmit Complete Queue Start Address*/
+	ffreg_t	tcq_ed_adr;	/* Transmit Complete Queue End Address	*/
+	ffreg_t	tcq_rd_ptr;	/* Transmit Complete Queue read pointer */
+	ffreg_t	tcq_wr_ptr;	/* Transmit Complete Queue write pointer*/
+	u_int	filler38[0x40 - 0x38];
+	ffreg_t	queue_base;	/* Base address for PRQ and TCQ		*/
+	ffreg_t	desc_base;	/* Base address of descriptor table	*/
+	u_int	filler42[0x45 - 0x42];
+	ffreg_t	mode_reg_0;	/* Mode register 0			*/
+	ffreg_t	mode_reg_1;	/* Mode register 1			*/
+	ffreg_t	intr_status_reg;/* Interrupt Status register		*/
+	ffreg_t	mask_reg;	/* Mask Register			*/
+	ffreg_t	cell_ctr_high1; /* Total cell transfer count (high)	*/
+	ffreg_t	cell_ctr_lo1;	/* Total cell transfer count (low)	*/
+	ffreg_t	state_reg;	/* Status register			*/
+	u_int	filler4c[0x58 - 0x4c];
+	ffreg_t	curr_desc_num;	/* Contains the current descriptor num	*/
+	ffreg_t	next_desc;	/* Next descriptor			*/
+	ffreg_t	next_vc;	/* Next VC				*/
+	u_int	filler5b[0x5d - 0x5b];
+	ffreg_t	present_slot_cnt;/* Present slot count			*/
+	u_int	filler5e[0x6a - 0x5e];
+	ffreg_t	new_desc_num;	/* New descriptor number		*/
+	ffreg_t	new_vc;		/* New VC				*/
+	ffreg_t	sched_tbl_ptr;	/* Schedule table pointer		*/
+	ffreg_t	vbrwq_wptr;	/* VBR wait queue write pointer		*/
+	ffreg_t	vbrwq_rptr;	/* VBR wait queue read pointer		*/
+	ffreg_t	abrwq_wptr;	/* ABR wait queue write pointer		*/
+	ffreg_t	abrwq_rptr;	/* ABR wait queue read pointer		*/
+	ffreg_t	ubrwq_wptr;	/* UBR wait queue write pointer		*/
+	ffreg_t	ubrwq_rptr;	/* UBR wait queue read pointer		*/
+	ffreg_t	cbr_vc;		/* CBR VC				*/
+	ffreg_t	vbr_sb_vc;	/* VBR SB VC				*/
+	ffreg_t	abr_sb_vc;	/* ABR SB VC				*/
+	ffreg_t	ubr_sb_vc;	/* UBR SB VC				*/
+	ffreg_t	vbr_next_link;	/* VBR next link			*/
+	ffreg_t	abr_next_link;	/* ABR next link			*/
+	ffreg_t	ubr_next_link;	/* UBR next link			*/
+	u_int	filler7a[0x7c-0x7a];
+	ffreg_t	out_rate_head;	/* Out of rate head			*/
+	u_int	filler7d[0xca-0x7d]; /* pad out to full address space	*/
+	ffreg_t	cell_ctr_high1_nc;/* Total cell transfer count (high)	*/
+	ffreg_t	cell_ctr_lo1_nc;/* Total cell transfer count (low)	*/
+	u_int	fillercc[0x100-0xcc]; /* pad out to full address space	 */
 } ffredn_t;
 
 typedef struct _rfredn_t {
diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
index 9dcf76a..31dd451 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -461,7 +461,7 @@ static int generic_request(struct vdc_port *port, u8 op, void *buf, int len)
 	int op_len, err;
 	void *req_buf;
 
-	if (!(((u64)1 << ((u64)op - 1)) & port->operations))
+	if (!(((u64)1 << (u64)op) & port->operations))
 		return -EOPNOTSUPP;
 
 	switch (op) {
diff --git a/drivers/isdn/gigaset/capi.c b/drivers/isdn/gigaset/capi.c
index 68452b7..03a0a01 100644
--- a/drivers/isdn/gigaset/capi.c
+++ b/drivers/isdn/gigaset/capi.c
@@ -248,6 +248,8 @@ static inline void dump_rawmsg(enum debuglevel level, const char *tag,
 		CAPIMSG_APPID(data), CAPIMSG_MSGID(data), l,
 		CAPIMSG_CONTROL(data));
 	l -= 12;
+	if (l <= 0)
+		return;
 	dbgline = kmalloc(3 * l, GFP_ATOMIC);
 	if (!dbgline)
 		return;
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 711eb14..3756278 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -1245,14 +1245,26 @@ static int tg3_phy_auxctl_write(struct tg3 *tp, int reg, u32 set)
 	return tg3_writephy(tp, MII_TG3_AUX_CTRL, set | reg);
 }
 
-#define TG3_PHY_AUXCTL_SMDSP_ENABLE(tp) \
-	tg3_phy_auxctl_write((tp), MII_TG3_AUXCTL_SHDWSEL_AUXCTL, \
-			     MII_TG3_AUXCTL_ACTL_SMDSP_ENA | \
-			     MII_TG3_AUXCTL_ACTL_TX_6DB)
+static int tg3_phy_toggle_auxctl_smdsp(struct tg3 *tp, bool enable)
+{
+	u32 val;
+	int err;
 
-#define TG3_PHY_AUXCTL_SMDSP_DISABLE(tp) \
-	tg3_phy_auxctl_write((tp), MII_TG3_AUXCTL_SHDWSEL_AUXCTL, \
-			     MII_TG3_AUXCTL_ACTL_TX_6DB);
+	err = tg3_phy_auxctl_read(tp, MII_TG3_AUXCTL_SHDWSEL_AUXCTL, &val);
+
+	if (err)
+		return err;
+	if (enable)
+
+		val |= MII_TG3_AUXCTL_ACTL_SMDSP_ENA;
+	else
+		val &= ~MII_TG3_AUXCTL_ACTL_SMDSP_ENA;
+
+	err = tg3_phy_auxctl_write((tp), MII_TG3_AUXCTL_SHDWSEL_AUXCTL,
+				   val | MII_TG3_AUXCTL_ACTL_TX_6DB);
+
+	return err;
+}
 
 static int tg3_bmcr_reset(struct tg3 *tp)
 {
@@ -2185,7 +2197,7 @@ static void tg3_phy_apply_otp(struct tg3 *tp)
 
 	otp = tp->phy_otp;
 
-	if (TG3_PHY_AUXCTL_SMDSP_ENABLE(tp))
+	if (tg3_phy_toggle_auxctl_smdsp(tp, true))
 		return;
 
 	phy = ((otp & TG3_OTP_AGCTGT_MASK) >> TG3_OTP_AGCTGT_SHIFT);
@@ -2210,7 +2222,7 @@ static void tg3_phy_apply_otp(struct tg3 *tp)
 	      ((otp & TG3_OTP_RCOFF_MASK) >> TG3_OTP_RCOFF_SHIFT);
 	tg3_phydsp_write(tp, MII_TG3_DSP_EXP97, phy);
 
-	TG3_PHY_AUXCTL_SMDSP_DISABLE(tp);
+	tg3_phy_toggle_auxctl_smdsp(tp, false);
 }
 
 static void tg3_phy_eee_adjust(struct tg3 *tp, u32 current_link_up)
@@ -2246,9 +2258,9 @@ static void tg3_phy_eee_adjust(struct tg3 *tp, u32 current_link_up)
 
 	if (!tp->setlpicnt) {
 		if (current_link_up == 1 &&
-		   !TG3_PHY_AUXCTL_SMDSP_ENABLE(tp)) {
+		   !tg3_phy_toggle_auxctl_smdsp(tp, true)) {
 			tg3_phydsp_write(tp, MII_TG3_DSP_TAP26, 0x0000);
-			TG3_PHY_AUXCTL_SMDSP_DISABLE(tp);
+			tg3_phy_toggle_auxctl_smdsp(tp, false);
 		}
 
 		val = tr32(TG3_CPMU_EEE_MODE);
@@ -2264,11 +2276,11 @@ static void tg3_phy_eee_enable(struct tg3 *tp)
 	    (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5717 ||
 	     GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5719 ||
 	     tg3_flag(tp, 57765_CLASS)) &&
-	    !TG3_PHY_AUXCTL_SMDSP_ENABLE(tp)) {
+	    !tg3_phy_toggle_auxctl_smdsp(tp, true)) {
 		val = MII_TG3_DSP_TAP26_ALNOKO |
 		      MII_TG3_DSP_TAP26_RMRXSTO;
 		tg3_phydsp_write(tp, MII_TG3_DSP_TAP26, val);
-		TG3_PHY_AUXCTL_SMDSP_DISABLE(tp);
+		tg3_phy_toggle_auxctl_smdsp(tp, false);
 	}
 
 	val = tr32(TG3_CPMU_EEE_MODE);
@@ -2412,7 +2424,7 @@ static int tg3_phy_reset_5703_4_5(struct tg3 *tp)
 		tg3_writephy(tp, MII_CTRL1000,
 			     CTL1000_AS_MASTER | CTL1000_ENABLE_MASTER);
 
-		err = TG3_PHY_AUXCTL_SMDSP_ENABLE(tp);
+		err = tg3_phy_toggle_auxctl_smdsp(tp, true);
 		if (err)
 			return err;
 
@@ -2433,7 +2445,7 @@ static int tg3_phy_reset_5703_4_5(struct tg3 *tp)
 	tg3_writephy(tp, MII_TG3_DSP_ADDRESS, 0x8200);
 	tg3_writephy(tp, MII_TG3_DSP_CONTROL, 0x0000);
 
-	TG3_PHY_AUXCTL_SMDSP_DISABLE(tp);
+	tg3_phy_toggle_auxctl_smdsp(tp, false);
 
 	tg3_writephy(tp, MII_CTRL1000, phy9_orig);
 
@@ -2522,10 +2534,10 @@ static int tg3_phy_reset(struct tg3 *tp)
 
 out:
 	if ((tp->phy_flags & TG3_PHYFLG_ADC_BUG) &&
-	    !TG3_PHY_AUXCTL_SMDSP_ENABLE(tp)) {
+	    !tg3_phy_toggle_auxctl_smdsp(tp, true)) {
 		tg3_phydsp_write(tp, 0x201f, 0x2aaa);
 		tg3_phydsp_write(tp, 0x000a, 0x0323);
-		TG3_PHY_AUXCTL_SMDSP_DISABLE(tp);
+		tg3_phy_toggle_auxctl_smdsp(tp, false);
 	}
 
 	if (tp->phy_flags & TG3_PHYFLG_5704_A0_BUG) {
@@ -2534,14 +2546,14 @@ out:
 	}
 
 	if (tp->phy_flags & TG3_PHYFLG_BER_BUG) {
-		if (!TG3_PHY_AUXCTL_SMDSP_ENABLE(tp)) {
+		if (!tg3_phy_toggle_auxctl_smdsp(tp, true)) {
 			tg3_phydsp_write(tp, 0x000a, 0x310b);
 			tg3_phydsp_write(tp, 0x201f, 0x9506);
 			tg3_phydsp_write(tp, 0x401f, 0x14e2);
-			TG3_PHY_AUXCTL_SMDSP_DISABLE(tp);
+			tg3_phy_toggle_auxctl_smdsp(tp, false);
 		}
 	} else if (tp->phy_flags & TG3_PHYFLG_JITTER_BUG) {
-		if (!TG3_PHY_AUXCTL_SMDSP_ENABLE(tp)) {
+		if (!tg3_phy_toggle_auxctl_smdsp(tp, true)) {
 			tg3_writephy(tp, MII_TG3_DSP_ADDRESS, 0x000a);
 			if (tp->phy_flags & TG3_PHYFLG_ADJUST_TRIM) {
 				tg3_writephy(tp, MII_TG3_DSP_RW_PORT, 0x110b);
@@ -2550,7 +2562,7 @@ out:
 			} else
 				tg3_writephy(tp, MII_TG3_DSP_RW_PORT, 0x010b);
 
-			TG3_PHY_AUXCTL_SMDSP_DISABLE(tp);
+			tg3_phy_toggle_auxctl_smdsp(tp, false);
 		}
 	}
 
@@ -3967,7 +3979,7 @@ static int tg3_phy_autoneg_cfg(struct tg3 *tp, u32 advertise, u32 flowctrl)
 	tw32(TG3_CPMU_EEE_MODE,
 	     tr32(TG3_CPMU_EEE_MODE) & ~TG3_CPMU_EEEMD_LPI_ENABLE);
 
-	err = TG3_PHY_AUXCTL_SMDSP_ENABLE(tp);
+	err = tg3_phy_toggle_auxctl_smdsp(tp, true);
 	if (!err) {
 		u32 err2;
 
@@ -4000,7 +4012,7 @@ static int tg3_phy_autoneg_cfg(struct tg3 *tp, u32 advertise, u32 flowctrl)
 						 MII_TG3_DSP_CH34TP2_HIBW01);
 		}
 
-		err2 = TG3_PHY_AUXCTL_SMDSP_DISABLE(tp);
+		err2 = tg3_phy_toggle_auxctl_smdsp(tp, false);
 		if (!err)
 			err = err2;
 	}
@@ -6703,6 +6715,9 @@ static void tg3_poll_controller(struct net_device *dev)
 	int i;
 	struct tg3 *tp = netdev_priv(dev);
 
+	if (tg3_irq_sync(tp))
+		return;
+
 	for (i = 0; i < tp->irq_cnt; i++)
 		tg3_interrupt(tp->napi[i].irq_vec, &tp->napi[i]);
 }
@@ -15806,6 +15821,7 @@ static int __devinit tg3_init_one(struct pci_dev *pdev,
 	tp->pm_cap = pm_cap;
 	tp->rx_mode = TG3_DEF_RX_MODE;
 	tp->tx_mode = TG3_DEF_TX_MODE;
+	tp->irq_sync = 1;
 
 	if (tg3_debug > 0)
 		tp->msg_enable = tg3_debug;
diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index 16814b3..e29c1b6 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -546,6 +546,10 @@ static int desc_get_rx_status(struct xgmac_priv *priv, struct xgmac_dma_desc *p)
 		return -1;
 	}
 
+	/* All frames should fit into a single buffer */
+	if (!(status & RXDESC_FIRST_SEG) || !(status & RXDESC_LAST_SEG))
+		return -1;
+
 	/* Check if packet has checksum already */
 	if ((status & RXDESC_FRAME_TYPE) && (status & RXDESC_EXT_STATUS) &&
 		!(ext_status & RXDESC_IP_PAYLOAD_MASK))
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index edd9cb8..aa9122f 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -1435,7 +1435,7 @@ int mlx4_en_alloc_resources(struct mlx4_en_priv *priv)
 	}
 
 #ifdef CONFIG_RFS_ACCEL
-	priv->dev->rx_cpu_rmap = alloc_irq_cpu_rmap(priv->rx_ring_num);
+	priv->dev->rx_cpu_rmap = alloc_irq_cpu_rmap(priv->mdev->dev->caps.comp_pool);
 	if (!priv->dev->rx_cpu_rmap)
 		goto err;
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index 10bba09..2af24ba 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -630,10 +630,15 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
 		ring->tx_csum++;
 	}
 
-	/* Copy dst mac address to wqe */
-	ethh = (struct ethhdr *)skb->data;
-	tx_desc->ctrl.srcrb_flags16[0] = get_unaligned((__be16 *)ethh->h_dest);
-	tx_desc->ctrl.imm = get_unaligned((__be32 *)(ethh->h_dest + 2));
+	if (mlx4_is_mfunc(mdev->dev) || priv->validate_loopback) {
+		/* Copy dst mac address to wqe. This allows loopback in eSwitch,
+		 * so that VFs and PF can communicate with each other
+		 */
+		ethh = (struct ethhdr *)skb->data;
+		tx_desc->ctrl.srcrb_flags16[0] = get_unaligned((__be16 *)ethh->h_dest);
+		tx_desc->ctrl.imm = get_unaligned((__be32 *)(ethh->h_dest + 2));
+	}
+
 	/* Handle LSO (TSO) packets */
 	if (lso_header_size) {
 		/* Mark opcode as LSO */
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 2f816c6..8ca1ed8 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -1630,15 +1630,8 @@ static void mlx4_enable_msi_x(struct mlx4_dev *dev)
 	int i;
 
 	if (msi_x) {
-		/* In multifunction mode each function gets 2 msi-X vectors
-		 * one for data path completions anf the other for asynch events
-		 * or command completions */
-		if (mlx4_is_mfunc(dev)) {
-			nreq = 2;
-		} else {
-			nreq = min_t(int, dev->caps.num_eqs -
-				     dev->caps.reserved_eqs, nreq);
-		}
+		nreq = min_t(int, dev->caps.num_eqs - dev->caps.reserved_eqs,
+			     nreq);
 
 		entries = kcalloc(nreq, sizeof *entries, GFP_KERNEL);
 		if (!entries)
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
index bc165f4d..695667d 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
@@ -144,7 +144,7 @@ void netxen_release_tx_buffers(struct netxen_adapter *adapter)
 					 buffrag->length, PCI_DMA_TODEVICE);
 			buffrag->dma = 0ULL;
 		}
-		for (j = 0; j < cmd_buf->frag_count; j++) {
+		for (j = 1; j < cmd_buf->frag_count; j++) {
 			buffrag++;
 			if (buffrag->dma) {
 				pci_unmap_page(adapter->pdev, buffrag->dma,
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index a77c558..d6a8218 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -1963,10 +1963,12 @@ unwind:
 	while (--i >= 0) {
 		nf = &pbuf->frag_array[i+1];
 		pci_unmap_page(pdev, nf->dma, nf->length, PCI_DMA_TODEVICE);
+		nf->dma = 0ULL;
 	}
 
 	nf = &pbuf->frag_array[0];
 	pci_unmap_single(pdev, nf->dma, skb_headlen(skb), PCI_DMA_TODEVICE);
+	nf->dma = 0ULL;
 
 out_err:
 	return -ENOMEM;
diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index df7bbba..6c1c396 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -6088,13 +6088,6 @@ process_pkt:
 			tp->rx_stats.bytes += pkt_size;
 			u64_stats_update_end(&tp->rx_stats.syncp);
 		}
-
-		/* Work around for AMD plateform. */
-		if ((desc->opts2 & cpu_to_le32(0xfffe000)) &&
-		    (tp->mac_version == RTL_GIGA_MAC_VER_05)) {
-			desc->opts2 = 0;
-			cur_rx++;
-		}
 	}
 
 	count = cur_rx - tp->cur_rx;
diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
index 0459c09..046526e0 100644
--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -1802,7 +1802,7 @@ static void rhine_tx(struct net_device *dev)
 					 rp->tx_skbuff[entry]->len,
 					 PCI_DMA_TODEVICE);
 		}
-		dev_kfree_skb_irq(rp->tx_skbuff[entry]);
+		dev_kfree_skb(rp->tx_skbuff[entry]);
 		rp->tx_skbuff[entry] = NULL;
 		entry = (++rp->dirty_tx) % TX_RING_SIZE;
 	}
@@ -2011,11 +2011,7 @@ static void rhine_slow_event_task(struct work_struct *work)
 	if (intr_status & IntrPCIErr)
 		netif_warn(rp, hw, dev, "PCI error\n");
 
-	napi_disable(&rp->napi);
-	rhine_irq_disable(rp);
-	/* Slow and safe. Consider __napi_schedule as a replacement ? */
-	napi_enable(&rp->napi);
-	napi_schedule(&rp->napi);
+	iowrite16(RHINE_EVENT & 0xffff, rp->base + IntrEnable);
 
 out_unlock:
 	mutex_unlock(&rp->task_lock);
diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index e2a06fd..ba61c33 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -77,6 +77,11 @@ static netdev_tx_t loopback_xmit(struct sk_buff *skb,
 
 	skb_orphan(skb);
 
+	/* Before queueing this packet to netif_rx(),
+	 * make sure dst is refcounted.
+	 */
+	skb_dst_force(skb);
+
 	skb->protocol = eth_type_trans(skb, dev);
 
 	/* it's OK to use per_cpu_ptr() because BHs are off */
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 66a9bfe..666fc20 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -628,6 +628,7 @@ void macvlan_common_setup(struct net_device *dev)
 	ether_setup(dev);
 
 	dev->priv_flags	       &= ~(IFF_XMIT_DST_RELEASE | IFF_TX_SKB_SHARING);
+	dev->priv_flags	       |= IFF_UNICAST_FLT;
 	dev->netdev_ops		= &macvlan_netdev_ops;
 	dev->destructor		= free_netdev;
 	dev->header_ops		= &macvlan_hard_header_ops,
@@ -822,7 +823,10 @@ static int macvlan_changelink(struct net_device *dev,
 
 static size_t macvlan_get_size(const struct net_device *dev)
 {
-	return nla_total_size(4);
+	return (0
+		+ nla_total_size(4) /* IFLA_MACVLAN_MODE */
+		+ nla_total_size(2) /* IFLA_MACVLAN_FLAGS */
+		);
 }
 
 static int macvlan_fill_info(struct sk_buff *skb,
diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 5c05572..2603b99 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -1021,7 +1021,15 @@ ppp_net_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	return err;
 }
 
+static struct lock_class_key ppp_tx_busylock;
+static int ppp_dev_init(struct net_device *dev)
+{
+	dev->qdisc_tx_busylock = &ppp_tx_busylock;
+	return 0;
+}
+
 static const struct net_device_ops ppp_netdev_ops = {
+	.ndo_init	 = ppp_dev_init,
 	.ndo_start_xmit = ppp_start_xmit,
 	.ndo_do_ioctl   = ppp_net_ioctl,
 };
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index f8cd61f..8a11070 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1008,6 +1008,8 @@ static int team_port_del(struct team *team, struct net_device *port_dev)
 	netdev_set_master(port_dev, NULL);
 	team_port_disable_netpoll(port);
 	vlan_vids_del_by_dev(port_dev, dev);
+	dev_uc_unsync(port_dev, dev);
+	dev_mc_unsync(port_dev, dev);
 	dev_close(port_dev);
 	team_port_leave(team, port);
 	team_port_set_orig_mac(port);
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 3a16d4f..ef7710f 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -421,6 +421,8 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 		goto drop;
 	skb_orphan(skb);
 
+	nf_reset(skb);
+
 	/* Enqueue packet */
 	skb_queue_tail(&tun->socket.sk->sk_receive_queue, skb);
 
diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
index 94b79c3..9d7f172 100644
--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -151,6 +151,9 @@ void xen_netbk_queue_tx_skb(struct xenvif *vif, struct sk_buff *skb);
 /* Notify xenvif that ring now has space to send an skb to the frontend */
 void xenvif_notify_tx_completion(struct xenvif *vif);
 
+/* Prevent the device from generating any further traffic. */
+void xenvif_carrier_off(struct xenvif *vif);
+
 /* Returns number of ring slots required to send an skb to the frontend */
 unsigned int xen_netbk_count_skb_slots(struct xenvif *vif, struct sk_buff *skb);
 
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index b7d41f8..221f426 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -132,6 +132,7 @@ static void xenvif_up(struct xenvif *vif)
 static void xenvif_down(struct xenvif *vif)
 {
 	disable_irq(vif->irq);
+	del_timer_sync(&vif->credit_timeout);
 	xen_netbk_deschedule_xenvif(vif);
 	xen_netbk_remove_xenvif(vif);
 }
@@ -343,23 +344,26 @@ err:
 	return err;
 }
 
-void xenvif_disconnect(struct xenvif *vif)
+void xenvif_carrier_off(struct xenvif *vif)
 {
 	struct net_device *dev = vif->dev;
-	if (netif_carrier_ok(dev)) {
-		rtnl_lock();
-		netif_carrier_off(dev); /* discard queued packets */
-		if (netif_running(dev))
-			xenvif_down(vif);
-		rtnl_unlock();
-		xenvif_put(vif);
-	}
+
+	rtnl_lock();
+	netif_carrier_off(dev); /* discard queued packets */
+	if (netif_running(dev))
+		xenvif_down(vif);
+	rtnl_unlock();
+	xenvif_put(vif);
+}
+
+void xenvif_disconnect(struct xenvif *vif)
+{
+	if (netif_carrier_ok(vif->dev))
+		xenvif_carrier_off(vif);
 
 	atomic_dec(&vif->refcnt);
 	wait_event(vif->waiting_to_free, atomic_read(&vif->refcnt) == 0);
 
-	del_timer_sync(&vif->credit_timeout);
-
 	if (vif->irq)
 		unbind_from_irqhandler(vif->irq, vif);
 
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 682633b..6aa059e 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -146,7 +146,8 @@ void xen_netbk_remove_xenvif(struct xenvif *vif)
 	atomic_dec(&netbk->netfront_count);
 }
 
-static void xen_netbk_idx_release(struct xen_netbk *netbk, u16 pending_idx);
+static void xen_netbk_idx_release(struct xen_netbk *netbk, u16 pending_idx,
+				  u8 status);
 static void make_tx_response(struct xenvif *vif,
 			     struct xen_netif_tx_request *txp,
 			     s8       st);
@@ -850,7 +851,7 @@ static void netbk_tx_err(struct xenvif *vif,
 
 	do {
 		make_tx_response(vif, txp, XEN_NETIF_RSP_ERROR);
-		if (cons >= end)
+		if (cons == end)
 			break;
 		txp = RING_GET_REQUEST(&vif->tx, cons++);
 	} while (1);
@@ -859,6 +860,13 @@ static void netbk_tx_err(struct xenvif *vif,
 	xenvif_put(vif);
 }
 
+static void netbk_fatal_tx_err(struct xenvif *vif)
+{
+	netdev_err(vif->dev, "fatal error; disabling device\n");
+	xenvif_carrier_off(vif);
+	xenvif_put(vif);
+}
+
 static int netbk_count_requests(struct xenvif *vif,
 				struct xen_netif_tx_request *first,
 				struct xen_netif_tx_request *txp,
@@ -872,29 +880,33 @@ static int netbk_count_requests(struct xenvif *vif,
 
 	do {
 		if (frags >= work_to_do) {
-			netdev_dbg(vif->dev, "Need more frags\n");
-			return -frags;
+			netdev_err(vif->dev, "Need more frags\n");
+			netbk_fatal_tx_err(vif);
+			return -ENODATA;
 		}
 
 		if (unlikely(frags >= MAX_SKB_FRAGS)) {
-			netdev_dbg(vif->dev, "Too many frags\n");
-			return -frags;
+			netdev_err(vif->dev, "Too many frags\n");
+			netbk_fatal_tx_err(vif);
+			return -E2BIG;
 		}
 
 		memcpy(txp, RING_GET_REQUEST(&vif->tx, cons + frags),
 		       sizeof(*txp));
 		if (txp->size > first->size) {
-			netdev_dbg(vif->dev, "Frags galore\n");
-			return -frags;
+			netdev_err(vif->dev, "Frag is bigger than frame.\n");
+			netbk_fatal_tx_err(vif);
+			return -EIO;
 		}
 
 		first->size -= txp->size;
 		frags++;
 
 		if (unlikely((txp->offset + txp->size) > PAGE_SIZE)) {
-			netdev_dbg(vif->dev, "txp->offset: %x, size: %u\n",
+			netdev_err(vif->dev, "txp->offset: %x, size: %u\n",
 				 txp->offset, txp->size);
-			return -frags;
+			netbk_fatal_tx_err(vif);
+			return -EINVAL;
 		}
 	} while ((txp++)->flags & XEN_NETTXF_more_data);
 	return frags;
@@ -937,7 +949,7 @@ static struct gnttab_copy *xen_netbk_get_requests(struct xen_netbk *netbk,
 		pending_idx = netbk->pending_ring[index];
 		page = xen_netbk_alloc_page(netbk, skb, pending_idx);
 		if (!page)
-			return NULL;
+			goto err;
 
 		gop->source.u.ref = txp->gref;
 		gop->source.domid = vif->domid;
@@ -959,6 +971,17 @@ static struct gnttab_copy *xen_netbk_get_requests(struct xen_netbk *netbk,
 	}
 
 	return gop;
+err:
+	/* Unwind, freeing all pages and sending error responses. */
+	while (i-- > start) {
+		xen_netbk_idx_release(netbk, frag_get_pending_idx(&frags[i]),
+				      XEN_NETIF_RSP_ERROR);
+	}
+	/* The head too, if necessary. */
+	if (start)
+		xen_netbk_idx_release(netbk, pending_idx, XEN_NETIF_RSP_ERROR);
+
+	return NULL;
 }
 
 static int xen_netbk_tx_check_gop(struct xen_netbk *netbk,
@@ -967,30 +990,20 @@ static int xen_netbk_tx_check_gop(struct xen_netbk *netbk,
 {
 	struct gnttab_copy *gop = *gopp;
 	u16 pending_idx = *((u16 *)skb->data);
-	struct pending_tx_info *pending_tx_info = netbk->pending_tx_info;
-	struct xenvif *vif = pending_tx_info[pending_idx].vif;
-	struct xen_netif_tx_request *txp;
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
 	int nr_frags = shinfo->nr_frags;
 	int i, err, start;
 
 	/* Check status of header. */
 	err = gop->status;
-	if (unlikely(err)) {
-		pending_ring_idx_t index;
-		index = pending_index(netbk->pending_prod++);
-		txp = &pending_tx_info[pending_idx].req;
-		make_tx_response(vif, txp, XEN_NETIF_RSP_ERROR);
-		netbk->pending_ring[index] = pending_idx;
-		xenvif_put(vif);
-	}
+	if (unlikely(err))
+		xen_netbk_idx_release(netbk, pending_idx, XEN_NETIF_RSP_ERROR);
 
 	/* Skip first skb fragment if it is on same page as header fragment. */
 	start = (frag_get_pending_idx(&shinfo->frags[0]) == pending_idx);
 
 	for (i = start; i < nr_frags; i++) {
 		int j, newerr;
-		pending_ring_idx_t index;
 
 		pending_idx = frag_get_pending_idx(&shinfo->frags[i]);
 
@@ -999,16 +1012,12 @@ static int xen_netbk_tx_check_gop(struct xen_netbk *netbk,
 		if (likely(!newerr)) {
 			/* Had a previous error? Invalidate this fragment. */
 			if (unlikely(err))
-				xen_netbk_idx_release(netbk, pending_idx);
+				xen_netbk_idx_release(netbk, pending_idx, XEN_NETIF_RSP_OKAY);
 			continue;
 		}
 
 		/* Error on this fragment: respond to client with an error. */
-		txp = &netbk->pending_tx_info[pending_idx].req;
-		make_tx_response(vif, txp, XEN_NETIF_RSP_ERROR);
-		index = pending_index(netbk->pending_prod++);
-		netbk->pending_ring[index] = pending_idx;
-		xenvif_put(vif);
+		xen_netbk_idx_release(netbk, pending_idx, XEN_NETIF_RSP_ERROR);
 
 		/* Not the first error? Preceding frags already invalidated. */
 		if (err)
@@ -1016,10 +1025,10 @@ static int xen_netbk_tx_check_gop(struct xen_netbk *netbk,
 
 		/* First error: invalidate header and preceding fragments. */
 		pending_idx = *((u16 *)skb->data);
-		xen_netbk_idx_release(netbk, pending_idx);
+		xen_netbk_idx_release(netbk, pending_idx, XEN_NETIF_RSP_OKAY);
 		for (j = start; j < i; j++) {
 			pending_idx = frag_get_pending_idx(&shinfo->frags[j]);
-			xen_netbk_idx_release(netbk, pending_idx);
+			xen_netbk_idx_release(netbk, pending_idx, XEN_NETIF_RSP_OKAY);
 		}
 
 		/* Remember the error: invalidate all subsequent fragments. */
@@ -1053,7 +1062,7 @@ static void xen_netbk_fill_frags(struct xen_netbk *netbk, struct sk_buff *skb)
 
 		/* Take an extra reference to offset xen_netbk_idx_release */
 		get_page(netbk->mmap_pages[pending_idx]);
-		xen_netbk_idx_release(netbk, pending_idx);
+		xen_netbk_idx_release(netbk, pending_idx, XEN_NETIF_RSP_OKAY);
 	}
 }
 
@@ -1066,7 +1075,8 @@ static int xen_netbk_get_extras(struct xenvif *vif,
 
 	do {
 		if (unlikely(work_to_do-- <= 0)) {
-			netdev_dbg(vif->dev, "Missing extra info\n");
+			netdev_err(vif->dev, "Missing extra info\n");
+			netbk_fatal_tx_err(vif);
 			return -EBADR;
 		}
 
@@ -1075,8 +1085,9 @@ static int xen_netbk_get_extras(struct xenvif *vif,
 		if (unlikely(!extra.type ||
 			     extra.type >= XEN_NETIF_EXTRA_TYPE_MAX)) {
 			vif->tx.req_cons = ++cons;
-			netdev_dbg(vif->dev,
+			netdev_err(vif->dev,
 				   "Invalid extra type: %d\n", extra.type);
+			netbk_fatal_tx_err(vif);
 			return -EINVAL;
 		}
 
@@ -1092,13 +1103,15 @@ static int netbk_set_skb_gso(struct xenvif *vif,
 			     struct xen_netif_extra_info *gso)
 {
 	if (!gso->u.gso.size) {
-		netdev_dbg(vif->dev, "GSO size must not be zero.\n");
+		netdev_err(vif->dev, "GSO size must not be zero.\n");
+		netbk_fatal_tx_err(vif);
 		return -EINVAL;
 	}
 
 	/* Currently only TCPv4 S.O. is supported. */
 	if (gso->u.gso.type != XEN_NETIF_GSO_TYPE_TCPV4) {
-		netdev_dbg(vif->dev, "Bad GSO type %d.\n", gso->u.gso.type);
+		netdev_err(vif->dev, "Bad GSO type %d.\n", gso->u.gso.type);
+		netbk_fatal_tx_err(vif);
 		return -EINVAL;
 	}
 
@@ -1235,9 +1248,25 @@ static unsigned xen_netbk_tx_build_gops(struct xen_netbk *netbk)
 
 		/* Get a netif from the list with work to do. */
 		vif = poll_net_schedule_list(netbk);
+		/* This can sometimes happen because the test of
+		 * list_empty(net_schedule_list) at the top of the
+		 * loop is unlocked.  Just go back and have another
+		 * look.
+		 */
 		if (!vif)
 			continue;
 
+		if (vif->tx.sring->req_prod - vif->tx.req_cons >
+		    XEN_NETIF_TX_RING_SIZE) {
+			netdev_err(vif->dev,
+				   "Impossible number of requests. "
+				   "req_prod %d, req_cons %d, size %ld\n",
+				   vif->tx.sring->req_prod, vif->tx.req_cons,
+				   XEN_NETIF_TX_RING_SIZE);
+			netbk_fatal_tx_err(vif);
+			continue;
+		}
+
 		RING_FINAL_CHECK_FOR_REQUESTS(&vif->tx, work_to_do);
 		if (!work_to_do) {
 			xenvif_put(vif);
@@ -1265,17 +1294,14 @@ static unsigned xen_netbk_tx_build_gops(struct xen_netbk *netbk)
 			work_to_do = xen_netbk_get_extras(vif, extras,
 							  work_to_do);
 			idx = vif->tx.req_cons;
-			if (unlikely(work_to_do < 0)) {
-				netbk_tx_err(vif, &txreq, idx);
+			if (unlikely(work_to_do < 0))
 				continue;
-			}
 		}
 
 		ret = netbk_count_requests(vif, &txreq, txfrags, work_to_do);
-		if (unlikely(ret < 0)) {
-			netbk_tx_err(vif, &txreq, idx - ret);
+		if (unlikely(ret < 0))
 			continue;
-		}
+
 		idx += ret;
 
 		if (unlikely(txreq.size < ETH_HLEN)) {
@@ -1287,11 +1313,11 @@ static unsigned xen_netbk_tx_build_gops(struct xen_netbk *netbk)
 
 		/* No crossing a page as the payload mustn't fragment. */
 		if (unlikely((txreq.offset + txreq.size) > PAGE_SIZE)) {
-			netdev_dbg(vif->dev,
+			netdev_err(vif->dev,
 				   "txreq.offset: %x, size: %u, end: %lu\n",
 				   txreq.offset, txreq.size,
 				   (txreq.offset&~PAGE_MASK) + txreq.size);
-			netbk_tx_err(vif, &txreq, idx);
+			netbk_fatal_tx_err(vif);
 			continue;
 		}
 
@@ -1319,8 +1345,8 @@ static unsigned xen_netbk_tx_build_gops(struct xen_netbk *netbk)
 			gso = &extras[XEN_NETIF_EXTRA_TYPE_GSO - 1];
 
 			if (netbk_set_skb_gso(vif, skb, gso)) {
+				/* Failure in netbk_set_skb_gso is fatal. */
 				kfree_skb(skb);
-				netbk_tx_err(vif, &txreq, idx);
 				continue;
 			}
 		}
@@ -1419,7 +1445,7 @@ static void xen_netbk_tx_submit(struct xen_netbk *netbk)
 			txp->size -= data_len;
 		} else {
 			/* Schedule a response immediately. */
-			xen_netbk_idx_release(netbk, pending_idx);
+			xen_netbk_idx_release(netbk, pending_idx, XEN_NETIF_RSP_OKAY);
 		}
 
 		if (txp->flags & XEN_NETTXF_csum_blank)
@@ -1474,7 +1500,8 @@ static void xen_netbk_tx_action(struct xen_netbk *netbk)
 
 }
 
-static void xen_netbk_idx_release(struct xen_netbk *netbk, u16 pending_idx)
+static void xen_netbk_idx_release(struct xen_netbk *netbk, u16 pending_idx,
+				  u8 status)
 {
 	struct xenvif *vif;
 	struct pending_tx_info *pending_tx_info;
@@ -1488,7 +1515,7 @@ static void xen_netbk_idx_release(struct xen_netbk *netbk, u16 pending_idx)
 
 	vif = pending_tx_info->vif;
 
-	make_tx_response(vif, &pending_tx_info->req, XEN_NETIF_RSP_OKAY);
+	make_tx_response(vif, &pending_tx_info->req, status);
 
 	index = pending_index(netbk->pending_prod++);
 	netbk->pending_ring[index] = pending_idx;
diff --git a/fs/splice.c b/fs/splice.c
index 41514dd..c69fbb7 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -696,8 +696,10 @@ static int pipe_to_sendpage(struct pipe_inode_info *pipe,
 		return -EINVAL;
 
 	more = (sd->flags & SPLICE_F_MORE) ? MSG_MORE : 0;
-	if (sd->len < sd->total_len)
+
+	if (sd->len < sd->total_len && pipe->nrbufs > 1)
 		more |= MSG_SENDPAGE_NOTLAST;
+
 	return file->f_op->sendpage(file, buf->page, buf->offset,
 				    sd->len, &pos, more);
 }
diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 561e130..9b0c614 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -327,7 +327,7 @@ static inline void vlan_set_encap_proto(struct sk_buff *skb,
 					struct vlan_hdr *vhdr)
 {
 	__be16 proto;
-	unsigned char *rawp;
+	unsigned short *rawp;
 
 	/*
 	 * Was a VLAN packet, grab the encapsulated protocol, which the layer
@@ -340,8 +340,8 @@ static inline void vlan_set_encap_proto(struct sk_buff *skb,
 		return;
 	}
 
-	rawp = skb->data;
-	if (*(unsigned short *) rawp == 0xFFFF)
+	rawp = (unsigned short *)(vhdr + 1);
+	if (*rawp == 0xFFFF)
 		/*
 		 * This is a magic hack to spot IPX packets. Older Novell
 		 * breaks the protocol design and runs IPX over 802.3 without
diff --git a/include/net/dst.h b/include/net/dst.h
index 621e351..3e3fffe 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -36,13 +36,9 @@ struct dst_entry {
 	struct net_device       *dev;
 	struct  dst_ops	        *ops;
 	unsigned long		_metrics;
-	union {
-		unsigned long           expires;
-		/* point to where the dst_entry copied from */
-		struct dst_entry        *from;
-	};
+	unsigned long           expires;
 	struct dst_entry	*path;
-	void			*__pad0;
+	struct dst_entry	*from;
 #ifdef CONFIG_XFRM
 	struct xfrm_state	*xfrm;
 #else
diff --git a/include/net/icmp.h b/include/net/icmp.h
index 9ac2524..081439f 100644
--- a/include/net/icmp.h
+++ b/include/net/icmp.h
@@ -41,6 +41,7 @@ struct net;
 
 extern void	icmp_send(struct sk_buff *skb_in,  int type, int code, __be32 info);
 extern int	icmp_rcv(struct sk_buff *skb);
+extern void	icmp_err(struct sk_buff *, u32 info);
 extern int	icmp_init(void);
 extern void	icmp_out_count(struct net *net, unsigned char type);
 
diff --git a/include/net/inet6_hashtables.h b/include/net/inet6_hashtables.h
index 9e34c87..f071f50 100644
--- a/include/net/inet6_hashtables.h
+++ b/include/net/inet6_hashtables.h
@@ -28,16 +28,16 @@
 
 struct inet_hashinfo;
 
-/* I have no idea if this is a good hash for v6 or not. -DaveM */
 static inline unsigned int inet6_ehashfn(struct net *net,
 				const struct in6_addr *laddr, const u16 lport,
 				const struct in6_addr *faddr, const __be16 fport)
 {
-	u32 ports = (lport ^ (__force u16)fport);
+	u32 ports = (((u32)lport) << 16) | (__force u32)fport;
 
 	return jhash_3words((__force u32)laddr->s6_addr32[3],
-			    (__force u32)faddr->s6_addr32[3],
-			    ports, inet_ehash_secret + net_hash_mix(net));
+			    ipv6_addr_jhash(faddr),
+			    ports,
+			    inet_ehash_secret + net_hash_mix(net));
 }
 
 static inline int inet6_sk_ehashfn(const struct sock *sk)
diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index ba1d361..1832927 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -318,6 +318,7 @@ extern void inet_csk_reqsk_queue_prune(struct sock *parent,
 				       const unsigned long max_rto);
 
 extern void inet_csk_destroy_sock(struct sock *sk);
+extern void inet_csk_prepare_forced_close(struct sock *sk);
 
 /*
  * LISTEN is a special case for poll..
diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index 613cfa4..8eac4a9 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -203,6 +203,7 @@ static inline void inet_sk_copy_descendant(struct sock *sk_to,
 extern int inet_sk_rebuild_header(struct sock *sk);
 
 extern u32 inet_ehash_secret;
+extern u32 ipv6_hash_secret;
 extern void build_ehash_secret(void);
 
 static inline unsigned int inet_ehashfn(struct net *net,
diff --git a/include/net/ip.h b/include/net/ip.h
index 5a5d84d..2d03843 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -141,6 +141,8 @@ static inline struct sk_buff *ip_finish_skb(struct sock *sk, struct flowi4 *fl4)
 extern int		ip4_datagram_connect(struct sock *sk, 
 					     struct sockaddr *uaddr, int addr_len);
 
+extern void ip4_datagram_release_cb(struct sock *sk);
+
 struct ip_reply_arg {
 	struct kvec iov[1];   
 	int	    flags;
diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 9fc7114..0235de8 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -156,50 +156,35 @@ static inline struct inet6_dev *ip6_dst_idev(struct dst_entry *dst)
 
 static inline void rt6_clean_expires(struct rt6_info *rt)
 {
-	if (!(rt->rt6i_flags & RTF_EXPIRES) && rt->dst.from)
-		dst_release(rt->dst.from);
-
 	rt->rt6i_flags &= ~RTF_EXPIRES;
-	rt->dst.from = NULL;
 }
 
 static inline void rt6_set_expires(struct rt6_info *rt, unsigned long expires)
 {
-	if (!(rt->rt6i_flags & RTF_EXPIRES) && rt->dst.from)
-		dst_release(rt->dst.from);
-
-	rt->rt6i_flags |= RTF_EXPIRES;
 	rt->dst.expires = expires;
+	rt->rt6i_flags |= RTF_EXPIRES;
 }
 
-static inline void rt6_update_expires(struct rt6_info *rt, int timeout)
+static inline void rt6_update_expires(struct rt6_info *rt0, int timeout)
 {
-	if (!(rt->rt6i_flags & RTF_EXPIRES)) {
-		if (rt->dst.from)
-			dst_release(rt->dst.from);
-		/* dst_set_expires relies on expires == 0 
-		 * if it has not been set previously.
-		 */
-		rt->dst.expires = 0;
-	}
-
-	dst_set_expires(&rt->dst, timeout);
-	rt->rt6i_flags |= RTF_EXPIRES;
+	struct rt6_info *rt;
+
+	for (rt = rt0; rt && !(rt->rt6i_flags & RTF_EXPIRES);
+	     rt = (struct rt6_info *)rt->dst.from);
+	if (rt && rt != rt0)
+		rt0->dst.expires = rt->dst.expires;
+
+	dst_set_expires(&rt0->dst, timeout);
+	rt0->rt6i_flags |= RTF_EXPIRES;
 }
 
 static inline void rt6_set_from(struct rt6_info *rt, struct rt6_info *from)
 {
 	struct dst_entry *new = (struct dst_entry *) from;
 
-	if (!(rt->rt6i_flags & RTF_EXPIRES) && rt->dst.from) {
-		if (new == rt->dst.from)
-			return;
-		dst_release(rt->dst.from);
-	}
-
 	rt->rt6i_flags &= ~RTF_EXPIRES;
-	rt->dst.from = new;
 	dst_hold(new);
+	rt->dst.from = new;
 }
 
 struct fib6_walker_t {
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 01c34b3..640591f 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -15,6 +15,7 @@
 
 #include <linux/ipv6.h>
 #include <linux/hardirq.h>
+#include <linux/jhash.h>
 #include <net/if_inet6.h>
 #include <net/ndisc.h>
 #include <net/flow.h>
@@ -432,6 +433,17 @@ static inline u32 ipv6_addr_hash(const struct in6_addr *a)
 #endif
 }
 
+/* more secured version of ipv6_addr_hash() */
+static inline u32 ipv6_addr_jhash(const struct in6_addr *a)
+{
+	u32 v = (__force u32)a->s6_addr32[0] ^ (__force u32)a->s6_addr32[1];
+
+	return jhash_3words(v,
+			    (__force u32)a->s6_addr32[2],
+			    (__force u32)a->s6_addr32[3],
+			    ipv6_hash_secret);
+}
+
 static inline bool ipv6_addr_loopback(const struct in6_addr *a)
 {
 	return (a->s6_addr32[0] | a->s6_addr32[1] |
diff --git a/include/net/ndisc.h b/include/net/ndisc.h
index 96a3b5c..826a541 100644
--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -77,6 +77,13 @@ struct ra_msg {
 	__be32			retrans_timer;
 };
 
+struct rd_msg {
+	struct icmp6hdr icmph;
+	struct in6_addr	target;
+	struct in6_addr	dest;
+	__u8		opt[0];
+};
+
 struct nd_opt_hdr {
 	__u8		nd_opt_type;
 	__u8		nd_opt_len;
diff --git a/include/net/sock.h b/include/net/sock.h
index adb7da2..450a2af 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1012,7 +1012,7 @@ static inline void sk_refcnt_debug_dec(struct sock *sk)
 	       sk->sk_prot->name, sk, atomic_read(&sk->sk_prot->socks));
 }
 
-inline void sk_refcnt_debug_release(const struct sock *sk)
+static inline void sk_refcnt_debug_release(const struct sock *sk)
 {
 	if (atomic_read(&sk->sk_refcnt) != 1)
 		printk(KERN_DEBUG "Destruction of the %s socket %p delayed, refcnt=%d\n",
diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index 469daab..1476f26 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -119,7 +119,7 @@ batadv_iv_ogm_emit_send_time(const struct batadv_priv *bat_priv)
 	unsigned int msecs;
 
 	msecs = atomic_read(&bat_priv->orig_interval) - BATADV_JITTER;
-	msecs += (random32() % 2 * BATADV_JITTER);
+	msecs += random32() % (2 * BATADV_JITTER);
 
 	return jiffies + msecs_to_jiffies(msecs);
 }
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 68e8f36..fe43bc7 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -265,6 +265,9 @@ static int br_parse_ip_options(struct sk_buff *skb)
 	struct net_device *dev = skb->dev;
 	u32 len;
 
+	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
+		goto inhdr_error;
+
 	iph = ip_hdr(skb);
 	opt = &(IPCB(skb)->opt);
 
diff --git a/net/bridge/br_stp_bpdu.c b/net/bridge/br_stp_bpdu.c
index fd30a60..a8aa2d5 100644
--- a/net/bridge/br_stp_bpdu.c
+++ b/net/bridge/br_stp_bpdu.c
@@ -16,6 +16,7 @@
 #include <linux/etherdevice.h>
 #include <linux/llc.h>
 #include <linux/slab.h>
+#include <linux/pkt_sched.h>
 #include <net/net_namespace.h>
 #include <net/llc.h>
 #include <net/llc_pdu.h>
@@ -40,6 +41,7 @@ static void br_send_bpdu(struct net_bridge_port *p,
 
 	skb->dev = p->dev;
 	skb->protocol = htons(ETH_P_802_2);
+	skb->priority = TC_PRIO_CONTROL;
 
 	skb_reserve(skb, LLC_RESERVE);
 	memcpy(__skb_put(skb, length), data, length);
diff --git a/net/core/datagram.c b/net/core/datagram.c
index 0337e2b..368f9c3 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -187,7 +187,7 @@ struct sk_buff *__skb_recv_datagram(struct sock *sk, unsigned int flags,
 		skb_queue_walk(queue, skb) {
 			*peeked = skb->peeked;
 			if (flags & MSG_PEEK) {
-				if (*off >= skb->len) {
+				if (*off >= skb->len && skb->len) {
 					*off -= skb->len;
 					continue;
 				}
diff --git a/net/core/dev.c b/net/core/dev.c
index 1dce5b5..c41efb7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3296,6 +3296,7 @@ ncls:
 		}
 		switch (rx_handler(&skb)) {
 		case RX_HANDLER_CONSUMED:
+			ret = NET_RX_SUCCESS;
 			goto unlock;
 		case RX_HANDLER_ANOTHER:
 			goto another_round;
diff --git a/net/core/dst.c b/net/core/dst.c
index 56d6361..c63220e 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -179,6 +179,7 @@ void *dst_alloc(struct dst_ops *ops, struct net_device *dev,
 	dst_init_metrics(dst, dst_default_metrics, true);
 	dst->expires = 0UL;
 	dst->path = dst;
+	dst->from = NULL;
 #ifdef CONFIG_XFRM
 	dst->xfrm = NULL;
 #endif
diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index e356b8d..d7881b2 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -1797,10 +1797,13 @@ static ssize_t pktgen_thread_write(struct file *file,
 			return -EFAULT;
 		i += len;
 		mutex_lock(&pktgen_thread_lock);
-		pktgen_add_device(t, f);
+		ret = pktgen_add_device(t, f);
 		mutex_unlock(&pktgen_thread_lock);
-		ret = count;
-		sprintf(pg_result, "OK: add_device=%s", f);
+		if (!ret) {
+			ret = count;
+			sprintf(pg_result, "OK: add_device=%s", f);
+		} else
+			sprintf(pg_result, "ERROR: can not add device %s", f);
 		goto out;
 	}
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 2c5a0a0..4908588 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -976,6 +976,7 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb, struct net_device *dev,
 			 * report anything.
 			 */
 			ivi.spoofchk = -1;
+			memset(ivi.mac, 0, sizeof(ivi.mac));
 			if (dev->netdev_ops->ndo_get_vf_config(dev, i, &ivi))
 				break;
 			vf_mac.vf =
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 9708777..043139d01 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1606,7 +1606,7 @@ static void sock_spd_release(struct splice_pipe_desc *spd, unsigned int i)
 
 static struct page *linear_to_page(struct page *page, unsigned int *len,
 				   unsigned int *offset,
-				   struct sk_buff *skb, struct sock *sk)
+				   struct sock *sk)
 {
 	struct page *p = sk->sk_sndmsg_page;
 	unsigned int off;
@@ -1658,14 +1658,14 @@ static bool spd_can_coalesce(const struct splice_pipe_desc *spd,
 static bool spd_fill_page(struct splice_pipe_desc *spd,
 			  struct pipe_inode_info *pipe, struct page *page,
 			  unsigned int *len, unsigned int offset,
-			  struct sk_buff *skb, bool linear,
+			  bool linear,
 			  struct sock *sk)
 {
 	if (unlikely(spd->nr_pages == MAX_SKB_FRAGS))
 		return true;
 
 	if (linear) {
-		page = linear_to_page(page, len, &offset, skb, sk);
+		page = linear_to_page(page, len, &offset, sk);
 		if (!page)
 			return true;
 	}
@@ -1682,23 +1682,9 @@ static bool spd_fill_page(struct splice_pipe_desc *spd,
 	return false;
 }
 
-static inline void __segment_seek(struct page **page, unsigned int *poff,
-				  unsigned int *plen, unsigned int off)
-{
-	unsigned long n;
-
-	*poff += off;
-	n = *poff / PAGE_SIZE;
-	if (n)
-		*page = nth_page(*page, n);
-
-	*poff = *poff % PAGE_SIZE;
-	*plen -= off;
-}
-
 static bool __splice_segment(struct page *page, unsigned int poff,
 			     unsigned int plen, unsigned int *off,
-			     unsigned int *len, struct sk_buff *skb,
+			     unsigned int *len,
 			     struct splice_pipe_desc *spd, bool linear,
 			     struct sock *sk,
 			     struct pipe_inode_info *pipe)
@@ -1713,23 +1699,19 @@ static bool __splice_segment(struct page *page, unsigned int poff,
 	}
 
 	/* ignore any bits we already processed */
-	if (*off) {
-		__segment_seek(&page, &poff, &plen, *off);
-		*off = 0;
-	}
+	poff += *off;
+	plen -= *off;
+	*off = 0;
 
 	do {
 		unsigned int flen = min(*len, plen);
 
-		/* the linear region may spread across several pages  */
-		flen = min_t(unsigned int, flen, PAGE_SIZE - poff);
-
-		if (spd_fill_page(spd, pipe, page, &flen, poff, skb, linear, sk))
+		if (spd_fill_page(spd, pipe, page, &flen, poff,
+				  linear, sk))
 			return true;
-
-		__segment_seek(&page, &poff, &plen, flen);
+		poff += flen;
+		plen -= flen;
 		*len -= flen;
-
 	} while (*len && plen);
 
 	return false;
@@ -1753,7 +1735,7 @@ static bool __skb_splice_bits(struct sk_buff *skb, struct pipe_inode_info *pipe,
 	if (__splice_segment(virt_to_page(skb->data),
 			     (unsigned long) skb->data & (PAGE_SIZE - 1),
 			     skb_headlen(skb),
-			     offset, len, skb, spd,
+			     offset, len, spd,
 			     skb_head_is_locked(skb),
 			     sk, pipe))
 		return true;
@@ -1766,7 +1748,7 @@ static bool __skb_splice_bits(struct sk_buff *skb, struct pipe_inode_info *pipe,
 
 		if (__splice_segment(skb_frag_page(f),
 				     f->page_offset, skb_frag_size(f),
-				     offset, len, skb, spd, false, sk, pipe))
+				     offset, len, spd, false, sk, pipe))
 			return true;
 	}
 
diff --git a/net/core/sock_diag.c b/net/core/sock_diag.c
index 9d8755e..a2ad320 100644
--- a/net/core/sock_diag.c
+++ b/net/core/sock_diag.c
@@ -121,6 +121,9 @@ static int __sock_diag_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	if (nlmsg_len(nlh) < sizeof(*req))
 		return -EINVAL;
 
+	if (req->sdiag_family >= AF_MAX)
+		return -EINVAL;
+
 	hndl = sock_diag_lock_handler(req->sdiag_family);
 	if (hndl == NULL)
 		err = -ENOENT;
diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
index 81f2bb6..eb1b2eb 100644
--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -284,6 +284,7 @@ static int dcbnl_getperm_hwaddr(struct net_device *netdev, struct nlmsghdr *nlh,
 	if (!netdev->dcbnl_ops->getpermhwaddr)
 		return -EOPNOTSUPP;
 
+	memset(perm_addr, 0, sizeof(perm_addr));
 	netdev->dcbnl_ops->getpermhwaddr(netdev, perm_addr);
 
 	return nla_put(skb, DCB_ATTR_PERM_HWADDR, sizeof(perm_addr), perm_addr);
@@ -1042,6 +1043,7 @@ static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
 
 	if (ops->ieee_getets) {
 		struct ieee_ets ets;
+		memset(&ets, 0, sizeof(ets));
 		err = ops->ieee_getets(netdev, &ets);
 		if (!err &&
 		    nla_put(skb, DCB_ATTR_IEEE_ETS, sizeof(ets), &ets))
@@ -1050,6 +1052,7 @@ static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
 
 	if (ops->ieee_getmaxrate) {
 		struct ieee_maxrate maxrate;
+		memset(&maxrate, 0, sizeof(maxrate));
 		err = ops->ieee_getmaxrate(netdev, &maxrate);
 		if (!err) {
 			err = nla_put(skb, DCB_ATTR_IEEE_MAXRATE,
@@ -1061,6 +1064,7 @@ static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
 
 	if (ops->ieee_getpfc) {
 		struct ieee_pfc pfc;
+		memset(&pfc, 0, sizeof(pfc));
 		err = ops->ieee_getpfc(netdev, &pfc);
 		if (!err &&
 		    nla_put(skb, DCB_ATTR_IEEE_PFC, sizeof(pfc), &pfc))
@@ -1094,6 +1098,7 @@ static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
 	/* get peer info if available */
 	if (ops->ieee_peer_getets) {
 		struct ieee_ets ets;
+		memset(&ets, 0, sizeof(ets));
 		err = ops->ieee_peer_getets(netdev, &ets);
 		if (!err &&
 		    nla_put(skb, DCB_ATTR_IEEE_PEER_ETS, sizeof(ets), &ets))
@@ -1102,6 +1107,7 @@ static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
 
 	if (ops->ieee_peer_getpfc) {
 		struct ieee_pfc pfc;
+		memset(&pfc, 0, sizeof(pfc));
 		err = ops->ieee_peer_getpfc(netdev, &pfc);
 		if (!err &&
 		    nla_put(skb, DCB_ATTR_IEEE_PEER_PFC, sizeof(pfc), &pfc))
@@ -1280,6 +1286,7 @@ static int dcbnl_cee_fill(struct sk_buff *skb, struct net_device *netdev)
 	/* peer info if available */
 	if (ops->cee_peer_getpg) {
 		struct cee_pg pg;
+		memset(&pg, 0, sizeof(pg));
 		err = ops->cee_peer_getpg(netdev, &pg);
 		if (!err &&
 		    nla_put(skb, DCB_ATTR_CEE_PEER_PG, sizeof(pg), &pg))
@@ -1288,6 +1295,7 @@ static int dcbnl_cee_fill(struct sk_buff *skb, struct net_device *netdev)
 
 	if (ops->cee_peer_getpfc) {
 		struct cee_pfc pfc;
+		memset(&pfc, 0, sizeof(pfc));
 		err = ops->cee_peer_getpfc(netdev, &pfc);
 		if (!err &&
 		    nla_put(skb, DCB_ATTR_CEE_PEER_PFC, sizeof(pfc), &pfc))
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index 176ecdb..4f9f5eb 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -439,8 +439,8 @@ exit:
 	NET_INC_STATS_BH(sock_net(sk), LINUX_MIB_LISTENDROPS);
 	return NULL;
 put_and_exit:
-	bh_unlock_sock(newsk);
-	sock_put(newsk);
+	inet_csk_prepare_forced_close(newsk);
+	dccp_done(newsk);
 	goto exit;
 }
 
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 56840b2..6e05981 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -585,7 +585,8 @@ static struct sock *dccp_v6_request_recv_sock(struct sock *sk,
 	newinet->inet_rcv_saddr = LOOPBACK4_IPV6;
 
 	if (__inet_inherit_port(sk, newsk) < 0) {
-		sock_put(newsk);
+		inet_csk_prepare_forced_close(newsk);
+		dccp_done(newsk);
 		goto out;
 	}
 	__inet6_hash(newsk, NULL);
diff --git a/net/ieee802154/6lowpan.h b/net/ieee802154/6lowpan.h
index 8c2251f..bba5f83 100644
--- a/net/ieee802154/6lowpan.h
+++ b/net/ieee802154/6lowpan.h
@@ -84,7 +84,7 @@
 	(memcmp(addr1, addr2, length >> 3) == 0)
 
 /* local link, i.e. FE80::/10 */
-#define is_addr_link_local(a) (((a)->s6_addr16[0]) == 0x80FE)
+#define is_addr_link_local(a) (((a)->s6_addr16[0]) == htons(0xFE80))
 
 /*
  * check whether we can compress the IID to 16 bits,
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index fe4582c..dfeb658 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -228,8 +228,12 @@ EXPORT_SYMBOL(inet_listen);
 u32 inet_ehash_secret __read_mostly;
 EXPORT_SYMBOL(inet_ehash_secret);
 
+u32 ipv6_hash_secret __read_mostly;
+EXPORT_SYMBOL(ipv6_hash_secret);
+
 /*
- * inet_ehash_secret must be set exactly once
+ * inet_ehash_secret must be set exactly once, and to a non nul value
+ * ipv6_hash_secret must be set exactly once.
  */
 void build_ehash_secret(void)
 {
@@ -239,7 +243,8 @@ void build_ehash_secret(void)
 		get_random_bytes(&rnd, sizeof(rnd));
 	} while (rnd == 0);
 
-	cmpxchg(&inet_ehash_secret, 0, rnd);
+	if (cmpxchg(&inet_ehash_secret, 0, rnd) == 0)
+		get_random_bytes(&ipv6_hash_secret, sizeof(ipv6_hash_secret));
 }
 EXPORT_SYMBOL(build_ehash_secret);
 
@@ -1556,7 +1561,7 @@ static const struct net_protocol udp_protocol = {
 
 static const struct net_protocol icmp_protocol = {
 	.handler =	icmp_rcv,
-	.err_handler =	ping_err,
+	.err_handler =	icmp_err,
 	.no_policy =	1,
 	.netns_ok =	1,
 };
diff --git a/net/ipv4/datagram.c b/net/ipv4/datagram.c
index 424fafb..b28e863 100644
--- a/net/ipv4/datagram.c
+++ b/net/ipv4/datagram.c
@@ -85,3 +85,28 @@ out:
 	return err;
 }
 EXPORT_SYMBOL(ip4_datagram_connect);
+
+void ip4_datagram_release_cb(struct sock *sk)
+{
+	const struct inet_sock *inet = inet_sk(sk);
+	const struct ip_options_rcu *inet_opt;
+	__be32 daddr = inet->inet_daddr;
+	struct flowi4 fl4;
+	struct rtable *rt;
+
+	if (! __sk_dst_get(sk) || __sk_dst_check(sk, 0))
+		return;
+
+	rcu_read_lock();
+	inet_opt = rcu_dereference(inet->inet_opt);
+	if (inet_opt && inet_opt->opt.srr)
+		daddr = inet_opt->opt.faddr;
+	rt = ip_route_output_ports(sock_net(sk), &fl4, sk, daddr,
+				   inet->inet_saddr, inet->inet_dport,
+				   inet->inet_sport, sk->sk_protocol,
+				   RT_CONN_FLAGS(sk), sk->sk_bound_dev_if);
+	if (!IS_ERR(rt))
+		__sk_dst_set(sk, &rt->dst);
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL_GPL(ip4_datagram_release_cb);
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 17ff9fd..3ac5dff 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -934,6 +934,29 @@ error:
 	goto drop;
 }
 
+void icmp_err(struct sk_buff *skb, u32 info)
+{
+	struct iphdr *iph = (struct iphdr *)skb->data;
+	struct icmphdr *icmph = (struct icmphdr *)(skb->data+(iph->ihl<<2));
+	int type = icmp_hdr(skb)->type;
+	int code = icmp_hdr(skb)->code;
+	struct net *net = dev_net(skb->dev);
+
+	/*
+	 * Use ping_err to handle all icmp errors except those
+	 * triggered by ICMP_ECHOREPLY which sent from kernel.
+	 */
+	if (icmph->type != ICMP_ECHOREPLY) {
+		ping_err(skb, info);
+		return;
+	}
+
+	if (type == ICMP_DEST_UNREACH && code == ICMP_FRAG_NEEDED)
+		ipv4_update_pmtu(skb, net, info, 0, 0, IPPROTO_ICMP, 0);
+	else if (type == ICMP_REDIRECT)
+		ipv4_redirect(skb, net, 0, 0, IPPROTO_ICMP, 0);
+}
+
 /*
  *	This table is the definition of how we handle ICMP.
  */
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 0405cc8..567c31f 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -679,6 +679,22 @@ void inet_csk_destroy_sock(struct sock *sk)
 }
 EXPORT_SYMBOL(inet_csk_destroy_sock);
 
+/* This function allows to force a closure of a socket after the call to
+ * tcp/dccp_create_openreq_child().
+ */
+void inet_csk_prepare_forced_close(struct sock *sk)
+{
+	/* sk_clone_lock locked the socket and set refcnt to 2 */
+	bh_unlock_sock(sk);
+	sock_put(sk);
+
+	/* The below has to be done to allow calling inet_csk_destroy_sock */
+	sock_set_flag(sk, SOCK_DEAD);
+	percpu_counter_inc(sk->sk_prot->orphan_count);
+	inet_sk(sk)->inet_num = 0;
+}
+EXPORT_SYMBOL(inet_csk_prepare_forced_close);
+
 int inet_csk_listen_start(struct sock *sk, const int nr_table_entries)
 {
 	struct inet_sock *inet = inet_sk(sk);
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index b062a98..3ee08ce 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -946,8 +946,12 @@ static netdev_tx_t ipgre_tunnel_xmit(struct sk_buff *skb, struct net_device *dev
 			ptr--;
 		}
 		if (tunnel->parms.o_flags&GRE_CSUM) {
+			int offset = skb_transport_offset(skb);
+
 			*ptr = 0;
-			*(__sum16 *)ptr = ip_compute_csum((void *)(iph+1), skb->len - sizeof(struct iphdr));
+			*(__sum16 *)ptr = csum_fold(skb_checksum(skb, offset,
+								 skb->len - offset,
+								 0));
 		}
 	}
 
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 14bbfcf..e95d72b 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -590,7 +590,7 @@ static int do_ip_setsockopt(struct sock *sk, int level,
 	case IP_TTL:
 		if (optlen < 1)
 			goto e_inval;
-		if (val != -1 && (val < 0 || val > 255))
+		if (val != -1 && (val < 1 || val > 255))
 			goto e_inval;
 		inet->uc_ttl = val;
 		break;
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 6232d47..af8739a 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -328,8 +328,8 @@ void ping_err(struct sk_buff *skb, u32 info)
 	struct iphdr *iph = (struct iphdr *)skb->data;
 	struct icmphdr *icmph = (struct icmphdr *)(skb->data+(iph->ihl<<2));
 	struct inet_sock *inet_sock;
-	int type = icmph->type;
-	int code = icmph->code;
+	int type = icmp_hdr(skb)->type;
+	int code = icmp_hdr(skb)->code;
 	struct net *net = dev_net(skb->dev);
 	struct sock *sk;
 	int harderr;
@@ -744,6 +744,7 @@ struct proto ping_prot = {
 	.recvmsg =	ping_recvmsg,
 	.bind =		ping_bind,
 	.backlog_rcv =	ping_queue_rcv_skb,
+	.release_cb =	ip4_datagram_release_cb,
 	.hash =		ping_v4_hash,
 	.unhash =	ping_v4_unhash,
 	.get_port =	ping_v4_get_port,
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index d23c657..f9c0d05 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -894,6 +894,7 @@ struct proto raw_prot = {
 	.recvmsg	   = raw_recvmsg,
 	.bind		   = raw_bind,
 	.backlog_rcv	   = raw_rcv_skb,
+	.release_cb	   = ip4_datagram_release_cb,
 	.hash		   = raw_hash_sk,
 	.unhash		   = raw_unhash_sk,
 	.obj_size	   = sizeof(struct raw_sock),
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 285a18f..39de0ca 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -912,6 +912,9 @@ static void __ip_rt_update_pmtu(struct rtable *rt, struct flowi4 *fl4, u32 mtu)
 	struct dst_entry *dst = &rt->dst;
 	struct fib_result res;
 
+	if (dst_metric_locked(dst, RTAX_MTU))
+		return;
+
 	if (dst->dev->mtu < mtu)
 		return;
 
@@ -962,7 +965,7 @@ void ipv4_update_pmtu(struct sk_buff *skb, struct net *net, u32 mtu,
 }
 EXPORT_SYMBOL_GPL(ipv4_update_pmtu);
 
-void ipv4_sk_update_pmtu(struct sk_buff *skb, struct sock *sk, u32 mtu)
+static void __ipv4_sk_update_pmtu(struct sk_buff *skb, struct sock *sk, u32 mtu)
 {
 	const struct iphdr *iph = (const struct iphdr *) skb->data;
 	struct flowi4 fl4;
@@ -975,6 +978,53 @@ void ipv4_sk_update_pmtu(struct sk_buff *skb, struct sock *sk, u32 mtu)
 		ip_rt_put(rt);
 	}
 }
+
+void ipv4_sk_update_pmtu(struct sk_buff *skb, struct sock *sk, u32 mtu)
+{
+	const struct iphdr *iph = (const struct iphdr *) skb->data;
+	struct flowi4 fl4;
+	struct rtable *rt;
+	struct dst_entry *dst;
+	bool new = false;
+
+	bh_lock_sock(sk);
+	rt = (struct rtable *) __sk_dst_get(sk);
+
+	if (sock_owned_by_user(sk) || !rt) {
+		__ipv4_sk_update_pmtu(skb, sk, mtu);
+		goto out;
+	}
+
+	__build_flow_key(&fl4, sk, iph, 0, 0, 0, 0, 0);
+
+	if (!__sk_dst_check(sk, 0)) {
+		rt = ip_route_output_flow(sock_net(sk), &fl4, sk);
+		if (IS_ERR(rt))
+			goto out;
+
+		new = true;
+	}
+
+	__ip_rt_update_pmtu((struct rtable *) rt->dst.path, &fl4, mtu);
+
+	dst = dst_check(&rt->dst, 0);
+	if (!dst) {
+		if (new)
+			dst_release(&rt->dst);
+
+		rt = ip_route_output_flow(sock_net(sk), &fl4, sk);
+		if (IS_ERR(rt))
+			goto out;
+
+		new = true;
+	}
+
+	if (new)
+		__sk_dst_set(sk, &rt->dst);
+
+out:
+	bh_unlock_sock(sk);
+}
 EXPORT_SYMBOL_GPL(ipv4_sk_update_pmtu);
 
 void ipv4_redirect(struct sk_buff *skb, struct net *net,
@@ -1123,7 +1173,7 @@ static unsigned int ipv4_mtu(const struct dst_entry *dst)
 	if (!mtu)
 		mtu = dst_metric_raw(dst, RTAX_MTU);
 
-	if (mtu && rt_is_output_route(rt))
+	if (mtu)
 		return mtu;
 
 	mtu = dst->dev->mtu;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index b0b39f6..a07e91c 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1454,12 +1454,12 @@ static void tcp_service_net_dma(struct sock *sk, bool wait)
 }
 #endif
 
-static inline struct sk_buff *tcp_recv_skb(struct sock *sk, u32 seq, u32 *off)
+static struct sk_buff *tcp_recv_skb(struct sock *sk, u32 seq, u32 *off)
 {
 	struct sk_buff *skb;
 	u32 offset;
 
-	skb_queue_walk(&sk->sk_receive_queue, skb) {
+	while ((skb = skb_peek(&sk->sk_receive_queue)) != NULL) {
 		offset = seq - TCP_SKB_CB(skb)->seq;
 		if (tcp_hdr(skb)->syn)
 			offset--;
@@ -1467,6 +1467,11 @@ static inline struct sk_buff *tcp_recv_skb(struct sock *sk, u32 seq, u32 *off)
 			*off = offset;
 			return skb;
 		}
+		/* This looks weird, but this can happen if TCP collapsing
+		 * splitted a fat GRO packet, while we released socket lock
+		 * in skb_splice_bits()
+		 */
+		sk_eat_skb(sk, skb, false);
 	}
 	return NULL;
 }
@@ -1508,7 +1513,7 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 					break;
 			}
 			used = recv_actor(desc, skb, offset, len);
-			if (used < 0) {
+			if (used <= 0) {
 				if (!copied)
 					copied = used;
 				break;
@@ -1517,15 +1522,19 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 				copied += used;
 				offset += used;
 			}
-			/*
-			 * If recv_actor drops the lock (e.g. TCP splice
+			/* If recv_actor drops the lock (e.g. TCP splice
 			 * receive) the skb pointer might be invalid when
 			 * getting here: tcp_collapse might have deleted it
 			 * while aggregating skbs from the socket queue.
 			 */
-			skb = tcp_recv_skb(sk, seq-1, &offset);
-			if (!skb || (offset+1 != skb->len))
+			skb = tcp_recv_skb(sk, seq - 1, &offset);
+			if (!skb)
 				break;
+			/* TCP coalescing might have appended data to the skb.
+			 * Try to splice more frags
+			 */
+			if (offset + 1 != skb->len)
+				continue;
 		}
 		if (tcp_hdr(skb)->fin) {
 			sk_eat_skb(sk, skb, false);
@@ -1542,8 +1551,10 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 	tcp_rcv_space_adjust(sk);
 
 	/* Clean up data we have read: This will do ACK frames. */
-	if (copied > 0)
+	if (copied > 0) {
+		tcp_recv_skb(sk, seq, &offset);
 		tcp_cleanup_rbuf(sk, copied);
+	}
 	return copied;
 }
 EXPORT_SYMBOL(tcp_read_sock);
diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
index 1432cdb..fc582a7 100644
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -309,6 +309,12 @@ void tcp_slow_start(struct tcp_sock *tp)
 {
 	int cnt; /* increase in packets */
 	unsigned int delta = 0;
+	u32 snd_cwnd = tp->snd_cwnd;
+
+	if (unlikely(!snd_cwnd)) {
+		pr_err_once("snd_cwnd is nul, please report this bug.\n");
+		snd_cwnd = 1U;
+	}
 
 	/* RFC3465: ABC Slow start
 	 * Increase only after a full MSS of bytes is acked
@@ -323,7 +329,7 @@ void tcp_slow_start(struct tcp_sock *tp)
 	if (sysctl_tcp_max_ssthresh > 0 && tp->snd_cwnd > sysctl_tcp_max_ssthresh)
 		cnt = sysctl_tcp_max_ssthresh >> 1;	/* limited slow start */
 	else
-		cnt = tp->snd_cwnd;			/* exponential increase */
+		cnt = snd_cwnd;				/* exponential increase */
 
 	/* RFC3465: ABC
 	 * We MAY increase by 2 if discovered delayed ack
@@ -333,11 +339,11 @@ void tcp_slow_start(struct tcp_sock *tp)
 	tp->bytes_acked = 0;
 
 	tp->snd_cwnd_cnt += cnt;
-	while (tp->snd_cwnd_cnt >= tp->snd_cwnd) {
-		tp->snd_cwnd_cnt -= tp->snd_cwnd;
+	while (tp->snd_cwnd_cnt >= snd_cwnd) {
+		tp->snd_cwnd_cnt -= snd_cwnd;
 		delta++;
 	}
-	tp->snd_cwnd = min(tp->snd_cwnd + delta, tp->snd_cwnd_clamp);
+	tp->snd_cwnd = min(snd_cwnd + delta, tp->snd_cwnd_clamp);
 }
 EXPORT_SYMBOL_GPL(tcp_slow_start);
 
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index c92c4da..396c6ae 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3531,6 +3531,11 @@ static bool tcp_process_frto(struct sock *sk, int flag)
 		}
 	} else {
 		if (!(flag & FLAG_DATA_ACKED) && (tp->frto_counter == 1)) {
+			if (!tcp_packets_in_flight(tp)) {
+				tcp_enter_frto_loss(sk, 2, flag);
+				return true;
+			}
+
 			/* Prevent sending of new data. */
 			tp->snd_cwnd = min(tp->snd_cwnd,
 					   tcp_packets_in_flight(tp));
@@ -3579,6 +3584,24 @@ static bool tcp_process_frto(struct sock *sk, int flag)
 	return false;
 }
 
+/* RFC 5961 7 [ACK Throttling] */
+static void tcp_send_challenge_ack(struct sock *sk)
+{
+	/* unprotected vars, we dont care of overwrites */
+	static u32 challenge_timestamp;
+	static unsigned int challenge_count;
+	u32 now = jiffies / HZ;
+
+	if (now != challenge_timestamp) {
+		challenge_timestamp = now;
+		challenge_count = 0;
+	}
+	if (++challenge_count <= sysctl_tcp_challenge_ack_limit) {
+		NET_INC_STATS_BH(sock_net(sk), LINUX_MIB_TCPCHALLENGEACK);
+		tcp_send_ack(sk);
+	}
+}
+
 /* This routine deals with incoming acks, but not outgoing ones. */
 static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 {
@@ -3598,8 +3621,14 @@ static int tcp_ack(struct sock *sk, const struct sk_buff *skb, int flag)
 	/* If the ack is older than previous acks
 	 * then we can probably ignore it.
 	 */
-	if (before(ack, prior_snd_una))
+	if (before(ack, prior_snd_una)) {
+		/* RFC 5961 5.2 [Blind Data Injection Attack].[Mitigation] */
+		if (before(ack, prior_snd_una - tp->max_window)) {
+			tcp_send_challenge_ack(sk);
+			return -1;
+		}
 		goto old_ack;
+	}
 
 	/* If the ack includes data we haven't sent yet, discard
 	 * this segment (RFC793 Section 3.9).
@@ -5271,23 +5300,6 @@ out:
 }
 #endif /* CONFIG_NET_DMA */
 
-static void tcp_send_challenge_ack(struct sock *sk)
-{
-	/* unprotected vars, we dont care of overwrites */
-	static u32 challenge_timestamp;
-	static unsigned int challenge_count;
-	u32 now = jiffies / HZ;
-
-	if (now != challenge_timestamp) {
-		challenge_timestamp = now;
-		challenge_count = 0;
-	}
-	if (++challenge_count <= sysctl_tcp_challenge_ack_limit) {
-		NET_INC_STATS_BH(sock_net(sk), LINUX_MIB_TCPCHALLENGEACK);
-		tcp_send_ack(sk);
-	}
-}
-
 /* Does PAWS and seqno based validation of an incoming segment, flags will
  * play significant role here.
  */
@@ -5340,11 +5352,6 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 		goto discard;
 	}
 
-	/* ts_recent update must be made after we are sure that the packet
-	 * is in window.
-	 */
-	tcp_replace_ts_recent(tp, TCP_SKB_CB(skb)->seq);
-
 	/* step 3: check security and precedence [ignored] */
 
 	/* step 4: Check for a SYN
@@ -5518,6 +5525,9 @@ int tcp_rcv_established(struct sock *sk, struct sk_buff *skb,
 				if (tcp_checksum_complete_user(sk, skb))
 					goto csum_error;
 
+				if ((int)skb->truesize > sk->sk_forward_alloc)
+					goto step5;
+
 				/* Predicted packet is in window by definition.
 				 * seq == rcv_nxt and rcv_wup <= rcv_nxt.
 				 * Hence, check seq<=rcv_wup reduces to:
@@ -5529,9 +5539,6 @@ int tcp_rcv_established(struct sock *sk, struct sk_buff *skb,
 
 				tcp_rcv_rtt_measure_ts(sk, skb);
 
-				if ((int)skb->truesize > sk->sk_forward_alloc)
-					goto step5;
-
 				NET_INC_STATS_BH(sock_net(sk), LINUX_MIB_TCPHPHITS);
 
 				/* Bulk data transfer: receiver */
@@ -5579,6 +5586,11 @@ step5:
 	if (th->ack && tcp_ack(sk, skb, FLAG_SLOWPATH) < 0)
 		goto discard;
 
+	/* ts_recent update must be made after we are sure that the packet
+	 * is in window.
+	 */
+	tcp_replace_ts_recent(tp, TCP_SKB_CB(skb)->seq);
+
 	tcp_rcv_rtt_measure_ts(sk, skb);
 
 	/* Process urgent data. */
@@ -5666,8 +5678,7 @@ static bool tcp_rcv_fastopen_synack(struct sock *sk, struct sk_buff *synack,
 	 * the remote receives only the retransmitted (regular) SYNs: either
 	 * the original SYN-data or the corresponding SYN-ACK is lost.
 	 */
-	syn_drop = (cookie->len <= 0 && data &&
-		    inet_csk(sk)->icsk_retransmits);
+	syn_drop = (cookie->len <= 0 && data && tp->total_retrans);
 
 	tcp_fastopen_cache_set(sk, mss, cookie, syn_drop);
 
@@ -6106,6 +6117,11 @@ int tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb,
 	} else
 		goto discard;
 
+	/* ts_recent update must be made after we are sure that the packet
+	 * is in window.
+	 */
+	tcp_replace_ts_recent(tp, TCP_SKB_CB(skb)->seq);
+
 	/* step 6: check the URG bit */
 	tcp_urg(sk, skb, th);
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index db7bfad..c883f4f 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -379,11 +379,10 @@ void tcp_v4_err(struct sk_buff *icmp_skb, u32 info)
 	 * We do take care of PMTU discovery (RFC1191) special case :
 	 * we can receive locally generated ICMP messages while socket is held.
 	 */
-	if (sock_owned_by_user(sk) &&
-	    type != ICMP_DEST_UNREACH &&
-	    code != ICMP_FRAG_NEEDED)
-		NET_INC_STATS_BH(net, LINUX_MIB_LOCKDROPPEDICMPS);
-
+	if (sock_owned_by_user(sk)) {
+		if (!(type == ICMP_DEST_UNREACH && code == ICMP_FRAG_NEEDED))
+			NET_INC_STATS_BH(net, LINUX_MIB_LOCKDROPPEDICMPS);
+	}
 	if (sk->sk_state == TCP_CLOSE)
 		goto out;
 
@@ -1537,10 +1536,8 @@ exit:
 	NET_INC_STATS_BH(sock_net(sk), LINUX_MIB_LISTENDROPS);
 	return NULL;
 put_and_exit:
-	tcp_clear_xmit_timers(newsk);
-	tcp_cleanup_congestion_control(newsk);
-	bh_unlock_sock(newsk);
-	sock_put(newsk);
+	inet_csk_prepare_forced_close(newsk);
+	tcp_done(newsk);
 	goto exit;
 }
 EXPORT_SYMBOL(tcp_v4_syn_recv_sock);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 6735bea..6a1cdc8 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1342,8 +1342,8 @@ int tcp_trim_head(struct sock *sk, struct sk_buff *skb, u32 len)
 	return 0;
 }
 
-/* Calculate MSS. Not accounting for SACKs here.  */
-int tcp_mtu_to_mss(struct sock *sk, int pmtu)
+/* Calculate MSS not accounting any TCP options.  */
+static inline int __tcp_mtu_to_mss(struct sock *sk, int pmtu)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
 	const struct inet_connection_sock *icsk = inet_csk(sk);
@@ -1372,13 +1372,17 @@ int tcp_mtu_to_mss(struct sock *sk, int pmtu)
 	/* Then reserve room for full set of TCP options and 8 bytes of data */
 	if (mss_now < 48)
 		mss_now = 48;
-
-	/* Now subtract TCP options size, not including SACKs */
-	mss_now -= tp->tcp_header_len - sizeof(struct tcphdr);
-
 	return mss_now;
 }
 
+/* Calculate MSS. Not accounting for SACKs here.  */
+int tcp_mtu_to_mss(struct sock *sk, int pmtu)
+{
+	/* Subtract TCP options size, not including SACKs */
+	return __tcp_mtu_to_mss(sk, pmtu) -
+	       (tcp_sk(sk)->tcp_header_len - sizeof(struct tcphdr));
+}
+
 /* Inverse of above */
 int tcp_mss_to_mtu(struct sock *sk, int mss)
 {
@@ -2914,7 +2918,7 @@ static int tcp_send_syn_data(struct sock *sk, struct sk_buff *syn)
 	 */
 	if (tp->rx_opt.user_mss && tp->rx_opt.user_mss < tp->rx_opt.mss_clamp)
 		tp->rx_opt.mss_clamp = tp->rx_opt.user_mss;
-	space = tcp_mtu_to_mss(sk, inet_csk(sk)->icsk_pmtu_cookie) -
+	space = __tcp_mtu_to_mss(sk, inet_csk(sk)->icsk_pmtu_cookie) -
 		MAX_TCP_OPTION_SPACE;
 
 	syn_data = skb_copy_expand(syn, skb_headroom(syn), space,
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 2814f66..ee4b36a 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1952,6 +1952,7 @@ struct proto udp_prot = {
 	.recvmsg	   = udp_recvmsg,
 	.sendpage	   = udp_sendpage,
 	.backlog_rcv	   = __udp_queue_rcv_skb,
+	.release_cb	   = ip4_datagram_release_cb,
 	.hash		   = udp_lib_hash,
 	.unhash		   = udp_lib_unhash,
 	.rehash		   = udp_v4_rehash,
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index b10374d..fd82a30 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1736,7 +1736,7 @@ static struct rt6_info *addrconf_get_prefix_route(const struct in6_addr *pfx,
 			continue;
 		if ((rt->rt6i_flags & flags) != flags)
 			continue;
-		if ((noflags != 0) && ((rt->rt6i_flags & flags) != 0))
+		if ((rt->rt6i_flags & noflags) != 0)
 			continue;
 		dst_hold(&rt->dst);
 		break;
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 24d69db..4d844d7 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -81,10 +81,22 @@ static inline struct sock *icmpv6_sk(struct net *net)
 	return net->ipv6.icmp_sk[smp_processor_id()];
 }
 
+static void icmpv6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
+		       u8 type, u8 code, int offset, __be32 info)
+{
+	struct net *net = dev_net(skb->dev);
+
+	if (type == ICMPV6_PKT_TOOBIG)
+		ip6_update_pmtu(skb, net, info, 0, 0);
+	else if (type == NDISC_REDIRECT)
+		ip6_redirect(skb, net, 0, 0);
+}
+
 static int icmpv6_rcv(struct sk_buff *skb);
 
 static const struct inet6_protocol icmpv6_protocol = {
 	.handler	=	icmpv6_rcv,
+	.err_handler	=	icmpv6_err,
 	.flags		=	INET6_PROTO_NOPOLICY|INET6_PROTO_FINAL,
 };
 
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index a52d864..b196852 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -270,7 +270,8 @@ int ip6_mc_input(struct sk_buff *skb)
 	 *      IPv6 multicast router mode is now supported ;)
 	 */
 	if (dev_net(skb->dev)->ipv6.devconf_all->mc_forwarding &&
-	    !(ipv6_addr_type(&hdr->daddr) & IPV6_ADDR_LINKLOCAL) &&
+	    !(ipv6_addr_type(&hdr->daddr) &
+	      (IPV6_ADDR_LOOPBACK|IPV6_ADDR_LINKLOCAL)) &&
 	    likely(!(IP6CB(skb)->flags & IP6SKB_FORWARDED))) {
 		/*
 		 * Okay, we try to forward - split and duplicate
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 5b2d63e..3d485ec 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1287,10 +1287,10 @@ int ip6_append_data(struct sock *sk, int getfrag(void *from, char *to,
 		cork->length = 0;
 		sk->sk_sndmsg_page = NULL;
 		sk->sk_sndmsg_off = 0;
-		exthdrlen = (opt ? opt->opt_flen : 0) - rt->rt6i_nfheader_len;
+		exthdrlen = (opt ? opt->opt_flen : 0);
 		length += exthdrlen;
 		transhdrlen += exthdrlen;
-		dst_exthdrlen = rt->dst.header_len;
+		dst_exthdrlen = rt->dst.header_len - rt->rt6i_nfheader_len;
 	} else {
 		rt = (struct rt6_info *)cork->dst;
 		fl6 = &inet->cork.fl.u.ip6;
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 2edce30..89dab79 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1333,6 +1333,12 @@ out:
 
 static void ndisc_redirect_rcv(struct sk_buff *skb)
 {
+	u8 *hdr;
+	struct ndisc_options ndopts;
+	struct rd_msg *msg = (struct rd_msg *)skb_transport_header(skb);
+	u32 ndoptlen = skb->tail - (skb->transport_header +
+				    offsetof(struct rd_msg, opt));
+
 #ifdef CONFIG_IPV6_NDISC_NODETYPE
 	switch (skb->ndisc_nodetype) {
 	case NDISC_NODETYPE_HOST:
@@ -1349,6 +1355,17 @@ static void ndisc_redirect_rcv(struct sk_buff *skb)
 		return;
 	}
 
+	if (!ndisc_parse_options(msg->opt, ndoptlen, &ndopts))
+		return;
+
+	if (!ndopts.nd_opts_rh)
+		return;
+
+	hdr = (u8 *)ndopts.nd_opts_rh;
+	hdr += 8;
+	if (!pskb_pull(skb, hdr - skb_transport_header(skb)))
+		return;
+
 	icmpv6_notify(skb, NDISC_REDIRECT, 0, 0);
 }
 
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 070a3ce..103880b 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -297,6 +297,7 @@ static void ip6_dst_destroy(struct dst_entry *dst)
 {
 	struct rt6_info *rt = (struct rt6_info *)dst;
 	struct inet6_dev *idev = rt->rt6i_idev;
+	struct dst_entry *from = dst->from;
 
 	if (rt->n)
 		neigh_release(rt->n);
@@ -309,8 +310,8 @@ static void ip6_dst_destroy(struct dst_entry *dst)
 		in6_dev_put(idev);
 	}
 
-	if (!(rt->rt6i_flags & RTF_EXPIRES) && dst->from)
-		dst_release(dst->from);
+	dst->from = NULL;
+	dst_release(from);
 
 	if (rt6_has_peer(rt)) {
 		struct inet_peer *peer = rt6_peer_ptr(rt);
@@ -881,7 +882,7 @@ restart:
 	dst_hold(&rt->dst);
 	read_unlock_bh(&table->tb6_lock);
 
-	if (!rt->n && !(rt->rt6i_flags & RTF_NONEXTHOP))
+	if (!rt->n && !(rt->rt6i_flags & (RTF_NONEXTHOP | RTF_LOCAL)))
 		nrt = rt6_alloc_cow(rt, &fl6->daddr, &fl6->saddr);
 	else if (!(rt->dst.flags & DST_HOST))
 		nrt = rt6_alloc_clone(rt, &fl6->daddr);
@@ -1007,7 +1008,6 @@ struct dst_entry *ip6_blackhole_route(struct net *net, struct dst_entry *dst_ori
 
 		rt->rt6i_gateway = ort->rt6i_gateway;
 		rt->rt6i_flags = ort->rt6i_flags;
-		rt6_clean_expires(rt);
 		rt->rt6i_metric = 0;
 
 		memcpy(&rt->rt6i_dst, &ort->rt6i_dst, sizeof(struct rt6key));
@@ -1810,8 +1810,6 @@ static struct rt6_info *ip6_rt_copy(struct rt6_info *ort,
 		if ((ort->rt6i_flags & (RTF_DEFAULT | RTF_ADDRCONF)) ==
 		    (RTF_DEFAULT | RTF_ADDRCONF))
 			rt6_set_from(rt, ort);
-		else
-			rt6_clean_expires(rt);
 		rt->rt6i_metric = 0;
 
 #ifdef CONFIG_IPV6_SUBTREES
@@ -1943,7 +1941,8 @@ void rt6_purge_dflt_routers(struct net *net)
 restart:
 	read_lock_bh(&table->tb6_lock);
 	for (rt = table->tb6_root.leaf; rt; rt = rt->dst.rt6_next) {
-		if (rt->rt6i_flags & (RTF_DEFAULT | RTF_ADDRCONF)) {
+		if (rt->rt6i_flags & (RTF_DEFAULT | RTF_ADDRCONF) &&
+		    (!rt->rt6i_idev || rt->rt6i_idev->cnf.accept_ra != 2)) {
 			dst_hold(&rt->dst);
 			read_unlock_bh(&table->tb6_lock);
 			ip6_del_rt(rt);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 7e32d42..8b45fb4 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1371,7 +1371,8 @@ static struct sock * tcp_v6_syn_recv_sock(struct sock *sk, struct sk_buff *skb,
 #endif
 
 	if (__inet_inherit_port(sk, newsk) < 0) {
-		sock_put(newsk);
+		inet_csk_prepare_forced_close(newsk);
+		tcp_done(newsk);
 		goto out;
 	}
 	__inet6_hash(newsk, NULL);
diff --git a/net/ipv6/xfrm6_policy.c b/net/ipv6/xfrm6_policy.c
index f8c4c08..bf6912e 100644
--- a/net/ipv6/xfrm6_policy.c
+++ b/net/ipv6/xfrm6_policy.c
@@ -236,6 +236,8 @@ static void xfrm6_dst_destroy(struct dst_entry *dst)
 {
 	struct xfrm_dst *xdst = (struct xfrm_dst *)dst;
 
+	if (likely(xdst->u.rt6.n))
+		neigh_release(xdst->u.rt6.n);
 	if (likely(xdst->u.rt6.rt6i_idev))
 		in6_dev_put(xdst->u.rt6.rt6i_idev);
 	dst_destroy_metrics_generic(dst);
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 286366e..e966602 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -355,6 +355,7 @@ static int pppol2tp_sendmsg(struct kiocb *iocb, struct socket *sock, struct msgh
 	l2tp_xmit_skb(session, skb, session->hdr_len);
 
 	sock_put(ps->tunnel_sock);
+	sock_put(sk);
 
 	return error;
 
diff --git a/net/mac802154/wpan.c b/net/mac802154/wpan.c
index f30f6d4..c5e24c8 100644
--- a/net/mac802154/wpan.c
+++ b/net/mac802154/wpan.c
@@ -387,7 +387,7 @@ void mac802154_wpan_setup(struct net_device *dev)
 
 static int mac802154_process_data(struct net_device *dev, struct sk_buff *skb)
 {
-	return netif_rx(skb);
+	return netif_rx_ni(skb);
 }
 
 static int
diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index e7ff694..7fe20d0 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -1189,8 +1189,6 @@ static int netlbl_unlabel_staticlist(struct sk_buff *skb,
 	struct netlbl_unlhsh_walk_arg cb_arg;
 	u32 skip_bkt = cb->args[0];
 	u32 skip_chain = cb->args[1];
-	u32 skip_addr4 = cb->args[2];
-	u32 skip_addr6 = cb->args[3];
 	u32 iter_bkt;
 	u32 iter_chain = 0, iter_addr4 = 0, iter_addr6 = 0;
 	struct netlbl_unlhsh_iface *iface;
@@ -1215,7 +1213,7 @@ static int netlbl_unlabel_staticlist(struct sk_buff *skb,
 				continue;
 			netlbl_af4list_foreach_rcu(addr4,
 						   &iface->addr4_list) {
-				if (iter_addr4++ < skip_addr4)
+				if (iter_addr4++ < cb->args[2])
 					continue;
 				if (netlbl_unlabel_staticlist_gen(
 					      NLBL_UNLABEL_C_STATICLIST,
@@ -1231,7 +1229,7 @@ static int netlbl_unlabel_staticlist(struct sk_buff *skb,
 #if IS_ENABLED(CONFIG_IPV6)
 			netlbl_af6list_foreach_rcu(addr6,
 						   &iface->addr6_list) {
-				if (iter_addr6++ < skip_addr6)
+				if (iter_addr6++ < cb->args[3])
 					continue;
 				if (netlbl_unlabel_staticlist_gen(
 					      NLBL_UNLABEL_C_STATICLIST,
@@ -1250,10 +1248,10 @@ static int netlbl_unlabel_staticlist(struct sk_buff *skb,
 
 unlabel_staticlist_return:
 	rcu_read_unlock();
-	cb->args[0] = skip_bkt;
-	cb->args[1] = skip_chain;
-	cb->args[2] = skip_addr4;
-	cb->args[3] = skip_addr6;
+	cb->args[0] = iter_bkt;
+	cb->args[1] = iter_chain;
+	cb->args[2] = iter_addr4;
+	cb->args[3] = iter_addr6;
 	return skb->len;
 }
 
@@ -1273,12 +1271,9 @@ static int netlbl_unlabel_staticlistdef(struct sk_buff *skb,
 {
 	struct netlbl_unlhsh_walk_arg cb_arg;
 	struct netlbl_unlhsh_iface *iface;
-	u32 skip_addr4 = cb->args[0];
-	u32 skip_addr6 = cb->args[1];
-	u32 iter_addr4 = 0;
+	u32 iter_addr4 = 0, iter_addr6 = 0;
 	struct netlbl_af4list *addr4;
 #if IS_ENABLED(CONFIG_IPV6)
-	u32 iter_addr6 = 0;
 	struct netlbl_af6list *addr6;
 #endif
 
@@ -1292,7 +1287,7 @@ static int netlbl_unlabel_staticlistdef(struct sk_buff *skb,
 		goto unlabel_staticlistdef_return;
 
 	netlbl_af4list_foreach_rcu(addr4, &iface->addr4_list) {
-		if (iter_addr4++ < skip_addr4)
+		if (iter_addr4++ < cb->args[0])
 			continue;
 		if (netlbl_unlabel_staticlist_gen(NLBL_UNLABEL_C_STATICLISTDEF,
 					      iface,
@@ -1305,7 +1300,7 @@ static int netlbl_unlabel_staticlistdef(struct sk_buff *skb,
 	}
 #if IS_ENABLED(CONFIG_IPV6)
 	netlbl_af6list_foreach_rcu(addr6, &iface->addr6_list) {
-		if (iter_addr6++ < skip_addr6)
+		if (iter_addr6++ < cb->args[1])
 			continue;
 		if (netlbl_unlabel_staticlist_gen(NLBL_UNLABEL_C_STATICLISTDEF,
 					      iface,
@@ -1320,8 +1315,8 @@ static int netlbl_unlabel_staticlistdef(struct sk_buff *skb,
 
 unlabel_staticlistdef_return:
 	rcu_read_unlock();
-	cb->args[0] = skip_addr4;
-	cb->args[1] = skip_addr6;
+	cb->args[0] = iter_addr4;
+	cb->args[1] = iter_addr6;
 	return skb->len;
 }
 
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index c5c9e2a..70f7e18 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2443,13 +2443,15 @@ static int packet_release(struct socket *sock)
 
 	packet_flush_mclist(sk);
 
-	memset(&req_u, 0, sizeof(req_u));
-
-	if (po->rx_ring.pg_vec)
+	if (po->rx_ring.pg_vec) {
+		memset(&req_u, 0, sizeof(req_u));
 		packet_set_ring(sk, &req_u, 1, 0);
+	}
 
-	if (po->tx_ring.pg_vec)
+	if (po->tx_ring.pg_vec) {
+		memset(&req_u, 0, sizeof(req_u));
 		packet_set_ring(sk, &req_u, 1, 1);
+	}
 
 	fanout_release(sk);
 
diff --git a/net/rds/message.c b/net/rds/message.c
index f0a4658..aff589c 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -197,6 +197,9 @@ struct rds_message *rds_message_alloc(unsigned int extra_len, gfp_t gfp)
 {
 	struct rds_message *rm;
 
+	if (extra_len > KMALLOC_MAX_SIZE - sizeof(struct rds_message))
+		return NULL;
+
 	rm = kzalloc(sizeof(struct rds_message) + extra_len, gfp);
 	if (!rm)
 		goto out;
diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 9d75b77..e9ea2f3 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -874,7 +874,7 @@ ok:
 	q->now = psched_get_time();
 	start_at = jiffies;
 
-	next_event = q->now + 5 * PSCHED_TICKS_PER_SEC;
+	next_event = q->now + 5LLU * PSCHED_TICKS_PER_SEC;
 
 	for (level = 0; level < TC_HTB_MAXDEPTH; level++) {
 		/* common case optimization - skip event handler quickly */
diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
index 68a385d..58cd035 100644
--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -248,6 +248,8 @@ void sctp_endpoint_free(struct sctp_endpoint *ep)
 /* Final destructor for endpoint.  */
 static void sctp_endpoint_destroy(struct sctp_endpoint *ep)
 {
+	int i;
+
 	SCTP_ASSERT(ep->base.dead, "Endpoint is not dead", return);
 
 	/* Free up the HMAC transform. */
@@ -270,6 +272,9 @@ static void sctp_endpoint_destroy(struct sctp_endpoint *ep)
 	sctp_inq_free(&ep->base.inqueue);
 	sctp_bind_addr_free(&ep->base.bind_addr);
 
+	for (i = 0; i < SCTP_HOW_MANY_SECRETS; ++i)
+		memset(&ep->secret_key[i], 0, SCTP_SECRET_SIZE);
+
 	/* Remove and free the port */
 	if (sctp_sk(ep->base.sk)->bind_hash)
 		sctp_put_port(ep->base.sk);
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index e7aa177c..e0902c9 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -223,7 +223,7 @@ void sctp_outq_init(struct sctp_association *asoc, struct sctp_outq *q)
 
 /* Free the outqueue structure and any related pending chunks.
  */
-void sctp_outq_teardown(struct sctp_outq *q)
+static void __sctp_outq_teardown(struct sctp_outq *q)
 {
 	struct sctp_transport *transport;
 	struct list_head *lchunk, *temp;
@@ -276,8 +276,6 @@ void sctp_outq_teardown(struct sctp_outq *q)
 		sctp_chunk_free(chunk);
 	}
 
-	q->error = 0;
-
 	/* Throw away any leftover control chunks. */
 	list_for_each_entry_safe(chunk, tmp, &q->control_chunk_list, list) {
 		list_del_init(&chunk->list);
@@ -285,11 +283,17 @@ void sctp_outq_teardown(struct sctp_outq *q)
 	}
 }
 
+void sctp_outq_teardown(struct sctp_outq *q)
+{
+	__sctp_outq_teardown(q);
+	sctp_outq_init(q->asoc, q);
+}
+
 /* Free the outqueue structure and any related pending chunks.  */
 void sctp_outq_free(struct sctp_outq *q)
 {
 	/* Throw away leftover chunks. */
-	sctp_outq_teardown(q);
+	__sctp_outq_teardown(q);
 
 	/* If we were kmalloc()'d, free the memory.  */
 	if (q->malloced)
diff --git a/net/sctp/probe.c b/net/sctp/probe.c
index bc6cd75..5f7518d 100644
--- a/net/sctp/probe.c
+++ b/net/sctp/probe.c
@@ -122,7 +122,8 @@ static const struct file_operations sctpprobe_fops = {
 	.llseek = noop_llseek,
 };
 
-sctp_disposition_t jsctp_sf_eat_sack(const struct sctp_endpoint *ep,
+sctp_disposition_t jsctp_sf_eat_sack(struct net *net,
+				     const struct sctp_endpoint *ep,
 				     const struct sctp_association *asoc,
 				     const sctp_subtype_t type,
 				     void *arg,
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index cb54123..d32d86d 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3375,7 +3375,7 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
 
 	ret = sctp_auth_set_key(sctp_sk(sk)->ep, asoc, authkey);
 out:
-	kfree(authkey);
+	kzfree(authkey);
 	return ret;
 }
 


