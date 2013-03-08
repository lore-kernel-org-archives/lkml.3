Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934228Ab3CHOsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 09:48:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25611 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757872Ab3CHOsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 09:48:14 -0500
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=pE2RfcJUNw4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=qJ9awtIP2uUA:10 a=NGDtfeR3KDeQInN0DFEA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1362754092.31874.97.camel@gandalf.local.home>
Subject: [PATCH v2] init: Scream bloody murder if interrupts are enabled too
 early
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Ard van Breemen <ard@telegraafnet.nl>
Date: Fri, 08 Mar 2013 09:48:12 -0500
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Andrew, can you pull this patch into -mm? ]

As I was testing a lot of my code recently, and having several
"successes", I accidentally noticed in the dmesg this little line:

[    0.000000] start_kernel(): bug: interrupts were enabled *very* early, fixing it


Sure enough, one of my patches two commits ago enabled interrupts early.
The sad part here is that I never noticed it, and I ran several tests
with ktest too, and ktest did not notice this line.

What ktest looks for (and so does many other automated testing scripts)
is a back trace produced by a WARN_ON() or BUG(). As a back trace was
never produced, my buggy patch could have slipped into linux-next, or
even worse, mainline.

Adding a WARN(!irqs_disabled()) makes this bug a little more obvious:

[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 2003252k/2054848k available (4857k kernel code, 460k absent, 51136k reserved, 6210k data, 1096k init)
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at /home/rostedt/work/git/linux-trace.git/init/main.c:543 start_kernel+0x21e/0x415()
[    0.000000] Hardware name: To Be Filled By O.E.M.
[    0.000000] Interrupts were enabled *very* early, fixing it
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper/0 Not tainted 3.8.0-test+ #286
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81037b79>] warn_slowpath_common+0x83/0x9b
[    0.000000]  [<ffffffff81037c34>] warn_slowpath_fmt+0x46/0x48
[    0.000000]  [<ffffffff81ae4a39>] start_kernel+0x21e/0x415
[    0.000000]  [<ffffffff81ae4623>] ? repair_env_string+0x56/0x56
[    0.000000]  [<ffffffff81ae4312>] x86_64_start_reservations+0x10e/0x112
[    0.000000]  [<ffffffff81ae4120>] ? early_idt_handlers+0x120/0x120
[    0.000000]  [<ffffffff81ae4418>] x86_64_start_kernel+0x102/0x111
[    0.000000] ---[ end trace 007d8b0491b4f5d8 ]---
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]  RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=4.
[    0.000000] NR_IRQS:4352 nr_irqs:712 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled, bootconsole disabled

Do you see it?

The original version of this patch just slapped a WARN_ON() in there and
kept the printk(). Ard van Breemen suggested using the WARN() interface,
which makes the code a bit cleaner.

Also, while examining other warnings in init/main.c, I found two other
locations that deserve a bloody murder scream if their conditions are
hit, and updated them accordingly.

Cc: Ard van Breemen <ard@telegraafnet.nl>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-trace.git/init/main.c
===================================================================
--- linux-trace.git.orig/init/main.c
+++ linux-trace.git/init/main.c
@@ -539,11 +539,8 @@ asmlinkage void __init start_kernel(void
 	 * fragile until we cpu_idle() for the first time.
 	 */
 	preempt_disable();
-	if (!irqs_disabled()) {
-		printk(KERN_WARNING "start_kernel(): bug: interrupts were "
-				"enabled *very* early, fixing it\n");
+	if (WARN(!irqs_disabled(), "Interrupts were enabled *very* early, fixing it\n"))
 		local_irq_disable();
-	}
 	idr_init_cache();
 	perf_event_init();
 	rcu_init();
@@ -558,9 +555,7 @@ asmlinkage void __init start_kernel(void
 	time_init();
 	profile_init();
 	call_function_init();
-	if (!irqs_disabled())
-		printk(KERN_CRIT "start_kernel(): bug: interrupts were "
-				 "enabled early\n");
+	WARN(!irqs_disabled(), "Interrupts were enabled early\n");
 	early_boot_irqs_disabled = false;
 	local_irq_enable();
 
@@ -702,9 +697,7 @@ int __init_or_module do_one_initcall(ini
 		strlcat(msgbuf, "disabled interrupts ", sizeof(msgbuf));
 		local_irq_enable();
 	}
-	if (msgbuf[0]) {
-		printk("initcall %pF returned with %s\n", fn, msgbuf);
-	}
+	WARN(msgbuf[0], "initcall %pF returned with %s\n", fn, msgbuf);
 
 	return ret;
 }


