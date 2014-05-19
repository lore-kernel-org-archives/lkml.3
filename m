Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbaESUbW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 16:31:22 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:54188 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaESUbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 16:31:20 -0400
MIME-Version: 1.0
In-Reply-To: <CACiqTEObccUuhyCcr8HZ0qZunxwdtkPLNYsp9xJRG6H6hxGo7Q@mail.gmail.com>
References: <CACiqTEObccUuhyCcr8HZ0qZunxwdtkPLNYsp9xJRG6H6hxGo7Q@mail.gmail.com>
Date: Mon, 19 May 2014 23:31:20 +0300
Message-ID: <CACiqTEPUn_ZD6ut_hMnpCH_CwmR+GgLTG3GQqjmXh3rQ7PNO6A@mail.gmail.com>
Subject: Re: 3.13-1 dm cache possible race condition
From: roma1390 <roma1390@gmail.com>
To: linux-kernel@vger.kernel.org, Morgan Mears <Morgan.Mears@netapp.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, Joe Thornber <ejt@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again.

Tried this on latest head: 14186fea0cb06bc43181ce239efe0df6f1af260a

Getting same error. If there is needed some additional information,
please contact.

On Sun, May 18, 2014 at 6:35 PM, roma1390 <roma1390@gmail.com> wrote:
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
>
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
> after some (~20) writes:
> 0 32768 cache 10/4096 1790456 256 1737543 0 0 0 64 0 1 writeback 2
> migration_threshold 2048 4 random_threshold 4 sequential_threshold 512
> started full speed test, after 2 sec:
> 0 32768 cache 10/4096 2475934 256 2417479 0 0 0 64 0 1 writeback 2
> migration_threshold 2048 4 random_threshold 4 sequential_threshold 512
> 0 32768 cache 10/4096 2485872 256 2428545 0 0 0 64 5 1 writeback 2
> migration_threshold 2048 4 random_threshold 4 sequential_threshold 512
> 0 32768 cache 10/4096 2495964 256 2437959 0 0 0 64 0 1 writeback 2
> migration_threshold 2048 4 random_threshold 4 sequential_threshold 512
> 0 32768 cache 10/4096 2506447 256 2447365 0 0 0 64 20 1 writeback 2
> migration_threshold 2048 4 random_threshold 4 sequential_threshold 512
> 0 32768 cache 10/4096 2515948 256 2458439 0 0 0 64 0 1 writeback 2
> migration_threshold 2048 4 random_threshold 4 sequential_threshold 512
> 0 32768 cache 10/4096 2526687 256 2466631 0 0 0 64 0 1 writeback 2
> migration_threshold 2048 4 random_threshold 4 sequential_threshold 512
> after ~10sec:
> 0 32768 cache 10/4096 2667754 256 2609991 0 0 0 64 0 1 writeback 2
> migration_threshold 2048 4 random_threshold 4 sequential_threshold 512
> 0 32768 cache 10/4096 2678571 256 2618183 0 0 0 64 4294967295 1
> writeback 2 migration_threshold 2048 4 random_threshold 4
> sequential_threshold 512
> 0 32768 cache 10/4096 2687846 256 2630471 0 0 0 64 4294967295 1
> writeback 2 migration_threshold 2048 4 random_threshold 4
> sequential_threshold 512
> 0 32768 cache 10/4096 2698349 256 2638663 0 0 0 64 4294967295 1
> writeback 2 migration_threshold 2048 4 random_threshold 4
> sequential_threshold 512
> 0 32768 cache 10/4096 2708082 256 2648514 0 0 0 64 5 1 writeback 2
> migration_threshold 2048 4 random_threshold 4 sequential_threshold 512
> 0 32768 cache 10/4096 2717700 256 2659143 0 0 0 64 4294967295 1
> writeback 2 migration_threshold 2048 4 random_threshold 4
> sequential_threshold 512
> 0 32768 cache 10/4096 2728596 256 2667335 0 0 0 64 4294967295 1
> writeback 2 migration_threshold 2048 4 random_threshold 4
> sequential_threshold 512
> 0 32768 cache 10/4096 2737453 256 2679623 0 0 0 64 4294967295 1
> writeback 2 migration_threshold 2048 4 random_threshold 4
> sequential_threshold 512
> ^C
