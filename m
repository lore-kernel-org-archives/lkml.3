Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbaJHW2s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 18:28:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbaJHW2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 18:28:47 -0400
Date: Wed, 8 Oct 2014 18:28:41 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        martin.petersen@oracle.com
Subject: Re: block: fix alignment_offset math that assumes io_min is a
 power-of-2
Message-ID: <20141008222841.GA15345@redhat.com>
References: <1412805952-15316-1-git-send-email-snitzer@redhat.com>
 <5435B6C0.8020704@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5435B6C0.8020704@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08 2014 at  6:12pm -0400,
Jens Axboe <axboe@kernel.dk> wrote:

> On 10/08/2014 04:05 PM, Mike Snitzer wrote:
> > The math in both blk_stack_limits() and queue_limit_alignment_offset()
> > assume that a block device's io_min (aka minimum_io_size) is always a
> > power-of-2.  Fix the math such that it works for non-power-of-2 io_min.
> > 
> > This issue (of alignment_offset != 0) became apparent when testing
> > dm-thinp with a thinp blocksize that matches a RAID6 stripesize of
> > 1280K.  Commit fdfb4c8c1 ("dm thin: set minimum_io_size to pool's data
> > block size") unlocked the potential for alignment_offset != 0 due to
> > the dm-thin-pool's io_min possibly being a non-power-of-2.
> 
> Well that sucks, AND with a mask is considerably cheaper than a MOD...

Yeah, certainly does suck (please note v2 that I just sent).  The MODs
shouldn't kill us, these functions aren't called in any real hot path.
A storm at boot maybe.. or SCSI rescan but...
