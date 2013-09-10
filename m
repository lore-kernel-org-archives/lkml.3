Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740Ab3IJHT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 03:19:56 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:57294 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464Ab3IJHTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 03:19:54 -0400
MIME-Version: 1.0
In-Reply-To: <20130910153347.5fafb58b@notabene.brown>
References: <CAPoh-nY8wwu-2yYRbKycPX2gEUofQu6y29TOYhOm83C2au6ZQQ@mail.gmail.com>
	<20130910153347.5fafb58b@notabene.brown>
Date: Tue, 10 Sep 2013 15:19:51 +0800
Message-ID: <CAPoh-nYLbSL81V4zmLQ579+XMa2rsNFG-Drf6mVQQuCh6SYOKg@mail.gmail.com>
Subject: Re: Subject: [PATCH] md: avoid deadlock when raid5 array has unack
 badblocks during md_stop_writes.
From: y b <ycbzzjlby@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I use linux-next 2013-9-6 vesion and I can reproduce it when raid5
array rescovering, so sync_blockdev may not work.
Some disk-controller driver handle disk error in a slowerpath, may
more than 5 seconds. if shutdown or set readonly array, we can met
this situation.

the detail message when I met this situation:
[root@localhost ~]# cat /proc/version
Linux version 3.11.0-next-20130906+ (root@localhost.localdomain) (gcc
version 4.4.6 20110731 (Red Hat 4.4.6-3) (GCC) ) #4 SMP Tue Sep 10
05:41:05 CST 2013

Sep 10 15:12:53 localhost kernel: [  266.455439] sd 2:0:0:0: [sdb] CDB:
Sep 10 15:12:53 localhost kernel: [  266.455442] Read(10): 28 00 00 04
90 00 00 04 00 00
Sep 10 15:12:53 localhost kernel: [  266.455487] end_request: I/O
error, dev sdb, sector 300000
Sep 10 15:12:53 localhost kernel: [  266.455493] md/raid:md0: read
error not correctable (sector 300000 on sdb).
Sep 10 15:12:53 localhost kernel: [  266.455500] md/raid:md0: read
error not correctable (sector 300008 on sdb).
Sep 10 15:12:53 localhost kernel: [  266.455503] md/raid:md0: read
error not correctable (sector 300016 on sdb).
Sep 10 15:12:53 localhost kernel: [  266.455507] md/raid:md0: read
error not correctable (sector 300024 on sdb).
Sep 10 15:12:53 localhost kernel: [  266.455507] md/raid:md0: read
error not correctable (sector 300024 on sdb).
Sep 10 15:12:53 localhost kernel: [  266.455534] ata3: EH complete
Sep 10 15:12:54 localhost kernel: [  267.556251] ata3.00: exception
Emask 0x0 SAct 0x1 SErr 0x0 action 0x0
Sep 10 15:12:54 localhost kernel: [  267.556253] ata3.00: irq_stat 0x40000008
Sep 10 15:12:54 localhost kernel: [  267.556257] ata3.00: failed
command: READ FPDMA QUEUED
Sep 10 15:12:54 localhost kernel: [  267.556266] ata3.00: cmd
60/00:00:00:94:04/04:00:00:00:00/40 tag 0 ncq 524288 in
Sep 10 15:12:54 localhost kernel: [  267.556266]          res
41/40:00:08:94:04/00:04:00:00:00/00 Emask 0x409 (media error) <F>
Sep 10 15:12:54 localhost kernel: [  267.556280] ata3.00: status: { DRDY ERR }
Sep 10 15:12:54 localhost kernel: [  267.556292] ata3.00: error: { UNC }
Sep 10 15:13:42 localhost kernel: [  315.360006] EXT4-fs (sda3): error count: 9
Sep 10 15:13:42 localhost kernel: [  315.360021] EXT4-fs (sda3):
initial error at 1378787888: ext4_writepages:2544
Sep 10 15:13:42 localhost kernel: [  315.360035] EXT4-fs (sda3): last
error at 1378789801: ext4_journal_check_start:57
Sep 10 15:13:42 localhost kernel: [  315.360035] EXT4-fs (sda3): last
error at 1378789801: ext4_journal_check_start:57
Sep 10 15:15:46 localhost udevd[1892]: worker [3161] unexpectedly
returned with status 0x0100
Sep 10 15:15:46 localhost udevd[1892]: worker [3161] failed while
handling '/devices/virtual/block/md0'
Sep 10 15:16:28 localhost kernel: [  480.850203]       Not tainted
3.11.0-next-20130906+ #4
Sep 10 15:16:28 localhost kernel: [  480.852344] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep 10 15:16:28 localhost kernel: [  480.854380]  [<ffffffff8153b324>]
md_do_sync+0x7e4/0xe60
Sep 10 15:16:28 localhost kernel: [  480.854386]  [<ffffffff81747fcb>]
? _raw_spin_unlock_irq+0x2b/0x40
Sep 10 15:16:28 localhost kernel: [  480.854395]  [<ffffffff81536fa0>]
? md_unregister_thread+0x90/0x90
Sep 10 15:16:28 localhost kernel: [  480.854400]  [<ffffffff810a716d>]
? trace_hardirqs_on+0xd/0x10
Sep 10 15:16:28 localhost kernel: [  480.854405]  [<ffffffff815370bf>]
md_thread+0x11f/0x170
Sep 10 15:16:28 localhost kernel: [  480.854410]  [<ffffffff81536fa0>]
? md_unregister_thread+0x90/0x90
Sep 10 15:16:28 localhost kernel: [  480.854415]  [<ffffffff8106d956>]
kthread+0xd6/0xe0
Sep 10 15:16:28 localhost kernel: [  480.854423]  [<ffffffff8106d880>]
? __init_kthread_worker+0x70/0x70
Sep 10 15:16:28 localhost kernel: [  480.854428]  [<ffffffff8174ff2c>]
ret_from_fork+0x7c/0xb0
Sep 10 15:16:28 localhost kernel: [  480.854432]  [<ffffffff8106d880>]
? __init_kthread_worker+0x70/0x70
Sep 10 15:16:28 localhost kernel: [  480.854435] no locks held by
md0_resync/3246.
Sep 10 15:16:28 localhost kernel: [  480.854437] INFO: task mdadm:3257
blocked for more than 120 seconds.
Sep 10 15:16:28 localhost kernel: [  480.854438]       Not tainted
3.11.0-next-20130906+ #4
Sep 10 15:16:28 localhost kernel: [  480.854439] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep 10 15:16:28 localhost kernel: [  480.854442] mdadm           D
0000000000000000  5024  3257   3209 0x00000080
Sep 10 15:16:28 localhost kernel: [  480.854445]  ffff880138c37b18
0000000000000046 00000000ffffffff ffff880037d3b120
Sep 10 15:16:28 localhost kernel: [  480.854447]  ffff88013a038720
ffff88013a038000 0000000000013500 ffff880138c37fd8
Sep 10 15:16:28 localhost kernel: [  480.854449]  ffff880138c36010
0000000000013500 0000000000013500 ffff880138c37fd8
Sep 10 15:16:28 localhost kernel: [  480.854449] Call Trace:
Sep 10 15:16:28 localhost kernel: [  480.854452]  [<ffffffff81745fa4>]
schedule+0x24/0x70
Sep 10 15:16:28 localhost kernel: [  480.854453]  [<ffffffff81742725>]
schedule_timeout+0x175/0x200
Sep 10 15:16:28 localhost kernel: [  480.854455]  [<ffffffff810a6d30>]
? mark_held_locks+0x80/0x130
Sep 10 15:16:28 localhost kernel: [  480.854457]  [<ffffffff81747fcb>]
? _raw_spin_unlock_irq+0x2b/0x40
Sep 10 15:16:28 localhost kernel: [  480.854459]  [<ffffffff810a709d>]
? trace_hardirqs_on_caller+0xfd/0x1c0
Sep 10 15:16:28 localhost kernel: [  480.854461]  [<ffffffff810a716d>]
? trace_hardirqs_on+0xd/0x10
Sep 10 15:16:28 localhost kernel: [  480.854463]  [<ffffffff81746600>]
wait_for_completion+0xa0/0x110
Sep 10 15:16:28 localhost kernel: [  480.854465]  [<ffffffff8107d160>]
? try_to_wake_up+0x300/0x300
Sep 10 15:16:28 localhost kernel: [  480.854467]  [<ffffffff8106ddbc>]
kthread_stop+0x4c/0xe0
Sep 10 15:16:28 localhost kernel: [  480.854468]  [<ffffffff81536f5e>]
md_unregister_thread+0x4e/0x90
Sep 10 15:16:28 localhost kernel: [  480.854470]  [<ffffffff8153965d>]
md_reap_sync_thread+0x1d/0x140
Sep 10 15:16:28 localhost kernel: [  480.854472]  [<ffffffff815397ab>]
__md_stop_writes+0x2b/0x80
Sep 10 15:16:28 localhost kernel: [  480.854473]  [<ffffffff8153c911>]
do_md_stop+0x91/0x4d0
Sep 10 15:16:28 localhost kernel: [  480.854475]  [<ffffffff8153e8a7>]
? md_ioctl+0xf7/0x15c0
Sep 10 15:16:28 localhost kernel: [  480.854477]  [<ffffffff810a716d>]
? trace_hardirqs_on+0xd/0x10
Sep 10 15:16:28 localhost kernel: [  480.854479]  [<ffffffff8153f6a9>]
md_ioctl+0xef9/0x15c0
Sep 10 15:16:28 localhost kernel: [  480.854481]  [<ffffffff8113145d>]
? handle_mm_fault+0x17d/0x920

2013/9/10, NeilBrown <neilb@suse.de>:
> On Tue, 10 Sep 2013 13:00:52 +0800 y b <ycbzzjlby@gmail.com> wrote:
>
>> When raid5 hit a fresh badblock, this badblock will flagged as unack
>> badblock until md_update_sb is called.
>> But md_stop/reboot/md_set_readonly will avoid raid5d call md_update_sb
>> in md_check_recovery, the badblock will always be unack, so raid5d
>> thread enter a infinite loop and never can unregister sync_thread
>> that cause deadlock.
>>
>> To solve this, before md_stop_writes call md_unregister_thread, set
>> MD_STOPPING_WRITES on mddev->flags. In raid5.c analyse_stripe judge
>> MD_STOPPING_WRITES bit on mddev->flags, if setted don't block rdev
>> to wait md_update_sb. so raid5d thread can be finished.
>> Signed-off-by: Bian Yu <bianyu@kedacom.com>
>
> Have you actually seen this deadlock happen?  Because I don't think it can
> happen.
>
> By the time we get to md_stop or md_set_readonly all dirty buffers should
> have been flushed and there should be no pending writes so nothing to wait
> for an unacked bad block.
>
> If you have seen this happen, any details you can give about the exact
> state
> of the RAID5 when it deadlocked, the stack trace of any relevant processes
> etc would be very helpful.
>
> Thanks,
> NeilBrown
>
>
>> ---
>>  drivers/md/md.c    |    2 ++
>>  drivers/md/md.h    |    3 +++
>>  drivers/md/raid5.c |    3 ++-
>>  3 files changed, 7 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index adf4d7e..54ef71f 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -5278,6 +5278,7 @@ static void md_clean(struct mddev *mddev)
>>  static void __md_stop_writes(struct mddev *mddev)
>>  {
>>      set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
>> +    set_bit(MD_STOPPING_WRITES, &mddev->flags);
>>      if (mddev->sync_thread) {
>>          set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>>          md_reap_sync_thread(mddev);
>> @@ -5294,6 +5295,7 @@ static void __md_stop_writes(struct mddev *mddev)
>>          mddev->in_sync = 1;
>>          md_update_sb(mddev, 1);
>>      }
>> +    clear_bit(MD_STOPPING_WRITES, &mddev->flags);
>>  }
>>
>>  void md_stop_writes(struct mddev *mddev)
>> diff --git a/drivers/md/md.h b/drivers/md/md.h
>> index 608050c..c998b82 100644
>> --- a/drivers/md/md.h
>> +++ b/drivers/md/md.h
>> @@ -214,6 +214,9 @@ struct mddev {
>>  #define MD_STILL_CLOSED    4    /* If set, then array has not been opened
>> since
>>                   * md_ioctl checked on it.
>>                   */
>> +#define MD_STOPPING_WRITES 5     /* If set, raid5 shouldn't set
>> unacknowledged
>> +                  * badblock blocked in analyse_stripe to avoid infinite
>> loop
>> +                  */
>>
>>      int                suspended;
>>      atomic_t            active_io;
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index f9972e2..ff1aecf 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -3446,7 +3446,8 @@ static void analyse_stripe(struct stripe_head
>> *sh, struct stripe_head_state *s)
>>          if (rdev) {
>>              is_bad = is_badblock(rdev, sh->sector, STRIPE_SECTORS,
>>                           &first_bad, &bad_sectors);
>> -            if (s->blocked_rdev == NULL
>> +            if (!test_bit(MD_STOPPING_WRITES, &conf->mddev->flags)
>> +                && s->blocked_rdev == NULL
>>                  && (test_bit(Blocked, &rdev->flags)
>>                  || is_bad < 0)) {
>>                  if (is_bad < 0)
>
>
