Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965030AbaEMO7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:59:37 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:49318 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965007AbaEMO6y (ORCPT
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
Subject: [PATCH v1 RFC 5/6] KVM: s390: initial implementation of soft facilities
Date: Tue, 13 May 2014 16:58:33 +0200
Message-Id: <1399993114-15333-6-git-send-email-mimu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1399993114-15333-1-git-send-email-mimu@linux.vnet.ibm.com>
References: <1399993114-15333-1-git-send-email-mimu@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051314-1948-0000-0000-000008C5B7BC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements the new state soft_fac_bits. This state
defines which facilities are emulated in kernel and not in processor
or millicode. Currently all bits are cleared.

Signed-off-by: Michael Mueller <mimu@linux.vnet.ibm.com>
---
 arch/s390/kvm/Makefile   |  2 +-
 arch/s390/kvm/kvm-s390.h |  3 +++
 arch/s390/kvm/softfac.c  | 38 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 42 insertions(+), 1 deletion(-)
 create mode 100644 arch/s390/kvm/softfac.c

diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
index 88aa28b..586f686 100644
--- a/arch/s390/kvm/Makefile
+++ b/arch/s390/kvm/Makefile
@@ -12,6 +12,6 @@ common-objs = $(KVM)/kvm_main.o $(KVM)/eventfd.o  $(KVM)/async_pf.o $(KVM)/irqch
 ccflags-y := -Ivirt/kvm -Iarch/s390/kvm
 
 kvm-objs := $(common-objs) kvm-s390.o intercept.o interrupt.o priv.o sigp.o
-kvm-objs += diag.o config.o gaccess.o guestdbg.o ibc.o
+kvm-objs += diag.o config.o gaccess.o guestdbg.o ibc.o softfac.o
 
 obj-$(CONFIG_KVM) += kvm.o
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index 3715917..10de678 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -261,4 +261,7 @@ unsigned short kvm_s390_lowest_ibc(void);
 unsigned short kvm_s390_latest_ibc(void);
 bool kvm_s390_has_ibc(void);
 
+/* implemented in softfac.c */
+unsigned int stsfle(unsigned long *fac, unsigned long size);
+
 #endif
diff --git a/arch/s390/kvm/softfac.c b/arch/s390/kvm/softfac.c
new file mode 100644
index 0000000..1c489d8
--- /dev/null
+++ b/arch/s390/kvm/softfac.c
@@ -0,0 +1,38 @@
+/*
+ * Registration of KVM emulated facilities
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
+#include "kvm-s390.h"
+
+/*
+ * The soft facilities define which of the facilities are emulatable
+ * in KVM. The size must be identical to the size of the cpu facility
+ * list.
+ */
+static unsigned long soft_fac_bits[S390_ARCH_FAC_LIST_SIZE_U64];
+
+/**
+ * stsfle():
+ *          store soft facility list extended, copies a subset of the
+ *          soft facility list
+ * @fac     address of buffer where the facilities should be stored
+ * @size    number of double words + 1 to store in @fac
+ * @returns number of bytes being copied
+ */
+unsigned int stsfle(unsigned long *fac, unsigned long size)
+{
+	if (size >= S390_ARCH_FAC_LIST_SIZE_U64)
+		size = S390_ARCH_FAC_LIST_SIZE_U64 - 1;
+	size = (!test_facility(7)) ? 4 : (size + 1) * sizeof(*fac);
+	memcpy(fac, soft_fac_bits, size);
+
+	return size;
+}
-- 
1.8.3.1

