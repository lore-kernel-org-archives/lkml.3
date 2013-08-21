Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab3HUDqD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 23:46:03 -0400
Received: from mga09.intel.com ([134.134.136.24]:15369 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085Ab3HUDqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 23:46:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,924,1367996400"; 
   d="scan'208";a="390633356"
Subject: [PATCH] irq: add irq handler function name in ftrace
From: Li Fei <fei.li@intel.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com, rob@landley.net
Cc: chuansheng.liu@intel.com, fei.li@intel.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Aug 2013 11:44:21 +0800
Message-ID: <1377056661.32321.2.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At present, irq handler function name is not printed out when
irq_handler_entry is added into trace event, which is inconvenient
for debugging.
In order to improve the debugging efficiency, print out the handler
function name in irq_handler_entry.

Signed-off-by: Li Fei <fei.li@intel.com>
Acked-by: Liu Chuansheng <chuansheng.liu@intel.com>
---
 Documentation/trace/ftrace.txt |    8 ++++----
 include/trace/events/irq.h     |    5 ++++-
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
index b937c6e..907ecbd 100644
--- a/Documentation/trace/ftrace.txt
+++ b/Documentation/trace/ftrace.txt
@@ -2701,10 +2701,10 @@ CPU:2 [LOST 11745 EVENTS]
             bash-1998  [000] ..s2   138.733106: softirq_exit: vec=1 [action=TIMER]
             bash-1998  [000] ..s2   138.733106: softirq_entry: vec=9 [action=RCU]
             bash-1998  [000] ..s2   138.733109: softirq_exit: vec=9 [action=RCU]
-            sshd-1995  [001] d.h1   138.733278: irq_handler_entry: irq=21 name=uhci_hcd:usb4
-            sshd-1995  [001] d.h1   138.733280: irq_handler_exit: irq=21 ret=unhandled
-            sshd-1995  [001] d.h1   138.733281: irq_handler_entry: irq=21 name=eth0
-            sshd-1995  [001] d.h1   138.733283: irq_handler_exit: irq=21 ret=handled
+            kworker/0:2-161  [001] d.h1   138.733278: irq_handler_entry: irq=17 name=i2c-designware-pci-7 func=i2c_dw_isr
+            kworker/0:2-161  [001] d.h1   138.733280: irq_handler_exit: irq=17 ret=unhandled
+            kworker/0:2-161  [001] d.h1   138.733281: irq_handler_entry: irq=17 name=mmc0 func=sdhci_irq
+            kworker/0:2-161  [001] d.h1   138.733283: irq_handler_exit: irq=17 ret=handled
 [...]
 
  # cat instances/zoot/trace
diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
index 1c09820..3497eb3 100644
--- a/include/trace/events/irq.h
+++ b/include/trace/events/irq.h
@@ -43,14 +43,17 @@ TRACE_EVENT(irq_handler_entry,
 	TP_STRUCT__entry(
 		__field(	int,	irq		)
 		__string(	name,	action->name	)
+		__field(irq_handler_t, func)
 	),
 
 	TP_fast_assign(
 		__entry->irq = irq;
 		__assign_str(name, action->name);
+		__entry->func = action->handler;
 	),
 
-	TP_printk("irq=%d name=%s", __entry->irq, __get_str(name))
+	TP_printk("irq=%d name=%s func=%pf",
+		__entry->irq, __get_str(name), __entry->func)
 );
 
 /**
-- 
1.7.4.1



