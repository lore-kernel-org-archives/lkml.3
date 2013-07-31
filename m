Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760292Ab3GaOkZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 10:40:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39854 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758295Ab3GaOkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 10:40:23 -0400
Date: Wed, 31 Jul 2013 16:40:19 +0200
From: Jan Kara <jack@suse.cz>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, davej@redhat.com, viro@zeniv.linux.org.uk,
        jack@suse.cz, glommer@parallels.com
Subject: Re: [PATCH 01/11] writeback: plug writeback at a high level
Message-ID: <20130731144019.GC22930@quack.suse.cz>
References: <1375244150-27296-1-git-send-email-david@fromorbit.com>
 <1375244150-27296-2-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375244150-27296-2-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 31-07-13 14:15:40, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Doing writeback on lots of little files causes terrible IOPS storms
> because of the per-mapping writeback plugging we do. This
> essentially causes imeediate dispatch of IO for each mapping,
> regardless of the context in which writeback is occurring.
> 
> IOWs, running a concurrent write-lots-of-small 4k files using fsmark
> on XFS results in a huge number of IOPS being issued for data
> writes.  Metadata writes are sorted and plugged at a high level by
> XFS, so aggregate nicely into large IOs. However, data writeback IOs
> are dispatched in individual 4k IOs, even when the blocks of two
> consecutively written files are adjacent.
> 
> Test VM: 8p, 8GB RAM, 4xSSD in RAID0, 100TB sparse XFS filesystem,
> metadata CRCs enabled.
> 
> Kernel: 3.10-rc5 + xfsdev + my 3.11 xfs queue (~70 patches)
> 
> Test:
> 
> $ ./fs_mark  -D  10000  -S0  -n  10000  -s  4096  -L  120  -d
> /mnt/scratch/0  -d  /mnt/scratch/1  -d  /mnt/scratch/2  -d
> /mnt/scratch/3  -d  /mnt/scratch/4  -d  /mnt/scratch/5  -d
> /mnt/scratch/6  -d  /mnt/scratch/7
> 
> Result:
> 
> 		wall	sys	create rate	Physical write IO
> 		time	CPU	(avg files/s)	 IOPS	Bandwidth
> 		-----	-----	------------	------	---------
> unpatched	6m56s	15m47s	24,000+/-500	26,000	130MB/s
> patched		5m06s	13m28s	32,800+/-600	 1,500	180MB/s
> improvement	-26.44%	-14.68%	  +36.67%	-94.23%	+38.46%
> 
> If I use zero length files, this workload at about 500 IOPS, so
> plugging drops the data IOs from roughly 25,500/s to 1000/s.
> 3 lines of code, 35% better throughput for 15% less CPU.
> 
> The benefits of plugging at this layer are likely to be higher for
> spinning media as the IO patterns for this workload are going make a
> much bigger difference on high IO latency devices.....
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
  Just one question: Won't this cause a regression when files are say 2 MB
large? Then we generate maximum sized requests for these files with
per-inode plugging anyway and they will unnecessarily sit in the plug list
until the plug list gets full (that is after 16 requests). Granted it
shouldn't be too long but with fast storage it may be measurable...

Now if we have maximum sized request in the plug list, maybe we could just
dispatch it right away but that's another story.


							Honza
> ---
>  fs/fs-writeback.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 68851ff..1d23d9a 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -589,7 +589,9 @@ static long writeback_sb_inodes(struct super_block *sb,
>  	unsigned long start_time = jiffies;
>  	long write_chunk;
>  	long wrote = 0;  /* count both pages and inodes */
> +	struct blk_plug plug;
>  
> +	blk_start_plug(&plug);
>  	while (!list_empty(&wb->b_io)) {
>  		struct inode *inode = wb_inode(wb->b_io.prev);
>  
> @@ -686,6 +688,7 @@ static long writeback_sb_inodes(struct super_block *sb,
>  				break;
>  		}
>  	}
> +	blk_finish_plug(&plug);
>  	return wrote;
>  }
>  
> -- 
> 1.8.3.2
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
