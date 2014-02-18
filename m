Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbaBRBbN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 20:31:13 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41803 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097AbaBRBbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 20:31:11 -0500
Date: Mon, 17 Feb 2014 17:31:00 -0800
From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, Jan Kara <jack@suse.cz>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH V5] mm readahead: Fix readahead fail for no local
 memory and limit readahead pages
Message-ID: <20140218013100.GA31998@linux.vnet.ibm.com>
References: <52FC6F2A.30905@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1402130003320.11689@chino.kir.corp.google.com>
 <52FC98A6.1000701@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1402131416430.13899@chino.kir.corp.google.com>
 <20140214001438.GB1651@linux.vnet.ibm.com>
 <CA+55aFwH8BqyLSqyLL7g-08nOtnOrJ9vKj4ebiSqrxc5ooEjLw@mail.gmail.com>
 <20140214043235.GA21999@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1402140244330.12099@chino.kir.corp.google.com>
 <20140217192803.GA14586@linux.vnet.ibm.com>
 <alpine.DEB.2.02.1402171501001.25724@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1402171501001.25724@chino.kir.corp.google.com>
X-Operating-System: Linux 3.11.0-15-generic (x86_64)
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021801-5806-0000-0000-000024277510
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.02.2014 [15:14:06 -0800], David Rientjes wrote:
> On Mon, 17 Feb 2014, Nishanth Aravamudan wrote:
> 
> > Here is what I'm running into now:
> > 
> > setup_arch ->
> > 	do_init_bootmem ->
> > 		cpu_numa_callback ->
> > 			numa_setup_cpu ->
> > 				map_cpu_to_node -> 
> > 					update_numa_cpu_lookup_table
> > 
> > Which current updates the powerpc specific numa_cpu_lookup_table. I
> > would like to update that function to use set_cpu_numa_node() and
> > set_cpu_numa_mem(), but local_memory_node() is not yet functional
> > because build_all_zonelists is called later in start_kernel. Would it
> > make sense for first_zones_zonelist() to return NUMA_NO_NODE if we
> > don't have a zone?
> > 
> 
> Hmm, I don't think we'll want to modify the generic first_zones_zonelist() 
> for a special case that is only true during boot.  Instead, would it make 
> sense to modify numa_setup_cpu() to use the generic cpu_to_node() instead 
> of using a powerpc mapping and then do the set_cpu_numa_mem() after 
> paging_init() when the zonelists will have been built and zones without 
> present pages are properly excluded?

Sorry, I was unclear in my e-mail. I meant to modify
local_memory_node(), not first_zones_zonelist(). Well, it only needs the
following, I think?

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e3758a0..5de4337 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3650,6 +3650,8 @@ int local_memory_node(int node)
                                   gfp_zone(GFP_KERNEL),
                                   NULL,
                                   &zone);
+       if (!zone)
+               return NUMA_NO_NODE;
        return zone->node;
 }
 #endif

I think that condition should only happen during boot -- maybe even
deserving of an unlikely, but I don't think the above is considered a
hot-path. If the above isn't palatable, I can look into your suggestion
instead.

Thanks,
Nish

