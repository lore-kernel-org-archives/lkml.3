Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbaBEW0K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 17:26:10 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:43875 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957AbaBEWKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 17:10:22 -0500
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 02/51] Doc/cpu-hotplug: Specify race-free way to register CPU
 hotplug callbacks
To: paulus@samba.org, oleg@redhat.com, rusty@rustcorp.com.au,
        peterz@infradead.org, tglx@linutronix.de, akpm@linux-foundation.org
Cc: mingo@kernel.org, paulmck@linux.vnet.ibm.com, tj@kernel.org,
        walken@google.com, ego@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Date: Thu, 06 Feb 2014 03:34:58 +0530
Message-ID: <20140205220457.19080.30489.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020522-0260-0000-0000-00000450B659
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recommend the usage of the new CPU hotplug callback registration APIs
(__register_cpu_notifier() etc), when subsystems need to also perform
initialization for already online CPUs. Provide examples of correct
and race-free ways of achieving this, and point out the kinds of code
that are error-prone.

Cc: Rob Landley <rob@landley.net>
Cc: linux-doc@vger.kernel.org
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 Documentation/cpu-hotplug.txt |   45 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/Documentation/cpu-hotplug.txt b/Documentation/cpu-hotplug.txt
index be675d2..42831b7 100644
--- a/Documentation/cpu-hotplug.txt
+++ b/Documentation/cpu-hotplug.txt
@@ -312,12 +312,57 @@ things will happen if a notifier in path sent a BAD notify code.
 Q: I don't see my action being called for all CPUs already up and running?
 A: Yes, CPU notifiers are called only when new CPUs are on-lined or offlined.
    If you need to perform some action for each cpu already in the system, then
+   do this:
 
 	for_each_online_cpu(i) {
 		foobar_cpu_callback(&foobar_cpu_notifier, CPU_UP_PREPARE, i);
 		foobar_cpu_callback(&foobar_cpu_notifier, CPU_ONLINE, i);
 	}
 
+   However, if you want to register a hotplug callback, as well as perform
+   some initialization for CPUs that are already online, then do this:
+
+   Version 1: (Correct)
+   ---------
+
+   	cpu_maps_update_begin();
+
+		for_each_online_cpu(i) {
+			foobar_cpu_callback(&foobar_cpu_notifier,
+					    CPU_UP_PREPARE, i);
+			foobar_cpu_callback(&foobar_cpu_notifier,
+					    CPU_ONLINE, i);
+		}
+
+	/* Note the use of the double underscored version of the API */
+	__register_cpu_notifier(&foobar_cpu_notifier);
+
+	cpu_maps_update_done();
+
+   Note that the following code is *NOT* the right way to achieve this,
+   because it is prone to an ABBA deadlock between the cpu_add_remove_lock
+   and the cpu_hotplug.lock.
+
+   Version 2: (Wrong!)
+   ---------
+
+	get_online_cpus();
+
+		for_each_online_cpu(i) {
+			foobar_cpu_callback(&foobar_cpu_notifier,
+					    CPU_UP_PREPARE, i);
+			foobar_cpu_callback(&foobar_cpu_notifier,
+					    CPU_ONLINE, i);
+		}
+
+	register_cpu_notifier(&foobar_cpu_notifier);
+
+	put_online_cpus();
+
+    So always use the first version shown above when you want to register
+    callbacks as well as initialize the already online CPUs.
+
+
 Q: If i would like to develop cpu hotplug support for a new architecture,
    what do i need at a minimum?
 A: The following are what is required for CPU hotplug infrastructure to work

