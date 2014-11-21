Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218AbaKUO2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 09:28:05 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:15040 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755232AbaKUO2E convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 09:28:04 -0500
Date: Fri, 21 Nov 2014 09:27:46 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: linux-next: build failure after merge of the ftrace tree
Message-ID: <20141121092746.7acc5d35@gandalf.local.home>
In-Reply-To: <20141121092036.09edee57@gandalf.local.home>
References: <20141121183215.01ba539c@canb.auug.org.au>
	<alpine.LNX.2.00.1411211149490.23174@pobox.suse.cz>
	<20141121092036.09edee57@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Nov 2014 09:20:36 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:
 
> > diff --git a/include/linux/percpu.h b/include/linux/percpu.h
> > index a3aa63e..c94c766 100644
> > --- a/include/linux/percpu.h
> > +++ b/include/linux/percpu.h
> > @@ -7,6 +7,7 @@
> >  #include <linux/cpumask.h>
> >  #include <linux/pfn.h>
> >  #include <linux/init.h>
> > +#include <linux/printk.h>
> >  
> >  #include <asm/percpu.h>
> 
> Unfortunately, this wasn't the fix. This was an allnoconfig, which
> means printk wasn't defined.
> 

Just to be safe, I put the printk.h back in. Although it doesn't seem
to be needed.

-- Steve

>From da1e044a557571fd3718bd161b7ce7f36d3f999e Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Date: Fri, 21 Nov 2014 09:16:58 -0500
Subject: [PATCH] printk/percpu: Do not define printk_func when printk is not
 defined

To avoid include hell, the per_cpu variable printk_func was declared
in percpu.h. But it is only defined if printk is defined.

Also add a printk.h include in percpu.h just to be safe.

Link: http://lkml.kernel.org/r/20141121183215.01ba539c@canb.auug.org.au

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/percpu.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index ba2e85a0ff5b..87e9082a2bd4 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -5,6 +5,7 @@
 #include <linux/preempt.h>
 #include <linux/smp.h>
 #include <linux/cpumask.h>
+#include <linux/printk.h>
 #include <linux/pfn.h>
 #include <linux/init.h>
 
@@ -134,7 +135,9 @@ extern phys_addr_t per_cpu_ptr_to_phys(void *addr);
 	(typeof(type) __percpu *)__alloc_percpu(sizeof(type),		\
 						__alignof__(type))
 
+#ifdef CONFIG_PRINTK
 /* To avoid include hell, as printk can not declare this, we declare it here */
 DECLARE_PER_CPU(printk_func_t, printk_func);
+#endif
 
 #endif /* __LINUX_PERCPU_H */
-- 
1.8.1.4

