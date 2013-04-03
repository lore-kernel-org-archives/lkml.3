Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761966Ab3DCQJR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 12:09:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759071Ab3DCQJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 12:09:14 -0400
From: Anton Arapov <anton@redhat.com>
To: Anton Arapov <anton@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: [PATCH v1 9/9] uretprobes: Documentation update
Date: Wed,  3 Apr 2013 18:00:39 +0200
Message-Id: <1365004839-21982-10-git-send-email-anton@redhat.com>
In-Reply-To: <1365004839-21982-1-git-send-email-anton@redhat.com>
References: <1365004839-21982-1-git-send-email-anton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add the uretprobe syntax and update an example

Signed-off-by: Anton Arapov <anton@redhat.com>
---
 Documentation/trace/uprobetracer.txt | 114 ++++++++++++++++++++---------------
 1 file changed, 67 insertions(+), 47 deletions(-)

diff --git a/Documentation/trace/uprobetracer.txt b/Documentation/trace/uprobetracer.txt
index 24ce682..d9c3e68 100644
--- a/Documentation/trace/uprobetracer.txt
+++ b/Documentation/trace/uprobetracer.txt
@@ -1,6 +1,8 @@
-		Uprobe-tracer: Uprobe-based Event Tracing
-		=========================================
-                 Documentation written by Srikar Dronamraju
+            Uprobe-tracer: Uprobe-based Event Tracing
+            =========================================
+
+           Documentation written by Srikar Dronamraju
+
 
 Overview
 --------
@@ -13,78 +15,94 @@ current_tracer. Instead of that, add probe points via
 /sys/kernel/debug/tracing/events/uprobes/<EVENT>/enabled.
 
 However unlike kprobe-event tracer, the uprobe event interface expects the
-user to calculate the offset of the probepoint in the object
+user to calculate the offset of the probepoint in the object.
 
 Synopsis of uprobe_tracer
 -------------------------
-  p[:[GRP/]EVENT] PATH:SYMBOL[+offs] [FETCHARGS]	: Set a probe
+  p[:[GRP/]EVENT] PATH:SYMBOL[+offs] [FETCHARGS] : Set a uprobe
+  r[:[GRP/]EVENT] PATH:SYMBOL[+offs] [FETCHARGS] : Set a return uprobe (uretprobe)
+  -:[GRP/]EVENT                                  : Clear uprobe or uretprobe event
 
- GRP		: Group name. If omitted, use "uprobes" for it.
- EVENT		: Event name. If omitted, the event name is generated
-		  based on SYMBOL+offs.
- PATH		: path to an executable or a library.
- SYMBOL[+offs]	: Symbol+offset where the probe is inserted.
+  GRP           : Group name. If omitted, "uprobes" is the default value.
+  EVENT         : Event name. If omitted, the event name is generated based
+                  on SYMBOL+offs.
+  PATH          : Path to an executable or a library.
+  SYMBOL[+offs] : Symbol+offset where the probe is inserted.
 
- FETCHARGS	: Arguments. Each probe can have up to 128 args.
-  %REG		: Fetch register REG
+  FETCHARGS     : Arguments. Each probe can have up to 128 args.
+   %REG         : Fetch register REG
 
 Event Profiling
 ---------------
- You can check the total number of probe hits and probe miss-hits via
+You can check the total number of probe hits and probe miss-hits via
 /sys/kernel/debug/tracing/uprobe_profile.
- The first column is event name, the second is the number of probe hits,
+The first column is event name, the second is the number of probe hits,
 the third is the number of probe miss-hits.
 
 Usage examples
 --------------
-To add a probe as a new event, write a new definition to uprobe_events
-as below.
+ * Add a probe as a new uprobe event, write a new definition to uprobe_events
+as below: (sets a uprobe at an offset of 0x4245c0 in the executable /bin/bash)
+
+    echo 'p: /bin/bash:0x4245c0' > /sys/kernel/debug/tracing/uprobe_events
+
+ * Add a probe as a new uretprobe event:
+
+    echo 'r: /bin/bash:0x4245c0' > /sys/kernel/debug/tracing/uprobe_events
+
+ * Unset registered event:
 
-  echo 'p: /bin/bash:0x4245c0' > /sys/kernel/debug/tracing/uprobe_events
+    echo '-:bash_0x4245c0' >> /sys/kernel/debug/tracing/uprobe_events
 
- This sets a uprobe at an offset of 0x4245c0 in the executable /bin/bash
+ * Print out the events that are registered:
 
-  echo > /sys/kernel/debug/tracing/uprobe_events
+    cat /sys/kernel/debug/tracing/uprobe_events
 
- This clears all probe points.
+ * Clear all events:
 
-The following example shows how to dump the instruction pointer and %ax
-a register at the probed text address.  Here we are trying to probe
-function zfree in /bin/zsh
+    echo > /sys/kernel/debug/tracing/uprobe_events
+
+Following example shows how to dump the instruction pointer and %ax register
+at the probed text address. Probe zfree function in /bin/zsh:
 
     # cd /sys/kernel/debug/tracing/
-    # cat /proc/`pgrep  zsh`/maps | grep /bin/zsh | grep r-xp
+    # cat /proc/`pgrep zsh`/maps | grep /bin/zsh | grep r-xp
     00400000-0048a000 r-xp 00000000 08:03 130904 /bin/zsh
     # objdump -T /bin/zsh | grep -w zfree
     0000000000446420 g    DF .text  0000000000000012  Base        zfree
 
-0x46420 is the offset of zfree in object /bin/zsh that is loaded at
-0x00400000. Hence the command to probe would be :
+  0x46420 is the offset of zfree in object /bin/zsh that is loaded at
+  0x00400000. Hence the command to uprobe would be:
+
+    # echo 'p:zfree_entry /bin/zsh:0x46420 %ip %ax' > uprobe_events
+
+  And the same for the uretprobe would be:
 
-    # echo 'p /bin/zsh:0x46420 %ip %ax' > uprobe_events
+    # echo 'r:zfree_exit /bin/zsh:0x46420 %ip %ax' >> uprobe_events
 
-Please note: User has to explicitly calculate the offset of the probepoint
+Please note: User has to explicitly calculate the offset of the probe-point
 in the object. We can see the events that are registered by looking at the
 uprobe_events file.
 
     # cat uprobe_events
-    p:uprobes/p_zsh_0x46420 /bin/zsh:0x00046420 arg1=%ip arg2=%ax
+    p:uprobes/zfree_entry /bin/zsh:0x00046420 arg1=%ip arg2=%ax
+    r:uprobes/zfree_exit /bin/zsh:0x00046420 arg1=%ip arg2=%ax
 
-The format of events can be seen by viewing the file events/uprobes/p_zsh_0x46420/format
+Format of events can be seen by viewing the file events/uprobes/zfree_entry/format
 
-    # cat events/uprobes/p_zsh_0x46420/format
-    name: p_zsh_0x46420
+    # cat events/uprobes/zfree_entry/format
+    name: zfree_entry
     ID: 922
     format:
-	field:unsigned short common_type;	offset:0;	size:2;	signed:0;
-	field:unsigned char common_flags;	offset:2;	size:1;	signed:0;
-	field:unsigned char common_preempt_count;	offset:3;	size:1;	signed:0;
-	field:int common_pid;	offset:4;	size:4;	signed:1;
-	field:int common_padding;	offset:8;	size:4;	signed:1;
+         field:unsigned short common_type;         offset:0;  size:2; signed:0;
+         field:unsigned char common_flags;         offset:2;  size:1; signed:0;
+         field:unsigned char common_preempt_count; offset:3;  size:1; signed:0;
+         field:int common_pid;                     offset:4;  size:4; signed:1;
+         field:int common_padding;                 offset:8;  size:4; signed:1;
 
-	field:unsigned long __probe_ip;	offset:12;	size:4;	signed:0;
-	field:u32 arg1;	offset:16;	size:4;	signed:0;
-	field:u32 arg2;	offset:20;	size:4;	signed:0;
+         field:unsigned long __probe_ip;           offset:12; size:4; signed:0;
+         field:u32 arg1;                           offset:16; size:4; signed:0;
+         field:u32 arg2;                           offset:20; size:4; signed:0;
 
     print fmt: "(%lx) arg1=%lx arg2=%lx", REC->__probe_ip, REC->arg1, REC->arg2
 
@@ -94,6 +112,7 @@ Right after definition, each event is disabled by default. For tracing these
     # echo 1 > events/uprobes/enable
 
 Lets disable the event after sleeping for some time.
+
     # sleep 20
     # echo 0 > events/uprobes/enable
 
@@ -104,10 +123,11 @@ And you can see the traced information via /sys/kernel/debug/tracing/trace.
     #
     #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
     #              | |       |          |         |
-                 zsh-24842 [006] 258544.995456: p_zsh_0x46420: (0x446420) arg1=446421 arg2=79
-                 zsh-24842 [007] 258545.000270: p_zsh_0x46420: (0x446420) arg1=446421 arg2=79
-                 zsh-24842 [002] 258545.043929: p_zsh_0x46420: (0x446420) arg1=446421 arg2=79
-                 zsh-24842 [004] 258547.046129: p_zsh_0x46420: (0x446420) arg1=446421 arg2=79
-
-Each line shows us probes were triggered for a pid 24842 with ip being
-0x446421 and contents of ax register being 79.
+                 zsh-24842 [006] 258544.995456: zfree_entry: (0x446420) arg1=446420 arg2=79
+                 zsh-24842 [007] 258545.000270: zfree_exit:  (0x446540 <- 0x446420) arg1=446540 arg2=0
+                 zsh-24842 [002] 258545.043929: zfree_entry: (0x446420) arg1=446420 arg2=79
+                 zsh-24842 [004] 258547.046129: zfree_exit:  (0x446540 <- 0x446420) arg1=446540 arg2=0
+
+Output shows us uprobe was triggered for a pid 24842 with ip being 0x446420
+and contents of ax register being 79. And uretprobe was triggered with ip at
+0x446540 with counterpart function entry at 0x446420.
-- 
1.8.1.4

