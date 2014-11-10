Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbaKJLPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 06:15:45 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:61278 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbaKJLPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 06:15:44 -0500
Message-ID: <54609E56.3050403@plexistor.com>
Date: Mon, 10 Nov 2014 13:15:34 +0200
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Karel Zak <kzak@redhat.com>, Matthew Wilcox <willy@linux.intel.com>
CC: Jens Axboe <axboe@fb.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 5/5] brd: Add getgeo to block ops for fdisk
References: <545A2D69.8090003@plexistor.com> <545A2FEA.3050101@plexistor.com> <20141107092313.GH6880@x2.net.home> <545F9CF7.6090306@plexistor.com> <20141110095403.GL6880@x2.net.home>
In-Reply-To: <20141110095403.GL6880@x2.net.home>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2014 11:58 AM, Karel Zak wrote:
> On Sun, Nov 09, 2014 at 06:57:27PM +0200, Boaz Harrosh wrote:
>> with a small 4M disk
> 
>  This is the problem, for small disks (<= 4MiB) we don't use 1MiB
>  grain because it does not make sense. For so small devices the grain
>  (and the first partition offset) is the same as physical sector size. 
> 
>  Try something bigger in your tests :-)
> 

OK thanks, I saw that. Only I was not sure what is the threshold.
just that 4MiB is the default for brd at Kconfig so I naturally hit it.

>> I see brd_getgeo() getting called on fdisk load and when pressing
>> g or o. But it no longer has any effect at all if I have it defined
>> returning CHS(4,64,32) or returning CHS(1,1,1) or not defined at all
>> I get the same exact below experience:
> 
>  The alignment and topology code is generic, it gathers all
>  information about the device, but it's fine if the device does not
>  provide HDIO_GETGEO.  The geometry is currently used for DOS
>  compatible mode, or SGI and  SUN only.
> 

OK cool. So we should just remove it. Thanks for confirming.
(When I started all this, fdisk used to prompt for these values which started
 the all land slide. Cool one problem fixed, me happy)

>> ======== 4k physical_block_size PATCH ===============================================================
>>
>> Command (m for help): g
>> Command (m for help): n
>> First sector (34-8158, default 40): 
>> Last sector, +sectors or +size{K,M,G,T,P} (40-8158, default 8158): 1717
>> Command (m for help): n
>> First sector (34-8158, default 1720): 
>> # NOTE 34-8158 again, only with gpt
> 
>  It seems like a fdisk bug, the gap between 34-40 is smaller than phy sector
>  size.. I'll fix it, thanks!
> 

Please note that the final output needs to be 1718-8158 not
40-8158. I was not sure if you noticed from your explanation above.

>> Dave, Karel, what would you say fdisk should do? do you think it behaves correctly
>> to only align with the 4k-physical_block_size or must it always align ?
> 
>  If you expect partitions aligned to 4K (~pagesize?) then you have to
>  provide proper information to userspace (sector size or min/opt_io),
>  so from my point of view the patch makes sense.
> 
>  Note that for example zram uses 4K logical and physical sector sizes
>  as well as all I/O limits are aligned to 4K at all:
> 

In theory this is a great idea and makes perfect sense. Even the
page addressing instead of the sector addressing. But what I'm afraid
will happen at Kernel is that it will attempt to do read-modify-write
on small writes, but with memory technology this makes no sense.
Actually memory is *byte* addressable.

It is good for zram because I'd guess it compresses each page so the
read-modify-write done by Kernel is good for zram, less coding.

>  # modprobe zram
>  # zramctl --find --size 4MiB
>  /dev/zram0
> 
>  # fdisk -l /dev/zram0
>  Disk /dev/zram0: 4 MiB, 4194304 bytes, 1024 sectors
>  Units: sectors of 1 * 4096 = 4096 bytes
>  Sector size (logical/physical): 4096 bytes / 4096 bytes
>  I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> 
> 
>  Is there a reason for brd to behave differently?
> 
>     Karel
> 

Thanks Karel
Boaz

