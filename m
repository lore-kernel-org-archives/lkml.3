Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab3FCGVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 02:21:49 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53195 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab3FCGVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 02:21:44 -0400
Message-ID: <51AC35F1.2090108@windriver.com>
Date: Mon, 3 Jun 2013 14:21:37 +0800
From: Ying Xue <ying.xue@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [TIPC] BUG: unable to handle kernel NULL pointer dereference
 at 00000014
References: <20130601102645.GA6556@localhost>
In-Reply-To: <20130601102645.GA6556@localhost>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.162.175]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fengguang,

Thanks for your report.

I have found its root cause. Please see below call paths:

tipc_init()->tipc_cfg_init()->tipc_server_start()->kmem_cache_create()

When kmem_cache_create() return -ENOMEM due to lack of memory,
tipc_cfg_init() will call tipc_core_stop() immediately. Subsequently
below call list will be fellow:

tipc_core_stop()->tipc_cfg_stop()->tipc_server_stop()->destroy_workqueue()

In fact Work queues are not allocated in tipc_server_start() due to the
failure of kmem_cache_create(), however, we will release them in
tipc_server_stop(), which means we will free one unallocated memory
area. Thus, oops occurs.

I will fix it in next review version.

Regards,
Ying

On 06/01/2013 06:26 PM, Fengguang Wu wrote:
> Greetings,
> 
> I got the below dmesg and the first bad commit is
> 
> commit 0fb0040ed697d2b0fbd484042cdebbe76d29a840
> Author: Ying Xue <ying.xue@windriver.com>
> Date:   Mon May 6 23:57:18 2013 -0400
> 
>     tipc: convert configuration server to use new server facility
>     
>     As the new socket-based TIPC server infrastructure has been
>     introduced, we can now convert the configuration server to use
>     it.  Then we can take future steps to simplify the configuration
>     server locking policy.
>     
>     Some minor reordering of initialization is done, due to the
>     dependency on having tipc_socket_init completed.
>     
>     Signed-off-by: Ying Xue <ying.xue@windriver.com>
>     Signed-off-by: Jon Maloy <jon.maloy@ericsson.com>
>     Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> 
> [    7.054175]  c1589e09 00000000 ffffffff 00010000 742efec0 c160b2e4 000000f5 00000000
> [    7.054179]  c003ff3c c10851e1 00000000 00002000 00000000 00000000 c003ff60 c13e52f0
> [    7.054187] Call Trace:
> [    7.054232]  [<c1416d45>] dump_stack+0x16/0x18
> [    7.054257]  [<c1085063>] kmem_cache_create_memcg+0xf0/0x257
> [    7.054261]  [<c10851e1>] kmem_cache_create+0x17/0x19
> [    7.054272]  [<c13e52f0>] tipc_server_start+0x41/0x1e1
> [    7.054280]  [<c13da859>] tipc_cfg_init+0xd/0xf
> [    7.054288]  [<c1637f6a>] tipc_init+0xb2/0xd6
> [    7.054292]  [<c1637eb8>] ? rc80211_pid_init+0xf/0xf
> [    7.054317]  [<c1000192>] do_one_initcall+0x6b/0xf1
> [    7.054322]  [<c160ca39>] kernel_init_freeable+0xec/0x171
> [    7.054329]  [<c1407fdc>] kernel_init+0x8/0xaf
> [    7.054333]  [<c141baf7>] ret_from_kernel_thread+0x1b/0x28
> [    7.054336]  [<c1407fd4>] ? rest_init+0x70/0x70
> [    7.054443] BUG: unable to handle kernel NULL pointer dereference at 00000014
> [    7.054447] IP: [<c1419748>] __mutex_lock_common.isra.3+0x7d/0x32e
> [    7.054449] *pde = 00000000 
> [    7.054452] Oops: 0002 [#1] PREEMPT SMP 
> [    7.054464] Modules linked in:
> [    7.054467] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc3-00247-ged75b21 #32
> [    7.054468] task: c0040000 ti: c003e000 task.ti: c003e000
> [    7.054475] EIP: 0060:[<c1419748>] EFLAGS: 00010046 CPU: 0
> [    7.054478] EIP is at __mutex_lock_common.isra.3+0x7d/0x32e
> [    7.054480] EAX: 00000100 EBX: 00000010 ECX: c003e000 EDX: 00000000
> [    7.054482] ESI: 00000246 EDI: c0040000 EBP: c003feec ESP: c003feac
> [    7.054483]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [    7.054485] CR0: 8005003b CR2: 00000014 CR3: 01660000 CR4: 000006d0
> [    7.054494] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
> [    7.054498] DR6: ffff0ff0 DR7: 00000400
> [    7.054499] Stack:
> [    7.054505]  c003feb8 c141af97 c003fec0 00000002 00000014 c003ff18 c141619c 0010000d
> [    7.054510]  00000000 000da5a0 0010000e 00000246 00000246 00000010 c160b30c 00000000
> [    7.054515]  c003fef4 c1419b8c c003ff00 c1419bac 00000000 c003ff24 c103f010 c003ff18
> [    7.054516] Call Trace:
> [    7.054520]  [<c141af97>] ? _raw_spin_unlock_irqrestore+0x28/0x34
> [    7.054523]  [<c141619c>] ? __slab_free+0x126/0x2b6
> [    7.054526]  [<c1419b8c>] __mutex_lock_slowpath+0xd/0xf
> [    7.054529]  [<c1419bac>] mutex_lock+0x1e/0x2a
> [    7.054540]  [<c103f010>] drain_workqueue+0x16/0xea
> [    7.054543]  [<c103f119>] destroy_workqueue+0xe/0x155
> [    7.054546]  [<c13e54f3>] tipc_server_stop+0x63/0x84
> [    7.054553]  [<c1031202>] ? put_online_cpus+0x59/0x5b
> [    7.054556]  [<c13da890>] tipc_cfg_stop+0xd/0x11
> [    7.054559]  [<c1418843>] tipc_core_stop+0x12/0x28
> [    7.054562]  [<c1637f75>] tipc_init+0xbd/0xd6
> [    7.054564]  [<c1637eb8>] ? rc80211_pid_init+0xf/0xf
> [    7.054566]  [<c1000192>] do_one_initcall+0x6b/0xf1
> [    7.054569]  [<c160ca39>] kernel_init_freeable+0xec/0x171
> [    7.054572]  [<c1407fdc>] kernel_init+0x8/0xaf
> [    7.054575]  [<c141baf7>] ret_from_kernel_thread+0x1b/0x28
> [    7.054578]  [<c1407fd4>] ? rest_init+0x70/0x70
> [    7.054601] Code: 51 c1 68 55 01 00 00 68 74 be 51 c1 e8 8c 53 c1 ff 83 c4 10 e8 fe bb c2 ff 89 c6 e8 0d bc c2 ff 8d 43 04 89 45 d0 b8 00 01 00 00 <f0> 66 0f c1 43 04 88 c2 0f b6 c4 38 c2 74 07 f3 90 8a 53 04 eb
> [    7.054605] EIP: [<c1419748>] __mutex_lock_common.isra.3+0x7d/0x32e SS:ESP 0068:c003feac
> [    7.054606] CR2: 0000000000000014
> [    7.054611] ---[ end trace 730db1884308edf4 ]---
> 
> git bisect start ed75b2108d86fdd218fd0a89b0cc46a39ed6d724 v3.9 --
> git bisect good 73287a43cc79ca06629a88d1a199cd283f42456a  #    11  2013-05-31 10:52:17  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next
> git bisect good d7ab7302f970a254997687a1cdede421a5635c68  #    13  2013-05-31 14:30:29  Merge tag 'mfd-3.10-1' of git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-next
> git bisect good 07e074503eba3ee657ab50a8c9497ddf90039e7e  #    10  2013-05-31 14:58:02  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
> git bisect good 3c6a279ffccd0c414ecd1d5eb4670ed70072c526  #    10  2013-05-31 19:53:12  Merge branch 'upstream' of git://git.linux-mips.org/pub/scm/ralf/upstream-linus
> git bisect good eb3d33900aa953bcdfe132a71bb03ee592ebbb47  #    11  2013-05-31 20:10:55  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
> git bisect  bad 1fa65447bc7b3bf4fa6d1cfe9a88dcbfe804df28  #     0  2013-05-31 20:30:31  tipc: rename tipc_createport_raw to tipc_createport
> git bisect good 84b6f7456e8b88507dd85f988a9d350eb5af0e46  #    10  2013-05-31 21:23:34  bnx2x: Enable `set_phys_id' for all functions
> git bisect good eeb65cedd78ebd375608d71d703e6b0b9296efbd  #    10  2013-06-01 02:19:33  be2net: cleanup be_get_drvinfo()
> git bisect good 351638e7deeed2ec8ce451b53d33921b3da68f83  #    10  2013-06-01 06:22:06  net: pass info struct via netdevice notifier
> git bisect good 31fec5aa21d166cf81702a669c1398784b513b8a  #    10  2013-06-01 07:25:07  vxlan: use unsigned int instead of unsigned
> git bisect good 978e1115feb12672cf014697dfeffff2c4d5a2da  #    19  2013-06-01 10:56:29  tipc: Add "max_ports" configuration parameter
> git bisect good 37f8edf101359fc267ce8d28b2bcc65376ccf14d  #    13  2013-06-01 11:04:26  tipc: convert topology server to use new server facility
> git bisect  bad 62f71bc6f702fbd5e6f0f260b982580ea2111862  #     0  2013-06-01 11:42:24  tipc: delete code orphaned by new server infrastructure
> git bisect  bad 0fb0040ed697d2b0fbd484042cdebbe76d29a840  #     0  2013-06-01 12:08:04  tipc: convert configuration server to use new server facility
> git bisect good 37f8edf101359fc267ce8d28b2bcc65376ccf14d  #    30  2013-06-01 12:21:46  tipc: convert topology server to use new server facility
> git bisect  bad ed75b2108d86fdd218fd0a89b0cc46a39ed6d724  #     0  2013-06-01 17:18:01  Merge remote-tracking branch 'paulg/tipc_net-next' into devel-xian-i386-2013-05-31-04-08
> git bisect good 14d35d014bd806884801d32259ecdaf857ef276b  #    30  2013-06-01 17:53:32  Add linux-next specific files for 20130531
> 
> Thanks,
> Fengguang
> 

