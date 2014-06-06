Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbaFFRYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:24:50 -0400
Received: from david.siemens.de ([192.35.17.14]:35930 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408AbaFFRTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:19:37 -0400
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>,
        Tatiana Al-Chueyr Martins <tatiana.alchueyr@gmail.com>
Subject: [PATCH v8 10/22] scripts/gdb: Add read_u16/32/64 helpers
Date: Fri,  6 Jun 2014 19:18:51 +0200
Message-Id: <45733ec4b6e8f6b71fa2fef39b4010d45b9abf36.1402075140.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.8.1.1.298.ge7eed54
In-Reply-To: <cover.1402075136.git.jan.kiszka@siemens.com>
References: <cover.1402075136.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1402075136.git.jan.kiszka@siemens.com>
References: <cover.1402075136.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add helpers for reading integers from target memory buffers. Required
when caching the memory access is more efficient than reading individual
values via gdb.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/linux/utils.py | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/scripts/gdb/linux/utils.py b/scripts/gdb/linux/utils.py
index 10a227b..808a265 100644
--- a/scripts/gdb/linux/utils.py
+++ b/scripts/gdb/linux/utils.py
@@ -85,3 +85,24 @@ def get_target_endianness():
         else:
             raise gdb.GdgError("unknown endianness '{0}'".format(endian))
     return target_endianness
+
+
+def read_u16(buffer):
+    if get_target_endianness() == LITTLE_ENDIAN:
+        return ord(buffer[0]) + (ord(buffer[1]) << 8)
+    else:
+        return ord(buffer[1]) + (ord(buffer[0]) << 8)
+
+
+def read_u32(buffer):
+    if get_target_endianness() == LITTLE_ENDIAN:
+        return read_u16(buffer[0:2]) + (read_u16(buffer[2:4]) << 16)
+    else:
+        return read_u16(buffer[2:4]) + (read_u16(buffer[0:2]) << 16)
+
+
+def read_u64(buffer):
+    if get_target_endianness() == LITTLE_ENDIAN:
+        return read_u32(buffer[0:4]) + (read_u32(buffer[4:8]) << 32)
+    else:
+        return read_u32(buffer[4:8]) + (read_u32(buffer[0:4]) << 32)
-- 
1.8.1.1.298.ge7eed54

