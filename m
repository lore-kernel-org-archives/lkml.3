Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbaAWGBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 01:01:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635AbaAWGBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 01:01:31 -0500
Date: Thu, 23 Jan 2014 01:01:09 -0500
From: Dave Jones <davej@redhat.com>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        akpm@linux-foundation.org, zhangyanfei@cn.fujitsu.com,
        guz.fnst@cn.fujitsu.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] numa, mem-hotplug: Fix stack overflow in numa when
 seting kernel nodes to unhotpluggable.
Message-ID: <20140123060109.GA15206@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Tang Chen <tangchen@cn.fujitsu.com>, tglx@linutronix.de,
	mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org,
	zhangyanfei@cn.fujitsu.com, guz.fnst@cn.fujitsu.com, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <1390456168-28259-1-git-send-email-tangchen@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390456168-28259-1-git-send-email-tangchen@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 01:49:28PM +0800, Tang Chen wrote:
 
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

I'm surprised that this worked for anyone.
By my math, nodemask_t is 1024 longs, which should fill the whole stack.

Any idea why it only broke sometimes ?

There are other on-stack nodemask_t's in the tree too, why are they safe ?

	Dave

