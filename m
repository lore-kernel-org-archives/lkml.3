Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbaGaSEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 14:04:15 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:57411 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbaGaSEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 14:04:13 -0400
Message-ID: <53DA8518.3090604@gmail.com>
Date: Thu, 31 Jul 2014 21:04:08 +0300
From: Boaz Harrosh <openosd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Matthew Wilcox <willy@linux.intel.com>
CC: Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v8 04/22] Change direct_access calling convention
References: <cover.1406058387.git.matthew.r.wilcox@intel.com> <b78b33d94b669a5fbd02e06f2493b43dd5d77698.1406058387.git.matthew.r.wilcox@intel.com> <53D9174C.7040906@gmail.com> <20140730194503.GQ6754@linux.intel.com> <53DA165E.8040601@gmail.com> <20140731141315.GT6754@linux.intel.com> <53DA60A5.1030304@gmail.com> <20140731171953.GU6754@linux.intel.com>
In-Reply-To: <20140731171953.GU6754@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2014 08:19 PM, Matthew Wilcox wrote:
> On Thu, Jul 31, 2014 at 06:28:37PM +0300, Boaz Harrosh wrote:
>> Matthew what is your opinion about this, do we need to push for removal
>> of the partition dead code which never worked for brd, or we need to push
>> for fixing and implementing new partition support for brd?
> 
> Fixing the code gets my vote.  brd is useful for testing things ... and
> sometimes we need to test things that involve partitions.
> 

OK I'm on it, its what I'm doing today.

rrr I manged to completely trash my vm by doing 'make install' of
util-linux and after reboot it never recovered, I remember that
mount complained about a now missing library and I forgot and rebooted,
that was the end of that. Anyway I installed a new fc20 system wanted
that for a long time over my old fc18

>> Also another thing I saw is that if we leave the flag 
>> 	GENHD_FL_SUPPRESS_PARTITION_INFO
>>
>> then mount -U UUID stops to work, regardless of partitions or not,
>> this is because Kernel will not put us on /proc/patitions.
>> I'll submit another patch to remove it.
> 
> Yes, we should probably fix that too.
> 

Yes this is good stuff. I found out about the gpt option in fdisk
that's really good stuff because it gives you a PARTUUID even before
the mkfs, and the partitions are so mach more logical. 
But only without that flag

>> BTW I hit another funny bug where the partition beginning was not
>> 4K aligned apparently fdisk lets you do this if the total size is small
>> enough  (like 4096 which is default for brd) so I ended up with accessing
>> sec zero, the supper-block, failing because of the alignment check at
>> direct_access().
> 
> That's why I added on the partition start before doing the alignment
> check :-)
> 
Yes, exactly, I had very similar code to yours. I moved to your code
now First patch in the set is your patch 4/22 squashed with the modifications
you sent, then my fix, then the getgeo patch, then the remove of the flag.

But I'm still fighting fdisk's sector math, I can't for the life of me
figure out fdisk math, and it is all too easy to create a partition schema
that has an unaligned first/last sector.

I can observe and see the dis-alignment when the partitions are first
created, I can detect that at prd_probe time.

I can probably fix it by this logic:
  When first detecting a new partition ie if bd_part->start_sect
is not aligned round-up to PAGE_SIZE. Then subtract from bd_part->nr_sects the
fixed up size and round-down bd_part->nr_sects to PAGE_SIZE
This way I still live inside the confined space that fdisk gave me but only IO
within largest aligned space. The leftover sectors are just wasted space.


>> Do you know of any API that brd/prd can do to not let fdisk do this?
>> I'm looking at it right now I just thought it is worth asking.
> 
> I think it's enough to refuse the mount.  That feels like a patch to
> ext2/4 (or maybe ext2/4 has a way to start the filesystem on a different
> block boundary?)
> 

We should not leave this to the FSs to do again and again all over. I wonder
if there is some getgeo or some disk properties info somewhere that I can
set to force the core block layer to do this for me, I'm surprised that this
is the first place we have this problem?

Thanks
Boaz

