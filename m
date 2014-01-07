Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754108AbaAGV62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 16:58:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59553 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914AbaAGV6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 16:58:20 -0500
Date: Tue, 7 Jan 2014 13:58:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] Add a sysctl for numa_balancing v2
Message-Id: <20140107135817.7f3befadebe843761d08b812@linux-foundation.org>
In-Reply-To: <1389053326-29462-1-git-send-email-andi@firstfloor.org>
References: <1389053326-29462-1-git-send-email-andi@firstfloor.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  6 Jan 2014 16:08:46 -0800 Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> [It turns out the documentation patch was already merged
> earlier. So just resending without documentation.]

Confused.  How could we have merged the documentation for this feature
but not the feature itself?

> As discussed earlier, this adds a working sysctl to enable/disable
> automatic numa memory balancing at runtime.
> 
> This allows to track down performance problems with this
> feature and is generally a good idea.
> 
> This was possible earlier through debugfs, but only with special
> debugging options set. Also fix the boot message.
> 
> ...
>
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -398,6 +398,15 @@ static struct ctl_table kern_table[] = {
>  		.mode           = 0644,
>  		.proc_handler   = proc_dointvec,
>  	},
> +	{
> +		.procname	= "numa_balancing",
> +		.data		= NULL, /* filled in by handler */
> +		.maxlen		= sizeof(unsigned int),
> +		.mode		= 0644,
> +		.proc_handler	= sched_numa_balancing,
> +		.extra1		= &zero,
> +		.extra2		= &one,
> +	},

The name "sched_numa_balancing" is wrong.  All the other entries use
"sysctl_numa_balancing_foo", and so should this one.

--- a/include/linux/sched/sysctl.h~numa-add-a-sysctl-for-numa_balancing-fix
+++ a/include/linux/sched/sysctl.h
@@ -100,7 +100,7 @@ extern int sched_rt_handler(struct ctl_t
 		void __user *buffer, size_t *lenp,
 		loff_t *ppos);
 
-extern int sched_numa_balancing(struct ctl_table *table, int write,
+extern int sysctl_numa_balancing(struct ctl_table *table, int write,
 				 void __user *buffer, size_t *lenp,
 				 loff_t *ppos);
 
--- a/kernel/sched/core.c~numa-add-a-sysctl-for-numa_balancing-fix
+++ a/kernel/sched/core.c
@@ -1766,7 +1766,7 @@ void set_numabalancing_state(bool enable
 #endif /* CONFIG_SCHED_DEBUG */
 
 #ifdef CONFIG_PROC_SYSCTL
-int sched_numa_balancing(struct ctl_table *table, int write,
+int sysctl_numa_balancing(struct ctl_table *table, int write,
 			 void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	struct ctl_table t;
--- a/kernel/sysctl.c~numa-add-a-sysctl-for-numa_balancing-fix
+++ a/kernel/sysctl.c
@@ -401,7 +401,7 @@ static struct ctl_table kern_table[] = {
 		.data		= NULL, /* filled in by handler */
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-		.proc_handler	= sched_numa_balancing,
+		.proc_handler	= sysctl_numa_balancing,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
_

