Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435Ab3FQOsE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 10:48:04 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:15368 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab3FQOsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 10:48:03 -0400
Message-ID: <1371480480.2709.0.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH linux-next] ipc: Avoid sleeping inside RCU.
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 17 Jun 2013 07:48:00 -0700
In-Reply-To: <201306172055.GHD65623.LMtVQFHOOFFSOJ@I-love.SAKURA.ne.jp>
References: <201306170039.GEG18281.MQFtOOSJFOLHVF@I-love.SAKURA.ne.jp>
	 <201306172055.GHD65623.LMtVQFHOOFFSOJ@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-17 at 20:55 +0900, Tetsuo Handa wrote:
> I got this.
> 
> ===============================
> [ INFO: suspicious RCU usage. ]
> 3.10.0-rc6-next-20130617 #7 Not tainted
> -------------------------------
> include/linux/rcupdate.h:475 Illegal context switch in RCU read-side critical section!
> 
> other info that might help us debug this:
> 
> 
> rcu_scheduler_active = 1, debug_locks = 1
> 2 locks held by udevd/1909:
>  #0:  (&ids->rw_mutex){+.+.+.}, at: [<c038c4b5>] ipcget+0x45/0x70
>  #1:  (rcu_read_lock){.+.+..}, at: [<c038df60>] rcu_read_lock+0x0/0x80
> 
> stack backtrace:
> CPU: 0 PID: 1909 Comm: udevd Not tainted 3.10.0-rc6-next-20130617 #7
> Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 08/15/2008
>  00000001 da591e94 c0677931 00000001 da591ebc c0199606 c07f690d c07f83fa
>  00000001 00000001 c07e7904 00000000 000001a8 c081e5f7 da591ee4 c0176231
>  00000246 00000002 00000001 00000000 00000000 000000d0 deee0f0c ffffffe4
> Call Trace:
>  [<c0677931>] dump_stack+0x4c/0x6b
>  [<c0199606>] lockdep_rcu_suspicious+0xc6/0x100
>  [<c0176231>] __might_sleep+0xb1/0x200
>  [<c04098f1>] idr_preload+0xa1/0xd0
>  [<c038b4d2>] ipc_addid+0x52/0x190
>  [<c038dfbd>] ? rcu_read_lock+0x5d/0x80
>  [<c038e7aa>] newary+0xba/0x1a0
>  [<c038c4be>] ipcget+0x4e/0x70
>  [<c019d7a2>] ? __lock_release+0x72/0x1b0
>  [<c038e6cf>] SyS_semget+0x6f/0x80
>  [<c038e6f0>] ? sem_security+0x10/0x10
>  [<c038e6e0>] ? SyS_semget+0x80/0x80
>  [<c038dd80>] ? SyS_msgctl+0xb0/0xb0
>  [<c0392ab3>] SyS_ipc+0xa3/0x250
>  [<c0235426>] ? vm_munmap+0x46/0x60
>  [<c067c89a>] sysenter_do_call+0x12/0x32
> BUG: sleeping function called from invalid context at lib/idr.c:424
> in_atomic(): 1, irqs_disabled(): 0, pid: 1909, name: udevd
> 2 locks held by udevd/1909:
>  #0:  (&ids->rw_mutex){+.+.+.}, at: [<c038c4b5>] ipcget+0x45/0x70
>  #1:  (rcu_read_lock){.+.+..}, at: [<c038df60>] rcu_read_lock+0x0/0x80
> CPU: 0 PID: 1909 Comm: udevd Not tainted 3.10.0-rc6-next-20130617 #7
> Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 08/15/2008
>  000001a8 da591ebc c0677931 da594260 da591ee4 c01762dd c07e79fc 00000001
>  00000000 00000775 da594518 000000d0 deee0f0c ffffffe4 da591ef0 c04098f1
>  c08e2b84 da591f10 c038b4d2 da591f10 c038dfbd ffffffff 00000001 c08e2b80
> Call Trace:
>  [<c0677931>] dump_stack+0x4c/0x6b
>  [<c01762dd>] __might_sleep+0x15d/0x200
>  [<c04098f1>] idr_preload+0xa1/0xd0
>  [<c038b4d2>] ipc_addid+0x52/0x190
>  [<c038dfbd>] ? rcu_read_lock+0x5d/0x80
>  [<c038e7aa>] newary+0xba/0x1a0
>  [<c038c4be>] ipcget+0x4e/0x70
>  [<c019d7a2>] ? __lock_release+0x72/0x1b0
>  [<c038e6cf>] SyS_semget+0x6f/0x80
>  [<c038e6f0>] ? sem_security+0x10/0x10
>  [<c038e6e0>] ? SyS_semget+0x80/0x80
>  [<c038dd80>] ? SyS_msgctl+0xb0/0xb0
>  [<c0392ab3>] SyS_ipc+0xa3/0x250
>  [<c0235426>] ? vm_munmap+0x46/0x60
>  [<c067c89a>] sysenter_do_call+0x12/0x32
> 

This should already be fixed here:
https://lkml.org/lkml/2013/6/11/705

Thanks,
Davidlohr

