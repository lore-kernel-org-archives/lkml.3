Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab3IMW16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 18:27:58 -0400
Received: from smtprelay0227.hostedemail.com ([216.40.44.227]:48698 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753932Ab3IMW1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 18:27:55 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:69:355:379:541:599:960:966:968:973:979:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1593:1594:1605:1730:1747:1777:1792:1801:2196:2198:2199:2200:2393:2559:2562:2691:2740:2828:2896:2897:2898:2899:2901:2910:2924:2926:3138:3139:3140:3141:3142:3308:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:4383:4385:4395:4605:5007:7652:7875:7903:7904:8603:8957:9010:9164:9592:10004:10241:10848:11026:
X-HE-Tag: help74_2739e96b22610
X-Filterd-Recvd-Size: 80587
Message-ID: <1379111268.2066.22.camel@joe-AO722>
Subject: Re: [PATCH] vsprintf: drop comment claiming %n is ignored
From: Joe Perches <joe@perches.com>
To: George Spelvin <linux@horizon.com>
Cc: keescook@chromium.org, akpm@linux-foundation.org, dan.carpenter@oracle.com,
        davem@davemloft.net, eldad@fogrefinery.com, jbeulich@suse.com,
        jkosina@suse.cz, linux-kernel@vger.kernel.org, rdunlap@infradead.org,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Fri, 13 Sep 2013 15:27:48 -0700
In-Reply-To: <20130913195335.18955.qmail@science.horizon.com>
References: <20130913195335.18955.qmail@science.horizon.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-09-13 at 15:53 -0400, George Spelvin wrote:
> > Maybe WARN_ONCE so it's easier to emit the format too.
> 
> Good idea.  And, if it's not too much trouble, a comment explaining
> why it's deliberately omitted so the issue doesn't arise again.

Before any of the %n uses could be removed, I believe seq_printf
could to be converted to return void and have a another mechanism
to determine if any error occurred and the length of the output of
seq_printf.

I've done a preliminary conversion of seq_printf and seq_vprintf
to return void and added last_ret and last_len to struct seq_file.

If that's applied, it's trivial to convert vsnprintf to skip %n.

Anyone have an opinion of a different conversion mechanism?

Converting all the uses was (mostly) done with coccinelle.

Only compiled x86-32, several files uncompiled.
Completely untested.

---

 arch/arm/plat-pxa/dma.c                            |  95 +++++++------
 arch/microblaze/kernel/cpu/mb.c                    | 145 ++++++++++----------
 arch/x86/kernel/cpu/mtrr/if.c                      |   9 +-
 drivers/base/power/wakeup.c                        |  14 +-
 drivers/mfd/ab8500-debugfs.c                       |  12 +-
 drivers/mtd/devices/docg3.c                        |  97 ++++++-------
 drivers/parisc/ccio-dma.c                          |  52 +++----
 drivers/parisc/sba_iommu.c                         |  74 +++++-----
 drivers/regulator/dbx500-prcmu.c                   |  34 ++---
 drivers/staging/lustre/lustre/fid/lproc_fid.c      |  16 ++-
 drivers/staging/lustre/lustre/llite/lproc_llite.c  |  32 +++--
 drivers/staging/lustre/lustre/mdc/lproc_mdc.c      |   3 +-
 .../lustre/lustre/obdclass/lprocfs_status.c        |  64 +++++----
 drivers/staging/lustre/lustre/osc/lproc_osc.c      |  28 ++--
 .../staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c    |   3 +-
 drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c    |  78 +++++------
 drivers/usb/gadget/pxa27x_udc.c                    | 108 +++++++--------
 fs/debugfs/file.c                                  |   6 +-
 fs/dlm/debug_fs.c                                  | 152 +++++++++++----------
 fs/eventfd.c                                       |   5 +-
 fs/eventpoll.c                                     |   7 +-
 fs/notify/fdinfo.c                                 |  34 ++---
 fs/seq_file.c                                      |  15 +-
 include/linux/seq_file.h                           |   6 +-
 ipc/util.c                                         |   6 +-
 net/batman-adv/gateway_client.c                    |  21 +--
 .../netfilter/nf_conntrack_l3proto_ipv4_compat.c   |  30 ++--
 net/netfilter/nf_conntrack_standalone.c            |  35 +++--
 net/netfilter/nf_log.c                             |  12 +-
 net/netfilter/xt_hashlimit.c                       |  34 ++---
 30 files changed, 649 insertions(+), 578 deletions(-)

diff --git a/arch/arm/plat-pxa/dma.c b/arch/arm/plat-pxa/dma.c
index 79ef102..f2c5e34 100644
--- a/arch/arm/plat-pxa/dma.c
+++ b/arch/arm/plat-pxa/dma.c
@@ -56,12 +56,12 @@ static int dbg_show_requester_chan(struct seq_file *s, void *p)
 	int i;
 	u32 drcmr;
 
-	pos += seq_printf(s, "DMA channel %d requesters list :\n", chan);
+	seq_printf(s, "DMA channel %d requesters list :\n", chan);
 	for (i = 0; i < DMA_MAX_REQUESTERS; i++) {
 		drcmr = DRCMR(i);
 		if ((drcmr & DRCMR_CHLNUM) == chan)
-			pos += seq_printf(s, "\tRequester %d (MAPVLD=%d)\n", i,
-					  !!(drcmr & DRCMR_MAPVLD));
+			seq_printf(s, "\tRequester %d (MAPVLD=%d)\n",
+				   i, !!(drcmr & DRCMR_MAPVLD));
 	}
 	return pos;
 }
@@ -94,36 +94,35 @@ static int dbg_show_descriptors(struct seq_file *s, void *p)
 	spin_lock_irqsave(&dma_channels[chan].lock, flags);
 	phys_desc = DDADR(chan);
 
-	pos += seq_printf(s, "DMA channel %d descriptors :\n", chan);
-	pos += seq_printf(s, "[%03d] First descriptor unknown\n", 0);
+	seq_printf(s, "DMA channel %d descriptors :\n", chan);
+	seq_printf(s, "[%03d] First descriptor unknown\n", 0);
 	for (i = 1; i < max_show && is_phys_valid(phys_desc); i++) {
 		desc = phys_to_virt(phys_desc);
 		dcmd = desc->dcmd;
 		burst = dbg_burst_from_dcmd(dcmd);
 		width = (1 << ((dcmd >> 14) & 0x3)) >> 1;
 
-		pos += seq_printf(s, "[%03d] Desc at %08lx(virt %p)\n",
-				  i, phys_desc, desc);
-		pos += seq_printf(s, "\tDDADR = %08x\n", desc->ddadr);
-		pos += seq_printf(s, "\tDSADR = %08x\n", desc->dsadr);
-		pos += seq_printf(s, "\tDTADR = %08x\n", desc->dtadr);
-		pos += seq_printf(s, "\tDCMD  = %08x (%s%s%s%s%s%s%sburst=%d"
-				  " width=%d len=%d)\n",
-				  dcmd,
-				  DCMD_STR(INCSRCADDR), DCMD_STR(INCTRGADDR),
-				  DCMD_STR(FLOWSRC), DCMD_STR(FLOWTRG),
-				  DCMD_STR(STARTIRQEN), DCMD_STR(ENDIRQEN),
-				  DCMD_STR(ENDIAN), burst, width,
-				  dcmd & DCMD_LENGTH);
+		seq_printf(s, "[%03d] Desc at %08lx(virt %p)\n",
+			   i, phys_desc, desc);
+		seq_printf(s, "\tDDADR = %08x\n", desc->ddadr);
+		seq_printf(s, "\tDSADR = %08x\n", desc->dsadr);
+		seq_printf(s, "\tDTADR = %08x\n", desc->dtadr);
+		seq_printf(s, "\tDCMD  = %08x (%s%s%s%s%s%s%sburst=%d width=%d len=%d)\n",
+			   dcmd,
+			   DCMD_STR(INCSRCADDR), DCMD_STR(INCTRGADDR),
+			   DCMD_STR(FLOWSRC), DCMD_STR(FLOWTRG),
+			   DCMD_STR(STARTIRQEN), DCMD_STR(ENDIRQEN),
+			   DCMD_STR(ENDIAN), burst, width,
+			   dcmd & DCMD_LENGTH);
 		phys_desc = desc->ddadr;
 	}
 	if (i == max_show)
-		pos += seq_printf(s, "[%03d] Desc at %08lx ... max display reached\n",
-				  i, phys_desc);
+		seq_printf(s, "[%03d] Desc at %08lx ... max display reached\n",
+			   i, phys_desc);
 	else
-		pos += seq_printf(s, "[%03d] Desc at %08lx is %s\n",
-				  i, phys_desc, phys_desc == DDADR_STOP ?
-				  "DDADR_STOP" : "invalid");
+		seq_printf(s, "[%03d] Desc at %08lx is %s\n",
+			   i, phys_desc, phys_desc == DDADR_STOP ?
+			   "DDADR_STOP" : "invalid");
 
 	spin_unlock_irqrestore(&dma_channels[chan].lock, flags);
 	return pos;
@@ -142,30 +141,28 @@ static int dbg_show_chan_state(struct seq_file *s, void *p)
 	burst = dbg_burst_from_dcmd(dcmd);
 	width = (1 << ((dcmd >> 14) & 0x3)) >> 1;
 
-	pos += seq_printf(s, "DMA channel %d\n", chan);
-	pos += seq_printf(s, "\tPriority : %s\n",
-			  str_prio[dma_channels[chan].prio]);
-	pos += seq_printf(s, "\tUnaligned transfer bit: %s\n",
-			  DALGN & (1 << chan) ? "yes" : "no");
-	pos += seq_printf(s, "\tDCSR  = %08x (%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s)\n",
-			  dcsr, DCSR_STR(RUN), DCSR_STR(NODESC),
-			  DCSR_STR(STOPIRQEN), DCSR_STR(EORIRQEN),
-			  DCSR_STR(EORJMPEN), DCSR_STR(EORSTOPEN),
-			  DCSR_STR(SETCMPST), DCSR_STR(CLRCMPST),
-			  DCSR_STR(CMPST), DCSR_STR(EORINTR), DCSR_STR(REQPEND),
-			  DCSR_STR(STOPSTATE), DCSR_STR(ENDINTR),
-			  DCSR_STR(STARTINTR), DCSR_STR(BUSERR));
-
-	pos += seq_printf(s, "\tDCMD  = %08x (%s%s%s%s%s%s%sburst=%d width=%d"
-			  " len=%d)\n",
-			  dcmd,
-			  DCMD_STR(INCSRCADDR), DCMD_STR(INCTRGADDR),
-			  DCMD_STR(FLOWSRC), DCMD_STR(FLOWTRG),
-			  DCMD_STR(STARTIRQEN), DCMD_STR(ENDIRQEN),
-			  DCMD_STR(ENDIAN), burst, width, dcmd & DCMD_LENGTH);
-	pos += seq_printf(s, "\tDSADR = %08x\n", DSADR(chan));
-	pos += seq_printf(s, "\tDTADR = %08x\n", DTADR(chan));
-	pos += seq_printf(s, "\tDDADR = %08x\n", DDADR(chan));
+	seq_printf(s, "DMA channel %d\n", chan);
+	seq_printf(s, "\tPriority : %s\n", str_prio[dma_channels[chan].prio]);
+	seq_printf(s, "\tUnaligned transfer bit: %s\n",
+		   DALGN & (1 << chan) ? "yes" : "no");
+	seq_printf(s, "\tDCSR  = %08x (%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s)\n",
+		   dcsr, DCSR_STR(RUN), DCSR_STR(NODESC),
+		   DCSR_STR(STOPIRQEN), DCSR_STR(EORIRQEN),
+		   DCSR_STR(EORJMPEN), DCSR_STR(EORSTOPEN),
+		   DCSR_STR(SETCMPST), DCSR_STR(CLRCMPST),
+		   DCSR_STR(CMPST), DCSR_STR(EORINTR), DCSR_STR(REQPEND),
+		   DCSR_STR(STOPSTATE), DCSR_STR(ENDINTR),
+		   DCSR_STR(STARTINTR), DCSR_STR(BUSERR));
+
+	seq_printf(s, "\tDCMD  = %08x (%s%s%s%s%s%s%sburst=%d width=%d len=%d)\n",
+		   dcmd,
+		   DCMD_STR(INCSRCADDR), DCMD_STR(INCTRGADDR),
+		   DCMD_STR(FLOWSRC), DCMD_STR(FLOWTRG),
+		   DCMD_STR(STARTIRQEN), DCMD_STR(ENDIRQEN),
+		   DCMD_STR(ENDIAN), burst, width, dcmd & DCMD_LENGTH);
+	seq_printf(s, "\tDSADR = %08x\n", DSADR(chan));
+	seq_printf(s, "\tDTADR = %08x\n", DTADR(chan));
+	seq_printf(s, "\tDDADR = %08x\n", DDADR(chan));
 	return pos;
 }
 
@@ -174,8 +171,8 @@ static int dbg_show_state(struct seq_file *s, void *p)
 	int pos = 0;
 
 	/* basic device status */
-	pos += seq_printf(s, "DMA engine status\n");
-	pos += seq_printf(s, "\tChannel number: %d\n", num_dma_channels);
+	seq_puts(s, "DMA engine status\n");
+	seq_printf(s, "\tChannel number: %d\n", num_dma_channels);
 
 	return pos;
 }
diff --git a/arch/microblaze/kernel/cpu/mb.c b/arch/microblaze/kernel/cpu/mb.c
index 7b5dca7..fc9185b 100644
--- a/arch/microblaze/kernel/cpu/mb.c
+++ b/arch/microblaze/kernel/cpu/mb.c
@@ -48,91 +48,90 @@ static int show_cpuinfo(struct seq_file *m, void *v)
 		}
 	}
 
-	count = seq_printf(m,
-			"CPU-Family:	MicroBlaze\n"
-			"FPGA-Arch:	%s\n"
-			"CPU-Ver:	%s, %s endian\n"
-			"CPU-MHz:	%d.%02d\n"
-			"BogoMips:	%lu.%02lu\n",
-			fpga_family,
-			cpu_ver,
-			cpuinfo.endian ? "little" : "big",
-			cpuinfo.cpu_clock_freq /
-			1000000,
-			cpuinfo.cpu_clock_freq %
-			1000000,
-			loops_per_jiffy / (500000 / HZ),
-			(loops_per_jiffy / (5000 / HZ)) % 100);
-
-	count += seq_printf(m,
-		"HW:\n Shift:\t\t%s\n"
-		" MSR:\t\t%s\n"
-		" PCMP:\t\t%s\n"
-		" DIV:\t\t%s\n",
-		(cpuinfo.use_instr & PVR0_USE_BARREL_MASK) ? "yes" : "no",
-		(cpuinfo.use_instr & PVR2_USE_MSR_INSTR) ? "yes" : "no",
-		(cpuinfo.use_instr & PVR2_USE_PCMP_INSTR) ? "yes" : "no",
-		(cpuinfo.use_instr & PVR0_USE_DIV_MASK) ? "yes" : "no");
-
-	count += seq_printf(m,
-			" MMU:\t\t%x\n",
-			cpuinfo.mmu);
-
-	count += seq_printf(m,
-		" MUL:\t\t%s\n"
-		" FPU:\t\t%s\n",
-		(cpuinfo.use_mult & PVR2_USE_MUL64_MASK) ? "v2" :
-			(cpuinfo.use_mult & PVR0_USE_HW_MUL_MASK) ? "v1" : "no",
-		(cpuinfo.use_fpu & PVR2_USE_FPU2_MASK) ? "v2" :
-			(cpuinfo.use_fpu & PVR0_USE_FPU_MASK) ? "v1" : "no");
-
-	count += seq_printf(m,
-		" Exc:\t\t%s%s%s%s%s%s%s%s\n",
-		(cpuinfo.use_exc & PVR2_OPCODE_0x0_ILL_MASK) ? "op0x0 " : "",
-		(cpuinfo.use_exc & PVR2_UNALIGNED_EXC_MASK) ? "unal " : "",
-		(cpuinfo.use_exc & PVR2_ILL_OPCODE_EXC_MASK) ? "ill " : "",
-		(cpuinfo.use_exc & PVR2_IOPB_BUS_EXC_MASK) ? "iopb " : "",
-		(cpuinfo.use_exc & PVR2_DOPB_BUS_EXC_MASK) ? "dopb " : "",
-		(cpuinfo.use_exc & PVR2_DIV_ZERO_EXC_MASK) ? "zero " : "",
-		(cpuinfo.use_exc & PVR2_FPU_EXC_MASK) ? "fpu " : "",
-		(cpuinfo.use_exc & PVR2_USE_FSL_EXC) ? "fsl " : "");
-
-	count += seq_printf(m,
-			"Stream-insns:\t%sprivileged\n",
-			cpuinfo.mmu_privins ? "un" : "");
+	seq_printf(m,
+		   "CPU-Family:	MicroBlaze\n"
+		   "FPGA-Arch:	%s\n"
+		   "CPU-Ver:	%s, %s endian\n"
+		   "CPU-MHz:	%d.%02d\n"
+		   "BogoMips:	%lu.%02lu\n",
+		   fpga_family,
+		   cpu_ver,
+		   cpuinfo.endian ? "little" : "big",
+		   cpuinfo.cpu_clock_freq /
+		   1000000,
+		   cpuinfo.cpu_clock_freq %
+		   1000000,
+		   loops_per_jiffy / (500000 / HZ),
+		   (loops_per_jiffy / (5000 / HZ)) % 100);
+	count = m->last_len;
+
+	seq_printf(m,
+		   "HW:\n Shift:\t\t%s\n"
+		   " MSR:\t\t%s\n"
+		   " PCMP:\t\t%s\n"
+		   " DIV:\t\t%s\n",
+		   (cpuinfo.use_instr & PVR0_USE_BARREL_MASK) ? "yes" : "no",
+		   (cpuinfo.use_instr & PVR2_USE_MSR_INSTR) ? "yes" : "no",
+		   (cpuinfo.use_instr & PVR2_USE_PCMP_INSTR) ? "yes" : "no",
+		   (cpuinfo.use_instr & PVR0_USE_DIV_MASK) ? "yes" : "no");
+
+	seq_printf(m, " MMU:\t\t%x\n", cpuinfo.mmu);
+
+	seq_printf(m,
+		   " MUL:\t\t%s\n"
+		   " FPU:\t\t%s\n",
+		   (cpuinfo.use_mult & PVR2_USE_MUL64_MASK) ? "v2" :
+		   (cpuinfo.use_mult & PVR0_USE_HW_MUL_MASK) ? "v1" : "no",
+		   (cpuinfo.use_fpu & PVR2_USE_FPU2_MASK) ? "v2" :
+		   (cpuinfo.use_fpu & PVR0_USE_FPU_MASK) ? "v1" : "no");
+
+	seq_printf(m,
+		   " Exc:\t\t%s%s%s%s%s%s%s%s\n",
+		   (cpuinfo.use_exc & PVR2_OPCODE_0x0_ILL_MASK) ? "op0x0 " : "",
+		   (cpuinfo.use_exc & PVR2_UNALIGNED_EXC_MASK) ? "unal " : "",
+		   (cpuinfo.use_exc & PVR2_ILL_OPCODE_EXC_MASK) ? "ill " : "",
+		   (cpuinfo.use_exc & PVR2_IOPB_BUS_EXC_MASK) ? "iopb " : "",
+		   (cpuinfo.use_exc & PVR2_DOPB_BUS_EXC_MASK) ? "dopb " : "",
+		   (cpuinfo.use_exc & PVR2_DIV_ZERO_EXC_MASK) ? "zero " : "",
+		   (cpuinfo.use_exc & PVR2_FPU_EXC_MASK) ? "fpu " : "",
+		   (cpuinfo.use_exc & PVR2_USE_FSL_EXC) ? "fsl " : "");
+
+	seq_printf(m,
+		   "Stream-insns:\t%sprivileged\n",
+		   cpuinfo.mmu_privins ? "un" : "");
 
 	if (cpuinfo.use_icache)
-		count += seq_printf(m,
-				"Icache:\t\t%ukB\tline length:\t%dB\n",
-				cpuinfo.icache_size >> 10,
-				cpuinfo.icache_line_length);
+		seq_printf(m,
+			   "Icache:\t\t%ukB\tline length:\t%dB\n",
+			   cpuinfo.icache_size >> 10,
+			   cpuinfo.icache_line_length);
 	else
-		count += seq_printf(m, "Icache:\t\tno\n");
+		seq_puts(m, "Icache:\t\tno\n");
 
 	if (cpuinfo.use_dcache) {
-		count += seq_printf(m,
-				"Dcache:\t\t%ukB\tline length:\t%dB\n",
-				cpuinfo.dcache_size >> 10,
-				cpuinfo.dcache_line_length);
+		seq_printf(m,
+			   "Dcache:\t\t%ukB\tline length:\t%dB\n",
+			   cpuinfo.dcache_size >> 10,
+			   cpuinfo.dcache_line_length);
 		seq_printf(m, "Dcache-Policy:\t");
 		if (cpuinfo.dcache_wb)
-			count += seq_printf(m, "write-back\n");
+			seq_puts(m, "write-back\n");
 		else
-			count += seq_printf(m, "write-through\n");
+			seq_puts(m, "write-through\n");
 	} else
-		count += seq_printf(m, "Dcache:\t\tno\n");
+		seq_puts(m, "Dcache:\t\tno\n");
 
-	count += seq_printf(m,
-			"HW-Debug:\t%s\n",
-			cpuinfo.hw_debug ? "yes" : "no");
+	seq_printf(m,
+		   "HW-Debug:\t%s\n",
+		   cpuinfo.hw_debug ? "yes" : "no");
 
-	count += seq_printf(m,
-			"PVR-USR1:\t%02x\n"
-			"PVR-USR2:\t%08x\n",
-			cpuinfo.pvr_user1,
-			cpuinfo.pvr_user2);
+	seq_printf(m,
+		   "PVR-USR1:\t%02x\n"
+		   "PVR-USR2:\t%08x\n",
+		   cpuinfo.pvr_user1,
+		   cpuinfo.pvr_user2);
 
-	count += seq_printf(m, "Page size:\t%lu\n", PAGE_SIZE);
+	seq_printf(m, "Page size:\t%lu\n", PAGE_SIZE);
 	return 0;
 }
 
diff --git a/arch/x86/kernel/cpu/mtrr/if.c b/arch/x86/kernel/cpu/mtrr/if.c
index a041e09..8513d2e 100644
--- a/arch/x86/kernel/cpu/mtrr/if.c
+++ b/arch/x86/kernel/cpu/mtrr/if.c
@@ -425,11 +425,10 @@ static int mtrr_seq_show(struct seq_file *seq, void *offset)
 			size >>= 20 - PAGE_SHIFT;
 		}
 		/* Base can be > 32bit */
-		len += seq_printf(seq, "reg%02i: base=0x%06lx000 "
-			"(%5luMB), size=%5lu%cB, count=%d: %s\n",
-			i, base, base >> (20 - PAGE_SHIFT), size,
-			factor, mtrr_usage_table[i],
-			mtrr_attrib_to_str(type));
+		seq_printf(seq, "reg%02i: base=0x%06lx000 (%5luMB), size=%5lu%cB, count=%d: %s\n",
+			   i, base, base >> (20 - PAGE_SHIFT), size,
+			   factor, mtrr_usage_table[i],
+			   mtrr_attrib_to_str(type));
 	}
 	return 0;
 }
diff --git a/drivers/base/power/wakeup.c b/drivers/base/power/wakeup.c
index 2d56f41..6568d2d 100644
--- a/drivers/base/power/wakeup.c
+++ b/drivers/base/power/wakeup.c
@@ -845,13 +845,13 @@ static int print_wakeup_source_stats(struct seq_file *m,
 		active_time = ktime_set(0, 0);
 	}
 
-	ret = seq_printf(m, "%-12s\t%lu\t\t%lu\t\t%lu\t\t%lu\t\t"
-			"%lld\t\t%lld\t\t%lld\t\t%lld\t\t%lld\n",
-			ws->name, active_count, ws->event_count,
-			ws->wakeup_count, ws->expire_count,
-			ktime_to_ms(active_time), ktime_to_ms(total_time),
-			ktime_to_ms(max_time), ktime_to_ms(ws->last_time),
-			ktime_to_ms(prevent_sleep_time));
+	seq_printf(m, "%-12s\t%lu\t\t%lu\t\t%lu\t\t%lu\t\t%lld\t\t%lld\t\t%lld\t\t%lld\t\t%lld\n",
+		   ws->name, active_count, ws->event_count,
+		   ws->wakeup_count, ws->expire_count,
+		   ktime_to_ms(active_time), ktime_to_ms(total_time),
+		   ktime_to_ms(max_time), ktime_to_ms(ws->last_time),
+		   ktime_to_ms(prevent_sleep_time));
+	ret = m->last_ret;
 
 	spin_unlock_irqrestore(&ws->lock, flags);
 
diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index e592bb6..b8a8b16 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -1304,8 +1304,9 @@ static int ab8500_registers_print(struct device *dev, u32 bank,
 			}
 
 			if (s) {
-				err = seq_printf(s, "  [0x%02X/0x%02X]: 0x%02X\n",
-					bank, reg, value);
+				seq_printf(s, "  [0x%02X/0x%02X]: 0x%02X\n",
+					   bank, reg, value);
+				err = s->last_ret;
 				if (err < 0) {
 					/* Error is not returned here since
 					 * the output is wanted in any case */
@@ -1355,7 +1356,8 @@ static int ab8500_print_all_banks(struct seq_file *s, void *p)
 	seq_printf(s, AB8500_NAME_STRING " register values:\n");
 
 	for (i = 0; i < AB8500_NUM_BANKS; i++) {
-		err = seq_printf(s, " bank 0x%02X:\n", i);
+		seq_printf(s, " bank 0x%02X:\n", i);
+		err = s->last_ret;
 
 		ab8500_registers_print(dev, i, s);
 	}
@@ -1709,8 +1711,8 @@ static int ab8500_print_modem_registers(struct seq_file *s, void *p)
 			dev_err(dev, "ab->read fail %d\n", err);
 			return err;
 		}
-		err = seq_printf(s, "  [0x%02X/0x%02X]: 0x%02X\n",
-			bank, reg, value);
+		seq_printf(s, "  [0x%02X/0x%02X]: 0x%02X\n",
+			   bank, reg, value);
 	}
 	err = abx500_set_register_interruptible(dev,
 		AB8500_REGU_CTRL1, AB8500_SUPPLY_CONTROL_REG, orig_value);
diff --git a/drivers/mtd/devices/docg3.c b/drivers/mtd/devices/docg3.c
index 3e1b0a0..ac5d9f0 100644
--- a/drivers/mtd/devices/docg3.c
+++ b/drivers/mtd/devices/docg3.c
@@ -1662,14 +1662,13 @@ static int dbg_flashctrl_show(struct seq_file *s, void *p)
 	fctrl = doc_register_readb(docg3, DOC_FLASHCONTROL);
 	mutex_unlock(&docg3->cascade->lock);
 
-	pos += seq_printf(s,
-		 "FlashControl : 0x%02x (%s,CE# %s,%s,%s,flash %s)\n",
-		 fctrl,
-		 fctrl & DOC_CTRL_VIOLATION ? "protocol violation" : "-",
-		 fctrl & DOC_CTRL_CE ? "active" : "inactive",
-		 fctrl & DOC_CTRL_PROTECTION_ERROR ? "protection error" : "-",
-		 fctrl & DOC_CTRL_SEQUENCE_ERROR ? "sequence error" : "-",
-		 fctrl & DOC_CTRL_FLASHREADY ? "ready" : "not ready");
+	seq_printf(s, "FlashControl : 0x%02x (%s,CE# %s,%s,%s,flash %s)\n",
+		   fctrl,
+		   fctrl & DOC_CTRL_VIOLATION ? "protocol violation" : "-",
+		   fctrl & DOC_CTRL_CE ? "active" : "inactive",
+		   fctrl & DOC_CTRL_PROTECTION_ERROR ? "protection error" : "-",
+		   fctrl & DOC_CTRL_SEQUENCE_ERROR ? "sequence error" : "-",
+		   fctrl & DOC_CTRL_FLASHREADY ? "ready" : "not ready");
 	return pos;
 }
 DEBUGFS_RO_ATTR(flashcontrol, dbg_flashctrl_show);
@@ -1685,28 +1684,27 @@ static int dbg_asicmode_show(struct seq_file *s, void *p)
 	mode = pctrl & 0x03;
 	mutex_unlock(&docg3->cascade->lock);
 
-	pos += seq_printf(s,
-			 "%04x : RAM_WE=%d,RSTIN_RESET=%d,BDETCT_RESET=%d,WRITE_ENABLE=%d,POWERDOWN=%d,MODE=%d%d (",
-			 pctrl,
-			 pctrl & DOC_ASICMODE_RAM_WE ? 1 : 0,
-			 pctrl & DOC_ASICMODE_RSTIN_RESET ? 1 : 0,
-			 pctrl & DOC_ASICMODE_BDETCT_RESET ? 1 : 0,
-			 pctrl & DOC_ASICMODE_MDWREN ? 1 : 0,
-			 pctrl & DOC_ASICMODE_POWERDOWN ? 1 : 0,
-			 mode >> 1, mode & 0x1);
+	seq_printf(s, "%04x : RAM_WE=%d,RSTIN_RESET=%d,BDETCT_RESET=%d,WRITE_ENABLE=%d,POWERDOWN=%d,MODE=%d%d (",
+		   pctrl,
+		   pctrl & DOC_ASICMODE_RAM_WE ? 1 : 0,
+		   pctrl & DOC_ASICMODE_RSTIN_RESET ? 1 : 0,
+		   pctrl & DOC_ASICMODE_BDETCT_RESET ? 1 : 0,
+		   pctrl & DOC_ASICMODE_MDWREN ? 1 : 0,
+		   pctrl & DOC_ASICMODE_POWERDOWN ? 1 : 0,
+		   mode >> 1, mode & 0x1);
 
 	switch (mode) {
 	case DOC_ASICMODE_RESET:
-		pos += seq_printf(s, "reset");
+		seq_puts(s, "reset");
 		break;
 	case DOC_ASICMODE_NORMAL:
-		pos += seq_printf(s, "normal");
+		seq_puts(s, "normal");
 		break;
 	case DOC_ASICMODE_POWERDOWN:
-		pos += seq_printf(s, "powerdown");
+		seq_puts(s, "powerdown");
 		break;
 	}
-	pos += seq_printf(s, ")\n");
+	seq_puts(s, ")\n");
 	return pos;
 }
 DEBUGFS_RO_ATTR(asic_mode, dbg_asicmode_show);
@@ -1721,7 +1719,7 @@ static int dbg_device_id_show(struct seq_file *s, void *p)
 	id = doc_register_readb(docg3, DOC_DEVICESELECT);
 	mutex_unlock(&docg3->cascade->lock);
 
-	pos += seq_printf(s, "DeviceId = %d\n", id);
+	seq_printf(s, "DeviceId = %d\n", id);
 	return pos;
 }
 DEBUGFS_RO_ATTR(device_id, dbg_device_id_show);
@@ -1742,44 +1740,39 @@ static int dbg_protection_show(struct seq_file *s, void *p)
 	dps1_high = doc_register_readw(docg3, DOC_DPS1_ADDRHIGH);
 	mutex_unlock(&docg3->cascade->lock);
 
-	pos += seq_printf(s, "Protection = 0x%02x (",
-			 protect);
+	seq_printf(s, "Protection = 0x%02x (", protect);
 	if (protect & DOC_PROTECT_FOUNDRY_OTP_LOCK)
-		pos += seq_printf(s, "FOUNDRY_OTP_LOCK,");
+		seq_puts(s, "FOUNDRY_OTP_LOCK,");
 	if (protect & DOC_PROTECT_CUSTOMER_OTP_LOCK)
-		pos += seq_printf(s, "CUSTOMER_OTP_LOCK,");
+		seq_puts(s, "CUSTOMER_OTP_LOCK,");
 	if (protect & DOC_PROTECT_LOCK_INPUT)
-		pos += seq_printf(s, "LOCK_INPUT,");
+		seq_puts(s, "LOCK_INPUT,");
 	if (protect & DOC_PROTECT_STICKY_LOCK)
-		pos += seq_printf(s, "STICKY_LOCK,");
+		seq_puts(s, "STICKY_LOCK,");
 	if (protect & DOC_PROTECT_PROTECTION_ENABLED)
-		pos += seq_printf(s, "PROTECTION ON,");
+		seq_puts(s, "PROTECTION ON,");
 	if (protect & DOC_PROTECT_IPL_DOWNLOAD_LOCK)
-		pos += seq_printf(s, "IPL_DOWNLOAD_LOCK,");
+		seq_puts(s, "IPL_DOWNLOAD_LOCK,");
 	if (protect & DOC_PROTECT_PROTECTION_ERROR)
-		pos += seq_printf(s, "PROTECT_ERR,");
+		seq_puts(s, "PROTECT_ERR,");
 	else
-		pos += seq_printf(s, "NO_PROTECT_ERR");
-	pos += seq_printf(s, ")\n");
-
-	pos += seq_printf(s, "DPS0 = 0x%02x : "
-			 "Protected area [0x%x - 0x%x] : OTP=%d, READ=%d, "
-			 "WRITE=%d, HW_LOCK=%d, KEY_OK=%d\n",
-			 dps0, dps0_low, dps0_high,
-			 !!(dps0 & DOC_DPS_OTP_PROTECTED),
-			 !!(dps0 & DOC_DPS_READ_PROTECTED),
-			 !!(dps0 & DOC_DPS_WRITE_PROTECTED),
-			 !!(dps0 & DOC_DPS_HW_LOCK_ENABLED),
-			 !!(dps0 & DOC_DPS_KEY_OK));
-	pos += seq_printf(s, "DPS1 = 0x%02x : "
-			 "Protected area [0x%x - 0x%x] : OTP=%d, READ=%d, "
-			 "WRITE=%d, HW_LOCK=%d, KEY_OK=%d\n",
-			 dps1, dps1_low, dps1_high,
-			 !!(dps1 & DOC_DPS_OTP_PROTECTED),
-			 !!(dps1 & DOC_DPS_READ_PROTECTED),
-			 !!(dps1 & DOC_DPS_WRITE_PROTECTED),
-			 !!(dps1 & DOC_DPS_HW_LOCK_ENABLED),
-			 !!(dps1 & DOC_DPS_KEY_OK));
+		seq_puts(s, "NO_PROTECT_ERR");
+	seq_puts(s, ")\n");
+
+	seq_printf(s, "DPS0 = 0x%02x : Protected area [0x%x - 0x%x] : OTP=%d, READ=%d, WRITE=%d, HW_LOCK=%d, KEY_OK=%d\n",
+		   dps0, dps0_low, dps0_high,
+		   !!(dps0 & DOC_DPS_OTP_PROTECTED),
+		   !!(dps0 & DOC_DPS_READ_PROTECTED),
+		   !!(dps0 & DOC_DPS_WRITE_PROTECTED),
+		   !!(dps0 & DOC_DPS_HW_LOCK_ENABLED),
+		   !!(dps0 & DOC_DPS_KEY_OK));
+	seq_printf(s, "DPS1 = 0x%02x : Protected area [0x%x - 0x%x] : OTP=%d, READ=%d, WRITE=%d, HW_LOCK=%d, KEY_OK=%d\n",
+		   dps1, dps1_low, dps1_high,
+		   !!(dps1 & DOC_DPS_OTP_PROTECTED),
+		   !!(dps1 & DOC_DPS_READ_PROTECTED),
+		   !!(dps1 & DOC_DPS_WRITE_PROTECTED),
+		   !!(dps1 & DOC_DPS_HW_LOCK_ENABLED),
+		   !!(dps1 & DOC_DPS_KEY_OK));
 	return pos;
 }
 DEBUGFS_RO_ATTR(protection, dbg_protection_show);
diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
index 8b490d7..3d84154 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -1031,22 +1031,22 @@ static int ccio_proc_info(struct seq_file *m, void *p)
 		int j;
 #endif
 
-		len += seq_printf(m, "%s\n", ioc->name);
+		seq_printf(m, "%s\n", ioc->name);
 		
-		len += seq_printf(m, "Cujo 2.0 bug    : %s\n",
-				  (ioc->cujo20_bug ? "yes" : "no"));
+		seq_printf(m, "Cujo 2.0 bug    : %s\n",
+			   (ioc->cujo20_bug ? "yes" : "no"));
 		
-		len += seq_printf(m, "IO PDIR size    : %d bytes (%d entries)\n",
-			       total_pages * 8, total_pages);
+		seq_printf(m, "IO PDIR size    : %d bytes (%d entries)\n",
+			   total_pages * 8, total_pages);
 
 #ifdef CCIO_COLLECT_STATS
-		len += seq_printf(m, "IO PDIR entries : %ld free  %ld used (%d%%)\n",
-				  total_pages - ioc->used_pages, ioc->used_pages,
-				  (int)(ioc->used_pages * 100 / total_pages));
+		seq_printf(m, "IO PDIR entries : %ld free  %ld used (%d%%)\n",
+			   total_pages - ioc->used_pages, ioc->used_pages,
+			   (int)(ioc->used_pages * 100 / total_pages));
 #endif
 
-		len += seq_printf(m, "Resource bitmap : %d bytes (%d pages)\n", 
-				  ioc->res_size, total_pages);
+		seq_printf(m, "Resource bitmap : %d bytes (%d pages)\n",
+			   ioc->res_size, total_pages);
 
 #ifdef CCIO_COLLECT_STATS
 		min = max = ioc->avg_search[0];
@@ -1058,26 +1058,26 @@ static int ccio_proc_info(struct seq_file *m, void *p)
 				min = ioc->avg_search[j];
 		}
 		avg /= CCIO_SEARCH_SAMPLE;
-		len += seq_printf(m, "  Bitmap search : %ld/%ld/%ld (min/avg/max CPU Cycles)\n",
-				  min, avg, max);
+		seq_printf(m, "  Bitmap search : %ld/%ld/%ld (min/avg/max CPU Cycles)\n",
+			   min, avg, max);
 
-		len += seq_printf(m, "pci_map_single(): %8ld calls  %8ld pages (avg %d/1000)\n",
-				  ioc->msingle_calls, ioc->msingle_pages,
-				  (int)((ioc->msingle_pages * 1000)/ioc->msingle_calls));
+		seq_printf(m, "pci_map_single(): %8ld calls  %8ld pages (avg %d/1000)\n",
+			   ioc->msingle_calls, ioc->msingle_pages,
+			   (int)((ioc->msingle_pages * 1000)/ioc->msingle_calls));
 
 		/* KLUGE - unmap_sg calls unmap_single for each mapped page */
 		min = ioc->usingle_calls - ioc->usg_calls;
 		max = ioc->usingle_pages - ioc->usg_pages;
-		len += seq_printf(m, "pci_unmap_single: %8ld calls  %8ld pages (avg %d/1000)\n",
-				  min, max, (int)((max * 1000)/min));
+		seq_printf(m, "pci_unmap_single: %8ld calls  %8ld pages (avg %d/1000)\n",
+			   min, max, (int)((max * 1000)/min));
  
-		len += seq_printf(m, "pci_map_sg()    : %8ld calls  %8ld pages (avg %d/1000)\n",
-				  ioc->msg_calls, ioc->msg_pages,
-				  (int)((ioc->msg_pages * 1000)/ioc->msg_calls));
+		seq_printf(m, "pci_map_sg()    : %8ld calls  %8ld pages (avg %d/1000)\n",
+			   ioc->msg_calls, ioc->msg_pages,
+			   (int)((ioc->msg_pages * 1000)/ioc->msg_calls));
 
-		len += seq_printf(m, "pci_unmap_sg()  : %8ld calls  %8ld pages (avg %d/1000)\n\n\n",
-				  ioc->usg_calls, ioc->usg_pages,
-				  (int)((ioc->usg_pages * 1000)/ioc->usg_calls));
+		seq_printf(m, "pci_unmap_sg()  : %8ld calls  %8ld pages (avg %d/1000)\n\n\n",
+			   ioc->usg_calls, ioc->usg_pages,
+			   (int)((ioc->usg_pages * 1000)/ioc->usg_calls));
 #endif	/* CCIO_COLLECT_STATS */
 
 		ioc = ioc->next;
@@ -1110,11 +1110,11 @@ static int ccio_proc_bitmap_info(struct seq_file *m, void *p)
 
 		for (j = 0; j < (ioc->res_size / sizeof(u32)); j++) {
 			if ((j & 7) == 0)
-				len += seq_puts(m, "\n   ");
-			len += seq_printf(m, "%08x", *res_ptr);
+				seq_puts(m, "\n   ");
+			seq_printf(m, "%08x", *res_ptr);
 			res_ptr++;
 		}
-		len += seq_puts(m, "\n\n");
+		seq_puts(m, "\n\n");
 		ioc = ioc->next;
 		break; /* XXX - remove me */
 	}
diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
index 1ff1b67..08eed15 100644
--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -1776,35 +1776,35 @@ static int sba_proc_info(struct seq_file *m, void *p)
 #endif
 	int i, len = 0;
 
-	len += seq_printf(m, "%s rev %d.%d\n",
-		sba_dev->name,
-		(sba_dev->hw_rev & 0x7) + 1,
-		(sba_dev->hw_rev & 0x18) >> 3
+	seq_printf(m, "%s rev %d.%d\n",
+		   sba_dev->name,
+		   (sba_dev->hw_rev & 0x7) + 1,
+		   (sba_dev->hw_rev & 0x18) >> 3
 		);
-	len += seq_printf(m, "IO PDIR size    : %d bytes (%d entries)\n",
-		(int) ((ioc->res_size << 3) * sizeof(u64)), /* 8 bits/byte */
-		total_pages);
+	seq_printf(m, "IO PDIR size    : %d bytes (%d entries)\n",
+		   (int) ((ioc->res_size << 3) * sizeof(u64)), /* 8 bits/byte */
+		   total_pages);
 
-	len += seq_printf(m, "Resource bitmap : %d bytes (%d pages)\n", 
-		ioc->res_size, ioc->res_size << 3);   /* 8 bits per byte */
+	seq_printf(m, "Resource bitmap : %d bytes (%d pages)\n",
+		   ioc->res_size, ioc->res_size << 3);   /* 8 bits per byte */
 
-	len += seq_printf(m, "LMMIO_BASE/MASK/ROUTE %08x %08x %08x\n",
-		READ_REG32(sba_dev->sba_hpa + LMMIO_DIST_BASE),
-		READ_REG32(sba_dev->sba_hpa + LMMIO_DIST_MASK),
-		READ_REG32(sba_dev->sba_hpa + LMMIO_DIST_ROUTE)
+	seq_printf(m, "LMMIO_BASE/MASK/ROUTE %08x %08x %08x\n",
+		   READ_REG32(sba_dev->sba_hpa + LMMIO_DIST_BASE),
+		   READ_REG32(sba_dev->sba_hpa + LMMIO_DIST_MASK),
+		   READ_REG32(sba_dev->sba_hpa + LMMIO_DIST_ROUTE)
 		);
 
 	for (i=0; i<4; i++)
-		len += seq_printf(m, "DIR%d_BASE/MASK/ROUTE %08x %08x %08x\n", i,
-			READ_REG32(sba_dev->sba_hpa + LMMIO_DIRECT0_BASE  + i*0x18),
-			READ_REG32(sba_dev->sba_hpa + LMMIO_DIRECT0_MASK  + i*0x18),
-			READ_REG32(sba_dev->sba_hpa + LMMIO_DIRECT0_ROUTE + i*0x18)
-		);
+		seq_printf(m, "DIR%d_BASE/MASK/ROUTE %08x %08x %08x\n", i,
+			   READ_REG32(sba_dev->sba_hpa + LMMIO_DIRECT0_BASE  + i*0x18),
+			   READ_REG32(sba_dev->sba_hpa + LMMIO_DIRECT0_MASK  + i*0x18),
+			   READ_REG32(sba_dev->sba_hpa + LMMIO_DIRECT0_ROUTE + i*0x18)
+			);
 
 #ifdef SBA_COLLECT_STATS
-	len += seq_printf(m, "IO PDIR entries : %ld free  %ld used (%d%%)\n",
-		total_pages - ioc->used_pages, ioc->used_pages,
-		(int) (ioc->used_pages * 100 / total_pages));
+	seq_printf(m, "IO PDIR entries : %ld free  %ld used (%d%%)\n",
+		   total_pages - ioc->used_pages, ioc->used_pages,
+		   (int) (ioc->used_pages * 100 / total_pages));
 
 	min = max = ioc->avg_search[0];
 	for (i = 0; i < SBA_SEARCH_SAMPLE; i++) {
@@ -1813,26 +1813,26 @@ static int sba_proc_info(struct seq_file *m, void *p)
 		if (ioc->avg_search[i] < min) min = ioc->avg_search[i];
 	}
 	avg /= SBA_SEARCH_SAMPLE;
-	len += seq_printf(m, "  Bitmap search : %ld/%ld/%ld (min/avg/max CPU Cycles)\n",
-		min, avg, max);
+	seq_printf(m, "  Bitmap search : %ld/%ld/%ld (min/avg/max CPU Cycles)\n",
+		   min, avg, max);
 
-	len += seq_printf(m, "pci_map_single(): %12ld calls  %12ld pages (avg %d/1000)\n",
-		ioc->msingle_calls, ioc->msingle_pages,
-		(int) ((ioc->msingle_pages * 1000)/ioc->msingle_calls));
+	seq_printf(m, "pci_map_single(): %12ld calls  %12ld pages (avg %d/1000)\n",
+		   ioc->msingle_calls, ioc->msingle_pages,
+		   (int) ((ioc->msingle_pages * 1000)/ioc->msingle_calls));
 
 	/* KLUGE - unmap_sg calls unmap_single for each mapped page */
 	min = ioc->usingle_calls;
 	max = ioc->usingle_pages - ioc->usg_pages;
-	len += seq_printf(m, "pci_unmap_single: %12ld calls  %12ld pages (avg %d/1000)\n",
-		min, max, (int) ((max * 1000)/min));
+	seq_printf(m, "pci_unmap_single: %12ld calls  %12ld pages (avg %d/1000)\n",
+		   min, max, (int) ((max * 1000)/min));
 
-	len += seq_printf(m, "pci_map_sg()    : %12ld calls  %12ld pages (avg %d/1000)\n",
-		ioc->msg_calls, ioc->msg_pages, 
-		(int) ((ioc->msg_pages * 1000)/ioc->msg_calls));
+	seq_printf(m, "pci_map_sg()    : %12ld calls  %12ld pages (avg %d/1000)\n",
+		   ioc->msg_calls, ioc->msg_pages,
+		   (int) ((ioc->msg_pages * 1000)/ioc->msg_calls));
 
-	len += seq_printf(m, "pci_unmap_sg()  : %12ld calls  %12ld pages (avg %d/1000)\n",
-		ioc->usg_calls, ioc->usg_pages,
-		(int) ((ioc->usg_pages * 1000)/ioc->usg_calls));
+	seq_printf(m, "pci_unmap_sg()  : %12ld calls  %12ld pages (avg %d/1000)\n",
+		   ioc->usg_calls, ioc->usg_pages,
+		   (int) ((ioc->usg_pages * 1000)/ioc->usg_calls));
 #endif
 
 	return 0;
@@ -1862,10 +1862,10 @@ sba_proc_bitmap_info(struct seq_file *m, void *p)
 
 	for (i = 0; i < (ioc->res_size/sizeof(unsigned int)); ++i, ++res_ptr) {
 		if ((i & 7) == 0)
-			len += seq_printf(m, "\n   ");
-		len += seq_printf(m, " %08x", *res_ptr);
+			seq_puts(m, "\n   ");
+		seq_printf(m, " %08x", *res_ptr);
 	}
-	len += seq_printf(m, "\n");
+	seq_puts(m, "\n");
 
 	return 0;
 }
diff --git a/drivers/regulator/dbx500-prcmu.c b/drivers/regulator/dbx500-prcmu.c
index ce89f78..42f7651 100644
--- a/drivers/regulator/dbx500-prcmu.c
+++ b/drivers/regulator/dbx500-prcmu.c
@@ -93,15 +93,14 @@ void ux500_regulator_resume_debug(void)
 
 static int ux500_regulator_power_state_cnt_print(struct seq_file *s, void *p)
 {
-	struct device *dev = s->private;
-	int err;
-
 	/* print power state count */
-	err = seq_printf(s, "ux500-regulator power state count: %i\n",
-		power_state_active_get());
-	if (err < 0)
-		dev_err(dev, "seq_printf overflow\n");
+	seq_printf(s, "ux500-regulator power state count: %i\n",
+		   power_state_active_get());
+	if (s->last_ret < 0) {
+		struct device *dev = s->private;
 
+		dev_err(dev, "seq_printf overflow\n");
+	}
 	return 0;
 }
 
@@ -127,13 +126,12 @@ static int ux500_regulator_status_print(struct seq_file *s, void *p)
 	int i;
 
 	/* print dump header */
-	err = seq_printf(s, "ux500-regulator status:\n");
-	if (err < 0)
+	seq_puts(s, "ux500-regulator status:\n");
+	if (s->last_ret < 0)
 		dev_err(dev, "seq_printf overflow\n");
 
-	err = seq_printf(s, "%31s : %8s : %8s\n", "current",
-		"before", "after");
-	if (err < 0)
+	seq_printf(s, "%31s : %8s : %8s\n", "current", "before", "after");
+	if (s->last_ret < 0)
 		dev_err(dev, "seq_printf overflow\n");
 
 	for (i = 0; i < rdebug.num_regulators; i++) {
@@ -142,11 +140,13 @@ static int ux500_regulator_status_print(struct seq_file *s, void *p)
 		info = &rdebug.regulator_array[i];
 
 		/* print status */
-		err = seq_printf(s, "%20s : %8s : %8s : %8s\n", info->desc.name,
-			info->is_enabled ? "enabled" : "disabled",
-			rdebug.state_before_suspend[i] ? "enabled" : "disabled",
-			rdebug.state_after_suspend[i] ? "enabled" : "disabled");
-		if (err < 0)
+		seq_printf(s, "%20s : %8s : %8s : %8s\n",
+			   info->desc.name,
+			   info->is_enabled ? "enabled" : "disabled",
+			   rdebug.state_before_suspend[i] ? "enabled" : "disabled",
+			   rdebug.state_after_suspend[i] ? "enabled" : "disabled");
+		err = s->last_ret;
+		if (s->last_ret < 0)
 			dev_err(dev, "seq_printf overflow\n");
 	}
 
diff --git a/drivers/staging/lustre/lustre/fid/lproc_fid.c b/drivers/staging/lustre/lustre/fid/lproc_fid.c
index 294070d..503705e 100644
--- a/drivers/staging/lustre/lustre/fid/lproc_fid.c
+++ b/drivers/staging/lustre/lustre/fid/lproc_fid.c
@@ -109,7 +109,9 @@ lprocfs_fid_space_seq_show(struct seq_file *m, void *unused)
 	LASSERT(seq != NULL);
 
 	mutex_lock(&seq->lcs_mutex);
-	rc = seq_printf(m, "["LPX64" - "LPX64"]:%x:%s\n", PRANGE(&seq->lcs_space));
+	seq_printf(m, "[" LPX64 " - " LPX64 "]:%x:%s\n",
+		   PRANGE(&seq->lcs_space));
+	rc = m->last_ret;
 	mutex_unlock(&seq->lcs_mutex);
 
 	return rc;
@@ -158,7 +160,8 @@ lprocfs_fid_width_seq_show(struct seq_file *m, void *unused)
 	LASSERT(seq != NULL);
 
 	mutex_lock(&seq->lcs_mutex);
-	rc = seq_printf(m, LPU64"\n", seq->lcs_width);
+	seq_printf(m, LPU64 "\n", seq->lcs_width);
+	rc = m->last_ret;
 	mutex_unlock(&seq->lcs_mutex);
 
 	return rc;
@@ -173,7 +176,8 @@ lprocfs_fid_fid_seq_show(struct seq_file *m, void *unused)
 	LASSERT(seq != NULL);
 
 	mutex_lock(&seq->lcs_mutex);
-	rc = seq_printf(m, DFID"\n", PFID(&seq->lcs_fid));
+	seq_printf(m, DFID "\n", PFID(&seq->lcs_fid));
+	rc = m->last_ret;
 	mutex_unlock(&seq->lcs_mutex);
 
 	return rc;
@@ -190,9 +194,11 @@ lprocfs_fid_server_seq_show(struct seq_file *m, void *unused)
 
 	if (seq->lcs_exp != NULL) {
 		cli = &seq->lcs_exp->exp_obd->u.cli;
-		rc = seq_printf(m, "%s\n", cli->cl_target_uuid.uuid);
+		seq_printf(m, "%s\n", cli->cl_target_uuid.uuid);
+		rc = m->last_ret;
 	} else {
-		rc = seq_printf(m, "%s\n", seq->lcs_srv->lss_name);
+		seq_printf(m, "%s\n", seq->lcs_srv->lss_name);
+		rc = m->last_ret;
 	}
 	return rc;
 }
diff --git a/drivers/staging/lustre/lustre/llite/lproc_llite.c b/drivers/staging/lustre/lustre/llite/lproc_llite.c
index 8261d45..8b2a077 100644
--- a/drivers/staging/lustre/lustre/llite/lproc_llite.c
+++ b/drivers/staging/lustre/lustre/llite/lproc_llite.c
@@ -61,8 +61,10 @@ static int ll_blksize_seq_show(struct seq_file *m, void *v)
 	rc = ll_statfs_internal(sb, &osfs,
 				cfs_time_shift_64(-OBD_STATFS_CACHE_SECONDS),
 				OBD_STATFS_NODELAY);
-	if (!rc)
-	      rc = seq_printf(m, "%u\n", osfs.os_bsize);
+	if (!rc) {
+		seq_printf(m, "%u\n", osfs.os_bsize);
+	      rc = m->last_ret;
+}
 
 	return rc;
 }
@@ -85,7 +87,8 @@ static int ll_kbytestotal_seq_show(struct seq_file *m, void *v)
 		while (blk_size >>= 1)
 			result <<= 1;
 
-		rc = seq_printf(m, LPU64"\n", result);
+		seq_printf(m, LPU64 "\n", result);
+		rc = m->last_ret;
 	}
 	return rc;
 }
@@ -108,7 +111,8 @@ static int ll_kbytesfree_seq_show(struct seq_file *m, void *v)
 		while (blk_size >>= 1)
 			result <<= 1;
 
-		rc = seq_printf(m, LPU64"\n", result);
+		seq_printf(m, LPU64 "\n", result);
+		rc = m->last_ret;
 	}
 	return rc;
 }
@@ -131,7 +135,8 @@ static int ll_kbytesavail_seq_show(struct seq_file *m, void *v)
 		while (blk_size >>= 1)
 			result <<= 1;
 
-		rc = seq_printf(m, LPU64"\n", result);
+		seq_printf(m, LPU64 "\n", result);
+		rc = m->last_ret;
 	}
 	return rc;
 }
@@ -147,8 +152,10 @@ static int ll_filestotal_seq_show(struct seq_file *m, void *v)
 	rc = ll_statfs_internal(sb, &osfs,
 				cfs_time_shift_64(-OBD_STATFS_CACHE_SECONDS),
 				OBD_STATFS_NODELAY);
-	if (!rc)
-		 rc = seq_printf(m, LPU64"\n", osfs.os_files);
+	if (!rc) {
+		seq_printf(m, LPU64 "\n", osfs.os_files);
+		 rc = m->last_ret;
+}
 	return rc;
 }
 LPROC_SEQ_FOPS_RO(ll_filestotal);
@@ -163,8 +170,10 @@ static int ll_filesfree_seq_show(struct seq_file *m, void *v)
 	rc = ll_statfs_internal(sb, &osfs,
 				cfs_time_shift_64(-OBD_STATFS_CACHE_SECONDS),
 				OBD_STATFS_NODELAY);
-	if (!rc)
-		 rc = seq_printf(m, LPU64"\n", osfs.os_ffree);
+	if (!rc) {
+		seq_printf(m, LPU64 "\n", osfs.os_ffree);
+		 rc = m->last_ret;
+}
 	return rc;
 }
 LPROC_SEQ_FOPS_RO(ll_filesfree);
@@ -177,9 +186,10 @@ static int ll_client_type_seq_show(struct seq_file *m, void *v)
 	LASSERT(sbi != NULL);
 
 	if (sbi->ll_flags & LL_SBI_RMT_CLIENT)
-		rc = seq_printf(m, "remote client\n");
+		seq_puts(m, "remote client\n");
 	else
-		rc = seq_printf(m, "local client\n");
+		seq_puts(m, "local client\n");
+	rc = m->last_ret;
 
 	return rc;
 }
diff --git a/drivers/staging/lustre/lustre/mdc/lproc_mdc.c b/drivers/staging/lustre/lustre/mdc/lproc_mdc.c
index e0b8f18..fc14af2 100644
--- a/drivers/staging/lustre/lustre/mdc/lproc_mdc.c
+++ b/drivers/staging/lustre/lustre/mdc/lproc_mdc.c
@@ -48,7 +48,8 @@ static int mdc_max_rpcs_in_flight_seq_show(struct seq_file *m, void *v)
 	int rc;
 
 	client_obd_list_lock(&cli->cl_loi_list_lock);
-	rc = seq_printf(m, "%u\n", cli->cl_max_rpcs_in_flight);
+	seq_printf(m, "%u\n", cli->cl_max_rpcs_in_flight);
+	rc = m->last_ret;
 	client_obd_list_unlock(&cli->cl_loi_list_lock);
 	return rc;
 }
diff --git a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
index 3875b0d..2c5c87b 100644
--- a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
+++ b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
@@ -287,8 +287,10 @@ int lprocfs_rd_blksize(struct seq_file *m, void *data)
 	int rc = obd_statfs(NULL, obd->obd_self_export, &osfs,
 			    cfs_time_shift_64(-OBD_STATFS_CACHE_SECONDS),
 			    OBD_STATFS_NODELAY);
-	if (!rc)
-		rc = seq_printf(m, "%u\n", osfs.os_bsize);
+	if (!rc) {
+		seq_printf(m, "%u\n", osfs.os_bsize);
+		rc = m->last_ret;
+}
 	return rc;
 }
 EXPORT_SYMBOL(lprocfs_rd_blksize);
@@ -307,7 +309,8 @@ int lprocfs_rd_kbytestotal(struct seq_file *m, void *data)
 		while (blk_size >>= 1)
 			result <<= 1;
 
-		rc = seq_printf(m, LPU64"\n", result);
+		seq_printf(m, LPU64 "\n", result);
+		rc = m->last_ret;
 	}
 	return rc;
 }
@@ -327,7 +330,8 @@ int lprocfs_rd_kbytesfree(struct seq_file *m, void *data)
 		while (blk_size >>= 1)
 			result <<= 1;
 
-		rc = seq_printf(m, LPU64"\n", result);
+		seq_printf(m, LPU64 "\n", result);
+		rc = m->last_ret;
 	}
 	return rc;
 }
@@ -347,7 +351,8 @@ int lprocfs_rd_kbytesavail(struct seq_file *m, void *data)
 		while (blk_size >>= 1)
 			result <<= 1;
 
-		rc = seq_printf(m, LPU64"\n", result);
+		seq_printf(m, LPU64 "\n", result);
+		rc = m->last_ret;
 	}
 	return rc;
 }
@@ -360,8 +365,10 @@ int lprocfs_rd_filestotal(struct seq_file *m, void *data)
 	int rc = obd_statfs(NULL, obd->obd_self_export, &osfs,
 			    cfs_time_shift_64(-OBD_STATFS_CACHE_SECONDS),
 			    OBD_STATFS_NODELAY);
-	if (!rc)
-		rc = seq_printf(m, LPU64"\n", osfs.os_files);
+	if (!rc) {
+		seq_printf(m, LPU64 "\n", osfs.os_files);
+		rc = m->last_ret;
+}
 
 	return rc;
 }
@@ -374,8 +381,10 @@ int lprocfs_rd_filesfree(struct seq_file *m, void *data)
 	int rc = obd_statfs(NULL, obd->obd_self_export, &osfs,
 			    cfs_time_shift_64(-OBD_STATFS_CACHE_SECONDS),
 			    OBD_STATFS_NODELAY);
-	if (!rc)
-		rc = seq_printf(m, LPU64"\n", osfs.os_ffree);
+	if (!rc) {
+		seq_printf(m, LPU64 "\n", osfs.os_ffree);
+		rc = m->last_ret;
+}
 	return rc;
 }
 EXPORT_SYMBOL(lprocfs_rd_filesfree);
@@ -391,8 +400,9 @@ int lprocfs_rd_server_uuid(struct seq_file *m, void *data)
 	LPROCFS_CLIMP_CHECK(obd);
 	imp = obd->u.cli.cl_import;
 	imp_state_name = ptlrpc_import_state_name(imp->imp_state);
-	rc = seq_printf(m, "%s\t%s%s\n", obd2cli_tgt(obd), imp_state_name,
-			imp->imp_deactive ? "\tDEACTIVATED" : "");
+	seq_printf(m, "%s\t%s%s\n", obd2cli_tgt(obd), imp_state_name,
+		   imp->imp_deactive ? "\tDEACTIVATED" : "");
+	rc = m->last_ret;
 
 	LPROCFS_CLIMP_EXIT(obd);
 	return rc;
@@ -410,9 +420,10 @@ int lprocfs_rd_conn_uuid(struct seq_file *m, void *data)
 	LPROCFS_CLIMP_CHECK(obd);
 	conn = obd->u.cli.cl_import->imp_connection;
 	if (conn && obd->u.cli.cl_import)
-		rc = seq_printf(m, "%s\n", conn->c_remote_uuid.uuid);
+		seq_printf(m, "%s\n", conn->c_remote_uuid.uuid);
 	else
-		rc = seq_printf(m, "%s\n", "<none>");
+		seq_printf(m, "%s\n", "<none>");
+	rc = m->last_ret;
 
 	LPROCFS_CLIMP_EXIT(obd);
 	return rc;
@@ -1075,8 +1086,9 @@ static int lprocfs_stats_seq_show(struct seq_file *p, void *v)
 	if (idx == 0) {
 		struct timeval now;
 		do_gettimeofday(&now);
-		rc = seq_printf(p, "%-25s %lu.%lu secs.usecs\n",
-				"snapshot_time", now.tv_sec, now.tv_usec);
+		seq_printf(p, "%-25s %lu.%lu secs.usecs\n",
+			   "snapshot_time", now.tv_sec, now.tv_usec);
+		rc = p->last_ret;
 		if (rc < 0)
 			return rc;
 	}
@@ -1086,23 +1098,28 @@ static int lprocfs_stats_seq_show(struct seq_file *p, void *v)
 	if (ctr.lc_count == 0)
 		goto out;
 
-	rc = seq_printf(p, "%-25s "LPD64" samples [%s]", hdr->lc_name,
-			ctr.lc_count, hdr->lc_units);
+	seq_printf(p, "%-25s "LPD64" samples [%s]", hdr->lc_name,
+		   ctr.lc_count, hdr->lc_units);
+	rc = p->last_ret;
 
 	if (rc < 0)
 		goto out;
 
 	if ((hdr->lc_config & LPROCFS_CNTR_AVGMINMAX) && (ctr.lc_count > 0)) {
-		rc = seq_printf(p, " "LPD64" "LPD64" "LPD64,
-				ctr.lc_min, ctr.lc_max, ctr.lc_sum);
+		seq_printf(p, " " LPD64 " " LPD64 " " LPD64,
+			   ctr.lc_min, ctr.lc_max, ctr.lc_sum);
+		rc = p->last_ret;
 		if (rc < 0)
 			goto out;
-		if (hdr->lc_config & LPROCFS_CNTR_STDDEV)
-			rc = seq_printf(p, " "LPD64, ctr.lc_sumsquare);
+		if (hdr->lc_config & LPROCFS_CNTR_STDDEV) {
+			seq_printf(p, " " LPD64, ctr.lc_sumsquare);
+			rc = p->last_ret;
+		}
 		if (rc < 0)
 			goto out;
 	}
-	rc = seq_printf(p, "\n");
+	seq_puts(p, "\n");
+	rc = p->last_ret;
 out:
 	return (rc < 0) ? rc : 0;
 }
@@ -1984,7 +2001,8 @@ int lprocfs_obd_rd_max_pages_per_rpc(struct seq_file *m, void *data)
 	int rc;
 
 	client_obd_list_lock(&cli->cl_loi_list_lock);
-	rc = seq_printf(m, "%d\n", cli->cl_max_pages_per_rpc);
+	seq_printf(m, "%d\n", cli->cl_max_pages_per_rpc);
+	rc = m->last_ret;
 	client_obd_list_unlock(&cli->cl_loi_list_lock);
 	return rc;
 }
diff --git a/drivers/staging/lustre/lustre/osc/lproc_osc.c b/drivers/staging/lustre/lustre/osc/lproc_osc.c
index df5ddf8..b42eb5d 100644
--- a/drivers/staging/lustre/lustre/osc/lproc_osc.c
+++ b/drivers/staging/lustre/lustre/osc/lproc_osc.c
@@ -49,7 +49,8 @@ static int osc_active_seq_show(struct seq_file *m, void *v)
 	int rc;
 
 	LPROCFS_CLIMP_CHECK(dev);
-	rc = seq_printf(m, "%d\n", !dev->u.cli.cl_import->imp_deactive);
+	seq_printf(m, "%d\n", !dev->u.cli.cl_import->imp_deactive);
+	rc = m->last_ret;
 	LPROCFS_CLIMP_EXIT(dev);
 	return rc;
 }
@@ -83,7 +84,8 @@ static int osc_max_rpcs_in_flight_seq_show(struct seq_file *m, void *v)
 	int rc;
 
 	client_obd_list_lock(&cli->cl_loi_list_lock);
-	rc = seq_printf(m, "%u\n", cli->cl_max_rpcs_in_flight);
+	seq_printf(m, "%u\n", cli->cl_max_rpcs_in_flight);
+	rc = m->last_ret;
 	client_obd_list_unlock(&cli->cl_loi_list_lock);
 	return rc;
 }
@@ -164,12 +166,13 @@ static int osc_cached_mb_seq_show(struct seq_file *m, void *v)
 	int shift = 20 - PAGE_CACHE_SHIFT;
 	int rc;
 
-	rc = seq_printf(m,
-		      "used_mb: %d\n"
-		      "busy_cnt: %d\n",
-		      (atomic_read(&cli->cl_lru_in_list) +
-			atomic_read(&cli->cl_lru_busy)) >> shift,
-		      atomic_read(&cli->cl_lru_busy));
+	seq_printf(m,
+		   "used_mb: %d\n"
+		   "busy_cnt: %d\n",
+		   (atomic_read(&cli->cl_lru_in_list) +
+		    atomic_read(&cli->cl_lru_busy)) >> shift,
+		   atomic_read(&cli->cl_lru_busy));
+	rc = m->last_ret;
 
 	return rc;
 }
@@ -206,7 +209,8 @@ static int osc_cur_dirty_bytes_seq_show(struct seq_file *m, void *v)
 	int rc;
 
 	client_obd_list_lock(&cli->cl_loi_list_lock);
-	rc = seq_printf(m, "%lu\n", cli->cl_dirty);
+	seq_printf(m, "%lu\n", cli->cl_dirty);
+	rc = m->last_ret;
 	client_obd_list_unlock(&cli->cl_loi_list_lock);
 	return rc;
 }
@@ -219,7 +223,8 @@ static int osc_cur_grant_bytes_seq_show(struct seq_file *m, void *v)
 	int rc;
 
 	client_obd_list_lock(&cli->cl_loi_list_lock);
-	rc = seq_printf(m, "%lu\n", cli->cl_avail_grant);
+	seq_printf(m, "%lu\n", cli->cl_avail_grant);
+	rc = m->last_ret;
 	client_obd_list_unlock(&cli->cl_loi_list_lock);
 	return rc;
 }
@@ -264,7 +269,8 @@ static int osc_cur_lost_grant_bytes_seq_show(struct seq_file *m, void *v)
 	int rc;
 
 	client_obd_list_lock(&cli->cl_loi_list_lock);
-	rc = seq_printf(m, "%lu\n", cli->cl_lost_grant);
+	seq_printf(m, "%lu\n", cli->cl_lost_grant);
+	rc = m->last_ret;
 	client_obd_list_unlock(&cli->cl_loi_list_lock);
 	return rc;
 }
diff --git a/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c b/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
index 6bda26d..a068df2 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c
@@ -1310,7 +1310,8 @@ int lprocfs_rd_pinger_recov(struct seq_file *m, void *n)
 	int rc;
 
 	LPROCFS_CLIMP_CHECK(obd);
-	rc = seq_printf(m, "%d\n", !imp->imp_no_pinger_recover);
+	seq_printf(m, "%d\n", !imp->imp_no_pinger_recover);
+	rc = m->last_ret;
 	LPROCFS_CLIMP_EXIT(obd);
 
 	return rc;
diff --git a/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c b/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
index e90c8fb..968e85e 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c
@@ -129,45 +129,45 @@ int sptlrpc_proc_enc_pool_seq_show(struct seq_file *m, void *v)
 
 	spin_lock(&page_pools.epp_lock);
 
-	rc = seq_printf(m,
-		      "physical pages:	  %lu\n"
-		      "pages per pool:	  %lu\n"
-		      "max pages:	       %lu\n"
-		      "max pools:	       %u\n"
-		      "total pages:	     %lu\n"
-		      "total free:	      %lu\n"
-		      "idle index:	      %lu/100\n"
-		      "last shrink:	     %lds\n"
-		      "last access:	     %lds\n"
-		      "max pages reached:       %lu\n"
-		      "grows:		   %u\n"
-		      "grows failure:	   %u\n"
-		      "shrinks:		 %u\n"
-		      "cache access:	    %lu\n"
-		      "cache missing:	   %lu\n"
-		      "low free mark:	   %lu\n"
-		      "max waitqueue depth:     %u\n"
-		      "max wait time:	   "CFS_TIME_T"/%u\n"
-		      ,
-		      totalram_pages,
-		      PAGES_PER_POOL,
-		      page_pools.epp_max_pages,
-		      page_pools.epp_max_pools,
-		      page_pools.epp_total_pages,
-		      page_pools.epp_free_pages,
-		      page_pools.epp_idle_idx,
-		      cfs_time_current_sec() - page_pools.epp_last_shrink,
-		      cfs_time_current_sec() - page_pools.epp_last_access,
-		      page_pools.epp_st_max_pages,
-		      page_pools.epp_st_grows,
-		      page_pools.epp_st_grow_fails,
-		      page_pools.epp_st_shrinks,
-		      page_pools.epp_st_access,
-		      page_pools.epp_st_missings,
-		      page_pools.epp_st_lowfree,
-		      page_pools.epp_st_max_wqlen,
-		      page_pools.epp_st_max_wait, HZ
-		     );
+	seq_printf(m,
+		   "physical pages:	  %lu\n"
+		   "pages per pool:	  %lu\n"
+		   "max pages:	       %lu\n"
+		   "max pools:	       %u\n"
+		   "total pages:	     %lu\n"
+		   "total free:	      %lu\n"
+		   "idle index:	      %lu/100\n"
+		   "last shrink:	     %lds\n"
+		   "last access:	     %lds\n"
+		   "max pages reached:       %lu\n"
+		   "grows:		   %u\n"
+		   "grows failure:	   %u\n"
+		   "shrinks:		 %u\n"
+		   "cache access:	    %lu\n"
+		   "cache missing:	   %lu\n"
+		   "low free mark:	   %lu\n"
+		   "max waitqueue depth:     %u\n"
+		   "max wait time:	   " CFS_TIME_T "/%u\n",
+		   totalram_pages,
+		   PAGES_PER_POOL,
+		   page_pools.epp_max_pages,
+		   page_pools.epp_max_pools,
+		   page_pools.epp_total_pages,
+		   page_pools.epp_free_pages,
+		   page_pools.epp_idle_idx,
+		   cfs_time_current_sec() - page_pools.epp_last_shrink,
+		   cfs_time_current_sec() - page_pools.epp_last_access,
+		   page_pools.epp_st_max_pages,
+		   page_pools.epp_st_grows,
+		   page_pools.epp_st_grow_fails,
+		   page_pools.epp_st_shrinks,
+		   page_pools.epp_st_access,
+		   page_pools.epp_st_missings,
+		   page_pools.epp_st_lowfree,
+		   page_pools.epp_st_max_wqlen,
+		   page_pools.epp_st_max_wait, HZ
+		);
+	rc = m->last_ret;
 
 	spin_unlock(&page_pools.epp_lock);
 	return rc;
diff --git a/drivers/usb/gadget/pxa27x_udc.c b/drivers/usb/gadget/pxa27x_udc.c
index 3c97da7..37704fd 100644
--- a/drivers/usb/gadget/pxa27x_udc.c
+++ b/drivers/usb/gadget/pxa27x_udc.c
@@ -90,7 +90,7 @@ static void handle_ep(struct pxa_ep *ep);
 static int state_dbg_show(struct seq_file *s, void *p)
 {
 	struct pxa_udc *udc = s->private;
-	int pos = 0, ret;
+	int ret;
 	u32 tmp;
 
 	ret = -ENODEV;
@@ -98,38 +98,37 @@ static int state_dbg_show(struct seq_file *s, void *p)
 		goto out;
 
 	/* basic device status */
-	pos += seq_printf(s, DRIVER_DESC "\n"
-			 "%s version: %s\nGadget driver: %s\n",
-			 driver_name, DRIVER_VERSION,
-			 udc->driver ? udc->driver->driver.name : "(none)");
+	seq_printf(s, DRIVER_DESC "\n"
+		   "%s version: %s\nGadget driver: %s\n",
+		   driver_name, DRIVER_VERSION,
+		   udc->driver ? udc->driver->driver.name : "(none)");
 
 	tmp = udc_readl(udc, UDCCR);
-	pos += seq_printf(s,
-			 "udccr=0x%0x(%s%s%s%s%s%s%s%s%s%s), "
-			 "con=%d,inter=%d,altinter=%d\n", tmp,
-			 (tmp & UDCCR_OEN) ? " oen":"",
-			 (tmp & UDCCR_AALTHNP) ? " aalthnp":"",
-			 (tmp & UDCCR_AHNP) ? " rem" : "",
-			 (tmp & UDCCR_BHNP) ? " rstir" : "",
-			 (tmp & UDCCR_DWRE) ? " dwre" : "",
-			 (tmp & UDCCR_SMAC) ? " smac" : "",
-			 (tmp & UDCCR_EMCE) ? " emce" : "",
-			 (tmp & UDCCR_UDR) ? " udr" : "",
-			 (tmp & UDCCR_UDA) ? " uda" : "",
-			 (tmp & UDCCR_UDE) ? " ude" : "",
-			 (tmp & UDCCR_ACN) >> UDCCR_ACN_S,
-			 (tmp & UDCCR_AIN) >> UDCCR_AIN_S,
-			 (tmp & UDCCR_AAISN) >> UDCCR_AAISN_S);
+	seq_printf(s,
+		   "udccr=0x%0x(%s%s%s%s%s%s%s%s%s%s), con=%d,inter=%d,altinter=%d\n",
+		   tmp,
+		   (tmp & UDCCR_OEN) ? " oen" : "",
+		   (tmp & UDCCR_AALTHNP) ? " aalthnp" : "",
+		   (tmp & UDCCR_AHNP) ? " rem" : "",
+		   (tmp & UDCCR_BHNP) ? " rstir" : "",
+		   (tmp & UDCCR_DWRE) ? " dwre" : "",
+		   (tmp & UDCCR_SMAC) ? " smac" : "",
+		   (tmp & UDCCR_EMCE) ? " emce" : "",
+		   (tmp & UDCCR_UDR) ? " udr" : "",
+		   (tmp & UDCCR_UDA) ? " uda" : "",
+		   (tmp & UDCCR_UDE) ? " ude" : "",
+		   (tmp & UDCCR_ACN) >> UDCCR_ACN_S,
+		   (tmp & UDCCR_AIN) >> UDCCR_AIN_S,
+		   (tmp & UDCCR_AAISN) >> UDCCR_AAISN_S);
 	/* registers for device and ep0 */
-	pos += seq_printf(s, "udcicr0=0x%08x udcicr1=0x%08x\n",
-			udc_readl(udc, UDCICR0), udc_readl(udc, UDCICR1));
-	pos += seq_printf(s, "udcisr0=0x%08x udcisr1=0x%08x\n",
-			udc_readl(udc, UDCISR0), udc_readl(udc, UDCISR1));
-	pos += seq_printf(s, "udcfnr=%d\n", udc_readl(udc, UDCFNR));
-	pos += seq_printf(s, "irqs: reset=%lu, suspend=%lu, resume=%lu, "
-			"reconfig=%lu\n",
-			udc->stats.irqs_reset, udc->stats.irqs_suspend,
-			udc->stats.irqs_resume, udc->stats.irqs_reconfig);
+	seq_printf(s, "udcicr0=0x%08x udcicr1=0x%08x\n",
+		   udc_readl(udc, UDCICR0), udc_readl(udc, UDCICR1));
+	seq_printf(s, "udcisr0=0x%08x udcisr1=0x%08x\n",
+		   udc_readl(udc, UDCISR0), udc_readl(udc, UDCISR1));
+	seq_printf(s, "udcfnr=%d\n", udc_readl(udc, UDCFNR));
+	seq_printf(s, "irqs: reset=%lu, suspend=%lu, resume=%lu, reconfig=%lu\n",
+		   udc->stats.irqs_reset, udc->stats.irqs_suspend,
+		   udc->stats.irqs_resume, udc->stats.irqs_reconfig);
 
 	ret = 0;
 out:
@@ -141,7 +140,7 @@ static int queues_dbg_show(struct seq_file *s, void *p)
 	struct pxa_udc *udc = s->private;
 	struct pxa_ep *ep;
 	struct pxa27x_request *req;
-	int pos = 0, i, maxpkt, ret;
+	int i, maxpkt, ret;
 
 	ret = -ENODEV;
 	if (!udc->driver)
@@ -151,18 +150,18 @@ static int queues_dbg_show(struct seq_file *s, void *p)
 	for (i = 0; i < NR_PXA_ENDPOINTS; i++) {
 		ep = &udc->pxa_ep[i];
 		maxpkt = ep->fifo_size;
-		pos += seq_printf(s,  "%-12s max_pkt=%d %s\n",
-				EPNAME(ep), maxpkt, "pio");
+		seq_printf(s,  "%-12s max_pkt=%d %s\n",
+			   EPNAME(ep), maxpkt, "pio");
 
 		if (list_empty(&ep->queue)) {
-			pos += seq_printf(s, "\t(nothing queued)\n");
+			seq_puts(s, "\t(nothing queued)\n");
 			continue;
 		}
 
 		list_for_each_entry(req, &ep->queue, queue) {
-			pos += seq_printf(s,  "\treq %p len %d/%d buf %p\n",
-					&req->req, req->req.actual,
-					req->req.length, req->req.buf);
+			seq_printf(s,  "\treq %p len %d/%d buf %p\n",
+				   &req->req, req->req.actual,
+				   req->req.length, req->req.buf);
 		}
 	}
 
@@ -175,7 +174,7 @@ static int eps_dbg_show(struct seq_file *s, void *p)
 {
 	struct pxa_udc *udc = s->private;
 	struct pxa_ep *ep;
-	int pos = 0, i, ret;
+	int i, ret;
 	u32 tmp;
 
 	ret = -ENODEV;
@@ -184,27 +183,24 @@ static int eps_dbg_show(struct seq_file *s, void *p)
 
 	ep = &udc->pxa_ep[0];
 	tmp = udc_ep_readl(ep, UDCCSR);
-	pos += seq_printf(s, "udccsr0=0x%03x(%s%s%s%s%s%s%s)\n", tmp,
-			 (tmp & UDCCSR0_SA) ? " sa" : "",
-			 (tmp & UDCCSR0_RNE) ? " rne" : "",
-			 (tmp & UDCCSR0_FST) ? " fst" : "",
-			 (tmp & UDCCSR0_SST) ? " sst" : "",
-			 (tmp & UDCCSR0_DME) ? " dme" : "",
-			 (tmp & UDCCSR0_IPR) ? " ipr" : "",
-			 (tmp & UDCCSR0_OPC) ? " opc" : "");
+	seq_printf(s, "udccsr0=0x%03x(%s%s%s%s%s%s%s)\n", tmp,
+		   (tmp & UDCCSR0_SA) ? " sa" : "",
+		   (tmp & UDCCSR0_RNE) ? " rne" : "",
+		   (tmp & UDCCSR0_FST) ? " fst" : "",
+		   (tmp & UDCCSR0_SST) ? " sst" : "",
+		   (tmp & UDCCSR0_DME) ? " dme" : "",
+		   (tmp & UDCCSR0_IPR) ? " ipr" : "",
+		   (tmp & UDCCSR0_OPC) ? " opc" : "");
 	for (i = 0; i < NR_PXA_ENDPOINTS; i++) {
 		ep = &udc->pxa_ep[i];
 		tmp = i? udc_ep_readl(ep, UDCCR) : udc_readl(udc, UDCCR);
-		pos += seq_printf(s, "%-12s: "
-				"IN %lu(%lu reqs), OUT %lu(%lu reqs), "
-				"irqs=%lu, udccr=0x%08x, udccsr=0x%03x, "
-				"udcbcr=%d\n",
-				EPNAME(ep),
-				ep->stats.in_bytes, ep->stats.in_ops,
-				ep->stats.out_bytes, ep->stats.out_ops,
-				ep->stats.irqs,
-				tmp, udc_ep_readl(ep, UDCCSR),
-				udc_ep_readl(ep, UDCBCR));
+		seq_printf(s, "%-12s: IN %lu(%lu reqs), OUT %lu(%lu reqs), irqs=%lu, udccr=0x%08x, udccsr=0x%03x, udcbcr=%d\n",
+			   EPNAME(ep),
+			   ep->stats.in_bytes, ep->stats.in_ops,
+			   ep->stats.out_bytes, ep->stats.out_ops,
+			   ep->stats.irqs,
+			   tmp, udc_ep_readl(ep, UDCCSR),
+			   udc_ep_readl(ep, UDCBCR));
 	}
 
 	ret = 0;
diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 6314629..2c04599 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -699,9 +699,9 @@ int debugfs_print_regs32(struct seq_file *s, const struct debugfs_reg32 *regs,
 
 	for (i = 0; i < nregs; i++, regs++) {
 		if (prefix)
-			ret += seq_printf(s, "%s", prefix);
-		ret += seq_printf(s, "%s = 0x%08x\n", regs->name,
-				  readl(base + regs->offset));
+			seq_printf(s, "%s", prefix);
+		seq_printf(s, "%s = 0x%08x\n", regs->name,
+			   readl(base + regs->offset));
 	}
 	return ret;
 }
diff --git a/fs/dlm/debug_fs.c b/fs/dlm/debug_fs.c
index 7e073b9..7b67ea6 100644
--- a/fs/dlm/debug_fs.c
+++ b/fs/dlm/debug_fs.c
@@ -80,8 +80,9 @@ static int print_format1(struct dlm_rsb *res, struct seq_file *s)
 
 	lock_rsb(res);
 
-	rv = seq_printf(s, "\nResource %p Name (len=%d) \"",
-			res, res->res_length);
+	seq_printf(s, "\nResource %p Name (len=%d) \"",
+		   res, res->res_length);
+	rv = s->last_ret;
 	if (rv)
 		goto out;
 
@@ -93,16 +94,18 @@ static int print_format1(struct dlm_rsb *res, struct seq_file *s)
 	}
 
 	if (res->res_nodeid > 0)
-		rv = seq_printf(s, "\"  \nLocal Copy, Master is node %d\n",
-				res->res_nodeid);
+		seq_printf(s, "\" \nLocal Copy, Master is node %d\n",
+			   res->res_nodeid);
 	else if (res->res_nodeid == 0)
-		rv = seq_printf(s, "\"  \nMaster Copy\n");
+		seq_puts(s, "\" \nMaster Copy\n");
 	else if (res->res_nodeid == -1)
-		rv = seq_printf(s, "\"  \nLooking up master (lkid %x)\n",
-			   	res->res_first_lkid);
+		seq_printf(s, "\" \nLooking up master (lkid %x)\n",
+			   res->res_first_lkid);
 	else
-		rv = seq_printf(s, "\"  \nInvalid master %d\n",
-				res->res_nodeid);
+		seq_printf(s, "\" \nInvalid master %d\n", res->res_nodeid);
+
+	rv = s->last_ret;
+
 	if (rv)
 		goto out;
 
@@ -117,7 +120,8 @@ static int print_format1(struct dlm_rsb *res, struct seq_file *s)
 		}
 		if (rsb_flag(res, RSB_VALNOTVALID))
 			seq_printf(s, " (INVALID)");
-		rv = seq_printf(s, "\n");
+		seq_puts(s, "\n");
+		rv = s->last_ret;
 		if (rv)
 			goto out;
 	}
@@ -126,9 +130,10 @@ static int print_format1(struct dlm_rsb *res, struct seq_file *s)
 	recover_list = !list_empty(&res->res_recover_list);
 
 	if (root_list || recover_list) {
-		rv = seq_printf(s, "Recovery: root %d recover %d flags %lx "
-				"count %d\n", root_list, recover_list,
-			   	res->res_flags, res->res_recover_locks_count);
+		seq_printf(s, "Recovery: root %d recover %d flags %lx count %d\n",
+			   root_list, recover_list, res->res_flags,
+			   res->res_recover_locks_count);
+		rv = s->last_ret;
 		if (rv)
 			goto out;
 	}
@@ -160,11 +165,13 @@ static int print_format1(struct dlm_rsb *res, struct seq_file *s)
 
 	seq_printf(s, "Lookup Queue\n");
 	list_for_each_entry(lkb, &res->res_lookup, lkb_rsb_lookup) {
-		rv = seq_printf(s, "%08x %s", lkb->lkb_id,
-				print_lockmode(lkb->lkb_rqmode));
+		seq_printf(s, "%08x %s", lkb->lkb_id,
+			   print_lockmode(lkb->lkb_rqmode));
+		rv = s->last_ret;
 		if (lkb->lkb_wait_type)
 			seq_printf(s, " wait_type: %d", lkb->lkb_wait_type);
-		rv = seq_printf(s, "\n");
+		seq_puts(s, "\n");
+		rv = s->last_ret;
 	}
  out:
 	unlock_rsb(res);
@@ -189,21 +196,22 @@ static int print_format2_lock(struct seq_file *s, struct dlm_lkb *lkb,
 	/* id nodeid remid pid xid exflags flags sts grmode rqmode time_us
 	   r_nodeid r_len r_name */
 
-	rv = seq_printf(s, "%x %d %x %u %llu %x %x %d %d %d %llu %u %d \"%s\"\n",
-			lkb->lkb_id,
-			lkb->lkb_nodeid,
-			lkb->lkb_remid,
-			lkb->lkb_ownpid,
-			(unsigned long long)xid,
-			lkb->lkb_exflags,
-			lkb->lkb_flags,
-			lkb->lkb_status,
-			lkb->lkb_grmode,
-			lkb->lkb_rqmode,
-			(unsigned long long)us,
-			r->res_nodeid,
-			r->res_length,
-			r->res_name);
+	seq_printf(s, "%x %d %x %u %llu %x %x %d %d %d %llu %u %d \"%s\"\n",
+		   lkb->lkb_id,
+		   lkb->lkb_nodeid,
+		   lkb->lkb_remid,
+		   lkb->lkb_ownpid,
+		   (unsigned long long)xid,
+		   lkb->lkb_exflags,
+		   lkb->lkb_flags,
+		   lkb->lkb_status,
+		   lkb->lkb_grmode,
+		   lkb->lkb_rqmode,
+		   (unsigned long long)us,
+		   r->res_nodeid,
+		   r->res_length,
+		   r->res_name);
+	rv = s->last_ret;
 	return rv;
 }
 
@@ -247,23 +255,24 @@ static int print_format3_lock(struct seq_file *s, struct dlm_lkb *lkb,
 			xid = lkb->lkb_ua->xid;
 	}
 
-	rv = seq_printf(s, "lkb %x %d %x %u %llu %x %x %d %d %d %d %d %d %u %llu %llu\n",
-			lkb->lkb_id,
-			lkb->lkb_nodeid,
-			lkb->lkb_remid,
-			lkb->lkb_ownpid,
-			(unsigned long long)xid,
-			lkb->lkb_exflags,
-			lkb->lkb_flags,
-			lkb->lkb_status,
-			lkb->lkb_grmode,
-			lkb->lkb_rqmode,
-			lkb->lkb_last_bast.mode,
-			rsb_lookup,
-			lkb->lkb_wait_type,
-			lkb->lkb_lvbseq,
-			(unsigned long long)ktime_to_ns(lkb->lkb_timestamp),
-			(unsigned long long)ktime_to_ns(lkb->lkb_last_bast_time));
+	seq_printf(s, "lkb %x %d %x %u %llu %x %x %d %d %d %d %d %d %u %llu %llu\n",
+		   lkb->lkb_id,
+		   lkb->lkb_nodeid,
+		   lkb->lkb_remid,
+		   lkb->lkb_ownpid,
+		   (unsigned long long)xid,
+		   lkb->lkb_exflags,
+		   lkb->lkb_flags,
+		   lkb->lkb_status,
+		   lkb->lkb_grmode,
+		   lkb->lkb_rqmode,
+		   lkb->lkb_last_bast.mode,
+		   rsb_lookup,
+		   lkb->lkb_wait_type,
+		   lkb->lkb_lvbseq,
+		   (unsigned long long)ktime_to_ns(lkb->lkb_timestamp),
+		   (unsigned long long)ktime_to_ns(lkb->lkb_last_bast_time));
+	rv = s->last_ret;
 	return rv;
 }
 
@@ -276,15 +285,16 @@ static int print_format3(struct dlm_rsb *r, struct seq_file *s)
 
 	lock_rsb(r);
 
-	rv = seq_printf(s, "rsb %p %d %x %lx %d %d %u %d ",
-			r,
-			r->res_nodeid,
-			r->res_first_lkid,
-			r->res_flags,
-			!list_empty(&r->res_root_list),
-			!list_empty(&r->res_recover_list),
-			r->res_recover_locks_count,
-			r->res_length);
+	seq_printf(s, "rsb %p %d %x %lx %d %d %u %d ",
+		   r,
+		   r->res_nodeid,
+		   r->res_first_lkid,
+		   r->res_flags,
+		   !list_empty(&r->res_root_list),
+		   !list_empty(&r->res_recover_list),
+		   r->res_recover_locks_count,
+		   r->res_length);
+	rv = s->last_ret;
 	if (rv)
 		goto out;
 
@@ -301,7 +311,8 @@ static int print_format3(struct dlm_rsb *r, struct seq_file *s)
 		else
 			seq_printf(s, " %02x", (unsigned char)r->res_name[i]);
 	}
-	rv = seq_printf(s, "\n");
+	seq_puts(s, "\n");
+	rv = s->last_ret;
 	if (rv)
 		goto out;
 
@@ -312,7 +323,8 @@ static int print_format3(struct dlm_rsb *r, struct seq_file *s)
 
 	for (i = 0; i < lvblen; i++)
 		seq_printf(s, " %02x", (unsigned char)r->res_lvbptr[i]);
-	rv = seq_printf(s, "\n");
+	seq_puts(s, "\n");
+	rv = s->last_ret;
 	if (rv)
 		goto out;
 
@@ -353,15 +365,16 @@ static int print_format4(struct dlm_rsb *r, struct seq_file *s)
 
 	lock_rsb(r);
 
-	rv = seq_printf(s, "rsb %p %d %d %d %d %lu %lx %d ",
-			r,
-			r->res_nodeid,
-			r->res_master_nodeid,
-			r->res_dir_nodeid,
-			our_nodeid,
-			r->res_toss_time,
-			r->res_flags,
-			r->res_length);
+	seq_printf(s, "rsb %p %d %d %d %d %lu %lx %d ",
+		   r,
+		   r->res_nodeid,
+		   r->res_master_nodeid,
+		   r->res_dir_nodeid,
+		   our_nodeid,
+		   r->res_toss_time,
+		   r->res_flags,
+		   r->res_length);
+	rv = s->last_ret;
 	if (rv)
 		goto out;
 
@@ -378,7 +391,8 @@ static int print_format4(struct dlm_rsb *r, struct seq_file *s)
 		else
 			seq_printf(s, " %02x", (unsigned char)r->res_name[i]);
 	}
-	rv = seq_printf(s, "\n");
+	seq_puts(s, "\n");
+	rv = s->last_ret;
  out:
 	unlock_rsb(r);
 	return rv;
diff --git a/fs/eventfd.c b/fs/eventfd.c
index 35470d9..08835ba 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -293,8 +293,9 @@ static int eventfd_show_fdinfo(struct seq_file *m, struct file *f)
 	int ret;
 
 	spin_lock_irq(&ctx->wqh.lock);
-	ret = seq_printf(m, "eventfd-count: %16llx\n",
-			 (unsigned long long)ctx->count);
+	seq_printf(m, "eventfd-count: %16llx\n",
+		   (unsigned long long)ctx->count);
+	ret = m->last_ret;
 	spin_unlock_irq(&ctx->wqh.lock);
 
 	return ret;
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 31c729d..35165c5 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -844,9 +844,10 @@ static int ep_show_fdinfo(struct seq_file *m, struct file *f)
 	for (rbp = rb_first(&ep->rbr); rbp; rbp = rb_next(rbp)) {
 		struct epitem *epi = rb_entry(rbp, struct epitem, rbn);
 
-		ret = seq_printf(m, "tfd: %8d events: %8x data: %16llx\n",
-				 epi->ffd.fd, epi->event.events,
-				 (long long)epi->event.data);
+		seq_printf(m, "tfd: %8d events: %8x data: %16llx\n",
+			   epi->ffd.fd, epi->event.events,
+			   (long long)epi->event.data);
+		ret = m->last_ret;
 		if (ret)
 			break;
 	}
diff --git a/fs/notify/fdinfo.c b/fs/notify/fdinfo.c
index 238a593..05db00a 100644
--- a/fs/notify/fdinfo.c
+++ b/fs/notify/fdinfo.c
@@ -58,11 +58,14 @@ static int show_mark_fhandle(struct seq_file *m, struct inode *inode)
 	f.handle.handle_type = ret;
 	f.handle.handle_bytes = size * sizeof(u32);
 
-	ret = seq_printf(m, "fhandle-bytes:%x fhandle-type:%x f_handle:",
-			 f.handle.handle_bytes, f.handle.handle_type);
+	seq_printf(m, "fhandle-bytes:%x fhandle-type:%x f_handle:",
+		   f.handle.handle_bytes, f.handle.handle_type);
+	ret = m->last_ret;
 
-	for (i = 0; i < f.handle.handle_bytes; i++)
-		ret |= seq_printf(m, "%02x", (int)f.handle.f_handle[i]);
+	for (i = 0; i < f.handle.handle_bytes; i++) {
+		seq_printf(m, "%02x", (int)f.handle.f_handle[i]);
+		ret |= m->last_ret;
+	}
 
 	return ret;
 }
@@ -87,11 +90,10 @@ static int inotify_fdinfo(struct seq_file *m, struct fsnotify_mark *mark)
 	inode_mark = container_of(mark, struct inotify_inode_mark, fsn_mark);
 	inode = igrab(mark->i.inode);
 	if (inode) {
-		ret = seq_printf(m, "inotify wd:%x ino:%lx sdev:%x "
-				 "mask:%x ignored_mask:%x ",
-				 inode_mark->wd, inode->i_ino,
-				 inode->i_sb->s_dev,
-				 mark->mask, mark->ignored_mask);
+		seq_printf(m, "inotify wd:%x ino:%lx sdev:%x mask:%x ignored_mask:%x ",
+			   inode_mark->wd, inode->i_ino, inode->i_sb->s_dev,
+			   mark->mask, mark->ignored_mask);
+		ret = m->last_ret;
 		ret |= show_mark_fhandle(m, inode);
 		ret |= seq_putc(m, '\n');
 		iput(inode);
@@ -125,19 +127,19 @@ static int fanotify_fdinfo(struct seq_file *m, struct fsnotify_mark *mark)
 		inode = igrab(mark->i.inode);
 		if (!inode)
 			goto out;
-		ret = seq_printf(m, "fanotify ino:%lx sdev:%x "
-				 "mflags:%x mask:%x ignored_mask:%x ",
-				 inode->i_ino, inode->i_sb->s_dev,
-				 mflags, mark->mask, mark->ignored_mask);
+		seq_printf(m, "fanotify ino:%lx sdev:%x mflags:%x mask:%x ignored_mask:%x ",
+			   inode->i_ino, inode->i_sb->s_dev,
+			   mflags, mark->mask, mark->ignored_mask);
+		ret = m->last_ret;
 		ret |= show_mark_fhandle(m, inode);
 		ret |= seq_putc(m, '\n');
 		iput(inode);
 	} else if (mark->flags & FSNOTIFY_MARK_FLAG_VFSMOUNT) {
 		struct mount *mnt = real_mount(mark->m.mnt);
 
-		ret = seq_printf(m, "fanotify mnt_id:%x mflags:%x mask:%x "
-				 "ignored_mask:%x\n", mnt->mnt_id, mflags,
-				 mark->mask, mark->ignored_mask);
+		seq_printf(m, "fanotify mnt_id:%x mflags:%x mask:%x ignored_mask:%x\n",
+			   mnt->mnt_id, mflags, mark->mask, mark->ignored_mask);
+		ret = m->last_ret;
 	}
 out:
 	return ret;
diff --git a/fs/seq_file.c b/fs/seq_file.c
index 3135c25..a9585c3 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -389,32 +389,31 @@ int seq_escape(struct seq_file *m, const char *s, const char *esc)
 }
 EXPORT_SYMBOL(seq_escape);
 
-int seq_vprintf(struct seq_file *m, const char *f, va_list args)
+void seq_vprintf(struct seq_file *m, const char *f, va_list args)
 {
 	int len;
 
 	if (m->count < m->size) {
 		len = vsnprintf(m->buf + m->count, m->size - m->count, f, args);
+		m->last_len = len;
 		if (m->count + len < m->size) {
 			m->count += len;
-			return 0;
+			m->last_ret = 0;
+			return;
 		}
 	}
 	seq_set_overflow(m);
-	return -1;
+	m->last_ret = -1;
 }
 EXPORT_SYMBOL(seq_vprintf);
 
-int seq_printf(struct seq_file *m, const char *f, ...)
+void seq_printf(struct seq_file *m, const char *f, ...)
 {
-	int ret;
 	va_list args;
 
 	va_start(args, f);
-	ret = seq_vprintf(m, f, args);
+	seq_vprintf(m, f, args);
 	va_end(args);
-
-	return ret;
 }
 EXPORT_SYMBOL(seq_printf);
 
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index 4e32edc..b92994a 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -20,6 +20,8 @@ struct seq_file {
 	size_t size;
 	size_t from;
 	size_t count;
+	size_t last_len;
+	int last_ret;
 	loff_t index;
 	loff_t read_pos;
 	u64 version;
@@ -89,8 +91,8 @@ int seq_putc(struct seq_file *m, char c);
 int seq_puts(struct seq_file *m, const char *s);
 int seq_write(struct seq_file *seq, const void *data, size_t len);
 
-__printf(2, 3) int seq_printf(struct seq_file *, const char *, ...);
-__printf(2, 0) int seq_vprintf(struct seq_file *, const char *, va_list args);
+__printf(2, 3) void seq_printf(struct seq_file *, const char *, ...);
+__printf(2, 0) void seq_vprintf(struct seq_file *, const char *, va_list args);
 
 int seq_path(struct seq_file *, const struct path *, const char *);
 int seq_dentry(struct seq_file *, struct dentry *, const char *);
diff --git a/ipc/util.c b/ipc/util.c
index e829da9..a4eab9a 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -897,8 +897,10 @@ static int sysvipc_proc_show(struct seq_file *s, void *it)
 	struct ipc_proc_iter *iter = s->private;
 	struct ipc_proc_iface *iface = iter->iface;
 
-	if (it == SEQ_START_TOKEN)
-		return seq_puts(s, iface->header);
+	if (it == SEQ_START_TOKEN) {
+		seq_puts(s, iface->header);
+		return s->last_ret;
+}
 
 	return iface->show(s, it);
 }
diff --git a/net/batman-adv/gateway_client.c b/net/batman-adv/gateway_client.c
index 1ce4b87..563b474 100644
--- a/net/batman-adv/gateway_client.c
+++ b/net/batman-adv/gateway_client.c
@@ -477,16 +477,17 @@ static int batadv_write_buffer_text(struct batadv_priv *bat_priv,
 
 	curr_gw = batadv_gw_get_selected_gw_node(bat_priv);
 
-	ret = seq_printf(seq, "%s %pM (%3i) %pM [%10s]: %3i - %i%s/%i%s\n",
-			 (curr_gw == gw_node ? "=>" : "  "),
-			 gw_node->orig_node->orig,
-			 router->tq_avg, router->addr,
-			 router->if_incoming->net_dev->name,
-			 gw_node->orig_node->gw_flags,
-			 (down > 2048 ? down / 1024 : down),
-			 (down > 2048 ? "MBit" : "KBit"),
-			 (up > 2048 ? up / 1024 : up),
-			 (up > 2048 ? "MBit" : "KBit"));
+	seq_printf(seq, "%s %pM (%3i) %pM [%10s]: %3i - %i%s/%i%s\n",
+		   (curr_gw == gw_node ? "=>" : "  "),
+		   gw_node->orig_node->orig,
+		   router->tq_avg, router->addr,
+		   router->if_incoming->net_dev->name,
+		   gw_node->orig_node->gw_flags,
+		   (down > 2048 ? down / 1024 : down),
+		   (down > 2048 ? "MBit" : "KBit"),
+		   (up > 2048 ? up / 1024 : up),
+		   (up > 2048 ? "MBit" : "KBit"));
+	ret = seq->last_ret;
 
 	batadv_neigh_node_free_ref(router);
 	if (curr_gw)
diff --git a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
index 4c48e43..247f6c0 100644
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.c
@@ -104,7 +104,8 @@ static int ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 	if (ret)
 		return 0;
 
-	ret = seq_printf(s, "secctx=%s ", secctx);
+	seq_printf(s, "secctx=%s ", secctx);
+	ret = s->last_ret;
 
 	security_release_secctx(secctx, len);
 	return ret;
@@ -141,10 +142,11 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	NF_CT_ASSERT(l4proto);
 
 	ret = -ENOSPC;
-	if (seq_printf(s, "%-8s %u %ld ",
-		      l4proto->name, nf_ct_protonum(ct),
-		      timer_pending(&ct->timeout)
-		      ? (long)(ct->timeout.expires - jiffies)/HZ : 0) != 0)
+	seq_printf(s, "%-8s %u %ld ",
+		   l4proto->name, nf_ct_protonum(ct),
+		   timer_pending(&ct->timeout)
+		   ? (long)(ct->timeout.expires - jiffies)/HZ : 0);
+	if (s->last_ret)
 		goto release;
 
 	if (l4proto->print_conntrack && l4proto->print_conntrack(s, ct))
@@ -157,9 +159,11 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	if (seq_print_acct(s, ct, IP_CT_DIR_ORIGINAL))
 		goto release;
 
-	if (!(test_bit(IPS_SEEN_REPLY_BIT, &ct->status)))
-		if (seq_printf(s, "[UNREPLIED] "))
+	if (!(test_bit(IPS_SEEN_REPLY_BIT, &ct->status))) {
+		seq_puts(s, "[UNREPLIED] ");
+		if (s->last_ret)
 			goto release;
+	}
 
 	if (print_tuple(s, &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
 			l3proto, l4proto))
@@ -168,19 +172,23 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	if (seq_print_acct(s, ct, IP_CT_DIR_REPLY))
 		goto release;
 
-	if (test_bit(IPS_ASSURED_BIT, &ct->status))
-		if (seq_printf(s, "[ASSURED] "))
+	if (test_bit(IPS_ASSURED_BIT, &ct->status)) {
+		seq_puts(s, "[ASSURED] ");
+		if (s->last_ret)
 			goto release;
+	}
 
 #ifdef CONFIG_NF_CONNTRACK_MARK
-	if (seq_printf(s, "mark=%u ", ct->mark))
+	seq_printf(s, "mark=%u ", ct->mark);
+	if (s->last_ret)
 		goto release;
 #endif
 
 	if (ct_show_secctx(s, ct))
 		goto release;
 
-	if (seq_printf(s, "use=%u\n", atomic_read(&ct->ct_general.use)))
+	seq_printf(s, "use=%u\n", atomic_read(&ct->ct_general.use));
+	if (s->last_ret)
 		goto release;
 	ret = 0;
 release:
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 342c216..942d0b0 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -129,7 +129,8 @@ static int ct_show_secctx(struct seq_file *s, const struct nf_conn *ct)
 	if (ret)
 		return 0;
 
-	ret = seq_printf(s, "secctx=%s ", secctx);
+	seq_printf(s, "secctx=%s ", secctx);
+	ret = s->last_ret;
 
 	security_release_secctx(secctx, len);
 	return ret;
@@ -193,11 +194,12 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	NF_CT_ASSERT(l4proto);
 
 	ret = -ENOSPC;
-	if (seq_printf(s, "%-8s %u %-8s %u %ld ",
-		       l3proto->name, nf_ct_l3num(ct),
-		       l4proto->name, nf_ct_protonum(ct),
-		       timer_pending(&ct->timeout)
-		       ? (long)(ct->timeout.expires - jiffies)/HZ : 0) != 0)
+	seq_printf(s, "%-8s %u %-8s %u %ld ",
+		   l3proto->name, nf_ct_l3num(ct),
+		   l4proto->name, nf_ct_protonum(ct),
+		   timer_pending(&ct->timeout)
+		   ? (long)(ct->timeout.expires - jiffies)/HZ : 0);
+	if (s->last_ret)
 		goto release;
 
 	if (l4proto->print_conntrack && l4proto->print_conntrack(s, ct))
@@ -210,9 +212,11 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	if (seq_print_acct(s, ct, IP_CT_DIR_ORIGINAL))
 		goto release;
 
-	if (!(test_bit(IPS_SEEN_REPLY_BIT, &ct->status)))
-		if (seq_printf(s, "[UNREPLIED] "))
+	if (!(test_bit(IPS_SEEN_REPLY_BIT, &ct->status))) {
+		seq_puts(s, "[UNREPLIED] ");
+		if (s->last_ret)
 			goto release;
+	}
 
 	if (print_tuple(s, &ct->tuplehash[IP_CT_DIR_REPLY].tuple,
 			l3proto, l4proto))
@@ -221,12 +225,15 @@ static int ct_seq_show(struct seq_file *s, void *v)
 	if (seq_print_acct(s, ct, IP_CT_DIR_REPLY))
 		goto release;
 
-	if (test_bit(IPS_ASSURED_BIT, &ct->status))
-		if (seq_printf(s, "[ASSURED] "))
+	if (test_bit(IPS_ASSURED_BIT, &ct->status)) {
+		seq_puts(s, "[ASSURED] ");
+		if (s->last_ret)
 			goto release;
+	}
 
 #if defined(CONFIG_NF_CONNTRACK_MARK)
-	if (seq_printf(s, "mark=%u ", ct->mark))
+	seq_printf(s, "mark=%u ", ct->mark);
+	if (s->last_ret)
 		goto release;
 #endif
 
@@ -234,14 +241,16 @@ static int ct_seq_show(struct seq_file *s, void *v)
 		goto release;
 
 #ifdef CONFIG_NF_CONNTRACK_ZONES
-	if (seq_printf(s, "zone=%u ", nf_ct_zone(ct)))
+	seq_printf(s, "zone=%u ", nf_ct_zone(ct));
+	if (s->last_ret)
 		goto release;
 #endif
 
 	if (ct_show_delta_time(s, ct))
 		goto release;
 
-	if (seq_printf(s, "use=%u\n", atomic_read(&ct->ct_general.use)))
+	seq_printf(s, "use=%u\n", atomic_read(&ct->ct_general.use));
+	if (s->last_ret)
 		goto release;
 
 	ret = 0;
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index 5b26144..ba0d1e7 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -196,19 +196,21 @@ static int seq_show(struct seq_file *s, void *v)
 					   lockdep_is_held(&nf_log_mutex));
 
 	if (!logger)
-		ret = seq_printf(s, "%2lld NONE (", *pos);
+		seq_printf(s, "%2lld NONE (", *pos);
 	else
-		ret = seq_printf(s, "%2lld %s (", *pos, logger->name);
-
+		seq_printf(s, "%2lld %s (", *pos, logger->name);
+	ret = s->last_ret;
 	if (ret < 0)
 		return ret;
 
 	list_for_each_entry(t, &nf_loggers_l[*pos], list[*pos]) {
-		ret = seq_printf(s, "%s", t->name);
+		seq_printf(s, "%s", t->name);
+		ret = s->last_ret;
 		if (ret < 0)
 			return ret;
 		if (&t->list[*pos] != nf_loggers_l[*pos].prev) {
-			ret = seq_printf(s, ",");
+			seq_puts(s, ",");
+			ret = s->last_ret;
 			if (ret < 0)
 				return ret;
 		}
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 9ff035c..e4b4da0 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -794,25 +794,27 @@ static int dl_seq_real_show(struct dsthash_ent *ent, u_int8_t family,
 
 	switch (family) {
 	case NFPROTO_IPV4:
-		res = seq_printf(s, "%ld %pI4:%u->%pI4:%u %u %u %u\n",
-				 (long)(ent->expires - jiffies)/HZ,
-				 &ent->dst.ip.src,
-				 ntohs(ent->dst.src_port),
-				 &ent->dst.ip.dst,
-				 ntohs(ent->dst.dst_port),
-				 ent->rateinfo.credit, ent->rateinfo.credit_cap,
-				 ent->rateinfo.cost);
+		seq_printf(s, "%ld %pI4:%u->%pI4:%u %u %u %u\n",
+			   (long)(ent->expires - jiffies)/HZ,
+			   &ent->dst.ip.src,
+			   ntohs(ent->dst.src_port),
+			   &ent->dst.ip.dst,
+			   ntohs(ent->dst.dst_port),
+			   ent->rateinfo.credit, ent->rateinfo.credit_cap,
+			   ent->rateinfo.cost);
+		res = s->last_ret;
 		break;
 #if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 	case NFPROTO_IPV6:
-		res = seq_printf(s, "%ld %pI6:%u->%pI6:%u %u %u %u\n",
-				 (long)(ent->expires - jiffies)/HZ,
-				 &ent->dst.ip6.src,
-				 ntohs(ent->dst.src_port),
-				 &ent->dst.ip6.dst,
-				 ntohs(ent->dst.dst_port),
-				 ent->rateinfo.credit, ent->rateinfo.credit_cap,
-				 ent->rateinfo.cost);
+		seq_printf(s, "%ld %pI6:%u->%pI6:%u %u %u %u\n",
+			   (long)(ent->expires - jiffies)/HZ,
+			   &ent->dst.ip6.src,
+			   ntohs(ent->dst.src_port),
+			   &ent->dst.ip6.dst,
+			   ntohs(ent->dst.dst_port),
+			   ent->rateinfo.credit, ent->rateinfo.credit_cap,
+			   ent->rateinfo.cost);
+		res = s->last_ret;
 		break;
 #endif
 	default:


