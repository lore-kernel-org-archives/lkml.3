Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab3FFRfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 13:35:25 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:36572 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab3FFRfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 13:35:24 -0400
Message-ID: <1370540122.1724.3.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [IPC] INFO: suspicious RCU usage.
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 06 Jun 2013 10:35:22 -0700
In-Reply-To: <20130606132522.GA18959@localhost>
References: <20130606132522.GA18959@localhost>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ccing Andrew.

On Thu, 2013-06-06 at 21:25 +0800, Fengguang Wu wrote:
> Greetings,
> 
> I got the below dmesg and the first bad commit is
> 
> commit 1f6587114a689a5d7fdfb0d4abc818117e3182a5
> Author: Davidlohr Bueso <davidlohr.bueso@hp.com>
> Date:   Thu Jun 6 10:41:56 2013 +1000
> 
>     ipc: move rcu lock out of ipc_addid
>     
>     This patchset continues the work that began in the sysv ipc semaphore
>     scaling series: https://lkml.org/lkml/2013/3/20/546
>     
>     Just like semaphores used to be, sysv shared memory and msg queues also
>     abuse the ipc lock, unnecessarily holding it for operations such as
>     permission and security checks.  This patchset mostly deals with mqueues,
>     and while shared mem can be done in a very similar way, I want to get
>     these patches out in the open first.  It also does some pending cleanups,
>     mostly focused on the two level locking we have in ipc code, taking care
>     of ipc_addid() and ipcctl_pre_down_nolock() - yes there are still
>     functions that need to be updated as well.
>     
>     This patch:
>     
>     Make all callers explicitly take and release the RCU read lock.
>     
>     This addresses the two level locking seen in newary(), newseg() and
>     newqueue().  For the last two, explicitly unlock the ipc object and the
>     rcu lock, instead of calling the custom shm_unlock and msg_unlock
>     functions.  The next patch will deal with the open coded locking for
>     ->perm.lock
>     
>     Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
>     Cc: Andi Kleen <andi@firstfloor.org>
>     Cc: Rik van Riel <riel@redhat.com>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> [   51.524946] 
> [   51.525983] ===============================
> [   51.532875] [ INFO: suspicious RCU usage. ]
> [   51.535385] 3.10.0-rc4-next-20130606 #6 Not tainted
> [   51.538304] -------------------------------
> [   51.540937] /c/kernel-tests/src/stable/include/linux/rcupdate.h:471 Illegal context switch in RCU read-side critical section!
> [   51.548110] 
> [   51.548110] other info that might help us debug this:
> [   51.548110] 
> [   51.553055] 
> [   51.553055] rcu_scheduler_active = 1, debug_locks = 1
> [   51.557199] 2 locks held by trinity/1107:
> [   51.560168]  #0:  (&ids->rw_mutex){+.+.+.}, at: [<ffffffff811e15ee>] ipcget+0x38/0x2b3
> [   51.566465]  #1:  (rcu_read_lock){.+.+..}, at: [<ffffffff811e7698>] newseg+0x19d/0x3fd
> [   51.572413] 
> [   51.572413] stack backtrace:
> [   51.574761] CPU: 0 PID: 1107 Comm: trinity Not tainted 3.10.0-rc4-next-20130606 #6
> [   51.579331] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> [   51.583068]  0000000000000001 ffff880004a07d88 ffffffff817b1f5c ffff880004a07db8
> [   51.592119]  ffffffff810f2f1d ffffffff81b78569 00000000000001a8 0000000000000000
> [   51.596726]  0000000000000000 ffff880004a07de8 ffffffff810ded5e ffff880004a07fd8
> [   51.605189] Call Trace:
> [   51.606409]  [<ffffffff817b1f5c>] dump_stack+0x19/0x1b
> [   51.609632]  [<ffffffff810f2f1d>] lockdep_rcu_suspicious+0xeb/0xf4
> [   51.612905]  [<ffffffff810ded5e>] __might_sleep+0x59/0x1dc
> [   51.618614]  [<ffffffff81238623>] idr_preload+0x9b/0x142
> [   51.621939]  [<ffffffff811e0e56>] ipc_addid+0x3d/0x193
> [   51.624373]  [<ffffffff811e771c>] newseg+0x221/0x3fd
> [   51.626596]  [<ffffffff811e7698>] ? newseg+0x19d/0x3fd
> [   51.630177]  [<ffffffff811e1774>] ipcget+0x1be/0x2b3
> [   51.633174]  [<ffffffff817bc094>] ? retint_swapgs+0x13/0x1b
> [   51.636356]  [<ffffffff811e7a5a>] SyS_shmget+0x59/0x5d
> [   51.639576]  [<ffffffff811e74fb>] ? shm_try_destroy_orphaned+0xbf/0xbf
> [   51.643673]  [<ffffffff811e6ce5>] ? shm_get_unmapped_area+0x20/0x20
> [   51.647321]  [<ffffffff811e6cf0>] ? shm_security+0xb/0xb
> [   51.650831]  [<ffffffff817bcb27>] system_call_fastpath+0x16/0x1b

I suspect this is caused because now we call idr_preload() in ipc_addid
with the rcu lock held by the caller. So, we can either have a two level
rcu locking or a two level idr_preload/idr_preload_end.

Thanks,
Davidlohr

