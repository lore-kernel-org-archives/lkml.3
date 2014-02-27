Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbaB0Q33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:29:29 -0500
Received: from mga14.intel.com ([143.182.124.37]:48684 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927AbaB0Q32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:29:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,555,1389772800"; 
   d="scan'208";a="482984049"
Date: Thu, 27 Feb 2014 11:29:23 -0500
From: Matthew Wilcox <willy@linux.intel.com>
To: Florian Weimer <fweimer@redhat.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v6 00/22] Support ext4 on NV-DIMMs
Message-ID: <20140227162923.GH5744@linux.intel.com>
References: <1393337918-28265-1-git-send-email-matthew.r.wilcox@intel.com>
 <530F451F.9020107@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530F451F.9020107@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 03:01:03PM +0100, Florian Weimer wrote:
> On 02/25/2014 03:18 PM, Matthew Wilcox wrote:
> >One of the primary uses for NV-DIMMs is to expose them as a block device
> >and use a filesystem to store files on the NV-DIMM.  While that works,
> >it currently wastes memory and CPU time buffering the files in the page
> >cache.  We have support in ext2 for bypassing the page cache, but it
> >has some races which are unfixable in the current design.  This series
> >of patches rewrite the underlying support, and add support for direct
> >access to ext4.
> 
> I'm wondering if there is a potential security issue lurking here.
> 
> Some distributions use udisks2 to grant permission to local console
> users to create new loop devices from files.  File systems on these
> block devices are then mounted.  This is a replacement for several
> file systems implemented in user space, and for the users, this is a
> good thing because the in-kernel implementations are generally of
> higher quality.

Just to be sure I understand; the user owns the file (so can change any
bit in it at will), and the loop device is used to present that file
to the filesystem as a block device to be mounted?  Have we fuzz-tested
all the filesystems enough to be sure that's safe?  :-)

> What happens if we have DAX support in the entire stack, and an
> enterprising user mounts a file system?  Will she be able to fuzz
> the file system or binfmt loaders concurrently, changing the bits
> while they are being read?
> 
> Currently, it appears that the loop device duplicates pages in the
> page cache, so this does not seem to be possible, but DAX support
> might change this.

I haven't looked at adding DAX support to the loop device, although
that would make sense.  At the moment, neither ext2 nor ext4 (our only
DAX-supporting filesystems) use DAX for their metadata, only for user
data.  As far as fuzzing the binfmt loaders ... are these filesystems not
forced to be at least nosuid?  I might go so far as to make them noexec.

Thanks for thinking about this.  I didn't know allowing users to mount
files they owned was something distros actually did.  Have we considered
prohibiting the user from modifying the file while it's mounted, eg
forcing its permissions to 0 or pretending it's immutable?

