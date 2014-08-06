Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbaHFBRp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 21:17:45 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:54463 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbaHFBRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 21:17:43 -0400
MIME-Version: 1.0
In-Reply-To: <20140730140235.GA13959@localhost>
References: <20140730140235.GA13959@localhost>
Date: Tue, 5 Aug 2014 21:17:42 -0400
Message-ID: <CAPDOMVg7hNGUR7a6wiNRdSaAmdEnTT7rq7FtqtgoC8_h1oTSEA@mail.gmail.com>
Subject: Re: [cxgb4i] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:586
From: Nick Krause <xerofoify@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Anish Bhatt <anish@chelsio.com>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Lu, Aaron" <aaron.lu@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 10:02 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Hi Anish,
>
> FYI, here is another bisect result for
>
> commit 759a0cc5a3e1bc2cc48fa3c0b91bdcad8b8f87d6
> Author:     Anish Bhatt <anish@chelsio.com>
> AuthorDate: Thu Jul 17 00:18:18 2014 -0700
> Commit:     David S. Miller <davem@davemloft.net>
> CommitDate: Thu Jul 17 16:06:03 2014 -0700
>
>     cxgb4i: Add ipv6 code to driver, call into libcxgbi ipv6 api
>
>     Signed-off-by: Anish Bhatt <anish@chelsio.com>
>     Signed-off-by: Karen Xie <kxie@chelsio.com>
>     Signed-off-by: Manoj Malviya <manojmalviya@chelsio.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
>
> ===================================================
> PARENT COMMIT NOT CLEAN. LOOK OUT FOR WRONG BISECT!
> ===================================================
> Attached dmesg for the parent commit, too, to help confirm whether it is a noise error.
>
> +-----------------------------------------------------------------------------+------------+------------+------------------+
> |                                                                             | fc8d0590d9 | 759a0cc5a3 | v3.16-rc5_071821 |
> +-----------------------------------------------------------------------------+------------+------------+------------------+
> | boot_successes                                                              | 495        | 11         | 0                |
> | boot_failures                                                               | 825        | 319        | 11               |
> | BUG:kernel_boot_hang                                                        | 798        | 114        | 1                |
> | general_protection_fault                                                    | 13         | 2          |                  |
> | RIP:__lock_acquire                                                          | 13         | 2          |                  |
> | Kernel_panic-not_syncing:Attempted_to_kill_init_exitcode=                   | 13         | 2          |                  |
> | backtrace:free_reserved_area                                                | 13         | 2          |                  |
> | backtrace:free_init_pages                                                   | 13         | 2          |                  |
> | backtrace:populate_rootfs                                                   | 13         | 2          |                  |
> | backtrace:kernel_init_freeable                                              | 13         | 2          |                  |
> | BUG:kernel_boot_crashed                                                     | 14         |            |                  |
> | BUG:sleeping_function_called_from_invalid_context_at_kernel/locking/mutex.c | 0          | 203        | 10               |
> | backtrace:do_vfs_ioctl                                                      | 0          | 203        | 10               |
> | backtrace:SyS_ioctl                                                         | 0          | 203        | 10               |
> +-----------------------------------------------------------------------------+------------+------------+------------------+
>
> /etc/init.d/rc: /etc/rcS.d/S37populate-volatile.sh: line 172: can't open /proc/cmdline: no such file
> grep: /proc/filesystems: No such file or directory
> Configuring network interfaces...
> [    7.138372] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:586
> [    7.140148] in_atomic(): 0, irqs_disabled(): 0, pid: 261, name: ifconfig
> [    7.141280] 3 locks held by ifconfig/261:
> [    7.141947]  #0:  (rtnl_mutex){+.+.+.}, at: [<ffffffff87901830>] rtnl_lock+0x12/0x14
> [    7.143427]  #1:  (rcu_read_lock){......}, at: [<ffffffff8689976a>] rcu_lock_acquire+0x0/0x23
> [    7.144976]  #2:  (rcu_read_lock){......}, at: [<ffffffff870bf4a4>] rcu_read_lock+0x0/0x69
> [    7.146558] Preemption disabled at:[<ffffffff8682a7ea>] smp_apic_timer_interrupt+0x21/0x3c
> [    7.147977]
> [    7.148266] CPU: 0 PID: 261 Comm: ifconfig Not tainted 3.16.0-rc5-01126-g759a0cc #8
> [    7.149535]  0000000000000000 ffff880010927a48 ffffffff87ad0d0c ffff880010910550
> [    7.150862]  ffff880010927a78 ffffffff868a15f3 ffffffff886cd160 0000000000000000
> [    7.152216]  ffff88001375a000 ffff880010910550 ffff880010927af8 ffffffff87ae6dbb
> [    7.153533] Call Trace:
> [    7.153969]  [<ffffffff87ad0d0c>] dump_stack+0x4e/0x7a
> [    7.154841]  [<ffffffff868a15f3>] __might_sleep+0x1f2/0x1fb
> [    7.155792]  [<ffffffff87ae6dbb>] mutex_lock_nested+0x37/0x414
> [    7.156784]  [<ffffffff868ae892>] ? __lock_acquire+0x3a8/0xde4
> [    7.157764]  [<ffffffff870b8441>] cxgbi_device_find_by_netdev+0x5e/0xfd
> [    7.158866]  [<ffffffff870bf549>] cxgbi_inet6addr_handler+0x3c/0x99
> [    7.159915]  [<ffffffff86899859>] notifier_call_chain+0x94/0xc0
> [    7.160912]  [<ffffffff8689997c>] __atomic_notifier_call_chain+0x7c/0xe2
> [    7.162031]  [<ffffffff868999f1>] atomic_notifier_call_chain+0xf/0x11
> [    7.163110]  [<ffffffff879c95f6>] inet6addr_notifier_call_chain+0x16/0x18
> [    7.164241]  [<ffffffff879966e1>] ipv6_add_addr+0x105/0x404
> [    7.165174]  [<ffffffff8799aa38>] add_addr+0x2c/0x6e
> [    7.165980]  [<ffffffff8799bcd9>] addrconf_notify+0x3b0/0x6ec
> [    7.166951]  [<ffffffff868abcf8>] ? __lock_is_held+0x38/0x50
> [    7.167904]  [<ffffffff86899859>] notifier_call_chain+0x94/0xc0
> [    7.168898]  [<ffffffff86899b7b>] raw_notifier_call_chain+0xf/0x11
> [    7.169938]  [<ffffffff878f0363>] call_netdevice_notifiers_info+0x4d/0x54
> [    7.171068]  [<ffffffff878f3484>] call_netdevice_notifiers+0xe/0x10
> [    7.172114]  [<ffffffff878f647e>] __dev_notify_flags+0x4f/0x7d
> [    7.173091]  [<ffffffff878f6a28>] dev_change_flags+0x48/0x53
> [    7.174040]  [<ffffffff879661c3>] devinet_ioctl+0x289/0x5b9
> [    7.174950]  [<ffffffff87966a92>] inet_ioctl+0x8c/0xa6
> [    7.175822]  [<ffffffff878e10be>] sock_ioctl+0x1a7/0x1c9
> [    7.176731]  [<ffffffff86929882>] do_vfs_ioctl+0x3a7/0x470
> [    7.177652]  [<ffffffff869317f4>] ? rcu_read_lock_held+0x36/0x38
> [    7.178658]  [<ffffffff869319d4>] ? __fcheck_files.isra.8+0x4b/0x57
> [    7.179712]  [<ffffffff86929996>] SyS_ioctl+0x4b/0x76
> [    7.180561]  [<ffffffff87aea869>] system_call_fastpath+0x16/0x1b
> ifup: can't open '/var/run/ifstate': No such file or directory
> done.
> hwclock: can't open '/dev/misc/rtc': No such file or directory
>
> git bisect start 9931f57b978a5b5ff5934ece85cf8bf7db5d2f67 1795cd9b3a91d4b5473c97f491d63892442212ab --
> git bisect  bad 64f2bc8ec801297316bf7189c640e5da60c5b77b  # 01:06      0-    341  Merge 'renesas/devel' into devel-hourly-2014071821
> git bisect  bad 3f322c0abf13c5644ff308cd5f72c08e398878e6  # 01:09     31-    263  Merge 'pm/pm-sleep' into devel-hourly-2014071821
> git bisect  bad 9326a554df9c49570ff4c69ed8b28f9bff72b9ad  # 01:13     11-     26  Merge 'usb/usb-linus' into devel-hourly-2014071821
> git bisect good 5bc464435ec4aca3288a75c503280cedc875f72d  # 01:54    330+    192  Merge 'microblaze/next' into devel-hourly-2014071821
> git bisect good 366124999766417afff537a44e74c695aede3f04  # 02:10    330+    110  Merge 'pm/acpi-video' into devel-hourly-2014071821
> git bisect  bad 67ba0ca140433b242d9cb0920cf0572856b3dd38  # 02:18      1-    105  Merge 'can/master' into devel-hourly-2014071821
> git bisect good 90fb5679e568b11b89e02b87f7f4fe00c7589ce0  # 02:38    330+     85  Merge branch 'sctp_command_queue'
> git bisect good 95d01a669bd35d0e8eb28dd8a946876c00a9a61a  # 02:54    330+    115  Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next into for-davem
> git bisect good b6603fe574af289dbe9eb9fb4c540bca04f5a053  # 03:07    330+    194  Merge tag 'for-linus-20140716' of git://git.infradead.org/linux-mtd
> git bisect good f54424412b6b2f64cae4d7c39d981ca14ce0052c  # 03:27    330+    173  bonding: permit enslaving interfaces without set_mac support
> git bisect good 2dc41cff7545d55c6294525c811594576f8e119c  # 03:40    330+    185  udp: Use hash2 for long hash1 chains in __udp*_lib_mcast_deliver.
> git bisect  bad 759a0cc5a3e1bc2cc48fa3c0b91bdcad8b8f87d6  # 03:53      0-      4  cxgb4i: Add ipv6 code to driver, call into libcxgbi ipv6 api
> git bisect good 4bbe3f5c7174e989989c04d41e6640ac0b944dac  # 04:08    330+    154  Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/net-next
> git bisect good 92abf75033d2677a684c623d60f093b130c4b38f  # 04:30    330+    147  bonding: update bonding.txt for Layer2 hash factors
> git bisect good a3e3b2857d35988819bc396c012c53898b8223e6  # 04:46    330+    222  cxgb4: Export symbols required by cxgb4i for ipv6 support and required defines
> git bisect good fc8d0590d9142d01e4ccea3aa57c894bd6e53662  # 04:59    330+    173  libcxgbi: Add ipv6 api to driver
> # first bad commit: [759a0cc5a3e1bc2cc48fa3c0b91bdcad8b8f87d6] cxgb4i: Add ipv6 code to driver, call into libcxgbi ipv6 api
> git bisect good fc8d0590d9142d01e4ccea3aa57c894bd6e53662  # 05:14    990+    825  libcxgbi: Add ipv6 api to driver
> git bisect  bad 9931f57b978a5b5ff5934ece85cf8bf7db5d2f67  # 05:14      0-     11  0day head guard for 'devel-hourly-2014071821'
> git bisect good f83971912231fe5390d2357442b6c25bb8076d9b  # 05:56    990+    300  Merge tag 'gfs2-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-3.0-fixes
>
>
> This script may reproduce the error.
>
> ----------------------------------------------------------------------------
> #!/bin/bash
>
> kernel=$1
> initrd=yocto-minimal-x86_64.cgz
>
> wget --no-clobber https://github.com/fengguang/reproduce-kernel-bug/blob/master/initrd/$initrd
>
> kvm=(
>         qemu-system-x86_64
>         -enable-kvm
>         -cpu Haswell,+smep,+smap
>         -kernel $kernel
>         -initrd $initrd
>         -m 320
>         -smp 1
>         -net nic,vlan=1,model=e1000
>         -net user,vlan=1
>         -boot order=nc
>         -no-reboot
>         -watchdog i6300esb
>         -rtc base=localtime
>         -serial stdio
>         -display none
>         -monitor null
> )
>
> append=(
>         hung_task_panic=1
>         earlyprintk=ttyS0,115200
>         debug
>         apic=debug
>         sysrq_always_enabled
>         rcupdate.rcu_cpu_stall_timeout=100
>         panic=10
>         softlockup_panic=1
>         nmi_watchdog=panic
>         prompt_ramdisk=0
>         console=ttyS0,115200
>         console=tty0
>         vga=normal
>         root=/dev/ram0
>         rw
>         drbd.minor_count=8
> )
>
> "${kvm[@]}" --append "${append[*]}"
> ----------------------------------------------------------------------------
>
> Thanks,
> Fengguang
>
> _______________________________________________
> LKP mailing list
> LKP@linux.intel.com
>

Hey Fenngguang,

196 static struct cxgbi_device *cxgbi_device_find_by_netdev(struct
net_device *ndev,
197 int *port)
198 {
199 struct net_device *vdev = NULL;
200 struct cxgbi_device *cdev, *tmp;
201 int i;
202
203 if (ndev->priv_flags & IFF_802_1Q_VLAN) {
204 vdev = ndev;
205 ndev = vlan_dev_real_dev(ndev);
206 log_debug(1 << CXGBI_DBG_DEV,
207 "vlan dev %s -> %s.\n", vdev->name, ndev->name);
208 }
209
210 mutex_lock(&cdev_mutex);
211 list_for_each_entry_safe(cdev, tmp, &cdev_list, list_head) {
212 for (i = 0; i < cdev->nports; i++) {
213 if (ndev == cdev->ports[i]) {
214 cdev->hbas[i]->vdev = vdev;
215 mutex_unlock(&cdev_mutex);
216 if (port)
217 *port = i;
218 return cdev;
219 }
220 }
221 }
222 mutex_unlock(&cdev_mutex);
223 log_debug(1 << CXGBI_DBG_DEV,
224 "ndev 0x%p, %s, NO match found.\n", ndev, ndev->name);
225 return NULL;
226 }

This is the function where we are sleeping based on your kernel oops output.
If we are sleeping or can in this list we should change this to a spinlock as
that would stop sleeping issues here, unless  this function itself never sleeps
and we have an issue in another part of your trace that I am missing.
Regards Nick
