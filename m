Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbaBNAOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 19:14:51 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:43664 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbaBNAOu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 19:14:50 -0500
Date: Thu, 13 Feb 2014 16:14:38 -0800
From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, Jan Kara <jack@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH V5] mm readahead: Fix readahead fail for no local
 memory and limit readahead pages
Message-ID: <20140214001438.GB1651@linux.vnet.ibm.com>
References: <52F4B8A4.70405@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1402071239301.4212@chino.kir.corp.google.com>
 <52F88C16.70204@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1402100200420.30650@chino.kir.corp.google.com>
 <52F8C556.6090006@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1402101333160.15624@chino.kir.corp.google.com>
 <52FC6F2A.30905@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1402130003320.11689@chino.kir.corp.google.com>
 <52FC98A6.1000701@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1402131416430.13899@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402131416430.13899@chino.kir.corp.google.com>
X-Operating-System: Linux 3.11.0-15-generic (x86_64)
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021400-7182-0000-0000-000009D56AC1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.02.2014 [14:41:04 -0800], David Rientjes wrote:
> On Thu, 13 Feb 2014, Raghavendra K T wrote:
> 
> > Thanks David, unfortunately even after applying that patch, I do not see
> > the improvement.
> > 
> > Interestingly numa_mem_id() seem to still return the value of a
> > memoryless node.
> > May be  per cpu _numa_mem_ values are not set properly. Need to dig out ....
> > 
> 
> I believe ppc will be relying on __build_all_zonelists() to set 
> numa_mem_id() to be the proper node, and that relies on the ordering of 
> the zonelist built for the memoryless node.  It would be very strange if 
> local_memory_node() is returning a memoryless node because it is the first 
> zone for node_zonelist(GFP_KERNEL) (why would a memoryless node be on the 
> zonelist at all?).
> 
> I think the real problem is that build_all_zonelists() is only called at 
> init when the boot cpu is online so it's only setting numa_mem_id() 
> properly for the boot cpu.  Does it return a node with memory if you 
> toggle /proc/sys/vm/numa_zonelist_order?  Do
> 
> 	echo node > /proc/sys/vm/numa_zonelist_order
> 	echo zone > /proc/sys/vm/numa_zonelist_order
> 	echo default > /proc/sys/vm/numa_zonelist_order
> 
> and check if it returns the proper value at either point.  This will force 
> build_all_zonelists() and numa_mem_id() to point to the proper node since 
> all cpus are now online.
> 
> So the prerequisite for CONFIG_HAVE_MEMORYLESS_NODES is that there is an 
> arch-specific set_numa_mem() that makes this mapping correct like ia64 
> does.  If that's the case, then it's (1) completely undocumented and (2) 
> Nishanth's patch is incomplete because anything that adds 
> CONFIG_HAVE_MEMORYLESS_NODES needs to do the proper set_numa_mem() for it 
> to be any different than numa_node_id().

I'm working on this latter bit now. I tried to mirror ia64, but it looks
like they have CONFIG_USER_PERCPU_NUMA_NODE_ID, which powerpc doesn't.
It seems like CONFIG_USER_PERCPU_NUMA_NODE_ID and
CONFIG_HAVE_MEMORYLESS_NODES should be tied together in Kconfig?

I'll keep working, but would appreciate any further insight.

-Nish

