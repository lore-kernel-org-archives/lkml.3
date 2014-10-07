Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740AbaJGKtu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 06:49:50 -0400
Received: from ozlabs.org ([103.22.144.67]:49982 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674AbaJGKtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 06:49:43 -0400
From: Michael Neuling <mikey@neuling.org>
To: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org
Cc: mikey@neuling.org, anton@samba.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, imunsie@au.ibm.com,
        cbe-oss-dev@lists.ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH v3 14/16] cxl: Userspace header file.
Date: Tue,  7 Oct 2014 21:48:20 +1100
Message-Id: <1412678902-18672-15-git-send-email-mikey@neuling.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412678902-18672-1-git-send-email-mikey@neuling.org>
References: <1412678902-18672-1-git-send-email-mikey@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This defines structs and magic numbers required for userspace to interact with
the kernel cxl driver via /dev/cxl/afu0.0.

It adds this header file Kbuild so it's exported when doing make
headers_installs.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
Signed-off-by: Michael Neuling <mikey@neuling.org>
---
 include/uapi/Kbuild      |  1 +
 include/uapi/misc/Kbuild |  2 ++
 include/uapi/misc/cxl.h  | 86 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 89 insertions(+)
 create mode 100644 include/uapi/misc/Kbuild
 create mode 100644 include/uapi/misc/cxl.h

diff --git a/include/uapi/Kbuild b/include/uapi/Kbuild
index 81d2106..245aa6e 100644
--- a/include/uapi/Kbuild
+++ b/include/uapi/Kbuild
@@ -12,3 +12,4 @@ header-y += video/
 header-y += drm/
 header-y += xen/
 header-y += scsi/
+header-y += misc/
diff --git a/include/uapi/misc/Kbuild b/include/uapi/misc/Kbuild
new file mode 100644
index 0000000..e96cae7
--- /dev/null
+++ b/include/uapi/misc/Kbuild
@@ -0,0 +1,2 @@
+# misc Header export list
+header-y += cxl.h
diff --git a/include/uapi/misc/cxl.h b/include/uapi/misc/cxl.h
new file mode 100644
index 0000000..0aaecf3
--- /dev/null
+++ b/include/uapi/misc/cxl.h
@@ -0,0 +1,86 @@
+/*
+ * Copyright 2014 IBM Corp.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _UAPI_ASM_CXL_H
+#define _UAPI_ASM_CXL_H
+
+#include <linux/types.h>
+#include <linux/ioctl.h>
+
+/* Structs for IOCTLS for userspace to talk to the kernel */
+struct cxl_ioctl_start_work {
+	__u64 flags;
+	__u64 wed;
+	__u64 amr;
+	__s16 num_interrupts;
+	__s16 reserved1;
+	__s32 reserved2;
+	__u64 reserved3;
+	__u64 reserved4;
+	__u64 reserved5;
+	__u64 reserved6;
+};
+#define CXL_START_WORK_AMR		0x0000000000000001ULL
+#define CXL_START_WORK_NUM_IRQS		0x0000000000000002ULL
+#define CXL_START_WORK_ALL		(CXL_START_WORK_AMR |\
+					 CXL_START_WORK_NUM_IRQS)
+
+/* IOCTL numbers */
+#define CXL_MAGIC 0xCA
+#define CXL_IOCTL_START_WORK		_IOW(CXL_MAGIC, 0x00, struct cxl_ioctl_start_work)
+#define CXL_IOCTL_GET_PROCESS_ELEMENT	_IOR(CXL_MAGIC, 0x01, int)
+
+/* Events from read() */
+#define CXL_READ_MIN_SIZE 0x1000 /* 4K */
+enum cxl_event_type {
+	CXL_EVENT_RESERVED      = 0,
+	CXL_EVENT_AFU_INTERRUPT = 1,
+	CXL_EVENT_DATA_STORAGE  = 2,
+	CXL_EVENT_AFU_ERROR     = 3,
+};
+
+struct cxl_event_header {
+	__u16 type;
+	__u16 size;
+	__u16 process_element;
+	__u16 reserved1;
+};
+
+struct cxl_event_afu_interrupt {
+	__u16 flags;
+	__u16 irq; /* Raised AFU interrupt number */
+	__u32 reserved1;
+};
+
+struct cxl_event_data_storage {
+	__u16 flags;
+	__u16 reserved1;
+	__u32 reserved2;
+	__u64 addr;
+	__u64 dsisr;
+	__u64 reserved3;
+};
+
+struct cxl_event_afu_error {
+	__u16 flags;
+	__u16 reserved1;
+	__u32 reserved2;
+	__u64 err;
+};
+
+struct cxl_event {
+	struct cxl_event_header header;
+	union {
+		struct cxl_event_afu_interrupt irq;
+		struct cxl_event_data_storage fault;
+		struct cxl_event_afu_error afu_err;
+	};
+};
+
+#endif
-- 
1.9.1

