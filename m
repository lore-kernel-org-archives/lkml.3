Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbaFFRYp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:24:45 -0400
Received: from goliath.siemens.de ([192.35.17.28]:34750 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbaFFRTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
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
Subject: [PATCH v8 09/22] scripts/gdb: Add get_target_endianness helper
Date: Fri,  6 Jun 2014 19:18:50 +0200
Message-Id: <e7afb2d807b7c9d2433925650436b72978dbf805.1402075140.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.8.1.1.298.ge7eed54
In-Reply-To: <cover.1402075136.git.jan.kiszka@siemens.com>
References: <cover.1402075136.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1402075136.git.jan.kiszka@siemens.com>
References: <cover.1402075136.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parse the target endianness from the output of "show endian" and cache
the result to return it via the new helper get_target_endiannes. We will
need it for reading integers from buffers that contain target memory.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/linux/utils.py | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/scripts/gdb/linux/utils.py b/scripts/gdb/linux/utils.py
index c9d705b..10a227b 100644
--- a/scripts/gdb/linux/utils.py
+++ b/scripts/gdb/linux/utils.py
@@ -67,3 +67,21 @@ Note that TYPE and ELEMENT have to be quoted as strings."""
                             elementname.string())
 
 ContainerOf()
+
+
+BIG_ENDIAN = 0
+LITTLE_ENDIAN = 1
+target_endianness = None
+
+
+def get_target_endianness():
+    global target_endianness
+    if target_endianness is None:
+        endian = gdb.execute("show endian", to_string=True)
+        if "little endian" in endian:
+            target_endianness = LITTLE_ENDIAN
+        elif "big endian" in endian:
+            target_endianness = BIG_ENDIAN
+        else:
+            raise gdb.GdgError("unknown endianness '{0}'".format(endian))
+    return target_endianness
-- 
1.8.1.1.298.ge7eed54

