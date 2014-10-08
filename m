Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbaJHWrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 18:47:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbaJHWrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 18:47:10 -0400
Date: Wed, 8 Oct 2014 18:41:50 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        martin.petersen@oracle.com
Subject: Re: block: fix alignment_offset math that assumes io_min is a
 power-of-2
Message-ID: <20141008224149.GB15590@redhat.com>
References: <1412805952-15316-1-git-send-email-snitzer@redhat.com>
 <5435B6C0.8020704@kernel.dk>
 <20141008222841.GA15345@redhat.com>
 <5435BCD5.9050306@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5435BCD5.9050306@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08 2014 at  6:38pm -0400,
Jens Axboe <axboe@kernel.dk> wrote:

> On 10/08/2014 04:28 PM, Mike Snitzer wrote:
> > On Wed, Oct 08 2014 at  6:12pm -0400,
> > Jens Axboe <axboe@kernel.dk> wrote:
> > 
> >> On 10/08/2014 04:05 PM, Mike Snitzer wrote:
> >>> The math in both blk_stack_limits() and queue_limit_alignment_offset()
> >>> assume that a block device's io_min (aka minimum_io_size) is always a
> >>> power-of-2.  Fix the math such that it works for non-power-of-2 io_min.
> >>>
> >>> This issue (of alignment_offset != 0) became apparent when testing
> >>> dm-thinp with a thinp blocksize that matches a RAID6 stripesize of
> >>> 1280K.  Commit fdfb4c8c1 ("dm thin: set minimum_io_size to pool's data
> >>> block size") unlocked the potential for alignment_offset != 0 due to
> >>> the dm-thin-pool's io_min possibly being a non-power-of-2.
> >>
> >> Well that sucks, AND with a mask is considerably cheaper than a MOD...
> > 
> > Yeah, certainly does suck (please note v2 that I just sent).  The MODs
> > shouldn't kill us, these functions aren't called in any real hot path.
> > A storm at boot maybe.. or SCSI rescan but...
> 
> I had it mixed up with the recent blk_max_size_offset() - you are right,
> this is not in a hot path. For that case, I don't really care, it's fine.
> 
> Is v2 runtime tested?

Yes.

Here is the DM stack for an lvm created dm-thin-pool (dm-5).

# lsblk /dev/skd0
NAME                    MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
skd0                    252:0    0 745.3G  0 disk 
├─bricks-mypool_tmeta   253:2    0  15.8G  0 lvm  
│ └─bricks-mypool-tpool 253:4    0   512G  0 lvm  
│   └─bricks-mypool     253:5    0   512G  0 lvm  
└─bricks-mypool_tdata   253:3    0   512G  0 lvm  
  └─bricks-mypool-tpool 253:4    0   512G  0 lvm  
    └─bricks-mypool     253:5    0   512G  0 lvm  

Before patch:
# cat /sys/block/dm-5/alignment_offset
1048576

After patch:
# cat /sys/block/dm-5/alignment_offset 
0
