Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbaA1C4G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 21:56:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572AbaA1C4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 21:56:04 -0500
Date: Mon, 27 Jan 2014 21:55:37 -0500
From: Dave Jones <davej@redhat.com>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, akpm@linux-foundation.org, zhangyanfei@cn.fujitsu.com,
        guz.fnst@cn.fujitsu.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] numa, mem-hotplug: Fix stack overflow in numa when
 seting kernel nodes to unhotpluggable.
Message-ID: <20140128025537.GA21730@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Tang Chen <tangchen@cn.fujitsu.com>,
	David Rientjes <rientjes@google.com>, tglx@linutronix.de,
	mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org,
	zhangyanfei@cn.fujitsu.com, guz.fnst@cn.fujitsu.com, x86@kernel.org,
	linux-kernel@vger.kernel.org
References: <1390456168-28259-1-git-send-email-tangchen@cn.fujitsu.com>
 <alpine.DEB.2.02.1401222203330.8088@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1401271631090.17114@chino.kir.corp.google.com>
 <52E70165.8070709@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E70165.8070709@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 09:01:25AM +0800, Tang Chen wrote:
 > On 01/28/2014 08:32 AM, David Rientjes wrote:
 > > On Wed, 22 Jan 2014, David Rientjes wrote:
 > >
 > >>>   arch/x86/mm/numa.c | 2 +-
 > >>>   1 file changed, 1 insertion(+), 1 deletion(-)
 > >>>
 > >>> diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
 > >>> index 81b2750..ebefeb7 100644
 > >>> --- a/arch/x86/mm/numa.c
 > >>> +++ b/arch/x86/mm/numa.c
 > >>> @@ -562,10 +562,10 @@ static void __init numa_init_array(void)
 > >>>   	}
 > >>>   }
 > >>>
 > >>> +static nodemask_t numa_kernel_nodes __initdata;
 > >>>   static void __init numa_clear_kernel_node_hotplug(void)
 > >>>   {
 > >>>   	int i, nid;
 > >>> -	nodemask_t numa_kernel_nodes;
 > >>>   	unsigned long start, end;
 > >>>   	struct memblock_type *type =&memblock.reserved;
 > >>>
 > >>
 > >> Isn't this also a bugfix since you never initialize numa_kernel_nodes when
 > >> it's allocated on the stack with NODE_MASK_NONE?
 > >>
 > >
 > > This hasn't been answered and the patch still isn't in linux-kernel yet
 > > Dave tested it as good.  I'm suspicious of the changelog that indicates
 > > this nodemask is the result of a stack overflow itself which only manages
 > > to reproduce itself in the init patch slightly more than 50% of the time.
 > > How is that possible?
 > >
 > > I think the changelog should indicate this also fixes an uninitialized
 > > nodemask issue.
 > 
 > Hi David,
 > 
 > I'm still working on this problem, but unfortunately nothing new for now.
 > And the test till now shows no more problem here.
 > 
 > I'm digging into it, but need more time.
 > 
 > I'll resend a new patch and modify the changelog soon. Before we find the
 > root cause, I think we can use this patch as a temporary solution.

Ok, I hit the 2nd bug again (oops in next_zones_zonelist...)

I did a bisect with the patch above applied each step of the way.
This time I got a plausible looking result....


a0acda917284183f9b71e2d08b0aa0aea722b321 is the first bad commit
commit a0acda917284183f9b71e2d08b0aa0aea722b321
Author: Tang Chen <tangchen@cn.fujitsu.com>
Date:   Tue Jan 21 15:49:32 2014 -0800

    acpi, numa, mem_hotplug: mark all nodes the kernel resides un-hotpluggable
    

Reverting this commit of course removes the whole function from above,
so we haven't really learned anything new, other than that commit is broken,
even after the above fix-up.

	Dave

