Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935075Ab3BTEWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 23:22:11 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38864 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933066Ab3BTEWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 23:22:06 -0500
Message-ID: <1361334114.29126.29.camel@deadeye.wl.decadent.org.uk>
Subject: Re: Linux 3.2.39
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Jiri Slaby <jslaby@suse.cz>,
        stable@vger.kernel.org
Cc: lwn@lwn.net
Date: Wed, 20 Feb 2013 04:21:54 +0000
In-Reply-To: <1361334049.29126.28.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-A2jLOVnA1UlJRJ6C81oV"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-A2jLOVnA1UlJRJ6C81oV
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

diff --git a/MAINTAINERS b/MAINTAINERS
index 82d7fa6..83f156e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2584,7 +2584,7 @@ S:	Maintained
 F:	drivers/net/ethernet/i825xx/eexpress.*
=20
 ETHERNET BRIDGE
-M:	Stephen Hemminger <shemminger@vyatta.com>
+M:	Stephen Hemminger <stephen@networkplumber.org>
 L:	bridge@lists.linux-foundation.org
 L:	netdev@vger.kernel.org
 W:	http://www.linuxfoundation.org/en/Net:Bridge
@@ -4475,7 +4475,7 @@ S:	Supported
 F:	drivers/infiniband/hw/nes/
=20
 NETEM NETWORK EMULATOR
-M:	Stephen Hemminger <shemminger@vyatta.com>
+M:	Stephen Hemminger <stephen@networkplumber.org>
 L:	netem@lists.linux-foundation.org
 S:	Maintained
 F:	net/sched/sch_netem.c
@@ -5993,7 +5993,7 @@ S:	Maintained
 F:	drivers/usb/misc/sisusbvga/
=20
 SKGE, SKY2 10/100/1000 GIGABIT ETHERNET DRIVERS
-M:	Stephen Hemminger <shemminger@vyatta.com>
+M:	Stephen Hemminger <stephen@networkplumber.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/marvell/sk*
diff --git a/Makefile b/Makefile
index c8c9d02..0fceb8b 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION =3D 3
 PATCHLEVEL =3D 2
-SUBLEVEL =3D 38
+SUBLEVEL =3D 39
 EXTRAVERSION =3D
 NAME =3D Saber-toothed Squirrel
=20
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index a6253ec..95b4eb3 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -208,7 +208,7 @@ sysexit_from_sys_call:
 	testl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),TI_flags(%r10)
 	jnz ia32_ret_from_sys_call
 	TRACE_IRQS_ON
-	sti
+	ENABLE_INTERRUPTS(CLBR_NONE)
 	movl %eax,%esi		/* second arg, syscall return value */
 	cmpl $0,%eax		/* is it < 0? */
 	setl %al		/* 1 if so, 0 if not */
@@ -218,7 +218,7 @@ sysexit_from_sys_call:
 	GET_THREAD_INFO(%r10)
 	movl RAX-ARGOFFSET(%rsp),%eax	/* reload syscall return value */
 	movl $(_TIF_ALLWORK_MASK & ~_TIF_SYSCALL_AUDIT),%edi
-	cli
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	testl %edi,TI_flags(%r10)
 	jz \exit
diff --git a/arch/x86/kernel/step.c b/arch/x86/kernel/step.c
index c346d11..d4f278e 100644
--- a/arch/x86/kernel/step.c
+++ b/arch/x86/kernel/step.c
@@ -157,6 +157,34 @@ static int enable_single_step(struct task_struct *chil=
d)
 	return 1;
 }
=20
+static void set_task_blockstep(struct task_struct *task, bool on)
+{
+	unsigned long debugctl;
+
+	/*
+	 * Ensure irq/preemption can't change debugctl in between.
+	 * Note also that both TIF_BLOCKSTEP and debugctl should
+	 * be changed atomically wrt preemption.
+	 *
+	 * NOTE: this means that set/clear TIF_BLOCKSTEP is only safe if
+	 * task is current or it can't be running, otherwise we can race
+	 * with __switch_to_xtra(). We rely on ptrace_freeze_traced() but
+	 * PTRACE_KILL is not safe.
+	 */
+	local_irq_disable();
+	debugctl =3D get_debugctlmsr();
+	if (on) {
+		debugctl |=3D DEBUGCTLMSR_BTF;
+		set_tsk_thread_flag(task, TIF_BLOCKSTEP);
+	} else {
+		debugctl &=3D ~DEBUGCTLMSR_BTF;
+		clear_tsk_thread_flag(task, TIF_BLOCKSTEP);
+	}
+	if (task =3D=3D current)
+		update_debugctlmsr(debugctl);
+	local_irq_enable();
+}
+
 /*
  * Enable single or block step.
  */
@@ -169,19 +197,10 @@ static void enable_step(struct task_struct *child, bo=
ol block)
 	 * So no one should try to use debugger block stepping in a program
 	 * that uses user-mode single stepping itself.
 	 */
-	if (enable_single_step(child) && block) {
-		unsigned long debugctl =3D get_debugctlmsr();
-
-		debugctl |=3D DEBUGCTLMSR_BTF;
-		update_debugctlmsr(debugctl);
-		set_tsk_thread_flag(child, TIF_BLOCKSTEP);
-	} else if (test_tsk_thread_flag(child, TIF_BLOCKSTEP)) {
-		unsigned long debugctl =3D get_debugctlmsr();
-
-		debugctl &=3D ~DEBUGCTLMSR_BTF;
-		update_debugctlmsr(debugctl);
-		clear_tsk_thread_flag(child, TIF_BLOCKSTEP);
-	}
+	if (enable_single_step(child) && block)
+		set_task_blockstep(child, true);
+	else if (test_tsk_thread_flag(child, TIF_BLOCKSTEP))
+		set_task_blockstep(child, false);
 }
=20
 void user_enable_single_step(struct task_struct *child)
@@ -199,13 +218,8 @@ void user_disable_single_step(struct task_struct *chil=
d)
 	/*
 	 * Make sure block stepping (BTF) is disabled.
 	 */
-	if (test_tsk_thread_flag(child, TIF_BLOCKSTEP)) {
-		unsigned long debugctl =3D get_debugctlmsr();
-
-		debugctl &=3D ~DEBUGCTLMSR_BTF;
-		update_debugctlmsr(debugctl);
-		clear_tsk_thread_flag(child, TIF_BLOCKSTEP);
-	}
+	if (test_tsk_thread_flag(child, TIF_BLOCKSTEP))
+		set_task_blockstep(child, false);
=20
 	/* Always clear TIF_SINGLESTEP... */
 	clear_tsk_thread_flag(child, TIF_SINGLESTEP);
diff --git a/arch/x86/xen/xen-asm_32.S b/arch/x86/xen/xen-asm_32.S
index b040b0e..7328f71 100644
--- a/arch/x86/xen/xen-asm_32.S
+++ b/arch/x86/xen/xen-asm_32.S
@@ -88,11 +88,11 @@ ENTRY(xen_iret)
 	 */
 #ifdef CONFIG_SMP
 	GET_THREAD_INFO(%eax)
-	movl TI_cpu(%eax), %eax
-	movl __per_cpu_offset(,%eax,4), %eax
-	mov xen_vcpu(%eax), %eax
+	movl %ss:TI_cpu(%eax), %eax
+	movl %ss:__per_cpu_offset(,%eax,4), %eax
+	mov %ss:xen_vcpu(%eax), %eax
 #else
-	movl xen_vcpu, %eax
+	movl %ss:xen_vcpu, %eax
 #endif
=20
 	/* check IF state we're restoring */
@@ -105,11 +105,11 @@ ENTRY(xen_iret)
 	 * resuming the code, so we don't have to be worried about
 	 * being preempted to another CPU.
 	 */
-	setz XEN_vcpu_info_mask(%eax)
+	setz %ss:XEN_vcpu_info_mask(%eax)
 xen_iret_start_crit:
=20
 	/* check for unmasked and pending */
-	cmpw $0x0001, XEN_vcpu_info_pending(%eax)
+	cmpw $0x0001, %ss:XEN_vcpu_info_pending(%eax)
=20
 	/*
 	 * If there's something pending, mask events again so we can
@@ -117,7 +117,7 @@ xen_iret_start_crit:
 	 * touch XEN_vcpu_info_mask.
 	 */
 	jne 1f
-	movb $1, XEN_vcpu_info_mask(%eax)
+	movb $1, %ss:XEN_vcpu_info_mask(%eax)
=20
 1:	popl %eax
=20
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index b07edc4..62c1325 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -52,7 +52,9 @@
 #define DRV_VERSION	"3.0"
=20
 enum {
-	AHCI_PCI_BAR		=3D 5,
+	AHCI_PCI_BAR_STA2X11	=3D 0,
+	AHCI_PCI_BAR_ENMOTUS	=3D 2,
+	AHCI_PCI_BAR_STANDARD	=3D 5,
 };
=20
 enum board_ids {
@@ -375,6 +377,9 @@ static const struct pci_device_id ahci_pci_tbl[] =3D {
 	{ PCI_VDEVICE(SI, 0x1185), board_ahci },		/* SiS 968 */
 	{ PCI_VDEVICE(SI, 0x0186), board_ahci },		/* SiS 968 */
=20
+	/* ST Microelectronics */
+	{ PCI_VDEVICE(STMICRO, 0xCC06), board_ahci },		/* ST ConneXt */
+
 	/* Marvell */
 	{ PCI_VDEVICE(MARVELL, 0x6145), board_ahci_mv },	/* 6145 */
 	{ PCI_VDEVICE(MARVELL, 0x6121), board_ahci_mv },	/* 6121 */
@@ -400,6 +405,9 @@ static const struct pci_device_id ahci_pci_tbl[] =3D {
 	{ PCI_VDEVICE(ASMEDIA, 0x0611), board_ahci },	/* ASM1061 */
 	{ PCI_VDEVICE(ASMEDIA, 0x0612), board_ahci },	/* ASM1062 */
=20
+	/* Enmotus */
+	{ PCI_DEVICE(0x1c44, 0x8000), board_ahci },
+
 	/* Generic, PCI class code for AHCI */
 	{ PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
 	  PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci },
@@ -629,6 +637,13 @@ static int ahci_configure_dma_masks(struct pci_dev *pd=
ev, int using_dac)
 {
 	int rc;
=20
+	/*
+	 * If the device fixup already set the dma_mask to some non-standard
+	 * value, don't extend it here. This happens on STA2X11, for example.
+	 */
+	if (pdev->dma_mask && pdev->dma_mask < DMA_BIT_MASK(32))
+		return 0;
+
 	if (using_dac &&
 	    !pci_set_dma_mask(pdev, DMA_BIT_MASK(64))) {
 		rc =3D pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
@@ -1033,6 +1048,7 @@ static int ahci_init_one(struct pci_dev *pdev, const =
struct pci_device_id *ent)
 	struct ahci_host_priv *hpriv;
 	struct ata_host *host;
 	int n_ports, i, rc;
+	int ahci_pci_bar =3D AHCI_PCI_BAR_STANDARD;
=20
 	VPRINTK("ENTER\n");
=20
@@ -1064,6 +1080,12 @@ static int ahci_init_one(struct pci_dev *pdev, const=
 struct pci_device_id *ent)
 		dev_info(&pdev->dev,
 			 "PDC42819 can only drive SATA devices with this driver\n");
=20
+	/* Both Connext and Enmotus devices use non-standard BARs */
+	if (pdev->vendor =3D=3D PCI_VENDOR_ID_STMICRO && pdev->device =3D=3D 0xCC=
06)
+		ahci_pci_bar =3D AHCI_PCI_BAR_STA2X11;
+	else if (pdev->vendor =3D=3D 0x1c44 && pdev->device =3D=3D 0x8000)
+		ahci_pci_bar =3D AHCI_PCI_BAR_ENMOTUS;
+
 	/* acquire resources */
 	rc =3D pcim_enable_device(pdev);
 	if (rc)
@@ -1072,7 +1094,7 @@ static int ahci_init_one(struct pci_dev *pdev, const =
struct pci_device_id *ent)
 	/* AHCI controllers often implement SFF compatible interface.
 	 * Grab all PCI BARs just in case.
 	 */
-	rc =3D pcim_iomap_regions_request_all(pdev, 1 << AHCI_PCI_BAR, DRV_NAME);
+	rc =3D pcim_iomap_regions_request_all(pdev, 1 << ahci_pci_bar, DRV_NAME);
 	if (rc =3D=3D -EBUSY)
 		pcim_pin_device(pdev);
 	if (rc)
@@ -1115,7 +1137,7 @@ static int ahci_init_one(struct pci_dev *pdev, const =
struct pci_device_id *ent)
 	if ((hpriv->flags & AHCI_HFLAG_NO_MSI) || pci_enable_msi(pdev))
 		pci_intx(pdev, 1);
=20
-	hpriv->mmio =3D pcim_iomap_table(pdev)[AHCI_PCI_BAR];
+	hpriv->mmio =3D pcim_iomap_table(pdev)[ahci_pci_bar];
=20
 	/* save initial config */
 	ahci_pci_save_initial_config(pdev, hpriv);
@@ -1179,8 +1201,8 @@ static int ahci_init_one(struct pci_dev *pdev, const =
struct pci_device_id *ent)
 	for (i =3D 0; i < host->n_ports; i++) {
 		struct ata_port *ap =3D host->ports[i];
=20
-		ata_port_pbar_desc(ap, AHCI_PCI_BAR, -1, "abar");
-		ata_port_pbar_desc(ap, AHCI_PCI_BAR,
+		ata_port_pbar_desc(ap, ahci_pci_bar, -1, "abar");
+		ata_port_pbar_desc(ap, ahci_pci_bar,
 				   0x100 + ap->port_no * 0x80, "port");
=20
 		/* set enclosure management message type */
diff --git a/drivers/atm/iphase.h b/drivers/atm/iphase.h
index 6a0955e..53ecac5 100644
--- a/drivers/atm/iphase.h
+++ b/drivers/atm/iphase.h
@@ -636,82 +636,82 @@ struct rx_buf_desc {
 #define SEG_BASE IPHASE5575_FRAG_CONTROL_REG_BASE =20
 #define REASS_BASE IPHASE5575_REASS_CONTROL_REG_BASE =20
=20
-typedef volatile u_int  freg_t;
+typedef volatile u_int	ffreg_t;
 typedef u_int   rreg_t;
=20
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
-        u_int   fillercc[0x100-0xcc]; /* pad out to full address space   *=
/
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
=20
 typedef struct _rfredn_t {
diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 8e3c46d..7795d1e 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1789,7 +1789,8 @@ static void virtcons_remove(struct virtio_device *vde=
v)
 	/* Disable interrupts for vqs */
 	vdev->config->reset(vdev);
 	/* Finish up work that's lined up */
-	cancel_work_sync(&portdev->control_work);
+	if (use_multiport(portdev))
+		cancel_work_sync(&portdev->control_work);
=20
 	list_for_each_entry_safe(port, port2, &portdev->ports, list)
 		unplug_port(port);
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/in=
tel_display.c
index c05e825..7817429 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7156,8 +7156,6 @@ static int intel_gen4_queue_flip(struct drm_device *d=
ev,
 	OUT_RING(pf | pipesrc);
=20
 	intel_mark_page_flip_active(intel_crtc);
-
-	intel_mark_page_flip_active(intel_crtc);
 	ADVANCE_LP_RING();
 	return 0;
=20
@@ -7193,6 +7191,8 @@ static int intel_gen6_queue_flip(struct drm_device *d=
ev,
 	pf =3D I915_READ(PF_CTL(intel_crtc->pipe)) & PF_ENABLE;
 	pipesrc =3D I915_READ(PIPESRC(intel_crtc->pipe)) & 0x0fff0fff;
 	OUT_RING(pf | pipesrc);
+
+	intel_mark_page_flip_active(intel_crtc);
 	ADVANCE_LP_RING();
 	return 0;
=20
diff --git a/drivers/gpu/drm/radeon/radeon_combios.c b/drivers/gpu/drm/rade=
on/radeon_combios.c
index 1b98338..ec36dd9 100644
--- a/drivers/gpu/drm/radeon/radeon_combios.c
+++ b/drivers/gpu/drm/radeon/radeon_combios.c
@@ -2455,6 +2455,14 @@ bool radeon_get_legacy_connector_info_from_bios(stru=
ct drm_device *dev)
 								   1),
 								  ATOM_DEVICE_CRT1_SUPPORT);
 				}
+				/* RV100 board with external TDMS bit mis-set.
+				 * Actually uses internal TMDS, clear the bit.
+				 */
+				if (dev->pdev->device =3D=3D 0x5159 &&
+				    dev->pdev->subsystem_vendor =3D=3D 0x1014 &&
+				    dev->pdev->subsystem_device =3D=3D 0x029A) {
+					tmp &=3D ~(1 << 4);
+				}
 				if ((tmp >> 4) & 0x1) {
 					devices |=3D ATOM_DEVICE_DFP2_SUPPORT;
 					radeon_add_legacy_encoder(dev,
diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/rade=
on/radeon_display.c
index aec8e0c..63e7143 100644
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -1110,8 +1110,10 @@ radeon_user_framebuffer_create(struct drm_device *de=
v,
 	}
=20
 	radeon_fb =3D kzalloc(sizeof(*radeon_fb), GFP_KERNEL);
-	if (radeon_fb =3D=3D NULL)
+	if (radeon_fb =3D=3D NULL) {
+		drm_gem_object_unreference_unlocked(obj);
 		return ERR_PTR(-ENOMEM);
+	}
=20
 	radeon_framebuffer_init(dev, radeon_fb, mode_cmd, obj);
=20
diff --git a/drivers/gpu/drm/radeon/radeon_ring.c b/drivers/gpu/drm/radeon/=
radeon_ring.c
index 49d5820..65be5e8 100644
--- a/drivers/gpu/drm/radeon/radeon_ring.c
+++ b/drivers/gpu/drm/radeon/radeon_ring.c
@@ -306,6 +306,9 @@ int radeon_ring_alloc(struct radeon_device *rdev, unsig=
ned ndw)
 {
 	int r;
=20
+	/* make sure we aren't trying to allocate more space than there is on the=
 ring */
+	if (ndw > (rdev->cp.ring_size / 4))
+		return -ENOMEM;
 	/* Align requested size with padding so unlock_commit can
 	 * pad safely */
 	ndw =3D (ndw + rdev->cp.align_mask) & ~rdev->cp.align_mask;
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 2d41336..c15c38e 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -278,6 +278,9 @@
 #define USB_VENDOR_ID_EZKEY		0x0518
 #define USB_DEVICE_ID_BTC_8193		0x0002
=20
+#define USB_VENDOR_ID_FORMOSA          0x147a
+#define USB_DEVICE_ID_FORMOSA_IR_RECEIVER      0xe03e
+
 #define USB_VENDOR_ID_FREESCALE		0x15A2
 #define USB_DEVICE_ID_FREESCALE_MX28	0x004F
=20
diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirk=
s.c
index aec3fa3..e26eddf 100644
--- a/drivers/hid/usbhid/hid-quirks.c
+++ b/drivers/hid/usbhid/hid-quirks.c
@@ -68,6 +68,7 @@ static const struct hid_blacklist {
 	{ USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_AXIS_295, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_DMI, USB_DEVICE_ID_DMI_ENC, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_ELO, USB_DEVICE_ID_ELO_TS2700, HID_QUIRK_NOGET },
+	{ USB_VENDOR_ID_FORMOSA, USB_DEVICE_ID_FORMOSA_IR_RECEIVER, HID_QUIRK_NO_=
INIT_REPORTS },
 	{ USB_VENDOR_ID_FREESCALE, USB_DEVICE_ID_FREESCALE_MX28, HID_QUIRK_NOGET =
},
 	{ USB_VENDOR_ID_MGE, USB_DEVICE_ID_MGE_UPS, HID_QUIRK_NOGET },
 	{ USB_VENDOR_ID_PIXART, USB_DEVICE_ID_PIXART_OPTICAL_TOUCH_SCREEN, HID_QU=
IRK_NO_INIT_REPORTS },
diff --git a/drivers/isdn/gigaset/capi.c b/drivers/isdn/gigaset/capi.c
index fd17bb3..08c2329 100644
--- a/drivers/isdn/gigaset/capi.c
+++ b/drivers/isdn/gigaset/capi.c
@@ -264,6 +264,8 @@ static inline void dump_rawmsg(enum debuglevel level, c=
onst char *tag,
 		CAPIMSG_APPID(data), CAPIMSG_MSGID(data), l,
 		CAPIMSG_CONTROL(data));
 	l -=3D 12;
+	if (l <=3D 0)
+		return;
 	dbgline =3D kmalloc(3*l, GFP_ATOMIC);
 	if (!dbgline)
 		return;
diff --git a/drivers/media/video/gspca/kinect.c b/drivers/media/video/gspca=
/kinect.c
index 4fe51fd..acaef66 100644
--- a/drivers/media/video/gspca/kinect.c
+++ b/drivers/media/video/gspca/kinect.c
@@ -390,6 +390,7 @@ static const struct sd_desc sd_desc =3D {
 /* -- module initialisation -- */
 static const struct usb_device_id device_table[] =3D {
 	{USB_DEVICE(0x045e, 0x02ae)},
+	{USB_DEVICE(0x045e, 0x02bf)},
 	{}
 };
=20
diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 21a3d77..64647d4 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -446,8 +446,12 @@ static void c_can_setup_receive_object(struct net_devi=
ce *dev, int iface,
=20
 	priv->write_reg(priv, &priv->regs->ifregs[iface].mask1,
 			IFX_WRITE_LOW_16BIT(mask));
+
+	/* According to C_CAN documentation, the reserved bit
+	 * in IFx_MASK2 register is fixed 1
+	 */
 	priv->write_reg(priv, &priv->regs->ifregs[iface].mask2,
-			IFX_WRITE_HIGH_16BIT(mask));
+			IFX_WRITE_HIGH_16BIT(mask) | BIT(13));
=20
 	priv->write_reg(priv, &priv->regs->ifregs[iface].arb1,
 			IFX_WRITE_LOW_16BIT(id));
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/bro=
adcom/tg3.c
index 01bc102..c86fa50 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -1135,14 +1135,26 @@ static int tg3_phy_auxctl_write(struct tg3 *tp, int=
 reg, u32 set)
 	return tg3_writephy(tp, MII_TG3_AUX_CTRL, set | reg);
 }
=20
-#define TG3_PHY_AUXCTL_SMDSP_ENABLE(tp) \
-	tg3_phy_auxctl_write((tp), MII_TG3_AUXCTL_SHDWSEL_AUXCTL, \
-			     MII_TG3_AUXCTL_ACTL_SMDSP_ENA | \
-			     MII_TG3_AUXCTL_ACTL_TX_6DB)
+static int tg3_phy_toggle_auxctl_smdsp(struct tg3 *tp, bool enable)
+{
+	u32 val;
+	int err;
=20
-#define TG3_PHY_AUXCTL_SMDSP_DISABLE(tp) \
-	tg3_phy_auxctl_write((tp), MII_TG3_AUXCTL_SHDWSEL_AUXCTL, \
-			     MII_TG3_AUXCTL_ACTL_TX_6DB);
+	err =3D tg3_phy_auxctl_read(tp, MII_TG3_AUXCTL_SHDWSEL_AUXCTL, &val);
+
+	if (err)
+		return err;
+	if (enable)
+
+		val |=3D MII_TG3_AUXCTL_ACTL_SMDSP_ENA;
+	else
+		val &=3D ~MII_TG3_AUXCTL_ACTL_SMDSP_ENA;
+
+	err =3D tg3_phy_auxctl_write((tp), MII_TG3_AUXCTL_SHDWSEL_AUXCTL,
+				   val | MII_TG3_AUXCTL_ACTL_TX_6DB);
+
+	return err;
+}
=20
 static int tg3_bmcr_reset(struct tg3 *tp)
 {
@@ -2087,7 +2099,7 @@ static void tg3_phy_apply_otp(struct tg3 *tp)
=20
 	otp =3D tp->phy_otp;
=20
-	if (TG3_PHY_AUXCTL_SMDSP_ENABLE(tp))
+	if (tg3_phy_toggle_auxctl_smdsp(tp, true))
 		return;
=20
 	phy =3D ((otp & TG3_OTP_AGCTGT_MASK) >> TG3_OTP_AGCTGT_SHIFT);
@@ -2112,7 +2124,7 @@ static void tg3_phy_apply_otp(struct tg3 *tp)
 	      ((otp & TG3_OTP_RCOFF_MASK) >> TG3_OTP_RCOFF_SHIFT);
 	tg3_phydsp_write(tp, MII_TG3_DSP_EXP97, phy);
=20
-	TG3_PHY_AUXCTL_SMDSP_DISABLE(tp);
+	tg3_phy_toggle_auxctl_smdsp(tp, false);
 }
=20
 static void tg3_phy_eee_adjust(struct tg3 *tp, u32 current_link_up)
@@ -2148,9 +2160,9 @@ static void tg3_phy_eee_adjust(struct tg3 *tp, u32 cu=
rrent_link_up)
=20
 	if (!tp->setlpicnt) {
 		if (current_link_up =3D=3D 1 &&
-		   !TG3_PHY_AUXCTL_SMDSP_ENABLE(tp)) {
+		   !tg3_phy_toggle_auxctl_smdsp(tp, true)) {
 			tg3_phydsp_write(tp, MII_TG3_DSP_TAP26, 0x0000);
-			TG3_PHY_AUXCTL_SMDSP_DISABLE(tp);
+			tg3_phy_toggle_auxctl_smdsp(tp, false);
 		}
=20
 		val =3D tr32(TG3_CPMU_EEE_MODE);
@@ -2166,11 +2178,11 @@ static void tg3_phy_eee_enable(struct tg3 *tp)
 	    (GET_ASIC_REV(tp->pci_chip_rev_id) =3D=3D ASIC_REV_5717 ||
 	     GET_ASIC_REV(tp->pci_chip_rev_id) =3D=3D ASIC_REV_5719 ||
 	     GET_ASIC_REV(tp->pci_chip_rev_id) =3D=3D ASIC_REV_57765) &&
-	    !TG3_PHY_AUXCTL_SMDSP_ENABLE(tp)) {
+	    !tg3_phy_toggle_auxctl_smdsp(tp, true)) {
 		val =3D MII_TG3_DSP_TAP26_ALNOKO |
 		      MII_TG3_DSP_TAP26_RMRXSTO;
 		tg3_phydsp_write(tp, MII_TG3_DSP_TAP26, val);
-		TG3_PHY_AUXCTL_SMDSP_DISABLE(tp);
+		tg3_phy_toggle_auxctl_smdsp(tp, false);
 	}
=20
 	val =3D tr32(TG3_CPMU_EEE_MODE);
@@ -2314,7 +2326,7 @@ static int tg3_phy_reset_5703_4_5(struct tg3 *tp)
 		tg3_writephy(tp, MII_CTRL1000,
 			     CTL1000_AS_MASTER | CTL1000_ENABLE_MASTER);
=20
-		err =3D TG3_PHY_AUXCTL_SMDSP_ENABLE(tp);
+		err =3D tg3_phy_toggle_auxctl_smdsp(tp, true);
 		if (err)
 			return err;
=20
@@ -2335,7 +2347,7 @@ static int tg3_phy_reset_5703_4_5(struct tg3 *tp)
 	tg3_writephy(tp, MII_TG3_DSP_ADDRESS, 0x8200);
 	tg3_writephy(tp, MII_TG3_DSP_CONTROL, 0x0000);
=20
-	TG3_PHY_AUXCTL_SMDSP_DISABLE(tp);
+	tg3_phy_toggle_auxctl_smdsp(tp, false);
=20
 	tg3_writephy(tp, MII_CTRL1000, phy9_orig);
=20
@@ -2424,10 +2436,10 @@ static int tg3_phy_reset(struct tg3 *tp)
=20
 out:
 	if ((tp->phy_flags & TG3_PHYFLG_ADC_BUG) &&
-	    !TG3_PHY_AUXCTL_SMDSP_ENABLE(tp)) {
+	    !tg3_phy_toggle_auxctl_smdsp(tp, true)) {
 		tg3_phydsp_write(tp, 0x201f, 0x2aaa);
 		tg3_phydsp_write(tp, 0x000a, 0x0323);
-		TG3_PHY_AUXCTL_SMDSP_DISABLE(tp);
+		tg3_phy_toggle_auxctl_smdsp(tp, false);
 	}
=20
 	if (tp->phy_flags & TG3_PHYFLG_5704_A0_BUG) {
@@ -2436,14 +2448,14 @@ out:
 	}
=20
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
@@ -2452,7 +2464,7 @@ out:
 			} else
 				tg3_writephy(tp, MII_TG3_DSP_RW_PORT, 0x010b);
=20
-			TG3_PHY_AUXCTL_SMDSP_DISABLE(tp);
+			tg3_phy_toggle_auxctl_smdsp(tp, false);
 		}
 	}
=20
@@ -3639,7 +3651,7 @@ static int tg3_phy_autoneg_cfg(struct tg3 *tp, u32 ad=
vertise, u32 flowctrl)
 	tw32(TG3_CPMU_EEE_MODE,
 	     tr32(TG3_CPMU_EEE_MODE) & ~TG3_CPMU_EEEMD_LPI_ENABLE);
=20
-	err =3D TG3_PHY_AUXCTL_SMDSP_ENABLE(tp);
+	err =3D tg3_phy_toggle_auxctl_smdsp(tp, true);
 	if (!err) {
 		u32 err2;
=20
@@ -3671,7 +3683,7 @@ static int tg3_phy_autoneg_cfg(struct tg3 *tp, u32 ad=
vertise, u32 flowctrl)
 						 MII_TG3_DSP_CH34TP2_HIBW01);
 		}
=20
-		err2 =3D TG3_PHY_AUXCTL_SMDSP_DISABLE(tp);
+		err2 =3D tg3_phy_toggle_auxctl_smdsp(tp, false);
 		if (!err)
 			err =3D err2;
 	}
@@ -6353,6 +6365,9 @@ static void tg3_poll_controller(struct net_device *de=
v)
 	int i;
 	struct tg3 *tp =3D netdev_priv(dev);
=20
+	if (tg3_irq_sync(tp))
+		return;
+
 	for (i =3D 0; i < tp->irq_cnt; i++)
 		tg3_interrupt(tp->napi[i].irq_vec, &tp->napi[i]);
 }
@@ -15388,6 +15403,7 @@ static int __devinit tg3_init_one(struct pci_dev *p=
dev,
 	tp->pm_cap =3D pm_cap;
 	tp->rx_mode =3D TG3_DEF_RX_MODE;
 	tp->tx_mode =3D TG3_DEF_TX_MODE;
+	tp->irq_sync =3D 1;
=20
 	if (tg3_debug > 0)
 		tp->msg_enable =3D tg3_debug;
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c b/drivers=
/net/ethernet/qlogic/netxen/netxen_nic_init.c
index a8259cc..5674145 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
@@ -144,7 +144,7 @@ void netxen_release_tx_buffers(struct netxen_adapter *a=
dapter)
 					 buffrag->length, PCI_DMA_TODEVICE);
 			buffrag->dma =3D 0ULL;
 		}
-		for (j =3D 0; j < cmd_buf->frag_count; j++) {
+		for (j =3D 1; j < cmd_buf->frag_count; j++) {
 			buffrag++;
 			if (buffrag->dma) {
 				pci_unmap_page(adapter->pdev, buffrag->dma,
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers=
/net/ethernet/qlogic/netxen/netxen_nic_main.c
index da5204d..4a238a4 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -1924,10 +1924,12 @@ unwind:
 	while (--i >=3D 0) {
 		nf =3D &pbuf->frag_array[i+1];
 		pci_unmap_page(pdev, nf->dma, nf->length, PCI_DMA_TODEVICE);
+		nf->dma =3D 0ULL;
 	}
=20
 	nf =3D &pbuf->frag_array[0];
 	pci_unmap_single(pdev, nf->dma, skb_headlen(skb), PCI_DMA_TODEVICE);
+	nf->dma =3D 0ULL;
=20
 out_err:
 	return -ENOMEM;
diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/re=
altek/r8169.c
index b8db4cd..a6153f1 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -5829,13 +5829,6 @@ static int rtl8169_rx_interrupt(struct net_device *d=
ev,
 			dev->stats.rx_bytes +=3D pkt_size;
 			dev->stats.rx_packets++;
 		}
-
-		/* Work around for AMD plateform. */
-		if ((desc->opts2 & cpu_to_le32(0xfffe000)) &&
-		    (tp->mac_version =3D=3D RTL_GIGA_MAC_VER_05)) {
-			desc->opts2 =3D 0;
-			cur_rx++;
-		}
 	}
=20
 	count =3D cur_rx - tp->cur_rx;
diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index 4ce9e5f..d0893e4 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -78,6 +78,11 @@ static netdev_tx_t loopback_xmit(struct sk_buff *skb,
=20
 	skb_orphan(skb);
=20
+	/* Before queueing this packet to netif_rx(),
+	 * make sure dst is refcounted.
+	 */
+	skb_dst_force(skb);
+
 	skb->protocol =3D eth_type_trans(skb, dev);
=20
 	/* it's OK to use per_cpu_ptr() because BHs are off */
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwi=
fiex/scan.c
index 8d3ab37..6618dd6 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1594,7 +1594,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *p=
riv,
 		dev_err(adapter->dev, "SCAN_RESP: too many AP returned (%d)\n",
 		       scan_rsp->number_of_sets);
 		ret =3D -1;
-		goto done;
+		goto check_next_scan;
 	}
=20
 	bytes_left =3D le16_to_cpu(scan_rsp->bss_descript_size);
@@ -1663,7 +1663,8 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *p=
riv,
 		if (!beacon_size || beacon_size > bytes_left) {
 			bss_info +=3D bytes_left;
 			bytes_left =3D 0;
-			return -1;
+			ret =3D -1;
+			goto check_next_scan;
 		}
=20
 		/* Initialize the current working beacon pointer for this BSS
@@ -1716,7 +1717,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *p=
riv,
 				dev_err(priv->adapter->dev, "%s: in processing"
 					" IE, bytes left < IE length\n",
 					__func__);
-				goto done;
+				goto check_next_scan;
 			}
 			if (element_id =3D=3D WLAN_EID_DS_PARAMS) {
 				channel =3D *(u8 *) (current_ptr +
@@ -1782,6 +1783,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *p=
riv,
 		}
 	}
=20
+check_next_scan:
 	spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
 	if (list_empty(&adapter->scan_pending_q)) {
 		spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
@@ -1812,7 +1814,6 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *p=
riv,
 		mwifiex_insert_cmd_to_pending_q(adapter, cmd_node, true);
 	}
=20
-done:
 	return ret;
 }
=20
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless=
/rt2x00/rt2500usb.c
index 22ed6df..2be9880 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1921,7 +1921,7 @@ static struct usb_device_id rt2500usb_device_table[] =
=3D {
 	{ USB_DEVICE(0x0b05, 0x1706) },
 	{ USB_DEVICE(0x0b05, 0x1707) },
 	/* Belkin */
-	{ USB_DEVICE(0x050d, 0x7050) },
+	{ USB_DEVICE(0x050d, 0x7050) },	/* FCC ID: K7SF5D7050A ver. 2.x */
 	{ USB_DEVICE(0x050d, 0x7051) },
 	/* Cisco Systems */
 	{ USB_DEVICE(0x13b1, 0x000d) },
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless=
/rt2x00/rt2800usb.c
index b66a61b..3d4ea1f 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -959,6 +959,7 @@ static struct usb_device_id rt2800usb_device_table[] =
=3D {
 	{ USB_DEVICE(0x07d1, 0x3c15) },
 	{ USB_DEVICE(0x07d1, 0x3c16) },
 	{ USB_DEVICE(0x2001, 0x3c1b) },
+	{ USB_DEVICE(0x2001, 0x3c1e) },
 	/* Draytek */
 	{ USB_DEVICE(0x07fa, 0x7712) },
 	/* DVICO */
@@ -1090,6 +1091,7 @@ static struct usb_device_id rt2800usb_device_table[] =
=3D {
 	{ USB_DEVICE(0x177f, 0x0153) },
 	{ USB_DEVICE(0x177f, 0x0302) },
 	{ USB_DEVICE(0x177f, 0x0313) },
+	{ USB_DEVICE(0x177f, 0x0323) },
 	/* U-Media */
 	{ USB_DEVICE(0x157e, 0x300e) },
 	{ USB_DEVICE(0x157e, 0x3013) },
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/r=
t2x00/rt73usb.c
index 2ad468d..9e724eb 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2421,6 +2421,7 @@ static struct usb_device_id rt73usb_device_table[] =
=3D {
 	{ USB_DEVICE(0x0b05, 0x1723) },
 	{ USB_DEVICE(0x0b05, 0x1724) },
 	/* Belkin */
+	{ USB_DEVICE(0x050d, 0x7050) },	/* FCC ID: K7SF5D7050B ver. 3.x */
 	{ USB_DEVICE(0x050d, 0x705a) },
 	{ USB_DEVICE(0x050d, 0x905b) },
 	{ USB_DEVICE(0x050d, 0x905c) },
diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlw=
ifi/usb.c
index a49e848..30dd0a9 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -503,8 +503,8 @@ static void _rtl_rx_pre_process(struct ieee80211_hw *hw=
, struct sk_buff *skb)
 	WARN_ON(skb_queue_empty(&rx_queue));
 	while (!skb_queue_empty(&rx_queue)) {
 		_skb =3D skb_dequeue(&rx_queue);
-		_rtl_usb_rx_process_agg(hw, skb);
-		ieee80211_rx_irqsafe(hw, skb);
+		_rtl_usb_rx_process_agg(hw, _skb);
+		ieee80211_rx_irqsafe(hw, _skb);
 	}
 }
=20
diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/com=
mon.h
index 94b79c3..9d7f172 100644
--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -151,6 +151,9 @@ void xen_netbk_queue_tx_skb(struct xenvif *vif, struct =
sk_buff *skb);
 /* Notify xenvif that ring now has space to send an skb to the frontend */
 void xenvif_notify_tx_completion(struct xenvif *vif);
=20
+/* Prevent the device from generating any further traffic. */
+void xenvif_carrier_off(struct xenvif *vif);
+
 /* Returns number of ring slots required to send an skb to the frontend */
 unsigned int xen_netbk_count_skb_slots(struct xenvif *vif, struct sk_buff =
*skb);
=20
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/=
interface.c
index 1825629..5925e0b 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -342,17 +342,22 @@ err:
 	return err;
 }
=20
-void xenvif_disconnect(struct xenvif *vif)
+void xenvif_carrier_off(struct xenvif *vif)
 {
 	struct net_device *dev =3D vif->dev;
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
=20
 	atomic_dec(&vif->refcnt);
 	wait_event(vif->waiting_to_free, atomic_read(&vif->refcnt) =3D=3D 0);
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/ne=
tback.c
index 15e332d..b802bb3 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -146,7 +146,8 @@ void xen_netbk_remove_xenvif(struct xenvif *vif)
 	atomic_dec(&netbk->netfront_count);
 }
=20
-static void xen_netbk_idx_release(struct xen_netbk *netbk, u16 pending_idx=
);
+static void xen_netbk_idx_release(struct xen_netbk *netbk, u16 pending_idx=
,
+				  u8 status);
 static void make_tx_response(struct xenvif *vif,
 			     struct xen_netif_tx_request *txp,
 			     s8       st);
@@ -851,7 +852,7 @@ static void netbk_tx_err(struct xenvif *vif,
=20
 	do {
 		make_tx_response(vif, txp, XEN_NETIF_RSP_ERROR);
-		if (cons >=3D end)
+		if (cons =3D=3D end)
 			break;
 		txp =3D RING_GET_REQUEST(&vif->tx, cons++);
 	} while (1);
@@ -860,6 +861,13 @@ static void netbk_tx_err(struct xenvif *vif,
 	xenvif_put(vif);
 }
=20
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
@@ -873,19 +881,22 @@ static int netbk_count_requests(struct xenvif *vif,
=20
 	do {
 		if (frags >=3D work_to_do) {
-			netdev_dbg(vif->dev, "Need more frags\n");
+			netdev_err(vif->dev, "Need more frags\n");
+			netbk_fatal_tx_err(vif);
 			return -frags;
 		}
=20
 		if (unlikely(frags >=3D MAX_SKB_FRAGS)) {
-			netdev_dbg(vif->dev, "Too many frags\n");
+			netdev_err(vif->dev, "Too many frags\n");
+			netbk_fatal_tx_err(vif);
 			return -frags;
 		}
=20
 		memcpy(txp, RING_GET_REQUEST(&vif->tx, cons + frags),
 		       sizeof(*txp));
 		if (txp->size > first->size) {
-			netdev_dbg(vif->dev, "Frags galore\n");
+			netdev_err(vif->dev, "Frag is bigger than frame.\n");
+			netbk_fatal_tx_err(vif);
 			return -frags;
 		}
=20
@@ -893,8 +904,9 @@ static int netbk_count_requests(struct xenvif *vif,
 		frags++;
=20
 		if (unlikely((txp->offset + txp->size) > PAGE_SIZE)) {
-			netdev_dbg(vif->dev, "txp->offset: %x, size: %u\n",
+			netdev_err(vif->dev, "txp->offset: %x, size: %u\n",
 				 txp->offset, txp->size);
+			netbk_fatal_tx_err(vif);
 			return -frags;
 		}
 	} while ((txp++)->flags & XEN_NETTXF_more_data);
@@ -938,7 +950,7 @@ static struct gnttab_copy *xen_netbk_get_requests(struc=
t xen_netbk *netbk,
 		pending_idx =3D netbk->pending_ring[index];
 		page =3D xen_netbk_alloc_page(netbk, skb, pending_idx);
 		if (!page)
-			return NULL;
+			goto err;
=20
 		netbk->mmap_pages[pending_idx] =3D page;
=20
@@ -962,6 +974,17 @@ static struct gnttab_copy *xen_netbk_get_requests(stru=
ct xen_netbk *netbk,
 	}
=20
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
=20
 static int xen_netbk_tx_check_gop(struct xen_netbk *netbk,
@@ -970,30 +993,20 @@ static int xen_netbk_tx_check_gop(struct xen_netbk *n=
etbk,
 {
 	struct gnttab_copy *gop =3D *gopp;
 	u16 pending_idx =3D *((u16 *)skb->data);
-	struct pending_tx_info *pending_tx_info =3D netbk->pending_tx_info;
-	struct xenvif *vif =3D pending_tx_info[pending_idx].vif;
-	struct xen_netif_tx_request *txp;
 	struct skb_shared_info *shinfo =3D skb_shinfo(skb);
 	int nr_frags =3D shinfo->nr_frags;
 	int i, err, start;
=20
 	/* Check status of header. */
 	err =3D gop->status;
-	if (unlikely(err)) {
-		pending_ring_idx_t index;
-		index =3D pending_index(netbk->pending_prod++);
-		txp =3D &pending_tx_info[pending_idx].req;
-		make_tx_response(vif, txp, XEN_NETIF_RSP_ERROR);
-		netbk->pending_ring[index] =3D pending_idx;
-		xenvif_put(vif);
-	}
+	if (unlikely(err))
+		xen_netbk_idx_release(netbk, pending_idx, XEN_NETIF_RSP_ERROR);
=20
 	/* Skip first skb fragment if it is on same page as header fragment. */
 	start =3D (frag_get_pending_idx(&shinfo->frags[0]) =3D=3D pending_idx);
=20
 	for (i =3D start; i < nr_frags; i++) {
 		int j, newerr;
-		pending_ring_idx_t index;
=20
 		pending_idx =3D frag_get_pending_idx(&shinfo->frags[i]);
=20
@@ -1002,16 +1015,12 @@ static int xen_netbk_tx_check_gop(struct xen_netbk =
*netbk,
 		if (likely(!newerr)) {
 			/* Had a previous error? Invalidate this fragment. */
 			if (unlikely(err))
-				xen_netbk_idx_release(netbk, pending_idx);
+				xen_netbk_idx_release(netbk, pending_idx, XEN_NETIF_RSP_OKAY);
 			continue;
 		}
=20
 		/* Error on this fragment: respond to client with an error. */
-		txp =3D &netbk->pending_tx_info[pending_idx].req;
-		make_tx_response(vif, txp, XEN_NETIF_RSP_ERROR);
-		index =3D pending_index(netbk->pending_prod++);
-		netbk->pending_ring[index] =3D pending_idx;
-		xenvif_put(vif);
+		xen_netbk_idx_release(netbk, pending_idx, XEN_NETIF_RSP_ERROR);
=20
 		/* Not the first error? Preceding frags already invalidated. */
 		if (err)
@@ -1019,10 +1028,10 @@ static int xen_netbk_tx_check_gop(struct xen_netbk =
*netbk,
=20
 		/* First error: invalidate header and preceding fragments. */
 		pending_idx =3D *((u16 *)skb->data);
-		xen_netbk_idx_release(netbk, pending_idx);
+		xen_netbk_idx_release(netbk, pending_idx, XEN_NETIF_RSP_OKAY);
 		for (j =3D start; j < i; j++) {
 			pending_idx =3D frag_get_pending_idx(&shinfo->frags[j]);
-			xen_netbk_idx_release(netbk, pending_idx);
+			xen_netbk_idx_release(netbk, pending_idx, XEN_NETIF_RSP_OKAY);
 		}
=20
 		/* Remember the error: invalidate all subsequent fragments. */
@@ -1056,7 +1065,7 @@ static void xen_netbk_fill_frags(struct xen_netbk *ne=
tbk, struct sk_buff *skb)
=20
 		/* Take an extra reference to offset xen_netbk_idx_release */
 		get_page(netbk->mmap_pages[pending_idx]);
-		xen_netbk_idx_release(netbk, pending_idx);
+		xen_netbk_idx_release(netbk, pending_idx, XEN_NETIF_RSP_OKAY);
 	}
 }
=20
@@ -1069,7 +1078,8 @@ static int xen_netbk_get_extras(struct xenvif *vif,
=20
 	do {
 		if (unlikely(work_to_do-- <=3D 0)) {
-			netdev_dbg(vif->dev, "Missing extra info\n");
+			netdev_err(vif->dev, "Missing extra info\n");
+			netbk_fatal_tx_err(vif);
 			return -EBADR;
 		}
=20
@@ -1078,8 +1088,9 @@ static int xen_netbk_get_extras(struct xenvif *vif,
 		if (unlikely(!extra.type ||
 			     extra.type >=3D XEN_NETIF_EXTRA_TYPE_MAX)) {
 			vif->tx.req_cons =3D ++cons;
-			netdev_dbg(vif->dev,
+			netdev_err(vif->dev,
 				   "Invalid extra type: %d\n", extra.type);
+			netbk_fatal_tx_err(vif);
 			return -EINVAL;
 		}
=20
@@ -1095,13 +1106,15 @@ static int netbk_set_skb_gso(struct xenvif *vif,
 			     struct xen_netif_extra_info *gso)
 {
 	if (!gso->u.gso.size) {
-		netdev_dbg(vif->dev, "GSO size must not be zero.\n");
+		netdev_err(vif->dev, "GSO size must not be zero.\n");
+		netbk_fatal_tx_err(vif);
 		return -EINVAL;
 	}
=20
 	/* Currently only TCPv4 S.O. is supported. */
 	if (gso->u.gso.type !=3D XEN_NETIF_GSO_TYPE_TCPV4) {
-		netdev_dbg(vif->dev, "Bad GSO type %d.\n", gso->u.gso.type);
+		netdev_err(vif->dev, "Bad GSO type %d.\n", gso->u.gso.type);
+		netbk_fatal_tx_err(vif);
 		return -EINVAL;
 	}
=20
@@ -1238,9 +1251,25 @@ static unsigned xen_netbk_tx_build_gops(struct xen_n=
etbk *netbk)
=20
 		/* Get a netif from the list with work to do. */
 		vif =3D poll_net_schedule_list(netbk);
+		/* This can sometimes happen because the test of
+		 * list_empty(net_schedule_list) at the top of the
+		 * loop is unlocked.  Just go back and have another
+		 * look.
+		 */
 		if (!vif)
 			continue;
=20
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
@@ -1268,17 +1297,14 @@ static unsigned xen_netbk_tx_build_gops(struct xen_=
netbk *netbk)
 			work_to_do =3D xen_netbk_get_extras(vif, extras,
 							  work_to_do);
 			idx =3D vif->tx.req_cons;
-			if (unlikely(work_to_do < 0)) {
-				netbk_tx_err(vif, &txreq, idx);
+			if (unlikely(work_to_do < 0))
 				continue;
-			}
 		}
=20
 		ret =3D netbk_count_requests(vif, &txreq, txfrags, work_to_do);
-		if (unlikely(ret < 0)) {
-			netbk_tx_err(vif, &txreq, idx - ret);
+		if (unlikely(ret < 0))
 			continue;
-		}
+
 		idx +=3D ret;
=20
 		if (unlikely(txreq.size < ETH_HLEN)) {
@@ -1290,11 +1316,11 @@ static unsigned xen_netbk_tx_build_gops(struct xen_=
netbk *netbk)
=20
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
=20
@@ -1322,8 +1348,8 @@ static unsigned xen_netbk_tx_build_gops(struct xen_ne=
tbk *netbk)
 			gso =3D &extras[XEN_NETIF_EXTRA_TYPE_GSO - 1];
=20
 			if (netbk_set_skb_gso(vif, skb, gso)) {
+				/* Failure in netbk_set_skb_gso is fatal. */
 				kfree_skb(skb);
-				netbk_tx_err(vif, &txreq, idx);
 				continue;
 			}
 		}
@@ -1424,7 +1450,7 @@ static void xen_netbk_tx_submit(struct xen_netbk *net=
bk)
 			txp->size -=3D data_len;
 		} else {
 			/* Schedule a response immediately. */
-			xen_netbk_idx_release(netbk, pending_idx);
+			xen_netbk_idx_release(netbk, pending_idx, XEN_NETIF_RSP_OKAY);
 		}
=20
 		if (txp->flags & XEN_NETTXF_csum_blank)
@@ -1479,7 +1505,8 @@ static void xen_netbk_tx_action(struct xen_netbk *net=
bk)
=20
 }
=20
-static void xen_netbk_idx_release(struct xen_netbk *netbk, u16 pending_idx=
)
+static void xen_netbk_idx_release(struct xen_netbk *netbk, u16 pending_idx=
,
+				  u8 status)
 {
 	struct xenvif *vif;
 	struct pending_tx_info *pending_tx_info;
@@ -1493,7 +1520,7 @@ static void xen_netbk_idx_release(struct xen_netbk *n=
etbk, u16 pending_idx)
=20
 	vif =3D pending_tx_info->vif;
=20
-	make_tx_response(vif, &pending_tx_info->req, XEN_NETIF_RSP_OKAY);
+	make_tx_response(vif, &pending_tx_info->req, status);
=20
 	index =3D pending_index(netbk->pending_prod++);
 	netbk->pending_ring[index] =3D pending_idx;
diff --git a/drivers/rtc/rtc-isl1208.c b/drivers/rtc/rtc-isl1208.c
index da8beb8..627b66a 100644
--- a/drivers/rtc/rtc-isl1208.c
+++ b/drivers/rtc/rtc-isl1208.c
@@ -494,6 +494,7 @@ isl1208_rtc_interrupt(int irq, void *data)
 {
 	unsigned long timeout =3D jiffies + msecs_to_jiffies(1000);
 	struct i2c_client *client =3D data;
+	struct rtc_device *rtc =3D i2c_get_clientdata(client);
 	int handled =3D 0, sr, err;
=20
 	/*
@@ -516,6 +517,8 @@ isl1208_rtc_interrupt(int irq, void *data)
 	if (sr & ISL1208_REG_SR_ALM) {
 		dev_dbg(&client->dev, "alarm!\n");
=20
+		rtc_update_irq(rtc, 1, RTC_IRQF | RTC_AF);
+
 		/* Clear the alarm */
 		sr &=3D ~ISL1208_REG_SR_ALM;
 		sr =3D i2c_smbus_write_byte_data(client, ISL1208_REG_SR, sr);
diff --git a/drivers/rtc/rtc-pl031.c b/drivers/rtc/rtc-pl031.c
index 1e80a48..73816d8 100644
--- a/drivers/rtc/rtc-pl031.c
+++ b/drivers/rtc/rtc-pl031.c
@@ -44,6 +44,7 @@
 #define RTC_YMR		0x34	/* Year match register */
 #define RTC_YLR		0x38	/* Year data load register */
=20
+#define RTC_CR_EN	(1 << 0)	/* counter enable bit */
 #define RTC_CR_CWEN	(1 << 26)	/* Clockwatch enable bit */
=20
 #define RTC_TCR_EN	(1 << 1) /* Periodic timer enable bit */
@@ -312,7 +313,7 @@ static int pl031_probe(struct amba_device *adev, const =
struct amba_id *id)
 	int ret;
 	struct pl031_local *ldata;
 	struct rtc_class_ops *ops =3D id->data;
-	unsigned long time;
+	unsigned long time, data;
=20
 	ret =3D amba_request_regions(adev, NULL);
 	if (ret)
@@ -339,10 +340,11 @@ static int pl031_probe(struct amba_device *adev, cons=
t struct amba_id *id)
 	dev_dbg(&adev->dev, "designer ID =3D 0x%02x\n", ldata->hw_designer);
 	dev_dbg(&adev->dev, "revision =3D 0x%01x\n", ldata->hw_revision);
=20
+	data =3D readl(ldata->base + RTC_CR);
 	/* Enable the clockwatch on ST Variants */
 	if (ldata->hw_designer =3D=3D AMBA_VENDOR_ST)
-		writel(readl(ldata->base + RTC_CR) | RTC_CR_CWEN,
-		       ldata->base + RTC_CR);
+		data |=3D RTC_CR_CWEN;
+	writel(data | RTC_CR_EN, ldata->base + RTC_CR);
=20
 	/*
 	 * On ST PL031 variants, the RTC reset value does not provide correct
diff --git a/drivers/usb/host/ehci-sched.c b/drivers/usb/host/ehci-sched.c
index 34655d0..08e470f 100644
--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -236,7 +236,7 @@ static inline unsigned char tt_start_uframe(struct ehci=
_hcd *ehci, __hc32 mask)
 }
=20
 static const unsigned char
-max_tt_usecs[] =3D { 125, 125, 125, 125, 125, 125, 30, 0 };
+max_tt_usecs[] =3D { 125, 125, 125, 125, 125, 125, 125, 25 };
=20
 /* carryover low/fullspeed bandwidth that crosses uframe boundries */
 static inline void carryover_tt_bandwidth(unsigned short tt_usecs[8])
diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index 5cc401b..c7cfbce 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -780,6 +780,7 @@ void usb_enable_xhci_ports(struct pci_dev *xhci_pdev)
 				"defaulting to EHCI.\n");
 		dev_warn(&xhci_pdev->dev,
 				"USB 3.0 devices will work at USB 2.0 speeds.\n");
+		usb_disable_xhci_ports(xhci_pdev);
 		return;
 	}
=20
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 2ed591d..5c1f9e7 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2504,6 +2504,8 @@ cleanup:
 				(trb_comp_code !=3D COMP_STALL &&
 					trb_comp_code !=3D COMP_BABBLE))
 				xhci_urb_free_priv(xhci, urb_priv);
+			else
+				kfree(urb_priv);
=20
 			usb_hcd_unlink_urb_from_ep(bus_to_hcd(urb->dev->bus), urb);
 			if ((urb->actual_length !=3D urb->transfer_buffer_length &&
@@ -3032,7 +3034,7 @@ static u32 xhci_v1_0_td_remainder(int running_total, =
int trb_buff_len,
 	 * running_total.
 	 */
 	packets_transferred =3D (running_total + trb_buff_len) /
-		usb_endpoint_maxp(&urb->ep->desc);
+		GET_MAX_PACKET(usb_endpoint_maxp(&urb->ep->desc));
=20
 	if ((total_packet_count - packets_transferred) > 31)
 		return 31 << 17;
@@ -3594,7 +3596,8 @@ static int xhci_queue_isoc_tx(struct xhci_hcd *xhci, =
gfp_t mem_flags,
 		td_len =3D urb->iso_frame_desc[i].length;
 		td_remain_len =3D td_len;
 		total_packet_count =3D DIV_ROUND_UP(td_len,
-				usb_endpoint_maxp(&urb->ep->desc));
+				GET_MAX_PACKET(
+					usb_endpoint_maxp(&urb->ep->desc)));
 		/* A zero-length transfer still involves at least one packet. */
 		if (total_packet_count =3D=3D 0)
 			total_packet_count++;
@@ -3617,9 +3620,11 @@ static int xhci_queue_isoc_tx(struct xhci_hcd *xhci,=
 gfp_t mem_flags,
 		td =3D urb_priv->td[i];
 		for (j =3D 0; j < trbs_per_td; j++) {
 			u32 remainder =3D 0;
-			field =3D TRB_TBC(burst_count) | TRB_TLBPC(residue);
+			field =3D 0;
=20
 			if (first_trb) {
+				field =3D TRB_TBC(burst_count) |
+					TRB_TLBPC(residue);
 				/* Queue the isoc TRB */
 				field |=3D TRB_TYPE(TRB_ISOC);
 				/* Assume URB_ISO_ASAP is set */
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 2cc7c18..d644a66 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -590,6 +590,7 @@ static struct usb_device_id id_table_combined [] =3D {
 	/*
 	 * ELV devices:
 	 */
+	{ USB_DEVICE(FTDI_ELV_VID, FTDI_ELV_WS300_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ELV_USR_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ELV_MSM1_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ELV_KL100_PID) },
@@ -676,6 +677,7 @@ static struct usb_device_id id_table_combined [] =3D {
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_5_PID) },
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_6_PID) },
 	{ USB_DEVICE(FTDI_VID, XSENS_CONVERTER_7_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_OMNI1509) },
 	{ USB_DEVICE(MOBILITY_VID, MOBILITY_USB_SERIAL_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ACTIVE_ROBOTS_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_MHAM_KW_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_si=
o_ids.h
index dd6edf8..97e0a6b 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -147,6 +147,11 @@
 #define XSENS_CONVERTER_6_PID	0xD38E
 #define XSENS_CONVERTER_7_PID	0xD38F
=20
+/**
+ * Zolix (www.zolix.com.cb) product ids
+ */
+#define FTDI_OMNI1509			0xD491	/* Omni1509 embedded USB-serial */
+
 /*
  * NDI (www.ndigital.com) product ids
  */
@@ -204,7 +209,7 @@
=20
 /*
  * ELV USB devices submitted by Christian Abt of ELV (www.elv.de).
- * All of these devices use FTDI's vendor ID (0x0403).
+ * Almost all of these devices use FTDI's vendor ID (0x0403).
  * Further IDs taken from ELV Windows .inf file.
  *
  * The previously included PID for the UO 100 module was incorrect.
@@ -212,6 +217,8 @@
  *
  * Armin Laeuger originally sent the PID for the UM 100 module.
  */
+#define FTDI_ELV_VID	0x1B1F	/* ELV AG */
+#define FTDI_ELV_WS300_PID	0xC006	/* eQ3 WS 300 PC II */
 #define FTDI_ELV_USR_PID	0xE000	/* ELV Universal-Sound-Recorder */
 #define FTDI_ELV_MSM1_PID	0xE001	/* ELV Mini-Sound-Modul */
 #define FTDI_ELV_KL100_PID	0xE002	/* ELV Kfz-Leistungsmesser KL 100 */
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 9db3e23..52cd814 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -242,6 +242,7 @@ static void option_instat_callback(struct urb *urb);
 #define TELIT_PRODUCT_CC864_DUAL		0x1005
 #define TELIT_PRODUCT_CC864_SINGLE		0x1006
 #define TELIT_PRODUCT_DE910_DUAL		0x1010
+#define TELIT_PRODUCT_LE920			0x1200
=20
 /* ZTE PRODUCTS */
 #define ZTE_VENDOR_ID				0x19d2
@@ -453,6 +454,10 @@ static void option_instat_callback(struct urb *urb);
 #define TPLINK_VENDOR_ID			0x2357
 #define TPLINK_PRODUCT_MA180			0x0201
=20
+/* Changhong products */
+#define CHANGHONG_VENDOR_ID			0x2077
+#define CHANGHONG_PRODUCT_CH690			0x7001
+
 /* some devices interfaces need special handling due to a number of reason=
s */
 enum option_blacklist_reason {
 		OPTION_BLACKLIST_NONE =3D 0,
@@ -534,6 +539,11 @@ static const struct option_blacklist_info zte_1255_bla=
cklist =3D {
 	.reserved =3D BIT(3) | BIT(4),
 };
=20
+static const struct option_blacklist_info telit_le920_blacklist =3D {
+	.sendsetup =3D BIT(0),
+	.reserved =3D BIT(1) | BIT(5),
+};
+
 static const struct usb_device_id option_ids[] =3D {
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
 	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_RICOLA) },
@@ -784,6 +794,8 @@ static const struct usb_device_id option_ids[] =3D {
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_CC864_DUAL) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_CC864_SINGLE) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_DE910_DUAL) },
+	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_LE920),
+		.driver_info =3D (kernel_ulong_t)&telit_le920_blacklist },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, ZTE_PRODUCT_MF622, 0xff, 0=
xff, 0xff) }, /* ZTE WCDMA products */
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0002, 0xff, 0xff, 0xff),
 		.driver_info =3D (kernel_ulong_t)&net_intf1_blacklist },
@@ -1318,6 +1330,7 @@ static const struct usb_device_id option_ids[] =3D {
 	{ USB_DEVICE(PETATEL_VENDOR_ID, PETATEL_PRODUCT_NP10T) },
 	{ USB_DEVICE(TPLINK_VENDOR_ID, TPLINK_PRODUCT_MA180),
 	  .driver_info =3D (kernel_ulong_t)&net_intf4_blacklist },
+	{ USB_DEVICE(CHANGHONG_VENDOR_ID, CHANGHONG_PRODUCT_CH690) },
 	{ } /* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, option_ids);
diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index 6634477..14c4a82 100644
--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -55,6 +55,7 @@ static const struct usb_device_id id_table[] =3D {
 	{DEVICE_G1K(0x05c6, 0x9221)},	/* Generic Gobi QDL device */
 	{DEVICE_G1K(0x05c6, 0x9231)},	/* Generic Gobi QDL device */
 	{DEVICE_G1K(0x1f45, 0x0001)},	/* Unknown Gobi QDL device */
+	{DEVICE_G1K(0x1bc7, 0x900e)},	/* Telit Gobi QDL device */
=20
 	/* Gobi 2000 devices */
 	{USB_DEVICE(0x1410, 0xa010)},	/* Novatel Gobi 2000 QDL device */
diff --git a/drivers/usb/storage/initializers.c b/drivers/usb/storage/initi=
alizers.c
index 105d900..16b0bf0 100644
--- a/drivers/usb/storage/initializers.c
+++ b/drivers/usb/storage/initializers.c
@@ -92,8 +92,8 @@ int usb_stor_ucr61s2b_init(struct us_data *us)
 	return 0;
 }
=20
-/* This places the HUAWEI E220 devices in multi-port mode */
-int usb_stor_huawei_e220_init(struct us_data *us)
+/* This places the HUAWEI usb dongles in multi-port mode */
+static int usb_stor_huawei_feature_init(struct us_data *us)
 {
 	int result;
=20
@@ -104,3 +104,75 @@ int usb_stor_huawei_e220_init(struct us_data *us)
 	US_DEBUGP("Huawei mode set result is %d\n", result);
 	return 0;
 }
+
+/*
+ * It will send a scsi switch command called rewind' to huawei dongle.
+ * When the dongle receives this command at the first time,
+ * it will reboot immediately. After rebooted, it will ignore this command=
.
+ * So it is  unnecessary to read its response.
+ */
+static int usb_stor_huawei_scsi_init(struct us_data *us)
+{
+	int result =3D 0;
+	int act_len =3D 0;
+	struct bulk_cb_wrap *bcbw =3D (struct bulk_cb_wrap *) us->iobuf;
+	char rewind_cmd[] =3D {0x11, 0x06, 0x20, 0x00, 0x00, 0x01, 0x01, 0x00,
+			0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
+
+	bcbw->Signature =3D cpu_to_le32(US_BULK_CB_SIGN);
+	bcbw->Tag =3D 0;
+	bcbw->DataTransferLength =3D 0;
+	bcbw->Flags =3D bcbw->Lun =3D 0;
+	bcbw->Length =3D sizeof(rewind_cmd);
+	memset(bcbw->CDB, 0, sizeof(bcbw->CDB));
+	memcpy(bcbw->CDB, rewind_cmd, sizeof(rewind_cmd));
+
+	result =3D usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe, bcbw,
+					US_BULK_CB_WRAP_LEN, &act_len);
+	US_DEBUGP("transfer actual length=3D%d, result=3D%d\n", act_len, result);
+	return result;
+}
+
+/*
+ * It tries to find the supported Huawei USB dongles.
+ * In Huawei, they assign the following product IDs
+ * for all of their mobile broadband dongles,
+ * including the new dongles in the future.
+ * So if the product ID is not included in this list,
+ * it means it is not Huawei's mobile broadband dongles.
+ */
+static int usb_stor_huawei_dongles_pid(struct us_data *us)
+{
+	struct usb_interface_descriptor *idesc;
+	int idProduct;
+
+	idesc =3D &us->pusb_intf->cur_altsetting->desc;
+	idProduct =3D us->pusb_dev->descriptor.idProduct;
+	/* The first port is CDROM,
+	 * means the dongle in the single port mode,
+	 * and a switch command is required to be sent. */
+	if (idesc && idesc->bInterfaceNumber =3D=3D 0) {
+		if ((idProduct =3D=3D 0x1001)
+			|| (idProduct =3D=3D 0x1003)
+			|| (idProduct =3D=3D 0x1004)
+			|| (idProduct >=3D 0x1401 && idProduct <=3D 0x1500)
+			|| (idProduct >=3D 0x1505 && idProduct <=3D 0x1600)
+			|| (idProduct >=3D 0x1c02 && idProduct <=3D 0x2202)) {
+			return 1;
+		}
+	}
+	return 0;
+}
+
+int usb_stor_huawei_init(struct us_data *us)
+{
+	int result =3D 0;
+
+	if (usb_stor_huawei_dongles_pid(us)) {
+		if (us->pusb_dev->descriptor.idProduct >=3D 0x1446)
+			result =3D usb_stor_huawei_scsi_init(us);
+		else
+			result =3D usb_stor_huawei_feature_init(us);
+	}
+	return result;
+}
diff --git a/drivers/usb/storage/initializers.h b/drivers/usb/storage/initi=
alizers.h
index 529327f..5376d4f 100644
--- a/drivers/usb/storage/initializers.h
+++ b/drivers/usb/storage/initializers.h
@@ -46,5 +46,5 @@ int usb_stor_euscsi_init(struct us_data *us);
  * flash reader */
 int usb_stor_ucr61s2b_init(struct us_data *us);
=20
-/* This places the HUAWEI E220 devices in multi-port mode */
-int usb_stor_huawei_e220_init(struct us_data *us);
+/* This places the HUAWEI usb dongles in multi-port mode */
+int usb_stor_huawei_init(struct us_data *us);
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusu=
al_devs.h
index fa8a1b2..12640ef 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1515,335 +1515,10 @@ UNUSUAL_DEV(  0x1210, 0x0003, 0x0100, 0x0100,
 /* Reported by fangxiaozhi <huananhu@huawei.com>
  * This brings the HUAWEI data card devices into multi-port mode
  */
-UNUSUAL_DEV(  0x12d1, 0x1001, 0x0000, 0x0000,
+UNUSUAL_VENDOR_INTF(0x12d1, 0x08, 0x06, 0x50,
 		"HUAWEI MOBILE",
 		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1003, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1004, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1401, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1402, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1403, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1404, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1405, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1406, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1407, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1408, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1409, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x140A, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x140B, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x140C, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x140D, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x140E, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x140F, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1410, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1411, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1412, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1413, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1414, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1415, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1416, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1417, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1418, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1419, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x141A, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x141B, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x141C, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x141D, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x141E, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x141F, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1420, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1421, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1422, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1423, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1424, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1425, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1426, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1427, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1428, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1429, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x142A, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x142B, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x142C, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x142D, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x142E, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x142F, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1430, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1431, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1432, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1433, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1434, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1435, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1436, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1437, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1438, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1439, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x143A, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x143B, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x143C, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x143D, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x143E, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x143F, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_init,
 		0),
=20
 /* Reported by Vilius Bilinkevicius <vilisas AT xxx DOT lt) */
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index db51ba1..d582af4 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -120,6 +120,17 @@ MODULE_PARM_DESC(quirks, "supplemental list of device =
IDs and their quirks");
 	.useTransport =3D use_transport,	\
 }
=20
+#define UNUSUAL_VENDOR_INTF(idVendor, cl, sc, pr, \
+		vendor_name, product_name, use_protocol, use_transport, \
+		init_function, Flags) \
+{ \
+	.vendorName =3D vendor_name,	\
+	.productName =3D product_name,	\
+	.useProtocol =3D use_protocol,	\
+	.useTransport =3D use_transport,	\
+	.initFunction =3D init_function,	\
+}
+
 static struct us_unusual_dev us_unusual_dev_list[] =3D {
 #	include "unusual_devs.h"=20
 	{ }		/* Terminating entry */
@@ -128,6 +139,7 @@ static struct us_unusual_dev us_unusual_dev_list[] =3D =
{
 #undef UNUSUAL_DEV
 #undef COMPLIANT_DEV
 #undef USUAL_DEV
+#undef UNUSUAL_VENDOR_INTF
=20

 #ifdef CONFIG_PM	/* Minimal support for suspend and resume */
diff --git a/drivers/usb/storage/usual-tables.c b/drivers/usb/storage/usual=
-tables.c
index b969279..a9b5f2e 100644
--- a/drivers/usb/storage/usual-tables.c
+++ b/drivers/usb/storage/usual-tables.c
@@ -46,6 +46,20 @@
 { USB_INTERFACE_INFO(USB_CLASS_MASS_STORAGE, useProto, useTrans), \
   .driver_info =3D ((useType)<<24) }
=20
+/* Define the device is matched with Vendor ID and interface descriptors *=
/
+#define UNUSUAL_VENDOR_INTF(id_vendor, cl, sc, pr, \
+			vendorName, productName, useProtocol, useTransport, \
+			initFunction, flags) \
+{ \
+	.match_flags =3D USB_DEVICE_ID_MATCH_INT_INFO \
+				| USB_DEVICE_ID_MATCH_VENDOR, \
+	.idVendor    =3D (id_vendor), \
+	.bInterfaceClass =3D (cl), \
+	.bInterfaceSubClass =3D (sc), \
+	.bInterfaceProtocol =3D (pr), \
+	.driver_info =3D (flags) \
+}
+
 struct usb_device_id usb_storage_usb_ids[] =3D {
 #	include "unusual_devs.h"
 	{ }		/* Terminating entry */
@@ -57,6 +71,7 @@ MODULE_DEVICE_TABLE(usb, usb_storage_usb_ids);
 #undef UNUSUAL_DEV
 #undef COMPLIANT_DEV
 #undef USUAL_DEV
+#undef UNUSUAL_VENDOR_INTF
=20

 /*
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index c598cfb..2b5e695 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -664,8 +664,11 @@ static int nilfs_ioctl_clean_segments(struct inode *in=
ode, struct file *filp,
 	if (ret < 0)
 		printk(KERN_ERR "NILFS: GC failed during preparation: "
 			"cannot read source blocks: err=3D%d\n", ret);
-	else
+	else {
+		if (nilfs_sb_need_update(nilfs))
+			set_nilfs_discontinued(nilfs);
 		ret =3D nilfs_clean_segments(inode->i_sb, argv, kbufs);
+	}
=20
 	nilfs_remove_all_gcinodes(nilfs);
 	clear_nilfs_gc_running(nilfs);
diff --git a/fs/splice.c b/fs/splice.c
index 014fcb4..58ab918 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -697,8 +697,10 @@ static int pipe_to_sendpage(struct pipe_inode_info *pi=
pe,
 		return -EINVAL;
=20
 	more =3D (sd->flags & SPLICE_F_MORE) ? MSG_MORE : 0;
-	if (sd->len < sd->total_len)
+
+	if (sd->len < sd->total_len && pipe->nrbufs > 1)
 		more |=3D MSG_SENDPAGE_NOTLAST;
+
 	return file->f_op->sendpage(file, buf->page, buf->offset,
 				    sd->len, &pos, more);
 }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 1e86bb4..8204898 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2597,7 +2597,16 @@ static inline void thread_group_cputime_init(struct =
signal_struct *sig)
 extern void recalc_sigpending_and_wake(struct task_struct *t);
 extern void recalc_sigpending(void);
=20
-extern void signal_wake_up(struct task_struct *t, int resume_stopped);
+extern void signal_wake_up_state(struct task_struct *t, unsigned int state=
);
+
+static inline void signal_wake_up(struct task_struct *t, bool resume)
+{
+	signal_wake_up_state(t, resume ? TASK_WAKEKILL : 0);
+}
+static inline void ptrace_signal_wake_up(struct task_struct *t, bool resum=
e)
+{
+	signal_wake_up_state(t, resume ? __TASK_TRACED : 0);
+}
=20
 /*
  * Wrappers for p->thread_info->cpu access. No-op on UP.
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 78ab24a..67fedad 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -117,11 +117,45 @@ void __ptrace_unlink(struct task_struct *child)
 	 * TASK_KILLABLE sleeps.
 	 */
 	if (child->jobctl & JOBCTL_STOP_PENDING || task_is_traced(child))
-		signal_wake_up(child, task_is_traced(child));
+		ptrace_signal_wake_up(child, true);
=20
 	spin_unlock(&child->sighand->siglock);
 }
=20
+/* Ensure that nothing can wake it up, even SIGKILL */
+static bool ptrace_freeze_traced(struct task_struct *task)
+{
+	bool ret =3D false;
+
+	/* Lockless, nobody but us can set this flag */
+	if (task->jobctl & JOBCTL_LISTENING)
+		return ret;
+
+	spin_lock_irq(&task->sighand->siglock);
+	if (task_is_traced(task) && !__fatal_signal_pending(task)) {
+		task->state =3D __TASK_TRACED;
+		ret =3D true;
+	}
+	spin_unlock_irq(&task->sighand->siglock);
+
+	return ret;
+}
+
+static void ptrace_unfreeze_traced(struct task_struct *task)
+{
+	if (task->state !=3D __TASK_TRACED)
+		return;
+
+	WARN_ON(!task->ptrace || task->parent !=3D current);
+
+	spin_lock_irq(&task->sighand->siglock);
+	if (__fatal_signal_pending(task))
+		wake_up_state(task, __TASK_TRACED);
+	else
+		task->state =3D TASK_TRACED;
+	spin_unlock_irq(&task->sighand->siglock);
+}
+
 /**
  * ptrace_check_attach - check whether ptracee is ready for ptrace operati=
on
  * @child: ptracee to check for
@@ -151,24 +185,29 @@ int ptrace_check_attach(struct task_struct *child, bo=
ol ignore_state)
 	 * be changed by us so it's not changing right after this.
 	 */
 	read_lock(&tasklist_lock);
-	if ((child->ptrace & PT_PTRACED) && child->parent =3D=3D current) {
+	if (child->ptrace && child->parent =3D=3D current) {
+		WARN_ON(child->state =3D=3D __TASK_TRACED);
 		/*
 		 * child->sighand can't be NULL, release_task()
 		 * does ptrace_unlink() before __exit_signal().
 		 */
-		spin_lock_irq(&child->sighand->siglock);
-		WARN_ON_ONCE(task_is_stopped(child));
-		if (ignore_state || (task_is_traced(child) &&
-				     !(child->jobctl & JOBCTL_LISTENING)))
+		if (ignore_state || ptrace_freeze_traced(child))
 			ret =3D 0;
-		spin_unlock_irq(&child->sighand->siglock);
 	}
 	read_unlock(&tasklist_lock);
=20
-	if (!ret && !ignore_state)
-		ret =3D wait_task_inactive(child, TASK_TRACED) ? 0 : -ESRCH;
+	if (!ret && !ignore_state) {
+		if (!wait_task_inactive(child, __TASK_TRACED)) {
+			/*
+			 * This can only happen if may_ptrace_stop() fails and
+			 * ptrace_stop() changes ->state back to TASK_RUNNING,
+			 * so we should not worry about leaking __TASK_TRACED.
+			 */
+			WARN_ON(child->state =3D=3D __TASK_TRACED);
+			ret =3D -ESRCH;
+		}
+	}
=20
-	/* All systems go.. */
 	return ret;
 }
=20
@@ -307,7 +346,7 @@ static int ptrace_attach(struct task_struct *task, long=
 request,
 	 */
 	if (task_is_stopped(task) &&
 	    task_set_jobctl_pending(task, JOBCTL_TRAP_STOP | JOBCTL_TRAPPING))
-		signal_wake_up(task, 1);
+		signal_wake_up_state(task, __TASK_STOPPED);
=20
 	spin_unlock(&task->sighand->siglock);
=20
@@ -736,7 +775,7 @@ int ptrace_request(struct task_struct *child, long requ=
est,
 		 * tracee into STOP.
 		 */
 		if (likely(task_set_jobctl_pending(child, JOBCTL_TRAP_STOP)))
-			signal_wake_up(child, child->jobctl & JOBCTL_LISTENING);
+			ptrace_signal_wake_up(child, child->jobctl & JOBCTL_LISTENING);
=20
 		unlock_task_sighand(child, &flags);
 		ret =3D 0;
@@ -762,7 +801,7 @@ int ptrace_request(struct task_struct *child, long requ=
est,
 			 * start of this trap and now.  Trigger re-trap.
 			 */
 			if (child->jobctl & JOBCTL_TRAP_NOTIFY)
-				signal_wake_up(child, true);
+				ptrace_signal_wake_up(child, true);
 			ret =3D 0;
 		}
 		unlock_task_sighand(child, &flags);
@@ -899,6 +938,8 @@ SYSCALL_DEFINE4(ptrace, long, request, long, pid, unsig=
ned long, addr,
 		goto out_put_task_struct;
=20
 	ret =3D arch_ptrace(child, request, addr, data);
+	if (ret || request !=3D PTRACE_DETACH)
+		ptrace_unfreeze_traced(child);
=20
  out_put_task_struct:
 	put_task_struct(child);
@@ -1038,8 +1079,11 @@ asmlinkage long compat_sys_ptrace(compat_long_t requ=
est, compat_long_t pid,
=20
 	ret =3D ptrace_check_attach(child, request =3D=3D PTRACE_KILL ||
 				  request =3D=3D PTRACE_INTERRUPT);
-	if (!ret)
+	if (!ret) {
 		ret =3D compat_arch_ptrace(child, request, addr, data);
+		if (ret || request !=3D PTRACE_DETACH)
+			ptrace_unfreeze_traced(child);
+	}
=20
  out_put_task_struct:
 	put_task_struct(child);
diff --git a/kernel/resource.c b/kernel/resource.c
index 7640b3a..08aa28e 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -757,6 +757,7 @@ static void __init __reserve_region_with_split(struct r=
esource *root,
 	struct resource *parent =3D root;
 	struct resource *conflict;
 	struct resource *res =3D kzalloc(sizeof(*res), GFP_ATOMIC);
+	struct resource *next_res =3D NULL;
=20
 	if (!res)
 		return;
@@ -766,21 +767,46 @@ static void __init __reserve_region_with_split(struct=
 resource *root,
 	res->end =3D end;
 	res->flags =3D IORESOURCE_BUSY;
=20
-	conflict =3D __request_resource(parent, res);
-	if (!conflict)
-		return;
+	while (1) {
=20
-	/* failed, split and try again */
-	kfree(res);
+		conflict =3D __request_resource(parent, res);
+		if (!conflict) {
+			if (!next_res)
+				break;
+			res =3D next_res;
+			next_res =3D NULL;
+			continue;
+		}
=20
-	/* conflict covered whole area */
-	if (conflict->start <=3D start && conflict->end >=3D end)
-		return;
+		/* conflict covered whole area */
+		if (conflict->start <=3D res->start &&
+				conflict->end >=3D res->end) {
+			kfree(res);
+			WARN_ON(next_res);
+			break;
+		}
+
+		/* failed, split and try again */
+		if (conflict->start > res->start) {
+			end =3D res->end;
+			res->end =3D conflict->start - 1;
+			if (conflict->end < end) {
+				next_res =3D kzalloc(sizeof(*next_res),
+						GFP_ATOMIC);
+				if (!next_res) {
+					kfree(res);
+					break;
+				}
+				next_res->name =3D name;
+				next_res->start =3D conflict->end + 1;
+				next_res->end =3D end;
+				next_res->flags =3D IORESOURCE_BUSY;
+			}
+		} else {
+			res->start =3D conflict->end + 1;
+		}
+	}
=20
-	if (conflict->start > start)
-		__reserve_region_with_split(root, start, conflict->start-1, name);
-	if (conflict->end < end)
-		__reserve_region_with_split(root, conflict->end+1, end, name);
 }
=20
 void __init reserve_region_with_split(struct resource *root,
diff --git a/kernel/sched.c b/kernel/sched.c
index fcc893f..eeeec4e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2924,7 +2924,8 @@ out:
  */
 int wake_up_process(struct task_struct *p)
 {
-	return try_to_wake_up(p, TASK_ALL, 0);
+	WARN_ON(task_is_stopped_or_traced(p));
+	return try_to_wake_up(p, TASK_NORMAL, 0);
 }
 EXPORT_SYMBOL(wake_up_process);
=20
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 78fcacf..6ad4fb3 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -384,7 +384,7 @@ static inline struct rt_bandwidth *sched_rt_bandwidth(s=
truct rt_rq *rt_rq)
 static int do_balance_runtime(struct rt_rq *rt_rq)
 {
 	struct rt_bandwidth *rt_b =3D sched_rt_bandwidth(rt_rq);
-	struct root_domain *rd =3D cpu_rq(smp_processor_id())->rd;
+	struct root_domain *rd =3D rq_of_rt_rq(rt_rq)->rd;
 	int i, weight, more =3D 0;
 	u64 rt_period;
=20
diff --git a/kernel/signal.c b/kernel/signal.c
index 08e0b97..d2f55ea 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -676,23 +676,17 @@ int dequeue_signal(struct task_struct *tsk, sigset_t =
*mask, siginfo_t *info)
  * No need to set need_resched since signal event passing
  * goes through ->blocked
  */
-void signal_wake_up(struct task_struct *t, int resume)
+void signal_wake_up_state(struct task_struct *t, unsigned int state)
 {
-	unsigned int mask;
-
 	set_tsk_thread_flag(t, TIF_SIGPENDING);
-
 	/*
-	 * For SIGKILL, we want to wake it up in the stopped/traced/killable
+	 * TASK_WAKEKILL also means wake it up in the stopped/traced/killable
 	 * case. We don't check t->state here because there is a race with it
 	 * executing another processor and just now entering stopped state.
 	 * By using wake_up_state, we ensure the process will wake up and
 	 * handle its death signal.
 	 */
-	mask =3D TASK_INTERRUPTIBLE;
-	if (resume)
-		mask |=3D TASK_WAKEKILL;
-	if (!wake_up_state(t, mask))
+	if (!wake_up_state(t, state | TASK_INTERRUPTIBLE))
 		kick_process(t);
 }
=20
@@ -841,7 +835,7 @@ static void ptrace_trap_notify(struct task_struct *t)
 	assert_spin_locked(&t->sighand->siglock);
=20
 	task_set_jobctl_pending(t, JOBCTL_TRAP_NOTIFY);
-	signal_wake_up(t, t->jobctl & JOBCTL_LISTENING);
+	ptrace_signal_wake_up(t, t->jobctl & JOBCTL_LISTENING);
 }
=20
 /*
@@ -1765,6 +1759,10 @@ static inline int may_ptrace_stop(void)
 	 * If SIGKILL was already sent before the caller unlocked
 	 * ->siglock we must see ->core_state !=3D NULL. Otherwise it
 	 * is safe to enter schedule().
+	 *
+	 * This is almost outdated, a task with the pending SIGKILL can't
+	 * block in TASK_TRACED. But PTRACE_EVENT_EXIT can be reported
+	 * after SIGKILL was already dequeued.
 	 */
 	if (unlikely(current->mm->core_state) &&
 	    unlikely(current->mm =3D=3D current->parent->mm))
@@ -1890,6 +1888,7 @@ static void ptrace_stop(int exit_code, int why, int c=
lear_code, siginfo_t *info)
 		if (gstop_done)
 			do_notify_parent_cldstop(current, false, why);
=20
+		/* tasklist protects us from ptrace_freeze_traced() */
 		__set_current_state(TASK_RUNNING);
 		if (clear_code)
 			current->exit_code =3D 0;
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 6033f02..7a157b3 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1972,7 +1972,7 @@ static inline void hci_cmd_complete_evt(struct hci_de=
v *hdev, struct sk_buff *sk
 	if (ev->opcode !=3D HCI_OP_NOP)
 		del_timer(&hdev->cmd_timer);
=20
-	if (ev->ncmd) {
+	if (ev->ncmd && !test_bit(HCI_RESET, &hdev->flags)) {
 		atomic_set(&hdev->cmd_cnt, 1);
 		if (!skb_queue_empty(&hdev->cmd_q))
 			tasklet_schedule(&hdev->cmd_task);
diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 1849ee0..9ab60e6 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -642,6 +642,19 @@ int smp_sig_channel(struct l2cap_conn *conn, struct sk=
_buff *skb)
=20
 	skb_pull(skb, sizeof(code));
=20
+	/*
+	 * The SMP context must be initialized for all other PDUs except
+	 * pairing and security requests. If we get any other PDU when
+	 * not initialized simply disconnect (done if this function
+	 * returns an error).
+	 */
+	if (code !=3D SMP_CMD_PAIRING_REQ && code !=3D SMP_CMD_SECURITY_REQ &&
+	    !conn->smp_chan) {
+		BT_ERR("Unexpected SMP command 0x%02x. Disconnecting.", code);
+		kfree_skb(skb);
+		return -ENOTSUPP;
+	}
+
 	switch (code) {
 	case SMP_CMD_PAIRING_REQ:
 		reason =3D smp_cmd_pairing_req(conn, skb);
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 577ea5d..7c1745d 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -245,6 +245,9 @@ static int br_parse_ip_options(struct sk_buff *skb)
 	struct net_device *dev =3D skb->dev;
 	u32 len;
=20
+	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
+		goto inhdr_error;
+
 	iph =3D ip_hdr(skb);
 	opt =3D &(IPCB(skb)->opt);
=20
diff --git a/net/core/pktgen.c b/net/core/pktgen.c
index 7bc9991..2ef7da0 100644
--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -1803,10 +1803,13 @@ static ssize_t pktgen_thread_write(struct file *fil=
e,
 			return -EFAULT;
 		i +=3D len;
 		mutex_lock(&pktgen_thread_lock);
-		pktgen_add_device(t, f);
+		ret =3D pktgen_add_device(t, f);
 		mutex_unlock(&pktgen_thread_lock);
-		ret =3D count;
-		sprintf(pg_result, "OK: add_device=3D%s", f);
+		if (!ret) {
+			ret =3D count;
+			sprintf(pg_result, "OK: add_device=3D%s", f);
+		} else
+			sprintf(pg_result, "ERROR: can not add device %s", f);
 		goto out;
 	}
=20
diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index 0106d25..3b36002 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -600,7 +600,7 @@ static int do_ip_setsockopt(struct sock *sk, int level,
 	case IP_TTL:
 		if (optlen < 1)
 			goto e_inval;
-		if (val !=3D -1 && (val < 0 || val > 255))
+		if (val !=3D -1 && (val < 1 || val > 255))
 			goto e_inval;
 		inet->uc_ttl =3D val;
 		break;
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index aab8f08..e865ed1 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3655,6 +3655,11 @@ static int tcp_process_frto(struct sock *sk, int fla=
g)
 		}
 	} else {
 		if (!(flag & FLAG_DATA_ACKED) && (tp->frto_counter =3D=3D 1)) {
+			if (!tcp_packets_in_flight(tp)) {
+				tcp_enter_frto_loss(sk, 2, flag);
+				return true;
+			}
+
 			/* Prevent sending of new data. */
 			tp->snd_cwnd =3D min(tp->snd_cwnd,
 					   tcp_packets_in_flight(tp));
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index aef80d7..b27baed 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -1739,7 +1739,7 @@ static struct rt6_info *addrconf_get_prefix_route(con=
st struct in6_addr *pfx,
 			continue;
 		if ((rt->rt6i_flags & flags) !=3D flags)
 			continue;
-		if ((noflags !=3D 0) && ((rt->rt6i_flags & flags) !=3D 0))
+		if ((rt->rt6i_flags & noflags) !=3D 0)
 			continue;
 		dst_hold(&rt->dst);
 		break;
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index ae98e09..3ccd9b2 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1284,10 +1284,10 @@ int ip6_append_data(struct sock *sk, int getfrag(vo=
id *from, char *to,
 		cork->length =3D 0;
 		sk->sk_sndmsg_page =3D NULL;
 		sk->sk_sndmsg_off =3D 0;
-		exthdrlen =3D (opt ? opt->opt_flen : 0) - rt->rt6i_nfheader_len;
+		exthdrlen =3D (opt ? opt->opt_flen : 0);
 		length +=3D exthdrlen;
 		transhdrlen +=3D exthdrlen;
-		dst_exthdrlen =3D rt->dst.header_len;
+		dst_exthdrlen =3D rt->dst.header_len - rt->rt6i_nfheader_len;
 	} else {
 		rt =3D (struct rt6_info *)cork->dst;
 		fl6 =3D &inet->cork.fl.u.ip6;
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 19724bd..791c1fa 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -819,7 +819,8 @@ restart:
 	dst_hold(&rt->dst);
 	read_unlock_bh(&table->tb6_lock);
=20
-	if (!dst_get_neighbour_raw(&rt->dst) && !(rt->rt6i_flags & RTF_NONEXTHOP)=
)
+	if (!dst_get_neighbour_raw(&rt->dst)
+	    && !(rt->rt6i_flags & (RTF_NONEXTHOP | RTF_LOCAL)))
 		nrt =3D rt6_alloc_cow(rt, &fl6->daddr, &fl6->saddr);
 	else if (!(rt->dst.flags & DST_HOST))
 		nrt =3D rt6_alloc_clone(rt, &fl6->daddr);
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 85afc13..835fcea 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2422,13 +2422,15 @@ static int packet_release(struct socket *sock)
=20
 	packet_flush_mclist(sk);
=20
-	memset(&req_u, 0, sizeof(req_u));
-
-	if (po->rx_ring.pg_vec)
+	if (po->rx_ring.pg_vec) {
+		memset(&req_u, 0, sizeof(req_u));
 		packet_set_ring(sk, &req_u, 1, 0);
+	}
=20
-	if (po->tx_ring.pg_vec)
+	if (po->tx_ring.pg_vec) {
+		memset(&req_u, 0, sizeof(req_u));
 		packet_set_ring(sk, &req_u, 1, 1);
+	}
=20
 	fanout_release(sk);
=20
diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
index c8cc24e..dbe5870a 100644
--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -248,6 +248,8 @@ void sctp_endpoint_free(struct sctp_endpoint *ep)
 /* Final destructor for endpoint.  */
 static void sctp_endpoint_destroy(struct sctp_endpoint *ep)
 {
+	int i;
+
 	SCTP_ASSERT(ep->base.dead, "Endpoint is not dead", return);
=20
 	/* Free up the HMAC transform. */
@@ -270,6 +272,9 @@ static void sctp_endpoint_destroy(struct sctp_endpoint =
*ep)
 	sctp_inq_free(&ep->base.inqueue);
 	sctp_bind_addr_free(&ep->base.bind_addr);
=20
+	for (i =3D 0; i < SCTP_HOW_MANY_SECRETS; ++i)
+		memset(&ep->secret_key[i], 0, SCTP_SECRET_SIZE);
+
 	/* Remove and free the port */
 	if (sctp_sk(ep->base.sk)->bind_hash)
 		sctp_put_port(ep->base.sk);
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index cfeb1d4..96eb168 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -223,7 +223,7 @@ void sctp_outq_init(struct sctp_association *asoc, stru=
ct sctp_outq *q)
=20
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
=20
-	q->error =3D 0;
-
 	/* Throw away any leftover control chunks. */
 	list_for_each_entry_safe(chunk, tmp, &q->control_chunk_list, list) {
 		list_del_init(&chunk->list);
@@ -285,11 +283,17 @@ void sctp_outq_teardown(struct sctp_outq *q)
 	}
 }
=20
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
=20
 	/* If we were kmalloc()'d, free the memory.  */
 	if (q->malloced)
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index fa8333b..5e0d86e 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -3375,7 +3375,7 @@ static int sctp_setsockopt_auth_key(struct sock *sk,
=20
 	ret =3D sctp_auth_set_key(sctp_sk(sk)->ep, asoc, authkey);
 out:
-	kfree(authkey);
+	kzfree(authkey);
 	return ret;
 }
=20



--=-A2jLOVnA1UlJRJ6C81oV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUSRPYue/yOyVhhEJAQoEKA//Uw6Fag+pm3C3A0oxy83Oakd246aC8YnF
Q+LKPP5yI6b0lff/6DZKYs3m1IlL/8BOu0F8CiSFGotxA2Id2RuSPTz3IqYxw9cj
MZBbSjAu5f1TZJOHT9EjU2H+seuaTzZm4EWKjGHNGddZf81mKZVmLBS0uBKjvqw5
m2OjkGn5P2FBQ2S9DtmpG/rLdViqf8eALlmzoij6d6aWHPLs1rvoU7WmGl7x8fsU
wkkN9z5ugfV8dhdJBQBkuoLvfq4znRRuZc5sV5fudDyaZpsiAlIIOdPGuQXZ3qWI
S6JTPQCyZE7LMRwVa5DNvxW4z7JZNa7l+0fKkld1hAlUnGaUbT8l7v/LWSNyQ7NY
/k3nu//TdcAQ/U7RIIBUfPNw1OERq41Ct49rK9GleIISQIUXiIEf7U0ZQZz4ebx8
i5dFlHiJyYEqMWNZA4E5fGpXmgRBxBIPODtnLsJIytBciM/vl+7vYJcQQ8PMoWQz
1CvshHC94LRJYz4e3Lr0TVWzTQQroMnSQeC1SU0Mk0n51eW+i8k/TREIiZwdgQkv
i5+XN5iC2iZKDH4cz7sMkwG0/zwq2eL8PRUo4uhNihMa0WY/92NoE9IdyDfgeTZ+
jacbnKeWSD4k7/JXlf6rLIIkCijDAGbCAqIuZgIWnlV72CEwqBug0JKK3YA4F5/C
N7aZEq9x1b4=
=dl36
-----END PGP SIGNATURE-----

--=-A2jLOVnA1UlJRJ6C81oV--
