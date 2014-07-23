Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865AbaGWOfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 10:35:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:53946 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757805AbaGWOfU (ORCPT <rfc822;Linux-Kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 10:35:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,717,1400050800"; 
   d="scan'208";a="574236160"
Date: Wed, 23 Jul 2014 10:34:53 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Howard Chu <hyc@symas.com>
Cc: Linux Kernel Mailing List <Linux-Kernel@vger.kernel.org>
Subject: Re: [PATCH v8 00/22] Support ext4 on NV-DIMMs
Message-ID: <20140723143453.GE6754@linux.intel.com>
References: <cover.1406058387.git.matthew.r.wilcox@intel.com>
 <00ad731b459e32ce965af8530bcd611a141e41b6.1406058387.git.matthew.r.wilcox@intel.com>
 <20140723121025.GE10317@node.dhcp.inet.fi>
 <20140723135514.GB6754@linux.intel.com>
 <53CFC258.6050803@symas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CFC258.6050803@symas.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 07:10:32AM -0700, Howard Chu wrote:
> Matthew Wilcox wrote:
> >One of the primary uses for NV-DIMMs is to expose them as a block device
> >and use a filesystem to store files on the NV-DIMM. While that works,
> >it currently wastes memory and CPU time buffering the files in the page
> >cache. We have support in ext2 for bypassing the page cache, but it
> >has some races which are unfixable in the current design. This series
> >of patches rewrite the underlying support, and add support for direct
> >access to ext4.
> 
> This is an awful lot of work to go thru just to get a glorified ext4
> RAMdisk. RAMdisks are one of the worst possible uses for RAM, requiring
> users to explicitly copy files to them before getting any benefit. Using RAM
> for a page cache instead brings benefits to all file accesses without
> requiring any user intervention.

Perhaps you misunderstand the problem.  There are many different kinds
of NV-DIMM out there today with different performance characteristics.
One that has been described to me has write times 1000x slower than read
times.  In that situation, you can't possibly "just use it as page cache";
you need to place the read-often; write-rarely files on that media.

> If the NVDIMM range was reserved for exclusive use of the page cache, then
> you would have an avenue to get persistence/safety for every filesystem
> mounted on a machine, not just a special case ext4.

No you wouldn't; you'd also need to have a mechanism to store the state
of the page cache persistently.  And you have to make sure that the
filesystem does appropriate cache invalidations.  By going the route
here, we can use the existing caching mechanisms (eg FS-Cache) which
have solved all the hard problems of making sure that local caches are
coherent with storage.
