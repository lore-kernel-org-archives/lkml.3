Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab3HQASX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:18:23 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:54308 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab3HQAST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 20:18:19 -0400
Date: Fri, 16 Aug 2013 14:07:37 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dave Hansen <dave@sr71.net>, Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC][PATCH] drivers: base: dynamic memory block creation
Message-ID: <20130816190737.GC7265@variantweb.net>
References: <1376508705-3188-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <20130814194043.GA10469@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130814194043.GA10469@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081619-7606-0000-0000-00000E66D744
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 12:40:43PM -0700, Greg Kroah-Hartman wrote:
> On Wed, Aug 14, 2013 at 02:31:45PM -0500, Seth Jennings wrote:
> > Large memory systems (~1TB or more) experience boot delays on the order
> > of minutes due to the initializing the memory configuration part of
> > sysfs at /sys/devices/system/memory/.
> > 
> > ppc64 has a normal memory block size of 256M (however sometimes as low
> > as 16M depending on the system LMB size), and (I think) x86 is 128M.  With
> > 1TB of RAM and a 256M block size, that's 4k memory blocks with 20 sysfs
> > entries per block that's around 80k items that need be created at boot
> > time in sysfs.  Some systems go up to 16TB where the issue is even more
> > severe.
> > 
> > This patch provides a means by which users can prevent the creation of
> > the memory block attributes at boot time, yet still dynamically create
> > them if they are needed.
> > 
> > This patch creates a new boot parameter, "largememory" that will prevent
> > memory_dev_init() from creating all of the memory block sysfs attributes
> > at boot time.  Instead, a new root attribute "show" will allow
> > the dynamic creation of the memory block devices.
> > Another new root attribute "present" shows the memory blocks present in
> > the system; the valid inputs for the "show" attribute.
> 
> Ick, no new boot parameters please, that's just a mess for distros and
> users.

Yes, I agreed it isn't the best.  The reason for it is backward
compatibility; or rather the user saying "I knowingly forfeit backward
compatibility in favor of fast boot time and all my userspace tools are
aware of the new requirement to show memory blocks before trying to use
them".

The only suggestion I heard that would make full backward compatibility
possible is one from Dave to create a new filesystem for memory blocks
(not sysfs) where the memory block directories would be dynamically
created as programs tried to access/open them. But you'd still have the
issue of requiring user intervention to mount that "memoryfs" at
/sys/devices/system/memory (or whatever your sysfs mount point was).

So it's tricky.

> 
> How about tying this into the work that has been happening on lkml with
> booting large-memory systems faster?  The work there should solve the
> problems you are seeing here (i.e. add memory after booting).  It looks
> like this is the same issue you are having here, just in a different
> part of the kernel.

I assume you are referring to the "[RFC v3 0/5] Transparent on-demand
struct page initialization embedded in the buddy allocator" thread.  I
think that trying to solve a different problem than I am trying to solve
though.  IIUC, that patch series is deferring the initialization of the
actually memory pages.

I'm working on breaking out just the refactoring patches (no functional
change) into a reviewable patch series.  Thanks for your time looking at
this!

Seth

