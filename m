Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab3FYOgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 10:36:21 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:36221 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab3FYOgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 10:36:19 -0400
From: Runzhen Wang <runzhen@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc: michael@ellerman.id.au, paulus@samba.org, acme@redhat.com,
        sukadev@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>
Subject: [PATCH v2 2/2] perf tools: Make Power7 events available for perf
Date: Tue, 25 Jun 2013 22:35:33 +0800
Message-Id: <1372170933-4538-3-git-send-email-runzhen@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372170933-4538-1-git-send-email-runzhen@linux.vnet.ibm.com>
References: <1372170933-4538-1-git-send-email-runzhen@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062514-8256-0000-0000-000008139925
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Power7 supports over 530 different perf events but only a small
subset of these can be specified by name, for the remaining
events, we must specify them by their raw code:

        perf stat -e r2003c <application>

This patch makes all the POWER7 events available in sysfs.
So we can instead specify these as:

        perf stat -e 'cpu/PM_CMPLU_STALL_DFU/' <application>

where PM_CMPLU_STALL_DFU is the r2003c in previous example.

Before this patch is applied, the size of power7-pmu.o is:

$ size arch/powerpc/perf/power7-pmu.o
   text	   data	    bss	    dec	    hex	filename
   3073	   2720	      0	   5793	   16a1	arch/powerpc/perf/power7-pmu.o

and after the patch is applied, it is:

$ size arch/powerpc/perf/power7-pmu.o
   text	   data	    bss	    dec	    hex	filename
  15950	  31112	      0	  47062	   b7d6	arch/powerpc/perf/power7-pmu.o

For the run time overhead, I use two scripts, one is "event_name.sh",
which contains 50 event names, it looks like:

 # ./perf record  -e 'cpu/PM_CMPLU_STALL_DFU/' -e .....  /bin/sleep 1

the other one is named "event_code.sh" which use corresponding  events raw
code instead of events names, it looks like:

 # ./perf record -e r2003c -e ......  /bin/sleep 1

below is the result.

Using events name:

[root@localhost perf]# time ./event_name.sh
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.002 MB perf.data (~102 samples) ]

real	0m1.192s
user	0m0.028s
sys	0m0.106s

Using events raw code:

[root@localhost perf]# time ./event_code.sh
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.003 MB perf.data (~112 samples) ]

real	0m1.198s
user	0m0.028s
sys	0m0.105s

Signed-off-by: Runzhen Wang <runzhen@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/perf_event_server.h |    4 +-
 arch/powerpc/perf/power7-events-list.h       |  548 ++++++++++++++++++++++++++
 arch/powerpc/perf/power7-pmu.c               |  148 ++-----
 3 files changed, 582 insertions(+), 118 deletions(-)
 create mode 100644 arch/powerpc/perf/power7-events-list.h

diff --git a/arch/powerpc/include/asm/perf_event_server.h b/arch/powerpc/include/asm/perf_event_server.h
index f265049..d9270d8 100644
--- a/arch/powerpc/include/asm/perf_event_server.h
+++ b/arch/powerpc/include/asm/perf_event_server.h
@@ -136,11 +136,11 @@ extern ssize_t power_events_sysfs_show(struct device *dev,
 #define	EVENT_PTR(_id, _suffix)		&EVENT_VAR(_id, _suffix).attr.attr
 
 #define	EVENT_ATTR(_name, _id, _suffix)					\
-	PMU_EVENT_ATTR(_name, EVENT_VAR(_id, _suffix), PME_PM_##_id,	\
+	PMU_EVENT_ATTR(_name, EVENT_VAR(_id, _suffix), PME_##_id,	\
 			power_events_sysfs_show)
 
 #define	GENERIC_EVENT_ATTR(_name, _id)	EVENT_ATTR(_name, _id, _g)
 #define	GENERIC_EVENT_PTR(_id)		EVENT_PTR(_id, _g)
 
-#define	POWER_EVENT_ATTR(_name, _id)	EVENT_ATTR(PM_##_name, _id, _p)
+#define	POWER_EVENT_ATTR(_name, _id)	EVENT_ATTR(_name, _id, _p)
 #define	POWER_EVENT_PTR(_id)		EVENT_PTR(_id, _p)
diff --git a/arch/powerpc/perf/power7-events-list.h b/arch/powerpc/perf/power7-events-list.h
new file mode 100644
index 0000000..a67e8a9
--- /dev/null
+++ b/arch/powerpc/perf/power7-events-list.h
@@ -0,0 +1,548 @@
+/*
+ * Performance counter support for POWER7 processors.
+ *
+ * Copyright 2013 Runzhen Wang, IBM Corporation.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+EVENT(PM_IC_DEMAND_L2_BR_ALL,                 0x4898)
+EVENT(PM_GCT_UTIL_7_TO_10_SLOTS,              0x20a0)
+EVENT(PM_PMC2_SAVED,                          0x10022)
+EVENT(PM_CMPLU_STALL_DFU,                     0x2003c)
+EVENT(PM_VSU0_16FLOP,                         0xa0a4)
+EVENT(PM_MRK_LSU_DERAT_MISS,                  0x3d05a)
+EVENT(PM_MRK_ST_CMPL,                         0x10034)
+EVENT(PM_NEST_PAIR3_ADD,                      0x40881)
+EVENT(PM_L2_ST_DISP,                          0x46180)
+EVENT(PM_L2_CASTOUT_MOD,                      0x16180)
+EVENT(PM_ISEG,                                0x20a4)
+EVENT(PM_MRK_INST_TIMEO,                      0x40034)
+EVENT(PM_L2_RCST_DISP_FAIL_ADDR,              0x36282)
+EVENT(PM_LSU1_DC_PREF_STREAM_CONFIRM,         0xd0b6)
+EVENT(PM_IERAT_WR_64K,                        0x40be)
+EVENT(PM_MRK_DTLB_MISS_16M,                   0x4d05e)
+EVENT(PM_IERAT_MISS,                          0x100f6)
+EVENT(PM_MRK_PTEG_FROM_LMEM,                  0x4d052)
+EVENT(PM_FLOP,                                0x100f4)
+EVENT(PM_THRD_PRIO_4_5_CYC,                   0x40b4)
+EVENT(PM_BR_PRED_TA,                          0x40aa)
+EVENT(PM_CMPLU_STALL_FXU,                     0x20014)
+EVENT(PM_EXT_INT,                             0x200f8)
+EVENT(PM_VSU_FSQRT_FDIV,                      0xa888)
+EVENT(PM_MRK_LD_MISS_EXPOSED_CYC,             0x1003e)
+EVENT(PM_LSU1_LDF,                            0xc086)
+EVENT(PM_IC_WRITE_ALL,                        0x488c)
+EVENT(PM_LSU0_SRQ_STFWD,                      0xc0a0)
+EVENT(PM_PTEG_FROM_RL2L3_MOD,                 0x1c052)
+EVENT(PM_MRK_DATA_FROM_L31_SHR,               0x1d04e)
+EVENT(PM_DATA_FROM_L21_MOD,                   0x3c046)
+EVENT(PM_VSU1_SCAL_DOUBLE_ISSUED,             0xb08a)
+EVENT(PM_VSU0_8FLOP,                          0xa0a0)
+EVENT(PM_POWER_EVENT1,                        0x1006e)
+EVENT(PM_DISP_CLB_HELD_BAL,                   0x2092)
+EVENT(PM_VSU1_2FLOP,                          0xa09a)
+EVENT(PM_LWSYNC_HELD,                         0x209a)
+EVENT(PM_PTEG_FROM_DL2L3_SHR,                 0x3c054)
+EVENT(PM_INST_FROM_L21_MOD,                   0x34046)
+EVENT(PM_IERAT_XLATE_WR_16MPLUS,              0x40bc)
+EVENT(PM_IC_REQ_ALL,                          0x4888)
+EVENT(PM_DSLB_MISS,                           0xd090)
+EVENT(PM_L3_MISS,                             0x1f082)
+EVENT(PM_LSU0_L1_PREF,                        0xd0b8)
+EVENT(PM_VSU_SCALAR_SINGLE_ISSUED,            0xb884)
+EVENT(PM_LSU1_DC_PREF_STREAM_CONFIRM_STRIDE,  0xd0be)
+EVENT(PM_L2_INST,                             0x36080)
+EVENT(PM_VSU0_FRSP,                           0xa0b4)
+EVENT(PM_FLUSH_DISP,                          0x2082)
+EVENT(PM_PTEG_FROM_L2MISS,                    0x4c058)
+EVENT(PM_VSU1_DQ_ISSUED,                      0xb09a)
+EVENT(PM_CMPLU_STALL_LSU,                     0x20012)
+EVENT(PM_MRK_DATA_FROM_DMEM,                  0x1d04a)
+EVENT(PM_LSU_FLUSH_ULD,                       0xc8b0)
+EVENT(PM_PTEG_FROM_LMEM,                      0x4c052)
+EVENT(PM_MRK_DERAT_MISS_16M,                  0x3d05c)
+EVENT(PM_THRD_ALL_RUN_CYC,                    0x2000c)
+EVENT(PM_MEM0_PREFETCH_DISP,                  0x20083)
+EVENT(PM_MRK_STALL_CMPLU_CYC_COUNT,           0x3003f)
+EVENT(PM_DATA_FROM_DL2L3_MOD,                 0x3c04c)
+EVENT(PM_VSU_FRSP,                            0xa8b4)
+EVENT(PM_MRK_DATA_FROM_L21_MOD,               0x3d046)
+EVENT(PM_PMC1_OVERFLOW,                       0x20010)
+EVENT(PM_VSU0_SINGLE,                         0xa0a8)
+EVENT(PM_MRK_PTEG_FROM_L3MISS,                0x2d058)
+EVENT(PM_MRK_PTEG_FROM_L31_SHR,               0x2d056)
+EVENT(PM_VSU0_VECTOR_SP_ISSUED,               0xb090)
+EVENT(PM_VSU1_FEST,                           0xa0ba)
+EVENT(PM_MRK_INST_DISP,                       0x20030)
+EVENT(PM_VSU0_COMPLEX_ISSUED,                 0xb096)
+EVENT(PM_LSU1_FLUSH_UST,                      0xc0b6)
+EVENT(PM_INST_CMPL,                           0x2)
+EVENT(PM_FXU_IDLE,                            0x1000e)
+EVENT(PM_LSU0_FLUSH_ULD,                      0xc0b0)
+EVENT(PM_MRK_DATA_FROM_DL2L3_MOD,             0x3d04c)
+EVENT(PM_LSU_LMQ_SRQ_EMPTY_ALL_CYC,           0x3001c)
+EVENT(PM_LSU1_REJECT_LMQ_FULL,                0xc0a6)
+EVENT(PM_INST_PTEG_FROM_L21_MOD,              0x3e056)
+EVENT(PM_INST_FROM_RL2L3_MOD,                 0x14042)
+EVENT(PM_SHL_CREATED,                         0x5082)
+EVENT(PM_L2_ST_HIT,                           0x46182)
+EVENT(PM_DATA_FROM_DMEM,                      0x1c04a)
+EVENT(PM_L3_LD_MISS,                          0x2f082)
+EVENT(PM_FXU1_BUSY_FXU0_IDLE,                 0x4000e)
+EVENT(PM_DISP_CLB_HELD_RES,                   0x2094)
+EVENT(PM_L2_SN_SX_I_DONE,                     0x36382)
+EVENT(PM_GRP_CMPL,                            0x30004)
+EVENT(PM_STCX_CMPL,                           0xc098)
+EVENT(PM_VSU0_2FLOP,                          0xa098)
+EVENT(PM_L3_PREF_MISS,                        0x3f082)
+EVENT(PM_LSU_SRQ_SYNC_CYC,                    0xd096)
+EVENT(PM_LSU_REJECT_ERAT_MISS,                0x20064)
+EVENT(PM_L1_ICACHE_MISS,                      0x200fc)
+EVENT(PM_LSU1_FLUSH_SRQ,                      0xc0be)
+EVENT(PM_LD_REF_L1_LSU0,                      0xc080)
+EVENT(PM_VSU0_FEST,                           0xa0b8)
+EVENT(PM_VSU_VECTOR_SINGLE_ISSUED,            0xb890)
+EVENT(PM_FREQ_UP,                             0x4000c)
+EVENT(PM_DATA_FROM_LMEM,                      0x3c04a)
+EVENT(PM_LSU1_LDX,                            0xc08a)
+EVENT(PM_PMC3_OVERFLOW,                       0x40010)
+EVENT(PM_MRK_BR_MPRED,                        0x30036)
+EVENT(PM_SHL_MATCH,                           0x5086)
+EVENT(PM_MRK_BR_TAKEN,                        0x10036)
+EVENT(PM_CMPLU_STALL_BRU,                     0x4004e)
+EVENT(PM_ISLB_MISS,                           0xd092)
+EVENT(PM_CYC,                                 0x1e)
+EVENT(PM_DISP_HELD_THERMAL,                   0x30006)
+EVENT(PM_INST_PTEG_FROM_RL2L3_SHR,            0x2e054)
+EVENT(PM_LSU1_SRQ_STFWD,                      0xc0a2)
+EVENT(PM_GCT_NOSLOT_BR_MPRED,                 0x4001a)
+EVENT(PM_1PLUS_PPC_CMPL,                      0x100f2)
+EVENT(PM_PTEG_FROM_DMEM,                      0x2c052)
+EVENT(PM_VSU_2FLOP,                           0xa898)
+EVENT(PM_GCT_FULL_CYC,                        0x4086)
+EVENT(PM_MRK_DATA_FROM_L3_CYC,                0x40020)
+EVENT(PM_LSU_SRQ_S0_ALLOC,                    0xd09d)
+EVENT(PM_MRK_DERAT_MISS_4K,                   0x1d05c)
+EVENT(PM_BR_MPRED_TA,                         0x40ae)
+EVENT(PM_INST_PTEG_FROM_L2MISS,               0x4e058)
+EVENT(PM_DPU_HELD_POWER,                      0x20006)
+EVENT(PM_RUN_INST_CMPL,                       0x400fa)
+EVENT(PM_MRK_VSU_FIN,                         0x30032)
+EVENT(PM_LSU_SRQ_S0_VALID,                    0xd09c)
+EVENT(PM_GCT_EMPTY_CYC,                       0x20008)
+EVENT(PM_IOPS_DISP,                           0x30014)
+EVENT(PM_RUN_SPURR,                           0x10008)
+EVENT(PM_PTEG_FROM_L21_MOD,                   0x3c056)
+EVENT(PM_VSU0_1FLOP,                          0xa080)
+EVENT(PM_SNOOP_TLBIE,                         0xd0b2)
+EVENT(PM_DATA_FROM_L3MISS,                    0x2c048)
+EVENT(PM_VSU_SINGLE,                          0xa8a8)
+EVENT(PM_DTLB_MISS_16G,                       0x1c05e)
+EVENT(PM_CMPLU_STALL_VECTOR,                  0x2001c)
+EVENT(PM_FLUSH,                               0x400f8)
+EVENT(PM_L2_LD_HIT,                           0x36182)
+EVENT(PM_NEST_PAIR2_AND,                      0x30883)
+EVENT(PM_VSU1_1FLOP,                          0xa082)
+EVENT(PM_IC_PREF_REQ,                         0x408a)
+EVENT(PM_L3_LD_HIT,                           0x2f080)
+EVENT(PM_GCT_NOSLOT_IC_MISS,                  0x2001a)
+EVENT(PM_DISP_HELD,                           0x10006)
+EVENT(PM_L2_LD,                               0x16080)
+EVENT(PM_LSU_FLUSH_SRQ,                       0xc8bc)
+EVENT(PM_BC_PLUS_8_CONV,                      0x40b8)
+EVENT(PM_MRK_DATA_FROM_L31_MOD_CYC,           0x40026)
+EVENT(PM_CMPLU_STALL_VECTOR_LONG,             0x4004a)
+EVENT(PM_L2_RCST_BUSY_RC_FULL,                0x26282)
+EVENT(PM_TB_BIT_TRANS,                        0x300f8)
+EVENT(PM_THERMAL_MAX,                         0x40006)
+EVENT(PM_LSU1_FLUSH_ULD,                      0xc0b2)
+EVENT(PM_LSU1_REJECT_LHS,                     0xc0ae)
+EVENT(PM_LSU_LRQ_S0_ALLOC,                    0xd09f)
+EVENT(PM_L3_CO_L31,                           0x4f080)
+EVENT(PM_POWER_EVENT4,                        0x4006e)
+EVENT(PM_DATA_FROM_L31_SHR,                   0x1c04e)
+EVENT(PM_BR_UNCOND,                           0x409e)
+EVENT(PM_LSU1_DC_PREF_STREAM_ALLOC,           0xd0aa)
+EVENT(PM_PMC4_REWIND,                         0x10020)
+EVENT(PM_L2_RCLD_DISP,                        0x16280)
+EVENT(PM_THRD_PRIO_2_3_CYC,                   0x40b2)
+EVENT(PM_MRK_PTEG_FROM_L2MISS,                0x4d058)
+EVENT(PM_IC_DEMAND_L2_BHT_REDIRECT,           0x4098)
+EVENT(PM_LSU_DERAT_MISS,                      0x200f6)
+EVENT(PM_IC_PREF_CANCEL_L2,                   0x4094)
+EVENT(PM_MRK_FIN_STALL_CYC_COUNT,             0x1003d)
+EVENT(PM_BR_PRED_CCACHE,                      0x40a0)
+EVENT(PM_GCT_UTIL_1_TO_2_SLOTS,               0x209c)
+EVENT(PM_MRK_ST_CMPL_INT,                     0x30034)
+EVENT(PM_LSU_TWO_TABLEWALK_CYC,               0xd0a6)
+EVENT(PM_MRK_DATA_FROM_L3MISS,                0x2d048)
+EVENT(PM_GCT_NOSLOT_CYC,                      0x100f8)
+EVENT(PM_LSU_SET_MPRED,                       0xc0a8)
+EVENT(PM_FLUSH_DISP_TLBIE,                    0x208a)
+EVENT(PM_VSU1_FCONV,                          0xa0b2)
+EVENT(PM_DERAT_MISS_16G,                      0x4c05c)
+EVENT(PM_INST_FROM_LMEM,                      0x3404a)
+EVENT(PM_IC_DEMAND_L2_BR_REDIRECT,            0x409a)
+EVENT(PM_CMPLU_STALL_SCALAR_LONG,             0x20018)
+EVENT(PM_INST_PTEG_FROM_L2,                   0x1e050)
+EVENT(PM_PTEG_FROM_L2,                        0x1c050)
+EVENT(PM_MRK_DATA_FROM_L21_SHR_CYC,           0x20024)
+EVENT(PM_MRK_DTLB_MISS_4K,                    0x2d05a)
+EVENT(PM_VSU0_FPSCR,                          0xb09c)
+EVENT(PM_VSU1_VECT_DOUBLE_ISSUED,             0xb082)
+EVENT(PM_MRK_PTEG_FROM_RL2L3_MOD,             0x1d052)
+EVENT(PM_MEM0_RQ_DISP,                        0x10083)
+EVENT(PM_L2_LD_MISS,                          0x26080)
+EVENT(PM_VMX_RESULT_SAT_1,                    0xb0a0)
+EVENT(PM_L1_PREF,                             0xd8b8)
+EVENT(PM_MRK_DATA_FROM_LMEM_CYC,              0x2002c)
+EVENT(PM_GRP_IC_MISS_NONSPEC,                 0x1000c)
+EVENT(PM_PB_NODE_PUMP,                        0x10081)
+EVENT(PM_SHL_MERGED,                          0x5084)
+EVENT(PM_NEST_PAIR1_ADD,                      0x20881)
+EVENT(PM_DATA_FROM_L3,                        0x1c048)
+EVENT(PM_LSU_FLUSH,                           0x208e)
+EVENT(PM_LSU_SRQ_SYNC_COUNT,                  0xd097)
+EVENT(PM_PMC2_OVERFLOW,                       0x30010)
+EVENT(PM_LSU_LDF,                             0xc884)
+EVENT(PM_POWER_EVENT3,                        0x3006e)
+EVENT(PM_DISP_WT,                             0x30008)
+EVENT(PM_CMPLU_STALL_REJECT,                  0x40016)
+EVENT(PM_IC_BANK_CONFLICT,                    0x4082)
+EVENT(PM_BR_MPRED_CR_TA,                      0x48ae)
+EVENT(PM_L2_INST_MISS,                        0x36082)
+EVENT(PM_CMPLU_STALL_ERAT_MISS,               0x40018)
+EVENT(PM_NEST_PAIR2_ADD,                      0x30881)
+EVENT(PM_MRK_LSU_FLUSH,                       0xd08c)
+EVENT(PM_L2_LDST,                             0x16880)
+EVENT(PM_INST_FROM_L31_SHR,                   0x1404e)
+EVENT(PM_VSU0_FIN,                            0xa0bc)
+EVENT(PM_LARX_LSU,                            0xc894)
+EVENT(PM_INST_FROM_RMEM,                      0x34042)
+EVENT(PM_DISP_CLB_HELD_TLBIE,                 0x2096)
+EVENT(PM_MRK_DATA_FROM_DMEM_CYC,              0x2002e)
+EVENT(PM_BR_PRED_CR,                          0x40a8)
+EVENT(PM_LSU_REJECT,                          0x10064)
+EVENT(PM_GCT_UTIL_3_TO_6_SLOTS,               0x209e)
+EVENT(PM_CMPLU_STALL_END_GCT_NOSLOT,          0x10028)
+EVENT(PM_LSU0_REJECT_LMQ_FULL,                0xc0a4)
+EVENT(PM_VSU_FEST,                            0xa8b8)
+EVENT(PM_NEST_PAIR0_AND,                      0x10883)
+EVENT(PM_PTEG_FROM_L3,                        0x2c050)
+EVENT(PM_POWER_EVENT2,                        0x2006e)
+EVENT(PM_IC_PREF_CANCEL_PAGE,                 0x4090)
+EVENT(PM_VSU0_FSQRT_FDIV,                     0xa088)
+EVENT(PM_MRK_GRP_CMPL,                        0x40030)
+EVENT(PM_VSU0_SCAL_DOUBLE_ISSUED,             0xb088)
+EVENT(PM_GRP_DISP,                            0x3000a)
+EVENT(PM_LSU0_LDX,                            0xc088)
+EVENT(PM_DATA_FROM_L2,                        0x1c040)
+EVENT(PM_MRK_DATA_FROM_RL2L3_MOD,             0x1d042)
+EVENT(PM_LD_REF_L1,                           0xc880)
+EVENT(PM_VSU0_VECT_DOUBLE_ISSUED,             0xb080)
+EVENT(PM_VSU1_2FLOP_DOUBLE,                   0xa08e)
+EVENT(PM_THRD_PRIO_6_7_CYC,                   0x40b6)
+EVENT(PM_BC_PLUS_8_RSLV_TAKEN,                0x40ba)
+EVENT(PM_BR_MPRED_CR,                         0x40ac)
+EVENT(PM_L3_CO_MEM,                           0x4f082)
+EVENT(PM_LD_MISS_L1,                          0x400f0)
+EVENT(PM_DATA_FROM_RL2L3_MOD,                 0x1c042)
+EVENT(PM_LSU_SRQ_FULL_CYC,                    0x1001a)
+EVENT(PM_TABLEWALK_CYC,                       0x10026)
+EVENT(PM_MRK_PTEG_FROM_RMEM,                  0x3d052)
+EVENT(PM_LSU_SRQ_STFWD,                       0xc8a0)
+EVENT(PM_INST_PTEG_FROM_RMEM,                 0x3e052)
+EVENT(PM_FXU0_FIN,                            0x10004)
+EVENT(PM_LSU1_L1_SW_PREF,                     0xc09e)
+EVENT(PM_PTEG_FROM_L31_MOD,                   0x1c054)
+EVENT(PM_PMC5_OVERFLOW,                       0x10024)
+EVENT(PM_LD_REF_L1_LSU1,                      0xc082)
+EVENT(PM_INST_PTEG_FROM_L21_SHR,              0x4e056)
+EVENT(PM_CMPLU_STALL_THRD,                    0x1001c)
+EVENT(PM_DATA_FROM_RMEM,                      0x3c042)
+EVENT(PM_VSU0_SCAL_SINGLE_ISSUED,             0xb084)
+EVENT(PM_BR_MPRED_LSTACK,                     0x40a6)
+EVENT(PM_MRK_DATA_FROM_RL2L3_MOD_CYC,         0x40028)
+EVENT(PM_LSU0_FLUSH_UST,                      0xc0b4)
+EVENT(PM_LSU_NCST,                            0xc090)
+EVENT(PM_BR_TAKEN,                            0x20004)
+EVENT(PM_INST_PTEG_FROM_LMEM,                 0x4e052)
+EVENT(PM_GCT_NOSLOT_BR_MPRED_IC_MISS,         0x4001c)
+EVENT(PM_DTLB_MISS_4K,                        0x2c05a)
+EVENT(PM_PMC4_SAVED,                          0x30022)
+EVENT(PM_VSU1_PERMUTE_ISSUED,                 0xb092)
+EVENT(PM_SLB_MISS,                            0xd890)
+EVENT(PM_LSU1_FLUSH_LRQ,                      0xc0ba)
+EVENT(PM_DTLB_MISS,                           0x300fc)
+EVENT(PM_VSU1_FRSP,                           0xa0b6)
+EVENT(PM_VSU_VECTOR_DOUBLE_ISSUED,            0xb880)
+EVENT(PM_L2_CASTOUT_SHR,                      0x16182)
+EVENT(PM_DATA_FROM_DL2L3_SHR,                 0x3c044)
+EVENT(PM_VSU1_STF,                            0xb08e)
+EVENT(PM_ST_FIN,                              0x200f0)
+EVENT(PM_PTEG_FROM_L21_SHR,                   0x4c056)
+EVENT(PM_L2_LOC_GUESS_WRONG,                  0x26480)
+EVENT(PM_MRK_STCX_FAIL,                       0xd08e)
+EVENT(PM_LSU0_REJECT_LHS,                     0xc0ac)
+EVENT(PM_IC_PREF_CANCEL_HIT,                  0x4092)
+EVENT(PM_L3_PREF_BUSY,                        0x4f080)
+EVENT(PM_MRK_BRU_FIN,                         0x2003a)
+EVENT(PM_LSU1_NCLD,                           0xc08e)
+EVENT(PM_INST_PTEG_FROM_L31_MOD,              0x1e054)
+EVENT(PM_LSU_NCLD,                            0xc88c)
+EVENT(PM_LSU_LDX,                             0xc888)
+EVENT(PM_L2_LOC_GUESS_CORRECT,                0x16480)
+EVENT(PM_THRESH_TIMEO,                        0x10038)
+EVENT(PM_L3_PREF_ST,                          0xd0ae)
+EVENT(PM_DISP_CLB_HELD_SYNC,                  0x2098)
+EVENT(PM_VSU_SIMPLE_ISSUED,                   0xb894)
+EVENT(PM_VSU1_SINGLE,                         0xa0aa)
+EVENT(PM_DATA_TABLEWALK_CYC,                  0x3001a)
+EVENT(PM_L2_RC_ST_DONE,                       0x36380)
+EVENT(PM_MRK_PTEG_FROM_L21_MOD,               0x3d056)
+EVENT(PM_LARX_LSU1,                           0xc096)
+EVENT(PM_MRK_DATA_FROM_RMEM,                  0x3d042)
+EVENT(PM_DISP_CLB_HELD,                       0x2090)
+EVENT(PM_DERAT_MISS_4K,                       0x1c05c)
+EVENT(PM_L2_RCLD_DISP_FAIL_ADDR,              0x16282)
+EVENT(PM_SEG_EXCEPTION,                       0x28a4)
+EVENT(PM_FLUSH_DISP_SB,                       0x208c)
+EVENT(PM_L2_DC_INV,                           0x26182)
+EVENT(PM_PTEG_FROM_DL2L3_MOD,                 0x4c054)
+EVENT(PM_DSEG,                                0x20a6)
+EVENT(PM_BR_PRED_LSTACK,                      0x40a2)
+EVENT(PM_VSU0_STF,                            0xb08c)
+EVENT(PM_LSU_FX_FIN,                          0x10066)
+EVENT(PM_DERAT_MISS_16M,                      0x3c05c)
+EVENT(PM_MRK_PTEG_FROM_DL2L3_MOD,             0x4d054)
+EVENT(PM_GCT_UTIL_11_PLUS_SLOTS,              0x20a2)
+EVENT(PM_INST_FROM_L3,                        0x14048)
+EVENT(PM_MRK_IFU_FIN,                         0x3003a)
+EVENT(PM_ITLB_MISS,                           0x400fc)
+EVENT(PM_VSU_STF,                             0xb88c)
+EVENT(PM_LSU_FLUSH_UST,                       0xc8b4)
+EVENT(PM_L2_LDST_MISS,                        0x26880)
+EVENT(PM_FXU1_FIN,                            0x40004)
+EVENT(PM_SHL_DEALLOCATED,                     0x5080)
+EVENT(PM_L2_SN_M_WR_DONE,                     0x46382)
+EVENT(PM_LSU_REJECT_SET_MPRED,                0xc8a8)
+EVENT(PM_L3_PREF_LD,                          0xd0ac)
+EVENT(PM_L2_SN_M_RD_DONE,                     0x46380)
+EVENT(PM_MRK_DERAT_MISS_16G,                  0x4d05c)
+EVENT(PM_VSU_FCONV,                           0xa8b0)
+EVENT(PM_ANY_THRD_RUN_CYC,                    0x100fa)
+EVENT(PM_LSU_LMQ_FULL_CYC,                    0xd0a4)
+EVENT(PM_MRK_LSU_REJECT_LHS,                  0xd082)
+EVENT(PM_MRK_LD_MISS_L1_CYC,                  0x4003e)
+EVENT(PM_MRK_DATA_FROM_L2_CYC,                0x20020)
+EVENT(PM_INST_IMC_MATCH_DISP,                 0x30016)
+EVENT(PM_MRK_DATA_FROM_RMEM_CYC,              0x4002c)
+EVENT(PM_VSU0_SIMPLE_ISSUED,                  0xb094)
+EVENT(PM_CMPLU_STALL_DIV,                     0x40014)
+EVENT(PM_MRK_PTEG_FROM_RL2L3_SHR,             0x2d054)
+EVENT(PM_VSU_FMA_DOUBLE,                      0xa890)
+EVENT(PM_VSU_4FLOP,                           0xa89c)
+EVENT(PM_VSU1_FIN,                            0xa0be)
+EVENT(PM_NEST_PAIR1_AND,                      0x20883)
+EVENT(PM_INST_PTEG_FROM_RL2L3_MOD,            0x1e052)
+EVENT(PM_RUN_CYC,                             0x200f4)
+EVENT(PM_PTEG_FROM_RMEM,                      0x3c052)
+EVENT(PM_LSU_LRQ_S0_VALID,                    0xd09e)
+EVENT(PM_LSU0_LDF,                            0xc084)
+EVENT(PM_FLUSH_COMPLETION,                    0x30012)
+EVENT(PM_ST_MISS_L1,                          0x300f0)
+EVENT(PM_L2_NODE_PUMP,                        0x36480)
+EVENT(PM_INST_FROM_DL2L3_SHR,                 0x34044)
+EVENT(PM_MRK_STALL_CMPLU_CYC,                 0x3003e)
+EVENT(PM_VSU1_DENORM,                         0xa0ae)
+EVENT(PM_MRK_DATA_FROM_L31_SHR_CYC,           0x20026)
+EVENT(PM_NEST_PAIR0_ADD,                      0x10881)
+EVENT(PM_INST_FROM_L3MISS,                    0x24048)
+EVENT(PM_EE_OFF_EXT_INT,                      0x2080)
+EVENT(PM_INST_PTEG_FROM_DMEM,                 0x2e052)
+EVENT(PM_INST_FROM_DL2L3_MOD,                 0x3404c)
+EVENT(PM_PMC6_OVERFLOW,                       0x30024)
+EVENT(PM_VSU_2FLOP_DOUBLE,                    0xa88c)
+EVENT(PM_TLB_MISS,                            0x20066)
+EVENT(PM_FXU_BUSY,                            0x2000e)
+EVENT(PM_L2_RCLD_DISP_FAIL_OTHER,             0x26280)
+EVENT(PM_LSU_REJECT_LMQ_FULL,                 0xc8a4)
+EVENT(PM_IC_RELOAD_SHR,                       0x4096)
+EVENT(PM_GRP_MRK,                             0x10031)
+EVENT(PM_MRK_ST_NEST,                         0x20034)
+EVENT(PM_VSU1_FSQRT_FDIV,                     0xa08a)
+EVENT(PM_LSU0_FLUSH_LRQ,                      0xc0b8)
+EVENT(PM_LARX_LSU0,                           0xc094)
+EVENT(PM_IBUF_FULL_CYC,                       0x4084)
+EVENT(PM_MRK_DATA_FROM_DL2L3_SHR_CYC,         0x2002a)
+EVENT(PM_LSU_DC_PREF_STREAM_ALLOC,            0xd8a8)
+EVENT(PM_GRP_MRK_CYC,                         0x10030)
+EVENT(PM_MRK_DATA_FROM_RL2L3_SHR_CYC,         0x20028)
+EVENT(PM_L2_GLOB_GUESS_CORRECT,               0x16482)
+EVENT(PM_LSU_REJECT_LHS,                      0xc8ac)
+EVENT(PM_MRK_DATA_FROM_LMEM,                  0x3d04a)
+EVENT(PM_INST_PTEG_FROM_L3,                   0x2e050)
+EVENT(PM_FREQ_DOWN,                           0x3000c)
+EVENT(PM_PB_RETRY_NODE_PUMP,                  0x30081)
+EVENT(PM_INST_FROM_RL2L3_SHR,                 0x1404c)
+EVENT(PM_MRK_INST_ISSUED,                     0x10032)
+EVENT(PM_PTEG_FROM_L3MISS,                    0x2c058)
+EVENT(PM_RUN_PURR,                            0x400f4)
+EVENT(PM_MRK_GRP_IC_MISS,                     0x40038)
+EVENT(PM_MRK_DATA_FROM_L3,                    0x1d048)
+EVENT(PM_CMPLU_STALL_DCACHE_MISS,             0x20016)
+EVENT(PM_PTEG_FROM_RL2L3_SHR,                 0x2c054)
+EVENT(PM_LSU_FLUSH_LRQ,                       0xc8b8)
+EVENT(PM_MRK_DERAT_MISS_64K,                  0x2d05c)
+EVENT(PM_INST_PTEG_FROM_DL2L3_MOD,            0x4e054)
+EVENT(PM_L2_ST_MISS,                          0x26082)
+EVENT(PM_MRK_PTEG_FROM_L21_SHR,               0x4d056)
+EVENT(PM_LWSYNC,                              0xd094)
+EVENT(PM_LSU0_DC_PREF_STREAM_CONFIRM_STRIDE,  0xd0bc)
+EVENT(PM_MRK_LSU_FLUSH_LRQ,                   0xd088)
+EVENT(PM_INST_IMC_MATCH_CMPL,                 0x100f0)
+EVENT(PM_NEST_PAIR3_AND,                      0x40883)
+EVENT(PM_PB_RETRY_SYS_PUMP,                   0x40081)
+EVENT(PM_MRK_INST_FIN,                        0x30030)
+EVENT(PM_MRK_PTEG_FROM_DL2L3_SHR,             0x3d054)
+EVENT(PM_INST_FROM_L31_MOD,                   0x14044)
+EVENT(PM_MRK_DTLB_MISS_64K,                   0x3d05e)
+EVENT(PM_LSU_FIN,                             0x30066)
+EVENT(PM_MRK_LSU_REJECT,                      0x40064)
+EVENT(PM_L2_CO_FAIL_BUSY,                     0x16382)
+EVENT(PM_MEM0_WQ_DISP,                        0x40083)
+EVENT(PM_DATA_FROM_L31_MOD,                   0x1c044)
+EVENT(PM_THERMAL_WARN,                        0x10016)
+EVENT(PM_VSU0_4FLOP,                          0xa09c)
+EVENT(PM_BR_MPRED_CCACHE,                     0x40a4)
+EVENT(PM_CMPLU_STALL_IFU,                     0x4004c)
+EVENT(PM_L1_DEMAND_WRITE,                     0x408c)
+EVENT(PM_FLUSH_BR_MPRED,                      0x2084)
+EVENT(PM_MRK_DTLB_MISS_16G,                   0x1d05e)
+EVENT(PM_MRK_PTEG_FROM_DMEM,                  0x2d052)
+EVENT(PM_L2_RCST_DISP,                        0x36280)
+EVENT(PM_CMPLU_STALL,                         0x4000a)
+EVENT(PM_LSU_PARTIAL_CDF,                     0xc0aa)
+EVENT(PM_DISP_CLB_HELD_SB,                    0x20a8)
+EVENT(PM_VSU0_FMA_DOUBLE,                     0xa090)
+EVENT(PM_FXU0_BUSY_FXU1_IDLE,                 0x3000e)
+EVENT(PM_IC_DEMAND_CYC,                       0x10018)
+EVENT(PM_MRK_DATA_FROM_L21_SHR,               0x3d04e)
+EVENT(PM_MRK_LSU_FLUSH_UST,                   0xd086)
+EVENT(PM_INST_PTEG_FROM_L3MISS,               0x2e058)
+EVENT(PM_VSU_DENORM,                          0xa8ac)
+EVENT(PM_MRK_LSU_PARTIAL_CDF,                 0xd080)
+EVENT(PM_INST_FROM_L21_SHR,                   0x3404e)
+EVENT(PM_IC_PREF_WRITE,                       0x408e)
+EVENT(PM_BR_PRED,                             0x409c)
+EVENT(PM_INST_FROM_DMEM,                      0x1404a)
+EVENT(PM_IC_PREF_CANCEL_ALL,                  0x4890)
+EVENT(PM_LSU_DC_PREF_STREAM_CONFIRM,          0xd8b4)
+EVENT(PM_MRK_LSU_FLUSH_SRQ,                   0xd08a)
+EVENT(PM_MRK_FIN_STALL_CYC,                   0x1003c)
+EVENT(PM_L2_RCST_DISP_FAIL_OTHER,             0x46280)
+EVENT(PM_VSU1_DD_ISSUED,                      0xb098)
+EVENT(PM_PTEG_FROM_L31_SHR,                   0x2c056)
+EVENT(PM_DATA_FROM_L21_SHR,                   0x3c04e)
+EVENT(PM_LSU0_NCLD,                           0xc08c)
+EVENT(PM_VSU1_4FLOP,                          0xa09e)
+EVENT(PM_VSU1_8FLOP,                          0xa0a2)
+EVENT(PM_VSU_8FLOP,                           0xa8a0)
+EVENT(PM_LSU_LMQ_SRQ_EMPTY_CYC,               0x2003e)
+EVENT(PM_DTLB_MISS_64K,                       0x3c05e)
+EVENT(PM_THRD_CONC_RUN_INST,                  0x300f4)
+EVENT(PM_MRK_PTEG_FROM_L2,                    0x1d050)
+EVENT(PM_PB_SYS_PUMP,                         0x20081)
+EVENT(PM_VSU_FIN,                             0xa8bc)
+EVENT(PM_MRK_DATA_FROM_L31_MOD,               0x1d044)
+EVENT(PM_THRD_PRIO_0_1_CYC,                   0x40b0)
+EVENT(PM_DERAT_MISS_64K,                      0x2c05c)
+EVENT(PM_PMC2_REWIND,                         0x30020)
+EVENT(PM_INST_FROM_L2,                        0x14040)
+EVENT(PM_GRP_BR_MPRED_NONSPEC,                0x1000a)
+EVENT(PM_INST_DISP,                           0x200f2)
+EVENT(PM_MEM0_RD_CANCEL_TOTAL,                0x30083)
+EVENT(PM_LSU0_DC_PREF_STREAM_CONFIRM,         0xd0b4)
+EVENT(PM_L1_DCACHE_RELOAD_VALID,              0x300f6)
+EVENT(PM_VSU_SCALAR_DOUBLE_ISSUED,            0xb888)
+EVENT(PM_L3_PREF_HIT,                         0x3f080)
+EVENT(PM_MRK_PTEG_FROM_L31_MOD,               0x1d054)
+EVENT(PM_CMPLU_STALL_STORE,                   0x2004a)
+EVENT(PM_MRK_FXU_FIN,                         0x20038)
+EVENT(PM_PMC4_OVERFLOW,                       0x10010)
+EVENT(PM_MRK_PTEG_FROM_L3,                    0x2d050)
+EVENT(PM_LSU0_LMQ_LHR_MERGE,                  0xd098)
+EVENT(PM_BTAC_HIT,                            0x508a)
+EVENT(PM_L3_RD_BUSY,                          0x4f082)
+EVENT(PM_LSU0_L1_SW_PREF,                     0xc09c)
+EVENT(PM_INST_FROM_L2MISS,                    0x44048)
+EVENT(PM_LSU0_DC_PREF_STREAM_ALLOC,           0xd0a8)
+EVENT(PM_L2_ST,                               0x16082)
+EVENT(PM_VSU0_DENORM,                         0xa0ac)
+EVENT(PM_MRK_DATA_FROM_DL2L3_SHR,             0x3d044)
+EVENT(PM_BR_PRED_CR_TA,                       0x48aa)
+EVENT(PM_VSU0_FCONV,                          0xa0b0)
+EVENT(PM_MRK_LSU_FLUSH_ULD,                   0xd084)
+EVENT(PM_BTAC_MISS,                           0x5088)
+EVENT(PM_MRK_LD_MISS_EXPOSED_CYC_COUNT,       0x1003f)
+EVENT(PM_MRK_DATA_FROM_L2,                    0x1d040)
+EVENT(PM_LSU_DCACHE_RELOAD_VALID,             0xd0a2)
+EVENT(PM_VSU_FMA,                             0xa884)
+EVENT(PM_LSU0_FLUSH_SRQ,                      0xc0bc)
+EVENT(PM_LSU1_L1_PREF,                        0xd0ba)
+EVENT(PM_IOPS_CMPL,                           0x10014)
+EVENT(PM_L2_SYS_PUMP,                         0x36482)
+EVENT(PM_L2_RCLD_BUSY_RC_FULL,                0x46282)
+EVENT(PM_LSU_LMQ_S0_ALLOC,                    0xd0a1)
+EVENT(PM_FLUSH_DISP_SYNC,                     0x2088)
+EVENT(PM_MRK_DATA_FROM_DL2L3_MOD_CYC,         0x4002a)
+EVENT(PM_L2_IC_INV,                           0x26180)
+EVENT(PM_MRK_DATA_FROM_L21_MOD_CYC,           0x40024)
+EVENT(PM_L3_PREF_LDST,                        0xd8ac)
+EVENT(PM_LSU_SRQ_EMPTY_CYC,                   0x40008)
+EVENT(PM_LSU_LMQ_S0_VALID,                    0xd0a0)
+EVENT(PM_FLUSH_PARTIAL,                       0x2086)
+EVENT(PM_VSU1_FMA_DOUBLE,                     0xa092)
+EVENT(PM_1PLUS_PPC_DISP,                      0x400f2)
+EVENT(PM_DATA_FROM_L2MISS,                    0x200fe)
+EVENT(PM_SUSPENDED,                           0x0)
+EVENT(PM_VSU0_FMA,                            0xa084)
+EVENT(PM_CMPLU_STALL_SCALAR,                  0x40012)
+EVENT(PM_STCX_FAIL,                           0xc09a)
+EVENT(PM_VSU0_FSQRT_FDIV_DOUBLE,              0xa094)
+EVENT(PM_DC_PREF_DST,                         0xd0b0)
+EVENT(PM_VSU1_SCAL_SINGLE_ISSUED,             0xb086)
+EVENT(PM_L3_HIT,                              0x1f080)
+EVENT(PM_L2_GLOB_GUESS_WRONG,                 0x26482)
+EVENT(PM_MRK_DFU_FIN,                         0x20032)
+EVENT(PM_INST_FROM_L1,                        0x4080)
+EVENT(PM_BRU_FIN,                             0x10068)
+EVENT(PM_IC_DEMAND_REQ,                       0x4088)
+EVENT(PM_VSU1_FSQRT_FDIV_DOUBLE,              0xa096)
+EVENT(PM_VSU1_FMA,                            0xa086)
+EVENT(PM_MRK_LD_MISS_L1,                      0x20036)
+EVENT(PM_VSU0_2FLOP_DOUBLE,                   0xa08c)
+EVENT(PM_LSU_DC_PREF_STRIDED_STREAM_CONFIRM,  0xd8bc)
+EVENT(PM_INST_PTEG_FROM_L31_SHR,              0x2e056)
+EVENT(PM_MRK_LSU_REJECT_ERAT_MISS,            0x30064)
+EVENT(PM_MRK_DATA_FROM_L2MISS,                0x4d048)
+EVENT(PM_DATA_FROM_RL2L3_SHR,                 0x1c04c)
+EVENT(PM_INST_FROM_PREF,                      0x14046)
+EVENT(PM_VSU1_SQ,                             0xb09e)
+EVENT(PM_L2_LD_DISP,                          0x36180)
+EVENT(PM_L2_DISP_ALL,                         0x46080)
+EVENT(PM_THRD_GRP_CMPL_BOTH_CYC,              0x10012)
+EVENT(PM_VSU_FSQRT_FDIV_DOUBLE,               0xa894)
+EVENT(PM_BR_MPRED,                            0x400f6)
+EVENT(PM_INST_PTEG_FROM_DL2L3_SHR,            0x3e054)
+EVENT(PM_VSU_1FLOP,                           0xa880)
+EVENT(PM_HV_CYC,                              0x2000a)
+EVENT(PM_MRK_LSU_FIN,                         0x40032)
+EVENT(PM_MRK_DATA_FROM_RL2L3_SHR,             0x1d04c)
+EVENT(PM_DTLB_MISS_16M,                       0x4c05e)
+EVENT(PM_LSU1_LMQ_LHR_MERGE,                  0xd09a)
+EVENT(PM_IFU_FIN,                             0x40066)
diff --git a/arch/powerpc/perf/power7-pmu.c b/arch/powerpc/perf/power7-pmu.c
index d1821b8..56c67bc 100644
--- a/arch/powerpc/perf/power7-pmu.c
+++ b/arch/powerpc/perf/power7-pmu.c
@@ -53,37 +53,13 @@
 /*
  * Power7 event codes.
  */
-#define	PME_PM_CYC			0x1e
-#define	PME_PM_GCT_NOSLOT_CYC		0x100f8
-#define	PME_PM_CMPLU_STALL		0x4000a
-#define	PME_PM_INST_CMPL		0x2
-#define	PME_PM_LD_REF_L1		0xc880
-#define	PME_PM_LD_MISS_L1		0x400f0
-#define	PME_PM_BRU_FIN			0x10068
-#define	PME_PM_BR_MPRED			0x400f6
-
-#define PME_PM_CMPLU_STALL_FXU			0x20014
-#define PME_PM_CMPLU_STALL_DIV			0x40014
-#define PME_PM_CMPLU_STALL_SCALAR		0x40012
-#define PME_PM_CMPLU_STALL_SCALAR_LONG		0x20018
-#define PME_PM_CMPLU_STALL_VECTOR		0x2001c
-#define PME_PM_CMPLU_STALL_VECTOR_LONG		0x4004a
-#define PME_PM_CMPLU_STALL_LSU			0x20012
-#define PME_PM_CMPLU_STALL_REJECT		0x40016
-#define PME_PM_CMPLU_STALL_ERAT_MISS		0x40018
-#define PME_PM_CMPLU_STALL_DCACHE_MISS		0x20016
-#define PME_PM_CMPLU_STALL_STORE		0x2004a
-#define PME_PM_CMPLU_STALL_THRD			0x1001c
-#define PME_PM_CMPLU_STALL_IFU			0x4004c
-#define PME_PM_CMPLU_STALL_BRU			0x4004e
-#define PME_PM_GCT_NOSLOT_IC_MISS		0x2001a
-#define PME_PM_GCT_NOSLOT_BR_MPRED		0x4001a
-#define PME_PM_GCT_NOSLOT_BR_MPRED_IC_MISS	0x4001c
-#define PME_PM_GRP_CMPL				0x30004
-#define PME_PM_1PLUS_PPC_CMPL			0x100f2
-#define PME_PM_CMPLU_STALL_DFU			0x2003c
-#define PME_PM_RUN_CYC				0x200f4
-#define PME_PM_RUN_INST_CMPL			0x400fa
+#define EVENT(_name, _code) \
+	PME_##_name = _code,
+
+enum {
+#include "power7-events-list.h"
+};
+#undef EVENT
 
 /*
  * Layout of constraint bits:
@@ -398,96 +374,36 @@ static int power7_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 };
 
 
-GENERIC_EVENT_ATTR(cpu-cycles,			CYC);
-GENERIC_EVENT_ATTR(stalled-cycles-frontend,	GCT_NOSLOT_CYC);
-GENERIC_EVENT_ATTR(stalled-cycles-backend,	CMPLU_STALL);
-GENERIC_EVENT_ATTR(instructions,		INST_CMPL);
-GENERIC_EVENT_ATTR(cache-references,		LD_REF_L1);
-GENERIC_EVENT_ATTR(cache-misses,		LD_MISS_L1);
-GENERIC_EVENT_ATTR(branch-instructions,		BRU_FIN);
-GENERIC_EVENT_ATTR(branch-misses,		BR_MPRED);
-
-POWER_EVENT_ATTR(CYC,				CYC);
-POWER_EVENT_ATTR(GCT_NOSLOT_CYC,		GCT_NOSLOT_CYC);
-POWER_EVENT_ATTR(CMPLU_STALL,			CMPLU_STALL);
-POWER_EVENT_ATTR(INST_CMPL,			INST_CMPL);
-POWER_EVENT_ATTR(LD_REF_L1,			LD_REF_L1);
-POWER_EVENT_ATTR(LD_MISS_L1,			LD_MISS_L1);
-POWER_EVENT_ATTR(BRU_FIN,			BRU_FIN)
-POWER_EVENT_ATTR(BR_MPRED,			BR_MPRED);
-
-POWER_EVENT_ATTR(CMPLU_STALL_FXU,		CMPLU_STALL_FXU);
-POWER_EVENT_ATTR(CMPLU_STALL_DIV,		CMPLU_STALL_DIV);
-POWER_EVENT_ATTR(CMPLU_STALL_SCALAR,		CMPLU_STALL_SCALAR);
-POWER_EVENT_ATTR(CMPLU_STALL_SCALAR_LONG,	CMPLU_STALL_SCALAR_LONG);
-POWER_EVENT_ATTR(CMPLU_STALL_VECTOR,		CMPLU_STALL_VECTOR);
-POWER_EVENT_ATTR(CMPLU_STALL_VECTOR_LONG,	CMPLU_STALL_VECTOR_LONG);
-POWER_EVENT_ATTR(CMPLU_STALL_LSU,		CMPLU_STALL_LSU);
-POWER_EVENT_ATTR(CMPLU_STALL_REJECT,		CMPLU_STALL_REJECT);
-
-POWER_EVENT_ATTR(CMPLU_STALL_ERAT_MISS,		CMPLU_STALL_ERAT_MISS);
-POWER_EVENT_ATTR(CMPLU_STALL_DCACHE_MISS,	CMPLU_STALL_DCACHE_MISS);
-POWER_EVENT_ATTR(CMPLU_STALL_STORE,		CMPLU_STALL_STORE);
-POWER_EVENT_ATTR(CMPLU_STALL_THRD,		CMPLU_STALL_THRD);
-POWER_EVENT_ATTR(CMPLU_STALL_IFU,		CMPLU_STALL_IFU);
-POWER_EVENT_ATTR(CMPLU_STALL_BRU,		CMPLU_STALL_BRU);
-POWER_EVENT_ATTR(GCT_NOSLOT_IC_MISS,		GCT_NOSLOT_IC_MISS);
-
-POWER_EVENT_ATTR(GCT_NOSLOT_BR_MPRED,		GCT_NOSLOT_BR_MPRED);
-POWER_EVENT_ATTR(GCT_NOSLOT_BR_MPRED_IC_MISS,	GCT_NOSLOT_BR_MPRED_IC_MISS);
-POWER_EVENT_ATTR(GRP_CMPL,			GRP_CMPL);
-POWER_EVENT_ATTR(1PLUS_PPC_CMPL,		1PLUS_PPC_CMPL);
-POWER_EVENT_ATTR(CMPLU_STALL_DFU,		CMPLU_STALL_DFU);
-POWER_EVENT_ATTR(RUN_CYC,			RUN_CYC);
-POWER_EVENT_ATTR(RUN_INST_CMPL,			RUN_INST_CMPL);
+GENERIC_EVENT_ATTR(cpu-cycles,			PM_CYC);
+GENERIC_EVENT_ATTR(stalled-cycles-frontend,	PM_GCT_NOSLOT_CYC);
+GENERIC_EVENT_ATTR(stalled-cycles-backend,	PM_CMPLU_STALL);
+GENERIC_EVENT_ATTR(instructions,		PM_INST_CMPL);
+GENERIC_EVENT_ATTR(cache-references,		PM_LD_REF_L1);
+GENERIC_EVENT_ATTR(cache-misses,		PM_LD_MISS_L1);
+GENERIC_EVENT_ATTR(branch-instructions,		PM_BRU_FIN);
+GENERIC_EVENT_ATTR(branch-misses,		PM_BR_MPRED);
+
+#define EVENT(_name, _code)     POWER_EVENT_ATTR(_name, _name);
+#include "power7-events-list.h"
+#undef EVENT
+
+#define EVENT(_name, _code)     POWER_EVENT_PTR(_name),
 
 static struct attribute *power7_events_attr[] = {
-	GENERIC_EVENT_PTR(CYC),
-	GENERIC_EVENT_PTR(GCT_NOSLOT_CYC),
-	GENERIC_EVENT_PTR(CMPLU_STALL),
-	GENERIC_EVENT_PTR(INST_CMPL),
-	GENERIC_EVENT_PTR(LD_REF_L1),
-	GENERIC_EVENT_PTR(LD_MISS_L1),
-	GENERIC_EVENT_PTR(BRU_FIN),
-	GENERIC_EVENT_PTR(BR_MPRED),
-
-	POWER_EVENT_PTR(CYC),
-	POWER_EVENT_PTR(GCT_NOSLOT_CYC),
-	POWER_EVENT_PTR(CMPLU_STALL),
-	POWER_EVENT_PTR(INST_CMPL),
-	POWER_EVENT_PTR(LD_REF_L1),
-	POWER_EVENT_PTR(LD_MISS_L1),
-	POWER_EVENT_PTR(BRU_FIN),
-	POWER_EVENT_PTR(BR_MPRED),
-
-	POWER_EVENT_PTR(CMPLU_STALL_FXU),
-	POWER_EVENT_PTR(CMPLU_STALL_DIV),
-	POWER_EVENT_PTR(CMPLU_STALL_SCALAR),
-	POWER_EVENT_PTR(CMPLU_STALL_SCALAR_LONG),
-	POWER_EVENT_PTR(CMPLU_STALL_VECTOR),
-	POWER_EVENT_PTR(CMPLU_STALL_VECTOR_LONG),
-	POWER_EVENT_PTR(CMPLU_STALL_LSU),
-	POWER_EVENT_PTR(CMPLU_STALL_REJECT),
-
-	POWER_EVENT_PTR(CMPLU_STALL_ERAT_MISS),
-	POWER_EVENT_PTR(CMPLU_STALL_DCACHE_MISS),
-	POWER_EVENT_PTR(CMPLU_STALL_STORE),
-	POWER_EVENT_PTR(CMPLU_STALL_THRD),
-	POWER_EVENT_PTR(CMPLU_STALL_IFU),
-	POWER_EVENT_PTR(CMPLU_STALL_BRU),
-	POWER_EVENT_PTR(GCT_NOSLOT_IC_MISS),
-	POWER_EVENT_PTR(GCT_NOSLOT_BR_MPRED),
-
-	POWER_EVENT_PTR(GCT_NOSLOT_BR_MPRED_IC_MISS),
-	POWER_EVENT_PTR(GRP_CMPL),
-	POWER_EVENT_PTR(1PLUS_PPC_CMPL),
-	POWER_EVENT_PTR(CMPLU_STALL_DFU),
-	POWER_EVENT_PTR(RUN_CYC),
-	POWER_EVENT_PTR(RUN_INST_CMPL),
+	GENERIC_EVENT_PTR(PM_CYC),
+	GENERIC_EVENT_PTR(PM_GCT_NOSLOT_CYC),
+	GENERIC_EVENT_PTR(PM_CMPLU_STALL),
+	GENERIC_EVENT_PTR(PM_INST_CMPL),
+	GENERIC_EVENT_PTR(PM_LD_REF_L1),
+	GENERIC_EVENT_PTR(PM_LD_MISS_L1),
+	GENERIC_EVENT_PTR(PM_BRU_FIN),
+	GENERIC_EVENT_PTR(PM_BR_MPRED),
+
+	#include "power7-events-list.h"
+	#undef EVENT
 	NULL
 };
 
-
 static struct attribute_group power7_pmu_events_group = {
 	.name = "events",
 	.attrs = power7_events_attr,
-- 
1.7.9.5

