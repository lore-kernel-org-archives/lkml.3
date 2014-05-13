Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965046AbaEMO7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:59:38 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:53520 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965005AbaEMO6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:58:54 -0400
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
Subject: [PATCH v1 RFC 4/6] KVM: s390: add ibc api
Date: Tue, 13 May 2014 16:58:32 +0200
Message-Id: <1399993114-15333-5-git-send-email-mimu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1399993114-15333-1-git-send-email-mimu@linux.vnet.ibm.com>
References: <1399993114-15333-1-git-send-email-mimu@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051314-8372-0000-0000-000009A98CE4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch addds an internal KVM API to access instruction blocking
control. It offers the following functions:

- has_ibc() : tests if the system offers instruction blocking control
- lowest_ibc() : first level supported
- latest_ibc() : latest level supported

Signed-off-by: Michael Mueller <mimu@linux.vnet.ibm.com>
Acked-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 arch/s390/kvm/Makefile   |  2 +-
 arch/s390/kvm/ibc.c      | 29 +++++++++++++++++++++++++++++
 arch/s390/kvm/kvm-s390.h |  8 ++++++++
 3 files changed, 38 insertions(+), 1 deletion(-)
 create mode 100644 arch/s390/kvm/ibc.c

diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
index f0072bc..88aa28b 100644
--- a/arch/s390/kvm/Makefile
+++ b/arch/s390/kvm/Makefile
@@ -12,6 +12,6 @@ common-objs = $(KVM)/kvm_main.o $(KVM)/eventfd.o  $(KVM)/async_pf.o $(KVM)/irqch
 ccflags-y := -Ivirt/kvm -Iarch/s390/kvm
 
 kvm-objs := $(common-objs) kvm-s390.o intercept.o interrupt.o priv.o sigp.o
-kvm-objs += diag.o config.o gaccess.o guestdbg.o
+kvm-objs += diag.o config.o gaccess.o guestdbg.o ibc.o
 
 obj-$(CONFIG_KVM) += kvm.o
diff --git a/arch/s390/kvm/ibc.c b/arch/s390/kvm/ibc.c
new file mode 100644
index 0000000..8171b02
--- /dev/null
+++ b/arch/s390/kvm/ibc.c
@@ -0,0 +1,29 @@
+/*
+ * Instruction Blocking related functions
+ *
+ * Copyright IBM Corp. 2014
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License (version 2 only)
+ * as published by the Free Software Foundation.
+ *
+ *    Author(s): Michael Mueller <mimu@linux.vnet.ibm.com>
+ */
+
+#include <asm/sclp.h>
+#include "kvm-s390.h"
+
+unsigned short kvm_s390_lowest_ibc(void)
+{
+	return (sclp_get_ibc() & IBC_MODE_MASK) >> 16;
+}
+
+unsigned short kvm_s390_latest_ibc(void)
+{
+	return sclp_get_ibc() & IBC_MODE_MASK;
+}
+
+bool kvm_s390_has_ibc(void)
+{
+	return kvm_s390_lowest_ibc() != 0;
+}
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index ecadc8a..3715917 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -32,6 +32,9 @@ int kvm_handle_sie_intercept(struct kvm_vcpu *vcpu);
 #define S390_ARCH_FAC_MASK_SIZE_U64 \
 	(S390_ARCH_FAC_MASK_SIZE_BYTE / sizeof(u64))
 
+/* mask non defined IBC bits from SCLP read data */
+#define IBC_MODE_MASK 0x0fff0fffu
+
 /* Transactional Memory Execution related macros */
 #define IS_TE_ENABLED(vcpu)	((vcpu->arch.sie_block->ecb & 0x10))
 #define TDB_FORMAT1		1
@@ -253,4 +256,9 @@ void kvm_s390_clear_bp_data(struct kvm_vcpu *vcpu);
 void kvm_s390_prepare_debug_exit(struct kvm_vcpu *vcpu);
 void kvm_s390_handle_per_event(struct kvm_vcpu *vcpu);
 
+/* implemented in ibc.c */
+unsigned short kvm_s390_lowest_ibc(void);
+unsigned short kvm_s390_latest_ibc(void);
+bool kvm_s390_has_ibc(void);
+
 #endif
-- 
1.8.3.1

