Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab3A2MjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 07:39:15 -0500
Received: from goliath.siemens.de ([192.35.17.28]:18489 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756853Ab3A2MjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 07:39:12 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@alien8.de>
Subject: [PATCH v5 18/20] scripts/gdb: Add helper to iterate over CPU masks
Date: Tue, 29 Jan 2013 13:38:01 +0100
Message-Id: <328d5aa5badc05674d82feb678fd0288a903a8e3.1359463075.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <cover.1359463075.git.jan.kiszka@siemens.com>
References: <cover.1359463075.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1359463075.git.jan.kiszka@siemens.com>
References: <cover.1359463075.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will be used first to count module references. It is optimized to read
the mask only once per stop and to minimize the loop lengths.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 scripts/gdb/percpu.py |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/scripts/gdb/percpu.py b/scripts/gdb/percpu.py
index 4dab8d3..bc04188 100644
--- a/scripts/gdb/percpu.py
+++ b/scripts/gdb/percpu.py
@@ -43,6 +43,39 @@ def per_cpu(var_ptr, cpu):
 	pointer = var_ptr.cast(get_long_type()) + offset
 	return pointer.cast(var_ptr.type).dereference()
 
+cpu_mask = { }
+
+def for_each_cpu(mask_name, func, arg = None):
+	def invalidate_handler(event):
+		global cpu_online_mask
+		cpu_mask = { }
+		gdb.events.stop.disconnect(invalidate_handler)
+		gdb.events.new_objfile.disconnect(invalidate_handler)
+
+	global cpu_mask
+	mask = None
+	if mask_name in cpu_mask:
+		mask = cpu_mask[mask_name]
+	if mask == None:
+		mask = gdb.parse_and_eval(mask_name + ".bits")
+		cpu_mask[mask_name] = mask
+		gdb.events.stop.connect(invalidate_handler)
+		gdb.events.new_objfile.connect(invalidate_handler)
+
+	max_cpu_id = mask.type.sizeof * 8
+	bits_per_entry = mask[0].type.sizeof * 8
+	for entry in range(max_cpu_id / bits_per_entry):
+		bits = mask[entry]
+		if bits == 0:
+			continue
+		for bit in range(bits_per_entry):
+			if bits & 1:
+				cpu = entry * bits_per_entry + bit
+				func(cpu, arg)
+			bits >>= 1
+			if bits == 0:
+				break
+
 
 class PerCpu(gdb.Function):
 	__doc__ = "Return per-cpu variable.\n" \
-- 
1.7.3.4

