Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752159AbaBKWQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 17:16:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41794 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaBKWQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 17:16:25 -0500
Date: Tue, 11 Feb 2014 14:16:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: m@silodev.com, stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Manfred Spraul <manfred@colorfullife.com>, dledford@redhat.com
Subject: Re: [PATCH] ipc,mqueue: remove limits for the amount of system-wide
 queues
Message-Id: <20140211141624.a24283a60496b445d8434e4f@linux-foundation.org>
In-Reply-To: <1391979963.1099.34.camel@buesod1.americas.hpqcorp.net>
References: <11414.87.110.183.114.1391682066.squirrel@www.silodev.com>
	<1391803868.1099.23.camel@buesod1.americas.hpqcorp.net>
	<1391979963.1099.34.camel@buesod1.americas.hpqcorp.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 09 Feb 2014 13:06:03 -0800 Davidlohr Bueso <davidlohr@hp.com> wrote:

> From: Davidlohr Bueso <davidlohr@hp.com>
> 
> Commit 93e6f119 (ipc/mqueue: cleanup definition names and locations) added
> global hardcoded limits to the amount of message queues that can be created.
> While these limits are per-namespace, reality is that it ends up breaking
> userspace applications. Historically users have, at least in theory, been able
> to create up to INT_MAX queues, and limiting it to just 1024 is way too low
> and dramatic for some workloads and use cases. For instance, Madars reports:
> 
> "This update imposes bad limits on our multi-process application. As our
> app uses approaches that each process opens its own set of queues (usually
> something about 3-5 queues per process). In some scenarios we might run up
> to 3000 processes or more (which of-course for linux is not a problem).
> Thus we might need up to 9000 queues or more. All processes run under one
> user."
> 
> Other affected users can be found in launchpad bug #1155695:
> https://bugs.launchpad.net/ubuntu/+source/manpages/+bug/1155695
> 
> Instead of increasing this limit, revert it entirely and fallback to the
> original way of dealing queue limits -- where once a user's resource limit
> is reached, and all memory is used, new queues cannot be created.
> 
> --- a/ipc/mq_sysctl.c
> +++ b/ipc/mq_sysctl.c
> @@ -22,6 +22,16 @@ static void *get_mq(ctl_table *table)
>  	return which;
>  }
>  
> +static int proc_mq_dointvec(ctl_table *table, int write,
> +			    void __user *buffer, size_t *lenp, loff_t *ppos)
> +{
> +	struct ctl_table mq_table;
> +	memcpy(&mq_table, table, sizeof(mq_table));
> +	mq_table.data = get_mq(table);
> +
> +	return proc_dointvec(&mq_table, write, buffer, lenp, ppos);
> +}
> +
>  static int proc_mq_dointvec_minmax(ctl_table *table, int write,
>  	void __user *buffer, size_t *lenp, loff_t *ppos)
>  {
>
> ...
>
> @@ -51,9 +59,7 @@ static ctl_table mq_sysctls[] = {
>  		.data		= &init_ipc_ns.mq_queues_max,
>  		.maxlen		= sizeof(int),
>  		.mode		= 0644,
> -		.proc_handler	= proc_mq_dointvec_minmax,
> -		.extra1		= &msg_queues_limit_min,
> -		.extra2		= &msg_queues_limit_max,
> +		.proc_handler	= proc_mq_dointvec,
>  	},

hm, afaict proc_mq_dointvec() isn't needed - proc_dointvec_minmax()
will do the right thing if ->extra1 and/or ->extra2 are NULL, so we can
still use proc_mq_dointvec_minmax().

Which has absolutely nothing at all to do with your patch, but makes me
think we could take a sharp instrument to the sysctl code...
