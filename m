Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbaAWGGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 01:06:21 -0500
Received: from mail-gg0-f169.google.com ([209.85.161.169]:62560 "EHLO
	mail-gg0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbaAWGGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 01:06:18 -0500
Date: Wed, 22 Jan 2014 22:06:14 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tang Chen <tangchen@cn.fujitsu.com>
cc: davej@redhat.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        akpm@linux-foundation.org, zhangyanfei@cn.fujitsu.com,
        guz.fnst@cn.fujitsu.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] numa, mem-hotplug: Fix stack overflow in numa when seting
 kernel nodes to unhotpluggable.
In-Reply-To: <1390456168-28259-1-git-send-email-tangchen@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.02.1401222203330.8088@chino.kir.corp.google.com>
References: <1390456168-28259-1-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jan 2014, Tang Chen wrote:

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
> Reported-by: Dave Jones <davej@redhat.com>
> Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
> Tested-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

I guess it depends on what Dave's CONFIG_NODES_SHIFT is?

> ---
>  arch/x86/mm/numa.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
> index 81b2750..ebefeb7 100644
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
>  

Isn't this also a bugfix since you never initialize numa_kernel_nodes when 
it's allocated on the stack with NODE_MASK_NONE?
