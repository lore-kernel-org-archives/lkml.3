Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759812Ab3CGUzg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 15:55:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758504Ab3CGUze (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 15:55:34 -0500
Message-ID: <5138FEAC.7050102@redhat.com>
Date: Thu, 07 Mar 2013 15:55:08 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Emmanuel Benisty <benisty.e@gmail.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, hhuang@redhat.com
Subject: Re: [PATCH v2 7/4] ipc: fine grained locking for semtimedop
References: <1362476149.2225.50.camel@buesod1.americas.hpqcorp.net>  <20130306171546.63471bc0@cuia.bos.redhat.com> <1362620201.2360.7.camel@buesod1.americas.hpqcorp.net>
In-Reply-To: <1362620201.2360.7.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 08:36 PM, Davidlohr Bueso wrote:

> But my 8 socket 160 CPU box sure isn't happy. I'm getting all sorts of
> issues (sometimes it will boot, sometimes it wont). When it does, linux
> will hang as soon as I start my benchmarking:

I think I may have found the cause of this bug.

It looks like it would be possible for a caller with a single
semop to come into semtimedop, see that sma->complex_count is
elevated, and take the write lock.

Further down in semtimedop, that caller can call do_smart_update,
which calls update_queue, which in turn calls unlink_queue.

The function unlink_queue can then decrement sma->complex_count.

In other words, we correctly grab the write lock when changing
sma->complex_count. However, we do not remember that we took
the write lock, and call read_unlock when we leave semtimedop.

The next caller will get stuck.

To fix this bug, we need to remember whether or not we took
the lock in exclusive mode, and unlock it the right way.

Now that I have figured this bug out, it should be easy to
re-implement things the way Linus suggested, subject to the
same bug fixes :)

> BUG: soft lockup - CPU#77 stuck for 23s! [oracle:129877]
> Modules linked in: fuse autofs4 sunrpc pcc_cpufreq ipv6 dm_mirror dm_region_hash dm_log dm_mod uinput iTCO_wdt iTCO_vendor_support sg freq_table mperf coretemp kvm_intel kvm crc32c_intel ghash_clmulni_intel microcode pcspkr lpc_ich mfd_core hpilo hpwdt i7core_edac edac_core netxen_nic ext4 mbcache jbd2 sd_mod crc_t10dif aesni_intel ablk_helper cryptd lrw aes_x86_64 xts gf128mul hpsa radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core
> CPU 77
> Pid: 129877, comm: oracle Tainted: G      D W    3.9.0-rc1+ #20 HP ProLiant DL980 G7
> RIP: 0010:[<ffffffff812777fa>]  [<ffffffff812777fa>] __read_lock_failed+0xa/0x20
> RSP: 0018:ffff8b87b8cf9ca8  EFLAGS: 00000297
> RAX: ffffc900293c1020 RBX: 000000010007a021 RCX: 000000000000d3a5
> RDX: 0000000000000001 RSI: ffff8b87b8cf9d58 RDI: ffffc900293c1020
> RBP: ffff8b87b8cf9ca8 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff8b87b8cf9c68
> R13: ffff8b87b8cf9c68 R14: 0000000000000286 R15: ffff8b87caf10100
> FS:  00007f7a689b2700(0000) GS:ffff8987ff9c0000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fc49426d000 CR3: 00000187cf08f000 CR4: 00000000000007e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process oracle (pid: 129877, threadinfo ffff8b87b8cf8000, task ffff8b87caf10100)
> Stack:
>   ffff8b87b8cf9cb8 ffffffff8155f374 ffff8b87b8cf9ce8 ffffffff81205245
>   0000000000000001 0000000000090002 00007fff82d3aa08 0000000000000000
>   ffff8b87b8cf9f78 ffffffff812069e1 0000000000cbc000 ffff8b87b8cf9f38
> Call Trace:
>   [<ffffffff8155f374>] _raw_read_lock+0x14/0x20
>   [<ffffffff81205245>] sem_lock+0x85/0xa0
>   [<ffffffff812069e1>] sys_semtimedop+0x521/0x7c0
>   [<ffffffff81089e2c>] ? task_sched_runtime+0x4c/0x90
>   [<ffffffff8101c1b3>] ? native_sched_clock+0x13/0x80
>   [<ffffffff8101b7b9>] ? sched_clock+0x9/0x10
>   [<ffffffff8108f9ed>] ? sched_clock_cpu+0xcd/0x110
>   [<ffffffff8108914b>] ? update_rq_clock+0x2b/0x50
>   [<ffffffff81089e2c>] ? task_sched_runtime+0x4c/0x90
>   [<ffffffff8108fe48>] ? thread_group_cputime+0x88/0xc0
>   [<ffffffff8108fd1d>] ? cputime_adjust+0x3d/0x90
>   [<ffffffff8108fece>] ? thread_group_cputime_adjusted+0x4e/0x60
>   [<ffffffff81568119>] system_call_fastpath+0x16/0x1b
> Code: 90 55 48 89 e5 f0 ff 07 f3 90 83 3f 01 75 f9 f0 ff 0f 75 f1 5d c3 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 f0 48 ff 07 f3 90 <48> 83 3f 01 78 f8 f0 48 ff 0f 78 ee 5d c3 90 90 90 90 90 90 90
>
>
>> +static inline void sem_unlock(struct sem_array *sma, struct sembuf *sops,
>> +			      int nsops)
>> +{
>> +	if (nsops == 1 && sma->sem_nsems > 1 && !sma->complex_count) {
>> +		struct sem *sem = sma->sem_base + sops->sem_num;
>> +		spin_unlock(&sem->lock);
>> +		read_unlock(&sma->sem_perm.lock);
>> +	} else
>> +		write_unlock(&sma->sem_perm.lock);
>> +}
>
> I believe (haven't tested it yet) the issue could be in sem_unlock() as
> we aren't unlocking the RCU read section - before it was just a trivial
> ipc_unlock call.

That is an additional bug.  You are right that sem_unlock does need
to call rcu_read_unlock() and that my patches fail to do so.

Good spotting.

-- 
All rights reversed
