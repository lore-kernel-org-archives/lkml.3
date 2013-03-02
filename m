Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab3CBTXE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 14:23:04 -0500
Received: from mail-ve0-f179.google.com ([209.85.128.179]:61701 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab3CBTXB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 14:23:01 -0500
MIME-Version: 1.0
Date: Sat, 2 Mar 2013 21:23:00 +0200
Message-ID: <CA+ydwtrRAf5VW_iZYOjzmTv6Y0ebprXw_RfWVmR1okQOxQx=CA@mail.gmail.com>
Subject: cgroup_release_agent() hung task warnings
From: Tommi Rantala <tt.rantala@gmail.com>
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm seeing the following hung task warnings when fuzzing the kernel
with trinity (in a qemu virtual machine, as the root user), that I
have not seen before with 3.8 or earlier. The kernel is
b0af9cd9aab60ceb17d3ebabb9fdf4ff0a99cf50 (Merge tag
'lzo-update-signature-20130226' of
git://github.com/markus-oberhumer/linux).


Case 1:

# ./trinity -q -l off -C20 --dangerous -c ioctl -V /dev
Trinity v1.1  Dave Jones <davej@redhat.com>
[2357] Marking 64-bit syscall 16 (ioctl) as enabled
[2357] Marking 32-bit syscall 54 (ioctl) as enabled
Enabling syscall ioctl
DANGER: RUNNING AS ROOT.
Unless you are running in a virtual machine, this could cause serious
problems such as overwriting CMOS
or similar which could potentially make this machine unbootable
without a firmware reset.

ctrl-c now unless you really know what you are doing.
Initial random seed from time of day: 4168443421
[2358] Watchdog is alive
[2357] Started watchdog process, PID is 2358
[2359] Main thread is alive.
Generating file descriptors
Added 79 filenames from /dev
[2359] Random reseed: 1227042961
[   26.657193] vmalloc: allocation failure: 2348897621 bytes
[   26.658473] trinity-child2: page allocation failure: order:0, mode:0x430
[   26.659752] Pid: 2379, comm: trinity-child2 Not tainted 3.8.0+ #93
[   26.660913] Call Trace:
[   26.661402]  [<ffffffff811591b0>] warn_alloc_failed+0x110/0x140
[   26.662568]  [<ffffffff816a31be>] ? copy_params+0x9e/0x1b0
[   26.663605]  [<ffffffff8118a059>] __vmalloc_node_range+0x249/0x270
[   26.664752]  [<ffffffff816a19e0>] ? __dev_status+0x120/0x120
[   26.665799]  [<ffffffff8118a0b0>] __vmalloc_node+0x30/0x40
[   26.666921]  [<ffffffff816a31be>] ? copy_params+0x9e/0x1b0
[   26.668022]  [<ffffffff8118a0dd>] __vmalloc+0x1d/0x20
[   26.668947]  [<ffffffff816a31be>] copy_params+0x9e/0x1b0
[   26.669991]  [<ffffffff810f3548>] ? trace_hardirqs_off_caller+0x28/0xd0
[   26.671214]  [<ffffffff816a19e0>] ? __dev_status+0x120/0x120
[   26.672324]  [<ffffffff816a3410>] ctl_ioctl+0x140/0x250
[   26.673357]  [<ffffffff816a352e>] dm_ctl_ioctl+0xe/0x20
[   26.674392]  [<ffffffff811b9542>] do_vfs_ioctl+0x532/0x580
[   26.675406]  [<ffffffff81306ce3>] ? file_has_perm+0x83/0xa0
[   26.676428]  [<ffffffff811b95ed>] sys_ioctl+0x5d/0xa0
[   26.677431]  [<ffffffff81362c9e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   26.678671]  [<ffffffff81cdcea9>] system_call_fastpath+0x16/0x1b
[   26.679855] Mem-Info:
[   26.680305] Node 0 DMA per-cpu:
[   26.680970] CPU    0: hi:    0, btch:   1 usd:   0
[   26.681874] Node 0 DMA32 per-cpu:
[   26.682523] CPU    0: hi:  186, btch:  31 usd:  76
[   26.683481] active_anon:4346 inactive_anon:736 isolated_anon:0
[   26.683481]  active_file:1737 inactive_file:6374 isolated_file:0
[   26.683481]  unevictable:0 dirty:96 writeback:0 unstable:0
[   26.683481]  free:473192 slab_reclaimable:2697 slab_unreclaimable:9949
[   26.683481]  mapped:3777 shmem:747 pagetables:346 bounce:0
[   26.683481]  free_cma:0
[   26.689665] Node 0 DMA free:15904kB min:352kB low:440kB high:528kB
active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15992kB
managed:15908kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB
shmem:0kB slab_reclaimable:0kB slab_unreclaimable:4kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? no
[   26.696774] lowmem_reserve[]: 0 1958 1958 1958
[   26.697709] Node 0 DMA32 free:1876864kB min:44700kB low:55872kB
high:67048kB active_anon:17384kB inactive_anon:2944kB
active_file:6948kB inactive_file:25496kB unevictable:0kB
isolated(anon):0kB isolated(file):0kB present:2080760kB
managed:2005844kB mlocked:0kB dirty:384kB writeback:0kB mapped:15108kB
shmem:2988kB slab_reclaimable:10788kB slab_unreclaimable:39792kB
kernel_stack:760kB pagetables:1384kB unstable:0kB bounce:0kB
free_cma:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
[   26.705494] lowmem_reserve[]: 0 0 0 0
[   26.706391] Node 0 DMA: 0*4kB 0*8kB 0*16kB 1*32kB (U) 2*64kB (U)
1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 1*2048kB (R) 3*4096kB (M)
= 15904kB
[   26.710256] Node 0 DMA32: 2*4kB (UE) 1*8kB (M) 1*16kB (M) 1*32kB
(E) 3*64kB (UEM) 1*128kB (U) 2*256kB (UE) 0*512kB 2*1024kB (UE)
1*2048kB (U) 457*4096kB (MR) = 1876864kB
[   26.714900] 8857 total pagecache pages
[   26.722071] 524285 pages RAM
[   26.722885] 17748 pages reserved
[   26.723748] 282120 pages shared
[   26.724562] 23832 pages non-shared
[   26.797417] program trinity-child6 is using a deprecated SCSI
ioctl, please convert it to SG_IO
[   27.170430] device-mapper: ioctl: Unable to rename non-existent device,  to ▒
[watchdog] 4164 iterations. [F:3982 S:181]
[   28.706283] trinity-child17 invoked oom-killer: gfp_mask=0x280da,
order=0, oom_score_adj=0
[   28.708366] trinity-child17 cpuset=/ mems_allowed=0
[   28.709412] Pid: 2398, comm: trinity-child17 Not tainted 3.8.0+ #93
[   28.710799] Call Trace:
[   28.711283]  [<ffffffff81cc743a>] dump_header.isra.6+0x74/0x229
[   28.712388]  [<ffffffff810f3475>] ? trace_hardirqs_on_caller+0x155/0x1f0
[   28.713759]  [<ffffffff810f351d>] ? trace_hardirqs_on+0xd/0x10
[   28.714956]  [<ffffffff8135b9bc>] ? ___ratelimit+0x10c/0x150
[   28.716028]  [<ffffffff81157274>] oom_kill_process+0x84/0x360
[   28.717213]  [<ffffffff81157d36>] out_of_memory+0x5d6/0x660
[   28.718261]  [<ffffffff8115ccbd>] __alloc_pages_nodemask+0x6ed/0x950
[   28.719501]  [<ffffffff81060339>] ? sched_clock+0x9/0x10
[   28.720513]  [<ffffffff81192adf>] alloc_pages_vma+0xef/0x160
[   28.721633]  [<ffffffff8117acd5>] handle_pte_fault+0x185/0x460
[   28.722843]  [<ffffffff81089954>] ? __do_page_fault+0x1d4/0x4d0
[   28.724180]  [<ffffffff8117b945>] handle_mm_fault+0x2b5/0x2e0
[   28.725324]  [<ffffffff81089bf8>] __do_page_fault+0x478/0x4d0
[   28.726492]  [<ffffffff81cdb99b>] ? _raw_spin_unlock_irq+0x2b/0x40
[   28.727770]  [<ffffffff810f3475>] ? trace_hardirqs_on_caller+0x155/0x1f0
[   28.729062]  [<ffffffff810f351d>] ? trace_hardirqs_on+0xd/0x10
[   28.730212]  [<ffffffff81cdb99b>] ? _raw_spin_unlock_irq+0x2b/0x40
[   28.731418]  [<ffffffff810cbb00>] ? finish_task_switch+0x80/0x120
[   28.732554]  [<ffffffff810cbac3>] ? finish_task_switch+0x43/0x120
[   28.733764]  [<ffffffff81362cdd>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   28.735068]  [<ffffffff81089c79>] do_page_fault+0x9/0x10
[   28.736050]  [<ffffffff81083a3c>] do_async_page_fault+0x4c/0xa0
[   28.737250]  [<ffffffff81cdc878>] async_page_fault+0x28/0x30
[   28.738302] Mem-Info:
[   28.738803] Node 0 DMA per-cpu:
[   28.739648] CPU    0: hi:    0, btch:   1 usd:   0
[   28.740706] Node 0 DMA32 per-cpu:
[   28.741406] CPU    0: hi:  186, btch:  31 usd:  30
[   28.742288] active_anon:24323 inactive_anon:735 isolated_anon:0
[   28.742288]  active_file:0 inactive_file:7 isolated_file:0
[   28.742288]  unevictable:0 dirty:17 writeback:0 unstable:0
[   28.742288]  free:7576 slab_reclaimable:2150 slab_unreclaimable:11082
[   28.742288]  mapped:682 shmem:753 pagetables:563 bounce:0
[   28.742288]  free_cma:0
[   28.748217] Node 0 DMA free:8008kB min:352kB low:440kB high:528kB
active_anon:108kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15992kB
managed:15908kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB
shmem:0kB slab_reclaimable:0kB slab_unreclaimable:4kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? yes
[   28.755739] lowmem_reserve[]: 0 1958 1958 1958
[   28.756772] Node 0 DMA32 free:22296kB min:44700kB low:55872kB
high:67048kB active_anon:97184kB inactive_anon:2940kB active_file:0kB
inactive_file:28kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:2080760kB managed:2005844kB mlocked:0kB
dirty:68kB writeback:0kB mapped:2728kB shmem:3012kB
slab_reclaimable:8600kB slab_unreclaimable:44324kB kernel_stack:920kB
pagetables:2252kB unstable:0kB bounce:0kB free_cma:0kB
writeback_tmp:0kB pages_scanned:49 all_unreclaimable? yes
[   28.767079] lowmem_reserve[]: 0 0 0 0
[   28.768173] Node 0 DMA: 2*4kB (UM) 2*8kB (UM) 1*16kB (U) 1*32kB (U)
0*64kB 2*128kB (UM) 2*256kB (UM) 2*512kB (UM) 2*1024kB (UM) 2*2048kB
(MR) 0*4096kB = 8008kB
[   28.772815] Node 0 DMA32: 336*4kB (EM) 245*8kB (UEM) 181*16kB (EM)
87*32kB (EM) 62*64kB (UEM) 25*128kB (UEM) 4*256kB (EM) 2*512kB (UE)
0*1024kB 0*2048kB 1*4096kB (R) = 22296kB
[   28.777490] 785 total pagecache pages
[   28.784217] 524285 pages RAM
[   28.785062] 17748 pages reserved
[   28.786188] 283440 pages shared
[   28.787027] 494193 pages non-shared
[   28.787930] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents
oom_score_adj name
[   28.789933] [ 1419]     0  1419     7374      110      18        0
       -1000 systemd-udevd
[   28.792103] [ 1422]     0  1422    70187       98      91        0
           0 systemd-journal
[   28.794316] [ 1545]     0  1545     6523       65      19        0
           0 systemd-logind
[   28.796517] [ 1547]    81  1547     4843       64      15        0
        -900 dbus-daemon
[   28.798667] [ 1559]     0  1559     1585       31       9        0
           0 agetty
[   28.800699] [ 1593]     0  1593     2198       93      10        0
           0 dhcpcd
[   28.802851] [ 1898]     0  1898    15754      114      37        0
           0 login
[   28.804764] [ 2349]     0  2349     3503      104      12        0
           0 bash
[   28.806658] [ 2354]     0  2354     2944       60      11        0
           0 run-ioctl
[   28.808704] [ 2357]     0  2357     4453     1212      11        0
           0 trinity
[   28.810763] [ 2358]     0  2358     4453      546      10        0
           0 trinity-watchdo
[   28.813071] [ 2359]     0  2359     4484      555      10        0
           0 trinity-main
[   28.815273] [ 2362]     0  2362     7373      113      17        0
           0 systemd-udevd
[   28.817726] [ 2377]     0  2377     6930     2151      15        0
           0 trinity-child0
[   28.819933] [ 2378]     0  2378     6658     2011      14        0
           0 trinity-child1
[   28.822114] [ 2379]     0  2379     6081     1725      13        0
           0 trinity-child2
[   28.824306] [ 2380]     0  2380     5505     1431      12        0
           0 trinity-child3
[   28.826497] [ 2382]     0  2382     4995     1180      11        0
           0 trinity-child4
[   28.828675] [ 2383]     0  2383    11649     4505      24        0
           0 trinity-child5
[   28.830849] [ 2384]     0  2384     7167     2267      15        0
           0 trinity-child6
[   28.833288] [ 2385]     0  2385    10461     3909      22        0
           0 trinity-child7
[   28.835475] [ 2386]     0  2386    11920     4647      25        0
           0 trinity-child8
[   28.837670] [ 2387]     0  2387     8898     3134      19        0
           0 trinity-child9
[   28.839295] [ 2388]     0  2388     6047     1705      13        0
           0 trinity-child10
[   28.841050] [ 2389]     0  2389     5708     1534      12        0
           0 trinity-child11
[   28.842785] [ 2392]     0  2392     7133     2253      15        0
           0 trinity-child12
[   28.844417] [ 2393]     0  2393     5572     1466      12        0
           0 trinity-child13
[   28.846091] [ 2394]     0  2394     5335     1351      12        0
           0 trinity-child14
[   28.847692] [ 2396]     0  2396     4518      940      10        0
           0 trinity-child15
[   28.849685] [ 2397]     0  2397     4484      838      10        0
           0 trinity-child16
[   28.851294] [ 2398]     0  2398     6115     1744      13        0
           0 trinity-child17
[   28.852907] [ 2399]     0  2399     4722     1048      10        0
           0 trinity-child18
[   28.854453] Out of memory: Kill process 1545 (systemd-logind) score
0 or sacrifice child
[   28.855984] Killed process 1545 (systemd-logind) total-vm:26092kB,
anon-rss:256kB, file-rss:4kB
[   30.482654] trinity-child15 invoked oom-killer: gfp_mask=0x201da,
order=0, oom_score_adj=0
[   30.484224] trinity-child15 cpuset=/ mems_allowed=0
[   30.485298] Pid: 2396, comm: trinity-child15 Not tainted 3.8.0+ #93
[   30.486575] Call Trace:
[   30.487241]  [<ffffffff81cc743a>] dump_header.isra.6+0x74/0x229
[   30.488297]  [<ffffffff810f3475>] ? trace_hardirqs_on_caller+0x155/0x1f0
[   30.489922]  [<ffffffff810f351d>] ? trace_hardirqs_on+0xd/0x10
[   30.491072]  [<ffffffff8135b9bc>] ? ___ratelimit+0x10c/0x150
[   30.492085]  [<ffffffff81157274>] oom_kill_process+0x84/0x360
[   30.493225]  [<ffffffff81157d36>] out_of_memory+0x5d6/0x660
[   30.494224]  [<ffffffff8115ccbd>] __alloc_pages_nodemask+0x6ed/0x950
[   30.495456]  [<ffffffff81192cd4>] alloc_pages_current+0x124/0x150
[   30.496655]  [<ffffffff811532d7>] __page_cache_alloc+0xa7/0xc0
[   30.498210]  [<ffffffff811539e0>] ? __lock_page_or_retry+0xc0/0xc0
[   30.499805]  [<ffffffff8115403d>] filemap_fault+0x2ed/0x460
[   30.501265]  [<ffffffff81177e6f>] __do_fault+0xbf/0x420
[   30.502717]  [<ffffffff8117ae0a>] handle_pte_fault+0x2ba/0x460
[   30.504242]  [<ffffffff81089954>] ? __do_page_fault+0x1d4/0x4d0
[   30.505962]  [<ffffffff8117b945>] handle_mm_fault+0x2b5/0x2e0
[   30.507405]  [<ffffffff81089bf8>] __do_page_fault+0x478/0x4d0
[   30.508911]  [<ffffffff811b9542>] ? do_vfs_ioctl+0x532/0x580
[   30.510345]  [<ffffffff81306ce3>] ? file_has_perm+0x83/0xa0
[   30.511804]  [<ffffffff81362cdd>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   30.513443]  [<ffffffff81089c79>] do_page_fault+0x9/0x10
[   30.514907]  [<ffffffff81083a3c>] do_async_page_fault+0x4c/0xa0
[   30.516469]  [<ffffffff81cdc878>] async_page_fault+0x28/0x30
[   30.517950] Mem-Info:
[   30.518557] Node 0 DMA per-cpu:
[   30.519442] CPU    0: hi:    0, btch:   1 usd:   0
[   30.520890] Node 0 DMA32 per-cpu:
[   30.521790] CPU    0: hi:  186, btch:  31 usd:   1
[   30.523065] active_anon:24268 inactive_anon:735 isolated_anon:0
[   30.523065]  active_file:11 inactive_file:20 isolated_file:0
[   30.523065]  unevictable:0 dirty:17 writeback:0 unstable:0
[   30.523065]  free:7590 slab_reclaimable:2046 slab_unreclaimable:11016
[   30.523065]  mapped:682 shmem:753 pagetables:547 bounce:0
[   30.523065]  free_cma:0
[   30.528934] Node 0 DMA free:8008kB min:352kB low:440kB high:528kB
active_anon:108kB inactive_anon:0kB active_file:0kB inactive_file:0kB
unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15992kB
managed:15908kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB
shmem:0kB slab_reclaimable:0kB slab_unreclaimable:4kB kernel_stack:0kB
pagetables:0kB unstable:0kB bounce:0kB free_cma:0kB writeback_tmp:0kB
pages_scanned:0 all_unreclaimable? yes
[   30.537922] lowmem_reserve[]: 0 1958 1958 1958
[   30.539308] Node 0 DMA32 free:22352kB min:44700kB low:55872kB
high:67048kB active_anon:96964kB inactive_anon:2940kB active_file:44kB
inactive_file:80kB unevictable:0kB isolated(anon):0kB
isolated(file):0kB present:2080760kB managed:2005844kB mlocked:0kB
dirty:68kB writeback:0kB mapped:2728kB shmem:3012kB
slab_reclaimable:8184kB slab_unreclaimable:44060kB kernel_stack:920kB
pagetables:2188kB unstable:0kB bounce:0kB free_cma:0kB
writeback_tmp:0kB pages_scanned:15654 all_unreclaimable? yes
[   30.549952] lowmem_reserve[]: 0 0 0 0
[   30.551092] Node 0 DMA: 2*4kB (UM) 2*8kB (UM) 1*16kB (U) 1*32kB (U)
0*64kB 2*128kB (UM) 2*256kB (UM) 2*512kB (UM) 2*1024kB (UM) 2*2048kB
(MR) 0*4096kB = 8008kB
[   30.555765] Node 0 DMA32: 328*4kB (UEM) 240*8kB (UEM) 183*16kB
(UEM) 91*32kB (UEM) 64*64kB (EM) 24*128kB (UEM) 6*256kB (UEM) 1*512kB
(E) 0*1024kB 0*2048kB 1*4096kB (R) = 22384kB
[   30.559529] 785 total pagecache pages
[   30.564898] 524285 pages RAM
[   30.565565] 17748 pages reserved
[   30.566189] 283440 pages shared
[   30.566774] 494200 pages non-shared
[   30.567634] [ pid ]   uid  tgid total_vm      rss nr_ptes swapents
oom_score_adj name
[   30.569095] [ 1419]     0  1419     7374      110      18        0
       -1000 systemd-udevd
[   30.570707] [ 1422]     0  1422    70187       98      91        0
           0 systemd-journal
[   30.572333] [ 1547]    81  1547     4843       64      15        0
        -900 dbus-daemon
[   30.573888] [ 1559]     0  1559     1585       31       9        0
           0 agetty
[   30.575637] [ 1593]     0  1593     2198       93      10        0
           0 dhcpcd
[   30.577523] [ 1898]     0  1898    15754      114      37        0
           0 login
[   30.579208] [ 2349]     0  2349     3503      104      12        0
           0 bash
[   30.580714] [ 2354]     0  2354     2944       60      11        0
           0 run-ioctl
[   30.582314] [ 2357]     0  2357     4453     1212      11        0
           0 trinity
[   30.584212] [ 2358]     0  2358     4453      546      10        0
           0 trinity-watchdo
[   30.585925] [ 2359]     0  2359     4484      555      10        0
           0 trinity-main
[   30.587637] [ 2362]     0  2362     7373      113      17        0
           0 systemd-udevd
[   30.589304] [ 2377]     0  2377     6930     2151      15        0
           0 trinity-child0
[   30.591024] [ 2378]     0  2378     6658     2011      14        0
           0 trinity-child1
[   30.592740] [ 2379]     0  2379     6081     1725      13        0
           0 trinity-child2
[   30.594451] [ 2380]     0  2380     5505     1431      12        0
           0 trinity-child3
[   30.596168] [ 2382]     0  2382     4995     1180      11        0
           0 trinity-child4
[   30.597888] [ 2383]     0  2383    11649     4505      24        0
           0 trinity-child5
[   30.599768] [ 2384]     0  2384     7167     2267      15        0
           0 trinity-child6
[   30.601390] [ 2385]     0  2385    10461     3909      22        0
           0 trinity-child7
[   30.603105] [ 2386]     0  2386    11920     4647      25        0
           0 trinity-child8
[   30.604815] [ 2387]     0  2387     8898     3134      19        0
           0 trinity-child9
[   30.606525] [ 2388]     0  2388     6047     1705      13        0
           0 trinity-child10
[   30.608268] [ 2389]     0  2389     5708     1534      12        0
           0 trinity-child11
[   30.610004] [ 2392]     0  2392     7133     2253      15        0
           0 trinity-child12
[   30.611719] [ 2393]     0  2393     5572     1466      12        0
           0 trinity-child13
[   30.613352] [ 2394]     0  2394     5335     1351      12        0
           0 trinity-child14
[   30.615251] [ 2396]     0  2396     4518      940      10        0
           0 trinity-child15
[   30.617320] [ 2397]     0  2397     4484      838      10        0
           0 trinity-child16
[   30.619522] [ 2398]     0  2398     6115     1744      13        0
           0 trinity-child17
[   30.621754] [ 2399]     0  2399     4722     1048      10        0
           0 trinity-child18
[   30.623670] Out of memory: Kill process 1422 (systemd-journal)
score 0 or sacrifice child
[   30.625743] Killed process 1422 (systemd-journal)
total-vm:280748kB, anon-rss:288kB, file-rss:104kB
[  120.594088] INFO: task kworker/0:2:1079 blocked for more than 60 seconds.
[  120.595877] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  120.598100] kworker/0:2     D ffff88007c518618     0  1079      2 0x00000000
[  120.599958]  ffff88007adc9a38 0000000000000046 ffff88007b0b0000
ffff88007adc9fd8
[  120.601982]  ffff88007adc9fd8 ffff88007adc9fd8 ffff88007c518000
ffff88007b0b0000
[  120.603994]  ffff88007adc9a18 ffff88007adc9b88 ffff88007adc9b90
7fffffffffffffff
[  120.606003] Call Trace:
[  120.606684]  [<ffffffff81cd9d95>] schedule+0x55/0x60
[  120.607973]  [<ffffffff81cd7786>] schedule_timeout+0x36/0x240
[  120.609460]  [<ffffffff810f3303>] ? mark_held_locks+0x123/0x140
[  120.610932]  [<ffffffff81cdb99b>] ? _raw_spin_unlock_irq+0x2b/0x40
[  120.612521]  [<ffffffff810f3475>] ? trace_hardirqs_on_caller+0x155/0x1f0
[  120.614471]  [<ffffffff810f351d>] ? trace_hardirqs_on+0xd/0x10
[  120.615957]  [<ffffffff81cda037>] wait_for_completion+0x97/0x100
[  120.617495]  [<ffffffff810d2310>] ? try_to_wake_up+0x340/0x340
[  120.619013]  [<ffffffff810b615c>] call_usermodehelper_exec+0x14c/0x210
[  120.620613]  [<ffffffff81cd9fcc>] ? wait_for_completion+0x2c/0x100
[  120.622187]  [<ffffffff810b6948>] call_usermodehelper_fns+0xe8/0x100
[  120.623821]  [<ffffffff8110921a>] cgroup_release_agent+0x15a/0x180
[  120.625374]  [<ffffffff810b85cb>] process_one_work+0x29b/0x4c0
[  120.626861]  [<ffffffff810b8560>] ? process_one_work+0x230/0x4c0
[  120.628407]  [<ffffffff810b8da8>] worker_thread+0x248/0x380
[  120.630183]  [<ffffffff810b8b60>] ? busy_worker_rebind_fn+0xb0/0xb0
[  120.631761]  [<ffffffff810bfd71>] kthread+0xd1/0xe0
[  120.633019]  [<ffffffff810f351d>] ? trace_hardirqs_on+0xd/0x10
[  120.634479]  [<ffffffff810bfca0>] ? __kthread_bind+0x40/0x40
[  120.635898]  [<ffffffff81cdcdfc>] ret_from_fork+0x7c/0xb0
[  120.637254]  [<ffffffff810bfca0>] ? __kthread_bind+0x40/0x40
[  120.638644] 2 locks held by kworker/0:2/1079:
[  120.639724]  #0:  (events){.+.+.+}, at: [<ffffffff810b8560>]
process_one_work+0x230/0x4c0
[  120.641941]  #1:  (release_agent_work){+.+.+.}, at:
[<ffffffff810b8560>] process_one_work+0x230/0x4c0
[  120.644457] INFO: task systemd-journal:1422 blocked for more than 60 seconds.
[  120.646439] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  120.648380] systemd-journal D ffff88007bbb2748     0  1422      1 0x00100006
[  120.650270]  ffff8800794f5aa8 0000000000000046 ffff880079500000
ffff8800794f5fd8
[  120.652320]  ffff8800794f5fd8 ffff8800794f5fd8 ffff880078c3a290
ffff880079500000
[  120.654333]  ffff88007bbb2750 ffff880079500000 ffff88007bbb2750
0000000000000002
[  120.656377] Call Trace:
[  120.657025]  [<ffffffff81cd9d95>] schedule+0x55/0x60
[  120.658299]  [<ffffffff81cdb59d>] rwsem_down_failed_common+0x1fd/0x240
[  120.659948]  [<ffffffff81cdb613>] rwsem_down_write_failed+0x13/0x15
[  120.661779]  [<ffffffff81362c03>] call_rwsem_down_write_failed+0x13/0x20
[  120.663429]  [<ffffffff81cd9131>] ? down_write+0x91/0x93
[  120.664743]  [<ffffffff81227fe3>] ? ext4_release_file+0x63/0xc0
[  120.666205]  [<ffffffff810c875e>] ? lg_local_unlock+0x1e/0x40
[  120.667625]  [<ffffffff811bd6cd>] ? dput+0x12d/0x1b0
[  120.668895]  [<ffffffff81227fe3>] ext4_release_file+0x63/0xc0
[  120.670382]  [<ffffffff811a807a>] __fput+0x11a/0x210
[  120.671645]  [<ffffffff811a8179>] ____fput+0x9/0x10
[  120.672932]  [<ffffffff810bcbde>] task_work_run+0x9e/0xc0
[  120.674365]  [<ffffffff8109d86c>] do_exit+0x3ac/0xad0
[  120.675688]  [<ffffffff810f35fd>] ? trace_hardirqs_off+0xd/0x10
[  120.677459]  [<ffffffff810d4dda>] ? local_clock+0x4a/0x70
[  120.678833]  [<ffffffff81cdb99b>] ? _raw_spin_unlock_irq+0x2b/0x40
[  120.680410]  [<ffffffff8109e054>] do_group_exit+0x84/0xd0
[  120.681761]  [<ffffffff810b0289>] get_signal_to_deliver+0x739/0x810
[  120.683365]  [<ffffffff81178b9b>] ? __pte_alloc+0x9b/0x150
[  120.684755]  [<ffffffff810583b2>] do_signal+0x52/0x570
[  120.686065]  [<ffffffff810f35fd>] ? trace_hardirqs_off+0xd/0x10
[  120.687580]  [<ffffffff810d4dda>] ? local_clock+0x4a/0x70
[  120.688957]  [<ffffffff810f17f8>] ? lock_release_holdtime+0x28/0x170
[  120.690561]  [<ffffffff81cdc5ff>] ? retint_signal+0x11/0x92
[  120.692192]  [<ffffffff810588f7>] do_notify_resume+0x27/0x70
[  120.693624]  [<ffffffff81362c9e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  120.695253]  [<ffffffff81cdc63b>] retint_signal+0x4d/0x92
[  120.696621] 1 lock held by systemd-journal/1422:
[  120.697799]  #0:  (&ei->i_data_sem){++++..}, at:
[<ffffffff81227fe3>] ext4_release_file+0x63/0xc0
[  180.700091] INFO: task kworker/0:2:1079 blocked for more than 60 seconds.
[  180.701842] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  180.703814] kworker/0:2     D ffff88007c518618     0  1079      2 0x00000000
[  180.705692]  ffff88007adc9a38 0000000000000046 ffff88007b0b0000
ffff88007adc9fd8
[  180.707998]  ffff88007adc9fd8 ffff88007adc9fd8 ffff88007c518000
ffff88007b0b0000
[  180.710058]  ffff88007adc9a18 ffff88007adc9b88 ffff88007adc9b90
7fffffffffffffff
[  180.712122] Call Trace:
[  180.712759]  [<ffffffff81cd9d95>] schedule+0x55/0x60
[  180.714027]  [<ffffffff81cd7786>] schedule_timeout+0x36/0x240
[  180.715487]  [<ffffffff810f3303>] ? mark_held_locks+0x123/0x140
[  180.716985]  [<ffffffff81cdb99b>] ? _raw_spin_unlock_irq+0x2b/0x40
[  180.718543]  [<ffffffff810f3475>] ? trace_hardirqs_on_caller+0x155/0x1f0
[  180.720290]  [<ffffffff810f351d>] ? trace_hardirqs_on+0xd/0x10
[  180.721770]  [<ffffffff81cda037>] wait_for_completion+0x97/0x100
[  180.723550]  [<ffffffff810d2310>] ? try_to_wake_up+0x340/0x340
[  180.725031]  [<ffffffff810b615c>] call_usermodehelper_exec+0x14c/0x210
[  180.726657]  [<ffffffff81cd9fcc>] ? wait_for_completion+0x2c/0x100
[  180.728224]  [<ffffffff810b6948>] call_usermodehelper_fns+0xe8/0x100
[  180.729821]  [<ffffffff8110921a>] cgroup_release_agent+0x15a/0x180
[  180.731382]  [<ffffffff810b85cb>] process_one_work+0x29b/0x4c0
[  180.732880]  [<ffffffff810b8560>] ? process_one_work+0x230/0x4c0
[  180.734396]  [<ffffffff810b8da8>] worker_thread+0x248/0x380
[  180.735808]  [<ffffffff810b8b60>] ? busy_worker_rebind_fn+0xb0/0xb0
[  180.737393]  [<ffffffff810bfd71>] kthread+0xd1/0xe0
[  180.738904]  [<ffffffff810f351d>] ? trace_hardirqs_on+0xd/0x10
[  180.740385]  [<ffffffff810bfca0>] ? __kthread_bind+0x40/0x40
[  180.741810]  [<ffffffff81cdcdfc>] ret_from_fork+0x7c/0xb0
[  180.743190]  [<ffffffff810bfca0>] ? __kthread_bind+0x40/0x40
[  180.744619] 2 locks held by kworker/0:2/1079:
[  180.745729]  #0:  (events){.+.+.+}, at: [<ffffffff810b8560>]
process_one_work+0x230/0x4c0
[  180.747973]  #1:  (release_agent_work){+.+.+.}, at:
[<ffffffff810b8560>] process_one_work+0x230/0x4c0
[  180.750502] INFO: task systemd-journal:1422 blocked for more than 60 seconds.
[  180.752294] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  180.754506] systemd-journal D ffff88007bbb2748     0  1422      1 0x00100006
[  180.756410]  ffff8800794f5aa8 0000000000000046 ffff880079500000
ffff8800794f5fd8
[  180.758441]  ffff8800794f5fd8 ffff8800794f5fd8 ffff880078c3a290
ffff880079500000
[  180.760469]  ffff88007bbb2750 ffff880079500000 ffff88007bbb2750
0000000000000002
[  180.762520] Call Trace:
[  180.763172]  [<ffffffff81cd9d95>] schedule+0x55/0x60
[  180.764430]  [<ffffffff81cdb59d>] rwsem_down_failed_common+0x1fd/0x240
[  180.766070]  [<ffffffff81cdb613>] rwsem_down_write_failed+0x13/0x15
[  180.767630]  [<ffffffff81362c03>] call_rwsem_down_write_failed+0x13/0x20
[  180.769485]  [<ffffffff81cd9131>] ? down_write+0x91/0x93
[  180.770835]  [<ffffffff81227fe3>] ? ext4_release_file+0x63/0xc0
[  180.772337]  [<ffffffff810c875e>] ? lg_local_unlock+0x1e/0x40
[  180.773785]  [<ffffffff811bd6cd>] ? dput+0x12d/0x1b0
[  180.775057]  [<ffffffff81227fe3>] ext4_release_file+0x63/0xc0
[  180.776503]  [<ffffffff811a807a>] __fput+0x11a/0x210
[  180.777809]  [<ffffffff811a8179>] ____fput+0x9/0x10
[  180.779060]  [<ffffffff810bcbde>] task_work_run+0x9e/0xc0
[  180.780436]  [<ffffffff8109d86c>] do_exit+0x3ac/0xad0
[  180.781726]  [<ffffffff810f35fd>] ? trace_hardirqs_off+0xd/0x10
[  180.783201]  [<ffffffff810d4dda>] ? local_clock+0x4a/0x70
[  180.784567]  [<ffffffff81cdb99b>] ? _raw_spin_unlock_irq+0x2b/0x40
[  180.786340]  [<ffffffff8109e054>] do_group_exit+0x84/0xd0
[  180.787705]  [<ffffffff810b0289>] get_signal_to_deliver+0x739/0x810
[  180.789293]  [<ffffffff81178b9b>] ? __pte_alloc+0x9b/0x150
[  180.790682]  [<ffffffff810583b2>] do_signal+0x52/0x570
[  180.792001]  [<ffffffff810f35fd>] ? trace_hardirqs_off+0xd/0x10
[  180.793491]  [<ffffffff810d4dda>] ? local_clock+0x4a/0x70
[  180.794845]  [<ffffffff810f17f8>] ? lock_release_holdtime+0x28/0x170
[  180.796438]  [<ffffffff81cdc5ff>] ? retint_signal+0x11/0x92
[  180.797855]  [<ffffffff810588f7>] do_notify_resume+0x27/0x70
[  180.799290]  [<ffffffff81362c9e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  180.801140]  [<ffffffff81cdc63b>] retint_signal+0x4d/0x92
[  180.802522] 1 lock held by systemd-journal/1422:
[  180.803703]  #0:  (&ei->i_data_sem){++++..}, at:
[<ffffffff81227fe3>] ext4_release_file+0x63/0xc0
[  240.806088] INFO: task kworker/0:2:1079 blocked for more than 60 seconds.
[  240.807918] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  240.809894] kworker/0:2     D ffff88007c518618     0  1079      2 0x00000000
[  240.811759]  ffff88007adc9a38 0000000000000046 ffff88007b0b0000
ffff88007adc9fd8
[  240.813832]  ffff88007adc9fd8 ffff88007adc9fd8 ffff88007c518000
ffff88007b0b0000
[  240.815853]  ffff88007adc9a18 ffff88007adc9b88 ffff88007adc9b90
7fffffffffffffff
[  240.818114] Call Trace:
[  240.818740]  [<ffffffff81cd9d95>] schedule+0x55/0x60
[  240.820013]  [<ffffffff81cd7786>] schedule_timeout+0x36/0x240
[  240.821483]  [<ffffffff810f3303>] ? mark_held_locks+0x123/0x140
[  240.823026]  [<ffffffff81cdb99b>] ? _raw_spin_unlock_irq+0x2b/0x40
[  240.824596]  [<ffffffff810f3475>] ? trace_hardirqs_on_caller+0x155/0x1f0
[  240.826612]  [<ffffffff810f351d>] ? trace_hardirqs_on+0xd/0x10
[  240.828104]  [<ffffffff81cda037>] wait_for_completion+0x97/0x100
[  240.829630]  [<ffffffff810d2310>] ? try_to_wake_up+0x340/0x340
[  240.831109]  [<ffffffff810b615c>] call_usermodehelper_exec+0x14c/0x210
[  240.832991]  [<ffffffff81cd9fcc>] ? wait_for_completion+0x2c/0x100
[  240.834555]  [<ffffffff810b6948>] call_usermodehelper_fns+0xe8/0x100
[  240.836158]  [<ffffffff8110921a>] cgroup_release_agent+0x15a/0x180
[  240.837724]  [<ffffffff810b85cb>] process_one_work+0x29b/0x4c0
[  240.839199]  [<ffffffff810b8560>] ? process_one_work+0x230/0x4c0
[  240.840712]  [<ffffffff810b8da8>] worker_thread+0x248/0x380
[  240.842133]  [<ffffffff810b8b60>] ? busy_worker_rebind_fn+0xb0/0xb0
[  240.843722]  [<ffffffff810bfd71>] kthread+0xd1/0xe0
[  240.844968]  [<ffffffff810f351d>] ? trace_hardirqs_on+0xd/0x10
[  240.846431]  [<ffffffff810bfca0>] ? __kthread_bind+0x40/0x40
[  240.848017]  [<ffffffff81cdcdfc>] ret_from_fork+0x7c/0xb0
[  240.849373]  [<ffffffff810bfca0>] ? __kthread_bind+0x40/0x40
[  240.850808] 2 locks held by kworker/0:2/1079:
[  240.851930]  #0:  (events){.+.+.+}, at: [<ffffffff810b8560>]
process_one_work+0x230/0x4c0
[  240.854198]  #1:  (release_agent_work){+.+.+.}, at:
[<ffffffff810b8560>] process_one_work+0x230/0x4c0
[  240.856703] INFO: task systemd-journal:1422 blocked for more than 60 seconds.
[  240.858507] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  240.860455] systemd-journal D ffff88007bbb2748     0  1422      1 0x00100006
[  240.862325]  ffff8800794f5aa8 0000000000000046 ffff880079500000
ffff8800794f5fd8
[  240.864593]  ffff8800794f5fd8 ffff8800794f5fd8 ffff880078c3a290
ffff880079500000
[  240.866592]  ffff88007bbb2750 ffff880079500000 ffff88007bbb2750
0000000000000002
[  240.868614] Call Trace:
[  240.869263]  [<ffffffff81cd9d95>] schedule+0x55/0x60
[  240.870546]  [<ffffffff81cdb59d>] rwsem_down_failed_common+0x1fd/0x240
[  240.872172]  [<ffffffff81cdb613>] rwsem_down_write_failed+0x13/0x15
[  240.873770]  [<ffffffff81362c03>] call_rwsem_down_write_failed+0x13/0x20
[  240.875466]  [<ffffffff81cd9131>] ? down_write+0x91/0x93
[  240.876823]  [<ffffffff81227fe3>] ? ext4_release_file+0x63/0xc0
[  240.878321]  [<ffffffff810c875e>] ? lg_local_unlock+0x1e/0x40
[  240.880063]  [<ffffffff811bd6cd>] ? dput+0x12d/0x1b0
[  240.881350]  [<ffffffff81227fe3>] ext4_release_file+0x63/0xc0
[  240.882811]  [<ffffffff811a807a>] __fput+0x11a/0x210
[  240.884078]  [<ffffffff811a8179>] ____fput+0x9/0x10
[  240.885322]  [<ffffffff810bcbde>] task_work_run+0x9e/0xc0
[  240.886699]  [<ffffffff8109d86c>] do_exit+0x3ac/0xad0
[  240.887985]  [<ffffffff810f35fd>] ? trace_hardirqs_off+0xd/0x10
[  240.889529]  [<ffffffff810d4dda>] ? local_clock+0x4a/0x70
[  240.890876]  [<ffffffff81cdb99b>] ? _raw_spin_unlock_irq+0x2b/0x40
[  240.892436]  [<ffffffff8109e054>] do_group_exit+0x84/0xd0
[  240.893806]  [<ffffffff810b0289>] get_signal_to_deliver+0x739/0x810
[  240.895633]  [<ffffffff81178b9b>] ? __pte_alloc+0x9b/0x150
[  240.897036]  [<ffffffff810583b2>] do_signal+0x52/0x570
[  240.898353]  [<ffffffff810f35fd>] ? trace_hardirqs_off+0xd/0x10
[  240.899856]  [<ffffffff810d4dda>] ? local_clock+0x4a/0x70
[  240.901236]  [<ffffffff810f17f8>] ? lock_release_holdtime+0x28/0x170
[  240.902856]  [<ffffffff81cdc5ff>] ? retint_signal+0x11/0x92
[  240.904269]  [<ffffffff810588f7>] do_notify_resume+0x27/0x70
[  240.905703]  [<ffffffff81362c9e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  240.907328]  [<ffffffff81cdc63b>] retint_signal+0x4d/0x92
[  240.908697] 1 lock held by systemd-journal/1422:
[  240.909881]  #0:  (&ei->i_data_sem){++++..}, at:
[<ffffffff81227fe3>] ext4_release_file+0x63/0xc0



Case 2:

[  682.881214] [ 2854]     0  2854    13893     4870      25        0
           0 trinity-child9
[  682.883340] [ 2855]     0  2855    13452     4646      24        0
           0 trinity-child10
[  682.885485] [ 2856]     0  2856     8496     2173      14        0
           0 trinity-child3
[  682.887577] [ 2857]     0  2857     9683     2755      16        0
           0 trinity-child7
[  682.889685] Out of memory: Kill process 2631 (systemd-logind) score
0 or sacrifice child
[  682.891744] Killed process 2631 (systemd-logind) total-vm:26092kB,
anon-rss:260kB, file-rss:4kB
[  780.652122] INFO: task kworker/0:0:4 blocked for more than 60 seconds.
[  780.653723] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  780.655609] kworker/0:0     D ffff880000000000     0     4      2 0x00000000
[  780.657449]  ffff88003e38fa38 0000000000000046 ffff88003e3a0000
ffff88003e38ffd8
[  780.659442]  ffff88003e38ffd8 ffff88003e38ffd8 ffff88003ca48000
ffff88003e3a0000
[  780.661480]  ffff88003e38fa18 ffff88003e38fb88 ffff88003e38fb90
7fffffffffffffff
[  780.663386] Call Trace:
[  780.663965]  [<ffffffff81cd9d95>] schedule+0x55/0x60
[  780.665156]  [<ffffffff81cd7786>] schedule_timeout+0x36/0x240
[  780.666606]  [<ffffffff810f3303>] ? mark_held_locks+0x123/0x140
[  780.668031]  [<ffffffff81cdb99b>] ? _raw_spin_unlock_irq+0x2b/0x40
[  780.669541]  [<ffffffff810f3475>] ? trace_hardirqs_on_caller+0x155/0x1f0
[  780.671150]  [<ffffffff810f351d>] ? trace_hardirqs_on+0xd/0x10
[  780.672553]  [<ffffffff81cda037>] wait_for_completion+0x97/0x100
[  780.674057]  [<ffffffff810d2310>] ? try_to_wake_up+0x340/0x340
[  780.675515]  [<ffffffff810b615c>] call_usermodehelper_exec+0x14c/0x210
[  780.677147]  [<ffffffff81cd9fcc>] ? wait_for_completion+0x2c/0x100
[  780.678664]  [<ffffffff810b6948>] call_usermodehelper_fns+0xe8/0x100
[  780.680319]  [<ffffffff8110921a>] cgroup_release_agent+0x15a/0x180
[  780.681881]  [<ffffffff810b85cb>] process_one_work+0x29b/0x4c0
[  780.683387]  [<ffffffff810b8560>] ? process_one_work+0x230/0x4c0
[  780.684894]  [<ffffffff810b8da8>] worker_thread+0x248/0x380
[  780.686276]  [<ffffffff810b8b60>] ? busy_worker_rebind_fn+0xb0/0xb0
[  780.687809]  [<ffffffff810bfd71>] kthread+0xd1/0xe0
[  780.689028]  [<ffffffff810f351d>] ? trace_hardirqs_on+0xd/0x10
[  780.690479]  [<ffffffff810bfca0>] ? __kthread_bind+0x40/0x40
[  780.691879]  [<ffffffff81cdcdfc>] ret_from_fork+0x7c/0xb0
[  780.693220]  [<ffffffff810bfca0>] ? __kthread_bind+0x40/0x40
[  780.694603] 2 locks held by kworker/0:0/4:
[  780.695617]  #0:  (events){.+.+.+}, at: [<ffffffff810b8560>]
process_one_work+0x230/0x4c0
[  780.697738]  #1:  (release_agent_work){+.+.+.}, at:
[<ffffffff810b8560>] process_one_work+0x230/0x4c0
[  780.700128] INFO: task kworker/0:1:2792 blocked for more than 60 seconds.
[  780.701720] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  780.703548] kworker/0:1     D ffff880038538000     0  2792      2 0x00000000
[  780.705308]  ffff88003903dae8 0000000000000046 ffff880038538000
ffff88003903dfd8
[  780.707380]  ffff88003903dfd8 ffff88003903dfd8 ffff88003e382290
ffff880038538000
[  780.709362]  ffff88003903dac8 ffff88003903dc78 ffff88003903dc80
7fffffffffffffff
[  780.711330] Call Trace:
[  780.711924]  [<ffffffff81cd9d95>] schedule+0x55/0x60
[  780.713177]  [<ffffffff81cd7786>] schedule_timeout+0x36/0x240
[  780.714559]  [<ffffffff810f3303>] ? mark_held_locks+0x123/0x140
[  780.715953]  [<ffffffff81cdb99b>] ? _raw_spin_unlock_irq+0x2b/0x40
[  780.717432]  [<ffffffff810f3475>] ? trace_hardirqs_on_caller+0x155/0x1f0
[  780.719126]  [<ffffffff810f351d>] ? trace_hardirqs_on+0xd/0x10
[  780.720591]  [<ffffffff81cda037>] wait_for_completion+0x97/0x100
[  780.722105]  [<ffffffff810d2310>] ? try_to_wake_up+0x340/0x340
[  780.723566]  [<ffffffff810bff5f>] kthread_create_on_node+0xaf/0x140
[  780.725104]  [<ffffffff81091240>] ? mark_shadow+0x50/0x150
[  780.726399]  [<ffffffff810b8b60>] ? busy_worker_rebind_fn+0xb0/0xb0
[  780.727872]  [<ffffffff81cd9fcc>] ? wait_for_completion+0x2c/0x100
[  780.729337]  [<ffffffff810b7db6>] create_worker+0x106/0x200
[  780.730651]  [<ffffffff810b8073>] manage_workers+0x1c3/0x350
[  780.732092]  [<ffffffff810b8d08>] worker_thread+0x1a8/0x380
[  780.733417]  [<ffffffff810b8b60>] ? busy_worker_rebind_fn+0xb0/0xb0
[  780.734892]  [<ffffffff810bfd71>] kthread+0xd1/0xe0
[  780.736115]  [<ffffffff810f351d>] ? trace_hardirqs_on+0xd/0x10
[  780.737604]  [<ffffffff810bfca0>] ? __kthread_bind+0x40/0x40
[  780.739007]  [<ffffffff81cdcdfc>] ret_from_fork+0x7c/0xb0
[  780.740402]  [<ffffffff810bfca0>] ? __kthread_bind+0x40/0x40
[  780.741744] 1 lock held by kworker/0:1/2792:
[  780.742764]  #0:  (&pool->assoc_mutex){+.+.+.}, at:
[<ffffffff810b7ef0>] manage_workers+0x40/0x350
[  840.745108] INFO: task kworker/0:0:4 blocked for more than 60 seconds.
[  840.748081] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  840.751539] kworker/0:0     D ffff880000000000     0     4      2 0x00000000
[  840.754799]  ffff88003e38fa38 0000000000000046 ffff88003e3a0000
ffff88003e38ffd8
[  840.758348]  ffff88003e38ffd8 ffff88003e38ffd8 ffff88003ca48000
ffff88003e3a0000
[  840.761908]  ffff88003e38fa18 ffff88003e38fb88 ffff88003e38fb90
7fffffffffffffff
[  840.765480] Call Trace:
[  840.766660]  [<ffffffff81cd9d95>] schedule+0x55/0x60
[  840.768888]  [<ffffffff81cd7786>] schedule_timeout+0x36/0x240
[  840.771438]  [<ffffffff810f3303>] ? mark_held_locks+0x123/0x140
[  840.774081]  [<ffffffff81cdb99b>] ? _raw_spin_unlock_irq+0x2b/0x40
[  840.776827]  [<ffffffff810f3475>] ? trace_hardirqs_on_caller+0x155/0x1f0
[  840.779762]  [<ffffffff810f351d>] ? trace_hardirqs_on+0xd/0x10
[  840.782344]  [<ffffffff81cda037>] wait_for_completion+0x97/0x100
[  840.785034]  [<ffffffff810d2310>] ? try_to_wake_up+0x340/0x340
[  840.787375]  [<ffffffff810b615c>] call_usermodehelper_exec+0x14c/0x210
[  840.790286]  [<ffffffff81cd9fcc>] ? wait_for_completion+0x2c/0x100
[  840.793042]  [<ffffffff810b6948>] call_usermodehelper_fns+0xe8/0x100
[  840.795884]  [<ffffffff8110921a>] cgroup_release_agent+0x15a/0x180
[  840.798655]  [<ffffffff810b85cb>] process_one_work+0x29b/0x4c0
[  840.801240]  [<ffffffff810b8560>] ? process_one_work+0x230/0x4c0
[  840.803925]  [<ffffffff810b8da8>] worker_thread+0x248/0x380
[  840.806416]  [<ffffffff810b8b60>] ? busy_worker_rebind_fn+0xb0/0xb0
[  840.809275]  [<ffffffff810bfd71>] kthread+0xd1/0xe0
[  840.811454]  [<ffffffff810f351d>] ? trace_hardirqs_on+0xd/0x10
[  840.814059]  [<ffffffff810bfca0>] ? __kthread_bind+0x40/0x40
[  840.816594]  [<ffffffff81cdcdfc>] ret_from_fork+0x7c/0xb0
[  840.819009]  [<ffffffff810bfca0>] ? __kthread_bind+0x40/0x40
[  840.821661] 2 locks held by kworker/0:0/4:
[  840.823999]  #0:  (events){.+.+.+}, at: [<ffffffff810b8560>]
process_one_work+0x230/0x4c0
[  840.825638]  #1:  (release_agent_work){+.+.+.}, at:
[<ffffffff810b8560>] process_one_work+0x230/0x4c0
[  840.827564] INFO: task kworker/0:1:2792 blocked for more than 60 seconds.
[  840.829225] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  840.831432] kworker/0:1     D ffff880038538000     0  2792      2 0x00000000
[  840.833246]  ffff88003903dae8 0000000000000046 ffff880038538000
ffff88003903dfd8
[  840.835207]  ffff88003903dfd8 ffff88003903dfd8 ffff88003e382290
ffff880038538000
[  840.837181]  ffff88003903dac8 ffff88003903dc78 ffff88003903dc80
7fffffffffffffff
[  840.839145] Call Trace:
[  840.839762]  [<ffffffff81cd9d95>] schedule+0x55/0x60
[  840.840989]  [<ffffffff81cd7786>] schedule_timeout+0x36/0x240
[  840.842412]  [<ffffffff810f3303>] ? mark_held_locks+0x123/0x140
[  840.843867]  [<ffffffff81cdb99b>] ? _raw_spin_unlock_irq+0x2b/0x40
[  840.845388]  [<ffffffff810f3475>] ? trace_hardirqs_on_caller+0x155/0x1f0
[  840.847028]  [<ffffffff810f351d>] ? trace_hardirqs_on+0xd/0x10
[  840.848531]  [<ffffffff81cda037>] wait_for_completion+0x97/0x100
[  840.850007]  [<ffffffff810d2310>] ? try_to_wake_up+0x340/0x340
[  840.851448]  [<ffffffff810bff5f>] kthread_create_on_node+0xaf/0x140
[  840.852995]  [<ffffffff81091240>] ? mark_shadow+0x50/0x150
[  840.854358]  [<ffffffff810b8b60>] ? busy_worker_rebind_fn+0xb0/0xb0
[  840.855911]  [<ffffffff81cd9fcc>] ? wait_for_completion+0x2c/0x100
[  840.857443]  [<ffffffff810b7db6>] create_worker+0x106/0x200
[  840.858836]  [<ffffffff810b8073>] manage_workers+0x1c3/0x350
[  840.860222]  [<ffffffff810b8d08>] worker_thread+0x1a8/0x380
[  840.861578]  [<ffffffff810b8b60>] ? busy_worker_rebind_fn+0xb0/0xb0
[  840.863110]  [<ffffffff810bfd71>] kthread+0xd1/0xe0
[  840.864319]  [<ffffffff810f351d>] ? trace_hardirqs_on+0xd/0x10
[  840.865763]  [<ffffffff810bfca0>] ? __kthread_bind+0x40/0x40
[  840.867153]  [<ffffffff81cdcdfc>] ret_from_fork+0x7c/0xb0
[  840.868496]  [<ffffffff810bfca0>] ? __kthread_bind+0x40/0x40
[  840.869885] 1 lock held by kworker/0:1/2792:
[  840.870955]  #0:  (&pool->assoc_mutex){+.+.+.}, at:
[<ffffffff810b7ef0>] manage_workers+0x40/0x350
[  900.873197] INFO: task kworker/0:0:4 blocked for more than 60 seconds.
[  900.874859] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  900.876791] kworker/0:0     D ffff880000000000     0     4      2 0x00000000
[  900.878607]  ffff88003e38fa38 0000000000000046 ffff88003e3a0000
ffff88003e38ffd8
[  900.880555]  ffff88003e38ffd8 ffff88003e38ffd8 ffff88003ca48000
ffff88003e3a0000
[  900.882488]  ffff88003e38fa18 ffff88003e38fb88 ffff88003e38fb90
7fffffffffffffff
[  900.884470] Call Trace:
[  900.885101]  [<ffffffff81cd9d95>] schedule+0x55/0x60
[  900.886345]  [<ffffffff81cd7786>] schedule_timeout+0x36/0x240
[  900.887771]  [<ffffffff810f3303>] ? mark_held_locks+0x123/0x140
[  900.889273]  [<ffffffff81cdb99b>] ? _raw_spin_unlock_irq+0x2b/0x40
[  900.890812]  [<ffffffff810f3475>] ? trace_hardirqs_on_caller+0x155/0x1f0
[  900.892457]  [<ffffffff810f351d>] ? trace_hardirqs_on+0xd/0x10
[  900.893912]  [<ffffffff81cda037>] wait_for_completion+0x97/0x100
[  900.895397]  [<ffffffff810d2310>] ? try_to_wake_up+0x340/0x340
[  900.896857]  [<ffffffff810b615c>] call_usermodehelper_exec+0x14c/0x210
[  900.898473]  [<ffffffff81cd9fcc>] ? wait_for_completion+0x2c/0x100
[  900.900000]  [<ffffffff810b6948>] call_usermodehelper_fns+0xe8/0x100
[  900.901597]  [<ffffffff8110921a>] cgroup_release_agent+0x15a/0x180
[  900.903105]  [<ffffffff810b85cb>] process_one_work+0x29b/0x4c0
[  900.904551]  [<ffffffff810b8560>] ? process_one_work+0x230/0x4c0
[  900.906025]  [<ffffffff810b8da8>] worker_thread+0x248/0x380
[  900.907415]  [<ffffffff810b8b60>] ? busy_worker_rebind_fn+0xb0/0xb0
[  900.908953]  [<ffffffff810bfd71>] kthread+0xd1/0xe0
[  900.910190]  [<ffffffff810f351d>] ? trace_hardirqs_on+0xd/0x10
[  900.911626]  [<ffffffff810bfca0>] ? __kthread_bind+0x40/0x40
[  900.913031]  [<ffffffff81cdcdfc>] ret_from_fork+0x7c/0xb0
[  900.914425]  [<ffffffff810bfca0>] ? __kthread_bind+0x40/0x40
[  900.915787] 2 locks held by kworker/0:0/4:
[  900.916810]  #0:  (events){.+.+.+}, at: [<ffffffff810b8560>]
process_one_work+0x230/0x4c0
[  900.918985]  #1:  (release_agent_work){+.+.+.}, at:
[<ffffffff810b8560>] process_one_work+0x230/0x4c0
[  900.921454] INFO: task kworker/0:1:2792 blocked for more than 60 seconds.
[  900.923092] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  900.925021] kworker/0:1     D ffff880038538000     0  2792      2 0x00000000
[  900.926802]  ffff88003903dae8 0000000000000046 ffff880038538000
ffff88003903dfd8
[  900.928789]  ffff88003903dfd8 ffff88003903dfd8 ffff88003e382290
ffff880038538000
[  900.930790]  ffff88003903dac8 ffff88003903dc78 ffff88003903dc80
7fffffffffffffff
[  900.932786] Call Trace:
[  900.933427]  [<ffffffff81cd9d95>] schedule+0x55/0x60
[  900.934660]  [<ffffffff81cd7786>] schedule_timeout+0x36/0x240
[  900.936066]  [<ffffffff810f3303>] ? mark_held_locks+0x123/0x140
[  900.937522]  [<ffffffff81cdb99b>] ? _raw_spin_unlock_irq+0x2b/0x40
[  900.939041]  [<ffffffff810f3475>] ? trace_hardirqs_on_caller+0x155/0x1f0
[  900.940754]  [<ffffffff810f351d>] ? trace_hardirqs_on+0xd/0x10
[  900.942203]  [<ffffffff81cda037>] wait_for_completion+0x97/0x100
[  900.943687]  [<ffffffff810d2310>] ? try_to_wake_up+0x340/0x340
[  900.945140]  [<ffffffff810bff5f>] kthread_create_on_node+0xaf/0x140
[  900.946678]  [<ffffffff81091240>] ? mark_shadow+0x50/0x150
[  900.948042]  [<ffffffff810b8b60>] ? busy_worker_rebind_fn+0xb0/0xb0
[  900.949575]  [<ffffffff81cd9fcc>] ? wait_for_completion+0x2c/0x100
[  900.951080]  [<ffffffff810b7db6>] create_worker+0x106/0x200
[  900.952476]  [<ffffffff810b8073>] manage_workers+0x1c3/0x350
[  900.953866]  [<ffffffff810b8d08>] worker_thread+0x1a8/0x380
[  900.955237]  [<ffffffff810b8b60>] ? busy_worker_rebind_fn+0xb0/0xb0
[  900.956798]  [<ffffffff810bfd71>] kthread+0xd1/0xe0
[  900.957986]  [<ffffffff810f351d>] ? trace_hardirqs_on+0xd/0x10
[  900.959437]  [<ffffffff810bfca0>] ? __kthread_bind+0x40/0x40
[  900.960862]  [<ffffffff81cdcdfc>] ret_from_fork+0x7c/0xb0
[  900.962204]  [<ffffffff810bfca0>] ? __kthread_bind+0x40/0x40
[  900.963584] 1 lock held by kworker/0:1/2792:
[  900.964691]  #0:  (&pool->assoc_mutex){+.+.+.}, at:
[<ffffffff810b7ef0>] manage_workers+0x40/0x350
[  960.967185] INFO: task kworker/0:0:4 blocked for more than 60 seconds.
[  960.968860] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  960.970785] kworker/0:0     D ffff880000000000     0     4      2 0x00000000
[  960.972612]  ffff88003e38fa38 0000000000000046 ffff88003e3a0000
ffff88003e38ffd8
[  960.974587]  ffff88003e38ffd8 ffff88003e38ffd8 ffff88003ca48000
ffff88003e3a0000
[  960.976569]  ffff88003e38fa18 ffff88003e38fb88 ffff88003e38fb90
7fffffffffffffff
[  960.978527] Call Trace:
[  960.979159]  [<ffffffff81cd9d95>] schedule+0x55/0x60
[  960.980383]  [<ffffffff81cd7786>] schedule_timeout+0x36/0x240
[  960.981818]  [<ffffffff810f3303>] ? mark_held_locks+0x123/0x140
[  960.983263]  [<ffffffff81cdb99b>] ? _raw_spin_unlock_irq+0x2b/0x40
[  960.984787]  [<ffffffff810f3475>] ? trace_hardirqs_on_caller+0x155/0x1f0
[  960.986412]  [<ffffffff810f351d>] ? trace_hardirqs_on+0xd/0x10
[  960.987858]  [<ffffffff81cda037>] wait_for_completion+0x97/0x100
[  960.989342]  [<ffffffff810d2310>] ? try_to_wake_up+0x340/0x340
[  960.990795]  [<ffffffff810b615c>] call_usermodehelper_exec+0x14c/0x210
[  960.992389]  [<ffffffff81cd9fcc>] ? wait_for_completion+0x2c/0x100
[  960.993908]  [<ffffffff810b6948>] call_usermodehelper_fns+0xe8/0x100
[  960.995495]  [<ffffffff8110921a>] cgroup_release_agent+0x15a/0x180
[  960.997006]  [<ffffffff810b85cb>] process_one_work+0x29b/0x4c0
[  960.998466]  [<ffffffff810b8560>] ? process_one_work+0x230/0x4c0
[  960.999939]  [<ffffffff810b8da8>] worker_thread+0x248/0x380
[  961.001317]  [<ffffffff810b8b60>] ? busy_worker_rebind_fn+0xb0/0xb0
[  961.002855]  [<ffffffff810bfd71>] kthread+0xd1/0xe0
[  961.004063]  [<ffffffff810f351d>] ? trace_hardirqs_on+0xd/0x10
[  961.005490]  [<ffffffff810bfca0>] ? __kthread_bind+0x40/0x40
[  961.006881]  [<ffffffff81cdcdfc>] ret_from_fork+0x7c/0xb0
[  961.008221]  [<ffffffff810bfca0>] ? __kthread_bind+0x40/0x40
[  961.009581] 2 locks held by kworker/0:0/4:
[  961.010611]  #0:  (events){.+.+.+}, at: [<ffffffff810b8560>]
process_one_work+0x230/0x4c0
[  961.012810]  #1:  (release_agent_work){+.+.+.}, at:
[<ffffffff810b8560>] process_one_work+0x230/0x4c0
[  961.015308] INFO: task kworker/0:1:2792 blocked for more than 60 seconds.
[  961.016984] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[  961.018923] kworker/0:1     D ffff880038538000     0  2792      2 0x00000000
[  961.020761]  ffff88003903dae8 0000000000000046 ffff880038538000
ffff88003903dfd8
[  961.022762]  ffff88003903dfd8 ffff88003903dfd8 ffff88003e382290
ffff880038538000
[  961.024752]  ffff88003903dac8 ffff88003903dc78 ffff88003903dc80
7fffffffffffffff
[  961.026726] Call Trace:
[  961.027360]  [<ffffffff81cd9d95>] schedule+0x55/0x60
[  961.028629]  [<ffffffff81cd7786>] schedule_timeout+0x36/0x240
[  961.030052]  [<ffffffff810f3303>] ? mark_held_locks+0x123/0x140
[  961.031516]  [<ffffffff81cdb99b>] ? _raw_spin_unlock_irq+0x2b/0x40
[  961.033039]  [<ffffffff810f3475>] ? trace_hardirqs_on_caller+0x155/0x1f0
[  961.034690]  [<ffffffff810f351d>] ? trace_hardirqs_on+0xd/0x10
[  961.036132]  [<ffffffff81cda037>] wait_for_completion+0x97/0x100
[  961.037657]  [<ffffffff810d2310>] ? try_to_wake_up+0x340/0x340
[  961.039097]  [<ffffffff810bff5f>] kthread_create_on_node+0xaf/0x140
[  961.040646]  [<ffffffff81091240>] ? mark_shadow+0x50/0x150
[  961.041985]  [<ffffffff810b8b60>] ? busy_worker_rebind_fn+0xb0/0xb0
[  961.043547]  [<ffffffff81cd9fcc>] ? wait_for_completion+0x2c/0x100
[  961.045052]  [<ffffffff810b7db6>] create_worker+0x106/0x200
[  961.046475]  [<ffffffff810b8073>] manage_workers+0x1c3/0x350
[  961.047886]  [<ffffffff810b8d08>] worker_thread+0x1a8/0x380
[  961.049253]  [<ffffffff810b8b60>] ? busy_worker_rebind_fn+0xb0/0xb0
[  961.050755]  [<ffffffff810bfd71>] kthread+0xd1/0xe0
[  961.051974]  [<ffffffff810f351d>] ? trace_hardirqs_on+0xd/0x10
[  961.053416]  [<ffffffff810bfca0>] ? __kthread_bind+0x40/0x40
[  961.054836]  [<ffffffff81cdcdfc>] ret_from_fork+0x7c/0xb0
[  961.056187]  [<ffffffff810bfca0>] ? __kthread_bind+0x40/0x40
[  961.057591] 1 lock held by kworker/0:1/2792:
[  961.058685]  #0:  (&pool->assoc_mutex){+.+.+.}, at:
[<ffffffff810b7ef0>] manage_workers+0x40/0x350
[ 1021.061156] INFO: task kworker/0:0:4 blocked for more than 60 seconds.
[ 1021.062857] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1021.064805] kworker/0:0     D ffff880000000000     0     4      2 0x00000000
[ 1021.066613]  ffff88003e38fa38 0000000000000046 ffff88003e3a0000
ffff88003e38ffd8
[ 1021.068668]  ffff88003e38ffd8 ffff88003e38ffd8 ffff88003ca48000
ffff88003e3a0000
[ 1021.070690]  ffff88003e38fa18 ffff88003e38fb88 ffff88003e38fb90
7fffffffffffffff
[ 1021.072661] Call Trace:
[ 1021.073302]  [<ffffffff81cd9d95>] schedule+0x55/0x60
[ 1021.074518]  [<ffffffff81cd7786>] schedule_timeout+0x36/0x240
[ 1021.075908]  [<ffffffff810f3303>] ? mark_held_locks+0x123/0x140
[ 1021.077399]  [<ffffffff81cdb99b>] ? _raw_spin_unlock_irq+0x2b/0x40
[ 1021.078919]  [<ffffffff810f3475>] ? trace_hardirqs_on_caller+0x155/0x1f0
[ 1021.080538]  [<ffffffff810f351d>] ? trace_hardirqs_on+0xd/0x10
[ 1021.081978]  [<ffffffff81cda037>] wait_for_completion+0x97/0x100
[ 1021.083604]  [<ffffffff810d2310>] ? try_to_wake_up+0x340/0x340
[ 1021.085700]  [<ffffffff810b615c>] call_usermodehelper_exec+0x14c/0x210
[ 1021.087331]  [<ffffffff81cd9fcc>] ? wait_for_completion+0x2c/0x100
[ 1021.088848]  [<ffffffff810b6948>] call_usermodehelper_fns+0xe8/0x100
[ 1021.090390]  [<ffffffff8110921a>] cgroup_release_agent+0x15a/0x180
[ 1021.091892]  [<ffffffff810b85cb>] process_one_work+0x29b/0x4c0
[ 1021.093236]  [<ffffffff810b8560>] ? process_one_work+0x230/0x4c0
[ 1021.094342]  [<ffffffff810b8da8>] worker_thread+0x248/0x380
[ 1021.095376]  [<ffffffff810b8b60>] ? busy_worker_rebind_fn+0xb0/0xb0
[ 1021.097017]  [<ffffffff810bfd71>] kthread+0xd1/0xe0
[ 1021.098124]  [<ffffffff810f351d>] ? trace_hardirqs_on+0xd/0x10
[ 1021.099342]  [<ffffffff810bfca0>] ? __kthread_bind+0x40/0x40
[ 1021.100448]  [<ffffffff81cdcdfc>] ret_from_fork+0x7c/0xb0
[ 1021.101855]  [<ffffffff810bfca0>] ? __kthread_bind+0x40/0x40
[ 1021.103221] 2 locks held by kworker/0:0/4:
[ 1021.104307]  #0:  (events){.+.+.+}, at: [<ffffffff810b8560>]
process_one_work+0x230/0x4c0
[ 1021.106541]  #1:  (release_agent_work){+.+.+.}, at:
[<ffffffff810b8560>] process_one_work+0x230/0x4c0
[ 1021.109041] INFO: task kworker/0:1:2792 blocked for more than 60 seconds.
[ 1021.110729] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1021.112679] kworker/0:1     D ffff880038538000     0  2792      2 0x00000000
[ 1021.114566]  ffff88003903dae8 0000000000000046 ffff880038538000
ffff88003903dfd8
[ 1021.116577]  ffff88003903dfd8 ffff88003903dfd8 ffff88003e382290
ffff880038538000
[ 1021.118613]  ffff88003903dac8 ffff88003903dc78 ffff88003903dc80
7fffffffffffffff
[ 1021.120632] Call Trace:
[ 1021.121276]  [<ffffffff81cd9d95>] schedule+0x55/0x60
[ 1021.122557]  [<ffffffff81cd7786>] schedule_timeout+0x36/0x240
[ 1021.124039]  [<ffffffff810f3303>] ? mark_held_locks+0x123/0x140
[ 1021.125530]  [<ffffffff81cdb99b>] ? _raw_spin_unlock_irq+0x2b/0x40
[ 1021.127057]  [<ffffffff810f3475>] ? trace_hardirqs_on_caller+0x155/0x1f0
[ 1021.128734]  [<ffffffff810f351d>] ? trace_hardirqs_on+0xd/0x10
[ 1021.130196]  [<ffffffff81cda037>] wait_for_completion+0x97/0x100
[ 1021.131708]  [<ffffffff810d2310>] ? try_to_wake_up+0x340/0x340
[ 1021.133189]  [<ffffffff810bff5f>] kthread_create_on_node+0xaf/0x140
[ 1021.134762]  [<ffffffff81091240>] ? mark_shadow+0x50/0x150
[ 1021.136140]  [<ffffffff810b8b60>] ? busy_worker_rebind_fn+0xb0/0xb0
[ 1021.137727]  [<ffffffff81cd9fcc>] ? wait_for_completion+0x2c/0x100
[ 1021.139266]  [<ffffffff810b7db6>] create_worker+0x106/0x200
[ 1021.140681]  [<ffffffff810b8073>] manage_workers+0x1c3/0x350
[ 1021.142098]  [<ffffffff810b8d08>] worker_thread+0x1a8/0x380
[ 1021.143756]  [<ffffffff810b8b60>] ? busy_worker_rebind_fn+0xb0/0xb0
[ 1021.146364]  [<ffffffff810bfd71>] kthread+0xd1/0xe0
[ 1021.147622]  [<ffffffff810f351d>] ? trace_hardirqs_on+0xd/0x10
[ 1021.148722]  [<ffffffff810bfca0>] ? __kthread_bind+0x40/0x40
[ 1021.149807]  [<ffffffff81cdcdfc>] ret_from_fork+0x7c/0xb0
[ 1021.150864]  [<ffffffff810bfca0>] ? __kthread_bind+0x40/0x40
[ 1021.152179] 1 lock held by kworker/0:1/2792:
[ 1021.153260]  #0:  (&pool->assoc_mutex){+.+.+.}, at:
[<ffffffff810b7ef0>] manage_workers+0x40/0x350


Tommi
