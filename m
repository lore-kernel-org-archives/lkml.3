Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426AbaJ1L1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 07:27:36 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:27768 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095AbaJ1L12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 07:27:28 -0400
From: Qais Yousef <qais.yousef@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Qais Yousef <qais.yousef@imgtec.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <alsa-devel@alsa-project.org>
Subject: [PATCH 04/11] drivers: char: axd: add fw binary header manipulation files
Date: Tue, 28 Oct 2014 11:26:22 +0000
Message-ID: <1414495589-8579-5-git-send-email-qais.yousef@imgtec.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1414495589-8579-1-git-send-email-qais.yousef@imgtec.com>
References: <1414495589-8579-1-git-send-email-qais.yousef@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.154.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

these files provide functions to get information from the fw binary
header

Signed-off-by: Qais Yousef <qais.yousef@imgtec.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: <alsa-devel@alsa-project.org>
---
 drivers/char/axd/axd_hdr.c | 69 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/char/axd/axd_hdr.h | 20 ++++++++++++++
 2 files changed, 89 insertions(+)
 create mode 100644 drivers/char/axd/axd_hdr.c
 create mode 100644 drivers/char/axd/axd_hdr.h

diff --git a/drivers/char/axd/axd_hdr.c b/drivers/char/axd/axd_hdr.c
new file mode 100644
index 000000000000..86a3aeec83e9
--- /dev/null
+++ b/drivers/char/axd/axd_hdr.c
@@ -0,0 +1,69 @@
+/*
+ * Copyright (C) 2011-2014 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * Helper functions to parse AXD Header in the firmware binary.
+ */
+#include <linux/kernel.h>
+
+#include "axd_api.h"
+#include "axd_hdr.h"
+
+
+#ifdef DEBUG_HEADER
+#define debughdr	printk
+#else
+#define debughdr(format, ...)
+#endif
+
+static struct axd_hdr *hdr;
+
+static void dump_hdr(void)
+{
+#ifdef DEBUG_HEADER
+	unsigned int offset = 0;
+	unsigned long address = (unsigned long)hdr;
+
+	debughdr("header <0x%08lX>:\n", address);
+	while (offset <= sizeof(*hdr)) {
+		debughdr("0x%08X\t", *(unsigned int *)(address+offset));
+		offset += 4;
+		if ((offset % (4*4)) == 0)
+			debughdr("\n");
+	}
+	debughdr("\n");
+#endif
+}
+
+void axd_hdr_init(unsigned long address)
+{
+	hdr = (struct axd_hdr *)address;
+	dump_hdr();
+}
+
+unsigned long axd_hdr_get_pc(unsigned int thread)
+{
+	if (thread >= THREAD_COUNT)
+		return -1;
+	return hdr->thread_pc[thread];
+}
+
+unsigned long axd_hdr_get_cmdblock_offset(void)
+{
+	debughdr("cmdblock_offset = 0x%08X\n", hdr->cmd_block_offset);
+	return hdr->cmd_block_offset;
+}
+
+char *axd_hdr_get_build_str(void)
+{
+	return hdr->build_str;
+}
+
+unsigned long axd_hdr_get_log_offset(void)
+{
+	return hdr->log_offset;
+}
diff --git a/drivers/char/axd/axd_hdr.h b/drivers/char/axd/axd_hdr.h
new file mode 100644
index 000000000000..34a46a7f8e65
--- /dev/null
+++ b/drivers/char/axd/axd_hdr.h
@@ -0,0 +1,20 @@
+/*
+ * Copyright (C) 2011-2014 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * Helper functions to parse AXD Header in the firmware binary
+ */
+ #ifndef AXD_HDR_H_
+ #define AXD_HDR_H_
+
+void axd_hdr_init(unsigned long address);
+unsigned long axd_hdr_get_pc(unsigned int thread);
+unsigned long axd_hdr_get_cmdblock_offset(void);
+char *axd_hdr_get_build_str(void);
+unsigned long axd_hdr_get_log_offset(void);
+
+#endif /* AXD_HDR_H_ */
-- 
2.1.0

