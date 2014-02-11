Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbaBKVpE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 16:45:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41616 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbaBKVpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 16:45:01 -0500
Date: Tue, 11 Feb 2014 13:44:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>, Dave Hansen <dave@sr71.net>,
        Michal Hocko <mhocko@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] drop_caches: add some documentation and info message
Message-Id: <20140211134459.551dd07d697a888e29f1c7b1@linux-foundation.org>
In-Reply-To: <20140210215416.GK6963@cmpxchg.org>
References: <1391794851-11412-1-git-send-email-hannes@cmpxchg.org>
	<52F51E19.9000406@redhat.com>
	<20140207181332.GG6963@cmpxchg.org>
	<20140207123129.84f9fb0aaf32f0e09c78851a@linux-foundation.org>
	<20140207212601.GI6963@cmpxchg.org>
	<20140210125102.86de67241664da038676af7d@linux-foundation.org>
	<20140210215416.GK6963@cmpxchg.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Feb 2014 16:54:16 -0500 Johannes Weiner <hannes@cmpxchg.org> wrote:

> How about this: we allow disabling the log message, but print the line
> of the disabling call so it's clear who dunnit.  To make sure valuable
> info is not missing in bug reports, add counters for the two events in
> /proc/vmstat.
> 
> Does that sound acceptable?

Yes, I really don't know what's the right thing to do here or where the
best tradeoff point is situated.  Let's start off this way and see what
happens I guess.

> --- a/fs/drop_caches.c
> +++ b/fs/drop_caches.c
> @@ -59,10 +59,22 @@ int drop_caches_sysctl_handler(ctl_table *table, int write,
>  	if (ret)
>  		return ret;
>  	if (write) {
> -		if (sysctl_drop_caches & 1)
> +		static int stfu;

That identifier wasn't serious, but I kinda like it.

> +
> +		if (sysctl_drop_caches & 1) {
>  			iterate_supers(drop_pagecache_sb, NULL);
> -		if (sysctl_drop_caches & 2)
> +			count_vm_event(DROP_PAGECACHE);
> +		}
> +		if (sysctl_drop_caches & 2) {
>  			drop_slab();
> +			count_vm_event(DROP_SLAB);
> +		}
> +		if (!stfu) {
> +			pr_info("%s (%d): drop_caches: %d\n",
> +				current->comm, task_pid_nr(current),
> +				sysctl_drop_caches);
> +		}
> +		stfu |= sysctl_drop_caches & 4;
>  	}
>  	return 0;
>  }

