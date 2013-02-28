Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759471Ab3B1WMG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 17:12:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40257 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756454Ab3B1WMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 17:12:02 -0500
Date: Thu, 28 Feb 2013 14:12:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrew Shewmaker <agshew@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC PATCH v2 1/2] mm: tuning hardcoded reserved memory
Message-Id: <20130228141200.3fe7f459.akpm@linux-foundation.org>
In-Reply-To: <20130227205629.GA8429@localhost.localdomain>
References: <20130227205629.GA8429@localhost.localdomain>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2013 15:56:30 -0500
Andrew Shewmaker <agshew@gmail.com> wrote:

> The following patches are against the mmtom git tree as of February 27th.
> 
> The first patch only affects OVERCOMMIT_NEVER mode, entirely removing 
> the 3% reserve for other user processes.
> 
> The second patch affects both OVERCOMMIT_GUESS and OVERCOMMIT_NEVER 
> modes, replacing the hardcoded 3% reserve for the root user with a 
> tunable knob.
> 

Gee, it's been years since anyone thought about the overcommit code.

Documentation/vm/overcommit-accounting says that OVERCOMMIT_ALWAYS is
"Appropriate for some scientific applications", but doesn't say why. 
You're running a scientific cluster but you're using OVERCOMMIT_NEVER,
I think?  Is the documentation wrong?

> __vm_enough_memory reserves 3% of free pages with the default 
> overcommit mode and 6% when overcommit is disabled. These hardcoded 
> values have become less reasonable as memory sizes have grown.
> 
> On scientific clusters, systems are generally dedicated to one user. 
> Also, overcommit is sometimes disabled in order to prevent a long 
> running job from suddenly failing days or weeks into a calculation.
> In this case, a user wishing to allocate as much memory as possible 
> to one process may be prevented from using, for example, around 7GB 
> out of 128GB.
> 
> The effect is less, but still significant when a user starts a job 
> with one process per core. I have repeatedly seen a set of processes 
> requesting the same amount of memory fail because one of them could  
> not allocate the amount of memory a user would expect to be able to 
> allocate.
> 
> ...
>
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -182,11 +182,6 @@ int __vm_enough_memory(struct mm_struct *mm, long pages, int cap_sys_admin)
>  		allowed -= allowed / 32;
>  	allowed += total_swap_pages;
>  
> -	/* Don't let a single process grow too big:
> -	   leave 3% of the size of this process for other processes */
> -	if (mm)
> -		allowed -= mm->total_vm / 32;
> -
>  	if (percpu_counter_read_positive(&vm_committed_as) < allowed)
>  		return 0;

So what might be the downside for this change?  root can't log in, I
assume.  Have you actually tested for this scenario and observed the
effects?

If there *are* observable risks and/or to preserve back-compatibility,
I guess we could create a fourth overcommit mode which provides the
headroom which you desire.

Also, should we be looking at removing root's 3% from OVERCOMMIT_GUESS
as well?

