Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbaDGNiS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 09:38:18 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39620 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760AbaDGNiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 09:38:16 -0400
Message-ID: <5342AA3E.50100@oracle.com>
Date: Mon, 07 Apr 2014 09:38:06 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: bdi: lockdep warning in bdi_queue_work
References: <533F2CED.3070006@oracle.com> <20140407102107.GD14927@quack.suse.cz>
In-Reply-To: <20140407102107.GD14927@quack.suse.cz>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2014 06:21 AM, Jan Kara wrote:
>   Hello,
> 
> On Fri 04-04-14 18:06:37, Sasha Levin wrote:
>> While fuzzing with trinity inside a KVM tools guest running the latest -next
>> kernel I've stumbled on the following:
>>
>> [  323.192041] INFO: trying to register non-static key.
>> [  323.193083] the code is fine but needs lockdep annotation.
>> [  323.193949] turning off the locking correctness validator.
>> [  323.194687] CPU: 15 PID: 21793 Comm: trinity-c94 Not tainted 3.14.0-next-20140403-sasha-00019-g7474aa9-dirty #376
>> [  323.196300]  0000000000000000 ffff8804d9067cf8 ffffffff954bfb2f 0000000000000000
>> [  323.197522]  ffffffff99378b10 ffff8804d9067df8 ffffffff921c3912 ffff88082bddaeb0
>> [  323.198879]  ffff880800000000 ffff880400000001 ffffffff00000000 ffff8804d9067d48
>> [  323.200063] Call Trace:
>> [  323.200487] dump_stack (lib/dump_stack.c:52)
>> [  323.200581] __lock_acquire (kernel/locking/lockdep.c:743 kernel/locking/lockdep.c:3078)
>> [  323.200581] ? __slab_alloc (mm/slub.c:2385 (discriminator 2))
>> [  323.200581] ? __lock_acquire (kernel/locking/lockdep.c:3189)
>> [  323.200581] ? kvm_clock_read (arch/x86/include/asm/preempt.h:90 arch/x86/kernel/kvmclock.c:86)
>> [  323.200581] lock_acquire (arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3602)
>> [  323.200581] ? bdi_queue_work (arch/x86/include/asm/bitops.h:313 fs/fs-writeback.c:108)
>> [  323.200581] _raw_spin_lock_bh (include/linux/spinlock_api_smp.h:136 kernel/locking/spinlock.c:175)
>> [  323.200581] ? bdi_queue_work (arch/x86/include/asm/bitops.h:313 fs/fs-writeback.c:108)
>> [  323.200581] bdi_queue_work (arch/x86/include/asm/bitops.h:313 fs/fs-writeback.c:108)
>> [  323.200581] __bdi_start_writeback (fs/fs-writeback.c:141)
>> [  323.200581] wakeup_flusher_threads (fs/fs-writeback.c:1077)
>> [  323.200581] ? wakeup_flusher_threads (include/linux/rcupdate.h:800 fs/fs-writeback.c:1076)
>> [  323.200581] ? syscall_trace_enter (include/linux/context_tracking.h:27 arch/x86/kernel/ptrace.c:1461)
>> [  323.200581] sys_sync (fs/sync.c:107)
>> [  323.200581] tracesys (arch/x86/kernel/entry_64.S:749)
>   Thanks for report. This is really strange. The complaint is apparently
> about bdi->wb_lock. But that is properly initialized with spin_lock_init()
> when bdi is created so I don't see how we could see a non-static key there.
> Can you reproduce this? Can you tell what the non-static key was?
> 
> I presume something bad could happen if someone was freeing the bdi while
> we are looking at it. And given bdi should be RCU freed, that could happen
> if someone forgot to free the bdi structure using RCU. So to identify that
> better, can you dump 'bdi->name' for the bdi which triggers this?

I've added some code to do that, but since I only saw that error once so far
I suspect it'll be a while before I could come back with a result.


Thanks,
Sasha

