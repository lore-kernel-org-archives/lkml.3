Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860AbaBEGer (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 01:34:47 -0500
Received: from relay.parallels.com ([195.214.232.42]:50153 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaBEGep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 01:34:45 -0500
Message-ID: <52F1DB81.30805@parallels.com>
Date: Wed, 5 Feb 2014 10:34:41 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Christoph Lameter <cl@linux.com>, <akpm@linux-foundation.org>,
        <penberg@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] slub: fix false-positive lockdep warning in free_partial()
References: <1391517397-6142-1-git-send-email-vdavydov@parallels.com> <alpine.DEB.2.10.1402041444140.11222@nuc> <alpine.DEB.2.02.1402041657030.26056@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1402041657030.26056@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.24.25.216]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2014 04:57 AM, David Rientjes wrote:
> On Tue, 4 Feb 2014, Christoph Lameter wrote:
>
>>> Although this cannot actually result in a race, because on cache
>>> destruction there should not be any concurrent frees or allocations from
>>> the cache, let's add spin_lock/unlock to free_partial() just to keep
>>> lockdep happy.
>> Please add a comment that says this in the source so we know why this was
>> added.
>>
> Makes sense since there is a comment there already saying we don't need 
> the lock, then with this patch we end up taking it away.  The nice thing 
> is that there should be no lock contention here :)
>
> I'm not sure we need to disable irqs as in the patch, though.

I'm afraid we need:

=================================
[ INFO: inconsistent lock state ]
3.14.0-rc1-mm1+ #4 Tainted: G        W  
---------------------------------
inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
modprobe/2760 [HC0[0]:SC0[0]:HE1:SE1] takes:
 (&(&n->list_lock)->rlock){?.-...}, at: [<ffffffff811c7e98>]
__kmem_cache_shutdown+0x68/0x210
{IN-HARDIRQ-W} state was registered at:
  [<ffffffff810d2e21>] __lock_acquire+0x8f1/0x17f0
  [<ffffffff810d3db2>] lock_acquire+0x92/0x120
  [<ffffffff816decc9>] _raw_spin_lock+0x39/0x70
  [<ffffffff811c54cb>] deactivate_slab+0x26b/0x500
  [<ffffffff811c7dfc>] flush_cpu_slab+0x3c/0x70
  [<ffffffff81100232>] generic_smp_call_function_single_interrupt+0x52/0xb0
  [<ffffffff810451c2>] smp_call_function_single_interrupt+0x22/0x40
  [<ffffffff816e96f2>] call_function_single_interrupt+0x72/0x80
  [<ffffffff8101f9ef>] default_idle+0x1f/0xe0
  [<ffffffff8101f346>] arch_cpu_idle+0x26/0x30
  [<ffffffff810e4766>] cpu_startup_entry+0xa6/0x290
  [<ffffffff81046129>] start_secondary+0x1d9/0x290
irq event stamp: 3883
hardirqs last  enabled at (3883): [<ffffffff816dd23f>]
mutex_lock_nested+0x2af/0x3d0
hardirqs last disabled at (3882): [<ffffffff816dd02f>]
mutex_lock_nested+0x9f/0x3d0
softirqs last  enabled at (3866): [<ffffffff810813e2>]
__do_softirq+0x1f2/0x330
softirqs last disabled at (3851): [<ffffffff81081675>] irq_exit+0xd5/0xe0

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&(&n->list_lock)->rlock);
  <Interrupt>
    lock(&(&n->list_lock)->rlock);

 *** DEADLOCK ***

1 lock held by modprobe/2760:
 #0:  (slab_mutex){+.+.+.}, at: [<ffffffff811908b2>]
kmem_cache_destroy+0x22/0xf0

stack backtrace:
CPU: 0 PID: 2760 Comm: modprobe Tainted: G        W    3.14.0-rc1-mm1+ #4
Hardware name:
 ffffffff82295780 ffff88003af89c18 ffffffff816d9633 0000000000000002
 ffff88007b2b0000 ffff88003af89c68 ffffffff810d1001 0000000000000000
 ffffffff00000001 0000000000000001 ffffffff822957e8 ffff88007b2b0840
Call Trace:
 [<ffffffff816d9633>] dump_stack+0x51/0x6e
 [<ffffffff810d1001>] print_usage_bug+0x231/0x290
 [<ffffffff810d1c5f>] mark_lock+0x37f/0x420
 [<ffffffff810d2cb9>] __lock_acquire+0x789/0x17f0
 [<ffffffff816db71b>] ? wait_for_completion+0x5b/0x120
 [<ffffffff8134c4b3>] ? cpumask_next_and+0x23/0x40
 [<ffffffff811c7dc0>] ? slab_cpuup_callback+0x120/0x120
 [<ffffffff810ffd4c>] ? smp_call_function_many+0x5c/0x250
 [<ffffffff811c7e98>] ? __kmem_cache_shutdown+0x68/0x210
 [<ffffffff810d3db2>] lock_acquire+0x92/0x120
 [<ffffffff811c7e98>] ? __kmem_cache_shutdown+0x68/0x210
 [<ffffffff811c1160>] ? set_page_slub_counters+0x40/0x40
 [<ffffffff816decc9>] _raw_spin_lock+0x39/0x70
 [<ffffffff811c7e98>] ? __kmem_cache_shutdown+0x68/0x210
 [<ffffffff811c7e98>] __kmem_cache_shutdown+0x68/0x210
 [<ffffffff811908d3>] kmem_cache_destroy+0x43/0xf0
 [<ffffffffa0180455>] xfs_qm_exit+0x15/0x30 [xfs]
 [<ffffffffa018ab25>] exit_xfs_fs+0x9/0x4e4 [xfs]
 [<ffffffff811036fa>] SyS_delete_module+0x19a/0x1f0
 [<ffffffff816dfd98>] ? retint_swapgs+0x13/0x1b
 [<ffffffff810d2125>] ? trace_hardirqs_on_caller+0x105/0x1d0
 [<ffffffff81359fae>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff816e85f9>] system_call_fastpath+0x16/0x1b
