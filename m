Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933273AbaGUR5r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 13:57:47 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:43278 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933142AbaGUR5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 13:57:45 -0400
Date: Mon, 21 Jul 2014 10:57:36 -0700
From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
To: Tony Luck <tony.luck@gmail.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        linux-hotplug@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC Patch V1 00/30] Enable memoryless node on x86 platforms
Message-ID: <20140721175736.GG4156@linux.vnet.ibm.com>
References: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com>
 <20140721172331.GB4156@linux.vnet.ibm.com>
 <CA+8MBbK+ZdisT_yXh_jkWSd4hWEMisG614s4s0EyNV3j-7YOow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+8MBbK+ZdisT_yXh_jkWSd4hWEMisG614s4s0EyNV3j-7YOow@mail.gmail.com>
X-Operating-System: Linux 3.13.0-32-generic (x86_64)
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072117-9332-0000-0000-00000173F5E8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.07.2014 [10:41:59 -0700], Tony Luck wrote:
> On Mon, Jul 21, 2014 at 10:23 AM, Nishanth Aravamudan
> <nacc@linux.vnet.ibm.com> wrote:
> > It seems like the issue is the order of onlining of resources on a
> > specific x86 platform?
> 
> Yes. When we online a node the BIOS hits us with some ACPI hotplug events:
> 
> First: Here are some new cpus

Ok, so during this period, you might get some remote allocations. Do you
know the topology of these CPUs? That is they belong to a
(soon-to-exist) NUMA node? Can you online that currently offline NUMA
node at this point (so that NODE_DATA()) resolves, etc.)?

> Next: Here is some new memory

And then update the NUMA topology at this point? That is,
set_cpu_numa_node/mem as appropriate so the underlying allocators do the
right thing?

> Last; Here are some new I/O things (PCIe root ports, PCIe devices,
> IOAPICs, IOMMUs, ...)
> 
> So there is a period where the node is memoryless - although that will
> generally be resolved when the memory hot plug event arrives ... that
> isn't guaranteed to occur (there might not be any memory on the node,
> or what memory there is may have failed self-test and been disabled).

Right, but the allocator(s) generally does the right thing already in
the face of memoryless nodes -- they fallback to the nearest node. That
leads to poor performance, but is functional. Based upon the previous
thread Jiang pointed to, it seems like the real issue here isn't that
the node is memoryless, but that it's not even online yet? So NODE_DATA
access crashes?

Thanks,
Nish

