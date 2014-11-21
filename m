Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbaKUCAO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 21:00:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756702AbaKUCAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 21:00:12 -0500
Date: Thu, 20 Nov 2014 20:59:41 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, martin.petersen@oracle.com,
        hch@infradead.org, mst@redhat.com, rusty@rustcorp.com.au,
        dm-devel@redhat.com
Subject: Re: virtio_blk: fix defaults for max_hw_sectors and max_segment_size
Message-ID: <20141121015941.GC2287@redhat.com>
References: <20141120190058.GA31214@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120190058.GA31214@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20 2014 at  2:00pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> virtio_blk incorrectly established -1U as the default for these
> queue_limits.  Set these limits to sane default values to avoid crashing
> the kernel.  But the virtio-blk protocol should probably be extended to
> allow proper stacking of the disk's limits from the host.
> 
> This change fixes a crash that was reported when virtio-blk was used to
> test linux-dm.git commit 604ea90641b4 ("dm thin: adjust max_sectors_kb
> based on thinp blocksize") that will initially set max_sectors to
> max_hw_sectors and then rounddown to the first power-of-2 factor of the
> DM thin-pool's blocksize.  Basically that commit assumes drivers don't
> suck when establishing max_hw_sectors so it acted like a canary in the
> coal mine.

I have changed that DM thinp code to not be so fragile with this
follow-on fix:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-for-3.19&id=971ab7029b61ec10e0765bfb96331448ce5c3094

> In the case of a DM thin-pool built ontop of virtio-blk data device
> these are the insane limits that were established for the DM thin-pool:
> 
>   # cat /sys/block/dm-6/queue/max_sectors_kb
>   1073741824
>   # cat /sys/block/dm-6/queue/max_hw_sectors_kb
>   2147483647
> 
> by stacking the virtio-blk device's limits:
> 
>   # cat /sys/block/vdb/queue/max_sectors_kb
>   512
>   # cat /sys/block/vdb/queue/max_hw_sectors_kb
>   2147483647
> 
> Attempting to mkfs.xfs against a thin device from this thin-pool quickly
> resulted in fs/direct-io.c:dio_send_cur_page()'s BUG_ON.

But virtio_blk really must be fixed.  I'll post v2 of this patch with a
revised header that skips all the references to DM thinp, etc.
