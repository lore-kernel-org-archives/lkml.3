Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057AbaKIQ5c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 11:57:32 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:55265 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbaKIQ5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 11:57:30 -0500
Message-ID: <545F9CF7.6090306@plexistor.com>
Date: Sun, 09 Nov 2014 18:57:27 +0200
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Karel Zak <kzak@redhat.com>, Jens Axboe <axboe@fb.com>,
        Dave Chinner <david@fromorbit.com>
CC: Matthew Wilcox <willy@linux.intel.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 5/5] brd: Add getgeo to block ops for fdisk
References: <545A2D69.8090003@plexistor.com> <545A2FEA.3050101@plexistor.com> <20141107092313.GH6880@x2.net.home>
In-Reply-To: <20141107092313.GH6880@x2.net.home>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2014 11:23 AM, Karel Zak wrote:
> On Wed, Nov 05, 2014 at 04:10:50PM +0200, Boaz Harrosh wrote:
>> From: Boaz Harrosh <boaz@plexistor.com>
>>
>> Now when fdisk is run on brd it will ask some cryptic
>> questions about CHS. This is because the getgeo block operation
>> is not implemented.
> 
>  Again, what fdisk (util-linux) version?
> 

Hi Karel, Dave and Jens

With Fedora 20 > "fdisk from util-linux 2.24.2"

>> I have done a quick audit of the fdisk code. The CHS calculation
>> is very convoluted but at the end it comes out with a number.
>> Which is taken into consideration in first-sector to allow. With
>> all 1(s) this numbers is very small and other numbers come into
>> account. Also note that if the device is big like 1G (not sure what
>> is the threshold) fdisk will offer 1M (2048) as possible first-
>> sector, and it does not matter what numbers we give here.
> 
>  oh.. sounds like archeology, CHS calculation does not mater in the
>  current code, it follows I/O limits (including crazy alignment
>  offset).
> 

with a small 4M disk

I see brd_getgeo() getting called on fdisk load and when pressing
g or o. But it no longer has any effect at all if I have it defined
returning CHS(4,64,32) or returning CHS(1,1,1) or not defined at all
I get the same exact below experience:
(Dropping the none-relevant prompts)

======== *WITHOUT* 4k physical_block_size PATCH ===============================================================
Command (m for help): g
Command (m for help): n
First sector (34-8158, default 34): 
Last sector, +sectors or +size{K,M,G,T,P} (34-8158, default 8158): 1717
Command (m for help): n
First sector (1718-8158, default 1718): 
# NOTE first sector is last "prev-end" + 1
Last sector, +sectors or +size{K,M,G,T,P} (1718-8158, default 8158): 
Command (m for help): p
  Disk /dev/ram0: 4 MiB, 4194304 bytes, 8192 sectors
  Units: sectors of 1 * 512 = 512 bytes
  Sector size (logical/physical): 512 bytes / 512 bytes
  I/O size (minimum/optimal): 512 bytes / 512 bytes
  Disklabel type: gpt
  Disk identifier: 5C14F69F-EA44-4FE3-984A-9948D6AB7628

  Device      Start          End   Size Type
  /dev/ram0p1    34         1717   842K Linux filesystem
  /dev/ram0p2  1718         8158   3.1M Linux filesystem

---

Command (m for help): o
Command (m for help): n
First sector (1-8191, default 1): 
Last sector, +sectors or +size{K,M,G,T,P} (1-8191, default 8191): 1717
Command (m for help): n
First sector (1718-8191, default 1718): 
# NOTE same here
Last sector, +sectors or +size{K,M,G,T,P} (1718-8191, default 8191): 
Command (m for help): p
  Disk /dev/ram0: 4 MiB, 4194304 bytes, 8192 sectors
  Units: sectors of 1 * 512 = 512 bytes
  Sector size (logical/physical): 512 bytes / 512 bytes
  I/O size (minimum/optimal): 512 bytes / 512 bytes
  Disklabel type: dos
  Disk identifier: 0xe5c9e1b1

  Device      Boot Start       End Blocks  Id System
  /dev/ram0p1          1      1717    858+ 83 Linux
  /dev/ram0p2       1718      8191   3237  83 Linux

======== 4k physical_block_size PATCH ===============================================================

Command (m for help): g
Command (m for help): n
First sector (34-8158, default 40): 
Last sector, +sectors or +size{K,M,G,T,P} (40-8158, default 8158): 1717
Command (m for help): n
First sector (34-8158, default 1720): 
# NOTE 34-8158 again, only with gpt
Last sector, +sectors or +size{K,M,G,T,P} (1720-8158, default 8158): 
Command (m for help): p
  Disk /dev/ram0: 4 MiB, 4194304 bytes, 8192 sectors
  Units: sectors of 1 * 512 = 512 bytes
  Sector size (logical/physical): 512 bytes / 4096 bytes
  I/O size (minimum/optimal): 512 bytes / 512 bytes
  Disklabel type: gpt
  Disk identifier: 892E3C8A-3942-4C06-9B5B-6BA6B5A84AB9

  Device      Start          End   Size Type
  /dev/ram0p1    40         1717   839K Linux filesystem
  /dev/ram0p2  1720         8158   3.1M Linux filesystem

---

Command (m for help): o
Command (m for help): n
First sector (8-8191, default 8): 
Last sector, +sectors or +size{K,M,G,T,P} (8-8191, default 8191): 1717
Command (m for help): n
First sector (1718-8191, default 1720): 
# NOTE with dos its good
Last sector, +sectors or +size{K,M,G,T,P} (1720-8191, default 8191): 
Command (m for help): p
  Disk /dev/ram0: 4 MiB, 4194304 bytes, 8192 sectors
  Units: sectors of 1 * 512 = 512 bytes
  Sector size (logical/physical): 512 bytes / 4096 bytes
  I/O size (minimum/optimal): 512 bytes / 512 bytes
  Disklabel type: dos
  Disk identifier: 0xaa069afe

  Device      Boot Start       End Blocks  Id System
  /dev/ram0p1          8      1717    855  83 Linux
  /dev/ram0p2       1720      8191   3236  83 Linux

=======

So I'm dropping the getgeo() patch all together. It is now fixed with new
util-linux 2.24.2 and is not needed at all. (Before fdisk gave me a prompt
on load without it)

Jens please drop this patch titled:
	[PATCH 5/5] brd: Add getgeo to block ops for fdisk

Dave, Karel, what would you say fdisk should do? do you think it behaves correctly
to only align with the 4k-physical_block_size or must it always align ?

So it looks like we still need the 4k-physical_block_size PATCH for current
fdisk, I don't mind if it is decided to be fixed in user-mode then we can
drop this patch as well.

[ For Karel 2 things:
  - It looks like getgeo has no effect (Is it used at all?), you might want to
    remove the call. (libgparted does not use it)
  - Checkout the small bug above with gpt and first-sector of second partition
]

Many Thanks
Boaz
