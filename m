Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934591Ab3FSJRZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 05:17:25 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:51665 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933820Ab3FSJRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 05:17:21 -0400
From: Runzhen Wang <runzhen@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc: michael@ellerman.id.au, paulus@samba.org, acme@redhat.com,
        sukadev@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        icycoder@gmail.com, Runzhen Wang <runzhen@linux.vnet.ibm.com>
Subject: [PATCH 2/2] perf tools: Make Power7 events available for perf
Date: Wed, 19 Jun 2013 17:15:26 +0800
Message-Id: <1371633326-7696-2-git-send-email-runzhen@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1371633326-7696-1-git-send-email-runzhen@linux.vnet.ibm.com>
References: <1371633326-7696-1-git-send-email-runzhen@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061909-9574-0000-0000-0000085CDEE0
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
  14451	  31112	      0	  45563	   b1fb	arch/powerpc/perf/power7-pmu.o

Signed-off-by: Runzhen Wang <runzhen@linux.vnet.ibm.com>
---
 arch/powerpc/perf/power7-pmu.c | 1697 +++++++++++++++++++++++++++++++++++++---
 1 file changed, 1608 insertions(+), 89 deletions(-)

diff --git a/arch/powerpc/perf/power7-pmu.c b/arch/powerpc/perf/power7-pmu.c
index d1821b8..55e2404 100644
--- a/arch/powerpc/perf/power7-pmu.c
+++ b/arch/powerpc/perf/power7-pmu.c
@@ -53,37 +53,544 @@
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
+#define PME_PM_IC_DEMAND_L2_BR_ALL                0x4898
+#define PME_PM_GCT_UTIL_7_TO_10_SLOTS             0x20a0
+#define PME_PM_PMC2_SAVED                         0x10022
+#define PME_PM_CMPLU_STALL_DFU                    0x2003c
+#define PME_PM_VSU0_16FLOP                        0xa0a4
+#define PME_PM_MRK_LSU_DERAT_MISS                 0x3d05a
+#define PME_PM_MRK_ST_CMPL                        0x10034
+#define PME_PM_NEST_PAIR3_ADD                     0x40881
+#define PME_PM_L2_ST_DISP                         0x46180
+#define PME_PM_L2_CASTOUT_MOD                     0x16180
+#define PME_PM_ISEG                               0x20a4
+#define PME_PM_MRK_INST_TIMEO                     0x40034
+#define PME_PM_L2_RCST_DISP_FAIL_ADDR             0x36282
+#define PME_PM_LSU1_DC_PREF_STREAM_CONFIRM        0xd0b6
+#define PME_PM_IERAT_WR_64K                       0x40be
+#define PME_PM_MRK_DTLB_MISS_16M                  0x4d05e
+#define PME_PM_IERAT_MISS                         0x100f6
+#define PME_PM_MRK_PTEG_FROM_LMEM                 0x4d052
+#define PME_PM_FLOP                               0x100f4
+#define PME_PM_THRD_PRIO_4_5_CYC                  0x40b4
+#define PME_PM_BR_PRED_TA                         0x40aa
+#define PME_PM_CMPLU_STALL_FXU                    0x20014
+#define PME_PM_EXT_INT                            0x200f8
+#define PME_PM_VSU_FSQRT_FDIV                     0xa888
+#define PME_PM_MRK_LD_MISS_EXPOSED_CYC            0x1003e
+#define PME_PM_LSU1_LDF                           0xc086
+#define PME_PM_IC_WRITE_ALL                       0x488c
+#define PME_PM_LSU0_SRQ_STFWD                     0xc0a0
+#define PME_PM_PTEG_FROM_RL2L3_MOD                0x1c052
+#define PME_PM_MRK_DATA_FROM_L31_SHR              0x1d04e
+#define PME_PM_DATA_FROM_L21_MOD                  0x3c046
+#define PME_PM_VSU1_SCAL_DOUBLE_ISSUED            0xb08a
+#define PME_PM_VSU0_8FLOP                         0xa0a0
+#define PME_PM_POWER_EVENT1                       0x1006e
+#define PME_PM_DISP_CLB_HELD_BAL                  0x2092
+#define PME_PM_VSU1_2FLOP                         0xa09a
+#define PME_PM_LWSYNC_HELD                        0x209a
+#define PME_PM_PTEG_FROM_DL2L3_SHR                0x3c054
+#define PME_PM_INST_FROM_L21_MOD                  0x34046
+#define PME_PM_IERAT_XLATE_WR_16MPLUS             0x40bc
+#define PME_PM_IC_REQ_ALL                         0x4888
+#define PME_PM_DSLB_MISS                          0xd090
+#define PME_PM_L3_MISS                            0x1f082
+#define PME_PM_LSU0_L1_PREF                       0xd0b8
+#define PME_PM_VSU_SCALAR_SINGLE_ISSUED           0xb884
+#define PME_PM_LSU1_DC_PREF_STREAM_CONFIRM_STRIDE 0xd0be
+#define PME_PM_L2_INST                            0x36080
+#define PME_PM_VSU0_FRSP                          0xa0b4
+#define PME_PM_FLUSH_DISP                         0x2082
+#define PME_PM_PTEG_FROM_L2MISS                   0x4c058
+#define PME_PM_VSU1_DQ_ISSUED                     0xb09a
+#define PME_PM_CMPLU_STALL_LSU                    0x20012
+#define PME_PM_MRK_DATA_FROM_DMEM                 0x1d04a
+#define PME_PM_LSU_FLUSH_ULD                      0xc8b0
+#define PME_PM_PTEG_FROM_LMEM                     0x4c052
+#define PME_PM_MRK_DERAT_MISS_16M                 0x3d05c
+#define PME_PM_THRD_ALL_RUN_CYC                   0x2000c
+#define PME_PM_MEM0_PREFETCH_DISP                 0x20083
+#define PME_PM_MRK_STALL_CMPLU_CYC_COUNT          0x3003f
+#define PME_PM_DATA_FROM_DL2L3_MOD                0x3c04c
+#define PME_PM_VSU_FRSP                           0xa8b4
+#define PME_PM_MRK_DATA_FROM_L21_MOD              0x3d046
+#define PME_PM_PMC1_OVERFLOW                      0x20010
+#define PME_PM_VSU0_SINGLE                        0xa0a8
+#define PME_PM_MRK_PTEG_FROM_L3MISS               0x2d058
+#define PME_PM_MRK_PTEG_FROM_L31_SHR              0x2d056
+#define PME_PM_VSU0_VECTOR_SP_ISSUED              0xb090
+#define PME_PM_VSU1_FEST                          0xa0ba
+#define PME_PM_MRK_INST_DISP                      0x20030
+#define PME_PM_VSU0_COMPLEX_ISSUED                0xb096
+#define PME_PM_LSU1_FLUSH_UST                     0xc0b6
+#define PME_PM_INST_CMPL                          0x2
+#define PME_PM_FXU_IDLE                           0x1000e
+#define PME_PM_LSU0_FLUSH_ULD                     0xc0b0
+#define PME_PM_MRK_DATA_FROM_DL2L3_MOD            0x3d04c
+#define PME_PM_LSU_LMQ_SRQ_EMPTY_ALL_CYC          0x3001c
+#define PME_PM_LSU1_REJECT_LMQ_FULL               0xc0a6
+#define PME_PM_INST_PTEG_FROM_L21_MOD             0x3e056
+#define PME_PM_INST_FROM_RL2L3_MOD                0x14042
+#define PME_PM_SHL_CREATED                        0x5082
+#define PME_PM_L2_ST_HIT                          0x46182
+#define PME_PM_DATA_FROM_DMEM                     0x1c04a
+#define PME_PM_L3_LD_MISS                         0x2f082
+#define PME_PM_FXU1_BUSY_FXU0_IDLE                0x4000e
+#define PME_PM_DISP_CLB_HELD_RES                  0x2094
+#define PME_PM_L2_SN_SX_I_DONE                    0x36382
+#define PME_PM_GRP_CMPL                           0x30004
+#define PME_PM_STCX_CMPL                          0xc098
+#define PME_PM_VSU0_2FLOP                         0xa098
+#define PME_PM_L3_PREF_MISS                       0x3f082
+#define PME_PM_LSU_SRQ_SYNC_CYC                   0xd096
+#define PME_PM_LSU_REJECT_ERAT_MISS               0x20064
+#define PME_PM_L1_ICACHE_MISS                     0x200fc
+#define PME_PM_LSU1_FLUSH_SRQ                     0xc0be
+#define PME_PM_LD_REF_L1_LSU0                     0xc080
+#define PME_PM_VSU0_FEST                          0xa0b8
+#define PME_PM_VSU_VECTOR_SINGLE_ISSUED           0xb890
+#define PME_PM_FREQ_UP                            0x4000c
+#define PME_PM_DATA_FROM_LMEM                     0x3c04a
+#define PME_PM_LSU1_LDX                           0xc08a
+#define PME_PM_PMC3_OVERFLOW                      0x40010
+#define PME_PM_MRK_BR_MPRED                       0x30036
+#define PME_PM_SHL_MATCH                          0x5086
+#define PME_PM_MRK_BR_TAKEN                       0x10036
+#define PME_PM_CMPLU_STALL_BRU                    0x4004e
+#define PME_PM_ISLB_MISS                          0xd092
+#define PME_PM_CYC                                0x1e
+#define PME_PM_DISP_HELD_THERMAL                  0x30006
+#define PME_PM_INST_PTEG_FROM_RL2L3_SHR           0x2e054
+#define PME_PM_LSU1_SRQ_STFWD                     0xc0a2
+#define PME_PM_GCT_NOSLOT_BR_MPRED                0x4001a
+#define PME_PM_1PLUS_PPC_CMPL                     0x100f2
+#define PME_PM_PTEG_FROM_DMEM                     0x2c052
+#define PME_PM_VSU_2FLOP                          0xa898
+#define PME_PM_GCT_FULL_CYC                       0x4086
+#define PME_PM_MRK_DATA_FROM_L3_CYC               0x40020
+#define PME_PM_LSU_SRQ_S0_ALLOC                   0xd09d
+#define PME_PM_MRK_DERAT_MISS_4K                  0x1d05c
+#define PME_PM_BR_MPRED_TA                        0x40ae
+#define PME_PM_INST_PTEG_FROM_L2MISS              0x4e058
+#define PME_PM_DPU_HELD_POWER                     0x20006
+#define PME_PM_RUN_INST_CMPL                      0x400fa
+#define PME_PM_MRK_VSU_FIN                        0x30032
+#define PME_PM_LSU_SRQ_S0_VALID                   0xd09c
+#define PME_PM_GCT_EMPTY_CYC                      0x20008
+#define PME_PM_IOPS_DISP                          0x30014
+#define PME_PM_RUN_SPURR                          0x10008
+#define PME_PM_PTEG_FROM_L21_MOD                  0x3c056
+#define PME_PM_VSU0_1FLOP                         0xa080
+#define PME_PM_SNOOP_TLBIE                        0xd0b2
+#define PME_PM_DATA_FROM_L3MISS                   0x2c048
+#define PME_PM_VSU_SINGLE                         0xa8a8
+#define PME_PM_DTLB_MISS_16G                      0x1c05e
+#define PME_PM_CMPLU_STALL_VECTOR                 0x2001c
+#define PME_PM_FLUSH                              0x400f8
+#define PME_PM_L2_LD_HIT                          0x36182
+#define PME_PM_NEST_PAIR2_AND                     0x30883
+#define PME_PM_VSU1_1FLOP                         0xa082
+#define PME_PM_IC_PREF_REQ                        0x408a
+#define PME_PM_L3_LD_HIT                          0x2f080
+#define PME_PM_GCT_NOSLOT_IC_MISS                 0x2001a
+#define PME_PM_DISP_HELD                          0x10006
+#define PME_PM_L2_LD                              0x16080
+#define PME_PM_LSU_FLUSH_SRQ                      0xc8bc
+#define PME_PM_BC_PLUS_8_CONV                     0x40b8
+#define PME_PM_MRK_DATA_FROM_L31_MOD_CYC          0x40026
+#define PME_PM_CMPLU_STALL_VECTOR_LONG            0x4004a
+#define PME_PM_L2_RCST_BUSY_RC_FULL               0x26282
+#define PME_PM_TB_BIT_TRANS                       0x300f8
+#define PME_PM_THERMAL_MAX                        0x40006
+#define PME_PM_LSU1_FLUSH_ULD                     0xc0b2
+#define PME_PM_LSU1_REJECT_LHS                    0xc0ae
+#define PME_PM_LSU_LRQ_S0_ALLOC                   0xd09f
+#define PME_PM_L3_CO_L31                          0x4f080
+#define PME_PM_POWER_EVENT4                       0x4006e
+#define PME_PM_DATA_FROM_L31_SHR                  0x1c04e
+#define PME_PM_BR_UNCOND                          0x409e
+#define PME_PM_LSU1_DC_PREF_STREAM_ALLOC          0xd0aa
+#define PME_PM_PMC4_REWIND                        0x10020
+#define PME_PM_L2_RCLD_DISP                       0x16280
+#define PME_PM_THRD_PRIO_2_3_CYC                  0x40b2
+#define PME_PM_MRK_PTEG_FROM_L2MISS               0x4d058
+#define PME_PM_IC_DEMAND_L2_BHT_REDIRECT          0x4098
+#define PME_PM_LSU_DERAT_MISS                     0x200f6
+#define PME_PM_IC_PREF_CANCEL_L2                  0x4094
+#define PME_PM_MRK_FIN_STALL_CYC_COUNT            0x1003d
+#define PME_PM_BR_PRED_CCACHE                     0x40a0
+#define PME_PM_GCT_UTIL_1_TO_2_SLOTS              0x209c
+#define PME_PM_MRK_ST_CMPL_INT                    0x30034
+#define PME_PM_LSU_TWO_TABLEWALK_CYC              0xd0a6
+#define PME_PM_MRK_DATA_FROM_L3MISS               0x2d048
+#define PME_PM_GCT_NOSLOT_CYC                     0x100f8
+#define PME_PM_LSU_SET_MPRED                      0xc0a8
+#define PME_PM_FLUSH_DISP_TLBIE                   0x208a
+#define PME_PM_VSU1_FCONV                         0xa0b2
+#define PME_PM_DERAT_MISS_16G                     0x4c05c
+#define PME_PM_INST_FROM_LMEM                     0x3404a
+#define PME_PM_IC_DEMAND_L2_BR_REDIRECT           0x409a
+#define PME_PM_CMPLU_STALL_SCALAR_LONG            0x20018
+#define PME_PM_INST_PTEG_FROM_L2                  0x1e050
+#define PME_PM_PTEG_FROM_L2                       0x1c050
+#define PME_PM_MRK_DATA_FROM_L21_SHR_CYC          0x20024
+#define PME_PM_MRK_DTLB_MISS_4K                   0x2d05a
+#define PME_PM_VSU0_FPSCR                         0xb09c
+#define PME_PM_VSU1_VECT_DOUBLE_ISSUED            0xb082
+#define PME_PM_MRK_PTEG_FROM_RL2L3_MOD            0x1d052
+#define PME_PM_MEM0_RQ_DISP                       0x10083
+#define PME_PM_L2_LD_MISS                         0x26080
+#define PME_PM_VMX_RESULT_SAT_1                   0xb0a0
+#define PME_PM_L1_PREF                            0xd8b8
+#define PME_PM_MRK_DATA_FROM_LMEM_CYC             0x2002c
+#define PME_PM_GRP_IC_MISS_NONSPEC                0x1000c
+#define PME_PM_PB_NODE_PUMP                       0x10081
+#define PME_PM_SHL_MERGED                         0x5084
+#define PME_PM_NEST_PAIR1_ADD                     0x20881
+#define PME_PM_DATA_FROM_L3                       0x1c048
+#define PME_PM_LSU_FLUSH                          0x208e
+#define PME_PM_LSU_SRQ_SYNC_COUNT                 0xd097
+#define PME_PM_PMC2_OVERFLOW                      0x30010
+#define PME_PM_LSU_LDF                            0xc884
+#define PME_PM_POWER_EVENT3                       0x3006e
+#define PME_PM_DISP_WT                            0x30008
+#define PME_PM_CMPLU_STALL_REJECT                 0x40016
+#define PME_PM_IC_BANK_CONFLICT                   0x4082
+#define PME_PM_BR_MPRED_CR_TA                     0x48ae
+#define PME_PM_L2_INST_MISS                       0x36082
+#define PME_PM_CMPLU_STALL_ERAT_MISS              0x40018
+#define PME_PM_NEST_PAIR2_ADD                     0x30881
+#define PME_PM_MRK_LSU_FLUSH                      0xd08c
+#define PME_PM_L2_LDST                            0x16880
+#define PME_PM_INST_FROM_L31_SHR                  0x1404e
+#define PME_PM_VSU0_FIN                           0xa0bc
+#define PME_PM_LARX_LSU                           0xc894
+#define PME_PM_INST_FROM_RMEM                     0x34042
+#define PME_PM_DISP_CLB_HELD_TLBIE                0x2096
+#define PME_PM_MRK_DATA_FROM_DMEM_CYC             0x2002e
+#define PME_PM_BR_PRED_CR                         0x40a8
+#define PME_PM_LSU_REJECT                         0x10064
+#define PME_PM_GCT_UTIL_3_TO_6_SLOTS              0x209e
+#define PME_PM_CMPLU_STALL_END_GCT_NOSLOT         0x10028
+#define PME_PM_LSU0_REJECT_LMQ_FULL               0xc0a4
+#define PME_PM_VSU_FEST                           0xa8b8
+#define PME_PM_NEST_PAIR0_AND                     0x10883
+#define PME_PM_PTEG_FROM_L3                       0x2c050
+#define PME_PM_POWER_EVENT2                       0x2006e
+#define PME_PM_IC_PREF_CANCEL_PAGE                0x4090
+#define PME_PM_VSU0_FSQRT_FDIV                    0xa088
+#define PME_PM_MRK_GRP_CMPL                       0x40030
+#define PME_PM_VSU0_SCAL_DOUBLE_ISSUED            0xb088
+#define PME_PM_GRP_DISP                           0x3000a
+#define PME_PM_LSU0_LDX                           0xc088
+#define PME_PM_DATA_FROM_L2                       0x1c040
+#define PME_PM_MRK_DATA_FROM_RL2L3_MOD            0x1d042
+#define PME_PM_LD_REF_L1                          0xc880
+#define PME_PM_VSU0_VECT_DOUBLE_ISSUED            0xb080
+#define PME_PM_VSU1_2FLOP_DOUBLE                  0xa08e
+#define PME_PM_THRD_PRIO_6_7_CYC                  0x40b6
+#define PME_PM_BC_PLUS_8_RSLV_TAKEN               0x40ba
+#define PME_PM_BR_MPRED_CR                        0x40ac
+#define PME_PM_L3_CO_MEM                          0x4f082
+#define PME_PM_LD_MISS_L1                         0x400f0
+#define PME_PM_DATA_FROM_RL2L3_MOD                0x1c042
+#define PME_PM_LSU_SRQ_FULL_CYC                   0x1001a
+#define PME_PM_TABLEWALK_CYC                      0x10026
+#define PME_PM_MRK_PTEG_FROM_RMEM                 0x3d052
+#define PME_PM_LSU_SRQ_STFWD                      0xc8a0
+#define PME_PM_INST_PTEG_FROM_RMEM                0x3e052
+#define PME_PM_FXU0_FIN                           0x10004
+#define PME_PM_LSU1_L1_SW_PREF                    0xc09e
+#define PME_PM_PTEG_FROM_L31_MOD                  0x1c054
+#define PME_PM_PMC5_OVERFLOW                      0x10024
+#define PME_PM_LD_REF_L1_LSU1                     0xc082
+#define PME_PM_INST_PTEG_FROM_L21_SHR             0x4e056
+#define PME_PM_CMPLU_STALL_THRD                   0x1001c
+#define PME_PM_DATA_FROM_RMEM                     0x3c042
+#define PME_PM_VSU0_SCAL_SINGLE_ISSUED            0xb084
+#define PME_PM_BR_MPRED_LSTACK                    0x40a6
+#define PME_PM_MRK_DATA_FROM_RL2L3_MOD_CYC        0x40028
+#define PME_PM_LSU0_FLUSH_UST                     0xc0b4
+#define PME_PM_LSU_NCST                           0xc090
+#define PME_PM_BR_TAKEN                           0x20004
+#define PME_PM_INST_PTEG_FROM_LMEM                0x4e052
+#define PME_PM_GCT_NOSLOT_BR_MPRED_IC_MISS        0x4001c
+#define PME_PM_DTLB_MISS_4K                       0x2c05a
+#define PME_PM_PMC4_SAVED                         0x30022
+#define PME_PM_VSU1_PERMUTE_ISSUED                0xb092
+#define PME_PM_SLB_MISS                           0xd890
+#define PME_PM_LSU1_FLUSH_LRQ                     0xc0ba
+#define PME_PM_DTLB_MISS                          0x300fc
+#define PME_PM_VSU1_FRSP                          0xa0b6
+#define PME_PM_VSU_VECTOR_DOUBLE_ISSUED           0xb880
+#define PME_PM_L2_CASTOUT_SHR                     0x16182
+#define PME_PM_DATA_FROM_DL2L3_SHR                0x3c044
+#define PME_PM_VSU1_STF                           0xb08e
+#define PME_PM_ST_FIN                             0x200f0
+#define PME_PM_PTEG_FROM_L21_SHR                  0x4c056
+#define PME_PM_L2_LOC_GUESS_WRONG                 0x26480
+#define PME_PM_MRK_STCX_FAIL                      0xd08e
+#define PME_PM_LSU0_REJECT_LHS                    0xc0ac
+#define PME_PM_IC_PREF_CANCEL_HIT                 0x4092
+#define PME_PM_L3_PREF_BUSY                       0x4f080
+#define PME_PM_MRK_BRU_FIN                        0x2003a
+#define PME_PM_LSU1_NCLD                          0xc08e
+#define PME_PM_INST_PTEG_FROM_L31_MOD             0x1e054
+#define PME_PM_LSU_NCLD                           0xc88c
+#define PME_PM_LSU_LDX                            0xc888
+#define PME_PM_L2_LOC_GUESS_CORRECT               0x16480
+#define PME_PM_THRESH_TIMEO                       0x10038
+#define PME_PM_L3_PREF_ST                         0xd0ae
+#define PME_PM_DISP_CLB_HELD_SYNC                 0x2098
+#define PME_PM_VSU_SIMPLE_ISSUED                  0xb894
+#define PME_PM_VSU1_SINGLE                        0xa0aa
+#define PME_PM_DATA_TABLEWALK_CYC                 0x3001a
+#define PME_PM_L2_RC_ST_DONE                      0x36380
+#define PME_PM_MRK_PTEG_FROM_L21_MOD              0x3d056
+#define PME_PM_LARX_LSU1                          0xc096
+#define PME_PM_MRK_DATA_FROM_RMEM                 0x3d042
+#define PME_PM_DISP_CLB_HELD                      0x2090
+#define PME_PM_DERAT_MISS_4K                      0x1c05c
+#define PME_PM_L2_RCLD_DISP_FAIL_ADDR             0x16282
+#define PME_PM_SEG_EXCEPTION                      0x28a4
+#define PME_PM_FLUSH_DISP_SB                      0x208c
+#define PME_PM_L2_DC_INV                          0x26182
+#define PME_PM_PTEG_FROM_DL2L3_MOD                0x4c054
+#define PME_PM_DSEG                               0x20a6
+#define PME_PM_BR_PRED_LSTACK                     0x40a2
+#define PME_PM_VSU0_STF                           0xb08c
+#define PME_PM_LSU_FX_FIN                         0x10066
+#define PME_PM_DERAT_MISS_16M                     0x3c05c
+#define PME_PM_MRK_PTEG_FROM_DL2L3_MOD            0x4d054
+#define PME_PM_GCT_UTIL_11_PLUS_SLOTS             0x20a2
+#define PME_PM_INST_FROM_L3                       0x14048
+#define PME_PM_MRK_IFU_FIN                        0x3003a
+#define PME_PM_ITLB_MISS                          0x400fc
+#define PME_PM_VSU_STF                            0xb88c
+#define PME_PM_LSU_FLUSH_UST                      0xc8b4
+#define PME_PM_L2_LDST_MISS                       0x26880
+#define PME_PM_FXU1_FIN                           0x40004
+#define PME_PM_SHL_DEALLOCATED                    0x5080
+#define PME_PM_L2_SN_M_WR_DONE                    0x46382
+#define PME_PM_LSU_REJECT_SET_MPRED               0xc8a8
+#define PME_PM_L3_PREF_LD                         0xd0ac
+#define PME_PM_L2_SN_M_RD_DONE                    0x46380
+#define PME_PM_MRK_DERAT_MISS_16G                 0x4d05c
+#define PME_PM_VSU_FCONV                          0xa8b0
+#define PME_PM_ANY_THRD_RUN_CYC                   0x100fa
+#define PME_PM_LSU_LMQ_FULL_CYC                   0xd0a4
+#define PME_PM_MRK_LSU_REJECT_LHS                 0xd082
+#define PME_PM_MRK_LD_MISS_L1_CYC                 0x4003e
+#define PME_PM_MRK_DATA_FROM_L2_CYC               0x20020
+#define PME_PM_INST_IMC_MATCH_DISP                0x30016
+#define PME_PM_MRK_DATA_FROM_RMEM_CYC             0x4002c
+#define PME_PM_VSU0_SIMPLE_ISSUED                 0xb094
+#define PME_PM_CMPLU_STALL_DIV                    0x40014
+#define PME_PM_MRK_PTEG_FROM_RL2L3_SHR            0x2d054
+#define PME_PM_VSU_FMA_DOUBLE                     0xa890
+#define PME_PM_VSU_4FLOP                          0xa89c
+#define PME_PM_VSU1_FIN                           0xa0be
+#define PME_PM_NEST_PAIR1_AND                     0x20883
+#define PME_PM_INST_PTEG_FROM_RL2L3_MOD           0x1e052
+#define PME_PM_RUN_CYC                            0x200f4
+#define PME_PM_PTEG_FROM_RMEM                     0x3c052
+#define PME_PM_LSU_LRQ_S0_VALID                   0xd09e
+#define PME_PM_LSU0_LDF                           0xc084
+#define PME_PM_FLUSH_COMPLETION                   0x30012
+#define PME_PM_ST_MISS_L1                         0x300f0
+#define PME_PM_L2_NODE_PUMP                       0x36480
+#define PME_PM_INST_FROM_DL2L3_SHR                0x34044
+#define PME_PM_MRK_STALL_CMPLU_CYC                0x3003e
+#define PME_PM_VSU1_DENORM                        0xa0ae
+#define PME_PM_MRK_DATA_FROM_L31_SHR_CYC          0x20026
+#define PME_PM_NEST_PAIR0_ADD                     0x10881
+#define PME_PM_INST_FROM_L3MISS                   0x24048
+#define PME_PM_EE_OFF_EXT_INT                     0x2080
+#define PME_PM_INST_PTEG_FROM_DMEM                0x2e052
+#define PME_PM_INST_FROM_DL2L3_MOD                0x3404c
+#define PME_PM_PMC6_OVERFLOW                      0x30024
+#define PME_PM_VSU_2FLOP_DOUBLE                   0xa88c
+#define PME_PM_TLB_MISS                           0x20066
+#define PME_PM_FXU_BUSY                           0x2000e
+#define PME_PM_L2_RCLD_DISP_FAIL_OTHER            0x26280
+#define PME_PM_LSU_REJECT_LMQ_FULL                0xc8a4
+#define PME_PM_IC_RELOAD_SHR                      0x4096
+#define PME_PM_GRP_MRK                            0x10031
+#define PME_PM_MRK_ST_NEST                        0x20034
+#define PME_PM_VSU1_FSQRT_FDIV                    0xa08a
+#define PME_PM_LSU0_FLUSH_LRQ                     0xc0b8
+#define PME_PM_LARX_LSU0                          0xc094
+#define PME_PM_IBUF_FULL_CYC                      0x4084
+#define PME_PM_MRK_DATA_FROM_DL2L3_SHR_CYC        0x2002a
+#define PME_PM_LSU_DC_PREF_STREAM_ALLOC           0xd8a8
+#define PME_PM_GRP_MRK_CYC                        0x10030
+#define PME_PM_MRK_DATA_FROM_RL2L3_SHR_CYC        0x20028
+#define PME_PM_L2_GLOB_GUESS_CORRECT              0x16482
+#define PME_PM_LSU_REJECT_LHS                     0xc8ac
+#define PME_PM_MRK_DATA_FROM_LMEM                 0x3d04a
+#define PME_PM_INST_PTEG_FROM_L3                  0x2e050
+#define PME_PM_FREQ_DOWN                          0x3000c
+#define PME_PM_PB_RETRY_NODE_PUMP                 0x30081
+#define PME_PM_INST_FROM_RL2L3_SHR                0x1404c
+#define PME_PM_MRK_INST_ISSUED                    0x10032
+#define PME_PM_PTEG_FROM_L3MISS                   0x2c058
+#define PME_PM_RUN_PURR                           0x400f4
+#define PME_PM_MRK_GRP_IC_MISS                    0x40038
+#define PME_PM_MRK_DATA_FROM_L3                   0x1d048
+#define PME_PM_CMPLU_STALL_DCACHE_MISS            0x20016
+#define PME_PM_PTEG_FROM_RL2L3_SHR                0x2c054
+#define PME_PM_LSU_FLUSH_LRQ                      0xc8b8
+#define PME_PM_MRK_DERAT_MISS_64K                 0x2d05c
+#define PME_PM_INST_PTEG_FROM_DL2L3_MOD           0x4e054
+#define PME_PM_L2_ST_MISS                         0x26082
+#define PME_PM_MRK_PTEG_FROM_L21_SHR              0x4d056
+#undef  LWSYNC
+#define PME_PM_LWSYNC                             0xd094
+#define PME_PM_LSU0_DC_PREF_STREAM_CONFIRM_STRIDE 0xd0bc
+#define PME_PM_MRK_LSU_FLUSH_LRQ                  0xd088
+#define PME_PM_INST_IMC_MATCH_CMPL                0x100f0
+#define PME_PM_NEST_PAIR3_AND                     0x40883
+#define PME_PM_PB_RETRY_SYS_PUMP                  0x40081
+#define PME_PM_MRK_INST_FIN                       0x30030
+#define PME_PM_MRK_PTEG_FROM_DL2L3_SHR            0x3d054
+#define PME_PM_INST_FROM_L31_MOD                  0x14044
+#define PME_PM_MRK_DTLB_MISS_64K                  0x3d05e
+#define PME_PM_LSU_FIN                            0x30066
+#define PME_PM_MRK_LSU_REJECT                     0x40064
+#define PME_PM_L2_CO_FAIL_BUSY                    0x16382
+#define PME_PM_MEM0_WQ_DISP                       0x40083
+#define PME_PM_DATA_FROM_L31_MOD                  0x1c044
+#define PME_PM_THERMAL_WARN                       0x10016
+#define PME_PM_VSU0_4FLOP                         0xa09c
+#define PME_PM_BR_MPRED_CCACHE                    0x40a4
+#define PME_PM_CMPLU_STALL_IFU                    0x4004c
+#define PME_PM_L1_DEMAND_WRITE                    0x408c
+#define PME_PM_FLUSH_BR_MPRED                     0x2084
+#define PME_PM_MRK_DTLB_MISS_16G                  0x1d05e
+#define PME_PM_MRK_PTEG_FROM_DMEM                 0x2d052
+#define PME_PM_L2_RCST_DISP                       0x36280
+#define PME_PM_CMPLU_STALL                        0x4000a
+#define PME_PM_LSU_PARTIAL_CDF                    0xc0aa
+#define PME_PM_DISP_CLB_HELD_SB                   0x20a8
+#define PME_PM_VSU0_FMA_DOUBLE                    0xa090
+#define PME_PM_FXU0_BUSY_FXU1_IDLE                0x3000e
+#define PME_PM_IC_DEMAND_CYC                      0x10018
+#define PME_PM_MRK_DATA_FROM_L21_SHR              0x3d04e
+#define PME_PM_MRK_LSU_FLUSH_UST                  0xd086
+#define PME_PM_INST_PTEG_FROM_L3MISS              0x2e058
+#define PME_PM_VSU_DENORM                         0xa8ac
+#define PME_PM_MRK_LSU_PARTIAL_CDF                0xd080
+#define PME_PM_INST_FROM_L21_SHR                  0x3404e
+#define PME_PM_IC_PREF_WRITE                      0x408e
+#define PME_PM_BR_PRED                            0x409c
+#define PME_PM_INST_FROM_DMEM                     0x1404a
+#define PME_PM_IC_PREF_CANCEL_ALL                 0x4890
+#define PME_PM_LSU_DC_PREF_STREAM_CONFIRM         0xd8b4
+#define PME_PM_MRK_LSU_FLUSH_SRQ                  0xd08a
+#define PME_PM_MRK_FIN_STALL_CYC                  0x1003c
+#define PME_PM_L2_RCST_DISP_FAIL_OTHER            0x46280
+#define PME_PM_VSU1_DD_ISSUED                     0xb098
+#define PME_PM_PTEG_FROM_L31_SHR                  0x2c056
+#define PME_PM_DATA_FROM_L21_SHR                  0x3c04e
+#define PME_PM_LSU0_NCLD                          0xc08c
+#define PME_PM_VSU1_4FLOP                         0xa09e
+#define PME_PM_VSU1_8FLOP                         0xa0a2
+#define PME_PM_VSU_8FLOP                          0xa8a0
+#define PME_PM_LSU_LMQ_SRQ_EMPTY_CYC              0x2003e
+#define PME_PM_DTLB_MISS_64K                      0x3c05e
+#define PME_PM_THRD_CONC_RUN_INST                 0x300f4
+#define PME_PM_MRK_PTEG_FROM_L2                   0x1d050
+#define PME_PM_PB_SYS_PUMP                        0x20081
+#define PME_PM_VSU_FIN                            0xa8bc
+#define PME_PM_MRK_DATA_FROM_L31_MOD              0x1d044
+#define PME_PM_THRD_PRIO_0_1_CYC                  0x40b0
+#define PME_PM_DERAT_MISS_64K                     0x2c05c
+#define PME_PM_PMC2_REWIND                        0x30020
+#define PME_PM_INST_FROM_L2                       0x14040
+#define PME_PM_GRP_BR_MPRED_NONSPEC               0x1000a
+#define PME_PM_INST_DISP                          0x200f2
+#define PME_PM_MEM0_RD_CANCEL_TOTAL               0x30083
+#define PME_PM_LSU0_DC_PREF_STREAM_CONFIRM        0xd0b4
+#define PME_PM_L1_DCACHE_RELOAD_VALID             0x300f6
+#define PME_PM_VSU_SCALAR_DOUBLE_ISSUED           0xb888
+#define PME_PM_L3_PREF_HIT                        0x3f080
+#define PME_PM_MRK_PTEG_FROM_L31_MOD              0x1d054
+#define PME_PM_CMPLU_STALL_STORE                  0x2004a
+#define PME_PM_MRK_FXU_FIN                        0x20038
+#define PME_PM_PMC4_OVERFLOW                      0x10010
+#define PME_PM_MRK_PTEG_FROM_L3                   0x2d050
+#define PME_PM_LSU0_LMQ_LHR_MERGE                 0xd098
+#define PME_PM_BTAC_HIT                           0x508a
+#define PME_PM_L3_RD_BUSY                         0x4f082
+#define PME_PM_LSU0_L1_SW_PREF                    0xc09c
+#define PME_PM_INST_FROM_L2MISS                   0x44048
+#define PME_PM_LSU0_DC_PREF_STREAM_ALLOC          0xd0a8
+#define PME_PM_L2_ST                              0x16082
+#define PME_PM_VSU0_DENORM                        0xa0ac
+#define PME_PM_MRK_DATA_FROM_DL2L3_SHR            0x3d044
+#define PME_PM_BR_PRED_CR_TA                      0x48aa
+#define PME_PM_VSU0_FCONV                         0xa0b0
+#define PME_PM_MRK_LSU_FLUSH_ULD                  0xd084
+#define PME_PM_BTAC_MISS                          0x5088
+#define PME_PM_MRK_LD_MISS_EXPOSED_CYC_COUNT      0x1003f
+#define PME_PM_MRK_DATA_FROM_L2                   0x1d040
+#define PME_PM_LSU_DCACHE_RELOAD_VALID            0xd0a2
+#define PME_PM_VSU_FMA                            0xa884
+#define PME_PM_LSU0_FLUSH_SRQ                     0xc0bc
+#define PME_PM_LSU1_L1_PREF                       0xd0ba
+#define PME_PM_IOPS_CMPL                          0x10014
+#define PME_PM_L2_SYS_PUMP                        0x36482
+#define PME_PM_L2_RCLD_BUSY_RC_FULL               0x46282
+#define PME_PM_LSU_LMQ_S0_ALLOC                   0xd0a1
+#define PME_PM_FLUSH_DISP_SYNC                    0x2088
+#define PME_PM_MRK_DATA_FROM_DL2L3_MOD_CYC        0x4002a
+#define PME_PM_L2_IC_INV                          0x26180
+#define PME_PM_MRK_DATA_FROM_L21_MOD_CYC          0x40024
+#define PME_PM_L3_PREF_LDST                       0xd8ac
+#define PME_PM_LSU_SRQ_EMPTY_CYC                  0x40008
+#define PME_PM_LSU_LMQ_S0_VALID                   0xd0a0
+#define PME_PM_FLUSH_PARTIAL                      0x2086
+#define PME_PM_VSU1_FMA_DOUBLE                    0xa092
+#define PME_PM_1PLUS_PPC_DISP                     0x400f2
+#define PME_PM_DATA_FROM_L2MISS                   0x200fe
+#define PME_PM_SUSPENDED                          0x0
+#define PME_PM_VSU0_FMA                           0xa084
+#define PME_PM_CMPLU_STALL_SCALAR                 0x40012
+#define PME_PM_STCX_FAIL                          0xc09a
+#define PME_PM_VSU0_FSQRT_FDIV_DOUBLE             0xa094
+#define PME_PM_DC_PREF_DST                        0xd0b0
+#define PME_PM_VSU1_SCAL_SINGLE_ISSUED            0xb086
+#define PME_PM_L3_HIT                             0x1f080
+#define PME_PM_L2_GLOB_GUESS_WRONG                0x26482
+#define PME_PM_MRK_DFU_FIN                        0x20032
+#define PME_PM_INST_FROM_L1                       0x4080
+#define PME_PM_BRU_FIN                            0x10068
+#define PME_PM_IC_DEMAND_REQ                      0x4088
+#define PME_PM_VSU1_FSQRT_FDIV_DOUBLE             0xa096
+#define PME_PM_VSU1_FMA                           0xa086
+#define PME_PM_MRK_LD_MISS_L1                     0x20036
+#define PME_PM_VSU0_2FLOP_DOUBLE                  0xa08c
+#define PME_PM_LSU_DC_PREF_STRIDED_STREAM_CONFIRM 0xd8bc
+#define PME_PM_INST_PTEG_FROM_L31_SHR             0x2e056
+#define PME_PM_MRK_LSU_REJECT_ERAT_MISS           0x30064
+#define PME_PM_MRK_DATA_FROM_L2MISS               0x4d048
+#define PME_PM_DATA_FROM_RL2L3_SHR                0x1c04c
+#define PME_PM_INST_FROM_PREF                     0x14046
+#define PME_PM_VSU1_SQ                            0xb09e
+#define PME_PM_L2_LD_DISP                         0x36180
+#define PME_PM_L2_DISP_ALL                        0x46080
+#define PME_PM_THRD_GRP_CMPL_BOTH_CYC             0x10012
+#define PME_PM_VSU_FSQRT_FDIV_DOUBLE              0xa894
+#define PME_PM_BR_MPRED                           0x400f6
+#define PME_PM_INST_PTEG_FROM_DL2L3_SHR           0x3e054
+#define PME_PM_VSU_1FLOP                          0xa880
+#define PME_PM_HV_CYC                             0x2000a
+#define PME_PM_MRK_LSU_FIN                        0x40032
+#define PME_PM_MRK_DATA_FROM_RL2L3_SHR            0x1d04c
+#define PME_PM_DTLB_MISS_16M                      0x4c05e
+#define PME_PM_LSU1_LMQ_LHR_MERGE                 0xd09a
+#define PME_PM_IFU_FIN                            0x40066
 
 /*
  * Layout of constraint bits:
@@ -407,39 +914,547 @@ GENERIC_EVENT_ATTR(cache-misses,		LD_MISS_L1);
 GENERIC_EVENT_ATTR(branch-instructions,		BRU_FIN);
 GENERIC_EVENT_ATTR(branch-misses,		BR_MPRED);
 
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
+POWER_EVENT_ATTR(IC_DEMAND_L2_BR_ALL,          IC_DEMAND_L2_BR_ALL);
+POWER_EVENT_ATTR(GCT_UTIL_7_TO_10_SLOTS,       GCT_UTIL_7_TO_10_SLOTS);
+POWER_EVENT_ATTR(PMC2_SAVED,                   PMC2_SAVED);
+POWER_EVENT_ATTR(CMPLU_STALL_DFU,              CMPLU_STALL_DFU);
+POWER_EVENT_ATTR(VSU0_16FLOP,                  VSU0_16FLOP);
+POWER_EVENT_ATTR(MRK_LSU_DERAT_MISS,           MRK_LSU_DERAT_MISS);
+POWER_EVENT_ATTR(MRK_ST_CMPL,                  MRK_ST_CMPL);
+POWER_EVENT_ATTR(NEST_PAIR3_ADD,               NEST_PAIR3_ADD);
+POWER_EVENT_ATTR(L2_ST_DISP,                   L2_ST_DISP);
+POWER_EVENT_ATTR(L2_CASTOUT_MOD,               L2_CASTOUT_MOD);
+POWER_EVENT_ATTR(ISEG,                         ISEG);
+POWER_EVENT_ATTR(MRK_INST_TIMEO,               MRK_INST_TIMEO);
+POWER_EVENT_ATTR(L2_RCST_DISP_FAIL_ADDR,       L2_RCST_DISP_FAIL_ADDR);
+POWER_EVENT_ATTR(LSU1_DC_PREF_STREAM_CONFIRM,  LSU1_DC_PREF_STREAM_CONFIRM);
+POWER_EVENT_ATTR(IERAT_WR_64K,                 IERAT_WR_64K);
+POWER_EVENT_ATTR(MRK_DTLB_MISS_16M,            MRK_DTLB_MISS_16M);
+POWER_EVENT_ATTR(IERAT_MISS,                   IERAT_MISS);
+POWER_EVENT_ATTR(MRK_PTEG_FROM_LMEM,           MRK_PTEG_FROM_LMEM);
+POWER_EVENT_ATTR(FLOP,                         FLOP);
+POWER_EVENT_ATTR(THRD_PRIO_4_5_CYC,            THRD_PRIO_4_5_CYC);
+POWER_EVENT_ATTR(BR_PRED_TA,                   BR_PRED_TA);
+POWER_EVENT_ATTR(CMPLU_STALL_FXU,              CMPLU_STALL_FXU);
+POWER_EVENT_ATTR(EXT_INT,                      EXT_INT);
+POWER_EVENT_ATTR(VSU_FSQRT_FDIV,               VSU_FSQRT_FDIV);
+POWER_EVENT_ATTR(MRK_LD_MISS_EXPOSED_CYC,      MRK_LD_MISS_EXPOSED_CYC);
+POWER_EVENT_ATTR(LSU1_LDF,                     LSU1_LDF);
+POWER_EVENT_ATTR(IC_WRITE_ALL,                 IC_WRITE_ALL);
+POWER_EVENT_ATTR(LSU0_SRQ_STFWD,               LSU0_SRQ_STFWD);
+POWER_EVENT_ATTR(PTEG_FROM_RL2L3_MOD,          PTEG_FROM_RL2L3_MOD);
+POWER_EVENT_ATTR(MRK_DATA_FROM_L31_SHR,        MRK_DATA_FROM_L31_SHR);
+POWER_EVENT_ATTR(DATA_FROM_L21_MOD,            DATA_FROM_L21_MOD);
+POWER_EVENT_ATTR(VSU1_SCAL_DOUBLE_ISSUED,      VSU1_SCAL_DOUBLE_ISSUED);
+POWER_EVENT_ATTR(VSU0_8FLOP,                   VSU0_8FLOP);
+POWER_EVENT_ATTR(POWER_EVENT1,                 POWER_EVENT1);
+POWER_EVENT_ATTR(DISP_CLB_HELD_BAL,            DISP_CLB_HELD_BAL);
+POWER_EVENT_ATTR(VSU1_2FLOP,                   VSU1_2FLOP);
+POWER_EVENT_ATTR(LWSYNC_HELD,                  LWSYNC_HELD);
+POWER_EVENT_ATTR(PTEG_FROM_DL2L3_SHR,          PTEG_FROM_DL2L3_SHR);
+POWER_EVENT_ATTR(INST_FROM_L21_MOD,            INST_FROM_L21_MOD);
+POWER_EVENT_ATTR(IERAT_XLATE_WR_16MPLUS,       IERAT_XLATE_WR_16MPLUS);
+POWER_EVENT_ATTR(IC_REQ_ALL,                   IC_REQ_ALL);
+POWER_EVENT_ATTR(DSLB_MISS,                    DSLB_MISS);
+POWER_EVENT_ATTR(L3_MISS,                      L3_MISS);
+POWER_EVENT_ATTR(LSU0_L1_PREF,                 LSU0_L1_PREF);
+POWER_EVENT_ATTR(VSU_SCALAR_SINGLE_ISSUED,     VSU_SCALAR_SINGLE_ISSUED);
+POWER_EVENT_ATTR(LSU1_DC_PREF_STREAM_CONFIRM_STRIDE,
+		 LSU1_DC_PREF_STREAM_CONFIRM_STRIDE);
+POWER_EVENT_ATTR(L2_INST,                      L2_INST);
+POWER_EVENT_ATTR(VSU0_FRSP,                    VSU0_FRSP);
+POWER_EVENT_ATTR(FLUSH_DISP,                   FLUSH_DISP);
+POWER_EVENT_ATTR(PTEG_FROM_L2MISS,             PTEG_FROM_L2MISS);
+POWER_EVENT_ATTR(VSU1_DQ_ISSUED,               VSU1_DQ_ISSUED);
+POWER_EVENT_ATTR(CMPLU_STALL_LSU,              CMPLU_STALL_LSU);
+POWER_EVENT_ATTR(MRK_DATA_FROM_DMEM,           MRK_DATA_FROM_DMEM);
+POWER_EVENT_ATTR(LSU_FLUSH_ULD,                LSU_FLUSH_ULD);
+POWER_EVENT_ATTR(PTEG_FROM_LMEM,               PTEG_FROM_LMEM);
+POWER_EVENT_ATTR(MRK_DERAT_MISS_16M,           MRK_DERAT_MISS_16M);
+POWER_EVENT_ATTR(THRD_ALL_RUN_CYC,             THRD_ALL_RUN_CYC);
+POWER_EVENT_ATTR(MEM0_PREFETCH_DISP,           MEM0_PREFETCH_DISP);
+POWER_EVENT_ATTR(MRK_STALL_CMPLU_CYC_COUNT,    MRK_STALL_CMPLU_CYC_COUNT);
+POWER_EVENT_ATTR(DATA_FROM_DL2L3_MOD,          DATA_FROM_DL2L3_MOD);
+POWER_EVENT_ATTR(VSU_FRSP,                     VSU_FRSP);
+POWER_EVENT_ATTR(MRK_DATA_FROM_L21_MOD,        MRK_DATA_FROM_L21_MOD);
+POWER_EVENT_ATTR(PMC1_OVERFLOW,                PMC1_OVERFLOW);
+POWER_EVENT_ATTR(VSU0_SINGLE,                  VSU0_SINGLE);
+POWER_EVENT_ATTR(MRK_PTEG_FROM_L3MISS,         MRK_PTEG_FROM_L3MISS);
+POWER_EVENT_ATTR(MRK_PTEG_FROM_L31_SHR,        MRK_PTEG_FROM_L31_SHR);
+POWER_EVENT_ATTR(VSU0_VECTOR_SP_ISSUED,        VSU0_VECTOR_SP_ISSUED);
+POWER_EVENT_ATTR(VSU1_FEST,                    VSU1_FEST);
+POWER_EVENT_ATTR(MRK_INST_DISP,                MRK_INST_DISP);
+POWER_EVENT_ATTR(VSU0_COMPLEX_ISSUED,          VSU0_COMPLEX_ISSUED);
+POWER_EVENT_ATTR(LSU1_FLUSH_UST,               LSU1_FLUSH_UST);
+POWER_EVENT_ATTR(INST_CMPL,                    INST_CMPL);
+POWER_EVENT_ATTR(FXU_IDLE,                     FXU_IDLE);
+POWER_EVENT_ATTR(LSU0_FLUSH_ULD,               LSU0_FLUSH_ULD);
+POWER_EVENT_ATTR(MRK_DATA_FROM_DL2L3_MOD,      MRK_DATA_FROM_DL2L3_MOD);
+POWER_EVENT_ATTR(LSU_LMQ_SRQ_EMPTY_ALL_CYC,    LSU_LMQ_SRQ_EMPTY_ALL_CYC);
+POWER_EVENT_ATTR(LSU1_REJECT_LMQ_FULL,         LSU1_REJECT_LMQ_FULL);
+POWER_EVENT_ATTR(INST_PTEG_FROM_L21_MOD,       INST_PTEG_FROM_L21_MOD);
+POWER_EVENT_ATTR(INST_FROM_RL2L3_MOD,          INST_FROM_RL2L3_MOD);
+POWER_EVENT_ATTR(SHL_CREATED,                  SHL_CREATED);
+POWER_EVENT_ATTR(L2_ST_HIT,                    L2_ST_HIT);
+POWER_EVENT_ATTR(DATA_FROM_DMEM,               DATA_FROM_DMEM);
+POWER_EVENT_ATTR(L3_LD_MISS,                   L3_LD_MISS);
+POWER_EVENT_ATTR(FXU1_BUSY_FXU0_IDLE,          FXU1_BUSY_FXU0_IDLE);
+POWER_EVENT_ATTR(DISP_CLB_HELD_RES,            DISP_CLB_HELD_RES);
+POWER_EVENT_ATTR(L2_SN_SX_I_DONE,              L2_SN_SX_I_DONE);
+POWER_EVENT_ATTR(GRP_CMPL,                     GRP_CMPL);
+POWER_EVENT_ATTR(STCX_CMPL,                    STCX_CMPL);
+POWER_EVENT_ATTR(VSU0_2FLOP,                   VSU0_2FLOP);
+POWER_EVENT_ATTR(L3_PREF_MISS,                 L3_PREF_MISS);
+POWER_EVENT_ATTR(LSU_SRQ_SYNC_CYC,             LSU_SRQ_SYNC_CYC);
+POWER_EVENT_ATTR(LSU_REJECT_ERAT_MISS,         LSU_REJECT_ERAT_MISS);
+POWER_EVENT_ATTR(L1_ICACHE_MISS,               L1_ICACHE_MISS);
+POWER_EVENT_ATTR(LSU1_FLUSH_SRQ,               LSU1_FLUSH_SRQ);
+POWER_EVENT_ATTR(LD_REF_L1_LSU0,               LD_REF_L1_LSU0);
+POWER_EVENT_ATTR(VSU0_FEST,                    VSU0_FEST);
+POWER_EVENT_ATTR(VSU_VECTOR_SINGLE_ISSUED,     VSU_VECTOR_SINGLE_ISSUED);
+POWER_EVENT_ATTR(FREQ_UP,                      FREQ_UP);
+POWER_EVENT_ATTR(DATA_FROM_LMEM,               DATA_FROM_LMEM);
+POWER_EVENT_ATTR(LSU1_LDX,                     LSU1_LDX);
+POWER_EVENT_ATTR(PMC3_OVERFLOW,                PMC3_OVERFLOW);
+POWER_EVENT_ATTR(MRK_BR_MPRED,                 MRK_BR_MPRED);
+POWER_EVENT_ATTR(SHL_MATCH,                    SHL_MATCH);
+POWER_EVENT_ATTR(MRK_BR_TAKEN,                 MRK_BR_TAKEN);
+POWER_EVENT_ATTR(CMPLU_STALL_BRU,              CMPLU_STALL_BRU);
+POWER_EVENT_ATTR(ISLB_MISS,                    ISLB_MISS);
+POWER_EVENT_ATTR(CYC,                          CYC);
+POWER_EVENT_ATTR(DISP_HELD_THERMAL,            DISP_HELD_THERMAL);
+POWER_EVENT_ATTR(INST_PTEG_FROM_RL2L3_SHR,     INST_PTEG_FROM_RL2L3_SHR);
+POWER_EVENT_ATTR(LSU1_SRQ_STFWD,               LSU1_SRQ_STFWD);
+POWER_EVENT_ATTR(GCT_NOSLOT_BR_MPRED,          GCT_NOSLOT_BR_MPRED);
+POWER_EVENT_ATTR(1PLUS_PPC_CMPL,               1PLUS_PPC_CMPL);
+POWER_EVENT_ATTR(PTEG_FROM_DMEM,               PTEG_FROM_DMEM);
+POWER_EVENT_ATTR(VSU_2FLOP,                    VSU_2FLOP);
+POWER_EVENT_ATTR(GCT_FULL_CYC,                 GCT_FULL_CYC);
+POWER_EVENT_ATTR(MRK_DATA_FROM_L3_CYC,         MRK_DATA_FROM_L3_CYC);
+POWER_EVENT_ATTR(LSU_SRQ_S0_ALLOC,             LSU_SRQ_S0_ALLOC);
+POWER_EVENT_ATTR(MRK_DERAT_MISS_4K,            MRK_DERAT_MISS_4K);
+POWER_EVENT_ATTR(BR_MPRED_TA,                  BR_MPRED_TA);
+POWER_EVENT_ATTR(INST_PTEG_FROM_L2MISS,        INST_PTEG_FROM_L2MISS);
+POWER_EVENT_ATTR(DPU_HELD_POWER,               DPU_HELD_POWER);
+POWER_EVENT_ATTR(RUN_INST_CMPL,                RUN_INST_CMPL);
+POWER_EVENT_ATTR(MRK_VSU_FIN,                  MRK_VSU_FIN);
+POWER_EVENT_ATTR(LSU_SRQ_S0_VALID,             LSU_SRQ_S0_VALID);
+POWER_EVENT_ATTR(GCT_EMPTY_CYC,                GCT_EMPTY_CYC);
+POWER_EVENT_ATTR(IOPS_DISP,                    IOPS_DISP);
+POWER_EVENT_ATTR(RUN_SPURR,                    RUN_SPURR);
+POWER_EVENT_ATTR(PTEG_FROM_L21_MOD,            PTEG_FROM_L21_MOD);
+POWER_EVENT_ATTR(VSU0_1FLOP,                   VSU0_1FLOP);
+POWER_EVENT_ATTR(SNOOP_TLBIE,                  SNOOP_TLBIE);
+POWER_EVENT_ATTR(DATA_FROM_L3MISS,             DATA_FROM_L3MISS);
+POWER_EVENT_ATTR(VSU_SINGLE,                   VSU_SINGLE);
+POWER_EVENT_ATTR(DTLB_MISS_16G,                DTLB_MISS_16G);
+POWER_EVENT_ATTR(CMPLU_STALL_VECTOR,           CMPLU_STALL_VECTOR);
+POWER_EVENT_ATTR(FLUSH,                        FLUSH);
+POWER_EVENT_ATTR(L2_LD_HIT,                    L2_LD_HIT);
+POWER_EVENT_ATTR(NEST_PAIR2_AND,               NEST_PAIR2_AND);
+POWER_EVENT_ATTR(VSU1_1FLOP,                   VSU1_1FLOP);
+POWER_EVENT_ATTR(IC_PREF_REQ,                  IC_PREF_REQ);
+POWER_EVENT_ATTR(L3_LD_HIT,                    L3_LD_HIT);
+POWER_EVENT_ATTR(GCT_NOSLOT_IC_MISS,           GCT_NOSLOT_IC_MISS);
+POWER_EVENT_ATTR(DISP_HELD,                    DISP_HELD);
+POWER_EVENT_ATTR(L2_LD,                        L2_LD);
+POWER_EVENT_ATTR(LSU_FLUSH_SRQ,                LSU_FLUSH_SRQ);
+POWER_EVENT_ATTR(BC_PLUS_8_CONV,               BC_PLUS_8_CONV);
+POWER_EVENT_ATTR(MRK_DATA_FROM_L31_MOD_CYC,    MRK_DATA_FROM_L31_MOD_CYC);
+POWER_EVENT_ATTR(CMPLU_STALL_VECTOR_LONG,      CMPLU_STALL_VECTOR_LONG);
+POWER_EVENT_ATTR(L2_RCST_BUSY_RC_FULL,         L2_RCST_BUSY_RC_FULL);
+POWER_EVENT_ATTR(TB_BIT_TRANS,                 TB_BIT_TRANS);
+POWER_EVENT_ATTR(THERMAL_MAX,                  THERMAL_MAX);
+POWER_EVENT_ATTR(LSU1_FLUSH_ULD,               LSU1_FLUSH_ULD);
+POWER_EVENT_ATTR(LSU1_REJECT_LHS,              LSU1_REJECT_LHS);
+POWER_EVENT_ATTR(LSU_LRQ_S0_ALLOC,             LSU_LRQ_S0_ALLOC);
+POWER_EVENT_ATTR(L3_CO_L31,                    L3_CO_L31);
+POWER_EVENT_ATTR(POWER_EVENT4,                 POWER_EVENT4);
+POWER_EVENT_ATTR(DATA_FROM_L31_SHR,            DATA_FROM_L31_SHR);
+POWER_EVENT_ATTR(BR_UNCOND,                    BR_UNCOND);
+POWER_EVENT_ATTR(LSU1_DC_PREF_STREAM_ALLOC,    LSU1_DC_PREF_STREAM_ALLOC);
+POWER_EVENT_ATTR(PMC4_REWIND,                  PMC4_REWIND);
+POWER_EVENT_ATTR(L2_RCLD_DISP,                 L2_RCLD_DISP);
+POWER_EVENT_ATTR(THRD_PRIO_2_3_CYC,            THRD_PRIO_2_3_CYC);
+POWER_EVENT_ATTR(MRK_PTEG_FROM_L2MISS,         MRK_PTEG_FROM_L2MISS);
+POWER_EVENT_ATTR(IC_DEMAND_L2_BHT_REDIRECT,    IC_DEMAND_L2_BHT_REDIRECT);
+POWER_EVENT_ATTR(LSU_DERAT_MISS,               LSU_DERAT_MISS);
+POWER_EVENT_ATTR(IC_PREF_CANCEL_L2,            IC_PREF_CANCEL_L2);
+POWER_EVENT_ATTR(MRK_FIN_STALL_CYC_COUNT,      MRK_FIN_STALL_CYC_COUNT);
+POWER_EVENT_ATTR(BR_PRED_CCACHE,               BR_PRED_CCACHE);
+POWER_EVENT_ATTR(GCT_UTIL_1_TO_2_SLOTS,        GCT_UTIL_1_TO_2_SLOTS);
+POWER_EVENT_ATTR(MRK_ST_CMPL_INT,              MRK_ST_CMPL_INT);
+POWER_EVENT_ATTR(LSU_TWO_TABLEWALK_CYC,        LSU_TWO_TABLEWALK_CYC);
+POWER_EVENT_ATTR(MRK_DATA_FROM_L3MISS,         MRK_DATA_FROM_L3MISS);
+POWER_EVENT_ATTR(GCT_NOSLOT_CYC,               GCT_NOSLOT_CYC);
+POWER_EVENT_ATTR(LSU_SET_MPRED,                LSU_SET_MPRED);
+POWER_EVENT_ATTR(FLUSH_DISP_TLBIE,             FLUSH_DISP_TLBIE);
+POWER_EVENT_ATTR(VSU1_FCONV,                   VSU1_FCONV);
+POWER_EVENT_ATTR(DERAT_MISS_16G,               DERAT_MISS_16G);
+POWER_EVENT_ATTR(INST_FROM_LMEM,               INST_FROM_LMEM);
+POWER_EVENT_ATTR(IC_DEMAND_L2_BR_REDIRECT,     IC_DEMAND_L2_BR_REDIRECT);
+POWER_EVENT_ATTR(CMPLU_STALL_SCALAR_LONG,      CMPLU_STALL_SCALAR_LONG);
+POWER_EVENT_ATTR(INST_PTEG_FROM_L2,            INST_PTEG_FROM_L2);
+POWER_EVENT_ATTR(PTEG_FROM_L2,                 PTEG_FROM_L2);
+POWER_EVENT_ATTR(MRK_DATA_FROM_L21_SHR_CYC,    MRK_DATA_FROM_L21_SHR_CYC);
+POWER_EVENT_ATTR(MRK_DTLB_MISS_4K,             MRK_DTLB_MISS_4K);
+POWER_EVENT_ATTR(VSU0_FPSCR,                   VSU0_FPSCR);
+POWER_EVENT_ATTR(VSU1_VECT_DOUBLE_ISSUED,      VSU1_VECT_DOUBLE_ISSUED);
+POWER_EVENT_ATTR(MRK_PTEG_FROM_RL2L3_MOD,      MRK_PTEG_FROM_RL2L3_MOD);
+POWER_EVENT_ATTR(MEM0_RQ_DISP,                 MEM0_RQ_DISP);
+POWER_EVENT_ATTR(L2_LD_MISS,                   L2_LD_MISS);
+POWER_EVENT_ATTR(VMX_RESULT_SAT_1,             VMX_RESULT_SAT_1);
+POWER_EVENT_ATTR(L1_PREF,                      L1_PREF);
+POWER_EVENT_ATTR(MRK_DATA_FROM_LMEM_CYC,       MRK_DATA_FROM_LMEM_CYC);
+POWER_EVENT_ATTR(GRP_IC_MISS_NONSPEC,          GRP_IC_MISS_NONSPEC);
+POWER_EVENT_ATTR(PB_NODE_PUMP,                 PB_NODE_PUMP);
+POWER_EVENT_ATTR(SHL_MERGED,                   SHL_MERGED);
+POWER_EVENT_ATTR(NEST_PAIR1_ADD,               NEST_PAIR1_ADD);
+POWER_EVENT_ATTR(DATA_FROM_L3,                 DATA_FROM_L3);
+POWER_EVENT_ATTR(LSU_FLUSH,                    LSU_FLUSH);
+POWER_EVENT_ATTR(LSU_SRQ_SYNC_COUNT,           LSU_SRQ_SYNC_COUNT);
+POWER_EVENT_ATTR(PMC2_OVERFLOW,                PMC2_OVERFLOW);
+POWER_EVENT_ATTR(LSU_LDF,                      LSU_LDF);
+POWER_EVENT_ATTR(POWER_EVENT3,                 POWER_EVENT3);
+POWER_EVENT_ATTR(DISP_WT,                      DISP_WT);
+POWER_EVENT_ATTR(CMPLU_STALL_REJECT,           CMPLU_STALL_REJECT);
+POWER_EVENT_ATTR(IC_BANK_CONFLICT,             IC_BANK_CONFLICT);
+POWER_EVENT_ATTR(BR_MPRED_CR_TA,               BR_MPRED_CR_TA);
+POWER_EVENT_ATTR(L2_INST_MISS,                 L2_INST_MISS);
+POWER_EVENT_ATTR(CMPLU_STALL_ERAT_MISS,        CMPLU_STALL_ERAT_MISS);
+POWER_EVENT_ATTR(NEST_PAIR2_ADD,               NEST_PAIR2_ADD);
+POWER_EVENT_ATTR(MRK_LSU_FLUSH,                MRK_LSU_FLUSH);
+POWER_EVENT_ATTR(L2_LDST,                      L2_LDST);
+POWER_EVENT_ATTR(INST_FROM_L31_SHR,            INST_FROM_L31_SHR);
+POWER_EVENT_ATTR(VSU0_FIN,                     VSU0_FIN);
+POWER_EVENT_ATTR(LARX_LSU,                     LARX_LSU);
+POWER_EVENT_ATTR(INST_FROM_RMEM,               INST_FROM_RMEM);
+POWER_EVENT_ATTR(DISP_CLB_HELD_TLBIE,          DISP_CLB_HELD_TLBIE);
+POWER_EVENT_ATTR(MRK_DATA_FROM_DMEM_CYC,       MRK_DATA_FROM_DMEM_CYC);
+POWER_EVENT_ATTR(BR_PRED_CR,                   BR_PRED_CR);
+POWER_EVENT_ATTR(LSU_REJECT,                   LSU_REJECT);
+POWER_EVENT_ATTR(GCT_UTIL_3_TO_6_SLOTS,        GCT_UTIL_3_TO_6_SLOTS);
+POWER_EVENT_ATTR(CMPLU_STALL_END_GCT_NOSLOT,   CMPLU_STALL_END_GCT_NOSLOT);
+POWER_EVENT_ATTR(LSU0_REJECT_LMQ_FULL,         LSU0_REJECT_LMQ_FULL);
+POWER_EVENT_ATTR(VSU_FEST,                     VSU_FEST);
+POWER_EVENT_ATTR(NEST_PAIR0_AND,               NEST_PAIR0_AND);
+POWER_EVENT_ATTR(PTEG_FROM_L3,                 PTEG_FROM_L3);
+POWER_EVENT_ATTR(POWER_EVENT2,                 POWER_EVENT2);
+POWER_EVENT_ATTR(IC_PREF_CANCEL_PAGE,          IC_PREF_CANCEL_PAGE);
+POWER_EVENT_ATTR(VSU0_FSQRT_FDIV,              VSU0_FSQRT_FDIV);
+POWER_EVENT_ATTR(MRK_GRP_CMPL,                 MRK_GRP_CMPL);
+POWER_EVENT_ATTR(VSU0_SCAL_DOUBLE_ISSUED,      VSU0_SCAL_DOUBLE_ISSUED);
+POWER_EVENT_ATTR(GRP_DISP,                     GRP_DISP);
+POWER_EVENT_ATTR(LSU0_LDX,                     LSU0_LDX);
+POWER_EVENT_ATTR(DATA_FROM_L2,                 DATA_FROM_L2);
+POWER_EVENT_ATTR(MRK_DATA_FROM_RL2L3_MOD,      MRK_DATA_FROM_RL2L3_MOD);
+POWER_EVENT_ATTR(LD_REF_L1,                    LD_REF_L1);
+POWER_EVENT_ATTR(VSU0_VECT_DOUBLE_ISSUED,      VSU0_VECT_DOUBLE_ISSUED);
+POWER_EVENT_ATTR(VSU1_2FLOP_DOUBLE,            VSU1_2FLOP_DOUBLE);
+POWER_EVENT_ATTR(THRD_PRIO_6_7_CYC,            THRD_PRIO_6_7_CYC);
+POWER_EVENT_ATTR(BC_PLUS_8_RSLV_TAKEN,         BC_PLUS_8_RSLV_TAKEN);
+POWER_EVENT_ATTR(BR_MPRED_CR,                  BR_MPRED_CR);
+POWER_EVENT_ATTR(L3_CO_MEM,                    L3_CO_MEM);
+POWER_EVENT_ATTR(LD_MISS_L1,                   LD_MISS_L1);
+POWER_EVENT_ATTR(DATA_FROM_RL2L3_MOD,          DATA_FROM_RL2L3_MOD);
+POWER_EVENT_ATTR(LSU_SRQ_FULL_CYC,             LSU_SRQ_FULL_CYC);
+POWER_EVENT_ATTR(TABLEWALK_CYC,                TABLEWALK_CYC);
+POWER_EVENT_ATTR(MRK_PTEG_FROM_RMEM,           MRK_PTEG_FROM_RMEM);
+POWER_EVENT_ATTR(LSU_SRQ_STFWD,                LSU_SRQ_STFWD);
+POWER_EVENT_ATTR(INST_PTEG_FROM_RMEM,          INST_PTEG_FROM_RMEM);
+POWER_EVENT_ATTR(FXU0_FIN,                     FXU0_FIN);
+POWER_EVENT_ATTR(LSU1_L1_SW_PREF,              LSU1_L1_SW_PREF);
+POWER_EVENT_ATTR(PTEG_FROM_L31_MOD,            PTEG_FROM_L31_MOD);
+POWER_EVENT_ATTR(PMC5_OVERFLOW,                PMC5_OVERFLOW);
+POWER_EVENT_ATTR(LD_REF_L1_LSU1,               LD_REF_L1_LSU1);
+POWER_EVENT_ATTR(INST_PTEG_FROM_L21_SHR,       INST_PTEG_FROM_L21_SHR);
+POWER_EVENT_ATTR(CMPLU_STALL_THRD,             CMPLU_STALL_THRD);
+POWER_EVENT_ATTR(DATA_FROM_RMEM,               DATA_FROM_RMEM);
+POWER_EVENT_ATTR(VSU0_SCAL_SINGLE_ISSUED,      VSU0_SCAL_SINGLE_ISSUED);
+POWER_EVENT_ATTR(BR_MPRED_LSTACK,              BR_MPRED_LSTACK);
+POWER_EVENT_ATTR(MRK_DATA_FROM_RL2L3_MOD_CYC,  MRK_DATA_FROM_RL2L3_MOD_CYC);
+POWER_EVENT_ATTR(LSU0_FLUSH_UST,               LSU0_FLUSH_UST);
+POWER_EVENT_ATTR(LSU_NCST,                     LSU_NCST);
+POWER_EVENT_ATTR(BR_TAKEN,                     BR_TAKEN);
+POWER_EVENT_ATTR(INST_PTEG_FROM_LMEM,          INST_PTEG_FROM_LMEM);
+POWER_EVENT_ATTR(GCT_NOSLOT_BR_MPRED_IC_MISS,  GCT_NOSLOT_BR_MPRED_IC_MISS);
+POWER_EVENT_ATTR(DTLB_MISS_4K,                 DTLB_MISS_4K);
+POWER_EVENT_ATTR(PMC4_SAVED,                   PMC4_SAVED);
+POWER_EVENT_ATTR(VSU1_PERMUTE_ISSUED,          VSU1_PERMUTE_ISSUED);
+POWER_EVENT_ATTR(SLB_MISS,                     SLB_MISS);
+POWER_EVENT_ATTR(LSU1_FLUSH_LRQ,               LSU1_FLUSH_LRQ);
+POWER_EVENT_ATTR(DTLB_MISS,                    DTLB_MISS);
+POWER_EVENT_ATTR(VSU1_FRSP,                    VSU1_FRSP);
+POWER_EVENT_ATTR(VSU_VECTOR_DOUBLE_ISSUED,     VSU_VECTOR_DOUBLE_ISSUED);
+POWER_EVENT_ATTR(L2_CASTOUT_SHR,               L2_CASTOUT_SHR);
+POWER_EVENT_ATTR(DATA_FROM_DL2L3_SHR,          DATA_FROM_DL2L3_SHR);
+POWER_EVENT_ATTR(VSU1_STF,                     VSU1_STF);
+POWER_EVENT_ATTR(ST_FIN,                       ST_FIN);
+POWER_EVENT_ATTR(PTEG_FROM_L21_SHR,            PTEG_FROM_L21_SHR);
+POWER_EVENT_ATTR(L2_LOC_GUESS_WRONG,           L2_LOC_GUESS_WRONG);
+POWER_EVENT_ATTR(MRK_STCX_FAIL,                MRK_STCX_FAIL);
+POWER_EVENT_ATTR(LSU0_REJECT_LHS,              LSU0_REJECT_LHS);
+POWER_EVENT_ATTR(IC_PREF_CANCEL_HIT,           IC_PREF_CANCEL_HIT);
+POWER_EVENT_ATTR(L3_PREF_BUSY,                 L3_PREF_BUSY);
+POWER_EVENT_ATTR(MRK_BRU_FIN,                  MRK_BRU_FIN);
+POWER_EVENT_ATTR(LSU1_NCLD,                    LSU1_NCLD);
+POWER_EVENT_ATTR(INST_PTEG_FROM_L31_MOD,       INST_PTEG_FROM_L31_MOD);
+POWER_EVENT_ATTR(LSU_NCLD,                     LSU_NCLD);
+POWER_EVENT_ATTR(LSU_LDX,                      LSU_LDX);
+POWER_EVENT_ATTR(L2_LOC_GUESS_CORRECT,         L2_LOC_GUESS_CORRECT);
+POWER_EVENT_ATTR(THRESH_TIMEO,                 THRESH_TIMEO);
+POWER_EVENT_ATTR(L3_PREF_ST,                   L3_PREF_ST);
+POWER_EVENT_ATTR(DISP_CLB_HELD_SYNC,           DISP_CLB_HELD_SYNC);
+POWER_EVENT_ATTR(VSU_SIMPLE_ISSUED,            VSU_SIMPLE_ISSUED);
+POWER_EVENT_ATTR(VSU1_SINGLE,                  VSU1_SINGLE);
+POWER_EVENT_ATTR(DATA_TABLEWALK_CYC,           DATA_TABLEWALK_CYC);
+POWER_EVENT_ATTR(L2_RC_ST_DONE,                L2_RC_ST_DONE);
+POWER_EVENT_ATTR(MRK_PTEG_FROM_L21_MOD,        MRK_PTEG_FROM_L21_MOD);
+POWER_EVENT_ATTR(LARX_LSU1,                    LARX_LSU1);
+POWER_EVENT_ATTR(MRK_DATA_FROM_RMEM,           MRK_DATA_FROM_RMEM);
+POWER_EVENT_ATTR(DISP_CLB_HELD,                DISP_CLB_HELD);
+POWER_EVENT_ATTR(DERAT_MISS_4K,                DERAT_MISS_4K);
+POWER_EVENT_ATTR(L2_RCLD_DISP_FAIL_ADDR,       L2_RCLD_DISP_FAIL_ADDR);
+POWER_EVENT_ATTR(SEG_EXCEPTION,                SEG_EXCEPTION);
+POWER_EVENT_ATTR(FLUSH_DISP_SB,                FLUSH_DISP_SB);
+POWER_EVENT_ATTR(L2_DC_INV,                    L2_DC_INV);
+POWER_EVENT_ATTR(PTEG_FROM_DL2L3_MOD,          PTEG_FROM_DL2L3_MOD);
+POWER_EVENT_ATTR(DSEG,                         DSEG);
+POWER_EVENT_ATTR(BR_PRED_LSTACK,               BR_PRED_LSTACK);
+POWER_EVENT_ATTR(VSU0_STF,                     VSU0_STF);
+POWER_EVENT_ATTR(LSU_FX_FIN,                   LSU_FX_FIN);
+POWER_EVENT_ATTR(DERAT_MISS_16M,               DERAT_MISS_16M);
+POWER_EVENT_ATTR(MRK_PTEG_FROM_DL2L3_MOD,      MRK_PTEG_FROM_DL2L3_MOD);
+POWER_EVENT_ATTR(GCT_UTIL_11_PLUS_SLOTS,       GCT_UTIL_11_PLUS_SLOTS);
+POWER_EVENT_ATTR(INST_FROM_L3,                 INST_FROM_L3);
+POWER_EVENT_ATTR(MRK_IFU_FIN,                  MRK_IFU_FIN);
+POWER_EVENT_ATTR(ITLB_MISS,                    ITLB_MISS);
+POWER_EVENT_ATTR(VSU_STF,                      VSU_STF);
+POWER_EVENT_ATTR(LSU_FLUSH_UST,                LSU_FLUSH_UST);
+POWER_EVENT_ATTR(L2_LDST_MISS,                 L2_LDST_MISS);
+POWER_EVENT_ATTR(FXU1_FIN,                     FXU1_FIN);
+POWER_EVENT_ATTR(SHL_DEALLOCATED,              SHL_DEALLOCATED);
+POWER_EVENT_ATTR(L2_SN_M_WR_DONE,              L2_SN_M_WR_DONE);
+POWER_EVENT_ATTR(LSU_REJECT_SET_MPRED,         LSU_REJECT_SET_MPRED);
+POWER_EVENT_ATTR(L3_PREF_LD,                   L3_PREF_LD);
+POWER_EVENT_ATTR(L2_SN_M_RD_DONE,              L2_SN_M_RD_DONE);
+POWER_EVENT_ATTR(MRK_DERAT_MISS_16G,           MRK_DERAT_MISS_16G);
+POWER_EVENT_ATTR(VSU_FCONV,                    VSU_FCONV);
+POWER_EVENT_ATTR(ANY_THRD_RUN_CYC,             ANY_THRD_RUN_CYC);
+POWER_EVENT_ATTR(LSU_LMQ_FULL_CYC,             LSU_LMQ_FULL_CYC);
+POWER_EVENT_ATTR(MRK_LSU_REJECT_LHS,           MRK_LSU_REJECT_LHS);
+POWER_EVENT_ATTR(MRK_LD_MISS_L1_CYC,           MRK_LD_MISS_L1_CYC);
+POWER_EVENT_ATTR(MRK_DATA_FROM_L2_CYC,         MRK_DATA_FROM_L2_CYC);
+POWER_EVENT_ATTR(INST_IMC_MATCH_DISP,          INST_IMC_MATCH_DISP);
+POWER_EVENT_ATTR(MRK_DATA_FROM_RMEM_CYC,       MRK_DATA_FROM_RMEM_CYC);
+POWER_EVENT_ATTR(VSU0_SIMPLE_ISSUED,           VSU0_SIMPLE_ISSUED);
+POWER_EVENT_ATTR(CMPLU_STALL_DIV,              CMPLU_STALL_DIV);
+POWER_EVENT_ATTR(MRK_PTEG_FROM_RL2L3_SHR,      MRK_PTEG_FROM_RL2L3_SHR);
+POWER_EVENT_ATTR(VSU_FMA_DOUBLE,               VSU_FMA_DOUBLE);
+POWER_EVENT_ATTR(VSU_4FLOP,                    VSU_4FLOP);
+POWER_EVENT_ATTR(VSU1_FIN,                     VSU1_FIN);
+POWER_EVENT_ATTR(NEST_PAIR1_AND,               NEST_PAIR1_AND);
+POWER_EVENT_ATTR(INST_PTEG_FROM_RL2L3_MOD,     INST_PTEG_FROM_RL2L3_MOD);
+POWER_EVENT_ATTR(RUN_CYC,                      RUN_CYC);
+POWER_EVENT_ATTR(PTEG_FROM_RMEM,               PTEG_FROM_RMEM);
+POWER_EVENT_ATTR(LSU_LRQ_S0_VALID,             LSU_LRQ_S0_VALID);
+POWER_EVENT_ATTR(LSU0_LDF,                     LSU0_LDF);
+POWER_EVENT_ATTR(FLUSH_COMPLETION,             FLUSH_COMPLETION);
+POWER_EVENT_ATTR(ST_MISS_L1,                   ST_MISS_L1);
+POWER_EVENT_ATTR(L2_NODE_PUMP,                 L2_NODE_PUMP);
+POWER_EVENT_ATTR(INST_FROM_DL2L3_SHR,          INST_FROM_DL2L3_SHR);
+POWER_EVENT_ATTR(MRK_STALL_CMPLU_CYC,          MRK_STALL_CMPLU_CYC);
+POWER_EVENT_ATTR(VSU1_DENORM,                  VSU1_DENORM);
+POWER_EVENT_ATTR(MRK_DATA_FROM_L31_SHR_CYC,    MRK_DATA_FROM_L31_SHR_CYC);
+POWER_EVENT_ATTR(NEST_PAIR0_ADD,               NEST_PAIR0_ADD);
+POWER_EVENT_ATTR(INST_FROM_L3MISS,             INST_FROM_L3MISS);
+POWER_EVENT_ATTR(EE_OFF_EXT_INT,               EE_OFF_EXT_INT);
+POWER_EVENT_ATTR(INST_PTEG_FROM_DMEM,          INST_PTEG_FROM_DMEM);
+POWER_EVENT_ATTR(INST_FROM_DL2L3_MOD,          INST_FROM_DL2L3_MOD);
+POWER_EVENT_ATTR(PMC6_OVERFLOW,                PMC6_OVERFLOW);
+POWER_EVENT_ATTR(VSU_2FLOP_DOUBLE,             VSU_2FLOP_DOUBLE);
+POWER_EVENT_ATTR(TLB_MISS,                     TLB_MISS);
+POWER_EVENT_ATTR(FXU_BUSY,                     FXU_BUSY);
+POWER_EVENT_ATTR(L2_RCLD_DISP_FAIL_OTHER,      L2_RCLD_DISP_FAIL_OTHER);
+POWER_EVENT_ATTR(LSU_REJECT_LMQ_FULL,          LSU_REJECT_LMQ_FULL);
+POWER_EVENT_ATTR(IC_RELOAD_SHR,                IC_RELOAD_SHR);
+POWER_EVENT_ATTR(GRP_MRK,                      GRP_MRK);
+POWER_EVENT_ATTR(MRK_ST_NEST,                  MRK_ST_NEST);
+POWER_EVENT_ATTR(VSU1_FSQRT_FDIV,              VSU1_FSQRT_FDIV);
+POWER_EVENT_ATTR(LSU0_FLUSH_LRQ,               LSU0_FLUSH_LRQ);
+POWER_EVENT_ATTR(LARX_LSU0,                    LARX_LSU0);
+POWER_EVENT_ATTR(IBUF_FULL_CYC,                IBUF_FULL_CYC);
+POWER_EVENT_ATTR(MRK_DATA_FROM_DL2L3_SHR_CYC,  MRK_DATA_FROM_DL2L3_SHR_CYC);
+POWER_EVENT_ATTR(LSU_DC_PREF_STREAM_ALLOC,     LSU_DC_PREF_STREAM_ALLOC);
+POWER_EVENT_ATTR(GRP_MRK_CYC,                  GRP_MRK_CYC);
+POWER_EVENT_ATTR(MRK_DATA_FROM_RL2L3_SHR_CYC,  MRK_DATA_FROM_RL2L3_SHR_CYC);
+POWER_EVENT_ATTR(L2_GLOB_GUESS_CORRECT,        L2_GLOB_GUESS_CORRECT);
+POWER_EVENT_ATTR(LSU_REJECT_LHS,               LSU_REJECT_LHS);
+POWER_EVENT_ATTR(MRK_DATA_FROM_LMEM,           MRK_DATA_FROM_LMEM);
+POWER_EVENT_ATTR(INST_PTEG_FROM_L3,            INST_PTEG_FROM_L3);
+POWER_EVENT_ATTR(FREQ_DOWN,                    FREQ_DOWN);
+POWER_EVENT_ATTR(PB_RETRY_NODE_PUMP,           PB_RETRY_NODE_PUMP);
+POWER_EVENT_ATTR(INST_FROM_RL2L3_SHR,          INST_FROM_RL2L3_SHR);
+POWER_EVENT_ATTR(MRK_INST_ISSUED,              MRK_INST_ISSUED);
+POWER_EVENT_ATTR(PTEG_FROM_L3MISS,             PTEG_FROM_L3MISS);
+POWER_EVENT_ATTR(RUN_PURR,                     RUN_PURR);
+POWER_EVENT_ATTR(MRK_GRP_IC_MISS,              MRK_GRP_IC_MISS);
+POWER_EVENT_ATTR(MRK_DATA_FROM_L3,             MRK_DATA_FROM_L3);
+POWER_EVENT_ATTR(CMPLU_STALL_DCACHE_MISS,      CMPLU_STALL_DCACHE_MISS);
+POWER_EVENT_ATTR(PTEG_FROM_RL2L3_SHR,          PTEG_FROM_RL2L3_SHR);
+POWER_EVENT_ATTR(LSU_FLUSH_LRQ,                LSU_FLUSH_LRQ);
+POWER_EVENT_ATTR(MRK_DERAT_MISS_64K,           MRK_DERAT_MISS_64K);
+POWER_EVENT_ATTR(INST_PTEG_FROM_DL2L3_MOD,     INST_PTEG_FROM_DL2L3_MOD);
+POWER_EVENT_ATTR(L2_ST_MISS,                   L2_ST_MISS);
+POWER_EVENT_ATTR(MRK_PTEG_FROM_L21_SHR,        MRK_PTEG_FROM_L21_SHR);
+POWER_EVENT_ATTR(LWSYNC,                       LWSYNC);
+POWER_EVENT_ATTR(LSU0_DC_PREF_STREAM_CONFIRM_STRIDE,
+		 LSU0_DC_PREF_STREAM_CONFIRM_STRIDE);
+POWER_EVENT_ATTR(MRK_LSU_FLUSH_LRQ,            MRK_LSU_FLUSH_LRQ);
+POWER_EVENT_ATTR(INST_IMC_MATCH_CMPL,          INST_IMC_MATCH_CMPL);
+POWER_EVENT_ATTR(NEST_PAIR3_AND,               NEST_PAIR3_AND);
+POWER_EVENT_ATTR(PB_RETRY_SYS_PUMP,            PB_RETRY_SYS_PUMP);
+POWER_EVENT_ATTR(MRK_INST_FIN,                 MRK_INST_FIN);
+POWER_EVENT_ATTR(MRK_PTEG_FROM_DL2L3_SHR,      MRK_PTEG_FROM_DL2L3_SHR);
+POWER_EVENT_ATTR(INST_FROM_L31_MOD,            INST_FROM_L31_MOD);
+POWER_EVENT_ATTR(MRK_DTLB_MISS_64K,            MRK_DTLB_MISS_64K);
+POWER_EVENT_ATTR(LSU_FIN,                      LSU_FIN);
+POWER_EVENT_ATTR(MRK_LSU_REJECT,               MRK_LSU_REJECT);
+POWER_EVENT_ATTR(L2_CO_FAIL_BUSY,              L2_CO_FAIL_BUSY);
+POWER_EVENT_ATTR(MEM0_WQ_DISP,                 MEM0_WQ_DISP);
+POWER_EVENT_ATTR(DATA_FROM_L31_MOD,            DATA_FROM_L31_MOD);
+POWER_EVENT_ATTR(THERMAL_WARN,                 THERMAL_WARN);
+POWER_EVENT_ATTR(VSU0_4FLOP,                   VSU0_4FLOP);
+POWER_EVENT_ATTR(BR_MPRED_CCACHE,              BR_MPRED_CCACHE);
+POWER_EVENT_ATTR(CMPLU_STALL_IFU,              CMPLU_STALL_IFU);
+POWER_EVENT_ATTR(L1_DEMAND_WRITE,              L1_DEMAND_WRITE);
+POWER_EVENT_ATTR(FLUSH_BR_MPRED,               FLUSH_BR_MPRED);
+POWER_EVENT_ATTR(MRK_DTLB_MISS_16G,            MRK_DTLB_MISS_16G);
+POWER_EVENT_ATTR(MRK_PTEG_FROM_DMEM,           MRK_PTEG_FROM_DMEM);
+POWER_EVENT_ATTR(L2_RCST_DISP,                 L2_RCST_DISP);
+POWER_EVENT_ATTR(CMPLU_STALL,                  CMPLU_STALL);
+POWER_EVENT_ATTR(LSU_PARTIAL_CDF,              LSU_PARTIAL_CDF);
+POWER_EVENT_ATTR(DISP_CLB_HELD_SB,             DISP_CLB_HELD_SB);
+POWER_EVENT_ATTR(VSU0_FMA_DOUBLE,              VSU0_FMA_DOUBLE);
+POWER_EVENT_ATTR(FXU0_BUSY_FXU1_IDLE,          FXU0_BUSY_FXU1_IDLE);
+POWER_EVENT_ATTR(IC_DEMAND_CYC,                IC_DEMAND_CYC);
+POWER_EVENT_ATTR(MRK_DATA_FROM_L21_SHR,        MRK_DATA_FROM_L21_SHR);
+POWER_EVENT_ATTR(MRK_LSU_FLUSH_UST,            MRK_LSU_FLUSH_UST);
+POWER_EVENT_ATTR(INST_PTEG_FROM_L3MISS,        INST_PTEG_FROM_L3MISS);
+POWER_EVENT_ATTR(VSU_DENORM,                   VSU_DENORM);
+POWER_EVENT_ATTR(MRK_LSU_PARTIAL_CDF,          MRK_LSU_PARTIAL_CDF);
+POWER_EVENT_ATTR(INST_FROM_L21_SHR,            INST_FROM_L21_SHR);
+POWER_EVENT_ATTR(IC_PREF_WRITE,                IC_PREF_WRITE);
+POWER_EVENT_ATTR(BR_PRED,                      BR_PRED);
+POWER_EVENT_ATTR(INST_FROM_DMEM,               INST_FROM_DMEM);
+POWER_EVENT_ATTR(IC_PREF_CANCEL_ALL,           IC_PREF_CANCEL_ALL);
+POWER_EVENT_ATTR(LSU_DC_PREF_STREAM_CONFIRM,   LSU_DC_PREF_STREAM_CONFIRM);
+POWER_EVENT_ATTR(MRK_LSU_FLUSH_SRQ,            MRK_LSU_FLUSH_SRQ);
+POWER_EVENT_ATTR(MRK_FIN_STALL_CYC,            MRK_FIN_STALL_CYC);
+POWER_EVENT_ATTR(L2_RCST_DISP_FAIL_OTHER,      L2_RCST_DISP_FAIL_OTHER);
+POWER_EVENT_ATTR(VSU1_DD_ISSUED,               VSU1_DD_ISSUED);
+POWER_EVENT_ATTR(PTEG_FROM_L31_SHR,            PTEG_FROM_L31_SHR);
+POWER_EVENT_ATTR(DATA_FROM_L21_SHR,            DATA_FROM_L21_SHR);
+POWER_EVENT_ATTR(LSU0_NCLD,                    LSU0_NCLD);
+POWER_EVENT_ATTR(VSU1_4FLOP,                   VSU1_4FLOP);
+POWER_EVENT_ATTR(VSU1_8FLOP,                   VSU1_8FLOP);
+POWER_EVENT_ATTR(VSU_8FLOP,                    VSU_8FLOP);
+POWER_EVENT_ATTR(LSU_LMQ_SRQ_EMPTY_CYC,        LSU_LMQ_SRQ_EMPTY_CYC);
+POWER_EVENT_ATTR(DTLB_MISS_64K,                DTLB_MISS_64K);
+POWER_EVENT_ATTR(THRD_CONC_RUN_INST,           THRD_CONC_RUN_INST);
+POWER_EVENT_ATTR(MRK_PTEG_FROM_L2,             MRK_PTEG_FROM_L2);
+POWER_EVENT_ATTR(PB_SYS_PUMP,                  PB_SYS_PUMP);
+POWER_EVENT_ATTR(VSU_FIN,                      VSU_FIN);
+POWER_EVENT_ATTR(MRK_DATA_FROM_L31_MOD,        MRK_DATA_FROM_L31_MOD);
+POWER_EVENT_ATTR(THRD_PRIO_0_1_CYC,            THRD_PRIO_0_1_CYC);
+POWER_EVENT_ATTR(DERAT_MISS_64K,               DERAT_MISS_64K);
+POWER_EVENT_ATTR(PMC2_REWIND,                  PMC2_REWIND);
+POWER_EVENT_ATTR(INST_FROM_L2,                 INST_FROM_L2);
+POWER_EVENT_ATTR(GRP_BR_MPRED_NONSPEC,         GRP_BR_MPRED_NONSPEC);
+POWER_EVENT_ATTR(INST_DISP,                    INST_DISP);
+POWER_EVENT_ATTR(MEM0_RD_CANCEL_TOTAL,         MEM0_RD_CANCEL_TOTAL);
+POWER_EVENT_ATTR(LSU0_DC_PREF_STREAM_CONFIRM,  LSU0_DC_PREF_STREAM_CONFIRM);
+POWER_EVENT_ATTR(L1_DCACHE_RELOAD_VALID,       L1_DCACHE_RELOAD_VALID);
+POWER_EVENT_ATTR(VSU_SCALAR_DOUBLE_ISSUED,     VSU_SCALAR_DOUBLE_ISSUED);
+POWER_EVENT_ATTR(L3_PREF_HIT,                  L3_PREF_HIT);
+POWER_EVENT_ATTR(MRK_PTEG_FROM_L31_MOD,        MRK_PTEG_FROM_L31_MOD);
+POWER_EVENT_ATTR(CMPLU_STALL_STORE,            CMPLU_STALL_STORE);
+POWER_EVENT_ATTR(MRK_FXU_FIN,                  MRK_FXU_FIN);
+POWER_EVENT_ATTR(PMC4_OVERFLOW,                PMC4_OVERFLOW);
+POWER_EVENT_ATTR(MRK_PTEG_FROM_L3,             MRK_PTEG_FROM_L3);
+POWER_EVENT_ATTR(LSU0_LMQ_LHR_MERGE,           LSU0_LMQ_LHR_MERGE);
+POWER_EVENT_ATTR(BTAC_HIT,                     BTAC_HIT);
+POWER_EVENT_ATTR(L3_RD_BUSY,                   L3_RD_BUSY);
+POWER_EVENT_ATTR(LSU0_L1_SW_PREF,              LSU0_L1_SW_PREF);
+POWER_EVENT_ATTR(INST_FROM_L2MISS,             INST_FROM_L2MISS);
+POWER_EVENT_ATTR(LSU0_DC_PREF_STREAM_ALLOC,    LSU0_DC_PREF_STREAM_ALLOC);
+POWER_EVENT_ATTR(L2_ST,                        L2_ST);
+POWER_EVENT_ATTR(VSU0_DENORM,                  VSU0_DENORM);
+POWER_EVENT_ATTR(MRK_DATA_FROM_DL2L3_SHR,      MRK_DATA_FROM_DL2L3_SHR);
+POWER_EVENT_ATTR(BR_PRED_CR_TA,                BR_PRED_CR_TA);
+POWER_EVENT_ATTR(VSU0_FCONV,                   VSU0_FCONV);
+POWER_EVENT_ATTR(MRK_LSU_FLUSH_ULD,            MRK_LSU_FLUSH_ULD);
+POWER_EVENT_ATTR(BTAC_MISS,                    BTAC_MISS);
+POWER_EVENT_ATTR(MRK_LD_MISS_EXPOSED_CYC_COUNT,
+		 MRK_LD_MISS_EXPOSED_CYC_COUNT);
+POWER_EVENT_ATTR(MRK_DATA_FROM_L2,             MRK_DATA_FROM_L2);
+POWER_EVENT_ATTR(LSU_DCACHE_RELOAD_VALID,      LSU_DCACHE_RELOAD_VALID);
+POWER_EVENT_ATTR(VSU_FMA,                      VSU_FMA);
+POWER_EVENT_ATTR(LSU0_FLUSH_SRQ,               LSU0_FLUSH_SRQ);
+POWER_EVENT_ATTR(LSU1_L1_PREF,                 LSU1_L1_PREF);
+POWER_EVENT_ATTR(IOPS_CMPL,                    IOPS_CMPL);
+POWER_EVENT_ATTR(L2_SYS_PUMP,                  L2_SYS_PUMP);
+POWER_EVENT_ATTR(L2_RCLD_BUSY_RC_FULL,         L2_RCLD_BUSY_RC_FULL);
+POWER_EVENT_ATTR(LSU_LMQ_S0_ALLOC,             LSU_LMQ_S0_ALLOC);
+POWER_EVENT_ATTR(FLUSH_DISP_SYNC,              FLUSH_DISP_SYNC);
+POWER_EVENT_ATTR(MRK_DATA_FROM_DL2L3_MOD_CYC,  MRK_DATA_FROM_DL2L3_MOD_CYC);
+POWER_EVENT_ATTR(L2_IC_INV,                    L2_IC_INV);
+POWER_EVENT_ATTR(MRK_DATA_FROM_L21_MOD_CYC,    MRK_DATA_FROM_L21_MOD_CYC);
+POWER_EVENT_ATTR(L3_PREF_LDST,                 L3_PREF_LDST);
+POWER_EVENT_ATTR(LSU_SRQ_EMPTY_CYC,            LSU_SRQ_EMPTY_CYC);
+POWER_EVENT_ATTR(LSU_LMQ_S0_VALID,             LSU_LMQ_S0_VALID);
+POWER_EVENT_ATTR(FLUSH_PARTIAL,                FLUSH_PARTIAL);
+POWER_EVENT_ATTR(VSU1_FMA_DOUBLE,              VSU1_FMA_DOUBLE);
+POWER_EVENT_ATTR(1PLUS_PPC_DISP,               1PLUS_PPC_DISP);
+POWER_EVENT_ATTR(DATA_FROM_L2MISS,             DATA_FROM_L2MISS);
+POWER_EVENT_ATTR(SUSPENDED,                    SUSPENDED);
+POWER_EVENT_ATTR(VSU0_FMA,                     VSU0_FMA);
+POWER_EVENT_ATTR(CMPLU_STALL_SCALAR,           CMPLU_STALL_SCALAR);
+POWER_EVENT_ATTR(STCX_FAIL,                    STCX_FAIL);
+POWER_EVENT_ATTR(VSU0_FSQRT_FDIV_DOUBLE,       VSU0_FSQRT_FDIV_DOUBLE);
+POWER_EVENT_ATTR(DC_PREF_DST,                  DC_PREF_DST);
+POWER_EVENT_ATTR(VSU1_SCAL_SINGLE_ISSUED,      VSU1_SCAL_SINGLE_ISSUED);
+POWER_EVENT_ATTR(L3_HIT,                       L3_HIT);
+POWER_EVENT_ATTR(L2_GLOB_GUESS_WRONG,          L2_GLOB_GUESS_WRONG);
+POWER_EVENT_ATTR(MRK_DFU_FIN,                  MRK_DFU_FIN);
+POWER_EVENT_ATTR(INST_FROM_L1,                 INST_FROM_L1);
+POWER_EVENT_ATTR(BRU_FIN,                      BRU_FIN);
+POWER_EVENT_ATTR(IC_DEMAND_REQ,                IC_DEMAND_REQ);
+POWER_EVENT_ATTR(VSU1_FSQRT_FDIV_DOUBLE,       VSU1_FSQRT_FDIV_DOUBLE);
+POWER_EVENT_ATTR(VSU1_FMA,                     VSU1_FMA);
+POWER_EVENT_ATTR(MRK_LD_MISS_L1,               MRK_LD_MISS_L1);
+POWER_EVENT_ATTR(VSU0_2FLOP_DOUBLE,            VSU0_2FLOP_DOUBLE);
+POWER_EVENT_ATTR(LSU_DC_PREF_STRIDED_STREAM_CONFIRM,
+		 LSU_DC_PREF_STRIDED_STREAM_CONFIRM);
+POWER_EVENT_ATTR(INST_PTEG_FROM_L31_SHR,       INST_PTEG_FROM_L31_SHR);
+POWER_EVENT_ATTR(MRK_LSU_REJECT_ERAT_MISS,     MRK_LSU_REJECT_ERAT_MISS);
+POWER_EVENT_ATTR(MRK_DATA_FROM_L2MISS,         MRK_DATA_FROM_L2MISS);
+POWER_EVENT_ATTR(DATA_FROM_RL2L3_SHR,          DATA_FROM_RL2L3_SHR);
+POWER_EVENT_ATTR(INST_FROM_PREF,               INST_FROM_PREF);
+POWER_EVENT_ATTR(VSU1_SQ,                      VSU1_SQ);
+POWER_EVENT_ATTR(L2_LD_DISP,                   L2_LD_DISP);
+POWER_EVENT_ATTR(L2_DISP_ALL,                  L2_DISP_ALL);
+POWER_EVENT_ATTR(THRD_GRP_CMPL_BOTH_CYC,       THRD_GRP_CMPL_BOTH_CYC);
+POWER_EVENT_ATTR(VSU_FSQRT_FDIV_DOUBLE,        VSU_FSQRT_FDIV_DOUBLE);
+POWER_EVENT_ATTR(BR_MPRED,                     BR_MPRED);
+POWER_EVENT_ATTR(INST_PTEG_FROM_DL2L3_SHR,     INST_PTEG_FROM_DL2L3_SHR);
+POWER_EVENT_ATTR(VSU_1FLOP,                    VSU_1FLOP);
+POWER_EVENT_ATTR(HV_CYC,                       HV_CYC);
+POWER_EVENT_ATTR(MRK_LSU_FIN,                  MRK_LSU_FIN);
+POWER_EVENT_ATTR(MRK_DATA_FROM_RL2L3_SHR,      MRK_DATA_FROM_RL2L3_SHR);
+POWER_EVENT_ATTR(DTLB_MISS_16M,                DTLB_MISS_16M);
+POWER_EVENT_ATTR(LSU1_LMQ_LHR_MERGE,           LSU1_LMQ_LHR_MERGE);
+POWER_EVENT_ATTR(IFU_FIN,                      IFU_FIN);
 
 static struct attribute *power7_events_attr[] = {
 	GENERIC_EVENT_PTR(CYC),
@@ -451,39 +1466,543 @@ static struct attribute *power7_events_attr[] = {
 	GENERIC_EVENT_PTR(BRU_FIN),
 	GENERIC_EVENT_PTR(BR_MPRED),
 
-	POWER_EVENT_PTR(CYC),
-	POWER_EVENT_PTR(GCT_NOSLOT_CYC),
-	POWER_EVENT_PTR(CMPLU_STALL),
-	POWER_EVENT_PTR(INST_CMPL),
-	POWER_EVENT_PTR(LD_REF_L1),
-	POWER_EVENT_PTR(LD_MISS_L1),
-	POWER_EVENT_PTR(BRU_FIN),
-	POWER_EVENT_PTR(BR_MPRED),
-
+	POWER_EVENT_PTR(IC_DEMAND_L2_BR_ALL),
+	POWER_EVENT_PTR(GCT_UTIL_7_TO_10_SLOTS),
+	POWER_EVENT_PTR(PMC2_SAVED),
+	POWER_EVENT_PTR(CMPLU_STALL_DFU),
+	POWER_EVENT_PTR(VSU0_16FLOP),
+	POWER_EVENT_PTR(MRK_LSU_DERAT_MISS),
+	POWER_EVENT_PTR(MRK_ST_CMPL),
+	POWER_EVENT_PTR(NEST_PAIR3_ADD),
+	POWER_EVENT_PTR(L2_ST_DISP),
+	POWER_EVENT_PTR(L2_CASTOUT_MOD),
+	POWER_EVENT_PTR(ISEG),
+	POWER_EVENT_PTR(MRK_INST_TIMEO),
+	POWER_EVENT_PTR(L2_RCST_DISP_FAIL_ADDR),
+	POWER_EVENT_PTR(LSU1_DC_PREF_STREAM_CONFIRM),
+	POWER_EVENT_PTR(IERAT_WR_64K),
+	POWER_EVENT_PTR(MRK_DTLB_MISS_16M),
+	POWER_EVENT_PTR(IERAT_MISS),
+	POWER_EVENT_PTR(MRK_PTEG_FROM_LMEM),
+	POWER_EVENT_PTR(FLOP),
+	POWER_EVENT_PTR(THRD_PRIO_4_5_CYC),
+	POWER_EVENT_PTR(BR_PRED_TA),
 	POWER_EVENT_PTR(CMPLU_STALL_FXU),
-	POWER_EVENT_PTR(CMPLU_STALL_DIV),
-	POWER_EVENT_PTR(CMPLU_STALL_SCALAR),
-	POWER_EVENT_PTR(CMPLU_STALL_SCALAR_LONG),
+	POWER_EVENT_PTR(EXT_INT),
+	POWER_EVENT_PTR(VSU_FSQRT_FDIV),
+	POWER_EVENT_PTR(MRK_LD_MISS_EXPOSED_CYC),
+	POWER_EVENT_PTR(LSU1_LDF),
+	POWER_EVENT_PTR(IC_WRITE_ALL),
+	POWER_EVENT_PTR(LSU0_SRQ_STFWD),
+	POWER_EVENT_PTR(PTEG_FROM_RL2L3_MOD),
+	POWER_EVENT_PTR(MRK_DATA_FROM_L31_SHR),
+	POWER_EVENT_PTR(DATA_FROM_L21_MOD),
+	POWER_EVENT_PTR(VSU1_SCAL_DOUBLE_ISSUED),
+	POWER_EVENT_PTR(VSU0_8FLOP),
+	POWER_EVENT_PTR(POWER_EVENT1),
+	POWER_EVENT_PTR(DISP_CLB_HELD_BAL),
+	POWER_EVENT_PTR(VSU1_2FLOP),
+	POWER_EVENT_PTR(LWSYNC_HELD),
+	POWER_EVENT_PTR(PTEG_FROM_DL2L3_SHR),
+	POWER_EVENT_PTR(INST_FROM_L21_MOD),
+	POWER_EVENT_PTR(IERAT_XLATE_WR_16MPLUS),
+	POWER_EVENT_PTR(IC_REQ_ALL),
+	POWER_EVENT_PTR(DSLB_MISS),
+	POWER_EVENT_PTR(L3_MISS),
+	POWER_EVENT_PTR(LSU0_L1_PREF),
+	POWER_EVENT_PTR(VSU_SCALAR_SINGLE_ISSUED),
+	POWER_EVENT_PTR(LSU1_DC_PREF_STREAM_CONFIRM_STRIDE),
+	POWER_EVENT_PTR(L2_INST),
+	POWER_EVENT_PTR(VSU0_FRSP),
+	POWER_EVENT_PTR(FLUSH_DISP),
+	POWER_EVENT_PTR(PTEG_FROM_L2MISS),
+	POWER_EVENT_PTR(VSU1_DQ_ISSUED),
+	POWER_EVENT_PTR(CMPLU_STALL_LSU),
+	POWER_EVENT_PTR(MRK_DATA_FROM_DMEM),
+	POWER_EVENT_PTR(LSU_FLUSH_ULD),
+	POWER_EVENT_PTR(PTEG_FROM_LMEM),
+	POWER_EVENT_PTR(MRK_DERAT_MISS_16M),
+	POWER_EVENT_PTR(THRD_ALL_RUN_CYC),
+	POWER_EVENT_PTR(MEM0_PREFETCH_DISP),
+	POWER_EVENT_PTR(MRK_STALL_CMPLU_CYC_COUNT),
+	POWER_EVENT_PTR(DATA_FROM_DL2L3_MOD),
+	POWER_EVENT_PTR(VSU_FRSP),
+	POWER_EVENT_PTR(MRK_DATA_FROM_L21_MOD),
+	POWER_EVENT_PTR(PMC1_OVERFLOW),
+	POWER_EVENT_PTR(VSU0_SINGLE),
+	POWER_EVENT_PTR(MRK_PTEG_FROM_L3MISS),
+	POWER_EVENT_PTR(MRK_PTEG_FROM_L31_SHR),
+	POWER_EVENT_PTR(VSU0_VECTOR_SP_ISSUED),
+	POWER_EVENT_PTR(VSU1_FEST),
+	POWER_EVENT_PTR(MRK_INST_DISP),
+	POWER_EVENT_PTR(VSU0_COMPLEX_ISSUED),
+	POWER_EVENT_PTR(LSU1_FLUSH_UST),
+	POWER_EVENT_PTR(INST_CMPL),
+	POWER_EVENT_PTR(FXU_IDLE),
+	POWER_EVENT_PTR(LSU0_FLUSH_ULD),
+	POWER_EVENT_PTR(MRK_DATA_FROM_DL2L3_MOD),
+	POWER_EVENT_PTR(LSU_LMQ_SRQ_EMPTY_ALL_CYC),
+	POWER_EVENT_PTR(LSU1_REJECT_LMQ_FULL),
+	POWER_EVENT_PTR(INST_PTEG_FROM_L21_MOD),
+	POWER_EVENT_PTR(INST_FROM_RL2L3_MOD),
+	POWER_EVENT_PTR(SHL_CREATED),
+	POWER_EVENT_PTR(L2_ST_HIT),
+	POWER_EVENT_PTR(DATA_FROM_DMEM),
+	POWER_EVENT_PTR(L3_LD_MISS),
+	POWER_EVENT_PTR(FXU1_BUSY_FXU0_IDLE),
+	POWER_EVENT_PTR(DISP_CLB_HELD_RES),
+	POWER_EVENT_PTR(L2_SN_SX_I_DONE),
+	POWER_EVENT_PTR(GRP_CMPL),
+	POWER_EVENT_PTR(STCX_CMPL),
+	POWER_EVENT_PTR(VSU0_2FLOP),
+	POWER_EVENT_PTR(L3_PREF_MISS),
+	POWER_EVENT_PTR(LSU_SRQ_SYNC_CYC),
+	POWER_EVENT_PTR(LSU_REJECT_ERAT_MISS),
+	POWER_EVENT_PTR(L1_ICACHE_MISS),
+	POWER_EVENT_PTR(LSU1_FLUSH_SRQ),
+	POWER_EVENT_PTR(LD_REF_L1_LSU0),
+	POWER_EVENT_PTR(VSU0_FEST),
+	POWER_EVENT_PTR(VSU_VECTOR_SINGLE_ISSUED),
+	POWER_EVENT_PTR(FREQ_UP),
+	POWER_EVENT_PTR(DATA_FROM_LMEM),
+	POWER_EVENT_PTR(LSU1_LDX),
+	POWER_EVENT_PTR(PMC3_OVERFLOW),
+	POWER_EVENT_PTR(MRK_BR_MPRED),
+	POWER_EVENT_PTR(SHL_MATCH),
+	POWER_EVENT_PTR(MRK_BR_TAKEN),
+	POWER_EVENT_PTR(CMPLU_STALL_BRU),
+	POWER_EVENT_PTR(ISLB_MISS),
+	POWER_EVENT_PTR(CYC),
+	POWER_EVENT_PTR(DISP_HELD_THERMAL),
+	POWER_EVENT_PTR(INST_PTEG_FROM_RL2L3_SHR),
+	POWER_EVENT_PTR(LSU1_SRQ_STFWD),
+	POWER_EVENT_PTR(GCT_NOSLOT_BR_MPRED),
+	POWER_EVENT_PTR(1PLUS_PPC_CMPL),
+	POWER_EVENT_PTR(PTEG_FROM_DMEM),
+	POWER_EVENT_PTR(VSU_2FLOP),
+	POWER_EVENT_PTR(GCT_FULL_CYC),
+	POWER_EVENT_PTR(MRK_DATA_FROM_L3_CYC),
+	POWER_EVENT_PTR(LSU_SRQ_S0_ALLOC),
+	POWER_EVENT_PTR(MRK_DERAT_MISS_4K),
+	POWER_EVENT_PTR(BR_MPRED_TA),
+	POWER_EVENT_PTR(INST_PTEG_FROM_L2MISS),
+	POWER_EVENT_PTR(DPU_HELD_POWER),
+	POWER_EVENT_PTR(RUN_INST_CMPL),
+	POWER_EVENT_PTR(MRK_VSU_FIN),
+	POWER_EVENT_PTR(LSU_SRQ_S0_VALID),
+	POWER_EVENT_PTR(GCT_EMPTY_CYC),
+	POWER_EVENT_PTR(IOPS_DISP),
+	POWER_EVENT_PTR(RUN_SPURR),
+	POWER_EVENT_PTR(PTEG_FROM_L21_MOD),
+	POWER_EVENT_PTR(VSU0_1FLOP),
+	POWER_EVENT_PTR(SNOOP_TLBIE),
+	POWER_EVENT_PTR(DATA_FROM_L3MISS),
+	POWER_EVENT_PTR(VSU_SINGLE),
+	POWER_EVENT_PTR(DTLB_MISS_16G),
 	POWER_EVENT_PTR(CMPLU_STALL_VECTOR),
+	POWER_EVENT_PTR(FLUSH),
+	POWER_EVENT_PTR(L2_LD_HIT),
+	POWER_EVENT_PTR(NEST_PAIR2_AND),
+	POWER_EVENT_PTR(VSU1_1FLOP),
+	POWER_EVENT_PTR(IC_PREF_REQ),
+	POWER_EVENT_PTR(L3_LD_HIT),
+	POWER_EVENT_PTR(GCT_NOSLOT_IC_MISS),
+	POWER_EVENT_PTR(DISP_HELD),
+	POWER_EVENT_PTR(L2_LD),
+	POWER_EVENT_PTR(LSU_FLUSH_SRQ),
+	POWER_EVENT_PTR(BC_PLUS_8_CONV),
+	POWER_EVENT_PTR(MRK_DATA_FROM_L31_MOD_CYC),
 	POWER_EVENT_PTR(CMPLU_STALL_VECTOR_LONG),
-	POWER_EVENT_PTR(CMPLU_STALL_LSU),
+	POWER_EVENT_PTR(L2_RCST_BUSY_RC_FULL),
+	POWER_EVENT_PTR(TB_BIT_TRANS),
+	POWER_EVENT_PTR(THERMAL_MAX),
+	POWER_EVENT_PTR(LSU1_FLUSH_ULD),
+	POWER_EVENT_PTR(LSU1_REJECT_LHS),
+	POWER_EVENT_PTR(LSU_LRQ_S0_ALLOC),
+	POWER_EVENT_PTR(L3_CO_L31),
+	POWER_EVENT_PTR(POWER_EVENT4),
+	POWER_EVENT_PTR(DATA_FROM_L31_SHR),
+	POWER_EVENT_PTR(BR_UNCOND),
+	POWER_EVENT_PTR(LSU1_DC_PREF_STREAM_ALLOC),
+	POWER_EVENT_PTR(PMC4_REWIND),
+	POWER_EVENT_PTR(L2_RCLD_DISP),
+	POWER_EVENT_PTR(THRD_PRIO_2_3_CYC),
+	POWER_EVENT_PTR(MRK_PTEG_FROM_L2MISS),
+	POWER_EVENT_PTR(IC_DEMAND_L2_BHT_REDIRECT),
+	POWER_EVENT_PTR(LSU_DERAT_MISS),
+	POWER_EVENT_PTR(IC_PREF_CANCEL_L2),
+	POWER_EVENT_PTR(MRK_FIN_STALL_CYC_COUNT),
+	POWER_EVENT_PTR(BR_PRED_CCACHE),
+	POWER_EVENT_PTR(GCT_UTIL_1_TO_2_SLOTS),
+	POWER_EVENT_PTR(MRK_ST_CMPL_INT),
+	POWER_EVENT_PTR(LSU_TWO_TABLEWALK_CYC),
+	POWER_EVENT_PTR(MRK_DATA_FROM_L3MISS),
+	POWER_EVENT_PTR(GCT_NOSLOT_CYC),
+	POWER_EVENT_PTR(LSU_SET_MPRED),
+	POWER_EVENT_PTR(FLUSH_DISP_TLBIE),
+	POWER_EVENT_PTR(VSU1_FCONV),
+	POWER_EVENT_PTR(DERAT_MISS_16G),
+	POWER_EVENT_PTR(INST_FROM_LMEM),
+	POWER_EVENT_PTR(IC_DEMAND_L2_BR_REDIRECT),
+	POWER_EVENT_PTR(CMPLU_STALL_SCALAR_LONG),
+	POWER_EVENT_PTR(INST_PTEG_FROM_L2),
+	POWER_EVENT_PTR(PTEG_FROM_L2),
+	POWER_EVENT_PTR(MRK_DATA_FROM_L21_SHR_CYC),
+	POWER_EVENT_PTR(MRK_DTLB_MISS_4K),
+	POWER_EVENT_PTR(VSU0_FPSCR),
+	POWER_EVENT_PTR(VSU1_VECT_DOUBLE_ISSUED),
+	POWER_EVENT_PTR(MRK_PTEG_FROM_RL2L3_MOD),
+	POWER_EVENT_PTR(MEM0_RQ_DISP),
+	POWER_EVENT_PTR(L2_LD_MISS),
+	POWER_EVENT_PTR(VMX_RESULT_SAT_1),
+	POWER_EVENT_PTR(L1_PREF),
+	POWER_EVENT_PTR(MRK_DATA_FROM_LMEM_CYC),
+	POWER_EVENT_PTR(GRP_IC_MISS_NONSPEC),
+	POWER_EVENT_PTR(PB_NODE_PUMP),
+	POWER_EVENT_PTR(SHL_MERGED),
+	POWER_EVENT_PTR(NEST_PAIR1_ADD),
+	POWER_EVENT_PTR(DATA_FROM_L3),
+	POWER_EVENT_PTR(LSU_FLUSH),
+	POWER_EVENT_PTR(LSU_SRQ_SYNC_COUNT),
+	POWER_EVENT_PTR(PMC2_OVERFLOW),
+	POWER_EVENT_PTR(LSU_LDF),
+	POWER_EVENT_PTR(POWER_EVENT3),
+	POWER_EVENT_PTR(DISP_WT),
 	POWER_EVENT_PTR(CMPLU_STALL_REJECT),
-
+	POWER_EVENT_PTR(IC_BANK_CONFLICT),
+	POWER_EVENT_PTR(BR_MPRED_CR_TA),
+	POWER_EVENT_PTR(L2_INST_MISS),
 	POWER_EVENT_PTR(CMPLU_STALL_ERAT_MISS),
-	POWER_EVENT_PTR(CMPLU_STALL_DCACHE_MISS),
-	POWER_EVENT_PTR(CMPLU_STALL_STORE),
+	POWER_EVENT_PTR(NEST_PAIR2_ADD),
+	POWER_EVENT_PTR(MRK_LSU_FLUSH),
+	POWER_EVENT_PTR(L2_LDST),
+	POWER_EVENT_PTR(INST_FROM_L31_SHR),
+	POWER_EVENT_PTR(VSU0_FIN),
+	POWER_EVENT_PTR(LARX_LSU),
+	POWER_EVENT_PTR(INST_FROM_RMEM),
+	POWER_EVENT_PTR(DISP_CLB_HELD_TLBIE),
+	POWER_EVENT_PTR(MRK_DATA_FROM_DMEM_CYC),
+	POWER_EVENT_PTR(BR_PRED_CR),
+	POWER_EVENT_PTR(LSU_REJECT),
+	POWER_EVENT_PTR(GCT_UTIL_3_TO_6_SLOTS),
+	POWER_EVENT_PTR(CMPLU_STALL_END_GCT_NOSLOT),
+	POWER_EVENT_PTR(LSU0_REJECT_LMQ_FULL),
+	POWER_EVENT_PTR(VSU_FEST),
+	POWER_EVENT_PTR(NEST_PAIR0_AND),
+	POWER_EVENT_PTR(PTEG_FROM_L3),
+	POWER_EVENT_PTR(POWER_EVENT2),
+	POWER_EVENT_PTR(IC_PREF_CANCEL_PAGE),
+	POWER_EVENT_PTR(VSU0_FSQRT_FDIV),
+	POWER_EVENT_PTR(MRK_GRP_CMPL),
+	POWER_EVENT_PTR(VSU0_SCAL_DOUBLE_ISSUED),
+	POWER_EVENT_PTR(GRP_DISP),
+	POWER_EVENT_PTR(LSU0_LDX),
+	POWER_EVENT_PTR(DATA_FROM_L2),
+	POWER_EVENT_PTR(MRK_DATA_FROM_RL2L3_MOD),
+	POWER_EVENT_PTR(LD_REF_L1),
+	POWER_EVENT_PTR(VSU0_VECT_DOUBLE_ISSUED),
+	POWER_EVENT_PTR(VSU1_2FLOP_DOUBLE),
+	POWER_EVENT_PTR(THRD_PRIO_6_7_CYC),
+	POWER_EVENT_PTR(BC_PLUS_8_RSLV_TAKEN),
+	POWER_EVENT_PTR(BR_MPRED_CR),
+	POWER_EVENT_PTR(L3_CO_MEM),
+	POWER_EVENT_PTR(LD_MISS_L1),
+	POWER_EVENT_PTR(DATA_FROM_RL2L3_MOD),
+	POWER_EVENT_PTR(LSU_SRQ_FULL_CYC),
+	POWER_EVENT_PTR(TABLEWALK_CYC),
+	POWER_EVENT_PTR(MRK_PTEG_FROM_RMEM),
+	POWER_EVENT_PTR(LSU_SRQ_STFWD),
+	POWER_EVENT_PTR(INST_PTEG_FROM_RMEM),
+	POWER_EVENT_PTR(FXU0_FIN),
+	POWER_EVENT_PTR(LSU1_L1_SW_PREF),
+	POWER_EVENT_PTR(PTEG_FROM_L31_MOD),
+	POWER_EVENT_PTR(PMC5_OVERFLOW),
+	POWER_EVENT_PTR(LD_REF_L1_LSU1),
+	POWER_EVENT_PTR(INST_PTEG_FROM_L21_SHR),
 	POWER_EVENT_PTR(CMPLU_STALL_THRD),
-	POWER_EVENT_PTR(CMPLU_STALL_IFU),
-	POWER_EVENT_PTR(CMPLU_STALL_BRU),
-	POWER_EVENT_PTR(GCT_NOSLOT_IC_MISS),
-	POWER_EVENT_PTR(GCT_NOSLOT_BR_MPRED),
-
+	POWER_EVENT_PTR(DATA_FROM_RMEM),
+	POWER_EVENT_PTR(VSU0_SCAL_SINGLE_ISSUED),
+	POWER_EVENT_PTR(BR_MPRED_LSTACK),
+	POWER_EVENT_PTR(MRK_DATA_FROM_RL2L3_MOD_CYC),
+	POWER_EVENT_PTR(LSU0_FLUSH_UST),
+	POWER_EVENT_PTR(LSU_NCST),
+	POWER_EVENT_PTR(BR_TAKEN),
+	POWER_EVENT_PTR(INST_PTEG_FROM_LMEM),
 	POWER_EVENT_PTR(GCT_NOSLOT_BR_MPRED_IC_MISS),
-	POWER_EVENT_PTR(GRP_CMPL),
-	POWER_EVENT_PTR(1PLUS_PPC_CMPL),
-	POWER_EVENT_PTR(CMPLU_STALL_DFU),
+	POWER_EVENT_PTR(DTLB_MISS_4K),
+	POWER_EVENT_PTR(PMC4_SAVED),
+	POWER_EVENT_PTR(VSU1_PERMUTE_ISSUED),
+	POWER_EVENT_PTR(SLB_MISS),
+	POWER_EVENT_PTR(LSU1_FLUSH_LRQ),
+	POWER_EVENT_PTR(DTLB_MISS),
+	POWER_EVENT_PTR(VSU1_FRSP),
+	POWER_EVENT_PTR(VSU_VECTOR_DOUBLE_ISSUED),
+	POWER_EVENT_PTR(L2_CASTOUT_SHR),
+	POWER_EVENT_PTR(DATA_FROM_DL2L3_SHR),
+	POWER_EVENT_PTR(VSU1_STF),
+	POWER_EVENT_PTR(ST_FIN),
+	POWER_EVENT_PTR(PTEG_FROM_L21_SHR),
+	POWER_EVENT_PTR(L2_LOC_GUESS_WRONG),
+	POWER_EVENT_PTR(MRK_STCX_FAIL),
+	POWER_EVENT_PTR(LSU0_REJECT_LHS),
+	POWER_EVENT_PTR(IC_PREF_CANCEL_HIT),
+	POWER_EVENT_PTR(L3_PREF_BUSY),
+	POWER_EVENT_PTR(MRK_BRU_FIN),
+	POWER_EVENT_PTR(LSU1_NCLD),
+	POWER_EVENT_PTR(INST_PTEG_FROM_L31_MOD),
+	POWER_EVENT_PTR(LSU_NCLD),
+	POWER_EVENT_PTR(LSU_LDX),
+	POWER_EVENT_PTR(L2_LOC_GUESS_CORRECT),
+	POWER_EVENT_PTR(THRESH_TIMEO),
+	POWER_EVENT_PTR(L3_PREF_ST),
+	POWER_EVENT_PTR(DISP_CLB_HELD_SYNC),
+	POWER_EVENT_PTR(VSU_SIMPLE_ISSUED),
+	POWER_EVENT_PTR(VSU1_SINGLE),
+	POWER_EVENT_PTR(DATA_TABLEWALK_CYC),
+	POWER_EVENT_PTR(L2_RC_ST_DONE),
+	POWER_EVENT_PTR(MRK_PTEG_FROM_L21_MOD),
+	POWER_EVENT_PTR(LARX_LSU1),
+	POWER_EVENT_PTR(MRK_DATA_FROM_RMEM),
+	POWER_EVENT_PTR(DISP_CLB_HELD),
+	POWER_EVENT_PTR(DERAT_MISS_4K),
+	POWER_EVENT_PTR(L2_RCLD_DISP_FAIL_ADDR),
+	POWER_EVENT_PTR(SEG_EXCEPTION),
+	POWER_EVENT_PTR(FLUSH_DISP_SB),
+	POWER_EVENT_PTR(L2_DC_INV),
+	POWER_EVENT_PTR(PTEG_FROM_DL2L3_MOD),
+	POWER_EVENT_PTR(DSEG),
+	POWER_EVENT_PTR(BR_PRED_LSTACK),
+	POWER_EVENT_PTR(VSU0_STF),
+	POWER_EVENT_PTR(LSU_FX_FIN),
+	POWER_EVENT_PTR(DERAT_MISS_16M),
+	POWER_EVENT_PTR(MRK_PTEG_FROM_DL2L3_MOD),
+	POWER_EVENT_PTR(GCT_UTIL_11_PLUS_SLOTS),
+	POWER_EVENT_PTR(INST_FROM_L3),
+	POWER_EVENT_PTR(MRK_IFU_FIN),
+	POWER_EVENT_PTR(ITLB_MISS),
+	POWER_EVENT_PTR(VSU_STF),
+	POWER_EVENT_PTR(LSU_FLUSH_UST),
+	POWER_EVENT_PTR(L2_LDST_MISS),
+	POWER_EVENT_PTR(FXU1_FIN),
+	POWER_EVENT_PTR(SHL_DEALLOCATED),
+	POWER_EVENT_PTR(L2_SN_M_WR_DONE),
+	POWER_EVENT_PTR(LSU_REJECT_SET_MPRED),
+	POWER_EVENT_PTR(L3_PREF_LD),
+	POWER_EVENT_PTR(L2_SN_M_RD_DONE),
+	POWER_EVENT_PTR(MRK_DERAT_MISS_16G),
+	POWER_EVENT_PTR(VSU_FCONV),
+	POWER_EVENT_PTR(ANY_THRD_RUN_CYC),
+	POWER_EVENT_PTR(LSU_LMQ_FULL_CYC),
+	POWER_EVENT_PTR(MRK_LSU_REJECT_LHS),
+	POWER_EVENT_PTR(MRK_LD_MISS_L1_CYC),
+	POWER_EVENT_PTR(MRK_DATA_FROM_L2_CYC),
+	POWER_EVENT_PTR(INST_IMC_MATCH_DISP),
+	POWER_EVENT_PTR(MRK_DATA_FROM_RMEM_CYC),
+	POWER_EVENT_PTR(VSU0_SIMPLE_ISSUED),
+	POWER_EVENT_PTR(CMPLU_STALL_DIV),
+	POWER_EVENT_PTR(MRK_PTEG_FROM_RL2L3_SHR),
+	POWER_EVENT_PTR(VSU_FMA_DOUBLE),
+	POWER_EVENT_PTR(VSU_4FLOP),
+	POWER_EVENT_PTR(VSU1_FIN),
+	POWER_EVENT_PTR(NEST_PAIR1_AND),
+	POWER_EVENT_PTR(INST_PTEG_FROM_RL2L3_MOD),
 	POWER_EVENT_PTR(RUN_CYC),
-	POWER_EVENT_PTR(RUN_INST_CMPL),
+	POWER_EVENT_PTR(PTEG_FROM_RMEM),
+	POWER_EVENT_PTR(LSU_LRQ_S0_VALID),
+	POWER_EVENT_PTR(LSU0_LDF),
+	POWER_EVENT_PTR(FLUSH_COMPLETION),
+	POWER_EVENT_PTR(ST_MISS_L1),
+	POWER_EVENT_PTR(L2_NODE_PUMP),
+	POWER_EVENT_PTR(INST_FROM_DL2L3_SHR),
+	POWER_EVENT_PTR(MRK_STALL_CMPLU_CYC),
+	POWER_EVENT_PTR(VSU1_DENORM),
+	POWER_EVENT_PTR(MRK_DATA_FROM_L31_SHR_CYC),
+	POWER_EVENT_PTR(NEST_PAIR0_ADD),
+	POWER_EVENT_PTR(INST_FROM_L3MISS),
+	POWER_EVENT_PTR(EE_OFF_EXT_INT),
+	POWER_EVENT_PTR(INST_PTEG_FROM_DMEM),
+	POWER_EVENT_PTR(INST_FROM_DL2L3_MOD),
+	POWER_EVENT_PTR(PMC6_OVERFLOW),
+	POWER_EVENT_PTR(VSU_2FLOP_DOUBLE),
+	POWER_EVENT_PTR(TLB_MISS),
+	POWER_EVENT_PTR(FXU_BUSY),
+	POWER_EVENT_PTR(L2_RCLD_DISP_FAIL_OTHER),
+	POWER_EVENT_PTR(LSU_REJECT_LMQ_FULL),
+	POWER_EVENT_PTR(IC_RELOAD_SHR),
+	POWER_EVENT_PTR(GRP_MRK),
+	POWER_EVENT_PTR(MRK_ST_NEST),
+	POWER_EVENT_PTR(VSU1_FSQRT_FDIV),
+	POWER_EVENT_PTR(LSU0_FLUSH_LRQ),
+	POWER_EVENT_PTR(LARX_LSU0),
+	POWER_EVENT_PTR(IBUF_FULL_CYC),
+	POWER_EVENT_PTR(MRK_DATA_FROM_DL2L3_SHR_CYC),
+	POWER_EVENT_PTR(LSU_DC_PREF_STREAM_ALLOC),
+	POWER_EVENT_PTR(GRP_MRK_CYC),
+	POWER_EVENT_PTR(MRK_DATA_FROM_RL2L3_SHR_CYC),
+	POWER_EVENT_PTR(L2_GLOB_GUESS_CORRECT),
+	POWER_EVENT_PTR(LSU_REJECT_LHS),
+	POWER_EVENT_PTR(MRK_DATA_FROM_LMEM),
+	POWER_EVENT_PTR(INST_PTEG_FROM_L3),
+	POWER_EVENT_PTR(FREQ_DOWN),
+	POWER_EVENT_PTR(PB_RETRY_NODE_PUMP),
+	POWER_EVENT_PTR(INST_FROM_RL2L3_SHR),
+	POWER_EVENT_PTR(MRK_INST_ISSUED),
+	POWER_EVENT_PTR(PTEG_FROM_L3MISS),
+	POWER_EVENT_PTR(RUN_PURR),
+	POWER_EVENT_PTR(MRK_GRP_IC_MISS),
+	POWER_EVENT_PTR(MRK_DATA_FROM_L3),
+	POWER_EVENT_PTR(CMPLU_STALL_DCACHE_MISS),
+	POWER_EVENT_PTR(PTEG_FROM_RL2L3_SHR),
+	POWER_EVENT_PTR(LSU_FLUSH_LRQ),
+	POWER_EVENT_PTR(MRK_DERAT_MISS_64K),
+	POWER_EVENT_PTR(INST_PTEG_FROM_DL2L3_MOD),
+	POWER_EVENT_PTR(L2_ST_MISS),
+	POWER_EVENT_PTR(MRK_PTEG_FROM_L21_SHR),
+	POWER_EVENT_PTR(LWSYNC),
+	POWER_EVENT_PTR(LSU0_DC_PREF_STREAM_CONFIRM_STRIDE),
+	POWER_EVENT_PTR(MRK_LSU_FLUSH_LRQ),
+	POWER_EVENT_PTR(INST_IMC_MATCH_CMPL),
+	POWER_EVENT_PTR(NEST_PAIR3_AND),
+	POWER_EVENT_PTR(PB_RETRY_SYS_PUMP),
+	POWER_EVENT_PTR(MRK_INST_FIN),
+	POWER_EVENT_PTR(MRK_PTEG_FROM_DL2L3_SHR),
+	POWER_EVENT_PTR(INST_FROM_L31_MOD),
+	POWER_EVENT_PTR(MRK_DTLB_MISS_64K),
+	POWER_EVENT_PTR(LSU_FIN),
+	POWER_EVENT_PTR(MRK_LSU_REJECT),
+	POWER_EVENT_PTR(L2_CO_FAIL_BUSY),
+	POWER_EVENT_PTR(MEM0_WQ_DISP),
+	POWER_EVENT_PTR(DATA_FROM_L31_MOD),
+	POWER_EVENT_PTR(THERMAL_WARN),
+	POWER_EVENT_PTR(VSU0_4FLOP),
+	POWER_EVENT_PTR(BR_MPRED_CCACHE),
+	POWER_EVENT_PTR(CMPLU_STALL_IFU),
+	POWER_EVENT_PTR(L1_DEMAND_WRITE),
+	POWER_EVENT_PTR(FLUSH_BR_MPRED),
+	POWER_EVENT_PTR(MRK_DTLB_MISS_16G),
+	POWER_EVENT_PTR(MRK_PTEG_FROM_DMEM),
+	POWER_EVENT_PTR(L2_RCST_DISP),
+	POWER_EVENT_PTR(CMPLU_STALL),
+	POWER_EVENT_PTR(LSU_PARTIAL_CDF),
+	POWER_EVENT_PTR(DISP_CLB_HELD_SB),
+	POWER_EVENT_PTR(VSU0_FMA_DOUBLE),
+	POWER_EVENT_PTR(FXU0_BUSY_FXU1_IDLE),
+	POWER_EVENT_PTR(IC_DEMAND_CYC),
+	POWER_EVENT_PTR(MRK_DATA_FROM_L21_SHR),
+	POWER_EVENT_PTR(MRK_LSU_FLUSH_UST),
+	POWER_EVENT_PTR(INST_PTEG_FROM_L3MISS),
+	POWER_EVENT_PTR(VSU_DENORM),
+	POWER_EVENT_PTR(MRK_LSU_PARTIAL_CDF),
+	POWER_EVENT_PTR(INST_FROM_L21_SHR),
+	POWER_EVENT_PTR(IC_PREF_WRITE),
+	POWER_EVENT_PTR(BR_PRED),
+	POWER_EVENT_PTR(INST_FROM_DMEM),
+	POWER_EVENT_PTR(IC_PREF_CANCEL_ALL),
+	POWER_EVENT_PTR(LSU_DC_PREF_STREAM_CONFIRM),
+	POWER_EVENT_PTR(MRK_LSU_FLUSH_SRQ),
+	POWER_EVENT_PTR(MRK_FIN_STALL_CYC),
+	POWER_EVENT_PTR(L2_RCST_DISP_FAIL_OTHER),
+	POWER_EVENT_PTR(VSU1_DD_ISSUED),
+	POWER_EVENT_PTR(PTEG_FROM_L31_SHR),
+	POWER_EVENT_PTR(DATA_FROM_L21_SHR),
+	POWER_EVENT_PTR(LSU0_NCLD),
+	POWER_EVENT_PTR(VSU1_4FLOP),
+	POWER_EVENT_PTR(VSU1_8FLOP),
+	POWER_EVENT_PTR(VSU_8FLOP),
+	POWER_EVENT_PTR(LSU_LMQ_SRQ_EMPTY_CYC),
+	POWER_EVENT_PTR(DTLB_MISS_64K),
+	POWER_EVENT_PTR(THRD_CONC_RUN_INST),
+	POWER_EVENT_PTR(MRK_PTEG_FROM_L2),
+	POWER_EVENT_PTR(PB_SYS_PUMP),
+	POWER_EVENT_PTR(VSU_FIN),
+	POWER_EVENT_PTR(MRK_DATA_FROM_L31_MOD),
+	POWER_EVENT_PTR(THRD_PRIO_0_1_CYC),
+	POWER_EVENT_PTR(DERAT_MISS_64K),
+	POWER_EVENT_PTR(PMC2_REWIND),
+	POWER_EVENT_PTR(INST_FROM_L2),
+	POWER_EVENT_PTR(GRP_BR_MPRED_NONSPEC),
+	POWER_EVENT_PTR(INST_DISP),
+	POWER_EVENT_PTR(MEM0_RD_CANCEL_TOTAL),
+	POWER_EVENT_PTR(LSU0_DC_PREF_STREAM_CONFIRM),
+	POWER_EVENT_PTR(L1_DCACHE_RELOAD_VALID),
+	POWER_EVENT_PTR(VSU_SCALAR_DOUBLE_ISSUED),
+	POWER_EVENT_PTR(L3_PREF_HIT),
+	POWER_EVENT_PTR(MRK_PTEG_FROM_L31_MOD),
+	POWER_EVENT_PTR(CMPLU_STALL_STORE),
+	POWER_EVENT_PTR(MRK_FXU_FIN),
+	POWER_EVENT_PTR(PMC4_OVERFLOW),
+	POWER_EVENT_PTR(MRK_PTEG_FROM_L3),
+	POWER_EVENT_PTR(LSU0_LMQ_LHR_MERGE),
+	POWER_EVENT_PTR(BTAC_HIT),
+	POWER_EVENT_PTR(L3_RD_BUSY),
+	POWER_EVENT_PTR(LSU0_L1_SW_PREF),
+	POWER_EVENT_PTR(INST_FROM_L2MISS),
+	POWER_EVENT_PTR(LSU0_DC_PREF_STREAM_ALLOC),
+	POWER_EVENT_PTR(L2_ST),
+	POWER_EVENT_PTR(VSU0_DENORM),
+	POWER_EVENT_PTR(MRK_DATA_FROM_DL2L3_SHR),
+	POWER_EVENT_PTR(BR_PRED_CR_TA),
+	POWER_EVENT_PTR(VSU0_FCONV),
+	POWER_EVENT_PTR(MRK_LSU_FLUSH_ULD),
+	POWER_EVENT_PTR(BTAC_MISS),
+	POWER_EVENT_PTR(MRK_LD_MISS_EXPOSED_CYC_COUNT),
+	POWER_EVENT_PTR(MRK_DATA_FROM_L2),
+	POWER_EVENT_PTR(LSU_DCACHE_RELOAD_VALID),
+	POWER_EVENT_PTR(VSU_FMA),
+	POWER_EVENT_PTR(LSU0_FLUSH_SRQ),
+	POWER_EVENT_PTR(LSU1_L1_PREF),
+	POWER_EVENT_PTR(IOPS_CMPL),
+	POWER_EVENT_PTR(L2_SYS_PUMP),
+	POWER_EVENT_PTR(L2_RCLD_BUSY_RC_FULL),
+	POWER_EVENT_PTR(LSU_LMQ_S0_ALLOC),
+	POWER_EVENT_PTR(FLUSH_DISP_SYNC),
+	POWER_EVENT_PTR(MRK_DATA_FROM_DL2L3_MOD_CYC),
+	POWER_EVENT_PTR(L2_IC_INV),
+	POWER_EVENT_PTR(MRK_DATA_FROM_L21_MOD_CYC),
+	POWER_EVENT_PTR(L3_PREF_LDST),
+	POWER_EVENT_PTR(LSU_SRQ_EMPTY_CYC),
+	POWER_EVENT_PTR(LSU_LMQ_S0_VALID),
+	POWER_EVENT_PTR(FLUSH_PARTIAL),
+	POWER_EVENT_PTR(VSU1_FMA_DOUBLE),
+	POWER_EVENT_PTR(1PLUS_PPC_DISP),
+	POWER_EVENT_PTR(DATA_FROM_L2MISS),
+	POWER_EVENT_PTR(SUSPENDED),
+	POWER_EVENT_PTR(VSU0_FMA),
+	POWER_EVENT_PTR(CMPLU_STALL_SCALAR),
+	POWER_EVENT_PTR(STCX_FAIL),
+	POWER_EVENT_PTR(VSU0_FSQRT_FDIV_DOUBLE),
+	POWER_EVENT_PTR(DC_PREF_DST),
+	POWER_EVENT_PTR(VSU1_SCAL_SINGLE_ISSUED),
+	POWER_EVENT_PTR(L3_HIT),
+	POWER_EVENT_PTR(L2_GLOB_GUESS_WRONG),
+	POWER_EVENT_PTR(MRK_DFU_FIN),
+	POWER_EVENT_PTR(INST_FROM_L1),
+	POWER_EVENT_PTR(BRU_FIN),
+	POWER_EVENT_PTR(IC_DEMAND_REQ),
+	POWER_EVENT_PTR(VSU1_FSQRT_FDIV_DOUBLE),
+	POWER_EVENT_PTR(VSU1_FMA),
+	POWER_EVENT_PTR(MRK_LD_MISS_L1),
+	POWER_EVENT_PTR(VSU0_2FLOP_DOUBLE),
+	POWER_EVENT_PTR(LSU_DC_PREF_STRIDED_STREAM_CONFIRM),
+	POWER_EVENT_PTR(INST_PTEG_FROM_L31_SHR),
+	POWER_EVENT_PTR(MRK_LSU_REJECT_ERAT_MISS),
+	POWER_EVENT_PTR(MRK_DATA_FROM_L2MISS),
+	POWER_EVENT_PTR(DATA_FROM_RL2L3_SHR),
+	POWER_EVENT_PTR(INST_FROM_PREF),
+	POWER_EVENT_PTR(VSU1_SQ),
+	POWER_EVENT_PTR(L2_LD_DISP),
+	POWER_EVENT_PTR(L2_DISP_ALL),
+	POWER_EVENT_PTR(THRD_GRP_CMPL_BOTH_CYC),
+	POWER_EVENT_PTR(VSU_FSQRT_FDIV_DOUBLE),
+	POWER_EVENT_PTR(BR_MPRED),
+	POWER_EVENT_PTR(INST_PTEG_FROM_DL2L3_SHR),
+	POWER_EVENT_PTR(VSU_1FLOP),
+	POWER_EVENT_PTR(HV_CYC),
+	POWER_EVENT_PTR(MRK_LSU_FIN),
+	POWER_EVENT_PTR(MRK_DATA_FROM_RL2L3_SHR),
+	POWER_EVENT_PTR(DTLB_MISS_16M),
+	POWER_EVENT_PTR(LSU1_LMQ_LHR_MERGE),
+	POWER_EVENT_PTR(IFU_FIN),
 	NULL
 };
 
-- 
1.7.9.5

