Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934159AbaEMPFJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:05:09 -0400
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:40058 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934158AbaEMPAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:00:30 -0400
From: Michael Mueller <mimu@linux.vnet.ibm.com>
To: qemu-devel@nongnu.org, kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Alexander Graf <agraf@suse.de>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Andreas Faerber <afaerber@suse.de>,
        "Jason J. Herne" <jjherne@linux.vnet.ibm.com>, mimu@linux.vnet.ibm.com
Subject: [PATCH v1 RFC 03/10] QEMU: s390: cpu model facilities support
Date: Tue, 13 May 2014 17:00:15 +0200
Message-Id: <1399993222-16339-4-git-send-email-mimu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1399993222-16339-1-git-send-email-mimu@linux.vnet.ibm.com>
References: <1399993222-16339-1-git-send-email-mimu@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051315-6892-0000-0000-000008C5CAD1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch defines S390 cpu facilities and their presence at the
different cpu model levels. The implemented functions allow to
calculate cpu model specific facility sets. These sets are associated
to the defined cpu classes used to calculate the list of supported
cpu models.

Signed-off-by: Michael Mueller <mimu@linux.vnet.ibm.com>
---
 target-s390x/cpu-models.c |  27 +++++-
 target-s390x/cpu-models.h | 234 ++++++++++++++++++++++++++++++++++++++++++++++
 target-s390x/cpu.c        |   3 +
 3 files changed, 262 insertions(+), 2 deletions(-)

diff --git a/target-s390x/cpu-models.c b/target-s390x/cpu-models.c
index 8f1fa64..e437bd0 100644
--- a/target-s390x/cpu-models.c
+++ b/target-s390x/cpu-models.c
@@ -13,6 +13,9 @@
 #include "cpu.h"
 #include "cpu-models.h"
 
+#define S390_FAC_NAME(n, _cpu_id)               \
+    glue(glue(glue(FAC, n), _), _cpu_id)
+
 #define S390_PROC_DEF(_name, _cpu_id, _desc)                            \
     static void                                                         \
     glue(_cpu_id, _cpu_class_init)                                      \
@@ -23,7 +26,7 @@
                                                                         \
         cc->is_active   = true;                                         \
         cc->is_host     = false;                                        \
-        cc->fac_list    = NULL;                                         \
+        cc->fac_list    = g_malloc0(S390_ARCH_FAC_LIST_SIZE_BYTE);      \
         cc->mach        = g_malloc0(sizeof(S390CPUMachineProps));       \
         cc->mach->ga    = cpu_ga(_cpu_id);                              \
         cc->mach->class = cpu_class(_cpu_id);                           \
@@ -34,7 +37,9 @@
         cc->proc->id    = S390_DEF_ID;                                  \
         cc->proc->type  = cpu_type(_cpu_id);                            \
         cc->proc->ibc   = S390_DEF_IBC;                                 \
-        cc->proc->fac_list = NULL;                                      \
+        cc->proc->fac_list = g_malloc0(S390_ARCH_FAC_LIST_SIZE_BYTE);   \
+        cc->proc->fac_list[0] = S390_FAC_NAME(0, _cpu_id);              \
+        cc->proc->fac_list[1] = S390_FAC_NAME(1, _cpu_id);              \
         dc->desc        = _desc;                                        \
     }                                                                   \
     static const TypeInfo                                               \
@@ -80,3 +85,21 @@ S390_PROC_DEF("2818-ga1", CPU_S390_2818_GA1, "IBM zEnterprise 114 GA1")
 S390_PROC_DEF("2827-ga1", CPU_S390_2827_GA1, "IBM zEnterprise EC12 GA1")
 S390_PROC_DEF("2827-ga2", CPU_S390_2827_GA2, "IBM zEnterprise EC12 GA2")
 S390_PROC_DEF("2828-ga1", CPU_S390_2828_GA1, "IBM zEnterprise BC12 GA1")
+
+static inline unsigned long bit_in_word(unsigned int nr)
+{
+    return 1ul << (__WORDSIZE - 1 - (nr % __WORDSIZE));
+};
+
+/* test a specific bit in facility set to be set */
+static inline int test_facility(unsigned long nr, unsigned long *fac_list)
+{
+    unsigned long *ptr;
+
+    if (nr >= S390_FAC_LIST_SIZE_BIT) {
+        return 0;
+    }
+    ptr = fac_list + (nr / __WORDSIZE);
+
+    return (*ptr & bit_in_word(nr)) != 0;
+}
diff --git a/target-s390x/cpu-models.h b/target-s390x/cpu-models.h
index 4abd39a..6f9a1a1 100644
--- a/target-s390x/cpu-models.h
+++ b/target-s390x/cpu-models.h
@@ -13,6 +13,20 @@
 #ifndef TARGET_S390X_CPU_MODELS_H
 #define TARGET_S390X_CPU_MODELS_H
 
+#define S390_FAC_LIST_SIZE_UINT64 2
+#define S390_FAC_LIST_SIZE_BYTE                 \
+    (S390_FAC_LIST_SIZE_UINT64 * sizeof(uint64_t))
+#define S390_FAC_LIST_SIZE_BIT                  \
+    (S390_FAC_LIST_SIZE_BYTE << 3)
+
+/* maximum size of facilities and facility mask is 2k bytes */
+#define S390_ARCH_FAC_LIST_SIZE_BYTE 2048
+#define S390_ARCH_FAC_LIST_SIZE_UINT64                  \
+    (S390_ARCH_FAC_LIST_SIZE_BYTE / sizeof(uint64_t))
+#define S390_ARCH_FAC_MASK_SIZE_BYTE S390_ARCH_FAC_LIST_SIZE_BYTE
+#define S390_ARCH_FAC_MASK_SIZE_UINT64                  \
+    (S390_ARCH_FAC_MASK_SIZE_BYTE / sizeof(uint64_t))
+
 #define S390_EC 0x1
 #define S390_BC 0x2
 
@@ -20,6 +34,9 @@
 #define S390_DEF_IBC     0x0
 #define S390_DEF_ID      0xdecade
 
+#define FAC_BIT(WORD, BIT) \
+    (BIT / 64 == WORD ? 1ull << (63 - BIT % 64) : 0)
+
 #define cpu_type(x)       (((x) >>  0) & 0xffff)
 #define cpu_order(x)      (((x) >> 16) & 0xffff)
 #define cpu_ga(x)         (((x) >> 16) & 0xf)
@@ -64,4 +81,221 @@ enum {
     CPU_S390_2828_GA1 = 0x0c212828,
 };
 
+/* S390 CPU facilities */
+typedef enum {
+    FAC_N3                              = 0,
+    FAC_ZARCH                           = 1,
+    FAC_ZARCH_ACTIVE                    = 2,
+    FAC_DAT_ENH                         = 3,
+    FAC_ASN_LX_REUSE                    = 6,
+    FAC_STFLE                           = 7,
+    FAC_ENHANCED_DAT_1                  = 8,
+    FAC_SENSE_RUNNING_STATUS            = 9,
+    FAC_CONDITIONAL_SSKE                = 10,
+    FAC_CONFIGURATION_TOPOLOGY          = 11,
+    FAC_IPTE_RANGE                      = 13,
+    FAC_NONQ_KEY_SETTING                = 14,
+    FAC_EXTENDED_TRANSLATION_2          = 16,
+    FAC_MESSAGE_SECURITY_ASSIST         = 17,
+    FAC_LONG_DISPLACEMENT               = 18,
+    FAC_LONG_DISPLACEMENT_FAST          = 19,
+    FAC_HFP_MADDSUB                     = 20,
+    FAC_EXTENDED_IMMEDIATE              = 21,
+    FAC_EXTENDED_TRANSLATION_3          = 22,
+    FAC_HFP_UNNORMALIZED_EXT            = 23,
+    FAC_ETF2_ENH                        = 24,
+    FAC_STORE_CLOCK_FAST                = 25,
+    FAC_PARSING_ENH                     = 26,
+    FAC_MOVE_WITH_OPTIONAL_SPEC         = 27,
+    FAC_TOD_CLOCK_STEERING              = 28,
+    FAC_ETF3_ENH                        = 30,
+    FAC_EXTRACT_CPU_TIME                = 31,
+    FAC_COMPARE_AND_SWAP_AND_STORE      = 32,
+    FAC_COMPARE_AND_SWAP_AND_STORE_2    = 33,
+    FAC_GENERAL_INSTRUCTIONS_EXT        = 34,
+    FAC_EXECUTE_EXT                     = 35,
+    FAC_ENHANCED_MONITOR                = 36,
+    FAC_FLOATING_POINT_EXT              = 37,
+    FAC_LOAD_PROGRAM_PARAMETERS         = 40,
+    FAC_FLOATING_POINT_SUPPPORT_ENH     = 41,
+    FAC_DFP                             = 42,
+    FAC_DFP_FAST                        = 43,
+    FAC_PFPO                            = 44,
+    FAC_MULTI_45                        = 45,
+    FAC_CMPSC_ENH                       = 47,
+    FAC_DFP_ZONED_CONVERSION            = 48,
+    FAC_MULTI_49                        = 49,
+    FAC_CONSTRAINT_TRANSACTIONAL_EXE    = 50,
+    FAC_LOCAL_TLB_CLEARING              = 51,
+    FAC_INTERLOCKED_ACCESS_2            = 52,
+    FAC_RESET_REFERENCE_BITS_MULTIPLE   = 66,
+    FAC_CPU_MEASUREMENT_COUNTER         = 67,
+    FAC_CPU_MEASUREMENT_SAMPLING        = 68,
+    FAC_TRANSACTIONAL_EXE               = 73,
+    FAC_ACCESS_EXCEPTION_FS_INDICATION  = 75,
+    FAC_MESSAGE_SECURITY_ASSIST_3       = 76,
+    FAC_MESSAGE_SECURITY_ASSIST_4       = 77,
+    FAC_ENHANCED_DAT_2                  = 78,
+} S390Facility;
+
+/* S390 CPU facility sets defined per CPU type and GA */
+#define FAC0_CPU_S390_2064_GA1                  \
+    (FAC_BIT(0, FAC_N3)                         \
+     | FAC_BIT(0, FAC_ZARCH)                    \
+     | FAC_BIT(0, FAC_ZARCH_ACTIVE))
+#define FAC1_CPU_S390_2064_GA1 0ul
+
+#define FAC0_CPU_S390_2064_GA2                           \
+    (FAC0_CPU_S390_2064_GA1                              \
+     | FAC_BIT(0, FAC_EXTENDED_TRANSLATION_2))
+#define FAC1_CPU_S390_2064_GA2 FAC1_CPU_S390_2064_GA1
+
+#define FAC0_CPU_S390_2064_GA3 FAC0_CPU_S390_2064_GA2
+#define FAC1_CPU_S390_2064_GA3 FAC1_CPU_S390_2064_GA2
+
+#define FAC0_CPU_S390_2066_GA1 FAC0_CPU_S390_2064_GA3
+#define FAC1_CPU_S390_2066_GA1 FAC1_CPU_S390_2064_GA3
+
+#define FAC0_CPU_S390_2084_GA1                            \
+    (FAC0_CPU_S390_2064_GA3                               \
+     | FAC_BIT(0, FAC_DAT_ENH)                            \
+     | FAC_BIT(0, FAC_MESSAGE_SECURITY_ASSIST)            \
+     | FAC_BIT(0, FAC_LONG_DISPLACEMENT)                  \
+     | FAC_BIT(0, FAC_LONG_DISPLACEMENT_FAST)             \
+     | FAC_BIT(0, FAC_HFP_MADDSUB))
+#define FAC1_CPU_S390_2084_GA1 FAC1_CPU_S390_2064_GA3
+
+#define FAC0_CPU_S390_2084_GA2                            \
+    (FAC0_CPU_S390_2084_GA1                               \
+     | FAC_BIT(0, 4))
+#define FAC1_CPU_S390_2084_GA2 FAC1_CPU_S390_2084_GA1
+
+#define FAC0_CPU_S390_2084_GA3                            \
+    (FAC0_CPU_S390_2084_GA2                               \
+     | FAC_BIT(0, FAC_ASN_LX_REUSE)                       \
+     | FAC_BIT(0, FAC_EXTENDED_TRANSLATION_3))
+
+#define FAC1_CPU_S390_2084_GA3 FAC1_CPU_S390_2084_GA2
+
+#define FAC0_CPU_S390_2084_GA4 FAC0_CPU_S390_2084_GA3
+#define FAC1_CPU_S390_2084_GA4 FAC1_CPU_S390_2084_GA3
+
+#define FAC0_CPU_S390_2084_GA5                                   \
+    (FAC0_CPU_S390_2084_GA4                                      \
+     | FAC_BIT(0, FAC_TOD_CLOCK_STEERING))
+#define FAC1_CPU_S390_2084_GA5 FAC1_CPU_S390_2084_GA4
+
+#define FAC0_CPU_S390_2086_GA1 FAC0_CPU_S390_2084_GA3
+#define FAC1_CPU_S390_2086_GA1 FAC1_CPU_S390_2084_GA3
+
+#define FAC0_CPU_S390_2086_GA2 FAC0_CPU_S390_2084_GA4
+#define FAC1_CPU_S390_2086_GA2 FAC1_CPU_S390_2084_GA4
+
+#define FAC0_CPU_S390_2086_GA3 FAC0_CPU_S390_2084_GA5
+#define FAC1_CPU_S390_2086_GA3 FAC1_CPU_S390_2084_GA5
+
+#define FAC0_CPU_S390_2094_GA1                                   \
+    (FAC0_CPU_S390_2084_GA5                                      \
+     | FAC_BIT(0, FAC_STFLE)                                     \
+     | FAC_BIT(0, FAC_EXTENDED_IMMEDIATE)                        \
+     | FAC_BIT(0, FAC_HFP_UNNORMALIZED_EXT)                      \
+     | FAC_BIT(0, FAC_ETF2_ENH)                                  \
+     | FAC_BIT(0, FAC_STORE_CLOCK_FAST)                          \
+     | FAC_BIT(0, FAC_ETF3_ENH)                                  \
+     | FAC_BIT(0, FAC_EXTRACT_CPU_TIME))
+#define FAC1_CPU_S390_2094_GA1 FAC1_CPU_S390_2084_GA5
+
+#define FAC0_CPU_S390_2094_GA2                                   \
+    (FAC0_CPU_S390_2094_GA1                                      \
+     | FAC_BIT(0, FAC_SENSE_RUNNING_STATUS)                      \
+     | FAC_BIT(0, FAC_MOVE_WITH_OPTIONAL_SPEC)                   \
+     | FAC_BIT(0, FAC_COMPARE_AND_SWAP_AND_STORE)                \
+     | FAC_BIT(0, FAC_FLOATING_POINT_SUPPPORT_ENH)               \
+     | FAC_BIT(0, FAC_DFP))
+#define FAC1_CPU_S390_2094_GA2 FAC1_CPU_S390_2094_GA1
+
+#define FAC0_CPU_S390_2094_GA3                                  \
+    (FAC0_CPU_S390_2094_GA2                                     \
+      | FAC_BIT(0, FAC_PFPO))
+#define FAC1_CPU_S390_2094_GA3 FAC1_CPU_S390_2094_GA2
+
+#define FAC0_CPU_S390_2096_GA1 FAC0_CPU_S390_2094_GA3
+#define FAC1_CPU_S390_2096_GA1 FAC1_CPU_S390_2094_GA3
+
+#define FAC0_CPU_S390_2096_GA2 FAC0_CPU_S390_2096_GA1
+#define FAC1_CPU_S390_2096_GA2 FAC1_CPU_S390_2096_GA1
+
+#define FAC0_CPU_S390_2097_GA1                                     \
+    (FAC0_CPU_S390_2094_GA3                                        \
+     | FAC_BIT(0, FAC_ENHANCED_DAT_1)                              \
+     | FAC_BIT(0, FAC_CONDITIONAL_SSKE)                            \
+     | FAC_BIT(0, FAC_CONFIGURATION_TOPOLOGY)                      \
+     | FAC_BIT(0, FAC_PARSING_ENH)                                 \
+     | FAC_BIT(0, FAC_COMPARE_AND_SWAP_AND_STORE_2)                \
+     | FAC_BIT(0, FAC_GENERAL_INSTRUCTIONS_EXT)                    \
+     | FAC_BIT(0, FAC_EXECUTE_EXT)                                \
+     | FAC_BIT(0, FAC_DFP_FAST))
+#define FAC1_CPU_S390_2097_GA1 FAC1_CPU_S390_2094_GA3
+
+#define FAC0_CPU_S390_2097_GA2 FAC0_CPU_S390_2097_GA1
+#define FAC1_CPU_S390_2097_GA2                                     \
+    (FAC1_CPU_S390_2097_GA1                                        \
+     | FAC_BIT(1, 65)                                              \
+     | FAC_BIT(1, FAC_CPU_MEASUREMENT_COUNTER)                     \
+     | FAC_BIT(1, FAC_CPU_MEASUREMENT_SAMPLING))
+
+#define FAC0_CPU_S390_2097_GA3                           \
+    (FAC0_CPU_S390_2097_GA2                              \
+      | FAC_BIT(0, FAC_LOAD_PROGRAM_PARAMETERS))
+#define FAC1_CPU_S390_2097_GA3 FAC1_CPU_S390_2097_GA2
+
+#define FAC0_CPU_S390_2098_GA1 FAC0_CPU_S390_2097_GA2
+#define FAC1_CPU_S390_2098_GA1 FAC1_CPU_S390_2097_GA2
+
+#define FAC0_CPU_S390_2098_GA2 FAC0_CPU_S390_2097_GA3
+#define FAC1_CPU_S390_2098_GA2 FAC1_CPU_S390_2097_GA3
+
+#define FAC0_CPU_S390_2817_GA1                                     \
+    (FAC0_CPU_S390_2097_GA3                                        \
+     | FAC_BIT(0, FAC_ENHANCED_MONITOR)                            \
+     | FAC_BIT(0, FAC_FLOATING_POINT_EXT)                          \
+     | FAC_BIT(0, FAC_MULTI_45)                                    \
+     | FAC_BIT(0, 46))
+#define FAC1_CPU_S390_2817_GA1                                     \
+    ((FAC1_CPU_S390_2097_GA3                                       \
+      & ~FAC_BIT(1, 65))                                           \
+    | FAC_BIT(1, FAC_ACCESS_EXCEPTION_FS_INDICATION))
+
+#define FAC0_CPU_S390_2817_GA2                                          \
+    (FAC0_CPU_S390_2817_GA1                                             \
+     | FAC_BIT(0, FAC_IPTE_RANGE)                                       \
+     | FAC_BIT(0, FAC_NONQ_KEY_SETTING)                                 \
+     | FAC_BIT(0, FAC_CMPSC_ENH))
+#define FAC1_CPU_S390_2817_GA2                                          \
+    (FAC1_CPU_S390_2817_GA1                                             \
+     | FAC_BIT(1, FAC_RESET_REFERENCE_BITS_MULTIPLE)                    \
+     | FAC_BIT(1, FAC_MESSAGE_SECURITY_ASSIST_3)                        \
+     | FAC_BIT(1, FAC_MESSAGE_SECURITY_ASSIST_4))
+
+#define FAC0_CPU_S390_2818_GA1 FAC0_CPU_S390_2817_GA2
+#define FAC1_CPU_S390_2818_GA1 FAC1_CPU_S390_2817_GA2
+
+#define FAC0_CPU_S390_2827_GA1                                          \
+    (FAC0_CPU_S390_2817_GA2                                             \
+     | FAC_BIT(0, FAC_DFP_ZONED_CONVERSION)                             \
+     | FAC_BIT(0, FAC_MULTI_49)                                         \
+     | FAC_BIT(0, FAC_CONSTRAINT_TRANSACTIONAL_EXE)                     \
+     | FAC_BIT(0, FAC_LOCAL_TLB_CLEARING)                               \
+     | FAC_BIT(0, FAC_INTERLOCKED_ACCESS_2))
+#define FAC1_CPU_S390_2827_GA1                           \
+    (FAC1_CPU_S390_2817_GA2                              \
+     | FAC_BIT(1, FAC_TRANSACTIONAL_EXE)                 \
+     | FAC_BIT(1, FAC_ENHANCED_DAT_2))
+
+#define FAC0_CPU_S390_2827_GA2 FAC0_CPU_S390_2827_GA1
+#define FAC1_CPU_S390_2827_GA2 FAC1_CPU_S390_2827_GA1
+
+#define FAC0_CPU_S390_2828_GA1 FAC0_CPU_S390_2827_GA2
+#define FAC1_CPU_S390_2828_GA1 FAC1_CPU_S390_2827_GA2
+
 #endif
diff --git a/target-s390x/cpu.c b/target-s390x/cpu.c
index 7fa588c..10a03f9 100644
--- a/target-s390x/cpu.c
+++ b/target-s390x/cpu.c
@@ -24,6 +24,7 @@
  */
 
 #include "cpu.h"
+#include "cpu-models.h"
 #include "qemu-common.h"
 #include "qemu/timer.h"
 #include "hw/hw.h"
@@ -258,6 +259,8 @@ static void s390_cpu_class_init(ObjectClass *oc, void *data)
     cc->gdb_num_core_regs = S390_NUM_REGS;
     scc->mach = g_malloc0(sizeof(*scc->mach));
     scc->proc = g_malloc0(sizeof(*scc->proc));
+    scc->fac_list = g_malloc0(S390_ARCH_FAC_LIST_SIZE_BYTE);
+    scc->proc->fac_list = g_malloc0(S390_ARCH_FAC_LIST_SIZE_BYTE);
 }
 
 static const TypeInfo s390_cpu_type_info = {
-- 
1.8.3.1

