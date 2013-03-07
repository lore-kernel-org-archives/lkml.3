Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933598Ab3CGWTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 17:19:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16892 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932792Ab3CGWTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 17:19:06 -0500
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=a9sOzq6JSfgA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=xYge-vcl5VgA:10 a=JatEOj8P9v7UvTNb6BUA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1362694743.31874.66.camel@gandalf.local.home>
Subject: [PATCH] init: Scream bloody murder if interrupts are enabled too
 early
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Ard van Breemen <ard@telegraafnet.nl>
Date: Thu, 07 Mar 2013 17:19:03 -0500
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

Adding a WARN_ON() makes this bug a little more obvious:

[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 2003192k/2054848k available (4792k kernel code, 460k absent, 51196k reserved, 6277k data, 1152k init)
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at /home/rostedt/work/git/linux-trace.git/init/main.c:543 start_kernel+0x215/0x40e()
[    0.000000] Hardware name: To Be Filled By O.E.M.
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper/0 Not tainted 3.8.0-test+ #275
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff8103781d>] warn_slowpath_common+0x83/0x9b
[    0.000000]  [<ffffffff8103784f>] warn_slowpath_null+0x1a/0x1c
[    0.000000]  [<ffffffff81ae5a30>] start_kernel+0x215/0x40e
[    0.000000]  [<ffffffff81ae5623>] ? repair_env_string+0x56/0x56
[    0.000000]  [<ffffffff81ae5312>] x86_64_start_reservations+0x10e/0x112
[    0.000000]  [<ffffffff81ae5120>] ? early_idt_handlers+0x120/0x120
[    0.000000]  [<ffffffff81ae5418>] x86_64_start_kernel+0x102/0x111
[    0.000000] ---[ end trace 1ca9c978643fe899 ]---
[    0.000000] start_kernel(): bug: interrupts were enabled *very* early, fixing it
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]  RCU restricting CPUs from NR_CPUS=8 to nr_cpu_ids=4.
[    0.000000] NR_IRQS:4352 nr_irqs:712 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled, bootconsole disabled
[    0.000000] console [ttyS0] enabled, bootconsole disabled

Do you see it?

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/init/main.c b/init/main.c
index 63534a1..f0fe0a5 100644
--- a/init/main.c
+++ b/init/main.c
@@ -539,7 +539,7 @@ asmlinkage void __init start_kernel(void)
 	 * fragile until we cpu_idle() for the first time.
 	 */
 	preempt_disable();
-	if (!irqs_disabled()) {
+	if (WARN_ON(!irqs_disabled())) {
 		printk(KERN_WARNING "start_kernel(): bug: interrupts were "
 				"enabled *very* early, fixing it\n");
 		local_irq_disable();


