Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299Ab3AURXQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 12:23:16 -0500
Received: from david.siemens.de ([192.35.17.14]:21668 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449Ab3AURXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 12:23:13 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>
Subject: [PATCH v4 05/13] scripts/gdb: Add read_u16/32/64 helpers
Date: Mon, 21 Jan 2013 18:06:12 +0100
Message-Id: <2cff4333b45f0812a69bef7abfd403b842e23d87.1358787929.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1358787929.git.jan.kiszka@siemens.com>
References: <cover.1358787929.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1358787929.git.jan.kiszka@siemens.com>
References: <cover.1358787929.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add helpers for reading integers from target memory buffers. Required
when caching the memory access is more efficient than reading individual
values via gdb.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/utils.py |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/scripts/gdb/utils.py b/scripts/gdb/utils.py
index 44daa29c..8d54241 100644
--- a/scripts/gdb/utils.py
+++ b/scripts/gdb/utils.py
@@ -73,3 +73,21 @@ def get_target_endianness():
 		else:
 			raise gdb.GdgError("unknown endianness '%s'" % endian)
 	return target_endianness
+
+def read_u16(buffer):
+	if get_target_endianness() == LITTLE_ENDIAN:
+		return ord(buffer[0]) + (ord(buffer[1]) << 8)
+	else:
+		return ord(buffer[1]) + (ord(buffer[0]) << 8)
+
+def read_u32(buffer):
+	if get_target_endianness() == LITTLE_ENDIAN:
+		return read_u16(buffer[0:2]) + (read_u16(buffer[2:4]) << 16)
+	else:
+		return read_u16(buffer[2:4]) + (read_u16(buffer[0:2]) << 16)
+
+def read_u64(buffer):
+	if get_target_endianness() == LITTLE_ENDIAN:
+		return read_u32(buffer[0:4]) + (read_u32(buffer[4:8]) << 32)
+	else:
+		return read_u32(buffer[4:8]) + (read_u32(buffer[0:4]) << 32)
-- 
1.7.3.4

