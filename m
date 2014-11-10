Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbaKJJ7F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 04:59:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152AbaKJJ7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 04:59:02 -0500
Date: Mon, 10 Nov 2014 10:58:49 +0100
From: Karel Zak <kzak@redhat.com>
To: Boaz Harrosh <boaz@plexistor.com>
Cc: Jens Axboe <axboe@fb.com>, Dave Chinner <david@fromorbit.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 5/5] brd: Add getgeo to block ops for fdisk
Message-ID: <20141110095403.GL6880@x2.net.home>
References: <545A2D69.8090003@plexistor.com>
 <545A2FEA.3050101@plexistor.com>
 <20141107092313.GH6880@x2.net.home>
 <545F9CF7.6090306@plexistor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545F9CF7.6090306@plexistor.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2014 at 06:57:27PM +0200, Boaz Harrosh wrote:
> with a small 4M disk

 This is the problem, for small disks (<= 4MiB) we don't use 1MiB
 grain because it does not make sense. For so small devices the grain
 (and the first partition offset) is the same as physical sector size. 

 Try something bigger in your tests :-)

> I see brd_getgeo() getting called on fdisk load and when pressing
> g or o. But it no longer has any effect at all if I have it defined
> returning CHS(4,64,32) or returning CHS(1,1,1) or not defined at all
> I get the same exact below experience:

 The alignment and topology code is generic, it gathers all
 information about the device, but it's fine if the device does not
 provide HDIO_GETGEO.  The geometry is currently used for DOS
 compatible mode, or SGI and  SUN only.

> ======== 4k physical_block_size PATCH ===============================================================
> 
> Command (m for help): g
> Command (m for help): n
> First sector (34-8158, default 40): 
> Last sector, +sectors or +size{K,M,G,T,P} (40-8158, default 8158): 1717
> Command (m for help): n
> First sector (34-8158, default 1720): 
> # NOTE 34-8158 again, only with gpt

 It seems like a fdisk bug, the gap between 34-40 is smaller than phy sector
 size.. I'll fix it, thanks!

> Dave, Karel, what would you say fdisk should do? do you think it behaves correctly
> to only align with the 4k-physical_block_size or must it always align ?

 If you expect partitions aligned to 4K (~pagesize?) then you have to
 provide proper information to userspace (sector size or min/opt_io),
 so from my point of view the patch makes sense.

 Note that for example zram uses 4K logical and physical sector sizes
 as well as all I/O limits are aligned to 4K at all:

 # modprobe zram
 # zramctl --find --size 4MiB
 /dev/zram0

 # fdisk -l /dev/zram0
 Disk /dev/zram0: 4 MiB, 4194304 bytes, 1024 sectors
 Units: sectors of 1 * 4096 = 4096 bytes
 Sector size (logical/physical): 4096 bytes / 4096 bytes
 I/O size (minimum/optimal): 4096 bytes / 4096 bytes


 Is there a reason for brd to behave differently?

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
