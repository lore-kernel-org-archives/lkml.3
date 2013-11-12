Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407Ab3KLHTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 02:19:36 -0500
Received: from david.siemens.de ([192.35.17.14]:27509 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754847Ab3KLHPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 02:15:15 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>,
        Tatiana Al-Chueyr Martins <tatiana.alchueyr@gmail.com>
Subject: [PATCH v7 16/21] scripts/gdb: Add get_gdbserver_type helper
Date: Tue, 12 Nov 2013 08:14:34 +0100
Message-Id: <d46ab44709e7e5af7be000514e803b3676dec05d.1384240478.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.8.1.1.298.ge7eed54
In-Reply-To: <cover.1384240478.git.jan.kiszka@siemens.com>
References: <cover.1384240478.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1384240478.git.jan.kiszka@siemens.com>
References: <cover.1384240478.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This helper probes the type of the gdb server. Supported are QEMU and
KGDB so far. Knowledge about the gdb server is required e.g. to retrieve
the current CPU or current task.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/linux/utils.py | 35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/scripts/gdb/linux/utils.py b/scripts/gdb/linux/utils.py
index 71ee48c..a4a1640 100644
--- a/scripts/gdb/linux/utils.py
+++ b/scripts/gdb/linux/utils.py
@@ -119,3 +119,38 @@ def is_target_arch(arch):
         if target_arch is None:
             target_arch = gdb.execute("show architecture", to_string=True)
         return arch in target_arch
+
+
+GDBSERVER_QEMU = 0
+GDBSERVER_KGDB = 1
+gdbserver_type = None
+
+
+def get_gdbserver_type():
+    def exit_handler(event):
+        global gdbserver_type
+        gdbserver_type = None
+        gdb.events.exited.disconnect(exit_handler)
+
+    def probe_qemu():
+        try:
+            return gdb.execute("monitor info version", to_string=True) != ""
+        except:
+            return False
+
+    def probe_kgdb():
+        try:
+            thread_info = gdb.execute("info thread 2", to_string=True)
+            return "shadowCPU0" in thread_info
+        except:
+            return False
+
+    global gdbserver_type
+    if gdbserver_type is None:
+        if probe_qemu():
+            gdbserver_type = GDBSERVER_QEMU
+        elif probe_kgdb():
+            gdbserver_type = GDBSERVER_KGDB
+        if not gdbserver_type is None and hasattr(gdb, 'events'):
+            gdb.events.exited.connect(exit_handler)
+    return gdbserver_type
-- 
1.8.1.1.298.ge7eed54

