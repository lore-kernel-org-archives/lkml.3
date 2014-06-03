Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011AbaFCSuU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 14:50:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885AbaFCSuT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 14:50:19 -0400
Date: Tue, 3 Jun 2014 14:50:15 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: roma1390 <roma1390@gmail.com>
Cc: linux-kernel@vger.kernel.org, Morgan Mears <Morgan.Mears@netapp.com>,
        Mikulas Patocka <mpatocka@redhat.com>, Joe Thornber <ejt@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>, dm-devel@redhat.com
Subject: Re: 3.13-1 dm cache possible race condition
Message-ID: <20140603185014.GA8627@redhat.com>
References: <CACiqTEObccUuhyCcr8HZ0qZunxwdtkPLNYsp9xJRG6H6hxGo7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACiqTEObccUuhyCcr8HZ0qZunxwdtkPLNYsp9xJRG6H6hxGo7Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[please cc dm-devel rather than, or in addition to, LKML in the future]

On Sun, May 18 2014 at 11:35am -0400,
roma1390 <roma1390@gmail.com> wrote:

> I think that somehow is got broken cache->nr_dirty
> 
> # dmsetup status foo0
> 0 32768 cache 7/4096 1728240 256 1675650 0 0 64 64 4294967295 1
> writeback 2 migration_threshold 2048 4 random_threshold 4
> sequential_threshold 512
> 
> 
> See: 4294967295 this is -1 as is not OK.
> 
> 
> Kernel: Debian stock 3.13-1-amd64
> 
> Actions taken:
> 
>  modprobe brd
>  BLOCKS=$[`blockdev --getsize64 /dev/ram0`/512]
>  METADATA_DEV=/dev/ram0
>  CACHE_DEV=/dev/ram1
>  DATA_DEV=/dev/ram2
>  dmsetup create foo0 --table "0 $BLOCKS cache $METADATA_DEV $CACHE_DEV
> $DATA_DEV 512 1 writeback default 0"

Why are you limiting the dm-cache's DM table to $BLOCKS of the metadata
device (/dev/ram0)?  You should be using the DATA_DEV for the size of
the cache table.

Anyway, based on the below dmsetup status output I can infer that your
metadata device is only 16MB.  But given that you're limiting the origin
size to that 16MB and you're using a cache blocksize of 512 sectors
(256K) there really only needs to be 64 cache blocks to cover the entire
origin device with cache.

(BTW, easier to just use blockdev --getsize since DM expects units of
512b sectors)

> Test:
> one terminal window:
>   while true; do dd if=/dev/zero of=/dev/mapper/foo0 bs=512; done
> second window:
>   while sleep .1; do dmsetup status foo0; done
> 
> 
> after some time from 0 i get to 4294967295, which is think is not
> expected value.
> 
> 
> More info:
> device just created:
> 0 32768 cache 10/4096 1728259 256 1675650 0 0 0 64 0 1 writeback 2
> migration_threshold 2048 4 random_threshold 4 sequential_threshold 512

...

> 0 32768 cache 10/4096 2737453 256 2679623 0 0 0 64 4294967295 1
> writeback 2 migration_threshold 2048 4 random_threshold 4
> sequential_threshold 512

You clearly are experiencing some bug, there is no way you have that
many cache blocks.  nr_dirty should always be bound by the number of
cache blocks in the cache.  So in your case it should be limited to 64
(if I did my math above properly).

The newer DM cache versions (in 3,14 and above) provide more useful
status.  But unfortunately, with the older status output, I cannot infer
from the provided status output how large the cache really is.

Anyway, I suspect something odd is happening due to user error.  Doesn't
mean there isn't a bug.. just helps explain why we haven't seen this.

Will try to reproduce.  But in the meantime if you could retry with
>= 3.14 and clearly show the "dmsetup table" (not the shell that creates
it) that'd be helpful.
