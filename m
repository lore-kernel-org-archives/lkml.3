Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbaCROiE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 10:38:04 -0400
Received: from qmta02.emeryville.ca.mail.comcast.net ([76.96.30.24]:40246 "EHLO
	qmta02.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752264AbaCROiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 10:38:01 -0400
Date: Tue, 18 Mar 2014 09:37:58 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Grygorii Strashko <grygorii.strashko@ti.com>
cc: linux-arm <linux-arm-kernel@lists.infradead.org>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [linux-next][regression] [PATCH] percpu: add preemption checks
 to __this_cpu ops
In-Reply-To: <53285FE7.5010203@ti.com>
Message-ID: <alpine.DEB.2.10.1403180922050.17965@nuc>
References: <53285FE7.5010203@ti.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2014, Grygorii Strashko wrote:

> diff --git a/lib/smp_processor_id.c b/lib/smp_processor_id.c
> index a270dce..73a2004 100644
> --- a/lib/smp_processor_id.c
> +++ b/lib/smp_processor_id.c
> @@ -58,9 +58,6 @@ EXPORT_SYMBOL(debug_smp_processor_id);
>
>  notrace void __this_cpu_preempt_check(const char *op)
>  {
> -       char text[40];
> -
> -       snprintf(text, sizeof(text), "__this_cpu_%s()", op);
> -       check_preemption_disabled(text);
> +       check_preemption_disabled(op);
>  }
>  EXPORT_SYMBOL(__this_cpu_preempt_check);

So it looks like there is an early this cpu operation in a context that
cannot handle snprintf. But the checks in check_preemption_disabled()
avoid processing there so that works.

We could fix this by moving the string concatenation operation into
the check function.

Index: linux/lib/smp_processor_id.c
===================================================================
--- linux.orig/lib/smp_processor_id.c	2014-03-18 09:36:31.330450525 -0500
+++ linux/lib/smp_processor_id.c	2014-03-18 09:36:37.822315534 -0500
@@ -7,7 +7,8 @@
 #include <linux/kallsyms.h>
 #include <linux/sched.h>

-notrace static unsigned int check_preemption_disabled(char *what)
+notrace static unsigned int check_preemption_disabled(const char *what1,
+							const char *what2)
 {
 	int this_cpu = raw_smp_processor_id();

@@ -38,8 +39,8 @@
 	if (!printk_ratelimit())
 		goto out_enable;

-	printk(KERN_ERR "BUG: using %s in preemptible [%08x] code: %s/%d\n",
-		what, preempt_count() - 1, current->comm, current->pid);
+	printk(KERN_ERR "BUG: using %s%s() in preemptible [%08x] code: %s/%d\n",
+		what1, what2, preempt_count() - 1, current->comm, current->pid);

 	print_symbol("caller is %s\n", (long)__builtin_return_address(0));
 	dump_stack();
@@ -52,15 +53,12 @@

 notrace unsigned int debug_smp_processor_id(void)
 {
-	return check_preemption_disabled("smp_processor_id()");
+	return check_preemption_disabled("smp_processor_id","");
 }
 EXPORT_SYMBOL(debug_smp_processor_id);

 notrace void __this_cpu_preempt_check(const char *op)
 {
-	char text[40];
-
-	snprintf(text, sizeof(text), "__this_cpu_%s()", op);
-	check_preemption_disabled(text);
+	check_preemption_disabled("__this_cpu_", op);
 }
 EXPORT_SYMBOL(__this_cpu_preempt_check);
