Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930Ab3A2MjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 07:39:22 -0500
Received: from goliath.siemens.de ([192.35.17.28]:18530 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756896Ab3A2MjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 07:39:17 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH v5 15/20] scripts/gdb: Add get_gdbserver_type helper
Date: Tue, 29 Jan 2013 13:37:58 +0100
Message-Id: <17368dae14b7f2e1ea15013990b62f35abf6a5c1.1359463075.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1359463075.git.jan.kiszka@siemens.com>
References: <cover.1359463075.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1359463075.git.jan.kiszka@siemens.com>
References: <cover.1359463075.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This helper probes the type of the gdb server. Supported are QEMU and
KGDB so far. Knowledge about the gdb server is required e.g. to retrieve
the current CPU or current task.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/utils.py |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/scripts/gdb/utils.py b/scripts/gdb/utils.py
index bcf4278..d381f63 100644
--- a/scripts/gdb/utils.py
+++ b/scripts/gdb/utils.py
@@ -121,3 +121,38 @@ def is_target_arch(arch):
 	if target_arch == None:
 		target_arch = gdb.execute("show architecture", False, True)
 	return target_arch.find(arch) >= 0
+
+
+GDBSERVER_QEMU = 0
+GDBSERVER_KGDB = 1
+gdbserver_type = None
+
+def get_gdbserver_type():
+	def exit_handler(event):
+		global gdbserver_type
+		gdbserver_type = None
+		gdb.events.exited.disconnect(exit_handler)
+
+	def probe_qemu():
+		try:
+			return gdb.execute("monitor info version", False,
+					   True) != ""
+		except:
+			return False
+
+	def probe_kgdb():
+		try:
+			thread_info = gdb.execute("info thread 2", False, True)
+			return thread_info.find("shadowCPU0") >= 0
+		except:
+			return False
+
+	global gdbserver_type
+	if gdbserver_type == None:
+		if probe_qemu():
+			gdbserver_type = GDBSERVER_QEMU
+		elif probe_kgdb():
+			gdbserver_type = GDBSERVER_KGDB
+		if gdbserver_type != None:
+			gdb.events.exited.connect(exit_handler)
+	return gdbserver_type
-- 
1.7.3.4

