Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab3FJSZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 14:25:07 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:50774 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab3FJSZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 14:25:04 -0400
X-Greylist: delayed 2531 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Jun 2013 14:25:03 EDT
From: Nix <nix@esperi.org.uk>
To: linux-kernel@vger.kernel.org
Subject: NFS/lazy-umount/path-lookup-related panics at shutdown (at kill of processes on lazy-umounted filesystems) with 3.9.2 and 3.9.5
Emacs: because one operating system isn't enough.
Date: Mon, 10 Jun 2013 18:42:49 +0100
Message-ID: <871u89vp46.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-URT-Metrics: spindle 1060; Body=1 Fuz1=1 Fuz2=1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, my shutdown scripts are panicking the kernel again! They're not
causing filesystem corruption this time, but it's still fs-related.

Here's the 3.9.5 panic, seen on an x86-32 NFS client using NFSv3: NFSv4
was compiled in but not used. This happened when processes whose
current directory was on one of those NFS-mounted filesystems were being
killed, after it had been lazy-umounted (so by this point its cwd was in
a disconnected mount point).

[  251.246800] BUG: unable to handle kernel NULL pointer dereference at 00000004
[  251.256556] IP: [<c01739f6>] path_init+0xc7/0x27f
[  251.256556] *pde = 00000000
[  251.256556] Oops: 0000 [#1]
[  251.256556] Pid: 748, comm: su Not tainted 3.9.5+ #1
[  251.256556] EIP: 0060:[<c01739f6>] EFLAGS: 00010246 CPU: 0
[  251.256556] EIP is at path_init+0xc7/0x27f
[  251.256556] EAX: df63da80 EBX: dd501d64 ECX: 00000000 EDX: 00001051
[  251.256556] ESI: dd501d40 EDI: 00000040 EBP: df5f180e ESP: dd501cc8
[  251.256556]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[  251.256556] CR0: 8005003b CR2: 00000004 CR3: 1f7ee000 CR4: 00000090
[  251.256556] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[  251.256556] DR6: ffff0ff0 DR7: 00000400
[  251.256556] Process su (pid: 748, ti=dd500000 task=df63da80 task.ti=dd500000)
[  251.256556] Stack:
[  251.256556]  c03fe9ac 00000044 df1ac000 dd501d64 dd501d40 00000041 df5f180e c0174832
[  251.256556]  dd501d64 dd501cf8 000009c0 00000040 00000000 00000040 00000000 00000000
[  251.256556]  00000000 00000001 ffffff9c dd501d40 dd501d64 00000001 c0174db5 dd501d64
[  251.256556] Call Trace:
[  251.256556]  [<c0174832>] ? path_lookupat+0x2c/0x593
[  251.256556]  [<c0174db5>] ? filename_lookup.isra.33+0x1c/0x51
[  251.256556]  [<c0174e5d>] ? do_path_lookup+0x2f/0x36
[  251.256556]  [<c0174ffb>] ? kern_path+0x1b/0x31
[  251.256556]  [<c016b8d1>] ? __kmalloc_track_caller+0x9e/0xc3
[  251.256556]  [<c026d5aa>] ? __alloc_skb+0x5f/0x14c
[  251.256556]  [<c026d40d>] ? __kmalloc_reserve.isra.38+0x1a/0x52
[  251.256556]  [<c026d5b9>] ? __alloc_skb+0x6e/0x14c
[  251.256556]  [<c02ef6ea>] ? unix_find_other.isra.40+0x24/0x133
[  251.256556]  [<c02ef8da>] ? unix_stream_connect+0xe1/0x2f7
[  251.256556]  [<c026a14d>] ? kernel_connect+0x10/0x14
[  251.256556]  [<c031ecb1>] ? xs_local_connect+0x108/0x181
[  251.256556]  [<c031c83b>] ? xprt_connect+0xcd/0xd1
[  251.256556]  [<c031fd1b>] ? __rpc_execute+0x5b/0x156
[  251.256556]  [<c0128ac2>] ? wake_up_bit+0xb/0x19
[  251.256556]  [<c031b83d>] ? rpc_run_task+0x55/0x5a
[  251.256556]  [<c031b8bc>] ? rpc_call_sync+0x7a/0x8d
[  251.256556]  [<c0325127>] ? rpcb_register_call+0x11/0x20
[  251.256556]  [<c032548a>] ? rpcb_v4_register+0x87/0xf6
[  251.256556]  [<c0321187>] ? svc_unregister.isra.22+0x46/0x87
[  251.256556]  [<c03211d0>] ? svc_rpcb_cleanup+0x8/0x10
[  251.256556]  [<c03213df>] ? svc_shutdown_net+0x18/0x1b
[  251.256556]  [<c01cb1f3>] ? lockd_down+0x22/0x97
[  251.256556]  [<c01c89df>] ? nlmclnt_done+0xc/0x14
[  251.256556]  [<c01b9064>] ? nfs_free_server+0x7f/0xdb
[  251.256556]  [<c016e776>] ? deactivate_locked_super+0x16/0x3e
[  251.256556]  [<c0187e17>] ? free_fs_struct+0x13/0x20
[  251.256556]  [<c011a009>] ? do_exit+0x224/0x64f
[  251.256556]  [<c016d51f>] ? vfs_write+0x82/0x108
[  251.256556]  [<c011a492>] ? do_group_exit+0x3a/0x65
[  251.256556]  [<c011a4ce>] ? sys_exit_group+0x11/0x11
[  251.256556]  [<c0332b3d>] ? syscall_call+0x7/0xb
[  251.256556] Code: 00 80 7d 00 2f 0f 85 8b 00 00 00 83 e7 40 74 4e b8 a0 b2 3e c0 e8 c0 91 fb ff 83 7b 14 00 75 66 a1 00 1e 3e c0 8b 88 54 02 00 00 <8b> 71 04 f7 c6 01 00 00 00 74 04 f3 90 eb f1 8b 51 14 8b 41 10
[  251.256556] EIP: [<c01739f6>] path_init+0xc7/0x27f SS:ESP 0068:dd501cc8
[  251.256556] CR2: 0000000000000004

I was seeing very similar problems in 3.9.2 on a quite differently
configured x86-64 box -- but still with NFSv4 configured in but not
used, and an NFSv3 mount, and not-yet-killed processes inside a
lazy-umounted NFS filesystem. I reboot this box a lot more than the
other one, so can confirm that it happens about 80% of the time, but not
always, perhaps due to differences in the speed of lazy-umounting:

[145348.012438] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[145348.013216] IP: [<ffffffff81167856>] path_init+0x11c/0x36f
[145348.013906] PGD 0 
[145348.014571] Oops: 0000 [#1] PREEMPT SMP 
[145348.015248] Modules linked in: [last unloaded: microcode] 
[145348.015952] CPU 3 
[145348.015963] Pid: 1137, comm: ssh Not tainted 3.9.2-05286-ge8a76db-dirty #1 System manufacturer System Product Name/P8H61-MX USB3
[145348.017367] RIP: 0010:[<ffffffff81167856>] [<ffffffff81167856>] path_init+0x11c/0x36f
[145348.018121] RSP: 0018:ffff88041c179538  EFLAGS: 00010246
[145348.018879] RAX: 0000000000000000 RBX: ffff88041c179688 RCX: 00000000000000c3
[145348.019654] RDX: 000000000000c3c3 RSI: ffff88041881501a RDI: ffffffff81c34910
[145348.020454] RBP: ffff88041c179588 R08: ffff88041c1795b8 R09: ffff88041c1797f4
[145348.021245] R10: 00000000ffffff9c R11: ffff88041c179688 R12: 0000000000000041
[145348.022063] R13: 0000000000000040 R14: ffff88041881501a R15: ffff88041c1797f4
[145348.022866] FS:  00007f8a2e262700(0000) GS:ffff88042fac0000(0000) knlGS:0000000000000000
[145348.023783] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[145348.024629] CR2: 0000000000000008 CR3: 0000000001c0b000 CR4: 00000000001407e0
[145348.025502] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[145348.026369] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[145348.027239] Process ssh (pid: 1137, threadinfo ffff88041c178000, task ffff88041c838000)
[145348.028127] Stack: [145348.029055]  0000000000000000 ffffffff8152043b ffffc900080a4000 0000000000000034
[145348.029978]  ffff88041cc51098 ffff88041c179688 0000000000000041 ffff88041881501a 
[145348.030913]  ffff88041c179658 ffff88041c1797f4 ffff88041c179618 ffffffff81167adc 
[145348.031855] Call Trace:
[145348.032786]  [<ffffffff8152043b>] ? skb_checksum+0x4f/0x25b
[145348.033735]  [<ffffffff81167adc>] path_lookupat+0x33/0x69b
[145348.034688]  [<ffffffff8152e092>] ? dev_hard_start_xmit+0x2bf/0x4ee
[145348.035652]  [<ffffffff8116816a>] filename_lookup.isra.27+0x26/0x5c
[145348.036618]  [<ffffffff81168234>] do_path_lookup+0x33/0x35
[145348.037593]  [<ffffffff81168462>] kern_path+0x2a/0x4d
[145348.038573]  [<ffffffff8115697e>] ? __kmalloc_track_caller+0x4c/0x148
[145348.039563]  [<ffffffff81522cb0>] ? __alloc_skb+0x75/0x186
[145348.040555]  [<ffffffff81522444>] ? __kmalloc_reserve.isra.42+0x2d/0x6c
[145348.041559]  [<ffffffff815894eb>] unix_find_other+0x38/0x1b9
[145348.042567]  [<ffffffff8158b2e6>] unix_stream_connect+0x102/0x3ed
[145348.043586]  [<ffffffff8151a737>] ? __sock_create+0x168/0x1c0
[145348.044610]  [<ffffffff8151820b>] kernel_connect+0x10/0x12
[145348.045581]  [<ffffffff815e3dbe>] xs_local_connect+0x142/0x1ca
[145348.046571]  [<ffffffff815df3cc>] ? call_refreshresult+0x91/0x91
[145348.047553]  [<ffffffff815e11d2>] xprt_connect+0x112/0x11b
[145348.048534]  [<ffffffff815df405>] call_connect+0x39/0x3b
[145348.049523]  [<ffffffff815e6276>] __rpc_execute+0xe8/0x313
[145348.050521]  [<ffffffff815e6549>] rpc_execute+0x76/0x9d
[145348.051499]  [<ffffffff815dfbd5>] rpc_run_task+0x78/0x80
[145348.052478]  [<ffffffff815dfd13>] rpc_call_sync+0x88/0x9e
[145348.053455]  [<ffffffff815ed019>] rpcb_register_call+0x1f/0x2e
[145348.054440]  [<ffffffff815ed4e8>] rpcb_v4_register+0xb2/0x13a
[145348.055430]  [<ffffffff8108cfe2>] ? call_timer_fn+0x15d/0x15d
[145348.056450]  [<ffffffff815e8b08>] svc_unregister.isra.11+0x5a/0xcb
[145348.057457]  [<ffffffff815e8b8d>] svc_rpcb_cleanup+0x14/0x21
[145348.058464]  [<ffffffff815e83cb>] svc_shutdown_net+0x2b/0x30
[145348.059483]  [<ffffffff81251609>] lockd_down_net+0x7f/0xa3
[145348.060508]  [<ffffffff8125165e>] lockd_down+0x31/0xb4
[145348.061529]  [<ffffffff8124e7bb>] nlmclnt_done+0x1f/0x23
[145348.062552]  [<ffffffff8121a806>] ? nfs_start_lockd+0xc8/0xc8
[145348.063596]  [<ffffffff8121a81d>] nfs_destroy_server+0x17/0x19
[145348.064618]  [<ffffffff8121acda>] nfs_free_server+0xeb/0x15c
[145348.065647]  [<ffffffff81221d23>] nfs_kill_super+0x1f/0x23
[145348.066663]  [<ffffffff8115f44f>] deactivate_locked_super+0x26/0x52
[145348.067684]  [<ffffffff81160162>] deactivate_super+0x42/0x47
[145348.068703]  [<ffffffff8117633b>] mntput_no_expire+0x135/0x13d
[145348.069725]  [<ffffffff81176370>] mntput+0x2d/0x2f
[145348.070834]  [<ffffffff81165987>] path_put+0x20/0x24
[145348.071856]  [<ffffffff8118586d>] free_fs_struct+0x20/0x33
[145348.072859]  [<ffffffff811858ec>] exit_fs+0x6c/0x75
[145348.073849]  [<ffffffff81084d9c>] do_exit+0x3bf/0x8fa
[145348.074847]  [<ffffffff811659a0>] ? terminate_walk+0x15/0x3f
[145348.075828]  [<ffffffff81166d4e>] ? link_path_walk+0x32a/0x7d7
[145348.076803]  [<ffffffff8108f7a4>] ? __dequeue_signal+0x1b/0x119
[145348.077776]  [<ffffffff81085471>] do_group_exit+0x6f/0xa2
[145348.078726]  [<ffffffff81091df7>] get_signal_to_deliver+0x4ff/0x53d
[145348.079655]  [<ffffffff81168107>] ? path_lookupat+0x65e/0x69b
[145348.080574]  [<ffffffff81038d01>] do_signal+0x4d/0x4a4
[145348.081484]  [<ffffffff8116682e>] ? final_putname+0x36/0x3b
[145348.082381]  [<ffffffff811686ad>] ? do_unlinkat+0x45/0x1b8
[145348.083273]  [<ffffffff81039184>] do_notify_resume+0x2c/0x6b
[145348.084192]  [<ffffffff816126d8>] int_signal+0x12/0x17
[145348.085085] Code: c7 c7 10 49 c3 81 e8 25 bc f3 ff e8 1d 34 f3 ff 48 83 7b 20 00 0f 85 8d 00 00 00 65 48 8b 04 25 c0 b8 00 00 48 8b 80 58 05 00 00 <8b> 50 08 f6 c2 01 74 04 f3 90 eb f4 48 8b 48 18 48 89 4b 20 48 
[145348.087176] RIP [<ffffffff81167856>] path_init+0x11c/0x36f
[145348.088159]  RSP <ffff88041c179538>
[145348.089132] CR2: 0000000000000008
[145348.090136] ---[ end trace f005e3ca73eafb37 ]---
[145348.091112] Kernel panic - not syncing: Fatal exception
[145348.092115] drm_kms_helper: panic occurred, switching back to text console

The shutdown scripts are doing this horrible hack (because we want to
umount -l everything possible whether or not other mounts fail to
unmount, and last I tried it a straight umount -l of lots of filesystems
on one command line failed to do this: this may have changed with the
libmount-based umount):

umount_fsen()
{
    LAZY=${1:-}
    ONLY_TYPE=${2:-}
    # List all mounts, deepest mount point first
    LANG=C sort -r -k 2 /proc/mounts | \
    (DIRS=""
     while read DEV DIR TYPE REST; do
         case "$DIR" in
             /|/proc|/dev|/proc/*|/sys)
                 continue;; # Ignoring virtual file systems needed later
         esac

         if [[ -z $ONLY_TYPE ]]; then
             case $TYPE in
                 proc|procfs|sysfs|usbfs|usbdevfs|devpts)
                     continue;; # Ignoring non-tmpfs virtual file systems
             esac
         else
             [[ $TYPE != $ONLY_TYPE ]] && continue
         fi
         DIRS="$DIRS $DIR"
    done

    if [[ -z $LAZY ]]; then
        umount -r -v $DIRS
    else
        for name in $DIRS; do
            umount -l -v $name
        done
    fi)
}

umount_fsen -l nfs
killall5 -15
killall5 -9

So it's nothing mre than a bunch of umount -l's of NFS filesystems that
have running processes on them, followed by a kill of those processes.
