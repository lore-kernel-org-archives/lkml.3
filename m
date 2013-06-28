Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223Ab3F1NAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 09:00:30 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:48735 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031Ab3F1NA1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 09:00:27 -0400
Date: Fri, 28 Jun 2013 09:00:15 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        roger.pau@citrix.com
Subject: Re: [GIT PULL) (xen) stable/for-jens-3.10 - Patches for Linux 3.11
Message-ID: <20130628130015.GA3284@phenom.dumpdata.com>
References: <20130624133652.GA21369@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130624133652.GA21369@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 09:36:52AM -0400, Konrad Rzeszutek Wilk wrote:
> Hey Jens,
> 
> I have a branch ready for v3.11 (the same that was for v3.10) with
> tons of fixes in it. There are some extra fixes that we are working
> through - but they are little one-line fixes (sanity checks).

The extra fix is now in the tree, which means that the diffstat has an
extra patch:


 drivers/block/xen-blkback/blkback.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

The full diffstat should look like this now:

 Documentation/ABI/testing/sysfs-driver-xen-blkback |  17 +
 .../ABI/testing/sysfs-driver-xen-blkfront          |  10 +
 drivers/block/xen-blkback/blkback.c                | 872 +++++++++++++--------
 drivers/block/xen-blkback/common.h                 | 147 +++-
 drivers/block/xen-blkback/xenbus.c                 |  85 ++
 drivers/block/xen-blkfront.c                       | 532 ++++++++++---
 include/xen/interface/io/blkif.h                   |  53 ++
 include/xen/interface/io/ring.h                    |   5 +
 8 files changed, 1299 insertions(+), 422 deletions(-)

Please pull and also if possible include below the nice blurb. Thanks!

> 
> Since the merge window could open shortly and those little one-line
> fixes can be applied later I am hoping you could pull this
> branch:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens-3.10
> 
> and then when we are done talking over the little one-line fixes
> I can send again a pull with the fixes.
> 
> Here is the description of what this git pull contains:
> <blurb>
> It has the 'feature-max-indirect-segments' implemented in both backend
> and frontend. The current problem with the backend and frontend is that the
> segment size is limited to 11 pages. It means we can at most squeeze in 44kB per
> request. The ring can hold 32 (next power of two below 36) requests, meaning we
> can do 1.4M of outstanding requests. Nowadays that is not enough.
> 
> The problem in the past was addressed in two ways - but neither one went upstream.
> The first solution to this proposed by Justin from Spectralogic was to negotiate
> the segment size.  This means that the ‘struct blkif_sring_entry’ is now a variable size.
> It can expand from 112 bytes (cover 11 pages of data - 44kB) to 1580 bytes
> (256 pages of data - so 1MB). It is a simple extension by just making the array in the
> request expand from 11 to a variable size negotiated. But it had limits: this extension
> still limits the number of segments per request to 255 (as the total number must be
> specified in the request, which only has an 8-bit field for that purpose).
> 
> The other solution (from Intel - Ronghui) was to create one extra ring that only has the
> ‘struct blkif_request_segment’ in them. The ‘struct blkif_request’ would be changed to have
> an index in said ‘segment ring’. There is only one segment ring. This means that the size of
> the initial ring is still the same. The requests would point to the segment and enumerate out
> how many of the indexes it wants to use. The limit is of course the size of the segment.
> If one assumes a one-page segment this means we can in one request cover ~4MB.
> 
> Those patches were posted as RFC and the author never followed up on the ideas on changing
> it to be a bit more flexible.
> 
> There is yet another mechanism that could be employed  (which these patches implement) - and it
> borrows from VirtIO protocol. And that is the ‘indirect descriptors’. This very similar to
> what Intel suggests, but with a twist. The twist is to negotiate how many of these
> 'segment' pages (aka indirect descriptor pages) we want to support (in reality we negotiate
> how many entries in the segment we want to cover, and we module the number if it is
> bigger than the segment size).
> 
> This means that with the existing 36 slots in the ring (single page) we can cover:
> 32 slots * each blkif_request_indirect covers: 512 * 4096 ~= 64M. Since we ample space
> in the blkif_request_indirect to span more than one indirect page, that number (64M)
> can be also multiplied by eight = 512MB.
> 
> Roger Pau Monne took the idea and implemented them in these patches. They work
> great and the corner cases (migration between backends with and without this extension)
> work nicely. The backend has a limit right now off how many indirect entries
> it can handle: one indirect page, and at maximum 256 entries (out of 512 - so  50% of the page
> is used). That comes out to 32 slots * 256 entries in a indirect page * 1 indirect page
> per request * 4096 = 32MB.
> 
> This is a conservative number that can change in the future. Right now it strikes
> a good balance between giving excellent performance, memory usage in the backend, and
> balancing the needs of many guests.
> 
> In the patchset there is also the split of the blkback structure to be per-VBD.
> This means that the spinlock contention we had with many guests trying to do I/O and
> all the blkback threads hitting the same lock has been eliminated.
> 
> Also there are bug-fixes to deal with oddly sized sectors, insane amounts on
> th ring, and also a security fix (posted earlier).
> </blurb>
> 
> Here is the full diffstat and such:
> 
> 
>  Documentation/ABI/testing/sysfs-driver-xen-blkback |  17 +
>  .../ABI/testing/sysfs-driver-xen-blkfront          |  10 +
>  drivers/block/xen-blkback/blkback.c                | 869 +++++++++++++--------
>  drivers/block/xen-blkback/common.h                 | 147 +++-
>  drivers/block/xen-blkback/xenbus.c                 |  85 ++
>  drivers/block/xen-blkfront.c                       | 532 ++++++++++---
>  include/xen/interface/io/blkif.h                   |  53 ++
>  include/xen/interface/io/ring.h                    |   5 +
>  8 files changed, 1297 insertions(+), 421 deletions(-)
> 
> Jan Beulich (1):
>       xen/io/ring.h: new macro to detect whether there are too many requests on the ring
> 
> Konrad Rzeszutek Wilk (5):
>       xen-blkfront: Introduce a 'max' module parameter to alter the amount of indirect segments.
>       xen-blkback/sysfs: Move the parameters for the persistent grant features
>       xen/blkback: Check device permissions before allowing OP_DISCARD
>       xen/blkback: Check for insane amounts of request on the ring (v6).
>       Merge branch 'stable/for-jens-3.10' into HEAD
> 
> Roger Pau Monne (11):
>       xen-blkback: print stats about persistent grants
>       xen-blkback: use balloon pages for all mappings
>       xen-blkback: implement LRU mechanism for persistent grants
>       xen-blkback: move pending handles list from blkbk to pending_req
>       xen-blkback: make the queue of free requests per backend
>       xen-blkback: expand map/unmap functions
>       xen-block: implement indirect descriptors
>       xen-blkback: allocate list of pending reqs in small chunks
>       xen-blkfront: use a different scatterlist for each request
>       xen-blkback: workaround compiler bug in gcc 4.1
>       xen-blkfront: set blk_queue_max_hw_sectors correctly
> 
> Stefan Bader (1):
>       xen/blkback: Use physical sector size for setup
> 
> 
>  Documentation/ABI/testing/sysfs-driver-xen-blkback |  17 +
>  .../ABI/testing/sysfs-driver-xen-blkfront          |  10 +
>  drivers/block/xen-blkback/blkback.c                | 869 +++++++++++++--------
>  drivers/block/xen-blkback/common.h                 | 147 +++-
>  drivers/block/xen-blkback/xenbus.c                 |  85 ++
>  drivers/block/xen-blkfront.c                       | 532 ++++++++++---
>  include/xen/interface/io/blkif.h                   |  53 ++
>  include/xen/interface/io/ring.h                    |   5 +
>  8 files changed, 1297 insertions(+), 421 deletions(-)
> 
> Jan Beulich (1):
>       xen/io/ring.h: new macro to detect whether there are too many requests on the ring
> 
> Konrad Rzeszutek Wilk (5):
>       xen-blkfront: Introduce a 'max' module parameter to alter the amount of indirect segments.
>       xen-blkback/sysfs: Move the parameters for the persistent grant features
>       xen/blkback: Check device permissions before allowing OP_DISCARD
>       xen/blkback: Check for insane amounts of request on the ring (v6).
>       Merge branch 'stable/for-jens-3.10' into HEAD
> 
> Roger Pau Monne (11):
>       xen-blkback: print stats about persistent grants
>       xen-blkback: use balloon pages for all mappings
>       xen-blkback: implement LRU mechanism for persistent grants
>       xen-blkback: move pending handles list from blkbk to pending_req
>       xen-blkback: make the queue of free requests per backend
>       xen-blkback: expand map/unmap functions
>       xen-block: implement indirect descriptors
>       xen-blkback: allocate list of pending reqs in small chunks
>       xen-blkfront: use a different scatterlist for each request
>       xen-blkback: workaround compiler bug in gcc 4.1
>       xen-blkfront: set blk_queue_max_hw_sectors correctly
> 
> Stefan Bader (1):
>       xen/blkback: Use physical sector size for setup
> 
