Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbaHRTdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 15:33:20 -0400
Received: from mail-qg0-f42.google.com ([209.85.192.42]:38913 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaHRTdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 15:33:18 -0400
MIME-Version: 1.0
In-Reply-To: <20140818153327.GA12278@ulmo>
References: <CACmBeS1kB4+=CZAtkDkM7F48m3SDgutGWGDHgPWVYDRmsDXBJw@mail.gmail.com>
	<20140818153327.GA12278@ulmo>
Date: Mon, 18 Aug 2014 12:33:17 -0700
Message-ID: <CAGa+x87ZYFR-cHGXMOXxZF4vZhtO_2qBRzXArFEFSnLF4vuN9A@mail.gmail.com>
Subject: Re: fs: panic in mnt_set_mountpoint
From: Kevin Hilman <khilman@linaro.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Jonas Jensen <jonas.jensen@gmail.com>, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 8:33 AM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Mon, Aug 18, 2014 at 01:09:24PM +0200, Jonas Jensen wrote:
>> Hi,
>>
>> I've run into a kernel panic [1] in next-20140818 you might find interesting.
>>
>> It surprised me because there was never an error in next-20140815, I
>> did a search for related panics but it came up empty.
>>
>> The board boots fine after applying the following:
>>
>> diff --git a/fs/namespace.c b/fs/namespace.c
>> index 1a2bbef..b408a9d 100644
>> --- a/fs/namespace.c
>> +++ b/fs/namespace.c
>> @@ -746,7 +746,7 @@ static void put_mountpoint(struct mountpoint *mp)
>>  {
>>         if (!--mp->m_count) {
>>                 struct dentry *dentry = mp->m_dentry;
>> -               BUG_ON(!hlist_empty(&mp->m_list));
>> +/*             BUG_ON(!hlist_empty(&mp->m_list));*/
>>                 spin_lock(&dentry->d_lock);
>>                 dentry->d_flags &= ~DCACHE_MOUNTED;
>>                 spin_unlock(&dentry->d_lock);
>> @@ -810,7 +810,7 @@ void mnt_set_mountpoint(struct mount *mnt,
>>         child_mnt->mnt_mountpoint = dget(mp->m_dentry);
>>         child_mnt->mnt_parent = mnt;
>>         child_mnt->mnt_mp = mp;
>> -       hlist_add_head(&child_mnt->mnt_mp_list, &mp->m_list);
>> +/*     hlist_add_head(&child_mnt->mnt_mp_list, &mp->m_list);*/
>>  }
>>
>>
>> [1]
>> Uncompressing Linux... done, booting the kernel.
>> [ 0.000000] Booting Linux on physical CPU 0x0
>> [ 0.000000] Linux version 3.17.0-rc1-next-20140818+ (i@Ildjarn) (gcc
>> version 4.9.0 (crosstool-NG 1.19.0) ) #2691 PREEMPT Mon Aug 18
>> 10:58:16 CEST 2014
>> [ 0.000000] CPU: FA526 [66015261] revision 1 (ARMv4), cr=0000397f
>> [ 0.000000] CPU: VIVT data cache, VIVT instruction cache
>> [ 0.000000] Machine model: MOXA UC-7112-LX
>> [ 0.000000] bootconsole [earlycon0] enabled
>> [ 0.000000] Memory policy: Data cache writeback
>> [ 0.000000] On node 0 totalpages: 8192
>> [ 0.000000] free_area_init_node: node 0, pgdat c035cfb4, node_mem_map c1fba000
>> [ 0.000000] Normal zone: 64 pages used for memmap
>> [ 0.000000] Normal zone: 0 pages reserved
>> [ 0.000000] Normal zone: 8192 pages, LIFO batch:0
>> [ 0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
>> [ 0.000000] pcpu-alloc: [0] 0
>> [ 0.000000] Built 1 zonelists in Zone order, mobility grouping on.
>> Total pages: 8128
>> [ 0.000000] Kernel command line: console=ttyS0,115200n8 earlyprintk
>> root=/dev/mmcblk0p1 rw rootwait debug
>> [ 0.000000] PID hash table entries: 128 (order: -3, 512 bytes)
>> [ 0.000000] Dentry cache hash table entries: 4096 (order: 2, 16384 bytes)
>> [ 0.000000] Inode-cache hash table entries: 2048 (order: 1, 8192 bytes)
>> [ 0.000000] Memory: 28852K/32768K available (2718K kernel code, 93K
>> rwdata, 484K rodata, 115K init, 126K bss, 3916K reserved)
>> [ 0.000000] Virtual kernel memory layout:
>> [ 0.000000] vector : 0xffff0000 - 0xffff1000 ( 4 kB)
>> [ 0.000000] fixmap : 0xffc00000 - 0xffe00000 (2048 kB)
>> [ 0.000000] vmalloc : 0xc2800000 - 0xff000000 ( 968 MB)
>> [ 0.000000] lowmem : 0xc0000000 - 0xc2000000 ( 32 MB)
>> [ 0.000000] .text : 0xc0008000 - 0xc0328aec (3203 kB)
>> [ 0.000000] .init : 0xc0329000 - 0xc0345ddc ( 116 kB)
>> [ 0.000000] .data : 0xc0346000 - 0xc035d700 ( 94 kB)
>> [ 0.000000] .bss : 0xc035d700 - 0xc037cf24 ( 127 kB)
>> [ 0.000000] SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
>> [ 0.000000] Preemptible hierarchical RCU implementation.
>> [ 0.000000] NR_IRQS:16 nr_irqs:16 16
>> [ 0.000000] sched_clock: 32 bits at 100 Hz, resolution 10000000ns,
>> wraps every 21474836480000000ns
>> [ 0.010000] Calibrating delay loop... 147.86 BogoMIPS (lpj=739328)
>> [ 0.090000] pid_max: default: 4096 minimum: 301
>> [ 0.090000] Mount-cache hash table entries: 1024 (order: 0, 4096 bytes)
>> [ 0.100000] Mountpoint-cache hash table entries: 1024 (order: 0, 4096 bytes)
>> [ 0.110000] CPU: Testing write buffer coherency: ok
>> [ 0.120000] Setting up static identity map for 0x296938 - 0x296980
>> [ 0.140000] Unhandled fault: alignment exception (0x801) at 0x00000003
>
> I've been seeing the same crash starting with next-20140818. I have slab
> allocation debugging enabled and the above unhandled fault is apparently
> caused by in-use poisoning:
>
>         [    0.301383] Unable to handle kernel paging request at virtual address 5a5a5a5e
>
> The below patch works "fixes" it for me, though I have no idea why it's
> needed all of a sudden.

FWIW, bisecting the boot failure between next-20140818 (bad) and
v3.17-rc1 (good) points the finger at:
# first bad commit: [89f7ca1af15bdfe7a6aed343032a84af2a69f736] vfs:
Keep a list of mounts on a mount point.

Kevin
