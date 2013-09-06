Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750792Ab3IFElv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 00:41:51 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:50873 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab3IFEls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 00:41:48 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1309051555250.1073@cobra.newdream.net>
References: <cover.1378418255.git.milosz@adfin.com>
	<alpine.DEB.2.00.1309051555250.1073@cobra.newdream.net>
Date: Fri, 6 Sep 2013 00:41:47 -0400
Message-ID: <CANP1eJEk=eRmq1F+yYWB53spgifbU+zzKGdmKw6BGfx8SknkrA@mail.gmail.com>
Subject: Re: [PATCH 0/8] ceph: fscache support & upstream changes
From: Milosz Tanski <milosz@adfin.com>
To: Sage Weil <sage@inktank.com>
Cc: ceph-devel <ceph-devel@vger.kernel.org>,
        "Yan, Zheng" <zheng.z.yan@intel.com>,
        David Howells <dhowells@redhat.com>, Hongyi Jia <jiayisuse@gmail.com>,
        "linux-cachefs@redhat.com" <linux-cachefs@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

After running this for a day on some loaded machines I ran into what
looks like an old issue with the new code. I remember you saw an issue
that manifested it self in a similar way a while back.

[13837253.462779] FS-Cache: Assertion failed
[13837253.462782] 3 == 5 is false
[13837253.462807] ------------[ cut here ]------------
[13837253.462811] kernel BUG at fs/fscache/operation.c:414!
[13837253.462815] invalid opcode: 0000 [#1] SMP
[13837253.462820] Modules linked in: cachefiles microcode auth_rpcgss
oid_registry nfsv4 nfs lockd ceph sunrpc libceph fscache raid10
raid456 async_pq async_xor async_memcpy async_raid6_recov async_tx
raid1 raid0 multipath linear btrfs raid6_pq lzo_compress xor
zlib_deflate libcrc32c
[13837253.462851] CPU: 1 PID: 1848 Comm: kworker/1:2 Not tainted
3.11.0-rc5-virtual #55
[13837253.462870] Workqueue: ceph-revalidate ceph_revalidate_work [ceph]
[13837253.462875] task: ffff8804251f16f0 ti: ffff8804047fa000 task.ti:
ffff8804047fa000
[13837253.462879] RIP: e030:[<ffffffffa0171bad>]  [<ffffffffa0171bad>]
fscache_put_operation+0x2ad/0x330 [fscache]
[13837253.462893] RSP: e02b:ffff8804047fbd58  EFLAGS: 00010296
[13837253.462896] RAX: 000000000000000f RBX: ffff880424049d80 RCX:
0000000000000006
[13837253.462901] RDX: 0000000000000007 RSI: 0000000000000007 RDI:
ffff8804047f0218
[13837253.462906] RBP: ffff8804047fbd68 R08: 0000000000000000 R09:
0000000000000000
[13837253.462910] R10: 0000000000000108 R11: 0000000000000107 R12:
ffff8804251cf928
[13837253.462915] R13: ffff8804253c7370 R14: 0000000000000000 R15:
0000000000000000
[13837253.462923] FS:  00007f5c56e43700(0000)
GS:ffff880443500000(0000) knlGS:0000000000000000
[13837253.462928] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[13837253.462932] CR2: 00007fc08b7ee000 CR3: 00000004259a4000 CR4:
0000000000002660
[13837253.462936] Stack:
[13837253.462939]  ffff880424049d80 ffff8804251cf928 ffff8804047fbda8
ffffffffa016def1
[13837253.462946]  ffff88042b462b20 ffff88040701c750 ffff88040701c730
ffff88040701c3f0
[13837253.462953]  0000000000000003 0000000000000000 ffff8804047fbde8
ffffffffa025ba3f
[13837253.462959] Call Trace:
[13837253.462966]  [<ffffffffa016def1>]
__fscache_check_consistency+0x1a1/0x2c0 [fscache]
[13837253.462977]  [<ffffffffa025ba3f>] ceph_revalidate_work+0x8f/0x120 [ceph]
[13837253.462987]  [<ffffffff8107aa59>] process_one_work+0x179/0x490
[13837253.462992]  [<ffffffff8107bf5b>] worker_thread+0x11b/0x370
[13837253.462998]  [<ffffffff8107be40>] ? manage_workers.isra.21+0x2e0/0x2e0
[13837253.463004]  [<ffffffff81082a80>] kthread+0xc0/0xd0
[13837253.463011]  [<ffffffff81010000>] ? perf_trace_xen_mmu_pmd_clear+0x50/0xc0
[13837253.463017]  [<ffffffff810829c0>] ? flush_kthread_worker+0xb0/0xb0
[13837253.463024]  [<ffffffff8157262c>] ret_from_fork+0x7c/0xb0
[13837253.463029]  [<ffffffff810829c0>] ? flush_kthread_worker+0xb0/0xb0
[13837253.463033] Code: 31 c0 e8 5d e6 3e e1 48 c7 c7 04 8e 17 a0 31
c0 e8 4f e6 3e e1 8b 73 40 ba 05 00 00 00 48 c7 c7 62 8e 17 a0 31 c0
e8 39 e6 3e e1 <0f> 0b 65 48 8b 34 25 80 c7 00 00 48 c7 c7 4f 8e 17 a0
48 81 c6
[13837253.463071] RIP  [<ffffffffa0171bad>]
fscache_put_operation+0x2ad/0x330 [fscache]
[13837253.463079]  RSP <ffff8804047fbd58>
[13837253.463085] ---[ end trace 2972d68e8efd961e ]---
[13837253.463130] BUG: unable to handle kernel paging request at
ffffffffffffffd8
[13837253.463136] IP: [<ffffffff81082d71>] kthread_data+0x11/0x20
[13837253.463142] PGD 1a0f067 PUD 1a11067 PMD 0
[13837253.463146] Oops: 0000 [#2] SMP
[13837253.463150] Modules linked in: cachefiles microcode auth_rpcgss
oid_registry nfsv4 nfs lockd ceph sunrpc libceph fscache raid10
raid456 async_pq async_xor async_memcpy async_raid6_recov async_tx
raid1 raid0 multipath linear btrfs raid6_pq lzo_compress xor
zlib_deflate libcrc32c
[13837253.463176] CPU: 1 PID: 1848 Comm: kworker/1:2 Tainted: G      D
     3.11.0-rc5-virtual #55
[13837253.463190] task: ffff8804251f16f0 ti: ffff8804047fa000 task.ti:
ffff8804047fa000
[13837253.463194] RIP: e030:[<ffffffff81082d71>]  [<ffffffff81082d71>]
kthread_data+0x11/0x20
[13837253.463201] RSP: e02b:ffff8804047fba00  EFLAGS: 00010046
[13837253.463204] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
ffffffff81c30d00
[13837253.463209] RDX: 0000000000000001 RSI: 0000000000000001 RDI:
ffff8804251f16f0
[13837253.463213] RBP: ffff8804047fba18 R08: 0000000027bf1216 R09:
0000000000000000
[13837253.463217] R10: ffff88044360cec0 R11: 000000000000000e R12:
0000000000000001
[13837253.463222] R13: ffff8804251f1ac8 R14: ffff88042c498000 R15:
0000000000000000
[13837253.463228] FS:  00007f5c56e43700(0000)
GS:ffff880443500000(0000) knlGS:0000000000000000
[13837253.463233] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[13837253.463237] CR2: 0000000000000028 CR3: 00000004259a4000 CR4:
0000000000002660
[13837253.463241] Stack:
[13837253.463243]  ffffffff8107c3d6 ffff880443513fc0 0000000000000001
ffff8804047fba98
[13837253.463249]  ffffffff81568308 0000000000000003 ffff8804251f1ce8
ffff8804251f16f0
[13837253.463255]  ffff8804047fbfd8 ffff8804047fbfd8 ffff8804047fbfd8
ffff8804047fba78
[13837253.463261] Call Trace:
[13837253.463265]  [<ffffffff8107c3d6>] ? wq_worker_sleeping+0x16/0x90
[13837253.463272]  [<ffffffff81568308>] __schedule+0x5c8/0x820
[13837253.463276]  [<ffffffff81568619>] schedule+0x29/0x70
[13837253.662186]  [<ffffffff81062600>] do_exit+0x6e0/0xa60
[13837253.662193]  [<ffffffff81560233>] ? printk+0x4d/0x4f
[13837253.662199]  [<ffffffff8156adc0>] oops_end+0xb0/0xf0
[13837253.662206]  [<ffffffff81016b28>] die+0x58/0x90
[13837253.662211]  [<ffffffff8156a6db>] do_trap+0xcb/0x170
[13837253.662217]  [<ffffffff8100b432>] ? check_events+0x12/0x20
[13837253.662222]  [<ffffffff81013f45>] do_invalid_op+0x95/0xb0
[13837253.662231]  [<ffffffffa0171bad>] ?
fscache_put_operation+0x2ad/0x330 [fscache]
[13837253.662239]  [<ffffffff810a92b4>] ? wake_up_klogd+0x34/0x40
[13837253.662244]  [<ffffffff810a9545>] ? console_unlock+0x285/0x3c0
[13837253.662249]  [<ffffffff810a9acd>] ? vprintk_emit+0x1cd/0x490
[13837253.662255]  [<ffffffff81573d9e>] invalid_op+0x1e/0x30
[13837253.662261]  [<ffffffffa0171bad>] ?
fscache_put_operation+0x2ad/0x330 [fscache]
[13837253.662269]  [<ffffffffa0171bad>] ?
fscache_put_operation+0x2ad/0x330 [fscache]
[13837253.662276]  [<ffffffffa016def1>]
__fscache_check_consistency+0x1a1/0x2c0 [fscache]
[13837253.662288]  [<ffffffffa025ba3f>] ceph_revalidate_work+0x8f/0x120 [ceph]
[13837253.662294]  [<ffffffff8107aa59>] process_one_work+0x179/0x490
[13837253.662300]  [<ffffffff8107bf5b>] worker_thread+0x11b/0x370
[13837253.662305]  [<ffffffff8107be40>] ? manage_workers.isra.21+0x2e0/0x2e0
[13837253.662310]  [<ffffffff81082a80>] kthread+0xc0/0xd0
[13837253.662314]  [<ffffffff81010000>] ? perf_trace_xen_mmu_pmd_clear+0x50/0xc0
[13837253.662320]  [<ffffffff810829c0>] ? flush_kthread_worker+0xb0/0xb0
[13837253.662325]  [<ffffffff8157262c>] ret_from_fork+0x7c/0xb0
[13837253.662330]  [<ffffffff810829c0>] ? flush_kthread_worker+0xb0/0xb0
[13837253.662333] Code: 48 89 e5 5d 48 8b 40 c8 48 c1 e8 02 83 e0 01
c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66 66 90 48 8b 87 80 03 00 00
55 48 89 e5 5d <48> 8b 40 d8 c3 66 2e 0f 1f 84 00 00 00 00 00 66 66 66
66 90 55
[13837253.662373] RIP  [<ffffffff81082d71>] kthread_data+0x11/0x20
[13837253.662378]  RSP <ffff8804047fba00>
[13837253.662381] CR2: ffffffffffffffd8
[13837253.662385] ---[ end trace 2972d68e8efd961f ]---
[13837253.662389] Fixing recursive fault but reboot is needed!


- Milosz

On Thu, Sep 5, 2013 at 7:00 PM, Sage Weil <sage@inktank.com> wrote:
> On Thu, 5 Sep 2013, Milosz Tanski wrote:
>> Hey gang I think this should be final revision of these changes. The changes
>> are:
>>
>>  * David rewrote the cookie validity check (that originally was written by
>>    Hongyi Jia). You might have seen some emails flying about doing it the
>>    right way.
>>  * I added crash fix when for Ceph filesystems mounted with nofsc (default)
>>    when fscache is compiled into Ceph. Previously it would crash trying to
>>    enqueue invalidate checks in the work queue because we didn't initialize
>>    if the mount had fscache disabled.
>>
>> I've tested both changes on my cluster. You can get get these changes from my
>> branch in bitbucket. It contains the upstream wip-fscache branch rebased with
>> David's rewrite of Hongyi Jia's changes.
>>
>> The branch is located at.
>>
>>   https://bitbucket.org/adfin/linux-fs.git in the wip-fscahce branch
>>
>> Finally, David requested that this patchset go through the Ceph tree. The tree
>> should have all the proper sign off from David. I also CC'ed him so he can give
>> his final okay.
>>
>> Best,
>>  - Milosz
>
> I've pulled this into ceph-client.git master.  If this looks good to you,
> David, I'll send it all to Linus (along with the current set of RBD fixes,
> once they are ready).
>
> Thanks!
> sage
>
>
>>
>> David Howells (2):
>>   FS-Cache: Add interface to check consistency of a cached object
>>   CacheFiles: Implement interface to check cache consistency
>>
>> Milosz Tanski (6):
>>   fscache: Netfs function for cleanup post readpages
>>   ceph: use fscache as a local presisent cache
>>   ceph: clean PgPrivate2 on returning from readpages
>>   ceph: ceph_readpage_to_fscache didn't check if marked
>>   ceph: page still marked private_2
>>   ceph: Do not do invalidate if the filesystem is mounted nofsc
>>
>>  Documentation/filesystems/caching/backend-api.txt |    9 +
>>  Documentation/filesystems/caching/netfs-api.txt   |   35 +-
>>  fs/cachefiles/interface.c                         |   26 ++
>>  fs/cachefiles/internal.h                          |    1 +
>>  fs/cachefiles/xattr.c                             |   36 ++
>>  fs/ceph/Kconfig                                   |    9 +
>>  fs/ceph/Makefile                                  |    1 +
>>  fs/ceph/addr.c                                    |   40 ++-
>>  fs/ceph/cache.c                                   |  400 +++++++++++++++++++++
>>  fs/ceph/cache.h                                   |  157 ++++++++
>>  fs/ceph/caps.c                                    |   19 +-
>>  fs/ceph/file.c                                    |   17 +
>>  fs/ceph/inode.c                                   |   14 +-
>>  fs/ceph/super.c                                   |   35 +-
>>  fs/ceph/super.h                                   |   16 +
>>  fs/fscache/cookie.c                               |   69 ++++
>>  fs/fscache/internal.h                             |    6 +
>>  fs/fscache/page.c                                 |   71 ++--
>>  include/linux/fscache-cache.h                     |    4 +
>>  include/linux/fscache.h                           |   42 +++
>>  20 files changed, 965 insertions(+), 42 deletions(-)
>>  create mode 100644 fs/ceph/cache.c
>>  create mode 100644 fs/ceph/cache.h
>>
>> --
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
