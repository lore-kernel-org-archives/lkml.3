Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab3KLHPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 02:15:45 -0500
Received: from david.siemens.de ([192.35.17.14]:27488 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754090Ab3KLHPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 02:15:13 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>,
        Tatiana Al-Chueyr Martins <tatiana.alchueyr@gmail.com>
Subject: [PATCH v7 10/21] scripts/gdb: Add read_u16/32/64 helpers
Date: Tue, 12 Nov 2013 08:14:28 +0100
Message-Id: <c509d486dad4e1344419e2d187401891f49d4b05.1384240478.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.8.1.1.298.ge7eed54
In-Reply-To: <cover.1384240478.git.jan.kiszka@siemens.com>
References: <cover.1384240478.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1384240478.git.jan.kiszka@siemens.com>
References: <cover.1384240478.git.jan.kiszka@siemens.com>
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

