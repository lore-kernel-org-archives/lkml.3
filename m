Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048Ab3KMDfo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 22:35:44 -0500
Received: from mga02.intel.com ([134.134.136.20]:16983 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755867Ab3KMDfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 22:35:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,690,1378882800"; 
   d="scan'208";a="426601762"
Date: Wed, 13 Nov 2013 11:35:03 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
Subject: Re: [seqcount] INFO: trying to register non-static key.
Message-ID: <20131113033503.GA28965@localhost>
References: <20131111012927.GA404@localhost>
 <20131111154551.GJ19203@twins.programming.kicks-ass.net>
 <20131112094147.GA32441@localhost>
 <20131112100140.GM5056@laptop.programming.kicks-ass.net>
 <20131112151541.GD24980@redhat.com>
 <20131112152956.GY5056@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <20131112152956.GY5056@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 12, 2013 at 04:29:56PM +0100, Peter Zijlstra wrote:
> On Tue, Nov 12, 2013 at 10:15:41AM -0500, Vivek Goyal wrote:
> > I see that we allocate per cpu stats but don't do any initializations.
> > 
> > static void tg_stats_alloc_fn(struct work_struct *work)
> > {
> >         static struct tg_stats_cpu *stats_cpu;  /* this fn is non-reentrant */
> >         struct delayed_work *dwork = to_delayed_work(work);
> >         bool empty = false;
> > 
> > alloc_stats:
> >         if (!stats_cpu) {
> >                 stats_cpu = alloc_percpu(struct tg_stats_cpu);
> >                 if (!stats_cpu) {
> >                         /* allocation failed, try again after some time */
> >                         schedule_delayed_work(dwork, msecs_to_jiffies(10));
> >                         return;
> >                 }
> >         }
> > 
> >         spin_lock_irq(&tg_stats_alloc_lock);
> 
> Absolutely!
> 
> Something like this perhaps? Did I miss more blkg_[rw]stats? If I read
> the git grep output right, this was the last one.

It changed the error into another one:

/kernel/i386-randconfig-j7-11082318/9d0d532888f6e77970016c0c270ddececfab8f9e

+---------------------------------------------------------+-------+--------------+--------------+--------------+
|                                                         | v3.12 | 838cc7b488f8 | d3516a7318f8 | 9d0d532888f6 |
+---------------------------------------------------------+-------+--------------+--------------+--------------+
| boot_successes                                          | 129   | 0            | 0            | 0            |
| boot_failures                                           | 1     | 100          | 100          | 100          |
| BUG:kernel_early_hang_without_any_printk_output         | 1     |              |              |              |
| INFO:trying_to_register_non-static_key                  | 0     | 100          | 100          |              |
| BUG:unable_to_handle_kernel_NULL_pointer_dereference_at | 0     | 0            | 0            | 98           |
| Oops:SMP                                                | 0     | 0            | 0            | 100          |
| BUG:unable_to_handle_kernel_paging_request_at           | 0     | 0            | 0            | 100          |
| BUG:unable_to_handle_kernel                             | 0     | 0            | 0            | 2            |
+---------------------------------------------------------+-------+--------------+--------------+--------------+

Here are 3 of the call traces. Attached 1 full dmesg.

dmesg-quantal-ant-3:20131113183320:i386-randconfig-j7-11082318:3.12.0-00187-g9d0d532:1

[   52.578884] SCSI Media Changer driver v0.25 
[   52.781957] scsi_debug: host protection
[   52.783001] scsi0 : scsi_debug, version 1.82 [20100324], dev_size_mb=8, opts=0x0
[   52.846181] BUG: unable to handle kernel NULL pointer dereference at 00000008
[   52.846293] IP: [<78287084>] lockdep_init_map+0xd/0x544
[   52.846293] *pde = 00000000 
[   52.846293] Oops: 0002 [#1] SMP 
[   52.846293] CPU: 0 PID: 4 Comm: kworker/0:0 Not tainted 3.12.0-00187-g9d0d532 #1
[   52.846293] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   52.846293] Workqueue: events tg_stats_alloc_fn
[   52.846293] task: 854f0070 ti: 854f6000 task.ti: 854f6000
[   52.846293] EIP: 0060:[<78287084>] EFLAGS: 00000296 CPU: 0
[   52.846293] EIP is at lockdep_init_map+0xd/0x544
[   52.846293] EAX: 00000004 EBX: 79d614b0 ECX: 79d614b0 EDX: 793fba74
[   52.846293] ESI: 00000004 EDI: 79d614b8 EBP: 854f7e90 ESP: 854f7e78
[   52.846293]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   52.846293] CR0: 8005003b CR2: 00000008 CR3: 018a4000 CR4: 000006d0
[   52.846293] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   52.846293] DR6: 00000000 DR7: 00000000
[   52.846293] Stack:
[   52.846293]  0000014a 0000014b 854bd740 00000000 00000000 79d614b8 854f7eac 785fae1d
[   52.846293]  00000000 795aea60 854bd740 00000000 00000000 854f7ef8 7826bae8 00000000
[   52.846293]  00000001 00000000 7826ba8f 854a6a00 85bf0700 795aea60 85bef380 795aea60
[   52.846293] Call Trace:
[   52.846293]  [<785fae1d>] tg_stats_alloc_fn+0xe3/0x155
[   52.846293]  [<7826bae8>] process_one_work+0x1ef/0x349
[   52.846293]  [<7826ba8f>] ? process_one_work+0x196/0x349
[   52.846293]  [<7826c039>] worker_thread+0x1a3/0x274
[   52.846293]  [<7826be96>] ? rescuer_thread+0x233/0x233
[   52.846293]  [<78270649>] kthread+0x8a/0x8f
[   52.846293]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[   52.846293]  [<78fbac7b>] ret_from_kernel_thread+0x1b/0x30
[   52.846293]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[   52.846293] Code: f0 8b 7d e8 64 ff 0d 68 d7 74 79 89 70 10 89 78 14 e9 9b fe ff ff 8d 65 f4 5b 5e 5f 5d c3 55 89 e5 57 56 89 c6 53 89 cb 83 ec 0c <c7> 40 04 00 00 00 00 c7 40 08 00 00 00 00 64 a1 10 d0 74 79 89
[   52.846293] EIP: [<78287084>] lockdep_init_map+0xd/0x544 SS:ESP 0068:854f7e78
[   52.846293] CR2: 0000000000000008
[   52.870492] ---[ end trace cee670421f9807b7 ]---
[   52.871070] kworker/0:0 (4) used greatest stack depth: 6464 bytes left

dmesg-quantal-ant-3:20131113183450:i386-randconfig-j7-11082318:3.12.0-00187-g9d0d532:1

[   60.495607] scsi_debug: host protection
[   60.496526] scsi0 : scsi_debug, version 1.82 [20100324], dev_size_mb=8, opts=0x0
[   60.549921] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       0004 PQ: 0 ANSI: 5
[   60.574257] BUG: unable to handle kernel NULL pointer dereference at 00000008
[   60.574284] IP: [<78287084>] lockdep_init_map+0xd/0x544
[   60.574284] *pde = 00000000 
[   60.574284] Oops: 0002 [#1] SMP 
[   60.574284] CPU: 0 PID: 4 Comm: kworker/0:0 Not tainted 3.12.0-00187-g9d0d532 #1
[   60.574284] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   60.574284] Workqueue: events tg_stats_alloc_fn
[   60.574284] task: 854f0070 ti: 854f6000 task.ti: 854f6000
[   60.574284] EIP: 0060:[<78287084>] EFLAGS: 00000296 CPU: 0
[   60.574284] EIP is at lockdep_init_map+0xd/0x544
[   60.574284] EAX: 00000004 EBX: 79d614b0 ECX: 79d614b0 EDX: 793fba74
[   60.574284] ESI: 00000004 EDI: 79d614b8 EBP: 854f7e90 ESP: 854f7e78
[   60.574284]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   60.574284] CR0: 8005003b CR2: 00000008 CR3: 018a4000 CR4: 000006d0
[   60.574284] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   60.574284] DR6: 00000000 DR7: 00000000
[   60.574284] Stack:
[   60.574284]  0000014a 0000014b 854bd740 00000000 00000000 79d614b8 854f7eac 785fae1d
[   60.574284]  00000000 795aea60 854bd740 00000000 00000000 854f7ef8 7826bae8 00000000
[   60.574284]  00000001 00000000 7826ba8f 854a6a00 85bf0700 795aea60 85bef380 795aea60
[   60.574284] Call Trace:
[   60.574284]  [<785fae1d>] tg_stats_alloc_fn+0xe3/0x155
[   60.574284]  [<7826bae8>] process_one_work+0x1ef/0x349
[   60.574284]  [<7826ba8f>] ? process_one_work+0x196/0x349
[   60.574284]  [<7826c039>] worker_thread+0x1a3/0x274
[   60.574284]  [<7826be96>] ? rescuer_thread+0x233/0x233
[   60.574284]  [<78270649>] kthread+0x8a/0x8f
[   60.574284]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[   60.574284]  [<78fbac7b>] ret_from_kernel_thread+0x1b/0x30
[   60.574284]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[   60.574284] Code: f0 8b 7d e8 64 ff 0d 68 d7 74 79 89 70 10 89 78 14 e9 9b fe ff ff 8d 65 f4 5b 5e 5f 5d c3 55 89 e5 57 56 89 c6 53 89 cb 83 ec 0c <c7> 40 04 00 00 00 00 c7 40 08 00 00 00 00 64 a1 10 d0 74 79 89
[   60.574284] EIP: [<78287084>] lockdep_init_map+0xd/0x544 SS:ESP 0068:854f7e78
[   60.574284] CR2: 0000000000000008
[   60.598000] ---[ end trace 2de24a556554a2aa ]---
[   60.598976] kworker/0:0 (4) used greatest stack depth: 6464 bytes left

dmesg-quantal-ant-6:20131113183449:i386-randconfig-j7-11082318:3.12.0-00187-g9d0d532:1

[   54.292005] SCSI Media Changer driver v0.25 
[   54.459617] scsi_debug: host protection
[   54.460597] scsi0 : scsi_debug, version 1.82 [20100324], dev_size_mb=8, opts=0x0
[   54.519306] BUG: unable to handle kernel NULL pointer dereference at 00000008
[   54.519328] IP: [<78287084>] lockdep_init_map+0xd/0x544
[   54.519328] *pde = 00000000 
[   54.519328] Oops: 0002 [#1] SMP 
[   54.519328] CPU: 0 PID: 4 Comm: kworker/0:0 Not tainted 3.12.0-00187-g9d0d532 #1
[   54.519328] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   54.519328] Workqueue: events tg_stats_alloc_fn
[   54.519328] task: 854f0070 ti: 854f6000 task.ti: 854f6000
[   54.519328] EIP: 0060:[<78287084>] EFLAGS: 00000296 CPU: 0
[   54.519328] EIP is at lockdep_init_map+0xd/0x544
[   54.519328] EAX: 00000004 EBX: 79d614b0 ECX: 79d614b0 EDX: 793fba74
[   54.519328] ESI: 00000004 EDI: 79d614b8 EBP: 854f7e90 ESP: 854f7e78
[   54.519328]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[   54.519328] CR0: 8005003b CR2: 00000008 CR3: 018a4000 CR4: 000006d0
[   54.519328] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   54.519328] DR6: 00000000 DR7: 00000000
[   54.519328] Stack:
[   54.519328]  0000014a 0000014b 854bd740 00000000 00000000 79d614b8 854f7eac 785fae1d
[   54.519328]  00000000 795aea60 854bd740 00000000 00000000 854f7ef8 7826bae8 00000000
[   54.519328]  00000001 00000000 7826ba8f 854a6a00 85bf0700 795aea60 85bef380 795aea60
[   54.519328] Call Trace:
[   54.519328]  [<785fae1d>] tg_stats_alloc_fn+0xe3/0x155
[   54.519328]  [<7826bae8>] process_one_work+0x1ef/0x349
[   54.519328]  [<7826ba8f>] ? process_one_work+0x196/0x349
[   54.519328]  [<7826c039>] worker_thread+0x1a3/0x274
[   54.519328]  [<7826be96>] ? rescuer_thread+0x233/0x233
[   54.519328]  [<78270649>] kthread+0x8a/0x8f
[   54.519328]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[   54.519328]  [<78fbac7b>] ret_from_kernel_thread+0x1b/0x30
[   54.519328]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[   54.519328] Code: f0 8b 7d e8 64 ff 0d 68 d7 74 79 89 70 10 89 78 14 e9 9b fe ff ff 8d 65 f4 5b 5e 5f 5d c3 55 89 e5 57 56 89 c6 53 89 cb 83 ec 0c <c7> 40 04 00 00 00 00 c7 40 08 00 00 00 00 64 a1 10 d0 74 79 89
[   54.519328] EIP: [<78287084>] lockdep_init_map+0xd/0x544 SS:ESP 0068:854f7e78
[   54.519328] CR2: 0000000000000008
[   54.543176] ---[ end trace ddf2d30616f27d7a ]---
[   54.544356] kworker/0:0 (4) used greatest stack depth: 6464 bytes left

Thanks,
Fengguang


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-quantal-cairo-10:20131113105701:i386-randconfig-j7-11082318:3.12.0-00187-g9d0d532:1"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.12.0-00187-g9d0d532 (kbuild@jaketown) (gcc v=
ersion 4.8.1 (Debian 4.8.1-8) ) #1 SMP Wed Nov 13 10:56:00 CST 2013
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   UMC UMC UMC UMC
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2011
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x100000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdac0-0x000fdacf] mapped at =
[780fdac0]
[    0.000000]   mpc: fdad0-fdbec
[    0.000000] initial memory mapped: [mem 0x00000000-0x023fffff]
[    0.000000] Base memory trampoline at [7809b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x0e000000-0x0e3fffff]
[    0.000000]  [mem 0x0e000000-0x0e3fffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x08000000-0x0dffffff]
[    0.000000]  [mem 0x08000000-0x0dffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x07ffffff]
[    0.000000]  [mem 0x00100000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x07ffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x0e400000-0x0fffdfff]
[    0.000000]  [mem 0x0e400000-0x0fbfffff] page 2M
[    0.000000]  [mem 0x0fc00000-0x0fffdfff] page 4k
[    0.000000] BRK [0x01e81000, 0x01e81fff] PGTABLE
[    0.000000] BRK [0x01e82000, 0x01e83fff] PGTABLE
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128404(97%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd930 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe450 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC=
 00000001)
[    0.000000] ACPI: DSDT 0fffe490 011A9 (v01   BXPC   BXDSDT 00000001 INTL=
 20100528)
[    0.000000] ACPI: FACS 0fffff40 00040
[    0.000000] ACPI: SSDT 0ffff7a0 00796 (v01 BOCHS  BXPCSSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: APIC 0ffff680 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC=
 00000001)
[    0.000000] ACPI: HPET 0ffff640 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC=
 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] BRK [0x01e84000, 0x01e84fff] PGTABLE
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   Normal   [mem 0x01000000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65436
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3998 pages, LIFO batch:0
[    0.000000]   Normal zone: 480 pages used for memmap
[    0.000000]   Normal zone: 61438 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffa000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 0, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 0, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 0, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 0, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 0, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 0, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 0, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 0, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 0, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 0, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 0, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 0, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 0, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 0, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 0, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffff9000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:32 nr_cpumask_bits:2 nr_cpu_ids:2 nr_n=
ode_ids:1
[    0.000000] PERCPU: Embedded 331 pages/cpu @85aa9000 s1340296 r0 d15480 =
u1355776
[    0.000000] pcpu-alloc: s1340296 r0 d15480 u1355776 alloc=3D331*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr daab7c0
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64924
[    0.000000] Kernel command line: hung_task_panic=3D1 rcutree.rcu_cpu_sta=
ll_timeout=3D100 log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3D=
debug dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 co=
nsole=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=
=3D/kernel-tests/run-queue/kvm/i386-randconfig-j7-11082318/wfg:fix-blkg_sta=
t_init/.vmlinuz-9d0d532888f6e77970016c0c270ddececfab8f9e-20131113105621-85-=
cairo branch=3Dwfg/fix-blkg_stat_init BOOT_IMAGE=3D/kernel/i386-randconfig-=
j7-11082318/9d0d532888f6e77970016c0c270ddececfab8f9e/vmlinuz-3.12.0-00187-g=
9d0d532
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 194064K/261744K available (14067K kernel code, 1182K=
 rwdata, 5916K rodata, 1944K init, 5976K bss, 67680K reserved, 0K highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffa95000 - 0xfffff000   (5544 kB)
[    0.000000]     pkmap   : 0xff400000 - 0xff800000   (4096 kB)
[    0.000000]     vmalloc : 0x887fe000 - 0xff3fe000   (1900 MB)
[    0.000000]     lowmem  : 0x78000000 - 0x87ffe000   ( 255 MB)
[    0.000000]       .init : 0x796ae000 - 0x79894000   (1944 kB)
[    0.000000]       .data : 0x78fbd11b - 0x796adb00   (7106 kB)
[    0.000000]       .text : 0x78200000 - 0x78fbd11b   (14068 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] Hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3D8540c000 soft=3D8540e000
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3807 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] allocated 524288 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't wan=
t memory cgroups
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 2893.008 MHz processor
[    0.003000] Calibrating delay loop (skipped) preset value.. 5786.01 Bogo=
MIPS (lpj=3D2893008)
[    0.004010] pid_max: default: 4096 minimum: 301
[    0.005278] Security Framework initialized
[    0.006017] AppArmor: AppArmor disabled by boot time parameter
[    0.007104] Mount-cache hash table entries: 512
[    0.009546] Initializing cgroup subsys memory
[    0.010078] Initializing cgroup subsys devices
[    0.011016] Initializing cgroup subsys blkio
[    0.012012] Initializing cgroup subsys net_prio
[    0.013238] mce: CPU supports 10 MCE banks
[    0.014090] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.014090] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.014090] tlb_flushall_shift: 6
[    0.021252] Freeing SMP alternatives memory: 52K (79894000 - 798a1000)
[    0.030574] ACPI: Core revision 20130725
[    0.035680] ACPI: All ACPI Tables successfully acquired
[    0.037216] Getting VERSION: 50014
[    0.037871] Getting VERSION: 50014
[    0.038020] Getting ID: 0
[    0.039022] Getting ID: f000000
[    0.039603] Getting LVT0: 8700
[    0.040014] Getting LVT1: 8400
[    0.041011] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.042140] enabled ExtINT on CPU#0
[    0.045077] ENABLING IO-APIC IRQs
[    0.045720] init IO_APIC IRQs
[    0.046009]  apic 0 pin 0 not connected
[    0.047020] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.048047] IOAPIC[0]: Set routing entry (0-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.049048] IOAPIC[0]: Set routing entry (0-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.050042] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.051041] IOAPIC[0]: Set routing entry (0-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.053110] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.054037] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.055041] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.056042] IOAPIC[0]: Set routing entry (0-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.057038] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.058039] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.059041] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.060041] IOAPIC[0]: Set routing entry (0-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.061047] IOAPIC[0]: Set routing entry (0-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.062040] IOAPIC[0]: Set routing entry (0-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.063034]  apic 0 pin 16 not connected
[    0.064015]  apic 0 pin 17 not connected
[    0.064716]  apic 0 pin 18 not connected
[    0.065005]  apic 0 pin 19 not connected
[    0.066005]  apic 0 pin 20 not connected
[    0.067005]  apic 0 pin 21 not connected
[    0.067737]  apic 0 pin 22 not connected
[    0.068005]  apic 0 pin 23 not connected
[    0.069173] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.070005] smpboot: CPU0: Intel Common KVM processor (fam: 0f, model: 0=
6, stepping: 01)
[    0.072006] Using local APIC timer interrupts.
[    0.072006] calibrating APIC timer ...
[    0.074000] ... lapic delta =3D 6250082
[    0.074000] ... PM-Timer delta =3D 357959
[    0.074000] ... PM-Timer result ok
[    0.074000] ..... delta 6250082
[    0.074000] ..... mult: 268438977
[    0.074000] ..... calibration result: 1000013
[    0.074000] ..... CPU clock speed is 2893.0009 MHz.
[    0.074000] ..... host bus clock speed is 1000.0013 MHz.
[    0.074154] Performance Events: unsupported Netburst CPU model 6 no PMU =
driver, software events only.
[    0.080962] CPU 1 irqstacks, hard=3D85526000 soft=3D85528000
[    0.081005] smpboot: Booting Node   0, Processors  #   1 OK
[    0.002000] Initializing CPU#1
[    0.003000] kvm-clock: cpu 1, msr 0:fffd041, secondary cpu clock
[    0.003000] masked ExtINT on CPU#1
[    0.097129] Brought up 2 CPUs
[    0.097072] KVM setup async PF for cpu 1
[    0.097072] kvm-stealtime: cpu 1, msr dbf67c0
[    0.098005] smpboot: Total of 2 processors activated (11572.03 BogoMIPS)
[    0.101252] devtmpfs: initialized
[    0.104145] EVM: security.selinux
[    0.104717] EVM: security.SMACK64
[    0.105004] EVM: security.ima
[    0.105532] EVM: security.capability
[    0.107945] xor: measuring software checksum speed
[    0.118004]    pIII_sse  :  8064.000 MB/sec
[    0.128005]    prefetch64-sse:  8864.000 MB/sec
[    0.128813] xor: using function: prefetch64-sse (8864.000 MB/sec)
[    0.130311] regulator-dummy: no parameters
[    0.131457] NET: Registered protocol family 16
[    0.133983] cpuidle: using governor ladder
[    0.134005] cpuidle: using governor menu
[    0.136675] ACPI: bus type PCI registered
[    0.137057] dca service started, version 1.12.1
[    0.138081] PCI: PCI BIOS revision 2.10 entry at 0xfc6d5, last bus=3D0
[    0.170019] bio: create slab <bio-0> at 0
[    0.188018] raid6: mmxx1     2500 MB/s
[    0.205013] raid6: mmxx2     2812 MB/s
[    0.222034] raid6: sse1x1    2171 MB/s
[    0.239019] raid6: sse1x2    2804 MB/s
[    0.256009] raid6: sse2x1    4316 MB/s
[    0.273012] raid6: sse2x2    5421 MB/s
[    0.273699] raid6: using algorithm sse2x2 (5421 MB/s)
[    0.274005] raid6: using intx1 recovery algorithm
[    0.275535] ACPI: Added _OSI(Module Device)
[    0.276006] ACPI: Added _OSI(Processor Device)
[    0.277006] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.278006] ACPI: Added _OSI(Processor Aggregator Device)
[    0.282422] ACPI: EC: Look up EC in DSDT
[    0.292761] ACPI: Interpreter enabled
[    0.293020] ACPI: (supports S0 S5)
[    0.294004] ACPI: Using IOAPIC for interrupt routing
[    0.295025] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.314638] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.315014] acpi PNP0A03:00: Unable to request _OSC control (_OSC suppor=
t mask: 0x08)
[    0.316739] PCI host bridge to bus 0000:00
[    0.317000] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.317000] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.317007] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.318000] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.320009] pci_bus 0000:00: root bus resource [mem 0x80000000-0xfebffff=
f]
[    0.321083] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.323331] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.325580] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.331007] pci 0000:00:01.1: reg 0x20: [io  0xc1c0-0xc1cf]
[    0.334612] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.336503] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.337022] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.338673] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.340022] pci 0000:00:02.0: reg 0x10: [mem 0xfc000000-0xfdffffff pref]
[    0.343021] pci 0000:00:02.0: reg 0x14: [mem 0xfebf0000-0xfebf0fff]
[    0.354020] pci 0000:00:02.0: reg 0x30: [mem 0xfebe0000-0xfebeffff pref]
[    0.356535] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.359007] pci 0000:00:03.0: reg 0x10: [mem 0xfeba0000-0xfebbffff]
[    0.362007] pci 0000:00:03.0: reg 0x14: [io  0xc000-0xc03f]
[    0.371876] pci 0000:00:03.0: reg 0x30: [mem 0xfebc0000-0xfebdffff pref]
[    0.372616] pci 0000:00:04.0: [1af4:1001] type 00 class 0x010000
[    0.373000] pci 0000:00:04.0: reg 0x10: [io  0xc040-0xc07f]
[    0.374000] pci 0000:00:04.0: reg 0x14: [mem 0xfebf1000-0xfebf1fff]
[    0.381047] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.383889] pci 0000:00:05.0: reg 0x10: [io  0xc080-0xc0bf]
[    0.386007] pci 0000:00:05.0: reg 0x14: [mem 0xfebf2000-0xfebf2fff]
[    0.397493] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.400008] pci 0000:00:06.0: reg 0x10: [io  0xc0c0-0xc0ff]
[    0.403007] pci 0000:00:06.0: reg 0x14: [mem 0xfebf3000-0xfebf3fff]
[    0.414118] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.417007] pci 0000:00:07.0: reg 0x10: [io  0xc100-0xc13f]
[    0.419007] pci 0000:00:07.0: reg 0x14: [mem 0xfebf4000-0xfebf4fff]
[    0.430452] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.433006] pci 0000:00:08.0: reg 0x10: [io  0xc140-0xc17f]
[    0.436007] pci 0000:00:08.0: reg 0x14: [mem 0xfebf5000-0xfebf5fff]
[    0.446779] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.449007] pci 0000:00:09.0: reg 0x10: [io  0xc180-0xc1bf]
[    0.452007] pci 0000:00:09.0: reg 0x14: [mem 0xfebf6000-0xfebf6fff]
[    0.463154] pci 0000:00:0a.0: [8086:25ab] type 00 class 0x088000
[    0.465007] pci 0000:00:0a.0: reg 0x10: [mem 0xfebf7000-0xfebf700f]
[    0.472520] pci_bus 0000:00: on NUMA node 0
[    0.474945] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.476429] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.477636] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.479332] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.480490] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.482921] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.483017] ACPI: \_SB_.PCI0: notify handler is installed
[    0.484184] Found 1 acpi root devices
[    0.488615] SCSI subsystem initialized
[    0.489087] libata version 3.00 loaded.
[    0.490190] ACPI: bus type USB registered
[    0.491082] usbcore: registered new interface driver usbfs
[    0.492052] usbcore: registered new interface driver hub
[    0.493157] usbcore: registered new device driver usb
[    0.494307] pps_core: LinuxPPS API ver. 1 registered
[    0.495005] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo =
Giometti <giometti@linux.it>
[    0.496036] PTP clock support registered
[    0.497312] wmi: Mapper loaded
[    0.498058] PCI: Using ACPI for IRQ routing
[    0.499005] PCI: pci_cache_line_size set to 64 bytes
[    0.500369] e820: reserve RAM buffer [mem 0x0009fc00-0x0009ffff]
[    0.501009] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    0.503365] NET: Registered protocol family 23
[    0.504110] Bluetooth: Core ver 2.16
[    0.504779] NET: Registered protocol family 31
[    0.505004] Bluetooth: HCI device and connection manager initialized
[    0.506022] Bluetooth: HCI socket layer initialized
[    0.507015] Bluetooth: L2CAP socket layer initialized
[    0.508044] Bluetooth: SCO socket layer initialized
[    0.509007] NET: Registered protocol family 8
[    0.510004] NET: Registered protocol family 20
[    0.511068] NetLabel: Initializing
[    0.511679] NetLabel:  domain hash size =3D 128
[    0.512004] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.513108] NetLabel:  unlabeled traffic allowed by default
[    0.514005] nfc: nfc_init: NFC Core ver 0.1
[    0.515106] NET: Registered protocol family 39
[    0.517664] Switched to clocksource kvm-clock
[    0.518273] FS-Cache: Loaded
[    0.519029] CacheFiles: Loaded
[    0.519676] pnp: PnP ACPI init
[    0.520276] ACPI: bus type PNP registered
[    0.521050] IOAPIC[0]: Set routing entry (0-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    0.522572] pnp 00:00: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.523764] IOAPIC[0]: Set routing entry (0-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    0.525281] pnp 00:01: Plug and Play ACPI device, IDs PNP0303 (active)
[    0.526491] IOAPIC[0]: Set routing entry (0-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    0.527945] pnp 00:02: Plug and Play ACPI device, IDs PNP0f13 (active)
[    0.529213] IOAPIC[0]: Set routing entry (0-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    0.530591] pnp 00:03: [dma 2]
[    0.531232] pnp 00:03: Plug and Play ACPI device, IDs PNP0700 (active)
[    0.532458] IOAPIC[0]: Set routing entry (0-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    0.533957] pnp 00:04: Plug and Play ACPI device, IDs PNP0400 (active)
[    0.535186] IOAPIC[0]: Set routing entry (0-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    0.536653] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    0.538515] pnp 00:06: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.540037] pnp: PnP ACPI: found 7 devices
[    0.540747] ACPI: bus type PNP unregistered
[    0.577623] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.578579] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.579541] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.580617] pci_bus 0000:00: resource 7 [mem 0x80000000-0xfebfffff]
[    0.582033] NET: Registered protocol family 2
[    0.583490] TCP established hash table entries: 2048 (order: 2, 16384 by=
tes)
[    0.584756] TCP bind hash table entries: 2048 (order: 4, 90112 bytes)
[    0.586038] TCP: Hash tables configured (established 2048 bind 2048)
[    0.587255] TCP: reno registered
[    0.587802] UDP hash table entries: 128 (order: 1, 12288 bytes)
[    0.588835] UDP-Lite hash table entries: 128 (order: 1, 12288 bytes)
[    0.590324] NET: Registered protocol family 1
[    0.591662] RPC: Registered named UNIX socket transport module.
[    0.592804] RPC: Registered udp transport module.
[    0.593739] RPC: Registered tcp transport module.
[    0.594585] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.595731] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.596888] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.598041] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.599191] pci 0000:00:02.0: Boot video device
[    0.600137] PCI: CLS 0 bytes, default 64
[    0.601376] Unpacking initramfs...
[    1.839331] Freeing initrd memory: 25284K (8673f000 - 87ff0000)
[    1.841676] kvm: no hardware support
[    1.842617] Machine check injector initialized
[    1.844452] cryptomgr_test (24) used greatest stack depth: 7364 bytes le=
ft
[    1.846127] PCLMULQDQ-NI instructions are not detected.
[    1.847149] The force parameter has not been set to 1. The Iris poweroff=
 handler will not be installed.
[    1.850680] Initializing RT-Tester: OK
[    1.852090] audit: initializing netlink socket (disabled)
[    1.853126] type=3D2000 audit(1384311413.078:1): initialized
[    1.854829] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    1.856765] VFS: Disk quotas dquot_6.5.2
[    1.857675] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.859879] DLM installed
[    1.862601] FS-Cache: Netfs 'nfs' registered for caching
[    1.864882] Key type cifs.spnego registered
[    1.865784] Key type cifs.idmap registered
[    1.866783] JFS: nTxBlock =3D 1714, nTxLock =3D 13712
[    1.869116] 9p: Installing v9fs 9p2000 file system support
[    1.870210] FS-Cache: Netfs '9p' registered for caching
[    1.871355] NILFS version 2 loaded
[    1.871959] OCFS2 1.5.0
[    1.872833] ocfs2: Registered cluster interface o2cb
[    1.873814] OCFS2 DLMFS 1.5.0
[    1.874592] OCFS2 User DLM kernel interface loaded
[    1.875456] OCFS2 Node Manager 1.5.0
[    1.876516] OCFS2 DLM 1.5.0
[    1.877691] bio: create slab <bio-1> at 1
[    1.879234] Btrfs loaded, debug=3Don, assert=3Don
[    1.879992] btrfs: selftest: Running btrfs free space cache tests
[    1.881092] btrfs: selftest: Running extent only tests
[    1.882115] btrfs: selftest: Running bitmap only tests
[    1.883082] btrfs: selftest: Running bitmap and extent tests
[    1.884168] btrfs: selftest: Free space cache tests finished
[    1.886137] GFS2 installed
[    1.894813] NET: Registered protocol family 38
[    1.895729] Key type asymmetric registered
[    1.896766] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 251)
[    1.898334] io scheduler noop registered (default)
[    1.899228] io scheduler deadline registered
[    1.900187] io scheduler cfq registered
[    1.900967] list_sort_test: start testing list_sort()
[    1.902676] test_string_helpers: Running tests...
[    1.910481] crc32: CRC_LE_BITS =3D 1, CRC_BE BITS =3D 1
[    1.911398] crc32: self tests passed, processed 225944 bytes in 3355690 =
nsec
[    1.916352] crc32c: CRC_LE_BITS =3D 1
[    1.916954] crc32c: self tests passed, processed 225944 bytes in 1786916=
 nsec
[    1.918818] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.919828] cpqphp: Compaq Hot Plug PCI Controller Driver version: 0.9.8
[    1.921276] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    1.922951] rivafb_setup START
[    1.923762] VIA Graphics Integration Chipset framebuffer 2.4 initializing
[    1.925482] no IO addresses supplied
[    1.927060] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM =
(4096 kB) at 0xfc000000
[    1.929301] usbcore: registered new interface driver smscufx
[    1.930842] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[    1.932191] ACPI: Power Button [PWRF]
[    1.933630] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    1.935312] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.959704] 00:05: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 115200) =
is a 16550A
[    1.962908] Cyclades driver 2.6
[    1.963668] MOXA Intellio family driver version 6.0k
[    1.964758] Initializing Nozomi driver 2.1d
[    1.965716] RocketPort device driver module, version 2.09, 12-June-2003
[    1.966994] No rocketport ports found; unloading driver
[    1.967940] SyncLink GT
[    1.968511] SyncLink GT, tty major#247
[    1.969334] SyncLink GT no devices found
[    1.970038] SyncLink MultiPort driver $Revision: 4.38 $
[    1.991650] SyncLink MultiPort driver $Revision: 4.38 $, tty major#246
[    1.992914] SyncLink serial driver $Revision: 4.38 $
[    2.014459] SyncLink serial driver $Revision: 4.38 $, tty major#245
[    2.016304] lp: driver loaded but no devices found
[    2.017185] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[    2.018539] ac.o: No PCI boards found.
[    2.019214] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[    2.020572] toshiba: not a supported Toshiba laptop
[    2.021533] ppdev: user-space parallel port driver
[    2.022519] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[    2.023821] platform pc8736x_gpio.0: no device found
[    2.024938] nsc_gpio initializing
[    2.025688] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 secon=
ds, margin is 60 seconds).
[    2.027330] Hangcheck: Using getrawmonotonic().
[    2.028425] [drm] Initialized drm 1.1.0 20060810
[    2.029682] [drm] radeon kernel modesetting enabled.
[    2.031290] parport_pc 00:04: reported by Plug and Play ACPI
[    2.032493] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
[    2.034306] lp0: using parport0 (interrupt-driven).
[    2.036300] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
[    2.037652] dummy-irq: no IRQ given.  Use irq=3DN
[    2.038537] lkdtm: No crash points registered, enable through debugfs
[    2.039760] Phantom Linux Driver, version n0.9.8, init OK
[    2.041053] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[    2.042572] c2port c2port0: C2 port uc added
[    2.043343] c2port c2port0: uc flash has 30 blocks x 512 bytes (15360 by=
tes total)
[    2.045103] Guest personality initialized and is inactive
[    2.046345] VMCI host device registered (name=3Dvmci, major=3D10, minor=
=3D59)
[    2.047550] Initialized host personality
[    2.048876] usbcore: registered new interface driver viperboard
[    2.050873] Loading iSCSI transport class v2.0-870.
[    2.053281] iscsi: registered transport (tcp)
[    2.054492] Adaptec aacraid driver 1.2-0[30200]-ms
[    2.056474] isci: Intel(R) C600 SAS Controller Driver - version 1.1.0
[    2.058000] scsi: <fdomain> Detection failed (no card)
[    2.060780] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[    2.061891] IOAPIC[0]: Set routing entry (0-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:3)
[    2.064892] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    2.066032] IOAPIC[0]: Set routing entry (0-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:3)
[    2.069105] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
[    2.071679] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    2.545544] DC390: clustering now enabled by default. If you get problem=
s load
[    2.546879]        with "disable_clustering=3D1" and report to maintaine=
rs
[    2.548222] megasas: 06.700.06.00-rc1 Sat. Aug. 31 17:00:00 PDT 2013
[    2.549565] GDT-HA: Storage RAID Controller Driver. Version: 3.05
[    2.550768] 3ware Storage Controller device driver for Linux v1.26.02.00=
3.
[    2.552074] imm: Version 2.05 (for Linux 2.4.0)
[    2.553713] ipr: IBM Power RAID SCSI Device Driver version: 2.6.0 (Novem=
ber 16, 2012)
[    2.555181] RocketRAID 3xxx/4xxx Controller driver v1.8
[    2.556238] stex: Promise SuperTrak EX Driver version: 4.6.0000.4
[    2.557425] libcxgbi:libcxgbi_init_module: tag itt 0x1fff, 13 bits, age =
0xf, 4 bits.
[    2.558846] libcxgbi:ddp_setup_host_page_size: system PAGE 4096, ddp idx=
 0.
[    2.560162] Chelsio T3 iSCSI Driver cxgb3i v2.0.0 (Jun. 2010)
[    2.561285] iscsi: registered transport (cxgb3i)
[    2.562217] Chelsio T4/T5 iSCSI Driver cxgb4i v0.9.4
[    2.563206] iscsi: registered transport (cxgb4i)
[    2.564182] iscsi: registered transport (be2iscsi)
[    2.565048] In beiscsi_module_init, tt=3D7960ed3c
[    2.566077] esas2r: driver will not be loaded because no ATTO esas2r dev=
ices were found
[    2.567953] SCSI Media Changer driver v0.25=20
[    2.571493] scsi_debug: host protection
[    2.572336] scsi0 : scsi_debug, version 1.82 [20100324], dev_size_mb=3D8=
, opts=3D0x0
[    2.574455] BUG: unable to handle kernel NULL pointer dereference at 000=
00008
[    2.575017] IP: [<78287084>] lockdep_init_map+0xd/0x544
[    2.575017] *pde =3D 00000000=20
[    2.575017] Oops: 0002 [#1] SMP=20
[    2.575017] CPU: 0 PID: 23 Comm: kworker/0:1 Not tainted 3.12.0-00187-g9=
d0d532 #1
[    2.575017] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.575017] Workqueue: events tg_stats_alloc_fn
[    2.575017] task: 8567a030 ti: 856cc000 task.ti: 856cc000
[    2.575017] EIP: 0060:[<78287084>] EFLAGS: 00010296 CPU: 0
[    2.575017] EIP is at lockdep_init_map+0xd/0x544
[    2.575017] EAX: 00000004 EBX: 79d614b0 ECX: 79d614b0 EDX: 793fba74
[    2.575017] ESI: 00000004 EDI: 79d614b8 EBP: 856cde90 ESP: 856cde78
[    2.575017]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    2.575017] CR0: 8005003b CR2: 00000008 CR3: 018a4000 CR4: 000006d0
[    2.575017] Stack:
[    2.575017]  0000014a 0000014b 85622380 00000000 00000000 79d614b8 856cd=
eac 785fae1d
[    2.575017]  00000000 795aea60 85622380 00000000 00000000 856cdef8 7826b=
ae8 00000000
[    2.575017]  00000001 00000000 7826ba8f 854a7a00 85bf0700 795aea60 85bef=
380 795aea60
[    2.575017] Call Trace:
[    2.575017]  [<785fae1d>] tg_stats_alloc_fn+0xe3/0x155
[    2.575017]  [<7826bae8>] process_one_work+0x1ef/0x349
[    2.575017]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    2.575017]  [<7826c039>] worker_thread+0x1a3/0x274
[    2.575017]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    2.575017]  [<78270649>] kthread+0x8a/0x8f
[    2.575017]  [<78270000>] ? SyS_timer_gettime+0x43/0x9e
[    2.575017]  [<78fbac7b>] ret_from_kernel_thread+0x1b/0x30
[    2.575017]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    2.575017] Code: f0 8b 7d e8 64 ff 0d 68 d7 74 79 89 70 10 89 78 14 e9 =
9b fe ff ff 8d 65 f4 5b 5e 5f 5d c3 55 89 e5 57 56 89 c6 53 89 cb 83 ec 0c =
<c7> 40 04 00 00 00 00 c7 40 08 00 00 00 00 64 a1 10 d0 74 79 89
[    2.575017] EIP: [<78287084>] lockdep_init_map+0xd/0x544 SS:ESP 0068:856=
cde78
[    2.575017] CR2: 0000000000000008
[    2.609817] ---[ end trace 7fb3ec8edd1e1f51 ]---
[    2.610145] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       00=
04 PQ: 0 ANSI: 5
[    2.610698] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.611445] SSFDC read-only Flash Translation layer
[    2.611524] device id =3D 2440
[    2.611528] device id =3D 2480
[    2.611532] device id =3D 24c0
[    2.611536] device id =3D 24d0
[    2.611540] device id =3D 25a1
[    2.611543] device id =3D 2670
[    2.611608] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    2.611678] Ramix PMC551 PCI Mezzanine Ram Driver. (C) 1999,2000 Nortel =
Networks.
[    2.611682] pmc551: not detected
[    2.613285] Spectra MTD driver built on Nov 13 2013 @ 10:54:17
[    2.621685] kworker/0:1 (23) used greatest stack depth: 6448 bytes left
[    2.622968] BUG: unable to handle kernel paging request at ffffffc8
[    2.623933] IP: [<78270787>] kthread_data+0xa/0xe
[    2.623933] *pde =3D 01e83067 *pte =3D 00000000=20
[    2.623933] Oops: 0000 [#2] SMP=20
[    2.623933] CPU: 0 PID: 23 Comm: kworker/0:1 Tainted: G      D      3.12=
=2E0-00187-g9d0d532 #1
[    2.623933] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[    2.623933] task: 8567a030 ti: 856cc000 task.ti: 856cc000
[    2.623933] EIP: 0060:[<78270787>] EFLAGS: 00010002 CPU: 0
[    2.623933] EIP is at kthread_data+0xa/0xe
[    2.623933] EAX: 00000000 EBX: 00000000 ECX: 798b3858 EDX: 00000000
[    2.623933] ESI: 8567a030 EDI: 00000000 EBP: 856cdc74 ESP: 856cdc6c
[    2.623933]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    2.623933] CR0: 8005003b CR2: 00000014 CR3: 018a4000 CR4: 000006d0
[    2.623933] Stack:
[    2.623933]  7826b5d8 8567a2e4 856cdce8 78fb5ac8 79892a00 79892a00 856cd=
ca4 78fa3a0e
[    2.623933]  854a3880 85befa00 8567a030 854a1a80 856cdca4 78295bba 856cd=
cc0 00000202
[    2.623933]  00000002 00000202 8567a030 8567a030 00000000 856cdccc 78295=
df5 00000000
[    2.623933] Call Trace:
[    2.623933]  [<7826b5d8>] ? wq_worker_sleeping+0xb/0x6e
[    2.623933]  [<78fb5ac8>] __schedule+0x104/0x797
[    2.623933]  [<78fa3a0e>] ? cache_flusharray+0xc0/0xc8
[    2.623933]  [<78295bba>] ? rcu_is_watching+0xf/0x18
[    2.623933]  [<78295df5>] ? call_rcu_sched+0xf/0x12
[    2.623933]  [<7825c3fd>] ? release_task+0x2d8/0x2eb
[    2.623933]  [<78fb61ad>] schedule+0x52/0x54
[    2.623933]  [<7825d886>] do_exit+0x73d/0x76c
[    2.623933]  [<7822daf1>] oops_end+0xdc/0x109
[    2.623933]  [<78fa2003>] no_context+0x161/0x16b
[    2.651466] No valid DiskOnChip devices found
[    2.651489] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    2.651490] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    2.651492] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    2.651493] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    2.651494] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    2.651495] [nandsim] warning: read_byte: unexpected data output cycle, =
state is STATE_READY return 0x0
[    2.651499] NAND device: Manufacturer ID: 0x98, Chip ID: 0x39 (Toshiba N=
AND 128MiB 1,8V 8-bit), 128MiB, page size: 512, OOB size: 16
[    2.651657] flash size: 128 MiB
[    2.651658] page size: 512 bytes
[    2.651659] OOB area size: 16 bytes
[    2.651659] sector size: 16 KiB
[    2.651660] pages number: 262144
[    2.651661] pages per sector: 32
[    2.651662] bus width: 8
[    2.651662] bits in sector size: 14
[    2.651663] bits in page size: 9
[    2.651664] bits in OOB size: 4
[    2.651665] flash size with OOB: 135168 KiB
[    2.651665] page address bytes: 4
[    2.651666] sector address bytes: 3
[    2.651667] options: 0x42
[    2.623933]  [<78250d78>] ? kvm_clock_read+0x1f/0x29
[    2.623933]  [<78fa2269>] __bad_area_nosemaphore+0x13d/0x147
[    2.623933]  [<782508e2>] ? kvm_read_and_reset_pf_reason+0x39/0x39
[    2.623933]  [<78fa2280>] bad_area_nosemaphore+0xd/0x10
[    2.623933]  [<78252aaf>] __do_page_fault+0x28a/0x3f6
[    2.623933]  [<7827b870>] ? sched_clock_cpu+0x105/0x113
[    2.623933]  [<782508e2>] ? kvm_read_and_reset_pf_reason+0x39/0x39
[    2.623933]  [<78252d5d>] do_page_fault+0x8/0xa
[    2.623933]  [<78250905>] do_async_page_fault+0x23/0x61
[    2.623933]  [<78fbaa7a>] error_code+0x5a/0x60
[    2.623933]  [<782508e2>] ? kvm_read_and_reset_pf_reason+0x39/0x39
[    2.623933]  [<78287084>] ? lockdep_init_map+0xd/0x544
[    2.623933]  [<785fae1d>] tg_stats_alloc_fn+0xe3/0x155
[    2.623933]  [<7826bae8>] process_one_work+0x1ef/0x349
[    2.623933]  [<7826ba8f>] ? process_one_work+0x196/0x349
[    2.623933]  [<7826c039>] worker_thread+0x1a3/0x274
[    2.623933]  [<7826be96>] ? rescuer_thread+0x233/0x233
[    2.623933]  [<78270649>] kthread+0x8a/0x8f
[    2.623933]  [<78270202>] ? SyS_timer_delete+0x61/0xd9
[    2.623933]  [<78fbac7b>] ret_from_kernel_thread+0x1b/0x30
[    2.623933]  [<782705bf>] ? __kthread_parkme+0x50/0x50
[    2.623933] Code: ba 72 00 00 00 53 89 c3 b8 62 a1 38 79 e8 68 a4 00 00 =
85 db 74 03 c6 03 00 e8 aa ff ff ff 5b 5d c3 55 8b 80 88 02 00 00 89 e5 5d =
<8b> 40 c8 c3 55 b9 04 00 00 00 89 e5 52 8b 90 88 02 00 00 8d 45
[    2.623933] EIP: [<78270787>] kthread_data+0xa/0xe SS:ESP 0068:856cdc6c
[    2.623933] CR2: 00000000ffffffc8
[    2.623933] ---[ end trace 7fb3ec8edd1e1f52 ]---
[    2.623933] Fixing recursive fault but reboot is needed!

Elapsed time: 10
qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-j=
7-11082318/9d0d532888f6e77970016c0c270ddececfab8f9e/vmlinuz-3.12.0-00187-g9=
d0d532 -append 'hung_task_panic=3D1 rcutree.rcu_cpu_stall_timeout=3D100 log=
_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebug dynamic_printk=
 sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 console=3DttyS0,115200=
 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3D/kernel-tests/run-=
queue/kvm/i386-randconfig-j7-11082318/wfg:fix-blkg_stat_init/.vmlinuz-9d0d5=
32888f6e77970016c0c270ddececfab8f9e-20131113105621-85-cairo branch=3Dwfg/fi=
x-blkg_stat_init BOOT_IMAGE=3D/kernel/i386-randconfig-j7-11082318/9d0d53288=
8f6e77970016c0c270ddececfab8f9e/vmlinuz-3.12.0-00187-g9d0d532'  -initrd /ke=
rnel-tests/initrd/quantal-core-i386.cgz -m 256M -smp 2 -net nic,vlan=3D1,mo=
del=3De1000 -net user,vlan=3D1 -boot order=3Dnc -no-reboot -watchdog i6300e=
sb -drive file=3D/fs/LABEL=3DKVM/disk0-quantal-cairo-10,media=3Ddisk,if=3Dv=
irtio -drive file=3D/fs/LABEL=3DKVM/disk1-quantal-cairo-10,media=3Ddisk,if=
=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk2-quantal-cairo-10,media=3Ddisk=
,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk3-quantal-cairo-10,media=3Dd=
isk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk4-quantal-cairo-10,media=
=3Ddisk,if=3Dvirtio -drive file=3D/fs/LABEL=3DKVM/disk5-quantal-cairo-10,me=
dia=3Ddisk,if=3Dvirtio -pidfile /dev/shm/kboot/pid-quantal-cairo-10 -serial=
 file:/dev/shm/kboot/serial-quantal-cairo-10 -daemonize -display none -moni=
tor null=20

--YiEDa0DAkWCtVeE4--
