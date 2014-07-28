Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbaG1T00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 15:26:26 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59506 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbaG1T0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 15:26:21 -0400
Date: Mon, 28 Jul 2014 12:26:02 -0700
From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Rob Herring <robh+dt@kernel.org>, Tony Luck <tony.luck@intel.com>,
        linux-mm@kvack.org, linux-hotplug@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [RFC Patch V1 22/30] mm, of: Use cpu_to_mem()/numa_mem_id() to
 support memoryless node
Message-ID: <20140728192602.GF24458@linux.vnet.ibm.com>
References: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com>
 <1405064267-11678-23-git-send-email-jiang.liu@linux.intel.com>
 <20140721175241.GF4156@linux.vnet.ibm.com>
 <20140728133040.854F5C4095E@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140728133040.854F5C4095E@trevor.secretlab.ca>
X-Operating-System: Linux 3.13.0-32-generic (x86_64)
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072819-0928-0000-0000-000003B882D0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.07.2014 [07:30:40 -0600], Grant Likely wrote:
> On Mon, 21 Jul 2014 10:52:41 -0700, Nishanth Aravamudan <nacc@linux.vnet.ibm.com> wrote:
> > On 11.07.2014 [15:37:39 +0800], Jiang Liu wrote:
> > > When CONFIG_HAVE_MEMORYLESS_NODES is enabled, cpu_to_node()/numa_node_id()
> > > may return a node without memory, and later cause system failure/panic
> > > when calling kmalloc_node() and friends with returned node id.
> > > So use cpu_to_mem()/numa_mem_id() instead to get the nearest node with
> > > memory for the/current cpu.
> > > 
> > > If CONFIG_HAVE_MEMORYLESS_NODES is disabled, cpu_to_mem()/numa_mem_id()
> > > is the same as cpu_to_node()/numa_node_id().
> > > 
> > > Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> > > ---
> > >  drivers/of/base.c |    2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/of/base.c b/drivers/of/base.c
> > > index b9864806e9b8..40d4772973ad 100644
> > > --- a/drivers/of/base.c
> > > +++ b/drivers/of/base.c
> > > @@ -85,7 +85,7 @@ EXPORT_SYMBOL(of_n_size_cells);
> > >  #ifdef CONFIG_NUMA
> > >  int __weak of_node_to_nid(struct device_node *np)
> > >  {
> > > -	return numa_node_id();
> > > +	return numa_mem_id();
> > >  }
> > >  #endif
> > 
> > Um, NAK. of_node_to_nid() returns the NUMA node ID for a given device
> > tree node. The default should be the physically local NUMA node, not the
> > nearest memory-containing node.
> 
> That description doesn't match the code. This patch only changes the
> default implementation of of_node_to_nid() which doesn't take the device
> node into account *at all* when returning a node ID. Just look at the
> diff.

I meant that of_node_to_nid() seems to be used throughout the call-sites
to indicate caller locality. We want to keep using cpu_to_node() there,
and fallback appropriately in the MM (when allocations occur offnode due
to memoryless nodes), not indicate memory-specific topology the caller
itself. There was a long thread between between Tejun and I that
discussed what we are trying for: https://lkml.org/lkml/2014/7/18/278

I understand that the code unconditionally returns current's NUMA node
ID right now (ignoring the device node). That seems correct, to me, for
something like:

of_device_add:
	/* device_add will assume that this device is on the same node as
         * the parent. If there is no parent defined, set the node
         * explicitly */
        if (!ofdev->dev.parent)
                set_dev_node(&ofdev->dev, of_node_to_nid(ofdev->dev.of_node));

I don't think we want the default implementation to set the NUMA node of
a dev to the nearest NUMA node with memory?

> I think this patch is correct, and it doesn't affect the override
> versions provided by powerpc and sparc.

Yes, agreed, so maybe it doesn't matter. I guess my point was simply
that it only seems reasonable to change callers of cpu_to_node() to
cpu_to_mem() that aren't in the core MM is if they care about memoryless
nodes explicitly. I don't think the OF code does, so I don't think it
should change.

Sorry for my premature NAK and lack of clarity in my explanation.

-Nish

