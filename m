Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200AbaAWGCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 01:02:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58617 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaAWGCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 01:02:21 -0500
Date: Wed, 22 Jan 2014 22:05:20 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: davej@redhat.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        zhangyanfei@cn.fujitsu.com, guz.fnst@cn.fujitsu.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] numa, mem-hotplug: Fix stack overflow in numa when
 seting kernel nodes to unhotpluggable.
Message-Id: <20140122220520.d0a773a7.akpm@linux-foundation.org>
In-Reply-To: <1390456168-28259-1-git-send-email-tangchen@cn.fujitsu.com>
References: <1390456168-28259-1-git-send-email-tangchen@cn.fujitsu.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jan 2014 13:49:28 +0800 Tang Chen <tangchen@cn.fujitsu.com> wrote:

> Dave found that the kernel will hang during boot. This is because
> the nodemask_t type stack variable numa_kernel_nodes is large enough
> to overflow the stack.
> 
> This doesn't always happen. According to Dave, this happened once
> in about five boots. The backtrace is like the following:
> 
> dump_stack
> panic
> ? numa_clear_kernel_node_hotplug
> __stack_chk_fail
> numa_clear_kernel_node_hotplug
> ? memblock_search_pfn_nid
> ? __early_pfn_to_nid
> numa_init
> x86_numa_init
> initmem_init
> setup_arch
> start_kernel
> 
> This patch fix this problem by defining numa_kernel_nodes as a
> static global variable in __initdata area.
> 
> ...
>
> --- a/arch/x86/mm/numa.c
> +++ b/arch/x86/mm/numa.c
> @@ -562,10 +562,10 @@ static void __init numa_init_array(void)
>  	}
>  }
>  
> +static nodemask_t numa_kernel_nodes __initdata;
>  static void __init numa_clear_kernel_node_hotplug(void)
>  {
>  	int i, nid;
> -	nodemask_t numa_kernel_nodes;
>  	unsigned long start, end;
>  	struct memblock_type *type = &memblock.reserved;

Seems odd.  The maximum size of a nodemask_t is 128 bytes, isn't it? 
If so, what the heck have we done in there to consume so much stack?

