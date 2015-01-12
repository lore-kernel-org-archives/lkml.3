Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbbALNbu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 08:31:50 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:41370 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbbALNbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:31:48 -0500
Date: Mon, 12 Jan 2015 08:31:45 -0500
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 10/12] sched: use {cpu|node}mask pr_cont and seq output
 functions
Message-ID: <20150112133145.GY25319@htj.dyndns.org>
References: <1418226774-30215-1-git-send-email-tj@kernel.org>
 <1418226774-30215-11-git-send-email-tj@kernel.org>
 <20141215103915.GX29390@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141215103915.GX29390@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter.

On Mon, Dec 15, 2014 at 11:39:15AM +0100, Peter Zijlstra wrote:
> I would very much prefer something like the below instead..
> 
> I'm not a great fan of pr_cont, it makes a mess of things if there's
> multiple cpus printing bits.

Yeah, it does sometimes get annoying and bitmaps should be generic
enough to have support from core printk functions.

...
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -27,6 +27,7 @@
>  #include <linux/uaccess.h>
>  #include <linux/ioport.h>
>  #include <linux/dcache.h>
> +#include <linux/cpumask.h>
>  #include <net/addrconf.h>
>  
>  #include <asm/page.h>		/* for PAGE_SIZE */
> @@ -1218,6 +1219,7 @@ int kptr_restrict __read_mostly;
>   *            The maximum supported length is 64 bytes of the input. Consider
>   *            to use print_hex_dump() for the larger input.
>   * - 'a' For a phys_addr_t type and its derivative types (passed by reference)
> + * - 'c' For a cpumask list
>   *
>   * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
>   * function pointers are really function descriptors, which contain a
> @@ -1335,6 +1337,8 @@ char *pointer(const char *fmt, char *buf
>  		return dentry_name(buf, end,
>  				   ((const struct file *)ptr)->f_path.dentry,
>  				   spec, fmt);
> +	case 'c':
> +		return buf + cpulist_scnprintf(buf, end - buf, ptr);

I think we prolly want something more generic than hard coding cpu and
node masks into printk.  Prolly something along the line of %*pb so
that the caller can do something along the line of

  printk("cpumask: %*pb\n", nr_cpumask_bits, cpumask);

I'll see if that's actually doable.

Thanks.

-- 
tejun
