Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123AbaG3HXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 03:23:47 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:42044 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754904AbaG3HXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 03:23:44 -0400
Date: Wed, 30 Jul 2014 00:22:43 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: peterz@infrdead.org, bruno@wolff.to, jwboyer@redhat.com
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: scheduler crash on Power
Message-ID: <20140730072242.GA21516@us.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="M9NhX3UHpAaciwkO"
Content-Disposition: inline
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14073007-5806-0000-0000-0000001AFFFE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


I am getting this crash on a Powerpc system using 3.16.0-rc7 kernel plus
some patches related to perf (24x7 counters) that Cody Schafer posted here:

	https://lkml.org/lkml/2014/5/27/768

I don't get the crash on an unpatched kernel though.

I have been staring at the perf event patches, but can't find anything
impacting the scheduler. Besides the patches had worked on 3.16.0-rc2
kernel on a different Power system.

The crash occurs on an idle system, a minute or two after booting to
runlevel 3.

kernel/sched/core.c:

---
5877 static void init_sched_groups_capacity(int cpu, struct sched_domain *sd)
5878 {
5879         struct sched_group *sg = sd->groups;
5880 
5881         WARN_ON(!sg);
5882 
5883         do {
5884                 sg->group_weight = cpumask_weight(sched_group_cpus(sg));

---


I tried applying the patch discussed in https://lkml.org/lkml/2014/7/16/386
but doesn't seem to help.

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index bc1638b..50702a8 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5842,6 +5842,8 @@ build_sched_groups(struct sched_domain *sd, int cpu)
                        continue;
 
                group = get_group(i, sdd, &sg);
+               cpumask_clear(sched_group_cpus(sg));
+               sg->sgc->capacity = 0;
                cpumask_setall(sched_group_mask(sg));
 
                for_each_cpu(j, span) {


I am also attaching the debug messages that Peterz added
here: https://lkml.org/lkml/2014/7/17/288

Appreciate any debug suggestions.

Sukadev


----
Red Hat Enterprise Linux Server 7.0 (Maipo)
Kernel 3.16.0-rc7-24x7+ on an ppc64

ltcbrazos2-lp07 login: 

Red Hat Enterprise Linux Server 7.0 (Maipo)
Kernel 3.16.0-rc7-24x7+ on an ppc64

ltcbrazos2-lp07 login: [  181.915974] ------------[ cut here ]------------
[  181.915991] WARNING: at ../kernel/sched/core.c:5881
[  181.915994] Modules linked in: sg cfg80211 rfkill nx_crypto ibmveth pseries_rng xfs libcrc32c sd_mod crc_t10dif crct10dif_common ibmvscsi scsi_transport_srp scsi_tgt dm_mirror dm_region_hash dm_log dm_mod
[  181.916024] CPU: 4 PID: 1087 Comm: kworker/4:2 Not tainted 3.16.0-rc7-24x7+ #15
[  181.916034] Workqueue: events .topology_work_fn
[  181.916038] task: c0000000dbd40000 ti: c0000000da400000 task.ti: c0000000da400000
[  181.916043] NIP: c0000000000d7528 LR: c0000000000d7578 CTR: 0000000000000000
[  181.916047] REGS: c0000000da403580 TRAP: 0700   Not tainted  (3.16.0-rc7-24x7+)
[  181.916051] MSR: 8000000100029032 <SF,EE,ME,IR,DR,RI>  CR: 28484c24  XER: 00000000
[  181.916063] CFAR: c0000000000d74f4 SOFTE: 1 
GPR00: c0000000000d7578 c0000000da403800 c000000000eaa7f0 0000000000000800 
GPR04: 0000000000000800 0000000000000800 0000000000000000 c0000000009cf878 
GPR08: c0000000009cf880 0000000000000001 0000000000000010 0000000000000000 
GPR12: 0000000000000000 c00000000ebe1200 0000000000000800 c0000000cc2f0000 
GPR16: c000000000ef0a68 0000000000000078 c0000000e5000000 0000000000000078 
GPR20: 0000000000000000 0000000000000001 c0000000cc2f0000 0000000000000001 
GPR24: c000000000db4402 000000000000000f 0000000000000000 c0000000dea39300 
GPR28: c000000000ef0ae0 c0000000e5440000 0000000000000000 c000000000ef4f7c 
[  181.916146] NIP [c0000000000d7528] .build_sched_domains+0xc28/0xd90
[  181.916151] LR [c0000000000d7578] .build_sched_domains+0xc78/0xd90
[  181.916155] Call Trace:
[  181.916159] [c0000000da403800] [c0000000000d7578] .build_sched_domains+0xc78/0xd90 (unreliable)
[  181.916166] [c0000000da403950] [c0000000000d7950] .partition_sched_domains+0x260/0x3f0
[  181.916175] [c0000000da403a30] [c000000000141704] .rebuild_sched_domains_locked+0x54/0x70
[  181.916182] [c0000000da403ab0] [c000000000143a98] .rebuild_sched_domains+0x28/0x50
[  181.916188] [c0000000da403b30] [c00000000004f250] .topology_work_fn+0x10/0x30
[  181.916194] [c0000000da403ba0] [c0000000000b7100] .process_one_work+0x1a0/0x4c0
[  181.916199] [c0000000da403c40] [c0000000000b7970] .worker_thread+0x180/0x630
[  181.916205] [c0000000da403d30] [c0000000000bfc88] .kthread+0x108/0x130
[  181.916214] [c0000000da403e30] [c00000000000a3e4] .ret_from_kernel_thread+0x58/0x74
[  181.916220] Instruction dump:
[  181.916223] 7f47492a e93c0000 e90a0010 7d0a4378 7d4a482a 814a0000 2f8a0000 419e0008 
[  181.916235] 7f48492a ebdd0010 7fc90074 7929d182 <0b090000> 48000014 60000000 60000000 
[  181.916245] ---[ end trace 6e9d20016598c36c ]---
[  181.916253] Unable to handle kernel paging request for data at address 0x00000018
[  181.916257] Faulting instruction address: 0xc00000000039d1c0
[  181.916263] Oops: Kernel access of bad area, sig: 11 [#1]
[  181.916267] SMP NR_CPUS=2048 NUMA pSeries
[  181.916271] Modules linked in: sg cfg80211 rfkill nx_crypto ibmveth pseries_rng xfs libcrc32c sd_mod crc_t10dif crct10dif_common ibmvscsi scsi_transport_srp scsi_tgt dm_mirror dm_region_hash dm_log dm_mod
[  181.916293] CPU: 4 PID: 1087 Comm: kworker/4:2 Tainted: G        W     3.16.0-rc7-24x7+ #15
[  181.916299] Workqueue: events .topology_work_fn
[  181.916303] task: c0000000dbd40000 ti: c0000000da400000 task.ti: c0000000da400000
[  181.916309] NIP: c00000000039d1c0 LR: c0000000000d754c CTR: 0000000000000000
[  181.916313] REGS: c0000000da4034d0 TRAP: 0300   Tainted: G        W      (3.16.0-rc7-24x7+)
[  181.916317] MSR: 8000000100009032 <SF,EE,ME,IR,DR,RI>  CR: 28484c24  XER: 00000000
[  181.916327] CFAR: c000000000009358 DAR: 0000000000000018 DSISR: 40000000 SOFTE: 1 
GPR00: c0000000000d754c c0000000da403750 c000000000eaa7f0 0000000000000018 
GPR04: 0000000000000800 0000000000000800 0000000000000000 c0000000009cf878 
GPR08: c0000000009cf880 0000000000000001 0000000000000010 0000000000000000 
GPR12: 0000000000000000 c00000000ebe1200 0000000000000800 c0000000cc2f0000 
GPR16: c000000000ef0a68 0000000000000078 c0000000e5000000 0000000000000078 
GPR20: 0000000000000000 0000000000000001 c0000000cc2f0000 0000000000000001 
GPR24: c000000000db4402 0000000000000020 0000000000000018 0000000000000800 
GPR28: 0000000000000020 0000000000000110 0000000000000000 0000000000000010 
[  181.916406] NIP [c00000000039d1c0] .__bitmap_weight+0x70/0x100
[  181.916411] LR [c0000000000d754c] .build_sched_domains+0xc4c/0xd90
[  181.916415] Call Trace:
[  181.916418] [c0000000da403750] [c0000000da403800] 0xc0000000da403800 (unreliable)
[  181.916424] [c0000000da403800] [c0000000000d754c] .build_sched_domains+0xc4c/0xd90
[  181.916430] [c0000000da403950] [c0000000000d7950] .partition_sched_domains+0x260/0x3f0
[  181.916436] [c0000000da403a30] [c000000000141704] .rebuild_sched_domains_locked+0x54/0x70
[  181.916442] [c0000000da403ab0] [c000000000143a98] .rebuild_sched_domains+0x28/0x50
[  181.916448] [c0000000da403b30] [c00000000004f250] .topology_work_fn+0x10/0x30
[  181.916453] [c0000000da403ba0] [c0000000000b7100] .process_one_work+0x1a0/0x4c0
[  181.916458] [c0000000da403c40] [c0000000000b7970] .worker_thread+0x180/0x630
[  181.916463] [c0000000da403d30] [c0000000000bfc88] .kthread+0x108/0x130
[  181.916468] [c0000000da403e30] [c00000000000a3e4] .ret_from_kernel_thread+0x58/0x74
[  181.916472] Instruction dump:
[  181.916475] 409d00b4 3bbcffff 3be3fff8 7bbd1f48 3bc00000 7fa3ea14 48000018 60000000 
[  181.916484] 60000000 60000000 60000000 60420000 <e87f0009> 4bcb74e9 60000000 7fbfe840 
[  181.916493] ---[ end trace 6e9d20016598c36d ]---
[  181.924408] 
[  183.931081] Kernel panic - not syncing: Fatal exception
[  183.954314] Rebooting in 10 seconds..


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Description: debug.dmsg
Content-Disposition: attachment; filename="peterz.dmsg"




Red Hat Enterprise Linux Server 7.0 (Maipo)
Kernel 3.16.0-rc7 on an ppc64

ltcbrazos2-lp07 login: [  OK  ] Started Show Plymouth Reboot Screen.
[  OK  ] Stopped Postfix Mail Transport Agent.
[  OK  ] Stopped target Network.
         Stopping LSB: Bring up/down networking...
[  OK  ] Stopped LSB: Bring up/down networking.
         Stopping Network Manager...
[  OK  ] Stopped Network Manager.
[  OK  ] Stopped target Basic System.
[  OK  ] Stopped target Slices.
[  OK  ] Removed slice User and Session Slice.
[  OK  ] Stopped target Paths.
[  OK  ] Stopped target Timers.
[  OK  ] Stopped target Sockets.
[  OK  ] Closed Avahi mDNS/DNS-SD Stack Activation Socket.
[  OK  ] Closed D-Bus System Message Bus Socket.
[  OK  ] Stopped target System Initialization.
         Stopping Setup Virtual Console...
[  OK  ] Stopped Setup Virtual Console.
[  OK  ] Stopped target Encrypted Volumes.
         Stopping Load/Save Random Seed...
         Stopping Apply Kernel Variables...
[  OK  ] Stopped Apply Kernel Variables.
         Stopping Update UTMP about System Reboot/Shutdown...
[  OK  ] Stopped target Swap.
         Deactivating swap /dev/dm-1...
         Deactivating swap /dev/dm-1...
         Deactivating swap /dev/dm-1...
         Deactivating swap /dev/dm-1...
         Deactivating swap /dev/dm-1...
         Deactivating swap /dev/dm-1...
[  OK  ] Stopped Load/Save Random Seed.
[  OK  ] Stopped Update UTMP about System Reboot/Shutdown.
         Stopping Security Auditing Service...
         Stopping Create Volatile Files and Directories...
[  OK  ] Stopped Create Volatile Files and Directories.
         Stopping Import network configuration from initramfs...
[  OK  ] Stopped Import network configuration from initramfs.
[  OK  ] Deactivated swap /dev/rhel_ltcbrazos2-lp07/swap.
[  OK  ] Deactivated swap /dev/disk/by-uuid/a943c471-4382-480...e-9782b5d3d2ab.
[  OK  ] Deactivated swap /dev/disk/by-id/dm-uuid-LVM-p1mvXnt...NIVU5f85SS81no.
[  OK  ] Deactivated swap /dev/disk/by-id/dm-name-rhel_ltcbrazos2--lp07-swap.
[  OK  ] Deactivated swap /dev/mapper/rhel_ltcbrazos2--lp07-swap.
[  OK  ] Deactivated swap /dev/dm-1.
[ 2433.045467] audit: type=1305 audit(1406703087.290:102): audit_pid=0 old=1093 auid=4294967295 ses=4294967295 res=1
[  OK  ] Stopped Security Auditing Service.
[ 2433.046079] audit: type=1131 audit(1406703087.290:103): pid=1 uid=0 auid=4294967295 ses=4294967295 msg=' comm="auditd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[  OK  ] Stopped target Local File Systems.
         Unmounting /boot...
         Stopping Configure read-only root support...
[  OK  ] Stopped Configure read-only root support.
[ 2433.046851] audit: type=1131 audit(1406703087.290:104): pid=1 uid=0 auid=4294967295 ses=4294967295 msg=' comm="rhel-readonly" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
         Stopping Monitoring of LVM2 mirrors, snapshots etc. ...ress polling...
[ 2433.108826] audit: type=1131 audit(1406703087.350:105): pid=1 uid=0 auid=4294967295 ses=4294967295 msg=' comm="lvm2-monitor" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[  OK  ] Stopped Monitoring of LVM2 mirrors, snapshots etc. u...ogress polling.
         Stopping LVM2 metadata daemon...
[ 2433.109666] audit: type=1131 audit(1406703087.350:106): pid=1 uid=0 auid=4294967295 ses=4294967295 msg=' comm="lvm2-lvmetad" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[  OK  ] Stopped LVM2 metadata daemon.
[ 2433.120492] audit: type=1131 audit(1406703087.360:107): pid=1 uid=0 auid=4294967295 ses=4294967295 msg=' comm="systemd-remount-fs" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[ 2433.120583] audit: type=1131 audit(1406703087.360:108): pid=1 uid=0 auid=4294967295 ses=4294967295 msg=' comm="systemd-readahead-replay" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[ 2433.120671] audit: type=1131 audit(1406703087.360:109): pid=1 uid=0 auid=4294967295 ses=4294967295 msg=' comm="systemd-readahead-collect" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
[  OK  ] Unmounted /boot.
[  OK  ] Reached target Unmount All Filesystems.
[  OK  ] Stopped target Local File Systems (Pre).
         Stopping Remount Root and Kernel File Systems...
[  OK  ] Stopped Remount Root and Kernel File Systems.
         Stopping Replay Read-Ahead Data...
[  OK  ] Stopped Replay Read-Ahead Data.
         Stopping Collect Read-Ahead Data...
[  OK  ] Stopped Collect Read-Ahead Data.
[  OK  ] Reached target Shutdown.
[ 2433.195428] systemd-journald[585]: Received SIGTERM
Sending SIGTERM to remaining processes...
Sending SIGKILL to remaining processes...
Unmounting file systems.
Unmounting /dev/hugepages.
Unmounting /dev/mqueue.
Unmounting /sys/kernel/debug.
Unmounting /sys/kernel/config.
All filesystems unmounted.
Deactivating swaps.
All swaps deactivated.
Detaching loop devices.
All loop devices detached.
Detaching DM devices.
Detaching DM 253:1.
Not all DM devices detached, 1 left.
Detaching DM devices.
Not all DM devices detached, 1 left.
Cannot finalize remaining file systems and devices, giving up.
Storage is finalized.
[ 2433.524953] reboot: Restarting system
























IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 

          1 = SMS Menu                          5 = Default Boot List
          8 = Open Firmware Prompt              6 = Stored Boot List


     Memory      Keyboard     Network     Speaker 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM                             IBM IBM IBM IBM IBM IBM
IBM IBM IBM IBM IBM IBM     STARTING SOFTWARE       IBM IBM IBM IBM IBM IBM
IBM IBM IBM IBM IBM IBM        PLEASE WAIT...       IBM IBM IBM IBM IBM IBM
IBM IBM IBM IBM IBM IBM                             IBM IBM IBM IBM IBM IBM
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM IBM 
/
Elapsed time since release of system processors: 0 mins 9 secs





      Red Hat Enterprise Linux Server, with Linux 3.16.0-rc7                    
      Red Hat Enterprise Linux Server, with Linux 3.16.0-rc7-24x7              
      Red Hat Enterprise Linux Server, with Linux 3.16.0-rc2-24x7              
      Red Hat Enterprise Linux Server, with Linux 3.10.0-suka-backports        
      Red Hat Enterprise Linux Server, with Linux 3.10.0-123.el7.ppc64         
      Red Hat Enterprise Linux Server, with Linux 0-rescue-fa07989832f3430ebf3>
                                                                               
                                                                               
                                                                               
                                                                               
                                                                               
                                                                               
                                                                               
                                                                               
                                                                                

      Use the ^ and v keys to change the selection.                       
      Press 'e' to edit the selected item, or 'c' for a command prompt.   
                                                                               
                                                                               

























OF stdout device is: /vdevice/vty@30000000
Preparing to boot Linux version 3.16.0-rc7-24x7+ (root@ltcbrazos2-lp07.austin.ibm.com) (gcc version 4.8.2 20140120 (Red Hat 4.8.2-16) (GCC) ) #17 SMP Wed Jul 30 02:49:19 EDT 2014
Detected machine type: 0000000000000101
Max number of cores passed to firmware: 256 (NR_CPUS = 2048)
Calling ibm,client-architecture-support... done
command line: BOOT_IMAGE=/vmlinux-3.16.0-rc7-24x7 root=UUID=e72c49fa-e137-43ff-ab41-44f3124572eb ro vconsole.keymap=us rd.lvm.lv=rhel_ltcbrazos2-lp07/root rd.lvm.lv=rhel_ltcbrazos2-lp07/swap crashkernel=auto vconsole.font=latarcyrheb-sun16 earlyprinkt=keep sched_debug
memory layout at init:
  memory_limit : 0000000000000000 (16 MB aligned)
  alloc_bottom : 000000000a5f0000
  alloc_top    : 0000000010000000
  alloc_top_hi : 0000000010000000
  rmo_top      : 0000000010000000
  ram_top      : 0000000010000000
instantiating rtas at 0x000000000ee20000... done
prom_hold_cpus: skipped
copying OF device tree...
Building dt strings...
Building dt structure...
Device tree strings 0x000000000a600000 -> 0x000000000a6016d4
Device tree struct  0x000000000a610000 -> 0x000000000a640000
Calling quiesce...
returning from prom_init
[    0.000000] crashkernel: memory value expected
[    0.000000] Using pSeries machine description
[    0.000000] Page sizes from device-tree:
[    0.000000] base_shift=12: shift=12, sllp=0x0000, avpnm=0x00000000, tlbiel=1, penc=0
[    0.000000] base_shift=12: shift=16, sllp=0x0000, avpnm=0x00000000, tlbiel=1, penc=7
[    0.000000] base_shift=12: shift=24, sllp=0x0000, avpnm=0x00000000, tlbiel=1, penc=56
[    0.000000] base_shift=16: shift=16, sllp=0x0110, avpnm=0x00000000, tlbiel=1, penc=1
[    0.000000] base_shift=16: shift=24, sllp=0x0110, avpnm=0x00000000, tlbiel=1, penc=8
[    0.000000] base_shift=24: shift=24, sllp=0x0100, avpnm=0x00000001, tlbiel=0, penc=0
[    0.000000] base_shift=34: shift=34, sllp=0x0120, avpnm=0x000007ff, tlbiel=0, penc=3
[    0.000000] Using 1TB segments
[    0.000000] kvm_cma: CMA: reserved 256 MiB
[    0.000000] Found initrd at 0xc000000009a00000:0xc00000000a5eb9b8
[    0.000000] bootconsole [udbg0] enabled
[    0.000000] Partition configured for 32 cpus.
[    0.000000] CPU maps initialized for 8 threads per core
 -> smp_release_cpus()
spinning_secondaries = 15
 <- smp_release_cpus()
[    0.000000] Starting Linux PPC64 #17 SMP Wed Jul 30 02:49:19 EDT 2014
[    0.000000] -----------------------------------------------------
[    0.000000] ppc64_pft_size                = 0x1a
[    0.000000] physicalMemorySize            = 0x100000000
[    0.000000] htab_hash_mask                = 0x7ffff
[    0.000000] -----------------------------------------------------
 <- setup_system()
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.16.0-rc7-24x7+ (root@ltcbrazos2-lp07.austin.ibm.com) (gcc version 4.8.2 20140120 (Red Hat 4.8.2-16) (GCC) ) #17 SMP Wed Jul 30 02:49:19 EDT 2014
[    0.000000] [boot]0012 Setup Arch
[    0.000000] PPC64 nvram contains 15360 bytes
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   1: [mem 0x00000000-0xffffffff]
[    0.000000] Could not find start_pfn for node 0
[    0.000000] [boot]0015 Setup Done
[    0.000000] PERCPU: Embedded 2 pages/cpu @c000000001200000 s102272 r0 d28800 u131072
[    0.000000] Built 2 zonelists in Node order, mobility grouping on.  Total pages: 65480
[    0.000000] Policy zone: DMA
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinux-3.16.0-rc7-24x7 root=UUID=e72c49fa-e137-43ff-ab41-44f3124572eb ro vconsole.keymap=us rd.lvm.lv=rhel_ltcbrazos2-lp07/root rd.lvm.lv=rhel_ltcbrazos2-lp07/swap crashkernel=auto vconsole.font=latarcyrheb-sun16 earlyprinkt=keep sched_debug
[    0.000000] PID hash table entries: 4096 (order: -1, 32768 bytes)
[    0.000000] Sorting __ex_table...
[    0.000000] Memory: 3793664K/4194304K available (7488K kernel code, 1728K rwdata, 1808K rodata, 4352K init, 2435K bss, 400640K reserved)
[    0.000000] SLUB: HWalign=128, Order=0-3, MinObjects=0, CPUs=32, Nodes=256
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=2048 to nr_cpu_ids=32.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-31.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=32
[    0.000000] NR_IRQS:512 nr_irqs:512 16
[    0.000001] clocksource: timebase mult[1f40000] shift[24] registered
[    0.000122] Console: colour dummy device 80x25
[    0.000141] console [hvc0] enabled
[    0.000141] console [hvc0] enabled
[    0.000156] bootconsole [udbg0] disabled
[    0.000156] bootconsole [udbg0] disabled
[    0.001244] allocated 1048576 bytes of page_cgroup
[    0.001252] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.001287] mempolicy: Enabling automatic NUMA balancing. Configure with numa_balancing= or the kernel.numa_balancing sysctl
[    0.001293] pid_max: default: 32768 minimum: 301
[    0.001328] Security Framework initialized
[    0.001338] SELinux:  Initializing.
[    0.001403] Dentry cache hash table entries: 524288 (order: 6, 4194304 bytes)
[    0.002058] Inode-cache hash table entries: 262144 (order: 5, 2097152 bytes)
[    0.002384] Mount-cache hash table entries: 8192 (order: 0, 65536 bytes)
[    0.002388] Mountpoint-cache hash table entries: 8192 (order: 0, 65536 bytes)
[    0.002603] Initializing cgroup subsys memory
[    0.002667] Initializing cgroup subsys devices
[    0.002673] Initializing cgroup subsys freezer
[    0.002677] Initializing cgroup subsys net_cls
[    0.002682] Initializing cgroup subsys blkio
[    0.002687] Initializing cgroup subsys perf_event
[    0.002690] Initializing cgroup subsys hugetlb
[    0.002805] EEH: pSeries platform initialized
[    0.002819] POWER8 performance monitor hardware support registered
[    0.020203] Brought up 16 CPUs
[    0.024297] __sdt_alloc: allocated c0000000e7ab0000 with cpus: 
[    0.024330] __sdt_alloc: allocated c0000000e7ae0000 with cpus: 
[    0.024363] __sdt_alloc: allocated c0000000e7b10000 with cpus: 
[    0.024396] __sdt_alloc: allocated c0000000e7b40000 with cpus: 
[    0.024428] __sdt_alloc: allocated c0000000e7b70000 with cpus: 
[    0.024460] __sdt_alloc: allocated c0000000e7ba0000 with cpus: 
[    0.024493] __sdt_alloc: allocated c0000000e7bd0000 with cpus: 
[    0.024526] __sdt_alloc: allocated c0000000e7c00000 with cpus: 
[    0.024558] __sdt_alloc: allocated c0000000e7c30000 with cpus: 
[    0.024591] __sdt_alloc: allocated c0000000e7c60000 with cpus: 
[    0.024623] __sdt_alloc: allocated c0000000e7c90000 with cpus: 
[    0.024655] __sdt_alloc: allocated c0000000e7cc0000 with cpus: 
[    0.024688] __sdt_alloc: allocated c0000000e7cf0000 with cpus: 
[    0.024720] __sdt_alloc: allocated c0000000e7d20000 with cpus: 
[    0.024753] __sdt_alloc: allocated c0000000e7d50000 with cpus: 
[    0.024785] __sdt_alloc: allocated c0000000e7d80000 with cpus: 
[    0.024819] __sdt_alloc: allocated c0000000e7db0000 with cpus: 
[    0.024852] __sdt_alloc: allocated c0000000e7de0000 with cpus: 
[    0.024884] __sdt_alloc: allocated c0000000e7e10000 with cpus: 
[    0.024916] __sdt_alloc: allocated c0000000e7e40000 with cpus: 
[    0.024949] __sdt_alloc: allocated c0000000e7e70000 with cpus: 
[    0.024981] __sdt_alloc: allocated c0000000e7ea0000 with cpus: 
[    0.025013] __sdt_alloc: allocated c0000000e7ed0000 with cpus: 
[    0.025045] __sdt_alloc: allocated c0000000e7f00000 with cpus: 
[    0.025078] __sdt_alloc: allocated c0000000e7f30000 with cpus: 
[    0.025110] __sdt_alloc: allocated c0000000e7f60000 with cpus: 
[    0.025143] __sdt_alloc: allocated c0000000e7f90000 with cpus: 
[    0.025175] __sdt_alloc: allocated c0000000e7fc0000 with cpus: 
[    0.025208] __sdt_alloc: allocated c0000000e7ff0000 with cpus: 
[    0.025240] __sdt_alloc: allocated c0000000e6020000 with cpus: 
[    0.025273] __sdt_alloc: allocated c0000000e6050000 with cpus: 
[    0.025305] __sdt_alloc: allocated c0000000e6080000 with cpus: 
[    0.025339] __sdt_alloc: allocated c0000000e60b0000 with cpus: 
[    0.025372] __sdt_alloc: allocated c0000000e60e0000 with cpus: 
[    0.025404] __sdt_alloc: allocated c0000000e6110000 with cpus: 
[    0.025436] __sdt_alloc: allocated c0000000e6140000 with cpus: 
[    0.025469] __sdt_alloc: allocated c0000000e6170000 with cpus: 
[    0.025501] __sdt_alloc: allocated c0000000e61a0000 with cpus: 
[    0.025533] __sdt_alloc: allocated c0000000e61d0000 with cpus: 
[    0.025566] __sdt_alloc: allocated c0000000e6200000 with cpus: 
[    0.025598] __sdt_alloc: allocated c0000000e6230000 with cpus: 
[    0.025630] __sdt_alloc: allocated c0000000e6260000 with cpus: 
[    0.025663] __sdt_alloc: allocated c0000000e6290000 with cpus: 
[    0.025695] __sdt_alloc: allocated c0000000e62c0000 with cpus: 
[    0.025727] __sdt_alloc: allocated c0000000e62f0000 with cpus: 
[    0.025758] __sdt_alloc: allocated c0000000e6320000 with cpus: 
[    0.025791] __sdt_alloc: allocated c0000000e6350000 with cpus: 
[    0.025822] __sdt_alloc: allocated c0000000e6380000 with cpus: 
[    0.025850] build_sched_groups: got group c0000000e7ab0000 with cpus: 
[    0.025853] build_sched_groups: got group c0000000e7ae0000 with cpus: 
[    0.025856] build_sched_groups: got group c0000000e7b10000 with cpus: 
[    0.025859] build_sched_groups: got group c0000000e7b40000 with cpus: 
[    0.025862] build_sched_groups: got group c0000000e7b70000 with cpus: 
[    0.025865] build_sched_groups: got group c0000000e7ba0000 with cpus: 
[    0.025869] build_sched_groups: got group c0000000e7bd0000 with cpus: 
[    0.025872] build_sched_groups: got group c0000000e7c00000 with cpus: 
[    0.025875] build_sched_groups: got group c0000000e7db0000 with cpus: 
[    0.025879] build_sched_groups: got group c0000000e7f30000 with cpus: 
[    0.025885] build_sched_groups: got group c0000000e7c30000 with cpus: 
[    0.025888] build_sched_groups: got group c0000000e7c60000 with cpus: 
[    0.025891] build_sched_groups: got group c0000000e7c90000 with cpus: 
[    0.025894] build_sched_groups: got group c0000000e7cc0000 with cpus: 
[    0.025897] build_sched_groups: got group c0000000e7cf0000 with cpus: 
[    0.025900] build_sched_groups: got group c0000000e7d20000 with cpus: 
[    0.025903] build_sched_groups: got group c0000000e7d50000 with cpus: 
[    0.025907] build_sched_groups: got group c0000000e7d80000 with cpus: 
[    0.026779] devtmpfs: initialized
[    0.034324] EEH: devices created
[    0.034767] atomic64_test: passed
[    0.035333] NET: Registered protocol family 16
[    0.035399] EEH: No capable adapters found
[    0.035448] IBM eBus Device Driver
[    0.035552] cpuidle: using governor menu
[    0.035671] pstore: Registered nvram as persistent store backend
[    0.037405] PCI: Probing PCI hardware
[    0.037414] opal: Node not found
[    0.037420] opal_async_comp_init: Opal node not found
[    0.037506] pseries-rng: Registering arch random hook.
[    0.040874] vgaarb: loaded
[    0.040939] SCSI subsystem initialized
[    0.040975] usbcore: registered new interface driver usbfs
[    0.040984] usbcore: registered new interface driver hub
[    0.041030] usbcore: registered new device driver usb
[    0.041235] NetLabel: Initializing
[    0.041238] NetLabel:  domain hash size = 128
[    0.041240] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.041250] NetLabel:  unlabeled traffic allowed by default
[    0.041378] Switched to clocksource timebase
[    0.046206] NET: Registered protocol family 2
[    0.046401] TCP established hash table entries: 32768 (order: 2, 262144 bytes)
[    0.046462] TCP bind hash table entries: 32768 (order: 3, 524288 bytes)
[    0.046524] TCP: Hash tables configured (established 32768 bind 32768)
[    0.046535] TCP: reno registered
[    0.046542] UDP hash table entries: 2048 (order: 0, 65536 bytes)
[    0.046553] UDP-Lite hash table entries: 2048 (order: 0, 65536 bytes)
[    0.046624] NET: Registered protocol family 1
[    0.046675] Unpacking initramfs...
[    0.197080] Freeing initrd memory: 12160K (c000000009a00000 - c00000000a5e0000)
[    0.201424] IOMMU table initialized, virtual merging enabled
[    0.230054] hv-24x7: read 1246 catalog entries, created 1265 event attrs (0 failures), 127 descs
[    0.230510] futex hash table entries: 8192 (order: 4, 1048576 bytes)
[    0.230641] Initialise system trusted keyring
[    0.230661] audit: initializing netlink subsys (disabled)
[    0.230679] audit: type=2000 audit(1406703165.220:1): initialized
[    0.231859] HugeTLB registered 16 MB page size, pre-allocated 0 pages
[    0.231863] HugeTLB registered 16 GB page size, pre-allocated 0 pages
[    0.233593] zbud: loaded
[    0.233784] VFS: Disk quotas dquot_6.5.2
[    0.233830] Dquot-cache hash table entries: 8192 (order 0, 65536 bytes)
[    0.234002] msgmni has been set to 8076
[    0.234071] Key type big_key registered
[    0.234936] alg: No test for stdrng (krng)
[    0.234955] NET: Registered protocol family 38
[    0.234962] Key type asymmetric registered
[    0.234965] Asymmetric key parser 'x509' registered
[    0.235002] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.235116] io scheduler noop registered
[    0.235120] io scheduler deadline registered (default)
[    0.235231] io scheduler cfq registered
[    0.235304] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.235312] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.235316] rpaphp: RPA HOT Plug PCI Controller Driver version: 0.1
[    0.235798] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.236105] Linux agpgart interface v0.103
[    0.236182] rdac: device handler registered
[    0.236329] hp_sw: device handler registered
[    0.236333] emc: device handler registered
[    0.236336] alua: device handler registered
[    0.236373] libphy: Fixed MDIO Bus: probed
[    0.236442] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.236451] ehci-pci: EHCI PCI platform driver
[    0.236460] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.236468] ohci-pci: OHCI PCI platform driver
[    0.236476] uhci_hcd: USB Universal Host Controller Interface driver
[    0.236517] usbcore: registered new interface driver usbserial
[    0.236524] usbcore: registered new interface driver usbserial_generic
[    0.236531] usbserial: USB Serial support registered for generic
[    0.236603] mousedev: PS/2 mouse device common for all mice
[    0.236825] rtc-generic rtc-generic: rtc core: registered rtc-generic as rtc0
[    0.236843] powernv-cpufreq: power-mgt node not found
[    0.236846] powernv-cpufreq: powernv-cpufreq disabled. System does not support PState control
[    0.237052] hidraw: raw HID events driver (C) Jiri Kosina
[    0.237146] usbcore: registered new interface driver usbhid
[    0.237149] usbhid: USB HID core driver
[    0.237164] drop_monitor: Initializing network drop monitor service
[    0.237224] TCP: cubic registered
[    0.237235] Initializing XFRM netlink socket
[    0.237328] NET: Registered protocol family 10
[    0.237521] NET: Registered protocol family 17
[    0.237707] Loading compiled-in X.509 certificates
[    0.238282] Loaded X.509 cert 'Magrathea: Glacier signing key: 60ef07e620363bf1993b6d295d264cddf46db0ea'
[    0.238298] registered taskstats version 1
[    0.242885] rtc-generic rtc-generic: setting system clock to 2014-07-30 06:52:45 UTC (1406703165)
[    0.243331] Freeing unused kernel memory: 4352K (c000000000920000 - c000000000d60000)
[    0.253009] systemd[1]: systemd 208 running in system mode. (+PAM +LIBWRAP +AUDIT +SELINUX +IMA +SYSVINIT +LIBCRYPTSETUP +GCRYPT +ACL +XZ)
[    0.253095] systemd[1]: Running in initial RAM disk.

Welcome to Red Hat Enterprise Linux Server 7.0 (Maipo) dracut-033-161.el7 (Initramfs)!

[    0.253327] systemd[1]: Set hostname to <ltcbrazos2-lp07.austin.ibm.com>.
[    0.253854] random: systemd urandom read with 17 bits of entropy available
[    0.277123] systemd[1]: Expecting device dev-disk-by\x2duuid-e72c49fa\x2de137\x2d43ff\x2dab41\x2d44f3124572eb.device...
         Expecting device dev-disk-by\x2duuid-e72c49fa\x2de13...572eb.device...
[    0.277348] systemd[1]: Starting -.slice.
[  OK  ] Created slice -.slice.
[    0.277721] systemd[1]: Created slice -.slice.
[    0.277752] systemd[1]: Starting System Slice.
[  OK  ] Created slice System Slice.
[    0.277946] systemd[1]: Created slice System Slice.
[    0.277976] systemd[1]: Starting Slices.
[  OK  ] Reached target Slices.
[    0.278120] systemd[1]: Reached target Slices.
[    0.278150] systemd[1]: Starting Timers.
[  OK  ] Reached target Timers.
[    0.278289] systemd[1]: Reached target Timers.
[    0.278318] systemd[1]: Starting Journal Socket.
[  OK  ] Listening on Journal Socket.
[    0.278489] systemd[1]: Listening on Journal Socket.
[    0.278641] systemd[1]: Starting dracut cmdline hook...
         Starting dracut cmdline hook...
[    0.279120] systemd[1]: Started Load Kernel Modules.
[    0.279129] systemd[1]: Starting Setup Virtual Console...
         Starting Setup Virtual Console...
[    0.279524] systemd[1]: Starting Journal Service...
         Starting Journal Service...
[  OK  ] Started Journal Service.
[    0.280348] systemd[1]: Started Journal Service.
[  OK  ] Listening on udev Kernel Socket.
[  OK  ] Listening on udev Control Socket.
[  OK  ] Reached target Sockets.
         Starting Create list of required static device nodes...rrent kernel...
         Starting Apply Kernel Variables...
[  OK  ] Reached target Swap.
[  OK  ] Reached target Local File Systems.
[    0.296357] systemd-journald[189]: Vacuuming done, freed 0 bytes
[  OK  ] Started Setup Virtual Console.
[  OK  ] Started Apply Kernel Variables.
[  OK  ] Started Create list of required static device nodes ...current kernel.
         Starting Create static device nodes in /dev...
[  OK  ] Started Create static device nodes in /dev.
[  OK  ] Started dracut cmdline hook.
         Starting dracut pre-udev hook...
[    0.420406] device-mapper: uevent: version 1.0.3
[    0.420563] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[  OK  ] Started dracut pre-udev hook.
         Starting udev Kernel Device Manager...
[    0.445276] systemd-udevd[320]: starting version 208
[  OK  ] Started udev Kernel Device Manager.
         Starting udev Coldplug all Devices...
         Mounting Configuration File System...
[  OK  ] Mounted Configuration File System.
[  OK  ] Started udev Coldplug all Devices.
         Starting dracut initqueue hook...
[  OK  ] Reached target System Initialization.
         Starting Show Plymouth Boot Screen...
[    0.495293] ibmvscsi 30000003: SRP_VERSION: 16.a
[    0.495520] scsi0 : IBM POWER Virtual SCSI Adapter 1.5.9
[    0.495774] ibmvscsi 30000003: partner initialization complete
[    0.495834] ibmvscsi 30000003: host srp version: 16.a, host partition ltcbrazos2-vios (1), OS 3, max io 262144
[    0.495908] ibmvscsi 30000003: Client reserve enabled
[    0.495924] ibmvscsi 30000003: sent SRP login
[    0.495959] ibmvscsi 30000003: SRP_LOGIN succeeded
[    0.513152] ibmvscsi 30000004: SRP_VERSION: 16.a
[    0.513301] scsi 0:0:1:0: Direct-Access     AIX      VDASD            0001 PQ: 0 ANSI: 3
[    0.513378] scsi1 : IBM POWER Virtual SCSI Adapter 1.5.9
[    0.513613] ibmvscsi 30000004: partner initialization complete
[    0.513659] ibmvscsi 30000004: host srp version: 16.a, host partition ltcbrazos2-vios (1), OS 3, max io 262144
[    0.513724] ibmvscsi 30000004: Client reserve enabled
[    0.513735] ibmvscsi 30000004: sent SRP login
[    0.513773] ibmvscsi 30000004: SRP_LOGIN succeeded
[  OK  ] Started Show Plymouth Boot Screen.
[  OK  ] Reached target Paths.
[  OK  ] Reached target Basic System.
[    0.532850] scsi 1:0:1:0: Direct-Access     AIX      VDASD            0001 PQ: 0 ANSI: 3
         Starting File System Check on /dev/disk/by-uuid/e72c...44f3124572eb...
[    0.565312] sd 0:0:1:0: [sda] 41943040 512-byte logical blocks: (21.4 GB/20.0 GiB)
[    0.565365] sd 0:0:1:0: [sda] Write Protect is off
[    0.565366] sd 1:0:1:0: [sdb] 41943040 512-byte logical blocks: (21.4 GB/20.0 GiB)
[    0.565424] sd 0:0:1:0: [sda] Cache data unavailable
[    0.565424] sd 1:0:1:0: [sdb] Write Protect is off
[    0.565435] sd 0:0:1:0: [sda] Assuming drive cache: write through
[    0.565479] sd 1:0:1:0: [sdb] Cache data unavailable
[    0.565485] sd 1:0:1:0: [sdb] Assuming drive cache: write through
[    0.566287]  sda: sda1 sda2 sda3
[    0.566344]  sdb: sdb1
[    0.566763] sd 0:0:1:0: [sda] Attached SCSI disk
[    0.566773] sd 1:0:1:0: [sdb] Attached SCSI disk
systemd-fsck[385]: fsck: error 2 (No such file or directory) while executing fsck.ext2 for /dev/disk/by-uuid/e72c49fa-e137-43ff-ab41-44f3124572eb
[  OK  ] Started File System Check on /dev/disk/by-uuid/e72c4...1-44f3124572eb.
[  OK  ] Started dracut initqueue hook.
         Mounting /sysroot...
[    1.277941] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    1.279694] XFS (dm-0): Mounting V4 Filesystem
[    9.504734] XFS (dm-0): Ending clean mount
[  OK  ] Mounted /sysroot.
[  OK  ] Reached target Initrd Root File System.
         Starting Reload Configuration from the Real Root...
[  OK  ] Started Reload Configuration from the Real Root.
[  OK  ] Reached target Initrd File Systems.
[  OK  ] Reached target Initrd Default Target.
[    9.641131] random: nonblocking pool is initialized
[    9.649710] systemd-journald[189]: Received SIGTERM
[    9.802718] SELinux:  Disabled at runtime.
[    9.881394] audit: type=1404 audit(1406703175.140:2): selinux=0 auid=4294967295 ses=4294967295

Welcome to Red Hat Enterprise Linux Server 7.0 (Maipo)!

[  OK  ] Stopped Switch Root.
[  OK  ] Stopped target Switch Root.
[  OK  ] Stopped target Initrd File Systems.
         Stopping File System Check on /dev/disk/by-uuid/e72c...44f3124572eb...
[  OK  ] Stopped File System Check on /dev/disk/by-uuid/e72c4...1-44f3124572eb.
[  OK  ] Stopped target Initrd Root File System.
[  OK  ] Created slice User and Session Slice.
[  OK  ] Created slice system-serial\x2dgetty.slice.
         Expecting device dev-hvc0.device...
[  OK  ] Created slice system-getty.slice.
[  OK  ] Reached target Remote File Systems.
         Starting Collect Read-Ahead Data...
         Starting Replay Read-Ahead Data...
[  OK  ] Reached target Slices.
[  OK  ] Listening on Delayed Shutdown Socket.
[  OK  ] Listening on /dev/initctl Compatibility Named Pipe.
[  OK  ] Listening on udev Kernel Socket.
[  OK  ] Listening on udev Control Socket.
         Starting udev Coldplug all Devices...
         Mounting Debug File System...
[  OK  ] Set up automount Arbitrary Executable File Formats F...utomount Point.
         Starting Create list of required static device nodes...rrent kernel...
         Mounting POSIX Message Queue File System...
         Mounting Huge Pages File System...
[  OK  ] Reached target Encrypted Volumes.
[  OK  ] Listening on LVM2 metadata daemon socket.
[  OK  ] Listening on Device-mapper event daemon FIFOs.
         Starting Monitoring of LVM2 mirrors, snapshots etc. ...ress polling...
         Expecting device dev-mapper-rhel_ltcbrazos2\x2d\x2dl...dswap.device...
         Expecting device dev-disk-by\x2duuid-5db39dc3\x2df94...1ffc1.device...
[  OK  ] Stopped Trigger Flushing of Journal to Persistent Storage.
         Stopping Journal Service...
[  OK  ] Stopped Journal Service.
         Starting Journal Service...
[  OK  ] Started Journal Service.
[  OK  ] Started Collect Read-Ahead Data.
[  OK  ] Started Replay Read-Ahead Data.
         Starting Apply Kernel Variables...
[   10.395081] systemd-journald[589]: Vacuuming done, freed 0 bytes
         Starting File System Check on Root Device...
[  OK  ] Mounted Debug File System.
[  OK  ] Mounted POSIX Message Queue File System.
[  OK  ] Mounted Huge Pages File System.
[  OK  ] Started udev Coldplug all Devices.
[  OK  ] Started Apply Kernel Variables.
         Starting LVM2 metadata daemon...
[  OK  ] Started LVM2 metadata daemon.
[  OK  ] Started Create list of required static device nodes ...current kernel.
         Starting Create static device nodes in /dev...
systemd-fsck[597]: /sbin/fsck.xfs: XFS file system.
[  OK  ] Started File System Check on Root Device.
         Starting Remount Root and Kernel File Systems...
[  OK  ] Started Create static device nodes in /dev.
         Starting udev Kernel Device Manager...
[  OK  ] Started Remount Root and Kernel File Systems.
         Starting Import network configuration from initramfs...
         Starting Configure read-only root support...
         Starting Load/Save Random Seed...
[  OK  ] Reached target Local File Systems (Pre).
[   10.457650] systemd-udevd[609]: starting version 208
[  OK  ] Started udev Kernel Device Manager.
[  OK  ] Started Import network configuration from initramfs.
[  OK  ] Started Load/Save Random Seed.
[  OK  ] Started Configure read-only root support.
[  OK  ] Found device /dev/hvc0.
[   10.687095] Registering IBM pSeries RNG driver
         Starting LVM2 PV scan on device 8:17...
[  OK  ] Started LVM2 PV scan on device 8:17.
         Starting LVM2 PV scan on device 8:3...
[  OK  ] Started Monitoring of LVM2 mirrors, snapshots etc. u...ogress polling.
[  OK  ] Started LVM2 PV scan on device 8:3.
[  OK  ] Found device /dev/mapper/rhel_ltcbrazos2--lp07-swap.
         Activating swap /dev/mapper/rhel_ltcbrazos2--lp07-swap...
[   10.822245] Adding 4194240k swap on /dev/mapper/rhel_ltcbrazos2--lp07-swap.  Priority:-1 extents:1 across:4194240k FS
[  OK  ] Activated swap /dev/mapper/rhel_ltcbrazos2--lp07-swap.
[  OK  ] Reached target Swap.
[  OK  ] Found device VDASD.
         Starting File System Check on /dev/disk/by-uuid/5db3...55e1b851ffc1...
systemd-fsck[1074]: /sbin/fsck.xfs: XFS file system.
[  OK  ] Started File System Check on /dev/disk/by-uuid/5db39...7-55e1b851ffc1.
         Mounting /boot...
[   10.854032] XFS (sda2): Mounting V4 Filesystem
[  *** ] A start job is running for /boot[   20.081762] XFS (sda2): Ending clean mount
[  OK  ] Mounted /boot.
[  OK  ] Reached target Local File Systems.
         Starting Trigger Flushing of Journal to Persistent Storage...
         Starting Create Volatile Files and Directories...
         Starting Security Auditing Service...
         Starting Tell Plymouth To Write Out Runtime Data...
[   20.095524] systemd-journald[589]: Received request to flush runtime journal from PID 1
[  OK  ] Started Trigger Flushing of Journal to Persistent Storage.
[   20.107505] audit: type=1305 audit(1406703185.360:3): audit_pid=1090 old=0 auid=4294967295 ses=4294967295 res=1
[  OK  ] Started Create Volatile Files and Directories.
[  OK  ] Started Tell Plymouth To Write Out Runtime Data.
[  OK  ] Started Security Auditing Service.
         Starting Update UTMP about System Reboot/Shutdown...
[  OK  ] Started Update UTMP about System Reboot/Shutdown.
[  OK  ] Reached target System Initialization.
[  OK  ] Reached target Timers.
[  OK  ] Listening on Avahi mDNS/DNS-SD Stack Activation Socket.
[  OK  ] Listening on D-Bus System Message Bus Socket.
[  OK  ] Reached target Sockets.
[  OK  ] Reached target Paths.
[  OK  ] Reached target Basic System.
         Starting LSB: Start the iprupdate utility...
         Starting Dump dmesg to /var/log/dmesg...

Red Hat Enterprise Linux Server 7.0 (Maipo)
Kernel 3.16.0-rc7-24x7+ on an ppc64

ltcbrazos2-lp07 login: [   61.011764] __sdt_alloc: allocated c000000006fc0000 with cpus: 
[   61.011809] __sdt_alloc: allocated c0000000d2070000 with cpus: 
[   61.011849] __sdt_alloc: allocated c0000000e0260000 with cpus: 
[   61.011884] __sdt_alloc: allocated c0000000e33d0000 with cpus: 
[   61.011926] __sdt_alloc: allocated c0000000e44b0000 with cpus: 
[   61.011961] __sdt_alloc: allocated c0000000dc5b0000 with cpus: 
[   61.012001] __sdt_alloc: allocated c0000000e0be0000 with cpus: 
[   61.012036] __sdt_alloc: allocated c0000000df540000 with cpus: 
[   61.012075] __sdt_alloc: allocated c0000000df6f0000 with cpus: 
[   61.012109] __sdt_alloc: allocated c0000000df590000 with cpus: 
[   61.012160] __sdt_alloc: allocated c0000000dd200000 with cpus: 
[   61.012202] __sdt_alloc: allocated c0000000dfcb0000 with cpus: 
[   61.012248] __sdt_alloc: allocated c0000000dca00000 with cpus: 
[   61.012301] __sdt_alloc: allocated c0000000df7f0000 with cpus: 
[   61.012346] __sdt_alloc: allocated c0000000dc660000 with cpus: 
[   61.012392] __sdt_alloc: allocated c0000000da0c0000 with cpus: 
[   61.012437] __sdt_alloc: allocated c0000000dd420000 with cpus: 
[   61.012482] __sdt_alloc: allocated c0000000e3800000 with cpus: 
[   61.012536] __sdt_alloc: allocated c0000000dec20000 with cpus: 
[   61.012585] __sdt_alloc: allocated c0000000def20000 with cpus: 
[   61.012629] __sdt_alloc: allocated c0000000e4a80000 with cpus: 
[   61.012672] __sdt_alloc: allocated c0000000e2390000 with cpus: 
[   61.012728] __sdt_alloc: allocated c000000007700000 with cpus: 
[   61.012773] __sdt_alloc: allocated c0000000077a0000 with cpus: 
[   61.012822] __sdt_alloc: allocated c0000000e6ef0000 with cpus: 
[   61.012859] __sdt_alloc: allocated c0000000e6f90000 with cpus: 
[   61.012905] __sdt_alloc: allocated c0000000d90c0000 with cpus: 
[   61.012959] __sdt_alloc: allocated c0000000e5980000 with cpus: 
[   61.013010] __sdt_alloc: allocated c0000000d9b10000 with cpus: 
[   61.013054] __sdt_alloc: allocated c0000000d2bd0000 with cpus: 
[   61.013092] __sdt_alloc: allocated c0000000e5fb0000 with cpus: 
[   61.013152] __sdt_alloc: allocated c0000000dab70000 with cpus: 
[   61.013216] __sdt_alloc: allocated c0000000e0fc0000 with cpus: 
[   61.013265] __sdt_alloc: allocated c0000000db9e0000 with cpus: 
[   61.013304] __sdt_alloc: allocated c0000000d9ea0000 with cpus: 
[   61.013354] __sdt_alloc: allocated c0000000de120000 with cpus: 
[   61.013406] __sdt_alloc: allocated c0000000d9e90000 with cpus: 
[   61.013466] __sdt_alloc: allocated c0000000e3620000 with cpus: 
[   61.013510] __sdt_alloc: allocated c0000000e3e80000 with cpus: 
[   61.013547] __sdt_alloc: allocated c0000000ddf40000 with cpus: 
[   61.013606] __sdt_alloc: allocated c0000000dec80000 with cpus: 
[   61.013656] __sdt_alloc: allocated c0000000df5f0000 with cpus: 
[   61.013692] __sdt_alloc: allocated c000000007c90000 with cpus: 
[   61.013725] __sdt_alloc: allocated c0000000e5a90000 with cpus: 
[   61.013760] __sdt_alloc: allocated c0000000e2490000 with cpus: 
[   61.013793] __sdt_alloc: allocated c0000000069d0000 with cpus: 
[   61.013830] __sdt_alloc: allocated c0000000def80000 with cpus: 
[   61.013870] __sdt_alloc: allocated c0000000da570000 with cpus: 
[   61.013911] build_sched_groups: got group c000000006fc0000 with cpus: 
[   61.013916] build_sched_groups: got group c0000000d2070000 with cpus: 
[   61.013920] build_sched_groups: got group c0000000e0260000 with cpus: 
[   61.013925] build_sched_groups: got group c0000000e33d0000 with cpus: 
[   61.013929] build_sched_groups: got group c0000000e44b0000 with cpus: 
[   61.013934] build_sched_groups: got group c0000000dc5b0000 with cpus: 
[   61.013938] build_sched_groups: got group c0000000e0be0000 with cpus: 
[   61.013942] build_sched_groups: got group c0000000df540000 with cpus: 
[   61.013947] build_sched_groups: got group c0000000dd420000 with cpus: 
[   61.014851] build_sched_groups: got group c0000000df6f0000 with cpus: 
[   61.014858] build_sched_groups: got group c0000000df590000 with cpus: 
[   61.014862] build_sched_groups: got group c0000000dd200000 with cpus: 
[   61.014866] build_sched_groups: got group c0000000dfcb0000 with cpus: 
[   61.014871] build_sched_groups: got group c0000000dca00000 with cpus: 
[   61.014876] build_sched_groups: got group c0000000df7f0000 with cpus: 
[   61.014880] build_sched_groups: got group c0000000dc660000 with cpus: 
[   61.014885] build_sched_groups: got group c0000000da0c0000 with cpus: 
[   61.015837] ------------[ cut here ]------------
[   61.015842] WARNING: at ../kernel/sched/core.c:5889
[   61.015845] Modules linked in: sg cfg80211 rfkill ibmveth pseries_rng nx_crypto xfs libcrc32c sd_mod crc_t10dif crct10dif_common ibmvscsi scsi_transport_srp scsi_tgt dm_mirror dm_region_hash dm_log dm_mod
[   61.015874] CPU: 4 PID: 1549 Comm: kworker/4:2 Not tainted 3.16.0-rc7-24x7+ #17
[   61.015886] Workqueue: events .topology_work_fn
[   61.015891] task: c0000000cd900000 ti: c0000000cda80000 task.ti: c0000000cda80000
[   61.015895] NIP: c0000000000d73b8 LR: c0000000000d73f8 CTR: 0000000000000000
[   61.015899] REGS: c0000000cda83570 TRAP: 0700   Not tainted  (3.16.0-rc7-24x7+)
[   61.015903] MSR: 8000000100029032 <SF,EE,ME,IR,DR,RI>  CR: 28484024  XER: 0000000b
[   61.015914] CFAR: c0000000000d7384 SOFTE: 1 
GPR00: c0000000000d73f8 c0000000cda837f0 c000000000eaa7f0 0000000000000800 
GPR04: 0000000000000800 0000000000000800 0000000000000000 c0000000009cf678 
GPR08: c0000000009cf680 0000000000000001 0000000000000010 0000000000000000 
GPR12: 0000000000000000 c00000000ebe1200 0000000000000000 c0000000d9af0018 
GPR16: 0000000000000078 c000000000ef0a68 0000000000000078 c0000000d9af0000 
GPR20: 0000000000000000 0000000000000000 c0000000d9af0000 0000000000000001 
GPR24: c000000000db4402 000000000000000f 0000000000000000 c000000000ef0ae0 
GPR28: c0000000063c5b00 c0000000e3790000 0000000000000000 c000000000ef4f7c 
[   61.015977] NIP [c0000000000d73b8] .build_sched_domains+0xab8/0xdf0
[   61.015982] LR [c0000000000d73f8] .build_sched_domains+0xaf8/0xdf0
[   61.015986] Call Trace:
[   61.015990] [c0000000cda837f0] [c0000000000d73f8] .build_sched_domains+0xaf8/0xdf0 (unreliable)
[   61.015997] [c0000000cda83950] [c0000000000d79b0] .partition_sched_domains+0x260/0x3f0
[   61.016006] [c0000000cda83a30] [c000000000141764] .rebuild_sched_domains_locked+0x54/0x70
[   61.016012] [c0000000cda83ab0] [c000000000143af8] .rebuild_sched_domains+0x28/0x50
[   61.016018] [c0000000cda83b30] [c00000000004f250] .topology_work_fn+0x10/0x30
[   61.016025] [c0000000cda83ba0] [c0000000000b7100] .process_one_work+0x1a0/0x4c0
[   61.016032] [c0000000cda83c40] [c0000000000b7970] .worker_thread+0x180/0x630
[   61.016039] [c0000000cda83d30] [c0000000000bfc88] .kthread+0x108/0x130
[   61.016049] [c0000000cda83e30] [c00000000000a3e4] .ret_from_kernel_thread+0x58/0x74
[   61.016058] Instruction dump:
[   61.016061] 7f47492a e93b0000 e90a0010 7d0a4378 7d4a482a 814a0000 2f8a0000 419e0008 
[   61.016072] 7f48492a ebdd0010 7fc90074 7929d182 <0b090000> 60420000 387e0018 38800800 
[   61.016082] ---[ end trace c7c13ef8e2257429 ]---
[   61.016091] Unable to handle kernel paging request for data at address 0x00000018
[   61.016098] Faulting instruction address: 0xc00000000039d260
[   61.016103] Oops: Kernel access of bad area, sig: 11 [#1]
[   61.016105] SMP NR_CPUS=2048 NUMA pSeries
[   61.016110] Modules linked in: sg cfg80211 rfkill ibmveth pseries_rng nx_crypto xfs libcrc32c sd_mod crc_t10dif crct10dif_common ibmvscsi scsi_transport_srp scsi_tgt dm_mirror dm_region_hash dm_log dm_mod
[   61.016133] CPU: 4 PID: 1549 Comm: kworker/4:2 Tainted: G        W     3.16.0-rc7-24x7+ #17
[   61.016139] Workqueue: events .topology_work_fn
[   61.016146] task: c0000000cd900000 ti: c0000000cda80000 task.ti: c0000000cda80000
[   61.016151] NIP: c00000000039d260 LR: c0000000000d73cc CTR: 0000000000000000
[   61.016156] REGS: c0000000cda834c0 TRAP: 0300   Tainted: G        W      (3.16.0-rc7-24x7+)
[   61.016159] MSR: 8000000100009032 <SF,EE,ME,IR,DR,RI>  CR: 28484024  XER: 0000000b
[   61.016169] CFAR: c000000000009358 DAR: 0000000000000018 DSISR: 40000000 SOFTE: 1 
GPR00: c0000000000d73cc c0000000cda83740 c000000000eaa7f0 0000000000000018 
GPR04: 0000000000000800 0000000000000800 0000000000000000 c0000000009cf678 
GPR08: c0000000009cf680 0000000000000001 0000000000000010 0000000000000000 
GPR12: 0000000000000000 c00000000ebe1200 0000000000000000 c0000000d9af0018 
GPR16: 0000000000000078 c000000000ef0a68 0000000000000078 c0000000d9af0000 
GPR20: 0000000000000000 0000000000000000 c0000000d9af0000 0000000000000001 
GPR24: c000000000db4402 0000000000000020 0000000000000018 0000000000000800 
GPR28: 0000000000000020 0000000000000110 0000000000000000 0000000000000010 
[   61.016233] NIP [c00000000039d260] .__bitmap_weight+0x70/0x100
[   61.016237] LR [c0000000000d73cc] .build_sched_domains+0xacc/0xdf0
[   61.016241] Call Trace:
[   61.016244] [c0000000cda83740] [c0000000cda837f0] 0xc0000000cda837f0 (unreliable)
[   61.016250] [c0000000cda837f0] [c0000000000d73cc] .build_sched_domains+0xacc/0xdf0
[   61.016256] [c0000000cda83950] [c0000000000d79b0] .partition_sched_domains+0x260/0x3f0
[   61.016262] [c0000000cda83a30] [c000000000141764] .rebuild_sched_domains_locked+0x54/0x70
[   61.016268] [c0000000cda83ab0] [c000000000143af8] .rebuild_sched_domains+0x28/0x50
[   61.016274] [c0000000cda83b30] [c00000000004f250] .topology_work_fn+0x10/0x30
[   61.016279] [c0000000cda83ba0] [c0000000000b7100] .process_one_work+0x1a0/0x4c0
[   61.016284] [c0000000cda83c40] [c0000000000b7970] .worker_thread+0x180/0x630
[   61.016289] [c0000000cda83d30] [c0000000000bfc88] .kthread+0x108/0x130
[   61.016295] [c0000000cda83e30] [c00000000000a3e4] .ret_from_kernel_thread+0x58/0x74
[   61.016300] Instruction dump:
[   61.016303] 409d00b4 3bbcffff 3be3fff8 7bbd1f48 3bc00000 7fa3ea14 48000018 60000000 
[   61.016311] 60000000 60000000 60000000 60420000 <e87f0009> 4bcb7449 60000000 7fbfe840 
[   61.016320] ---[ end trace c7c13ef8e225742a ]---
[   61.022697] 
[   63.022747] Kernel panic - not syncing: Fatal exception
[   63.046921] Rebooting in 10 seconds..Connection to hmc-eio.austin.ibm.com closed.
You have mail in /home/suka/Mail/mbox
suka@suka-t410 ~/ 

--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=us-ascii
Content-Description: debug.patch
Content-Disposition: attachment; filename="lkml.debug-patch"

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index bc1638b..fc1eabe 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5842,6 +5842,15 @@ build_sched_groups(struct sched_domain *sd, int cpu)
 			continue;
 
 		group = get_group(i, sdd, &sg);
+
+		if (!cpumask_empty(sched_group_cpus(sg)))
+			printk("%s FAIL\n", __func__);
+
+		printk("%s: got group %p with cpus: %pc\n", __func__, sg,
+				sched_group_cpus(sg));
+
+		cpumask_clear(sched_group_cpus(sg));
+		sg->sgc->capacity = 0;
 		cpumask_setall(sched_group_mask(sg));
 
 		for_each_cpu(j, span) {
@@ -6403,6 +6412,8 @@ static int __sdt_alloc(const struct cpumask *cpu_map)
 			if (!sg)
 				return -ENOMEM;
 
+			printk("%s: allocated %p with cpus: %pc\n", 
+					__func__, sg, sched_group_cpus(sg));
 			sg->next = sg;
 
 			*per_cpu_ptr(sdd->sg, j) = sg;
diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index 6fe2c84..168bea5 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -28,6 +28,7 @@
 #include <linux/ioport.h>
 #include <linux/dcache.h>
 #include <linux/cred.h>
+#include <linux/cpumask.h>
 #include <net/addrconf.h>
 
 #include <asm/page.h>		/* for PAGE_SIZE */
@@ -1389,6 +1390,8 @@ char *pointer(const char *fmt, char *buf, char *end, void *ptr,
 		return dentry_name(buf, end,
 				   ((const struct file *)ptr)->f_path.dentry,
 				   spec, fmt);
+	case 'c':
+		return buf + cpulist_scnprintf(buf, end-buf, ptr);
 	}
 	spec.flags |= SMALL;
 	if (spec.field_width == -1) {

--M9NhX3UHpAaciwkO--

