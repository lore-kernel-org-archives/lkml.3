Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbaC0E4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 00:56:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:61727 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049AbaC0EyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 00:54:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,739,1389772800"; 
   d="scan'208";a="500618905"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH 4/5] tracing: Add hash trigger to Documentation
Date: Wed, 26 Mar 2014 23:54:06 -0500
Message-Id: <de3f3d3974e4a2e54bf0f4b70fe6edfeb67a0de7.1395894625.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1395894625.git.tom.zanussi@linux.intel.com>
References: <cover.1395894625.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1395894625.git.tom.zanussi@linux.intel.com>
References: <cover.1395894625.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add documentation and usage examples for 'hash' triggers.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 Documentation/trace/events.txt | 81 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/Documentation/trace/events.txt b/Documentation/trace/events.txt
index c94435d..aed77bc 100644
--- a/Documentation/trace/events.txt
+++ b/Documentation/trace/events.txt
@@ -494,3 +494,84 @@ The following commands are supported:
 
   Note that there can be only one traceon or traceoff trigger per
   triggering event.
+
+- hash
+
+  This command updates a hash table with a key composed of one or more
+  trace event format fields and a set of values consisting of one or
+  more running totals of either field values or single counts.
+
+  For example, the following trigger hashes all kmalloc events using
+  'call_site' as the hash key.  For each entry, it keeps a running
+  count of event hits ('hitcount', which is optional - counts are
+  always tallied and displayed in the output), and running sums of
+  bytes_alloc, and bytes_req:
+
+  # echo 'hash:call_site:hitcount,bytes_alloc,bytes_req' > \
+      /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
+
+  The following uses the stacktrace at the call_site as a hash key
+  instead of just the straight call_site. :
+
+  # echo 'hash:stacktrace:bytes_alloc,bytes_req' > \
+      /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
+
+  The following uses the combination of call_site and pid as a
+  composite hash key, effectively implementing a per-pid nested hash
+  by call_site:
+
+  # echo 'hash:call_site,common_pid:bytes_alloc,bytes_req' > \
+      /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
+
+  To keep a per-pid count of the number of bytes asked for in file
+  reads:
+
+  # echo 'hash:common_pid:count' > \
+      /sys/kernel/debug/tracing/events/syscalls/sys_enter_read/trigger
+
+  To keep a per-pid, per-file count of the number of bytes asked for
+  in file reads:
+
+  # echo 'hash:common_pid,fd:count' > \
+      /sys/kernel/debug/tracing/events/syscalls/sys_enter_read/trigger
+
+  To keep a per-pid, per-file count of the number of bytes actually
+  gotten in file reads (but only if the return value wasn't negative):
+
+  # echo 'hash:common_pid,fd:ret if ret > 0' > \
+      /sys/kernel/debug/tracing/events/syscalls/sys_exit_read/trigger
+
+  The format is:
+
+      hash:<key>,<key>:<val>,<val>,<val>[:sort_keys] if filter > event/trigger
+
+  More formally,
+
+      # echo hash:key(s):value(s)[:sort_keys()][ if filter] > event/trigger
+
+  To remove the above commands:
+
+  # echo '!hash:call_site:1,bytes_alloc,bytes_req' > \
+      /sys/kernel/debug/tracing/events/kmem/kmalloc/trigger
+
+  Note that there can be any number of hash triggers per triggering
+  event.
+
+  A '-' operator is available for taking differences between numeric
+  fields.
+
+  Sorting:
+
+    The default sort key is 'hitcount' which is always available.
+    Appending ':sort=val1,val1' will sort the output using val1 as the
+    primary key and val2 as the secondary.
+
+  Modifiers:
+
+    Various fields can have a .<modifier> appended to them, which will
+    modify how they're displayed:
+
+      .hex      - display a numeric value as hex
+      .sym      - display an address as a symbol if possible
+      .syscall  - map a number representing syscall id to its syscall name
+      .execname - map a number representing a pid to its process name
-- 
1.8.3.1

