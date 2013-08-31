Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725Ab3HaLHg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 07:07:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:4514 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753602Ab3HaLHf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 07:07:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,997,1367996400"; 
   d="scan'208";a="396364073"
From: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "mingo@kernel.org" <mingo@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "jolsa@redhat.com" <jolsa@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>
Subject: RE: [RFC][PATCH 17/18 v2] ftrace/cpuidle/x86: Mark functions that
 are RCU unsafe
Thread-Topic: [RFC][PATCH 17/18 v2] ftrace/cpuidle/x86: Mark functions that
 are RCU unsafe
Thread-Index: AQHOpglW5XYR6imBrky9yFcyCnwDFJmvKH4O
Date: Sat, 31 Aug 2013 11:07:29 +0000
Message-ID: <niy9r1aodpxs3r912ut902gi.1377947166977@email.android.com>
References: <20130831051117.884125230@goodmis.org>,<20130831051703.241036187@goodmis.org>
In-Reply-To: <20130831051703.241036187@goodmis.org>
Reply-To: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>




Sent from a tablet, I apologize for formatting issues.

Steven Rostedt <rostedt@goodmis.org> wrote:
From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Some callbacks of the function tracer use rcu_read_lock(). This means that
there's places that can not be traced because RCU is not tracking the CPU
for various reasons (like NO_HZ_FULL and coming back from userspace).

Thes functions need to be marked so that callbacks that use RCU do not
trace them.

Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/process.c |    2 ++
 drivers/cpuidle/cpuidle.c |    2 ++
 kernel/cpu/idle.c         |    2 ++
 3 files changed, 6 insertions(+)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 83369e5..18739cd 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -17,6 +17,7 @@
 #include <linux/stackprotector.h>
 #include <linux/tick.h>
 #include <linux/cpuidle.h>
+#include <linux/ftrace.h>
 #include <trace/events/power.h>
 #include <linux/hw_breakpoint.h>
 #include <asm/cpu.h>
@@ -316,6 +317,7 @@ void default_idle(void)
 #ifdef CONFIG_APM_MODULE
 EXPORT_SYMBOL(default_idle);
 #endif
+FTRACE_UNSAFE_RCU(default_idle);

 #ifdef CONFIG_XEN
 bool xen_set_default_idle(void)
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index fdc432f..9515457 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -19,6 +19,7 @@
 #include <linux/ktime.h>
 #include <linux/hrtimer.h>
 #include <linux/module.h>
+#include <linux/ftrace.h>
 #include <trace/events/power.h>

 #include "cpuidle.h"
@@ -168,6 +169,7 @@ int cpuidle_idle_call(void)

         return 0;
 }
+FTRACE_UNSAFE_RCU(cpuidle_idle_call);

 /**
  * cpuidle_install_idle_handler - installs the cpuidle idle loop handler
diff --git a/kernel/cpu/idle.c b/kernel/cpu/idle.c
index e695c0a..d9d290f 100644
--- a/kernel/cpu/idle.c
+++ b/kernel/cpu/idle.c
@@ -5,6 +5,7 @@
 #include <linux/cpu.h>
 #include <linux/tick.h>
 #include <linux/mm.h>
+#include <linux/ftrace.h>
 #include <linux/stackprotector.h>

 #include <asm/tlb.h>
@@ -61,6 +62,7 @@ void __weak arch_cpu_idle(void)
         cpu_idle_force_poll = 1;
         local_irq_enable();
 }
+FTRACE_UNSAFE_RCU(arch_cpu_idle);

 /*
  * Generic idle loop implementation
--
1.7.10.4


---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
ul. Slowackiego 173 | 80-298 Gdansk | Sad Rejonowy Gdansk Polnoc | VII Wydzial Gospodarczy Krajowego Rejestru Sadowego - KRS 101882 | NIP 957-07-52-316 | Kapital zakladowy 200.000 PLN.

Ta wiadomosc wraz z zalacznikami jest przeznaczona dla okreslonego adresata i moze zawierac informacje poufne. W razie przypadkowego otrzymania tej wiadomosci, prosimy o powiadomienie nadawcy oraz trwale jej usuniecie; jakiekolwiek przegladanie lub rozpowszechnianie jest zabronione.
This e-mail and any attachments may contain confidential material for the sole use of the intended recipient(s). If you are not the intended recipient, please contact the sender and delete all copies; any review or distribution by others is strictly prohibited.

