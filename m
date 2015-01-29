Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804AbbA2HVc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 02:21:32 -0500
Received: from thoth.sbs.de ([192.35.17.2]:44408 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbbA2HVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 02:21:31 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH v11 10/28] scripts/gdb: Add read_u16/32/64 helpers
Date: Thu, 29 Jan 2015 07:46:29 +0100
Message-Id: <f0627582975a98fe6e1457cb01e8ca2197c086be.1422514006.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <cover.1422514006.git.jan.kiszka@siemens.com>
References: <cover.1422514006.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1422514006.git.jan.kiszka@siemens.com>
References: <cover.1422514006.git.jan.kiszka@siemens.com>
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
2.1.4

