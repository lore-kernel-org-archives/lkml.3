Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbaKZUyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 15:54:09 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:49682 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaKZUyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 15:54:07 -0500
Message-ID: <54763DEC.3050207@kernel.dk>
Date: Wed, 26 Nov 2014 13:54:04 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: Christoph Hellwig <hch@infradead.org>, martin.petersen@oracle.com,
        mst@redhat.com, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
        qemu-devel@nongnu.org, dm-devel@redhat.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: virtio_blk: fix defaults for max_hw_sectors and max_segment_size
References: <20141120190058.GA31214@redhat.com> <20141121095456.GB8866@infradead.org> <20141121154920.GA7644@redhat.com> <54762E9A.2070007@kernel.dk> <20141126205106.GA31815@redhat.com>
In-Reply-To: <20141126205106.GA31815@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2014 01:51 PM, Mike Snitzer wrote:
> On Wed, Nov 26 2014 at  2:48pm -0500,
> Jens Axboe <axboe@kernel.dk> wrote:
> 
>> On 11/21/2014 08:49 AM, Mike Snitzer wrote:
>>> On Fri, Nov 21 2014 at  4:54am -0500,
>>> Christoph Hellwig <hch@infradead.org> wrote:
>>>
>>>> On Thu, Nov 20, 2014 at 02:00:59PM -0500, Mike Snitzer wrote:
>>>>> virtio_blk incorrectly established -1U as the default for these
>>>>> queue_limits.  Set these limits to sane default values to avoid crashing
>>>>> the kernel.  But the virtio-blk protocol should probably be extended to
>>>>> allow proper stacking of the disk's limits from the host.
>>>>>
>>>>> This change fixes a crash that was reported when virtio-blk was used to
>>>>> test linux-dm.git commit 604ea90641b4 ("dm thin: adjust max_sectors_kb
>>>>> based on thinp blocksize") that will initially set max_sectors to
>>>>> max_hw_sectors and then rounddown to the first power-of-2 factor of the
>>>>> DM thin-pool's blocksize.  Basically that commit assumes drivers don't
>>>>> suck when establishing max_hw_sectors so it acted like a canary in the
>>>>> coal mine.
>>>>
>>>> Is that a crash in the host or guest?  What kind of mishandling did you
>>>> see?  Unless the recent virtio standard changed anything the host
>>>> should be able to handle our arbitrary limits, and even if it doesn't
>>>> that something we need to hash out with qemu and the virtio standards
>>>> folks.
>>>
>>> Some good news: this guest crash isn't an issue with recent kernels (so
>>> upstream, fedora 20, RHEL7, etc aren't impacted -- Jens feel free to
>>> drop my virtio_blk patch; even though some of it's limits are clearly
>>> broken I'll defer to the virtio_blk developers on the best way forward
>>> -- sorry for the noise!).
>>>
>>> The BUG I saw only seems to impact RHEL6 kernels so far (note to self,
>>> actually _test_ on upstream before reporting a crash against upstream!)
>>>
>>> [root@RHEL-6 ~]# echo 1073741824 > /sys/block/vdc/queue/max_sectors_kb
>>> [root@RHEL-6 ~]# lvs
>>>
>>> Message from syslogd@RHEL-6 at Nov 21 15:32:15 ...
>>>  kernel:Kernel panic - not syncing: Fatal exception
>>>
>>> Here is the RHEL6 guest crash, just for full disclosure:
>>>
>>> kernel BUG at fs/direct-io.c:696!
>>> invalid opcode: 0000 [#1] SMP
>>> last sysfs file: /sys/devices/virtual/block/dm-4/dev
>>> CPU 0
>>> Modules linked in: nfs lockd fscache auth_rpcgss nfs_acl sunrpc ipv6 ext2 dm_thin_pool dm_bio_prison dm_persistent_data dm_bufio libcrc32c dm_mirror dm_region_hash dm_log dm_mod microcode virtio_balloon i2c_piix4 i2c_core virtio_net ext4 jbd2 mbcache virtio_blk virtio_pci virtio_ring virtio pata_acpi ata_generic ata_piix [last unloaded: speedstep_lib]
>>>
>>> Pid: 1679, comm: lvs Not tainted 2.6.32 #6 Bochs Bochs
>>> RIP: 0010:[<ffffffff811ce336>]  [<ffffffff811ce336>] __blockdev_direct_IO_newtrunc+0x986/0x1270
>>> RSP: 0018:ffff88011a11ba48  EFLAGS: 00010287
>>> RAX: 0000000000000000 RBX: ffff8801192fbd28 RCX: 0000000000001000
>>> RDX: ffffea0003b3d218 RSI: ffff88011aac4300 RDI: ffff880118572378
>>> RBP: ffff88011a11bbe8 R08: 0000000000000000 R09: 0000000000000000
>>> R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801192fbd00
>>> R13: 0000000000000000 R14: ffff880118c3cac0 R15: 0000000000000000
>>> FS:  00007fde78bc37a0(0000) GS:ffff880028200000(0000) knlGS:0000000000000000
>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>> CR2: 00000000012706f0 CR3: 000000011a432000 CR4: 00000000000407f0
>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>> Process lvs (pid: 1679, threadinfo ffff88011a11a000, task ffff8801185a4aa0)
>>> Stack:
>>>  ffff88011a11bb48 ffff88011a11baa8 ffff88010000000c ffff88011a11bb18
>>> <d> 0000000000000000 0000000000000000 ffff88011a11bdc8 ffff88011a11beb8
>>> <d> 0000000c1a11baa8 ffff880118c3cb98 0000000000000000 0000000018c3ccb8
>>> Call Trace:
>>>  [<ffffffff811c9e90>] ? blkdev_get_block+0x0/0x20
>>>  [<ffffffff811cec97>] __blockdev_direct_IO+0x77/0xe0
>>>  [<ffffffff811c9e90>] ? blkdev_get_block+0x0/0x20
>>>  [<ffffffff811caf17>] blkdev_direct_IO+0x57/0x60
>>>  [<ffffffff811c9e90>] ? blkdev_get_block+0x0/0x20
>>>  [<ffffffff8112619b>] generic_file_aio_read+0x6bb/0x700
>>>  [<ffffffff811cba60>] ? blkdev_get+0x10/0x20
>>>  [<ffffffff811cba70>] ? blkdev_open+0x0/0xc0
>>>  [<ffffffff8118af4f>] ? __dentry_open+0x23f/0x360
>>>  [<ffffffff811ca2d1>] blkdev_aio_read+0x51/0x80
>>>  [<ffffffff8118dc6a>] do_sync_read+0xfa/0x140
>>>  [<ffffffff8109eaf0>] ? autoremove_wake_function+0x0/0x40
>>>  [<ffffffff811ca22c>] ? block_ioctl+0x3c/0x40
>>>  [<ffffffff811a34c2>] ? vfs_ioctl+0x22/0xa0
>>>  [<ffffffff811a3664>] ? do_vfs_ioctl+0x84/0x580
>>>  [<ffffffff8122cee6>] ? security_file_permission+0x16/0x20
>>>  [<ffffffff8118e625>] vfs_read+0xb5/0x1a0
>>>  [<ffffffff8118e761>] sys_read+0x51/0x90
>>>  [<ffffffff810e5aae>] ? __audit_syscall_exit+0x25e/0x290
>>>  [<ffffffff8100b072>] system_call_fastpath+0x16/0x1b
>>> Code: fe ff ff c7 85 fc fe ff ff 00 00 00 00 48 89 95 10 ff ff ff 8b 95 34 ff ff ff e8 46 ac ff ff 3b 85 34 ff ff ff 0f 84 fc 02 00 00 <0f> 0b eb fe 8b 9d 34 ff ff ff 8b 85 30 ff ff ff 01 d8 85 c0 0f
>>> RIP  [<ffffffff811ce336>] __blockdev_direct_IO_newtrunc+0x986/0x1270
>>>  RSP <ffff88011a11ba48>
>>> ---[ end trace 73be5dcaf8939399 ]---
>>> Kernel panic - not syncing: Fatal exception
>>
>> That code isn't even in mainline, as far as I can tell...
> 
> Right, it is old RHEL6 code.
> 
> But I've yet to determine what changed upstream that enables this to
> "just work" with a really large max_sectors (I haven't been looking
> either).

Kind of hard for the rest of us to say, since it's triggering a BUG in
code we don't have :-)

-- 
Jens Axboe

