Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbbA2PL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:11:57 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:59360 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbbA2PLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:11:55 -0500
Date: Fri, 30 Jan 2015 00:12:27 +0900
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Ganesh Mahendran <opensource.ganesh@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        sergey.senozhatsky.work@gmail.com
Subject: Re: [PATCH v1 2/2] zram: remove init_lock in zram_make_request
Message-ID: <20150129151227.GA936@swordfish>
References: <1422432945-6764-1-git-send-email-minchan@kernel.org>
 <1422432945-6764-2-git-send-email-minchan@kernel.org>
 <CADAEsF9tejvCL3gqGuYKsnv_wsfpsESsAg=Hm3r_ZfbpftE4-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADAEsF9tejvCL3gqGuYKsnv_wsfpsESsAg=Hm3r_ZfbpftE4-w@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (01/29/15 21:48), Ganesh Mahendran wrote:
> > Admin could reset zram during I/O operation going on so we have
> > used zram->init_lock as read-side lock in I/O path to prevent
> > sudden zram meta freeing.
> 
> When I/O operation is running, that means the /dev/zram0 is
> mounted or swaped on. Then the device could not be reset by
> below code:
> 
>     /* Do not reset an active device! */
>     if (bdev->bd_holders) {
>         ret = -EBUSY;
>         goto out;
>     }
> 
> So the zram->init_lock in I/O path is to check whether the device
> has been initialized(echo xxx > /sys/block/zram/disk_size).
> 

for mounted device (w/fs), we see initial (well, it goes up and down
many times while we create device, but this is not interesting here)
->bd_holders increment in:
  vfs_kern_mount -> mount_bdev -> blkdev_get_by_path -> blkdev_get

and it goes to zero in:
  cleanup_mnt -> deactivate_super -> kill_block_super -> blkdev_put


after umount we still have init device. so, *theoretically*, we
can see something like

	CPU0				CPU1
umount
reset_store			
bdev->bd_holders == 0			mount
...					zram_make_request()
zram_reset_device()

w/o zram->init_lock in both zram_reset_device() and zram_make_request()
one of CPUs will be a bit sad.

	-ss
