Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529AbaKUOUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 09:20:54 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:4840 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758491AbaKUOUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 09:20:52 -0500
Date: Fri, 21 Nov 2014 09:20:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: linux-next: build failure after merge of the ftrace tree
Message-ID: <20141121092036.09edee57@gandalf.local.home>
In-Reply-To: <alpine.LNX.2.00.1411211149490.23174@pobox.suse.cz>
References: <20141121183215.01ba539c@canb.auug.org.au>
	<alpine.LNX.2.00.1411211149490.23174@pobox.suse.cz>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> From: Jiri Kosina <jkosina@suse.cz>
> Subject: [PATCH] printk: make sure printk_func_t is known in percpu.h
> 
> Commit afdc34a3d3b8 ("printk: Add per_cpu printk func to allow printk to 
> be diverted") caused percpu variable printk_func to be declared in 
> percpu.h. Make sure that the corresponding type is known at the time of 
> declaration.
> 
> Fixes build failure on certain arch/config combinations.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
>  include/linux/percpu.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/percpu.h b/include/linux/percpu.h
> index a3aa63e..c94c766 100644
> --- a/include/linux/percpu.h
> +++ b/include/linux/percpu.h
> @@ -7,6 +7,7 @@
>  #include <linux/cpumask.h>
>  #include <linux/pfn.h>
>  #include <linux/init.h>
> +#include <linux/printk.h>
>  
>  #include <asm/percpu.h>

Unfortunately, this wasn't the fix. This was an allnoconfig, which
means printk wasn't defined.

-- Steve


From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Date: Fri, 21 Nov 2014 09:16:58 -0500
Subject: [PATCH] printk/percpu: Do not define printk_func when printk is not
 defined

To avoid include hell, the per_cpu variable printk_func was declared
in percpu.h. But it is only defined if printk is defined.

Link: http://lkml.kernel.org/r/20141121183215.01ba539c@canb.auug.org.au

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/percpu.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index ba2e85a0ff5b..74398ef1d294 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -134,7 +134,9 @@ extern phys_addr_t per_cpu_ptr_to_phys(void *addr);
 	(typeof(type) __percpu *)__alloc_percpu(sizeof(type),		\
 						__alignof__(type))
 
+#ifdef CONFIG_PRINTK
 /* To avoid include hell, as printk can not declare this, we declare it here */
 DECLARE_PER_CPU(printk_func_t, printk_func);
+#endif
 
 #endif /* __LINUX_PERCPU_H */
-- 
2.1.1

