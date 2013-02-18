Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab3BRBhr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 20:37:47 -0500
Received: from mga11.intel.com ([192.55.52.93]:19345 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756546Ab3BRBhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 20:37:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,683,1355126400"; 
   d="log'?scan'208";a="288398014"
Date: Mon, 18 Feb 2013 09:37:20 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Ben Skeggs <bskeggs@redhat.com>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: WARNING: at kernel/mutex.c:386 __mutex_lock_common()
Message-ID: <20130218013720.GC10963@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

I got the below warning and the first bad commit is

commit 11eb5a2ce9655ee552f705f2da6b8f96f466c0d4
Author: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Date:   Wed Nov 7 11:53:51 2012 +0100

    mutex: add support for reservation style locks
    
    GPU's do operations that commonly involve many buffers.  Those buffers
    can be shared across contexts/processes, exist in different memory
    domains (for example VRAM vs system memory), and so on.  And with
    PRIME / dmabuf, they can even be shared across devices.  So there are
    a handful of situations where the driver needs to wait for buffers to
    become ready.  If you think about this in terms of waiting on a buffer
    mutex for it to become available, this presents a problem because
    there is no way to guarantee that buffers appear in a execbuf/batch in
    the same order in all contexts.  That is directly under control of
    userspace, and a result of the sequence of GL calls that an application
    makes.  Which results in the potential for deadlock.  The problem gets
    more complex when you consider that the kernel may need to migrate the
    buffer(s) into VRAM before the GPU operates on the buffer(s), which
    may in turn require evicting some other buffers (and you don't want to
    evict other buffers which are already queued up to the GPU), but for a
    simplified understanding of the problem you can ignore this.
    
    The algorithm that TTM came up with for dealing with this problem is
    quite simple.  For each group of buffers (execbuf) that need to be
    locked, the caller would be assigned a unique reservation_id, from a
    global counter.  In case of deadlock in the process of locking all the
    buffers associated with a execbuf, the one with the lowest
    reservation_id wins, and the one with the higher reservation_id
    unlocks all of the buffers that it has already locked, and then tries
    again.
    
    How it is used:
    ---------------
    
    A very simplified version:
    
        int lock_execbuf(execbuf)
        {
            struct buf *res_buf = NULL;
    
            /* acquiring locks, before queuing up to GPU: */
            seqno = assign_global_seqno();
    
        retry:
            for (buf in execbuf->buffers) {
                if (buf == res_buf) {
                    res_buf = NULL;
                    continue;
                }
                ret = mutex_reserve_lock(&buf->lock, seqno);
                if (ret < 0)
                    goto err;
            }
    
            /* now everything is good to go, submit job to GPU: */
            ...
    
            return 0;
    
        err:
            for (all buf2 before buf in execbuf->buffers)
                mutex_unreserve_unlock(&buf2->lock);
            if (res_buf)
                mutex_unreserve_unlock(&res_buf->lock);
    
            if (ret == -EAGAIN) {
                /* we lost out in a seqno race, lock and retry.. */
                mutex_reserve_lock_slow(&buf->lock, seqno);
                res_buf = buf;
                goto retry;
            }
    
            return ret;
        }
    
        int unlock_execbuf(execbuf)
        {
            /* when GPU is finished; */
            for (buf in execbuf->buffers)
                mutex_unreserve_unlock(&buf->lock);
        }
    
    Functions:
    ----------
    
    mutex_reserve_lock, and mutex_reserve_lock_interruptible:
      Lock a buffer with a reservation_id set. reservation_id must not be
      set to 0, since this is a special value that means no reservation_id.
    
      Normally if reservation_id is not set, or is older than the
      reservation_id that's currently set on the mutex, the behavior will
      be to wait normally.  However, if  the reservation_id is newer than
      the current reservation_id, -EAGAIN will be returned.
    
      These functions will return -EDEADLK instead of -EAGAIN if
      reservation_id is the same as the reservation_id that's attempted to
      lock the mutex with, since in that case you presumably attempted to
      lock the same lock twice.
    
    mutex_reserve_lock_slow and mutex_reserve_lock_intr_slow:
      Similar to mutex_reserve_lock, except it won't backoff with -EAGAIN.
      This is useful when mutex_reserve_lock failed with -EAGAIN, and you
      unreserved all buffers so no deadlock can occur.
    
    mutex_unreserve_unlock:
       Unlock a buffer reserved with one of the mutex_reserve_*lock* calls.
    
    Missing at the moment, maybe TODO?
      * Check if lockdep warns if you unlock a lock that other locks were nested
        to.
        - spin_lock(m);
          spin_lock_nest_lock(a, m);
          spin_unlock(m);
          spin_unlock(a);
          It would be nice if this would give a splat on spin_unlock(m),
          I'm not 100% sure if it does right now, though..
      * In the *_slow calls, maybe add a check to ensure no other locks of the same
        lockdep class are nested in the lock we have to nest to?
        - This is making sure that mutex_unreserve_unlock have been called on all other locks.
    
    Design:
      I chose for ticket_mutex to encapsulate struct mutex, so the extra memory usage and
      atomic set on init will only happen when you deliberately create a ticket lock.
    
      Since the mutexes are mostly meant to protect buffer object serialization in ttm, not
      much contention is expected. I could be slightly smarter with wakeups, but this would
      be at the expense at adding a field to struct mutex_waiter. This would add
      overhead to all cases where normal mutexes are used, and ticket_mutexes are less
      performance sensitive anyway since they only protect buffer objects. As a result
      I chose not to do this.
    
      I needed this in kernel/mutex.c because of the extensions to __lock_common, which are
      hopefully optimized away for all normal paths.
    
      It is not illegal to use mutex_lock and mutex_unlock on ticket mutexes. This will work,
      as long you don't mix lock/unlock calls. This is useful if you want to lock only a single
      buffer.
    
      All the mutex_reserve calls are nested into another lock. The idea is that the
      seqno ticket you use functions as a lockdep class you have locked too. This will
      prevent lockdep false positives on locking 2 objects of the same class. It's allowed
      because they're nested to the seqno ticket. There are extensive tests for this in the
      patch that introduces locking tests for reservation objects and reservation tickets.
    
    Changes since RFC patch v1:
     - Updated to use atomic_long instead of atomic, since the reservation_id was a long.
     - added mutex_reserve_lock_slow and mutex_reserve_lock_intr_slow
     - removed mutex_locked_set_reservation_id (or w/e it was called)
    Changes since RFC patch v2:
     - remove use of __mutex_lock_retval_arg, add warnings when using wrong combination of
       mutex_(,reserve_)lock/unlock.
    
    Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

[    0.000000] 
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at /c/kernel-tests/src/tip/kernel/mutex.c:386 __mutex_lock_common+0x5a9/0x870()
[    0.000000] Hardware name: Bochs
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper/0 Not tainted 3.8.0-rc7-00071-g11eb5a2 #180
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81047102>] warn_slowpath_common+0xb2/0x120
[    0.000000]  [<ffffffff81047195>] warn_slowpath_null+0x25/0x30
[    0.000000]  [<ffffffff814ebdd9>] __mutex_lock_common+0x5a9/0x870
[    0.000000]  [<ffffffff81a66ef8>] ? rcu_cpu_notify+0xa8/0x451
[    0.000000]  [<ffffffff810bcb8f>] ? trace_hardirqs_off_caller+0xaf/0x120
[    0.000000]  [<ffffffff81a66ef8>] ? rcu_cpu_notify+0xa8/0x451
[    0.000000]  [<ffffffff810be38c>] ? lockdep_init_map+0xfc/0x230
[    0.000000]  [<ffffffff814ec621>] mutex_lock_nested+0x61/0x80
[    0.000000]  [<ffffffff810bcc1d>] ? trace_hardirqs_off+0x1d/0x30
[    0.000000]  [<ffffffff81a66ef8>] rcu_cpu_notify+0xa8/0x451
[    0.000000]  [<ffffffff814ecc31>] ? mutex_unlock+0x11/0x20
[    0.000000]  [<ffffffff81a3f952>] rcu_init+0x3b3/0x408
[    0.000000]  [<ffffffff81a21e0c>] start_kernel+0x34a/0x744
[    0.000000]  [<ffffffff81a216e6>] ? repair_env_string+0x81/0x81
[    0.000000]  [<ffffffff81a21120>] ? early_idt_handlers+0x120/0x120
[    0.000000]  [<ffffffff81a212fd>] x86_64_start_reservations+0x185/0x190
[    0.000000]  [<ffffffff81a214a8>] x86_64_start_kernel+0x1a0/0x1b6
[    0.000000] ---[ end trace 8e966724b1809892 ]---

git bisect start 11eb5a2ce9655ee552f705f2da6b8f96f466c0d4 836dc9e3fbbab0c30aa6e664417225f5c1fb1c39 --
git bisect good 569104e21addbec215daa2d1d2c7b2a274ebcc27  #  1000  2013-02-15 00:30:51  drm/nouveau: share fence structures between nv10+ and nv50 implementations
git bisect good dacf4c29d7e3b2e0903fdef6da8296fe51132dca  #  1000  2013-02-15 02:49:28  drm/nouveau/fifo/nvc0: improve interrupt handler somewhat
git bisect good 51fb70f904cf004272bd0a729959e4da76cb50dc  #  1000  2013-02-15 05:08:37  drm/nouveau/gpio: pass number of on-die gpio lines to base
git bisect good 38bc1653a04eeea372a4249ef58d554ce38bd0f5  #  1000  2013-02-15 07:27:46  drm/nv84-/fence: abstract class emit/sync functions to virt+sequence
git bisect good ef80d98bdcaebca98ec9790ee584f903557ca149  #  1000  2013-02-15 09:47:41  drm/nouveau/fence: make internal hooks part of the context
git bisect good 5fdd378c20bb56824d57905591f1ec93a02513b9  #  1000  2013-02-15 12:06:18  arch: make __mutex_fastpath_lock_retval return whether fastpath succeeded or not.
git bisect good 5fdd378c20bb56824d57905591f1ec93a02513b9  #  3001  2013-02-15 18:58:19  arch: make __mutex_fastpath_lock_retval return whether fastpath succeeded or not.
git bisect good 075198d07b7b64b50afb54853dc390ded9962ee4  #  3000  2013-02-16 02:12:51  Revert "mutex: add support for reservation style locks"
git bisect good be03210f1bbdde34b397e86c115511667210fe98  #  3000  2013-02-18 05:35:58  Add linux-next specific files for 20130215

Thanks,
Fengguang

--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-xbm-3830-2013-02-14-19-00-45-3.8.0-rc7-00071-g11eb5a2-180"

[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.8.0-rc7-00071-g11eb5a2 (kbuild@snb) (gcc version 4.7.2 (Debian 4.7.2-4) ) #180 SMP Thu Feb 14 18:57:23 CST 2013
[    0.000000] Command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 branch=nouveau/broken log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2013-02-14-18-57-47-nouveau:broken:a7bac5c-11eb5a2-x86_64-randconfig-s788-1-xbm BOOT_IMAGE=kernel-tests/kernels/x86_64-randconfig-s788/11eb5a2/vmlinuz-3.8.0-rc7-00071-g11eb5a2
[    0.000000] KERNEL supported cpus:
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009f3ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f400-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0xfffe max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x70406, new 0x7010600070106
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdae0-0x000fdaef] mapped at [ffff8800000fdae0]
[    0.000000]   mpc: fdaf0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffdfff]
[    0.000000]  [mem 0x00000000-0x0fdfffff] page 2M
[    0.000000]  [mem 0x0fe00000-0x0fffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffdfff @ [mem 0x0fffb000-0x0fffdfff]
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 127872(97%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] ACPI: RSDP 00000000000fd950 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 000000000fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 000000000fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 000000000fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL 20100528)
[    0.000000] ACPI: FACS 000000000fffff40 00040
[    0.000000] ACPI: SSDT 000000000ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 000000000ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 000000000ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] ACPI: SSDT 000000000ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f9000 (        fee00000)
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000000fffdfff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x0fffdfff]
[    0.000000]   NODE_DATA [mem 0x0fff7000-0x0fffafff]
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, boot clock
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x00010000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65421
[    0.000000]   DMA32 zone: 1024 pages used for memmap
[    0.000000]   DMA32 zone: 6 pages reserved
[    0.000000]   DMA32 zone: 64391 pages, LIFO batch:15
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to ffffffffff5f9000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5f8000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88000de00000 s79232 r8192 d23168 u1048576
[    0.000000] pcpu-alloc: s79232 r8192 d23168 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] kvm-clock: cpu 0, msr 0:fffd001, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr de0ce80
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 64391
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: hung_task_panic=1 rcutree.rcu_cpu_stall_timeout=100 branch=nouveau/broken log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=vmlinuz-2013-02-14-18-57-47-nouveau:broken:a7bac5c-11eb5a2-x86_64-randconfig-s788-1-xbm BOOT_IMAGE=kernel-tests/kernels/x86_64-randconfig-s788/11eb5a2/vmlinuz-3.8.0-rc7-00071-g11eb5a2
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Memory: 202612k/262136k available (5115k kernel code, 452k absent, 59072k reserved, 5160k data, 696k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 
[    0.000000] 
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at /c/kernel-tests/src/tip/kernel/mutex.c:386 __mutex_lock_common+0x5a9/0x870()
[    0.000000] Hardware name: Bochs
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper/0 Not tainted 3.8.0-rc7-00071-g11eb5a2 #180
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff81047102>] warn_slowpath_common+0xb2/0x120
[    0.000000]  [<ffffffff81047195>] warn_slowpath_null+0x25/0x30
[    0.000000]  [<ffffffff814ebdd9>] __mutex_lock_common+0x5a9/0x870
[    0.000000]  [<ffffffff81a66ef8>] ? rcu_cpu_notify+0xa8/0x451
[    0.000000]  [<ffffffff810bcb8f>] ? trace_hardirqs_off_caller+0xaf/0x120
[    0.000000]  [<ffffffff81a66ef8>] ? rcu_cpu_notify+0xa8/0x451
[    0.000000]  [<ffffffff810be38c>] ? lockdep_init_map+0xfc/0x230
[    0.000000]  [<ffffffff814ec621>] mutex_lock_nested+0x61/0x80
[    0.000000]  [<ffffffff810bcc1d>] ? trace_hardirqs_off+0x1d/0x30
[    0.000000]  [<ffffffff81a66ef8>] rcu_cpu_notify+0xa8/0x451
[    0.000000]  [<ffffffff814ecc31>] ? mutex_unlock+0x11/0x20
[    0.000000]  [<ffffffff81a3f952>] rcu_init+0x3b3/0x408
[    0.000000]  [<ffffffff81a21e0c>] start_kernel+0x34a/0x744
[    0.000000]  [<ffffffff81a216e6>] ? repair_env_string+0x81/0x81
[    0.000000]  [<ffffffff81a21120>] ? early_idt_handlers+0x120/0x120
[    0.000000]  [<ffffffff81a212fd>] x86_64_start_reservations+0x185/0x190
[    0.000000]  [<ffffffff81a214a8>] x86_64_start_kernel+0x1a0/0x1b6
[    0.000000] ---[ end trace 8e966724b1809892 ]---
[    0.000000] NR_IRQS:4352 nr_irqs:512 16
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ----------------------------------
[    0.000000] | Locking API testsuite disabled |
[    0.000000] ----------------------------------
[    0.000000] ODEBUG: 0 of 0 active objects replaced
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 3092.842 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.020000] Calibrating delay loop (skipped) preset value.. 6185.68 BogoMIPS (lpj=30928420)
[    0.020000] pid_max: default: 4096 minimum: 301
[    0.020000] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.020000] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.020000] Mount-cache hash table entries: 256
[    0.020000] Initializing cgroup subsys debug
[    0.020019] Initializing cgroup subsys blkio
[    0.020869] Initializing cgroup subsys perf_event
[    0.021880] mce: CPU supports 10 MCE banks
[    0.022697] mce: unknown CPU type - not enabling MCE support
[    0.023802] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.023802] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.023802] tlb_flushall_shift: -1
[    0.026561] Freeing SMP alternatives: 12k freed
[    0.031589] ACPI: Core revision 20121018
[    0.034094] Getting VERSION: 50014
[    0.034782] Getting VERSION: 50014
[    0.035462] Getting ID: 0
[    0.035987] Getting ID: ff000000
[    0.036633] Getting LVT0: 8700
[    0.037230] Getting LVT1: 8400
[    0.037912] enabled ExtINT on CPU#0
[    0.039849] ENABLING IO-APIC IRQs
[    0.040015] init IO_APIC IRQs
[    0.040604]  apic 2 pin 0 not connected
[    0.041365] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.042910] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.044443] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.045983] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.047521] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Active:0 Dest:1)
[    0.049061] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.050031] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.051558] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.053081] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Active:0 Dest:1)
[    0.054600] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 Active:0 Dest:1)
[    0.056157] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 Active:0 Dest:1)
[    0.057706] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.060030] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.061585] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.063142] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.064698]  apic 2 pin 16 not connected
[    0.065458]  apic 2 pin 17 not connected
[    0.066217]  apic 2 pin 18 not connected
[    0.066976]  apic 2 pin 19 not connected
[    0.067729]  apic 2 pin 20 not connected
[    0.068491]  apic 2 pin 21 not connected
[    0.069246]  apic 2 pin 22 not connected
[    0.070007]  apic 2 pin 23 not connected
[    0.070924] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.072321] smpboot: CPU0: GenuineIntel Common KVM processor (fam: 0f, model: 06, stepping: 01)
[    0.074467] Using local APIC timer interrupts.
[    0.074467] calibrating APIC timer ...
[    0.080000] ... lapic delta = 6250004
[    0.080000] ... PM-Timer delta = 357953
[    0.080000] ... PM-Timer result ok
[    0.080000] ..... delta 6250004
[    0.080000] ..... mult: 268435627
[    0.080000] ..... calibration result: 10000006
[    0.080000] ..... CPU clock speed is 3092.9620 MHz.
[    0.080000] ..... host bus clock speed is 1000.0006 MHz.
[    0.080000] Performance Events: 
[    0.080000] Testing tracer nop: PASSED
[    0.080000] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.080000] SMP alternatives: lockdep: fixing up alternatives
[    0.080000] smpboot: Booting Node   0, Processors  #1 OK
[    0.020000] kvm-clock: cpu 1, msr 0:fffd041, secondary cpu clock
[    0.020000] masked ExtINT on CPU#1
[    0.088912] Brought up 2 CPUs
[    0.088886] KVM setup async PF for cpu 1
[    0.088886] kvm-stealtime: cpu 1, msr df0ce80
[    0.090006] ----------------
[    0.090571] | NMI testsuite:
[    0.091120] --------------------
[    0.091742]   remote IPI:  ok  |
[    0.120237]    local IPI:  ok  |
[    0.180014] --------------------
[    0.180653] Good, all   2 testcases passed! |
[    0.181473] ---------------------------------
[    0.182300] smpboot: Total of 2 processors activated (12371.36 BogoMIPS)
[    0.184053] CPU0 attaching sched-domain:
[    0.184820]  domain 0: span 0-1 level CPU
[    0.185611]   groups: 0 1
[    0.186256] CPU1 attaching sched-domain:
[    0.187010]  domain 0: span 0-1 level CPU
[    0.187810]   groups: 1 0
[    0.189240] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.190088] ------------[ cut here ]------------
[    0.190975] WARNING: at /c/kernel-tests/src/tip/drivers/base/bus.c:540 bus_probe_device+0x11f/0x130()
[    0.192682] Hardware name: Bochs
[    0.193301] Modules linked in:
[    0.193916] Pid: 1, comm: swapper/0 Tainted: G        W    3.8.0-rc7-00071-g11eb5a2 #180
[    0.195423] Call Trace:
[    0.195953]  [<ffffffff81047102>] warn_slowpath_common+0xb2/0x120
[    0.197109]  [<ffffffff81047195>] warn_slowpath_null+0x25/0x30
[    0.198203]  [<ffffffff81393fff>] bus_probe_device+0x11f/0x130
[    0.199305]  [<ffffffff81391197>] device_add+0x8f7/0xa20
[    0.200014]  [<ffffffff8138ee84>] ? dev_set_name+0x44/0x50
[    0.201065]  [<ffffffff81397858>] platform_device_add+0x168/0x390
[    0.202220]  [<ffffffff81a5198f>] ? regulator_init_complete+0x245/0x245
[    0.203466]  [<ffffffff81a51a81>] regulator_dummy_init+0x54/0xdc
[    0.204596]  [<ffffffff81a51a20>] regulator_init+0x91/0x9e
[    0.205635]  [<ffffffff8100035a>] do_one_initcall+0x1aa/0x240
[    0.206729]  [<ffffffff81a223df>] kernel_init_freeable+0x1d9/0x2d0
[    0.207895]  [<ffffffff81a21665>] ? loglevel+0x46/0x46
[    0.208875]  [<ffffffff814df540>] ? rest_init+0x180/0x180
[    0.210011]  [<ffffffff814df551>] kernel_init+0x11/0x1a0
[    0.211022]  [<ffffffff814fd4bc>] ret_from_fork+0x7c/0xb0
[    0.212046]  [<ffffffff814df540>] ? rest_init+0x180/0x180
[    0.213065] ---[ end trace 8e966724b1809893 ]---
[    0.213953] BUG: unable to handle kernel NULL pointer dereference at 0000000000000014
[    0.215480] IP: [<ffffffff812d79c7>] do_raw_spin_lock+0x27/0x220
[    0.216639] PGD 0 
[    0.217073] Oops: 0000 [#1] SMP 
[    0.217751] Modules linked in:
[    0.218373] CPU 0 
[    0.218739] Pid: 1, comm: swapper/0 Tainted: G        W    3.8.0-rc7-00071-g11eb5a2 #180 Bochs Bochs
[    0.220000] RIP: 0010:[<ffffffff812d79c7>]  [<ffffffff812d79c7>] do_raw_spin_lock+0x27/0x220
[    0.220000] RSP: 0000:ffff88000012bd88  EFLAGS: 00010206
[    0.220000] RAX: ffff880000130000 RBX: 0000000000000010 RCX: 0000000000000000
[    0.220000] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000010
[    0.220000] RBP: ffff88000012bda8 R08: 0000000000000002 R09: 0000000000000000
[    0.220000] R10: 0000000000000000 R11: ffff880000130000 R12: ffffffff81a5198f
[    0.220000] R13: 0000000000000000 R14: ffffffff81766558 R15: 0000000000000010
[    0.220000] FS:  0000000000000000(0000) GS:ffff88000de00000(0000) knlGS:0000000000000000
[    0.220000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.220000] CR2: 0000000000000014 CR3: 00000000017c6000 CR4: 00000000000006b0
[    0.220000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    0.220000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    0.220000] Process swapper/0 (pid: 1, threadinfo ffff88000012a000, task ffff880000130000)
[    0.220000] Stack:
[    0.220000]  ffffffff81a5198f 0000000000000010 ffffffff81a5198f 0000000000000000
[    0.220000]  ffff88000012bdd8 ffffffff814eff7c ffffffff812ac133 ffffffff814f0e06
[    0.220000]  ffff88000007f400 ffffffff81969488 ffff88000012be18 ffffffff812ac133
[    0.220000] Call Trace:
[    0.220000]  [<ffffffff81a5198f>] ? regulator_init_complete+0x245/0x245
[    0.220000]  [<ffffffff81a5198f>] ? regulator_init_complete+0x245/0x245
[    0.220000]  [<ffffffff814eff7c>] _raw_spin_lock+0x6c/0x90
[    0.220000]  [<ffffffff812ac133>] ? kset_find_obj+0x33/0xf0
[    0.220000]  [<ffffffff814f0e06>] ? _raw_spin_unlock+0x46/0x80
[    0.220000]  [<ffffffff812ac133>] kset_find_obj+0x33/0xf0
[    0.220000]  [<ffffffff81a5198f>] ? regulator_init_complete+0x245/0x245
[    0.220000]  [<ffffffff81395a27>] driver_find+0x27/0x70
[    0.220000]  [<ffffffff81395e89>] driver_register+0x99/0x250
[    0.220000]  [<ffffffff81a5198f>] ? regulator_init_complete+0x245/0x245
[    0.220000]  [<ffffffff81397481>] platform_driver_register+0x61/0x70
[    0.220000]  [<ffffffff81a51acb>] regulator_dummy_init+0x9e/0xdc
[    0.220000]  [<ffffffff81a51a20>] regulator_init+0x91/0x9e
[    0.220000]  [<ffffffff8100035a>] do_one_initcall+0x1aa/0x240
[    0.220000]  [<ffffffff81a223df>] kernel_init_freeable+0x1d9/0x2d0
[    0.220000]  [<ffffffff81a21665>] ? loglevel+0x46/0x46
[    0.220000]  [<ffffffff814df540>] ? rest_init+0x180/0x180
[    0.220000]  [<ffffffff814df551>] kernel_init+0x11/0x1a0
[    0.220000]  [<ffffffff814fd4bc>] ret_from_fork+0x7c/0xb0
[    0.220000]  [<ffffffff814df540>] ? rest_init+0x180/0x180
[    0.220000] Code: 00 00 00 00 55 48 89 e5 48 83 ec 20 48 83 05 d0 24 19 01 01 48 83 05 08 25 19 01 01 48 89 5d e8 48 89 fb 4c 89 65 f0 4c 89 6d f8 <81> 7f 04 ad 4e ad de 0f 85 c5 01 00 00 65 48 8b 04 25 40 b8 00 
[    0.220000] RIP  [<ffffffff812d79c7>] do_raw_spin_lock+0x27/0x220
[    0.220000]  RSP <ffff88000012bd88>
[    0.220000] CR2: 0000000000000014
[    0.220008] ---[ end trace 8e966724b1809894 ]---
[    0.220886] note: swapper/0[1] exited with preempt_count 1
[    0.221934] BUG: unable to handle kernel NULL pointer dereference at           (null)
[    0.223453] IP: [<ffffffff8113e99b>] perf_event_exit_task+0x3b/0x2e0
[    0.224680] PGD 0 
[    0.225108] Oops: 0000 [#2] SMP 
[    0.225788] Modules linked in:
[    0.226407] CPU 0 
[    0.226780] Pid: 1, comm: swapper/0 Tainted: G      D W    3.8.0-rc7-00071-g11eb5a2 #180 Bochs Bochs
[    0.228534] RIP: 0010:[<ffffffff8113e99b>]  [<ffffffff8113e99b>] perf_event_exit_task+0x3b/0x2e0
[    0.230000] RSP: 0000:ffff88000012b9a8  EFLAGS: 00010202
[    0.230000] RAX: 0000000000000000 RBX: ffff880000130000 RCX: 0000000000000000
[    0.230000] RDX: ffff880000130f18 RSI: 2222222222222222 RDI: 2222222222222222
[    0.230000] RBP: ffff88000012b9e8 R08: 2222222222222222 R09: ffff880000130f60
[    0.230000] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880000130ed8
[    0.230000] R13: 0000000000000202 R14: 0000000000000000 R15: ffff880000130000
[    0.230000] FS:  0000000000000000(0000) GS:ffff88000de00000(0000) knlGS:0000000000000000
[    0.230000] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.230000] CR2: 0000000000000000 CR3: 00000000017c6000 CR4: 00000000000006b0
[    0.230000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    0.230000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    0.230000] Process swapper/0 (pid: 1, threadinfo ffff88000012a000, task ffff880000130000)
[    0.230000] Stack:
[    0.230000]  0000000000000000 ffffffff818c6160 ffff88000012b9e8 0000000000000000
[    0.230000]  ffff88000012bcd8 0000000000000202 0000000000000000 ffff880000130000
[    0.230000]  ffff88000012ba88 ffffffff8104ef33 0000000000000000 0000000000000202
[    0.230000] Call Trace:
[    0.230000]  [<ffffffff8104ef33>] do_exit+0x3c3/0xf90
[    0.230000]  [<ffffffff8104c240>] ? kmsg_dump+0x190/0x1e0
[    0.230000]  [<ffffffff8104c0e8>] ? kmsg_dump+0x38/0x1e0
[    0.230000]  [<ffffffff814f2a44>] oops_end+0xe4/0x150
[    0.230000]  [<ffffffff814e4be5>] no_context+0x2be/0x2d4
[    0.230000]  [<ffffffff814e50f8>] __bad_area_nosemaphore+0x28e/0x2a4
[    0.230000]  [<ffffffff814e51c1>] bad_area_nosemaphore+0x15/0x1e
[    0.230000]  [<ffffffff814f70b9>] __do_page_fault+0x7f9/0xa20
[    0.230000]  [<ffffffff810bcc1d>] ? trace_hardirqs_off+0x1d/0x30
[    0.230000]  [<ffffffff814f7316>] do_page_fault+0x36/0x80
[    0.230000]  [<ffffffff81a5198f>] ? regulator_init_complete+0x245/0x245
[    0.230000]  [<ffffffff814f6180>] do_async_page_fault+0x40/0x160
[    0.230000]  [<ffffffff814f18f5>] async_page_fault+0x25/0x30
[    0.230000]  [<ffffffff81a5198f>] ? regulator_init_complete+0x245/0x245
[    0.230000]  [<ffffffff812d79c7>] ? do_raw_spin_lock+0x27/0x220
[    0.230000]  [<ffffffff81a5198f>] ? regulator_init_complete+0x245/0x245
[    0.230000]  [<ffffffff81a5198f>] ? regulator_init_complete+0x245/0x245
[    0.230000]  [<ffffffff814eff7c>] _raw_spin_lock+0x6c/0x90
[    0.230000]  [<ffffffff812ac133>] ? kset_find_obj+0x33/0xf0
[    0.230000]  [<ffffffff814f0e06>] ? _raw_spin_unlock+0x46/0x80
[    0.230000]  [<ffffffff812ac133>] kset_find_obj+0x33/0xf0
[    0.230000]  [<ffffffff81a5198f>] ? regulator_init_complete+0x245/0x245
[    0.230000]  [<ffffffff81395a27>] driver_find+0x27/0x70
[    0.230000]  [<ffffffff81395e89>] driver_register+0x99/0x250
[    0.230000]  [<ffffffff81a5198f>] ? regulator_init_complete+0x245/0x245
[    0.230000]  [<ffffffff81397481>] platform_driver_register+0x61/0x70
[    0.230000]  [<ffffffff81a51acb>] regulator_dummy_init+0x9e/0xdc
[    0.230000]  [<ffffffff81a51a20>] regulator_init+0x91/0x9e
[    0.230000]  [<ffffffff8100035a>] do_one_initcall+0x1aa/0x240
[    0.230000]  [<ffffffff81a223df>] kernel_init_freeable+0x1d9/0x2d0
[    0.230000]  [<ffffffff81a21665>] ? loglevel+0x46/0x46
[    0.230000]  [<ffffffff814df540>] ? rest_init+0x180/0x180
[    0.230000]  [<ffffffff814df551>] kernel_init+0x11/0x1a0
[    0.230000]  [<ffffffff814fd4bc>] ret_from_fork+0x7c/0xb0
[    0.230000]  [<ffffffff814df540>] ? rest_init+0x180/0x180
[    0.230000] Code: a7 d8 0e 00 00 53 48 89 fb 4c 89 e7 48 83 ec 18 48 83 05 38 eb 27 01 01 e8 33 dc 3a 00 48 8b 8b 60 0f 00 00 4c 8d 8b 60 0f 00 00 <48> 8b 31 4c 39 c9 48 8d 81 88 fd ff ff 4c 8d 86 88 fd ff ff 74 
[    0.230000] RIP  [<ffffffff8113e99b>] perf_event_exit_task+0x3b/0x2e0
[    0.230000]  RSP <ffff88000012b9a8>
[    0.230000] CR2: 0000000000000000
[    0.230007] ---[ end trace 8e966724b1809895 ]---
[    0.230890] Fixing recursive fault but reboot is needed!
[    0.231893] BUG: scheduling while atomic: swapper/0/1/0x00000002
[    0.233026] INFO: lockdep is turned off.
[    0.233769] Modules linked in:
[    0.234386] Pid: 1, comm: swapper/0 Tainted: G      D W    3.8.0-rc7-00071-g11eb5a2 #180
[    0.235901] Call Trace:
[    0.236377]  [<ffffffff814e5dd9>] __schedule_bug+0x9e/0xba
[    0.237419]  [<ffffffff814ee3b4>] __schedule+0xad4/0xca0
[    0.240011]  [<ffffffff814ee6f4>] schedule+0x44/0xe0
[    0.240961]  [<ffffffff8104fa1f>] do_exit+0xeaf/0xf90
[    0.241922]  [<ffffffff8104c240>] ? kmsg_dump+0x190/0x1e0
[    0.242947]  [<ffffffff8104c0e8>] ? kmsg_dump+0x38/0x1e0
[    0.243954]  [<ffffffff814f2a44>] oops_end+0xe4/0x150
[    0.244914]  [<ffffffff814e4be5>] no_context+0x2be/0x2d4
[    0.245924]  [<ffffffff812b34c2>] ? put_dec+0x92/0xd0
[    0.246884]  [<ffffffff814e50f8>] __bad_area_nosemaphore+0x28e/0x2a4
[    0.248083]  [<ffffffff812b74b6>] ? vsnprintf+0x266/0x950
[    0.249106]  [<ffffffff814e51c1>] bad_area_nosemaphore+0x15/0x1e
[    0.250010]  [<ffffffff814f70b9>] __do_page_fault+0x7f9/0xa20
[    0.251104]  [<ffffffff8138169b>] ? wait_for_xmitr+0x5b/0x100
[    0.252187]  [<ffffffff8113e98d>] ? perf_event_exit_task+0x2d/0x2e0
[    0.253367]  [<ffffffff814f7316>] do_page_fault+0x36/0x80
[    0.254391]  [<ffffffff814f6180>] do_async_page_fault+0x40/0x160
[    0.255524]  [<ffffffff814f18f5>] async_page_fault+0x25/0x30
[    0.256598]  [<ffffffff8113e99b>] ? perf_event_exit_task+0x3b/0x2e0
[    0.257785]  [<ffffffff8113e98d>] ? perf_event_exit_task+0x2d/0x2e0
[    0.258971]  [<ffffffff8104ef33>] do_exit+0x3c3/0xf90
[    0.260010]  [<ffffffff8104c240>] ? kmsg_dump+0x190/0x1e0
[    0.261039]  [<ffffffff8104c0e8>] ? kmsg_dump+0x38/0x1e0
[    0.262046]  [<ffffffff814f2a44>] oops_end+0xe4/0x150
[    0.263008]  [<ffffffff814e4be5>] no_context+0x2be/0x2d4
[    0.264013]  [<ffffffff814e50f8>] __bad_area_nosemaphore+0x28e/0x2a4
[    0.265215]  [<ffffffff814e51c1>] bad_area_nosemaphore+0x15/0x1e
[    0.266350]  [<ffffffff814f70b9>] __do_page_fault+0x7f9/0xa20
[    0.267437]  [<ffffffff810bcc1d>] ? trace_hardirqs_off+0x1d/0x30
[    0.268577]  [<ffffffff814f7316>] do_page_fault+0x36/0x80
[    0.270011]  [<ffffffff81a5198f>] ? regulator_init_complete+0x245/0x245
[    0.271260]  [<ffffffff814f6180>] do_async_page_fault+0x40/0x160
[    0.272394]  [<ffffffff814f18f5>] async_page_fault+0x25/0x30
[    0.273469]  [<ffffffff81a5198f>] ? regulator_init_complete+0x245/0x245
[    0.274732]  [<ffffffff812d79c7>] ? do_raw_spin_lock+0x27/0x220
[    0.275854]  [<ffffffff81a5198f>] ? regulator_init_complete+0x245/0x245
[    0.277102]  [<ffffffff81a5198f>] ? regulator_init_complete+0x245/0x245
[    0.278349]  [<ffffffff814eff7c>] _raw_spin_lock+0x6c/0x90
[    0.279390]  [<ffffffff812ac133>] ? kset_find_obj+0x33/0xf0
[    0.280011]  [<ffffffff814f0e06>] ? _raw_spin_unlock+0x46/0x80
[    0.281121]  [<ffffffff812ac133>] kset_find_obj+0x33/0xf0
[    0.282149]  [<ffffffff81a5198f>] ? regulator_init_complete+0x245/0x245
[    0.283391]  [<ffffffff81395a27>] driver_find+0x27/0x70
[    0.284380]  [<ffffffff81395e89>] driver_register+0x99/0x250
[    0.285449]  [<ffffffff81a5198f>] ? regulator_init_complete+0x245/0x245
[    0.286697]  [<ffffffff81397481>] platform_driver_register+0x61/0x70
[    0.287899]  [<ffffffff81a51acb>] regulator_dummy_init+0x9e/0xdc
[    0.289033]  [<ffffffff81a51a20>] regulator_init+0x91/0x9e
[    0.290011]  [<ffffffff8100035a>] do_one_initcall+0x1aa/0x240
[    0.291107]  [<ffffffff81a223df>] kernel_init_freeable+0x1d9/0x2d0
[    0.292266]  [<ffffffff81a21665>] ? loglevel+0x46/0x46
[    0.293243]  [<ffffffff814df540>] ? rest_init+0x180/0x180
[    0.294265]  [<ffffffff814df551>] kernel_init+0x11/0x1a0
[    0.295272]  [<ffffffff814fd4bc>] ret_from_fork+0x7c/0xb0
[    0.296293]  [<ffffffff814df540>] ? rest_init+0x180/0x180

--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="11eb5a2-bisect.log"
Content-Transfer-Encoding: quoted-printable

git checkout 836dc9e3fbbab0c30aa6e664417225f5c1fb1c39
Previous HEAD position was 11eb5a2... mutex: add support for reservation st=
yle locks
HEAD is now at 836dc9e... Linux 3.8-rc7

2013-02-14-19:51:14 836dc9e3fbbab0c30aa6e664417225f5c1fb1c39 compiling
/home/wfg/linux

2013-02-14-19:52:40 detecting boot state 3.8.0-rc7-bisect #52 	2.	12..	22.	=
24	32.	42..	52..	62.	65	72.	82..	92..	102.	105	112.	122..	132..	142..	152.	=
155	162.	172..	182..	192.	199	202.	212..	222..	232.	240	242.	252..	262..	27=
2.	281	282.	292..	302..	312.	322..	332..	342.	343	352.	362..	372..	382.	383=
	392.	402..	412..	422.	423	432.	442..	452..	462.	463	472.	482..	492..	502.	=
505	512.	522..	532..	542.	545	552.	560	562.	572..	582.	586	592.	602..	612..=
	622.	626	632.	642..	652..	662.	666	672.	682..	692..	702.	706	712.	722..	73=
2..	742.	749	752.	762..	772..	782.	790	792.	802..	812..	822.	830	832.	842..=
	852.	854	862.	870	872.	882..	892.	896	902.	912..	922..	932.	937	942.	952..=
	962..	972.	977	982.	992.. SUCCESS
bisect: good commit 836dc9e3fbbab0c30aa6e664417225f5c1fb1c39
git bisect start 11eb5a2ce9655ee552f705f2da6b8f96f466c0d4 836dc9e3fbbab0c30=
aa6e664417225f5c1fb1c39 --
Previous HEAD position was 836dc9e... Linux 3.8-rc7
HEAD is now at 1e51120... userns: Convert 9p's uid/gid handling
Bisecting: 35 revisions left to test after this (roughly 5 steps)
[569104e21addbec215daa2d1d2c7b2a274ebcc27] drm/nouveau: share fence structu=
res between nv10+ and nv50 implementations
git bisect run /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-02-14-22:10:47 569104e21addbec215daa2d1d2c7b2a274ebcc27 compiling
/home/wfg/linux

2013-02-14-22:12:39 detecting boot state 3.8.0-rc7-bisect-00035-g569104e #5=
3 	10..	20.	21	30.	40..	50..	60.	61	70.	80..	90..	100.	101	110.	114	120.	13=
0..	140..	150.	153	160.	170..	180..	190.	193	200.	210..	220..	230.	234	240.=
	250..	260..	270.	276	280.	290..	300..	310.	318	320.	330..	340.	341	350.	35=
8	360.	370..	380.	381	390.	398	400.	410..	420.	423	430.	439	440.	450..	460.=
	462	470.	480..	490..	500.	504	510.	520..	530..	540.	544	550.	557	560.	570.=
=2E	580.	584	590.	599	600.	610..	620.	624	630.	639	640.	650..	660.	664	670.=
	680..	690..	700.	705	710.	720..	730.	731	740.	747	750.	760..	770.	771	780.=
	787	790.	800..	810.	811	820.	827	830.	840..	850.	852	860.	867	870.	880..	8=
90.	894	900.	907	910.	920..	930.	935	940.	948	950.	960.	961	970.	975	980.	9=
88	990.	1000.	1001 SUCCESS
Bisecting: 17 revisions left to test after this (roughly 4 steps)
[dacf4c29d7e3b2e0903fdef6da8296fe51132dca] drm/nouveau/fifo/nvc0: improve i=
nterrupt handler somewhat
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-02-15-00:30:52 dacf4c29d7e3b2e0903fdef6da8296fe51132dca compiling
/home/wfg/linux

2013-02-15-00:31:48 detecting boot state 3.8.0-rc7-bisect-00053-gdacf4c2 #5=
4 	7.	14	17.	27..	37.	42	47.	55	57.	67..	77.	82	87.	96	97.	107.	108	117.	12=
2	127.	137..	147.	148	157.	162	167.	177..	187.	189	197.	204	207.	217..	227.=
	229	237.	245	247.	257..	267.	269	277.	285	287.	297..	307.	309	317.	325	327=
=2E	337..	347.	350	357.	366	367.	377..	387.	391	397.	407..	417..	427.	432	4=
37.	447..	457..	467.	472	477.	487..	497..	507.	512	517.	526	527.	537..	547.=
	550	557.	567..	577..	587.	590	597.	607..	617..	627.	630	637.	647..	657..	6=
67.	670	677.	687..	697..	707.	712	717.	727..	737..	747.	753	757.	767..	777.=
=2E	787.	793	797.	807..	817..	827.	835	837.	847..	857..	867.	875	877.	887..=
	897..	907.	915	917.	927..	937..	947.	955	957.	967..	977..	987.	996	997. SU=
CCESS
Bisecting: 8 revisions left to test after this (roughly 3 steps)
[51fb70f904cf004272bd0a729959e4da76cb50dc] drm/nouveau/gpio: pass number of=
 on-die gpio lines to base
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-02-15-02:49:29 51fb70f904cf004272bd0a729959e4da76cb50dc compiling
/home/wfg/linux

2013-02-15-02:50:27 detecting boot state 3.8.0-rc7-bisect-00062-g51fb70f #5=
5 	10..	20.	29	30.	40..	50..	60.	70..	80..	90..	100.	110..	120..	130..	140.=
	150..	160..	170..	180.	190..	200..	210..	220.	230..	240..	250..	260.	270..=
	280..	290..	300.	310..	320..	330..	340.	350..	360..	370..	380.	383	390.	40=
0..	410..	420.	422	430.	440..	450..	460.	464	470.	480..	490..	500.	502	510.=
	520..	530..	540.	542	550.	560..	570..	580.	582	590.	600..	610..	620.	623	6=
30.	640..	650..	660.	664	670.	680..	690..	700.	704	710.	720..	730..	740.	74=
5	750.	760..	770..	780.	785	790.	800..	810..	820.	825	830.	840..	850..	860.=
	866	870.	880..	890..	900.	907	910.	920..	930..	940.	947	950.	960..	970..	9=
80.	981	990.	1000.. SUCCESS
Bisecting: 4 revisions left to test after this (roughly 2 steps)
[38bc1653a04eeea372a4249ef58d554ce38bd0f5] drm/nv84-/fence: abstract class =
emit/sync functions to virt+sequence
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-02-15-05:08:39 38bc1653a04eeea372a4249ef58d554ce38bd0f5 compiling
/home/wfg/linux

2013-02-15-05:09:36 detecting boot state 3.8.0-rc7-bisect-00066-g38bc165 #5=
6 	10.	11	20.	30..	40..	50.	51	60.	70..	80..	90.	91	100.	110..	120..	130.	1=
31	140.	150..	160..	170.	171	180.	190..	200..	210.	212	220.	230..	240..	250=
=2E	252	260.	270..	280..	290.	293	300.	310..	320..	330.	333	340.	350..	360.=
=2E	370.	375	380.	390..	400..	410.	415	420.	430..	440..	450.	455	460.	470..=
	480.	481	490.	498	500.	510..	520.	521	530.	538	540.	550..	560.	561	570.	57=
8	580.	590..	600.	602	610.	620..	630..	640.	643	650.	660..	670..	680.	685	6=
90.	700..	710..	720.	725	730.	740..	750..	760.	768	770.	780..	790.	791	800.=
	808	810.	820..	830.	831	840.	847	850.	860..	870.	871	880.	888	890.	900..	9=
10.	911	920.	928	930.	940..	950.	951	960.	968	970.	980..	990.	991	1000.	100=
8 SUCCESS
Bisecting: 2 revisions left to test after this (roughly 1 step)
[ef80d98bdcaebca98ec9790ee584f903557ca149] drm/nouveau/fence: make internal=
 hooks part of the context
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-02-15-07:27:48 ef80d98bdcaebca98ec9790ee584f903557ca149 compiling
/home/wfg/linux

2013-02-15-07:29:31 detecting boot state 3.8.0-rc7-bisect-00068-gef80d98 #5=
7 	8	10.	20..	30.	32	40.	48	50.	60..	70.	71	80.	88	90.	100..	110.	112	120.	=
129	130.	140..	150.	152	160.	168	170.	180..	190.	192	200.	210..	220..	230.	=
235	240.	250..	260..	270.	275	280.	290..	300..	310.	315	320.	330..	340.	341=
	350.	358	360.	370..	380.	381	390.	398	400.	410..	420.	422	430.	438	440.	45=
0..	460.	462	470.	480..	490..	500.	502	510.	520..	530..	540.	543	550.	560..=
	570..	580.	584	590.	600..	610..	620.	624	630.	640..	650..	660.	666	670.	68=
0..	690..	700.	707	710.	720..	730..	740.	748	750.	760..	770..	780.	788	790.=
	800..	810..	820.	828	830.	840..	850..	860.	868	870.	880..	890..	900.	910..=
	920..	930..	940.	950..	960..	970.	971	980.	990..	1000.. SUCCESS
Bisecting: 0 revisions left to test after this (roughly 1 step)
[5fdd378c20bb56824d57905591f1ec93a02513b9] arch: make __mutex_fastpath_lock=
_retval return whether fastpath succeeded or not.
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2013-02-15-09:47:43 5fdd378c20bb56824d57905591f1ec93a02513b9 compiling
/home/wfg/linux

2013-02-15-09:48:37 detecting boot state 3.8.0-rc7-bisect-00070-g5fdd378 #5=
8 	10.	16	20.	30..	40..	50.	56	60.	70..	80..	90.	97	100.	110..	120..	130.	1=
37	140.	150..	160..	170.	180..	190..	200..	210.	220..	230..	240..	250.	260.=
=2E	270..	280.	281	290.	300..	310..	320.	321	330.	340..	350..	360.	362	370.=
	380..	390..	400.	402	410.	420..	430..	440.	445	450.	460..	470..	480.	485	4=
90.	500..	510..	520.	525	530.	540..	550..	560.	566	570.	580..	590..	600.	60=
8	610.	620..	630..	640.	648	650.	660..	670.	671	680.	690..	700..	710.	712	7=
20.	730..	740..	750.	752	760.	770..	780..	790.	793	800.	810..	820..	830.	83=
3	840.	850..	860..	870.	874	880.	890..	900..	910.	915	920.	930..	940..	950.=
	955	960.	970..	980..	990.	996	1000. SUCCESS
11eb5a2ce9655ee552f705f2da6b8f96f466c0d4 is the first bad commit
commit 11eb5a2ce9655ee552f705f2da6b8f96f466c0d4
Author: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Date:   Wed Nov 7 11:53:51 2012 +0100

    mutex: add support for reservation style locks
   =20
    GPU's do operations that commonly involve many buffers.  Those buffers
    can be shared across contexts/processes, exist in different memory
    domains (for example VRAM vs system memory), and so on.  And with
    PRIME / dmabuf, they can even be shared across devices.  So there are
    a handful of situations where the driver needs to wait for buffers to
    become ready.  If you think about this in terms of waiting on a buffer
    mutex for it to become available, this presents a problem because
    there is no way to guarantee that buffers appear in a execbuf/batch in
    the same order in all contexts.  That is directly under control of
    userspace, and a result of the sequence of GL calls that an application
    makes.  Which results in the potential for deadlock.  The problem gets
    more complex when you consider that the kernel may need to migrate the
    buffer(s) into VRAM before the GPU operates on the buffer(s), which
    may in turn require evicting some other buffers (and you don't want to
    evict other buffers which are already queued up to the GPU), but for a
    simplified understanding of the problem you can ignore this.
   =20
    The algorithm that TTM came up with for dealing with this problem is
    quite simple.  For each group of buffers (execbuf) that need to be
    locked, the caller would be assigned a unique reservation_id, from a
    global counter.  In case of deadlock in the process of locking all the
    buffers associated with a execbuf, the one with the lowest
    reservation_id wins, and the one with the higher reservation_id
    unlocks all of the buffers that it has already locked, and then tries
    again.
   =20
    How it is used:
    ---------------
   =20
    A very simplified version:
   =20
        int lock_execbuf(execbuf)
        {
            struct buf *res_buf =3D NULL;
   =20
            /* acquiring locks, before queuing up to GPU: */
            seqno =3D assign_global_seqno();
   =20
        retry:
            for (buf in execbuf->buffers) {
                if (buf =3D=3D res_buf) {
                    res_buf =3D NULL;
                    continue;
                }
                ret =3D mutex_reserve_lock(&buf->lock, seqno);
                if (ret < 0)
                    goto err;
            }
   =20
            /* now everything is good to go, submit job to GPU: */
            ...
   =20
            return 0;
   =20
        err:
            for (all buf2 before buf in execbuf->buffers)
                mutex_unreserve_unlock(&buf2->lock);
            if (res_buf)
                mutex_unreserve_unlock(&res_buf->lock);
   =20
            if (ret =3D=3D -EAGAIN) {
                /* we lost out in a seqno race, lock and retry.. */
                mutex_reserve_lock_slow(&buf->lock, seqno);
                res_buf =3D buf;
                goto retry;
            }
   =20
            return ret;
        }
   =20
        int unlock_execbuf(execbuf)
        {
            /* when GPU is finished; */
            for (buf in execbuf->buffers)
                mutex_unreserve_unlock(&buf->lock);
        }
   =20
    Functions:
    ----------
   =20
    mutex_reserve_lock, and mutex_reserve_lock_interruptible:
      Lock a buffer with a reservation_id set. reservation_id must not be
      set to 0, since this is a special value that means no reservation_id.
   =20
      Normally if reservation_id is not set, or is older than the
      reservation_id that's currently set on the mutex, the behavior will
      be to wait normally.  However, if  the reservation_id is newer than
      the current reservation_id, -EAGAIN will be returned.
   =20
      These functions will return -EDEADLK instead of -EAGAIN if
      reservation_id is the same as the reservation_id that's attempted to
      lock the mutex with, since in that case you presumably attempted to
      lock the same lock twice.
   =20
    mutex_reserve_lock_slow and mutex_reserve_lock_intr_slow:
      Similar to mutex_reserve_lock, except it won't backoff with -EAGAIN.
      This is useful when mutex_reserve_lock failed with -EAGAIN, and you
      unreserved all buffers so no deadlock can occur.
   =20
    mutex_unreserve_unlock:
       Unlock a buffer reserved with one of the mutex_reserve_*lock* calls.
   =20
    Missing at the moment, maybe TODO?
      * Check if lockdep warns if you unlock a lock that other locks were n=
ested
        to.
        - spin_lock(m);
          spin_lock_nest_lock(a, m);
          spin_unlock(m);
          spin_unlock(a);
          It would be nice if this would give a splat on spin_unlock(m),
          I'm not 100% sure if it does right now, though..
      * In the *_slow calls, maybe add a check to ensure no other locks of =
the same
        lockdep class are nested in the lock we have to nest to?
        - This is making sure that mutex_unreserve_unlock have been called =
on all other locks.
   =20
    Design:
      I chose for ticket_mutex to encapsulate struct mutex, so the extra me=
mory usage and
      atomic set on init will only happen when you deliberately create a ti=
cket lock.
   =20
      Since the mutexes are mostly meant to protect buffer object serializa=
tion in ttm, not
      much contention is expected. I could be slightly smarter with wakeups=
, but this would
      be at the expense at adding a field to struct mutex_waiter. This woul=
d add
      overhead to all cases where normal mutexes are used, and ticket_mutex=
es are less
      performance sensitive anyway since they only protect buffer objects. =
As a result
      I chose not to do this.
   =20
      I needed this in kernel/mutex.c because of the extensions to __lock_c=
ommon, which are
      hopefully optimized away for all normal paths.
   =20
      It is not illegal to use mutex_lock and mutex_unlock on ticket mutexe=
s. This will work,
      as long you don't mix lock/unlock calls. This is useful if you want t=
o lock only a single
      buffer.
   =20
      All the mutex_reserve calls are nested into another lock. The idea is=
 that the
      seqno ticket you use functions as a lockdep class you have locked too=
=2E This will
      prevent lockdep false positives on locking 2 objects of the same clas=
s. It's allowed
      because they're nested to the seqno ticket. There are extensive tests=
 for this in the
      patch that introduces locking tests for reservation objects and reser=
vation tickets.
   =20
    Changes since RFC patch v1:
     - Updated to use atomic_long instead of atomic, since the reservation_=
id was a long.
     - added mutex_reserve_lock_slow and mutex_reserve_lock_intr_slow
     - removed mutex_locked_set_reservation_id (or w/e it was called)
    Changes since RFC patch v2:
     - remove use of __mutex_lock_retval_arg, add warnings when using wrong=
 combination of
       mutex_(,reserve_)lock/unlock.
   =20
    Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

:040000 040000 bd63e260bcf755ab1b760c33b71e3b9881f6108c cab9fb8ca2657a5e585=
72ad59c5298586ed77745 M	include
:040000 040000 9c3fcf59c757a8531d2380cefc8d086c75d53e88 2f827891af2be280d36=
2425da1383c39c9ae7fe1 M	kernel
bisect run success

2013-02-15-12:06:19 5fdd378c20bb56824d57905591f1ec93a02513b9 compiling
/home/wfg/linux

2013-02-15-12:06:47 detecting boot state 3.8.0-rc7-bisect-00070-g5fdd378 #5=
8 .	10..	20.	26	30.	40..	50..	60.	66	70.	80..	90..	100.	108	110.	120..	130.=
=2E	140.	148	150.	160..	170.	171	180.	190..	200..	210.	211	220.	230..	240..=
	250.	252	260.	270..	280..	290.	294	300.	310..	320..	330.	335	340.	350..	36=
0..	370.	376	380.	390..	400..	410.	418	420.	430..	440.	441	450.	458	460.	47=
0..	480.	481	490.	500..	510..	520.	521	530.	540..	550..	560.	562	570.	580..=
	590..	600.	602	610.	620..	630..	640.	643	650.	660..	670..	680.	685	690.	70=
0..	710..	720.	726	730.	740..	750..	760.	768	770.	780..	790.	791	800.	810..=
	820..	830.	831	840.	850..	860..	870.	873	880.	890..	900..	910.	913	920.	93=
0..	940..	950.	954	960.	970..	980..	990.	995	1000.	1010..	1020..	1030.	1035=
	1040.	1050..	1060..	1070.	1077	1080.	1090..	1100.	1101	1110.	1118	1120.	11=
30..	1140.	1141	1150.	1158	1160.	1170..	1180.	1181	1190.	1198	1200.	1210..	=
1220.	1223	1230.	1240..	1250..	1260.	1263	1270.	1280..	1290..	1300.	1303	13=
10.	1320..	1330..	1340.	1344	1350.	1360..	1370..	1380.	1384	1390.	1400..	14=
10..	1420.	1424	1430.	1440..	1450..	1460.	1466	1470.	1480..	1490.	1491	1500=
=2E	1507	1510.	1520..	1530.	1531	1540.	1548	1550.	1560..	1570.	1571	1580.	1=
590..	1600..	1610.	1613	1620.	1630..	1640..	1650.	1654	1660.	1670..	1680..	=
1690.	1694	1700.	1710..	1720..	1730.	1736	1740.	1750..	1760..	1770.	1776	17=
80.	1790..	1800.	1801	1810.	1817	1820.	1830..	1840.	1841	1850.	1858	1860.	1=
870..	1880.	1881	1890.	1898	1900.	1910..	1920.	1921	1930.	1940..	1950..	196=
0.	1961	1970.	1980..	1990..	2000.	2002	2010.	2020..	2030..	2040.	2044	2050.=
	2060..	2070..	2080.	2084	2090.	2100..	2110..	2120.	2124	2130.	2140..	2150.=
=2E	2160.	2164	2170.	2180..	2190..	2200.	2206	2210.	2220..	2230..	2240.	224=
6	2250.	2260..	2270.	2271	2280.	2286	2290.	2300..	2310.	2312	2320.	2330..	2=
340..	2350.	2352	2360.	2370..	2380..	2390.	2392	2400.	2410..	2420..	2430.	2=
432	2440.	2450..	2460..	2470.	2474	2480.	2490..	2500..	2510.	2516	2520.	253=
0..	2540..	2550.	2556	2560.	2570..	2580..	2590.	2596	2600.	2610..	2620..	26=
30.	2636	2640.	2650..	2660..	2670.	2676	2680.	2690..	2700..	2710.	2716	2720=
=2E	2730..	2740..	2750.	2756	2760.	2770..	2780..	2790.	2796	2800.	2810..	28=
20..	2830.	2833	2840.	2850..	2860..	2870.	2876	2880.	2890..	2900..	2910.	29=
17	2920.	2930..	2940..	2950.	2957	2960.	2970..	2980..	2990. SUCCESS
[detached HEAD 075198d] Revert "mutex: add support for reservation style lo=
cks"
 2 files changed, 16 insertions(+), 394 deletions(-)

2013-02-15-18:58:28 075198d07b7b64b50afb54853dc390ded9962ee4 compiling
/home/wfg/linux

2013-02-15-18:59:45 detecting boot state 3.8.0-rc7-bisect-00078-g075198d #5=
8 ..	10..	20.	24	30.	40..	50..	60.	65	70.	80..	90..	100.	107	110.	120..	130=
=2E.	140.	147	150.	160..	170..	180.	187	190.	200..	210..	220.	230..	240..	2=
50.	253	260.	270..	280..	290.	295	300.	310..	320..	330.	335	340.	350..	360.=
=2E	370.	375	380.	390..	400..	410.	417	420.	430..	440..	450.	458	460.	470..=
	480..	490.	498	500.	510..	520..	530.	538	540.	550..	560..	570.	580..	590..=
	600.	601	610.	620..	630..	640.	641	650.	660..	670..	680.	681	690.	700..	71=
0..	720.	721	730.	740..	750..	760.	761	770.	780..	790..	800.	801	810.	820..=
	830..	840.	842	850.	860..	870..	880.	882	890.	900..	910..	920.	923	930.	94=
0..	950..	960..	970..	980.	982	990.	999	1000.	1010..	1020..	1030..	1040..	1=
050..	1060.	1061	1070.	1072	1080.	1089	1090.	1100..	1110..	1120..	1130.	113=
9	1140.	1150..	1160..	1170..	1180..	1190.	1192	1200.	1210..	1220..	1230..	1=
240..	1250..	1260..	1270..	1280.	1286	1290.	1296	1300.	1306	1310.	1317	1320=
=2E	1329	1330.	1340..	1350..	1360..	1370..	1380..	1390.	1392	1400.	1402	141=
0.	1418	1420.	1430..	1440..	1450..	1460..	1470..	1480.	1487	1490.	1500..	15=
10..	1520..	1530.	1532	1540.	1550..	1560..	1570.	1571	1580.	1588	1589.	1598=
	1599.	1609..	1619..	1629..	1639..	1649..	1659..	1669..	1679..	1689..	1699.=
=2E	1709..	1719..	1729..	1739..	1749..	1759..	1769..	1779..	1789..	1799..	1=
809..	1818	1819	1820	1826	1829	1830	1835	1839	1840	1844	1849	1850	1854	1859=
	1860	1864	1869.	1874	1879.	1884	1889.	1894	1899.	1904	1909.	1914	1919.	192=
4	1929.	1934	1939.	1944	1949	1950	1952	1959	1960	1962	1969.	1971	1979.	1981=
	1989.	1991	1999.	2001	2009.	2011	2019.	2022	2029.	2032	2039.	2041	2049.	20=
51	2059.	2061	2069.	2072	2079.	2082	2089.	2091	2099.	2101	2109.	2111	2119.	=
2121	2129.	2131	2139.	2141	2149.	2151	2159.	2161	2168	2169	2171	2177	2179	2=
181	2184	2189	2191	2194	2199	2201	2204	2209	2211	2214	2219	2221	2223	2229	2=
231	2233	2239	2240	2242	2249	2250	2252	2259	2261	2262	2269	2271	2272	2279	2=
281	2282	2289	2291	2292	2299	2301	2302	2309	2311	2312	2319	2321	2322	2329	2=
331	2332	2339	2341	2342	2349	2351	2352	2359	2361	2362	2369	2371	2372	2379	2=
381	2382	2389	2391	2393	2399	2401	2404	2409	2411	2415	2419	2421	2425	2429	2=
431	2435	2439	2441	2445	2449	2451	2455	2459	2461	2465	2469	2471	2475	2480	2=
481	2486	2490	2491	2496	2500	2501	2506	2510	2511	2516	2520	2521	2526	2530	2=
531	2537	2540	2541	2547	2550	2552	2557	2560	2562	2568	2570	2572	2578	2580	2=
582	2588	2590	2592	2599	2601	2602	2609	2610	2612	2619	2620	2622	2629	2630	2=
632	2639	2641	2642	2649	2651	2652	2659	2661	2662	2669	2671	2672	2679	2681	2=
682	2689	2691	2693	2699	2701	2703	2709	2711	2714	2720	2721	2724	2730	2731	2=
734	2740	2741	2744	2750	2751	2754	2760	2761	2765	2770	2771	2775	2780	2781	2=
785	2790	2791	2795	2800	2801	2805	2810	2811	2816	2820	2821	2826	2830	2831	2=
836	2840	2841	2846	2850	2851	2856	2860	2861	2866	2870	2871	2876	2880	2881	2=
886	2890	2891	2896	2900	2901	2906	2910	2911	2916	2920	2921	2926	2930	2931	2=
936	2941.	2946	2951.	2957	2961.	2967	2971.	2977	2981. SUCCESS

=3D=3D=3D=3D=3D=3D=3D=3D=3D linux-next =3D=3D=3D=3D=3D=3D=3D=3D=3D
Fetching next

2013-02-16-02:27:47 be03210f1bbdde34b397e86c115511667210fe98 compiling
/home/wfg/linux

2013-02-16-02:29:58 detecting boot state 3.8.0-rc7-bisect-next-20130215 #59=
 	1	9	10.................	11	19	20..................	25	30.................=
=2E	32	39	40.................	41	49	50..................	57	60.............=
=2E....	63	69	70.................	71	79	80.................	81	87	90.......=
=2E..........	94	100..................	102	109	110.................	111	117=
	120..................	124	130..................	132	139	140...............=
=2E.	141	149	150.................	151	157	160..................	164	170....=
=2E.............	172	179	180.................	181	189	190.................	=
191	197	200..................	204	210..................	212	219	220........=
=2E........	221	229	230..................	235	240..................	242	249=
	250.................	251	259	260.................	261	267	270.............=
=2E....	274	280..................	282	289	290.................	291	299	300.=
=2E................	306	310..................	314	320..................	322=
	329	330.................	331	339	340.................	341	346	350.........=
=2E........	354	360..................	362	369	370.................	372	379	=
380.................	381	387	390..................	394	400.................=
=2E	402	409	410.................	412	419	420.................	421	427	430..=
=2E..............	431	436	440..................	444	450..................	4=
52	459	460.................	462	469	470.................	471	477	480.......=
=2E..........	484	490..................	492	499	500.................	502	50=
9	510.................	511	517	520..................	525	530...............=
=2E..	532	540..................	542	549	550.................	551	557	560...=
=2E..............	565	570..................	573	580..................	582	5=
89	590.................	591	597	600.................	601	606	610...........=
=2E......	614	620..................	622	629	630.................	632	638	64=
0.................	641	647	650..................	654	660..................	=
662	669	670.................	672	679	680.................	681	687	690......=
=2E...........	695	700..................	702	709	710.................	712	7=
19	720.................	721	727	730.................	731	736	740...........=
=2E......	742	750..................	752	759	760.................	761	767	77=
0.................	771	776	780..................	784	790..................	=
792	799	800.................	802	808	810.................	811	817	820......=
=2E...........	824	830..................	832	839	840.................	842	8=
49	850.................	851	857	860..................	865	870..............=
=2E...	872	880..................	882	889	890.................	891	897	900..=
=2E...............	905	910..................	912	920..................	922	=
929	930.................	931	937	940.................	941	946	950..........=
=2E.......	952	960..................	962	969	970.................	972	977	9=
80.................	981	987	990..................	993	1000.................=
=2E	1002	1009	1010.................	1012	1018	1020.................	1021	10=
27	1030..................	1033	1040..................	1042	1049	1050.......=
=2E.........	1052	1059	1060.................	1061	1067	1070................=
=2E.	1075	1080..................	1082	1089	1090.................	1092	1099	=
1100.................	1101	1107	1110.................	1111	1116	1120.......=
=2E..........	1122	1130..................	1132	1139	1140.................	1=
141	1147	1150.................	1151	1156	1160..................	1162	1170..=
=2E...............	1172	1179	1180.................	1182	1188	1190..........=
=2E......	1191	1197	1200..................	1202	1210..................	1212=
	1219	1220.................	1222	1229	1230.................	1231	1237	1240.=
=2E................	1244	1250..................	1252	1259	1260.............=
=2E...	1262	1269	1270.................	1271	1277	1280..................	128=
5	1290..................	1292	1300..................	1302	1309	1310........=
=2E........	1311	1317	1320..................	1322	1330..................	13=
32	1339	1340.................	1341	1347	1350.................	1351	1352	136=
0..................	1362	1370..................	1372	1380..................=
	1381	1387	1390.................	1391	1392	1400..................	1402	1410=
=2E.................	1412	1420..................	1422	1427	1430............=
=2E....	1431	1432	1440..................	1442	1450..................	1452	1=
460..................	1462	1467	1470.................	1471	1474	1480.......=
=2E..........	1482	1490..................	1492	1500..................	1502	=
1507	1510.................	1511	1515	1520.................	1521	1522	1530..=
=2E...............	1532	1540..................	1542	1549	1550..............=
=2E..	1551	1557	1560..............................	1561	1564	1570..........=
=2E........	1571	1572	1580..................	1582	1590..................	15=
92	1600..........................................	1602	1610................=
=2E.	1612	1617	1620.................	1621	1626	1630.................	1631	1=
632	1640..................	1642	1650..................	1652	1657	1660......=
=2E..........	1661	1664	1670..................	1672	1677.	1680.............=
=2E....	1682	1689	1690.................	1692	1697	1700.................	170=
1.	1707	1710.................	1711	1712	1720.................	1721	1722	173=
0.................	1731	1732	1737	1740................	1741.	1747	1750.....=
=2E...........	1751	1752	1760.................	1761	1762	1770..............=
=2E..	1771	1772	1777	1780................	1781.	1787	1790................	1=
791.	1792	1800.................	1801	1802	1810.................	1811	1812	1=
817	1820................	1821.	1827	1830................	1831.	1832	1840...=
=2E.............	1841	1842	1850.................	1851	1852	1857	1860.......=
=2E........	1861	1862	1865	1870................	1871.	1872	1880............=
=2E....	1881	1882	1890.................	1891	1892	1897	1900................=
	1901	1902	1905	1910................	1911.	1912	1920.................	1921	=
1922	1930.................	1931	1932	1937	1940................	1941	1942	19=
47	1950................	1951.	1952	1960.................	1961	1962	1970....=
=2E............	1971	1972	1977	1980................	1981	1982	1987	1990....=
=2E...........	1991.	1992	2000................	2001.	2002	2010.............=
=2E...	2011	2012	2018	2020................	2021	2022	2027	2030.............=
=2E..	2031.	2032	2040.................	2041	2042	2050.................	2051=
=2E	2052	2060.................	2061	2062	2070.................	2071	2072	20=
77	2080................	2081	2082.	2090.................	2091	2092	2100....=
=2E............	2101	2102	2110.................	2111	2112	2117	2120........=
=2E.......	2121	2122.	2130.................	2131	2132	2140.................=
	2141	2142	2148	2150................	2151	2152	2153	2160................	21=
61.	2162	2170.................	2171	2172	2180.................	2181	2182	21=
87	2190................	2191.	2192..	2200.................	2201	2202	2210..=
=2E..............	2211	2212.	2220................	2221	2222.	2230..........=
=2E.....	2231.	2232	2240.................	2241	2242	2247	2250..............=
=2E.	2251	2252.	2260................	2261	2262.	2270................	2271.	=
2272	2280.................	2281	2282	2287	2290................	2291	2292.	2=
300................	2301	2302.	2310................	2311.	2312	2320........=
=2E........	2321	2322	2327	2330................	2331	2332.	2340............=
=2E...	2341	2342.	2350................	2351.	2352	2360.................	236=
1	2362	2367	2370................	2371	2372.	2380................	2381	2382.=
	2390................	2391.	2392	2400.................	2401	2402	2407	2410.=
=2E..............	2411	2412..	2420...............	2421.	2422.	2430.........=
=2E......	2431	2432.	2438	2440...............	2441	2442..	2450.............=
=2E.	2451.	2452.	2460...............	2461.	2462.	2470................	2471	=
2472..	2480...............	2481	2482..	2490...............	2491	2492..	2500=
=2E..............	2501.	2502.	2510................	2511	2512..	2520........=
=2E......	2521	2522..	2530...............	2531	2532..	2540...............	2=
541.	2542.	2550................	2551	2552..	2560...............	2561	2562..=
	2570...............	2571	2572..	2580...............	2581.	2582.	2589	2590.=
=2E............	2591.	2592..	2600...............	2601	2602..	2610..........=
=2E....	2611	2612..	2620...............	2621.	2622.	2626	2630..............=
=2E	2631	2632..	2640...............	2641	2642..	2650...............	2651	26=
52..	2660...............	2661.	2662.	2666	2670..............	2671.	2672..	2=
680...............	2681	2682..	2690...............	2691	2692..	2700........=
=2E......	2701.	2702.	2706	2710..............	2711.	2712..	2720............=
=2E..	2721	2722..	2730...............	2731	2732..	2740...............	2741.=
	2742.	2746	2750..............	2751.	2752..	2760...............	2761	2762..=
	2770...............	2771	2772..	2780...............	2781.	2782.	2786	2790.=
=2E............	2791.	2792.	2793	2800...............	2801	2802..	2810......=
=2E........	2811	2812..	2820...............	2821	2822..	2830...............=
	2831.	2832.	2836	2840..............	2841.	2842..	2850...............	2851	=
2852..	2860...............	2861.	2862.	2867	2870..............	2871.	2872.	=
2874	2880..............	2881.	2882..	2890...............	2891	2892..	2900..=
=2E............	2901.	2902.	2907	2910..............	2911.	2912.	2914	2920..=
=2E...........	2921.	2922..	2930...............	2931	2932..	2940...........=
=2E...	2941.	2942.	2948	2950..............	2951.	2952.	2954	2960...........=
=2E..	2961.	2962..	2970...............	2971	2972..	2980...............	2981=
=2E	2982.	2988	2990..............	2991.	2992.	2994	3000..............	3001.=
	3002.. SUCCESS

--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config-bisect"

#
# Automatically generated file; DO NOT EDIT.
# Linux/x86_64 3.8.0-rc7 Kernel Configuration
#
CONFIG_64BIT=y
CONFIG_X86_64=y
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf64-x86-64"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
CONFIG_ZONE_DMA32=y
CONFIG_AUDIT_ARCH=y
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_X86_64_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-rdi -fcall-saved-rsi -fcall-saved-rdx -fcall-saved-rcx -fcall-saved-r8 -fcall-saved-r9 -fcall-saved-r10 -fcall-saved-r11"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
# CONFIG_EXPERIMENTAL is not set
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
# CONFIG_KERNEL_GZIP is not set
# CONFIG_KERNEL_BZIP2 is not set
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
CONFIG_KERNEL_LZO=y
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_FHANDLE=y
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set
CONFIG_AUDIT_LOGINUID_IMMUTABLE=y
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_ARCH_CLOCKSOURCE_DATA=y
CONFIG_GENERIC_TIME_VSYSCALL=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set

#
# CPU/Task time and stats accounting
#
CONFIG_TICK_CPU_ACCOUNTING=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
CONFIG_BSD_PROCESS_ACCT=y
CONFIG_BSD_PROCESS_ACCT_V3=y
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
CONFIG_TASK_XACCT=y
# CONFIG_TASK_IO_ACCOUNTING is not set

#
# RCU Subsystem
#
CONFIG_TREE_RCU=y
# CONFIG_PREEMPT_RCU is not set
CONFIG_CONTEXT_TRACKING=y
CONFIG_RCU_USER_QS=y
CONFIG_CONTEXT_TRACKING_FORCE=y
CONFIG_RCU_FANOUT=64
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_NOCB_CPU=y
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
# CONFIG_CGROUP_FREEZER is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_CPUSETS is not set
# CONFIG_CGROUP_CPUACCT is not set
# CONFIG_RESOURCE_COUNTERS is not set
CONFIG_CGROUP_PERF=y
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
CONFIG_BLK_CGROUP=y
CONFIG_DEBUG_BLK_CGROUP=y
CONFIG_CHECKPOINT_RESTORE=y
CONFIG_NAMESPACES=y
# CONFIG_UTS_NS is not set
# CONFIG_IPC_NS is not set
CONFIG_PID_NS=y
CONFIG_NET_NS=y
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_SYSFS_DEPRECATED is not set
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
CONFIG_SYSCTL_EXCEPTION_TRACE=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_EPOLL=y
# CONFIG_SIGNALFD is not set
CONFIG_TIMERFD=y
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
CONFIG_AIO=y
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_PCI_QUIRKS=y
# CONFIG_SLUB_DEBUG is not set
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
CONFIG_PROFILING=y
CONFIG_TRACEPOINTS=y
# CONFIG_OPROFILE is not set
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
CONFIG_KPROBES=y
CONFIG_JUMP_LABEL=y
CONFIG_OPTPROBES=y
CONFIG_UPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_KRETPROBES=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_HAVE_CONTEXT_TRACKING=y
CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
CONFIG_MODULES_USE_ELF_RELA=y
CONFIG_GENERIC_SIGALTSTACK=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
# CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
CONFIG_MODULES=y
CONFIG_MODULE_FORCE_LOAD=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODVERSIONS=y
CONFIG_MODULE_SRCVERSION_ALL=y
# CONFIG_MODULE_SIG is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
CONFIG_BLK_DEV_INTEGRITY=y
# CONFIG_BLK_DEV_THROTTLING is not set

#
# Partition Types
#
# CONFIG_PARTITION_ADVANCED is not set
CONFIG_MSDOS_PARTITION=y
CONFIG_EFI_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
# CONFIG_IOSCHED_DEADLINE is not set
CONFIG_IOSCHED_CFQ=m
# CONFIG_CFQ_GROUP_IOSCHED is not set
CONFIG_DEFAULT_NOOP=y
CONFIG_DEFAULT_IOSCHED="noop"
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_FREEZER is not set

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_EXTENDED_PLATFORM is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_SCHED_OMIT_FRAME_POINTER is not set
CONFIG_PARAVIRT_GUEST=y
# CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
# CONFIG_XEN is not set
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_GUEST=y
CONFIG_PARAVIRT=y
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_NO_BOOTMEM=y
# CONFIG_MEMTEST is not set
# CONFIG_MK8 is not set
# CONFIG_MPSC is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
CONFIG_GENERIC_CPU=y
CONFIG_X86_INTERNODE_CACHE_SHIFT=6
CONFIG_X86_L1_CACHE_SHIFT=6
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=64
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
# CONFIG_CPU_SUP_INTEL is not set
# CONFIG_CPU_SUP_AMD is not set
# CONFIG_CPU_SUP_CENTAUR is not set
CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_DMI=y
CONFIG_SWIOTLB=y
CONFIG_IOMMU_HELPER=y
CONFIG_NR_CPUS=8
# CONFIG_SCHED_SMT is not set
CONFIG_SCHED_MC=y
CONFIG_PREEMPT_NONE=y
# CONFIG_PREEMPT_VOLUNTARY is not set
# CONFIG_PREEMPT is not set
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
# CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
# CONFIG_X86_MCE_AMD is not set
# CONFIG_X86_MCE_INJECT is not set
# CONFIG_I8K is not set
CONFIG_MICROCODE=m
# CONFIG_MICROCODE_INTEL is not set
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=m
# CONFIG_X86_CPUID is not set
CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
CONFIG_ARCH_DMA_ADDR_T_64BIT=y
CONFIG_DIRECT_GBPAGES=y
CONFIG_NUMA=y
# CONFIG_AMD_NUMA is not set
CONFIG_X86_64_ACPI_NUMA=y
CONFIG_NODES_SPAN_OTHER_NODES=y
CONFIG_NUMA_EMU=y
CONFIG_NODES_SHIFT=6
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_DEFAULT=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ARCH_PROC_KCORE_TEXT=y
CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_SPARSEMEM_MANUAL=y
CONFIG_SPARSEMEM=y
CONFIG_NEED_MULTIPLE_NODES=y
CONFIG_HAVE_MEMORY_PRESENT=y
CONFIG_SPARSEMEM_EXTREME=y
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
CONFIG_SPARSEMEM_ALLOC_MEM_MAP_TOGETHER=y
# CONFIG_SPARSEMEM_VMEMMAP is not set
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
# CONFIG_MOVABLE_NODE is not set
# CONFIG_MEMORY_HOTPLUG is not set
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
# CONFIG_COMPACTION is not set
# CONFIG_MIGRATION is not set
CONFIG_PHYS_ADDR_T_64BIT=y
CONFIG_ZONE_DMA_FLAG=0
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
CONFIG_CLEANCACHE=y
CONFIG_FRONTSWAP=y
CONFIG_X86_CHECK_BIOS_CORRUPTION=y
# CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MTRR=y
# CONFIG_MTRR_SANITIZER is not set
CONFIG_X86_PAT=y
CONFIG_ARCH_USES_PG_UNCACHED=y
# CONFIG_ARCH_RANDOM is not set
# CONFIG_X86_SMAP is not set
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
# CONFIG_CC_STACKPROTECTOR is not set
CONFIG_HZ_100=y
# CONFIG_HZ_250 is not set
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=100
# CONFIG_SCHED_HRTICK is not set
CONFIG_KEXEC=y
# CONFIG_CRASH_DUMP is not set
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_HOTPLUG_CPU is not set
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
CONFIG_USE_PERCPU_NUMA_NODE_ID=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_HIBERNATION is not set
# CONFIG_PM_RUNTIME is not set
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
# CONFIG_ACPI_PROCFS_POWER is not set
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
CONFIG_ACPI_AC=y
CONFIG_ACPI_BATTERY=y
CONFIG_ACPI_BUTTON=y
# CONFIG_ACPI_VIDEO is not set
CONFIG_ACPI_FAN=y
CONFIG_ACPI_I2C=m
CONFIG_ACPI_PROCESSOR=y
CONFIG_ACPI_THERMAL=y
CONFIG_ACPI_NUMA=y
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
# CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
# CONFIG_ACPI_PCI_SLOT is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
# CONFIG_ACPI_CUSTOM_METHOD is not set
# CONFIG_ACPI_APEI is not set
# CONFIG_SFI is not set

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set

#
# Memory power savings
#

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
CONFIG_PCI_DIRECT=y
# CONFIG_PCI_MMCONFIG is not set
CONFIG_PCI_DOMAINS=y
CONFIG_PCIEPORTBUS=y
CONFIG_PCIEAER=y
# CONFIG_PCIE_ECRC is not set
CONFIG_PCIEAER_INJECT=m
CONFIG_PCIEASPM=y
CONFIG_PCIEASPM_DEBUG=y
CONFIG_PCIEASPM_DEFAULT=y
# CONFIG_PCIEASPM_POWERSAVE is not set
# CONFIG_PCIEASPM_PERFORMANCE is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
CONFIG_PCI_DEBUG=y
CONFIG_PCI_REALLOC_ENABLE_AUTO=y
CONFIG_PCI_STUB=m
# CONFIG_HT_IRQ is not set
# CONFIG_PCI_ATS is not set
# CONFIG_PCI_IOV is not set
# CONFIG_PCI_PRI is not set
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
# CONFIG_ISA_DMA_API is not set
CONFIG_PCCARD=m
# CONFIG_PCMCIA is not set
# CONFIG_CARDBUS is not set

#
# PC-card bridges
#
CONFIG_YENTA=m
CONFIG_YENTA_O2=y
# CONFIG_YENTA_RICOH is not set
# CONFIG_YENTA_TI is not set
CONFIG_YENTA_TOSHIBA=y
# CONFIG_HOTPLUG_PCI is not set
# CONFIG_RAPIDIO is not set

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
# CONFIG_HAVE_AOUT is not set
# CONFIG_BINFMT_MISC is not set
# CONFIG_COREDUMP is not set
# CONFIG_IA32_EMULATION is not set
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_X86_DEV_DMA_OPS=y
CONFIG_NET=y

#
# Networking options
#
CONFIG_PACKET=m
CONFIG_PACKET_DIAG=m
CONFIG_UNIX=y
# CONFIG_UNIX_DIAG is not set
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=m
# CONFIG_XFRM_USER is not set
CONFIG_NET_KEY=m
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
# CONFIG_IP_PNP_BOOTP is not set
# CONFIG_IP_PNP_RARP is not set
CONFIG_NET_IPIP=m
# CONFIG_NET_IPGRE_DEMUX is not set
# CONFIG_IP_MROUTE is not set
CONFIG_ARPD=y
# CONFIG_SYN_COOKIES is not set
# CONFIG_NET_IPVTI is not set
# CONFIG_INET_AH is not set
# CONFIG_INET_ESP is not set
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=m
CONFIG_INET_XFRM_MODE_TRANSPORT=m
CONFIG_INET_XFRM_MODE_TUNNEL=m
# CONFIG_INET_XFRM_MODE_BEET is not set
CONFIG_INET_LRO=m
CONFIG_INET_DIAG=m
CONFIG_INET_TCP_DIAG=m
# CONFIG_INET_UDP_DIAG is not set
# CONFIG_TCP_CONG_ADVANCED is not set
CONFIG_TCP_CONG_CUBIC=y
CONFIG_DEFAULT_TCP_CONG="cubic"
CONFIG_IPV6=m
CONFIG_IPV6_PRIVACY=y
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_INET6_AH is not set
CONFIG_INET6_ESP=m
# CONFIG_INET6_IPCOMP is not set
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
CONFIG_INET6_XFRM_MODE_TUNNEL=m
CONFIG_INET6_XFRM_MODE_BEET=m
# CONFIG_IPV6_SIT is not set
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_GRE is not set
CONFIG_NETWORK_SECMARK=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
# CONFIG_NETFILTER_ADVANCED is not set

#
# Core Netfilter Configuration
#
# CONFIG_NETFILTER_NETLINK_LOG is not set
CONFIG_NF_CONNTRACK=m
# CONFIG_NF_CONNTRACK_SECMARK is not set
CONFIG_NF_CONNTRACK_PROCFS=y
# CONFIG_NF_CONNTRACK_FTP is not set
# CONFIG_NF_CONNTRACK_IRC is not set
# CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
# CONFIG_NF_CONNTRACK_SIP is not set
# CONFIG_NF_CT_NETLINK is not set
CONFIG_NETFILTER_XTABLES=m

#
# Xtables combined modules
#
# CONFIG_NETFILTER_XT_MARK is not set

#
# Xtables targets
#
CONFIG_NETFILTER_XT_TARGET_LOG=m
# CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
# CONFIG_NETFILTER_XT_TARGET_SECMARK is not set
CONFIG_NETFILTER_XT_TARGET_TCPMSS=m

#
# Xtables matches
#
# CONFIG_NETFILTER_XT_MATCH_CONNTRACK is not set
CONFIG_NETFILTER_XT_MATCH_POLICY=m
CONFIG_NETFILTER_XT_MATCH_STATE=m
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV4 is not set
# CONFIG_NF_CONNTRACK_IPV4 is not set
# CONFIG_IP_NF_IPTABLES is not set

#
# IPv6: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV6 is not set
# CONFIG_NF_CONNTRACK_IPV6 is not set
CONFIG_IP6_NF_IPTABLES=m
# CONFIG_IP6_NF_MATCH_IPV6HEADER is not set
CONFIG_IP6_NF_FILTER=m
# CONFIG_IP6_NF_TARGET_REJECT is not set
CONFIG_IP6_NF_MANGLE=m
# CONFIG_IP6_NF_RAW is not set
# CONFIG_BRIDGE_NF_EBTABLES is not set
CONFIG_ATM=m
CONFIG_ATM_CLIP=m
# CONFIG_ATM_CLIP_NO_ICMP is not set
# CONFIG_ATM_LANE is not set
# CONFIG_ATM_BR2684 is not set
CONFIG_L2TP=m
# CONFIG_L2TP_DEBUGFS is not set
CONFIG_STP=m
CONFIG_BRIDGE=m
# CONFIG_BRIDGE_IGMP_SNOOPING is not set
CONFIG_HAVE_NET_DSA=y
CONFIG_NET_DSA=m
CONFIG_NET_DSA_TAG_EDSA=y
# CONFIG_VLAN_8021Q is not set
CONFIG_DECNET=m
CONFIG_LLC=m
CONFIG_LLC2=m
CONFIG_IPX=m
CONFIG_IPX_INTERN=y
# CONFIG_ATALK is not set
CONFIG_PHONET=m
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=m
# CONFIG_NET_SCH_HTB is not set
# CONFIG_NET_SCH_HFSC is not set
# CONFIG_NET_SCH_ATM is not set
CONFIG_NET_SCH_PRIO=m
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=m
# CONFIG_NET_SCH_SFB is not set
# CONFIG_NET_SCH_SFQ is not set
# CONFIG_NET_SCH_TEQL is not set
CONFIG_NET_SCH_TBF=m
CONFIG_NET_SCH_GRED=m
# CONFIG_NET_SCH_DSMARK is not set
CONFIG_NET_SCH_NETEM=m
# CONFIG_NET_SCH_DRR is not set
# CONFIG_NET_SCH_MQPRIO is not set
CONFIG_NET_SCH_CHOKE=m
# CONFIG_NET_SCH_QFQ is not set
# CONFIG_NET_SCH_CODEL is not set
# CONFIG_NET_SCH_FQ_CODEL is not set
# CONFIG_NET_SCH_INGRESS is not set
CONFIG_NET_SCH_PLUG=m

#
# Classification
#
CONFIG_NET_CLS=y
# CONFIG_NET_CLS_BASIC is not set
CONFIG_NET_CLS_TCINDEX=m
CONFIG_NET_CLS_ROUTE4=m
# CONFIG_NET_CLS_FW is not set
CONFIG_NET_CLS_U32=m
CONFIG_CLS_U32_PERF=y
# CONFIG_CLS_U32_MARK is not set
CONFIG_NET_CLS_RSVP=m
CONFIG_NET_CLS_RSVP6=m
CONFIG_NET_CLS_FLOW=m
# CONFIG_NET_CLS_CGROUP is not set
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
# CONFIG_NET_ACT_POLICE is not set
CONFIG_NET_ACT_GACT=m
CONFIG_GACT_PROB=y
CONFIG_NET_ACT_MIRRED=m
# CONFIG_NET_ACT_NAT is not set
# CONFIG_NET_ACT_PEDIT is not set
CONFIG_NET_ACT_SIMP=m
# CONFIG_NET_ACT_SKBEDIT is not set
CONFIG_NET_ACT_CSUM=m
CONFIG_NET_CLS_IND=y
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=m
CONFIG_BATMAN_ADV=m
# CONFIG_BATMAN_ADV_BLA is not set
# CONFIG_BATMAN_ADV_DAT is not set
# CONFIG_BATMAN_ADV_DEBUG is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_RPS=y
CONFIG_RFS_ACCEL=y
CONFIG_XPS=y
CONFIG_NETPRIO_CGROUP=m
CONFIG_BQL=y
CONFIG_BPF_JIT=y

#
# Network testing
#
# CONFIG_NET_PKTGEN is not set
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
# CONFIG_AX25 is not set
CONFIG_CAN=m
CONFIG_CAN_RAW=m
CONFIG_CAN_BCM=m
CONFIG_CAN_GW=m

#
# CAN Device Drivers
#
CONFIG_CAN_VCAN=m
# CONFIG_CAN_SLCAN is not set
# CONFIG_CAN_DEV is not set
# CONFIG_CAN_DEBUG_DEVICES is not set
# CONFIG_IRDA is not set
CONFIG_BT=m
CONFIG_BT_RFCOMM=m
CONFIG_BT_RFCOMM_TTY=y
# CONFIG_BT_BNEP is not set
CONFIG_BT_HIDP=m

#
# Bluetooth device drivers
#
CONFIG_BT_HCIBTUSB=m
# CONFIG_BT_HCIUART is not set
CONFIG_BT_HCIBCM203X=m
CONFIG_BT_HCIBPA10X=m
# CONFIG_BT_HCIBFUSB is not set
CONFIG_BT_HCIVHCI=m
CONFIG_BT_MRVL=m
CONFIG_BT_ATH3K=m
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
# CONFIG_CFG80211 is not set
CONFIG_LIB80211=m
CONFIG_LIB80211_CRYPT_WEP=m
CONFIG_LIB80211_CRYPT_CCMP=m
CONFIG_LIB80211_CRYPT_TKIP=m
# CONFIG_LIB80211_DEBUG is not set

#
# CFG80211 needs to be enabled for MAC80211
#
# CONFIG_WIMAX is not set
# CONFIG_RFKILL is not set
CONFIG_RFKILL_REGULATOR=m
CONFIG_NET_9P=m
CONFIG_NET_9P_DEBUG=y
# CONFIG_CAIF is not set
CONFIG_NFC=m
# CONFIG_NFC_NCI is not set
CONFIG_NFC_HCI=m
# CONFIG_NFC_SHDLC is not set
CONFIG_NFC_LLCP=y

#
# Near Field Communication (NFC) devices
#
# CONFIG_NFC_PN533 is not set
CONFIG_HAVE_BPF_JIT=y

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
# CONFIG_DEVTMPFS is not set
# CONFIG_STANDALONE is not set
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_FW_LOADER=m
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
# CONFIG_DEBUG_DRIVER is not set
# CONFIG_DEBUG_DEVRES is not set
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=m
CONFIG_REGMAP_SPI=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y

#
# Bus devices
#
CONFIG_CONNECTOR=m
# CONFIG_MTD is not set
# CONFIG_PARPORT is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
CONFIG_BLK_CPQ_CISS_DA=m
CONFIG_CISS_SCSI_TAPE=y
CONFIG_BLK_DEV_DAC960=m
CONFIG_BLK_DEV_UMEM=m
# CONFIG_BLK_DEV_COW_COMMON is not set
CONFIG_BLK_DEV_LOOP=m
CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
CONFIG_BLK_DEV_CRYPTOLOOP=m
# CONFIG_BLK_DEV_DRBD is not set
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
# CONFIG_BLK_DEV_SX8 is not set
CONFIG_BLK_DEV_RAM=m
CONFIG_BLK_DEV_RAM_COUNT=16
CONFIG_BLK_DEV_RAM_SIZE=4096
# CONFIG_BLK_DEV_XIP is not set
# CONFIG_CDROM_PKTCDVD is not set
# CONFIG_ATA_OVER_ETH is not set
# CONFIG_BLK_DEV_HD is not set
# CONFIG_BLK_DEV_RBD is not set

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=m
# CONFIG_AD525X_DPOT is not set
CONFIG_IBM_ASM=m
CONFIG_PHANTOM=m
CONFIG_INTEL_MID_PTI=m
CONFIG_SGI_IOC4=m
CONFIG_TIFM_CORE=m
CONFIG_TIFM_7XX1=m
CONFIG_ICS932S401=m
# CONFIG_ENCLOSURE_SERVICES is not set
# CONFIG_HP_ILO is not set
# CONFIG_APDS9802ALS is not set
CONFIG_ISL29003=m
# CONFIG_ISL29020 is not set
CONFIG_SENSORS_TSL2550=m
CONFIG_SENSORS_BH1780=m
CONFIG_SENSORS_BH1770=m
# CONFIG_SENSORS_APDS990X is not set
CONFIG_HMC6352=m
# CONFIG_DS1682 is not set
CONFIG_TI_DAC7512=m
CONFIG_VMWARE_BALLOON=m
CONFIG_BMP085=y
# CONFIG_BMP085_I2C is not set
CONFIG_BMP085_SPI=m
CONFIG_PCH_PHUB=m
CONFIG_USB_SWITCH_FSA9480=m
CONFIG_C2PORT=m
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
CONFIG_EEPROM_AT24=m
# CONFIG_EEPROM_AT25 is not set
CONFIG_EEPROM_LEGACY=m
CONFIG_EEPROM_MAX6875=m
CONFIG_EEPROM_93CX6=m
CONFIG_EEPROM_93XX46=m
CONFIG_CB710_CORE=m
CONFIG_CB710_DEBUG=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
# CONFIG_TI_ST is not set
CONFIG_SENSORS_LIS3_I2C=m

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=m
# CONFIG_INTEL_MEI is not set
CONFIG_HAVE_IDE=y
CONFIG_IDE=m

#
# Please see Documentation/ide/ide.txt for help/info on IDE drives
#
CONFIG_IDE_XFER_MODE=y
CONFIG_IDE_TIMINGS=y
CONFIG_IDE_ATAPI=y
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_IDE_GD is not set
CONFIG_BLK_DEV_IDECD=m
CONFIG_BLK_DEV_IDECD_VERBOSE_ERRORS=y
# CONFIG_BLK_DEV_IDETAPE is not set
# CONFIG_BLK_DEV_IDEACPI is not set
# CONFIG_IDE_TASK_IOCTL is not set
# CONFIG_IDE_PROC_FS is not set

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=m
# CONFIG_BLK_DEV_PLATFORM is not set
CONFIG_BLK_DEV_CMD640=m
CONFIG_BLK_DEV_CMD640_ENHANCED=y
# CONFIG_BLK_DEV_IDEPNP is not set
CONFIG_BLK_DEV_IDEDMA_SFF=y

#
# PCI IDE chipsets support
#
CONFIG_BLK_DEV_IDEPCI=y
# CONFIG_BLK_DEV_OFFBOARD is not set
CONFIG_BLK_DEV_GENERIC=m
# CONFIG_BLK_DEV_RZ1000 is not set
CONFIG_BLK_DEV_IDEDMA_PCI=y
CONFIG_BLK_DEV_AEC62XX=m
# CONFIG_BLK_DEV_ALI15X3 is not set
# CONFIG_BLK_DEV_AMD74XX is not set
CONFIG_BLK_DEV_ATIIXP=m
CONFIG_BLK_DEV_CMD64X=m
# CONFIG_BLK_DEV_TRIFLEX is not set
CONFIG_BLK_DEV_CS5530=m
# CONFIG_BLK_DEV_HPT366 is not set
# CONFIG_BLK_DEV_JMICRON is not set
# CONFIG_BLK_DEV_SC1200 is not set
# CONFIG_BLK_DEV_PIIX is not set
CONFIG_BLK_DEV_IT8172=m
# CONFIG_BLK_DEV_IT8213 is not set
# CONFIG_BLK_DEV_IT821X is not set
# CONFIG_BLK_DEV_NS87415 is not set
CONFIG_BLK_DEV_PDC202XX_OLD=m
CONFIG_BLK_DEV_PDC202XX_NEW=m
# CONFIG_BLK_DEV_SVWKS is not set
# CONFIG_BLK_DEV_SIIMAGE is not set
# CONFIG_BLK_DEV_SIS5513 is not set
# CONFIG_BLK_DEV_SLC90E66 is not set
CONFIG_BLK_DEV_TRM290=m
CONFIG_BLK_DEV_VIA82CXXX=m
# CONFIG_BLK_DEV_TC86C001 is not set
CONFIG_BLK_DEV_IDEDMA=y

#
# SCSI device support
#
CONFIG_SCSI_MOD=m
CONFIG_RAID_ATTRS=m
CONFIG_SCSI=m
CONFIG_SCSI_DMA=y
CONFIG_SCSI_NETLINK=y
# CONFIG_SCSI_PROC_FS is not set

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=m
# CONFIG_CHR_DEV_ST is not set
# CONFIG_CHR_DEV_OSST is not set
# CONFIG_BLK_DEV_SR is not set
# CONFIG_CHR_DEV_SG is not set
CONFIG_CHR_DEV_SCH=m
CONFIG_SCSI_MULTI_LUN=y
# CONFIG_SCSI_CONSTANTS is not set
# CONFIG_SCSI_LOGGING is not set
CONFIG_SCSI_SCAN_ASYNC=y

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=m
CONFIG_SCSI_FC_ATTRS=m
CONFIG_SCSI_ISCSI_ATTRS=m
CONFIG_SCSI_SAS_ATTRS=m
CONFIG_SCSI_SAS_LIBSAS=m
CONFIG_SCSI_SAS_HOST_SMP=y
# CONFIG_SCSI_SRP_ATTRS is not set
# CONFIG_SCSI_LOWLEVEL is not set
CONFIG_SCSI_DH=m
CONFIG_SCSI_DH_RDAC=m
CONFIG_SCSI_DH_HP_SW=m
# CONFIG_SCSI_DH_EMC is not set
CONFIG_SCSI_OSD_INITIATOR=m
# CONFIG_SCSI_OSD_ULD is not set
CONFIG_SCSI_OSD_DPRINT_SENSE=1
CONFIG_SCSI_OSD_DEBUG=y
# CONFIG_ATA is not set
CONFIG_MD=y
CONFIG_BLK_DEV_MD=m
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
# CONFIG_MD_RAID1 is not set
# CONFIG_MD_RAID10 is not set
CONFIG_MD_RAID456=m
# CONFIG_MD_MULTIPATH is not set
# CONFIG_MD_FAULTY is not set
# CONFIG_BLK_DEV_DM is not set
CONFIG_TARGET_CORE=m
CONFIG_TCM_IBLOCK=m
CONFIG_TCM_FILEIO=m
# CONFIG_TCM_PSCSI is not set
# CONFIG_LOOPBACK_TARGET is not set
CONFIG_ISCSI_TARGET=m
CONFIG_FUSION=y
# CONFIG_FUSION_SPI is not set
CONFIG_FUSION_FC=m
CONFIG_FUSION_SAS=m
CONFIG_FUSION_MAX_SGE=128
CONFIG_FUSION_CTL=m
# CONFIG_FUSION_LAN is not set
# CONFIG_FUSION_LOGGING is not set

#
# IEEE 1394 (FireWire) support
#
# CONFIG_FIREWIRE is not set
# CONFIG_FIREWIRE_NOSY is not set
# CONFIG_I2O is not set
CONFIG_MACINTOSH_DRIVERS=y
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
# CONFIG_DUMMY is not set
# CONFIG_EQUALIZER is not set
CONFIG_NET_FC=y
CONFIG_MII=m
CONFIG_IFB=m
# CONFIG_NETCONSOLE is not set
# CONFIG_NETPOLL is not set
# CONFIG_NET_POLL_CONTROLLER is not set
# CONFIG_TUN is not set
CONFIG_VETH=m
# CONFIG_ARCNET is not set
CONFIG_ATM_DRIVERS=y
# CONFIG_ATM_DUMMY is not set
CONFIG_ATM_TCP=m
CONFIG_ATM_LANAI=m
CONFIG_ATM_ENI=m
# CONFIG_ATM_ENI_DEBUG is not set
# CONFIG_ATM_ENI_TUNE_BURST is not set
CONFIG_ATM_FIRESTREAM=m
CONFIG_ATM_ZATM=m
CONFIG_ATM_ZATM_DEBUG=y
CONFIG_ATM_NICSTAR=m
CONFIG_ATM_NICSTAR_USE_SUNI=y
CONFIG_ATM_NICSTAR_USE_IDT77105=y
# CONFIG_ATM_IDT77252 is not set
# CONFIG_ATM_AMBASSADOR is not set
CONFIG_ATM_HORIZON=m
# CONFIG_ATM_HORIZON_DEBUG is not set
# CONFIG_ATM_IA is not set
CONFIG_ATM_FORE200E=m
CONFIG_ATM_FORE200E_USE_TASKLET=y
CONFIG_ATM_FORE200E_TX_RETRY=16
CONFIG_ATM_FORE200E_DEBUG=0
CONFIG_ATM_HE=m
# CONFIG_ATM_HE_USE_SUNI is not set
# CONFIG_ATM_SOLOS is not set

#
# CAIF transport drivers
#

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=m
# CONFIG_NET_DSA_MV88E6060 is not set
# CONFIG_NET_DSA_MV88E6XXX_NEED_PPU is not set
# CONFIG_NET_DSA_MV88E6131 is not set
CONFIG_NET_DSA_MV88E6123_61_65=m
# CONFIG_ETHERNET is not set
CONFIG_FDDI=m
# CONFIG_DEFXX is not set
# CONFIG_SKFP is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=m

#
# MII PHY device drivers
#
CONFIG_AT803X_PHY=m
CONFIG_AMD_PHY=m
# CONFIG_MARVELL_PHY is not set
CONFIG_DAVICOM_PHY=m
# CONFIG_QSEMI_PHY is not set
# CONFIG_LXT_PHY is not set
# CONFIG_CICADA_PHY is not set
CONFIG_VITESSE_PHY=m
# CONFIG_SMSC_PHY is not set
CONFIG_BROADCOM_PHY=m
CONFIG_BCM87XX_PHY=m
CONFIG_ICPLUS_PHY=m
# CONFIG_REALTEK_PHY is not set
# CONFIG_NATIONAL_PHY is not set
CONFIG_STE10XP=m
# CONFIG_LSI_ET1011C_PHY is not set
CONFIG_MICREL_PHY=m
CONFIG_MDIO_BITBANG=m
# CONFIG_MDIO_GPIO is not set
# CONFIG_MICREL_KS8995MA is not set
CONFIG_PPP=m
CONFIG_PPP_BSDCOMP=m
CONFIG_PPP_DEFLATE=m
# CONFIG_PPP_FILTER is not set
# CONFIG_PPPOATM is not set
CONFIG_PPP_ASYNC=m
# CONFIG_PPP_SYNC_TTY is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=m

#
# USB Network Adapters
#
CONFIG_USB_KAWETH=m
# CONFIG_USB_PEGASUS is not set
CONFIG_USB_USBNET=m
# CONFIG_USB_NET_AX8817X is not set
CONFIG_USB_NET_CDCETHER=m
# CONFIG_USB_NET_CDC_NCM is not set
# CONFIG_USB_NET_CDC_MBIM is not set
CONFIG_USB_NET_DM9601=m
CONFIG_USB_NET_SMSC75XX=m
# CONFIG_USB_NET_SMSC95XX is not set
CONFIG_USB_NET_GL620A=m
# CONFIG_USB_NET_NET1080 is not set
# CONFIG_USB_NET_MCS7830 is not set
CONFIG_USB_NET_CDC_SUBSET=m
# CONFIG_USB_ALI_M5632 is not set
# CONFIG_USB_AN2720 is not set
# CONFIG_USB_BELKIN is not set
# CONFIG_USB_ARMLINUX is not set
CONFIG_USB_EPSON2888=y
# CONFIG_USB_NET_ZAURUS is not set
# CONFIG_USB_NET_CX82310_ETH is not set
# CONFIG_USB_NET_KALMIA is not set
# CONFIG_USB_NET_QMI_WWAN is not set
CONFIG_USB_NET_INT51X1=m
# CONFIG_USB_CDC_PHONET is not set
# CONFIG_USB_IPHETH is not set
CONFIG_USB_SIERRA_NET=m
# CONFIG_USB_VL600 is not set
CONFIG_WLAN=y
# CONFIG_ATMEL is not set
CONFIG_USB_ZD1201=m
CONFIG_HOSTAP=m
# CONFIG_HOSTAP_FIRMWARE is not set
# CONFIG_HOSTAP_PLX is not set
# CONFIG_HOSTAP_PCI is not set
# CONFIG_WL_TI is not set

#
# Enable WiMAX (Networking options) to see the WiMAX drivers
#
# CONFIG_WAN is not set
CONFIG_VMXNET3=m
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
CONFIG_INPUT_FF_MEMLESS=m
CONFIG_INPUT_POLLDEV=m
# CONFIG_INPUT_SPARSEKMAP is not set
CONFIG_INPUT_MATRIXKMAP=m

#
# Userland interfaces
#
CONFIG_INPUT_MOUSEDEV=m
CONFIG_INPUT_MOUSEDEV_PSAUX=y
CONFIG_INPUT_MOUSEDEV_SCREEN_X=1024
CONFIG_INPUT_MOUSEDEV_SCREEN_Y=768
CONFIG_INPUT_JOYDEV=m
# CONFIG_INPUT_EVDEV is not set
CONFIG_INPUT_EVBUG=m

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_STMPE is not set
# CONFIG_KEYBOARD_XTKBD is not set
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=m
# CONFIG_MOUSE_PS2_ALPS is not set
CONFIG_MOUSE_PS2_LOGIPS2PP=y
CONFIG_MOUSE_PS2_SYNAPTICS=y
CONFIG_MOUSE_PS2_LIFEBOOK=y
# CONFIG_MOUSE_PS2_TRACKPOINT is not set
CONFIG_MOUSE_PS2_ELANTECH=y
CONFIG_MOUSE_PS2_SENTELIC=y
# CONFIG_MOUSE_PS2_TOUCHKIT is not set
# CONFIG_MOUSE_SERIAL is not set
# CONFIG_MOUSE_APPLETOUCH is not set
CONFIG_MOUSE_BCM5974=m
CONFIG_MOUSE_VSXXXAA=m
# CONFIG_MOUSE_GPIO is not set
# CONFIG_MOUSE_SYNAPTICS_I2C is not set
CONFIG_MOUSE_SYNAPTICS_USB=m
# CONFIG_INPUT_JOYSTICK is not set
# CONFIG_INPUT_TABLET is not set
CONFIG_INPUT_TOUCHSCREEN=y
# CONFIG_TOUCHSCREEN_ADS7846 is not set
CONFIG_TOUCHSCREEN_AD7877=m
CONFIG_TOUCHSCREEN_AD7879=m
CONFIG_TOUCHSCREEN_AD7879_I2C=m
# CONFIG_TOUCHSCREEN_AD7879_SPI is not set
# CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
CONFIG_TOUCHSCREEN_AUO_PIXCIR=m
# CONFIG_TOUCHSCREEN_BU21013 is not set
CONFIG_TOUCHSCREEN_CY8CTMG110=m
CONFIG_TOUCHSCREEN_CYTTSP_CORE=m
CONFIG_TOUCHSCREEN_CYTTSP_I2C=m
CONFIG_TOUCHSCREEN_CYTTSP_SPI=m
CONFIG_TOUCHSCREEN_DA9052=m
CONFIG_TOUCHSCREEN_DYNAPRO=m
# CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
CONFIG_TOUCHSCREEN_EETI=m
# CONFIG_TOUCHSCREEN_FUJITSU is not set
# CONFIG_TOUCHSCREEN_ILI210X is not set
# CONFIG_TOUCHSCREEN_GUNZE is not set
# CONFIG_TOUCHSCREEN_ELO is not set
# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
# CONFIG_TOUCHSCREEN_WACOM_I2C is not set
# CONFIG_TOUCHSCREEN_MAX11801 is not set
CONFIG_TOUCHSCREEN_MCS5000=m
CONFIG_TOUCHSCREEN_MMS114=m
# CONFIG_TOUCHSCREEN_MTOUCH is not set
# CONFIG_TOUCHSCREEN_INEXIO is not set
CONFIG_TOUCHSCREEN_MK712=m
# CONFIG_TOUCHSCREEN_PENMOUNT is not set
# CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
CONFIG_TOUCHSCREEN_TOUCHRIGHT=m
# CONFIG_TOUCHSCREEN_TOUCHWIN is not set
CONFIG_TOUCHSCREEN_PIXCIR=m
CONFIG_TOUCHSCREEN_USB_COMPOSITE=m
# CONFIG_TOUCHSCREEN_MC13783 is not set
# CONFIG_TOUCHSCREEN_USB_EGALAX is not set
# CONFIG_TOUCHSCREEN_USB_PANJIT is not set
CONFIG_TOUCHSCREEN_USB_3M=y
CONFIG_TOUCHSCREEN_USB_ITM=y
CONFIG_TOUCHSCREEN_USB_ETURBO=y
# CONFIG_TOUCHSCREEN_USB_GUNZE is not set
# CONFIG_TOUCHSCREEN_USB_DMC_TSC10 is not set
# CONFIG_TOUCHSCREEN_USB_IRTOUCH is not set
# CONFIG_TOUCHSCREEN_USB_IDEALTEK is not set
CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
# CONFIG_TOUCHSCREEN_USB_GOTOP is not set
CONFIG_TOUCHSCREEN_USB_JASTEC=y
# CONFIG_TOUCHSCREEN_USB_ELO is not set
CONFIG_TOUCHSCREEN_USB_E2I=y
# CONFIG_TOUCHSCREEN_USB_ZYTRONIC is not set
CONFIG_TOUCHSCREEN_USB_ETT_TC45USB=y
# CONFIG_TOUCHSCREEN_USB_NEXIO is not set
# CONFIG_TOUCHSCREEN_USB_EASYTOUCH is not set
CONFIG_TOUCHSCREEN_TOUCHIT213=m
CONFIG_TOUCHSCREEN_TSC_SERIO=m
# CONFIG_TOUCHSCREEN_TSC2005 is not set
CONFIG_TOUCHSCREEN_TSC2007=m
CONFIG_TOUCHSCREEN_ST1232=m
# CONFIG_TOUCHSCREEN_STMPE is not set
# CONFIG_TOUCHSCREEN_TPS6507X is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=m
CONFIG_SERIO_CT82C710=m
CONFIG_SERIO_PCIPS2=m
CONFIG_SERIO_LIBPS2=y
# CONFIG_SERIO_RAW is not set
CONFIG_SERIO_ALTERA_PS2=m
CONFIG_SERIO_PS2MULT=m
CONFIG_SERIO_ARC_PS2=m
# CONFIG_GAMEPORT is not set

#
# Character devices
#
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_NOZOMI=m
CONFIG_N_GSM=m
# CONFIG_TRACE_ROUTER is not set
CONFIG_TRACE_SINK=m
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_PNP=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
# CONFIG_SERIAL_8250_PCI is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set

#
# Non-8250 serial port support
#
# CONFIG_SERIAL_MAX3100 is not set
# CONFIG_SERIAL_MAX310X is not set
# CONFIG_SERIAL_MFD_HSU is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_SERIAL_JSM=m
# CONFIG_SERIAL_SCCNXP is not set
# CONFIG_SERIAL_TIMBERDALE is not set
# CONFIG_SERIAL_ALTERA_JTAGUART is not set
CONFIG_SERIAL_ALTERA_UART=m
CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
CONFIG_SERIAL_IFX6X60=m
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_ARC is not set
CONFIG_TTY_PRINTK=y
# CONFIG_IPMI_HANDLER is not set
CONFIG_HW_RANDOM=m
# CONFIG_HW_RANDOM_TIMERIOMEM is not set
# CONFIG_HW_RANDOM_INTEL is not set
# CONFIG_HW_RANDOM_AMD is not set
# CONFIG_HW_RANDOM_VIA is not set
# CONFIG_HW_RANDOM_TPM is not set
# CONFIG_NVRAM is not set
CONFIG_RTC=m
CONFIG_GEN_RTC=m
# CONFIG_GEN_RTC_X is not set
# CONFIG_R3964 is not set
CONFIG_APPLICOM=m
CONFIG_MWAVE=m
CONFIG_RAW_DRIVER=m
CONFIG_MAX_RAW_DEVS=256
# CONFIG_HPET is not set
CONFIG_HANGCHECK_TIMER=m
CONFIG_TCG_TPM=m
CONFIG_TCG_TIS=m
# CONFIG_TCG_TIS_I2C_INFINEON is not set
# CONFIG_TCG_NSC is not set
CONFIG_TCG_ATMEL=m
# CONFIG_TCG_INFINEON is not set
# CONFIG_TELCLOCK is not set
CONFIG_DEVPORT=y
CONFIG_I2C=m
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
# CONFIG_I2C_CHARDEV is not set
# CONFIG_I2C_MUX is not set
# CONFIG_I2C_HELPER_AUTO is not set
CONFIG_I2C_SMBUS=m

#
# I2C Algorithms
#
CONFIG_I2C_ALGOBIT=m
# CONFIG_I2C_ALGOPCF is not set
CONFIG_I2C_ALGOPCA=m

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
# CONFIG_I2C_ALI1535 is not set
CONFIG_I2C_ALI15X3=m
# CONFIG_I2C_AMD756 is not set
CONFIG_I2C_AMD8111=m
CONFIG_I2C_I801=m
CONFIG_I2C_ISCH=m
# CONFIG_I2C_PIIX4 is not set
CONFIG_I2C_NFORCE2=m
CONFIG_I2C_SIS5595=m
# CONFIG_I2C_SIS630 is not set
# CONFIG_I2C_SIS96X is not set
CONFIG_I2C_VIAPRO=m

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_CBUS_GPIO is not set
# CONFIG_I2C_DESIGNWARE_PCI is not set
# CONFIG_I2C_EG20T is not set
CONFIG_I2C_GPIO=m
# CONFIG_I2C_INTEL_MID is not set
CONFIG_I2C_PCA_PLATFORM=m
# CONFIG_I2C_PXA_PCI is not set
# CONFIG_I2C_SIMTEC is not set

#
# External I2C/SMBus adapter drivers
#
# CONFIG_I2C_DIOLAN_U2C is not set
CONFIG_I2C_PARPORT_LIGHT=m
CONFIG_I2C_TINY_USB=m
# CONFIG_I2C_VIPERBOARD is not set

#
# Other I2C/SMBus bus drivers
#
CONFIG_I2C_DEBUG_CORE=y
# CONFIG_I2C_DEBUG_ALGO is not set
CONFIG_I2C_DEBUG_BUS=y
CONFIG_SPI=y
CONFIG_SPI_DEBUG=y
CONFIG_SPI_MASTER=y

#
# SPI Master Controller Drivers
#
# CONFIG_SPI_ALTERA is not set
CONFIG_SPI_BITBANG=m
# CONFIG_SPI_GPIO is not set
CONFIG_SPI_OC_TINY=m
# CONFIG_SPI_PXA2XX_PCI is not set
# CONFIG_SPI_SC18IS602 is not set
# CONFIG_SPI_TOPCLIFF_PCH is not set
# CONFIG_SPI_XCOMM is not set
CONFIG_SPI_DESIGNWARE=m
# CONFIG_SPI_DW_PCI is not set

#
# SPI Protocol Masters
#
# CONFIG_SPI_TLE62X0 is not set
# CONFIG_HSI is not set

#
# PPS support
#
CONFIG_PPS=m
CONFIG_PPS_DEBUG=y
CONFIG_NTP_PPS=y

#
# PPS clients support
#
CONFIG_PPS_CLIENT_KTIMER=m
CONFIG_PPS_CLIENT_LDISC=m
# CONFIG_PPS_CLIENT_GPIO is not set

#
# PPS generators support
#

#
# PTP clock support
#
CONFIG_PTP_1588_CLOCK=m

#
# Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
#
CONFIG_PTP_1588_CLOCK_PCH=m
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_GPIO_ACPI=y
CONFIG_DEBUG_GPIO=y
CONFIG_GPIO_DA9052=m
CONFIG_GPIO_MAX730X=m

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
# CONFIG_GPIO_IT8761E is not set
# CONFIG_GPIO_TS5500 is not set
CONFIG_GPIO_SCH=m
CONFIG_GPIO_ICH=m
CONFIG_GPIO_VX855=m

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_ARIZONA is not set
CONFIG_GPIO_MAX7300=m
# CONFIG_GPIO_MAX732X is not set
CONFIG_GPIO_PCA953X=m
CONFIG_GPIO_PCF857X=m
CONFIG_GPIO_STMPE=y
# CONFIG_GPIO_TPS65912 is not set
CONFIG_GPIO_ADP5588=m

#
# PCI GPIO expanders:
#
CONFIG_GPIO_BT8XX=m
# CONFIG_GPIO_AMD8111 is not set
CONFIG_GPIO_LANGWELL=y
CONFIG_GPIO_PCH=m
CONFIG_GPIO_ML_IOH=m
CONFIG_GPIO_RDC321X=m

#
# SPI GPIO expanders:
#
# CONFIG_GPIO_MAX7301 is not set
# CONFIG_GPIO_MCP23S08 is not set
# CONFIG_GPIO_MC33880 is not set
CONFIG_GPIO_74X164=m

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#

#
# USB GPIO expanders:
#
# CONFIG_GPIO_VIPERBOARD is not set
# CONFIG_W1 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
# CONFIG_PDA_POWER is not set
CONFIG_GENERIC_ADC_BATTERY=m
# CONFIG_TEST_POWER is not set
# CONFIG_BATTERY_DS2780 is not set
# CONFIG_BATTERY_DS2781 is not set
# CONFIG_BATTERY_DS2782 is not set
# CONFIG_BATTERY_SBS is not set
# CONFIG_BATTERY_BQ27x00 is not set
# CONFIG_BATTERY_DA9052 is not set
# CONFIG_BATTERY_MAX17040 is not set
CONFIG_BATTERY_MAX17042=m
CONFIG_CHARGER_ISP1704=m
CONFIG_CHARGER_MAX8903=m
CONFIG_CHARGER_LP8727=m
CONFIG_CHARGER_GPIO=m
CONFIG_CHARGER_BQ2415X=m
CONFIG_CHARGER_SMB347=m
CONFIG_POWER_RESET=y
CONFIG_POWER_AVS=y
CONFIG_HWMON=m
CONFIG_HWMON_VID=m
CONFIG_HWMON_DEBUG_CHIP=y

#
# Native drivers
#
CONFIG_SENSORS_ABITUGURU=m
CONFIG_SENSORS_ABITUGURU3=m
# CONFIG_SENSORS_AD7314 is not set
CONFIG_SENSORS_AD7414=m
# CONFIG_SENSORS_AD7418 is not set
CONFIG_SENSORS_ADCXX=m
CONFIG_SENSORS_ADM1021=m
CONFIG_SENSORS_ADM1025=m
# CONFIG_SENSORS_ADM1026 is not set
# CONFIG_SENSORS_ADM1029 is not set
# CONFIG_SENSORS_ADM1031 is not set
CONFIG_SENSORS_ADM9240=m
CONFIG_SENSORS_ADT7410=m
CONFIG_SENSORS_ADT7411=m
CONFIG_SENSORS_ADT7462=m
CONFIG_SENSORS_ADT7470=m
CONFIG_SENSORS_ADT7475=m
# CONFIG_SENSORS_ASC7621 is not set
CONFIG_SENSORS_K8TEMP=m
# CONFIG_SENSORS_K10TEMP is not set
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=m
CONFIG_SENSORS_ATXP1=m
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=m
CONFIG_SENSORS_DA9052_ADC=m
# CONFIG_SENSORS_I5K_AMB is not set
# CONFIG_SENSORS_F71805F is not set
# CONFIG_SENSORS_F71882FG is not set
CONFIG_SENSORS_F75375S=m
# CONFIG_SENSORS_FSCHMD is not set
CONFIG_SENSORS_G760A=m
CONFIG_SENSORS_GL518SM=m
CONFIG_SENSORS_GL520SM=m
CONFIG_SENSORS_GPIO_FAN=m
CONFIG_SENSORS_HIH6130=m
CONFIG_SENSORS_CORETEMP=m
CONFIG_SENSORS_IT87=m
# CONFIG_SENSORS_JC42 is not set
# CONFIG_SENSORS_LINEAGE is not set
# CONFIG_SENSORS_LM63 is not set
# CONFIG_SENSORS_LM70 is not set
CONFIG_SENSORS_LM73=m
CONFIG_SENSORS_LM75=m
# CONFIG_SENSORS_LM77 is not set
CONFIG_SENSORS_LM78=m
# CONFIG_SENSORS_LM80 is not set
CONFIG_SENSORS_LM83=m
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=m
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=m
CONFIG_SENSORS_LTC4151=m
# CONFIG_SENSORS_LTC4215 is not set
CONFIG_SENSORS_LTC4245=m
# CONFIG_SENSORS_LTC4261 is not set
CONFIG_SENSORS_LM95241=m
CONFIG_SENSORS_LM95245=m
# CONFIG_SENSORS_MAX1111 is not set
CONFIG_SENSORS_MAX16065=m
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
# CONFIG_SENSORS_MAX197 is not set
# CONFIG_SENSORS_MAX6639 is not set
CONFIG_SENSORS_MAX6642=m
CONFIG_SENSORS_MAX6650=m
CONFIG_SENSORS_MCP3021=m
# CONFIG_SENSORS_NTC_THERMISTOR is not set
CONFIG_SENSORS_PC87360=m
# CONFIG_SENSORS_PC87427 is not set
# CONFIG_SENSORS_PCF8591 is not set
CONFIG_PMBUS=m
# CONFIG_SENSORS_PMBUS is not set
# CONFIG_SENSORS_ADM1275 is not set
CONFIG_SENSORS_LM25066=m
CONFIG_SENSORS_LTC2978=m
# CONFIG_SENSORS_MAX16064 is not set
CONFIG_SENSORS_MAX34440=m
# CONFIG_SENSORS_MAX8688 is not set
# CONFIG_SENSORS_UCD9000 is not set
# CONFIG_SENSORS_UCD9200 is not set
CONFIG_SENSORS_ZL6100=m
CONFIG_SENSORS_SHT15=m
CONFIG_SENSORS_SHT21=m
# CONFIG_SENSORS_SIS5595 is not set
# CONFIG_SENSORS_SMM665 is not set
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
CONFIG_SENSORS_EMC2103=m
# CONFIG_SENSORS_EMC6W201 is not set
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
# CONFIG_SENSORS_SMSC47B397 is not set
CONFIG_SENSORS_SCH56XX_COMMON=m
# CONFIG_SENSORS_SCH5627 is not set
CONFIG_SENSORS_SCH5636=m
# CONFIG_SENSORS_ADS1015 is not set
CONFIG_SENSORS_ADS7828=m
CONFIG_SENSORS_ADS7871=m
CONFIG_SENSORS_AMC6821=m
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
# CONFIG_SENSORS_TMP401 is not set
# CONFIG_SENSORS_TMP421 is not set
CONFIG_SENSORS_VIA_CPUTEMP=m
CONFIG_SENSORS_VIA686A=m
# CONFIG_SENSORS_VT1211 is not set
CONFIG_SENSORS_VT8231=m
CONFIG_SENSORS_W83781D=m
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=m
# CONFIG_SENSORS_W83793 is not set
# CONFIG_SENSORS_W83795 is not set
CONFIG_SENSORS_W83L785TS=m
# CONFIG_SENSORS_W83L786NG is not set
CONFIG_SENSORS_W83627HF=m
CONFIG_SENSORS_W83627EHF=m
CONFIG_SENSORS_APPLESMC=m
CONFIG_SENSORS_MC13783_ADC=m

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
# CONFIG_SENSORS_ATK0110 is not set
CONFIG_THERMAL=y
# CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
# CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
CONFIG_FAIR_SHARE=y
CONFIG_STEP_WISE=y
CONFIG_USER_SPACE=y
CONFIG_WATCHDOG=y
CONFIG_WATCHDOG_CORE=y
# CONFIG_WATCHDOG_NOWAYOUT is not set

#
# Watchdog Device Drivers
#
# CONFIG_SOFT_WATCHDOG is not set
CONFIG_DA9052_WATCHDOG=m
# CONFIG_ACQUIRE_WDT is not set
# CONFIG_ADVANTECH_WDT is not set
CONFIG_ALIM1535_WDT=m
# CONFIG_ALIM7101_WDT is not set
# CONFIG_F71808E_WDT is not set
CONFIG_SP5100_TCO=m
# CONFIG_SC520_WDT is not set
# CONFIG_SBC_FITPC2_WATCHDOG is not set
# CONFIG_EUROTECH_WDT is not set
CONFIG_IB700_WDT=m
CONFIG_IBMASR=m
# CONFIG_WAFER_WDT is not set
# CONFIG_I6300ESB_WDT is not set
# CONFIG_IE6XX_WDT is not set
CONFIG_ITCO_WDT=m
# CONFIG_ITCO_VENDOR_SUPPORT is not set
# CONFIG_IT8712F_WDT is not set
CONFIG_IT87_WDT=m
CONFIG_HP_WATCHDOG=m
CONFIG_HPWDT_NMI_DECODING=y
# CONFIG_SC1200_WDT is not set
# CONFIG_PC87413_WDT is not set
# CONFIG_NV_TCO is not set
CONFIG_60XX_WDT=m
# CONFIG_SBC8360_WDT is not set
CONFIG_CPU5_WDT=m
CONFIG_SMSC_SCH311X_WDT=m
CONFIG_SMSC37B787_WDT=m
CONFIG_VIA_WDT=m
CONFIG_W83627HF_WDT=m
CONFIG_W83697HF_WDT=m
# CONFIG_W83697UG_WDT is not set
CONFIG_W83877F_WDT=m
CONFIG_W83977F_WDT=m
CONFIG_MACHZ_WDT=m
CONFIG_SBC_EPX_C3_WATCHDOG=m

#
# PCI-based Watchdog Cards
#
CONFIG_PCIPCWATCHDOG=m
CONFIG_WDTPCI=m

#
# USB-based Watchdog Cards
#
# CONFIG_USBPCWATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=m
CONFIG_SSB_PCIHOST_POSSIBLE=y
# CONFIG_SSB_PCIHOST is not set
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_GPIO=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
# CONFIG_BCMA is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
# CONFIG_MFD_SM501 is not set
# CONFIG_MFD_RTSX_PCI is not set
# CONFIG_MFD_TI_AM335X_TSCADC is not set
CONFIG_HTC_PASIC3=m
CONFIG_MFD_LM3533=m
CONFIG_TPS6105X=m
CONFIG_TPS65010=m
CONFIG_TPS6507X=m
# CONFIG_MFD_TPS65217 is not set
CONFIG_MFD_TPS65912=y
CONFIG_MFD_TPS65912_SPI=y
CONFIG_MFD_STMPE=y

#
# STMPE Interface Drivers
#
CONFIG_STMPE_SPI=y
# CONFIG_MFD_TMIO is not set
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_SPI=y
CONFIG_MFD_ARIZONA=y
CONFIG_MFD_ARIZONA_I2C=m
CONFIG_MFD_ARIZONA_SPI=m
# CONFIG_MFD_WM5102 is not set
CONFIG_MFD_WM5110=y
# CONFIG_MFD_WM831X_SPI is not set
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_MC13783=m
CONFIG_MFD_MC13XXX=m
CONFIG_MFD_MC13XXX_SPI=m
# CONFIG_MFD_MC13XXX_I2C is not set
CONFIG_ABX500_CORE=y
# CONFIG_EZX_PCAP is not set
# CONFIG_MFD_CS5535 is not set
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_LPC_SCH=m
CONFIG_LPC_ICH=m
CONFIG_MFD_RDC321X=m
# CONFIG_MFD_JANZ_CMODIO is not set
CONFIG_MFD_VX855=m
CONFIG_MFD_WL1273_CORE=m
CONFIG_MFD_VIPERBOARD=m
CONFIG_MFD_RETU=m
CONFIG_REGULATOR=y
CONFIG_REGULATOR_DEBUG=y
CONFIG_REGULATOR_DUMMY=y
CONFIG_REGULATOR_FIXED_VOLTAGE=m
CONFIG_REGULATOR_VIRTUAL_CONSUMER=m
# CONFIG_REGULATOR_USERSPACE_CONSUMER is not set
# CONFIG_REGULATOR_GPIO is not set
# CONFIG_REGULATOR_AD5398 is not set
# CONFIG_REGULATOR_ARIZONA is not set
# CONFIG_REGULATOR_DA9052 is not set
# CONFIG_REGULATOR_FAN53555 is not set
CONFIG_REGULATOR_MC13XXX_CORE=m
CONFIG_REGULATOR_MC13783=m
CONFIG_REGULATOR_MC13892=m
CONFIG_REGULATOR_ISL6271A=m
CONFIG_REGULATOR_MAX1586=m
# CONFIG_REGULATOR_MAX8649 is not set
# CONFIG_REGULATOR_MAX8660 is not set
CONFIG_REGULATOR_MAX8952=m
CONFIG_REGULATOR_MAX8973=m
CONFIG_REGULATOR_LP3971=m
CONFIG_REGULATOR_LP3972=m
# CONFIG_REGULATOR_TPS51632 is not set
CONFIG_REGULATOR_TPS6105X=m
CONFIG_REGULATOR_TPS62360=m
# CONFIG_REGULATOR_TPS65023 is not set
CONFIG_REGULATOR_TPS6507X=m
CONFIG_REGULATOR_TPS6524X=m
CONFIG_REGULATOR_TPS65912=m
CONFIG_MEDIA_SUPPORT=m

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set
CONFIG_VIDEO_ADV_DEBUG=y
CONFIG_VIDEO_FIXED_MINOR_RANGES=y
CONFIG_DVB_CORE=m
CONFIG_DVB_NET=y
CONFIG_DVB_MAX_ADAPTERS=8
# CONFIG_DVB_DYNAMIC_MINORS is not set

#
# Media drivers
#
CONFIG_MEDIA_USB_SUPPORT=y

#
# Analog/digital TV USB devices
#

#
# Digital TV USB devices
#
CONFIG_DVB_TTUSB_BUDGET=m
# CONFIG_DVB_TTUSB_DEC is not set
CONFIG_SMS_USB_DRV=m
# CONFIG_DVB_B2C2_FLEXCOP_USB is not set

#
# Webcam, TV (analog/digital) USB devices
#
# CONFIG_MEDIA_PCI_SUPPORT is not set

#
# Supported MMC/SDIO adapters
#
CONFIG_MEDIA_COMMON_OPTIONS=y

#
# common driver options
#
CONFIG_SMS_SIANO_MDTV=m
# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#
# CONFIG_MEDIA_ATTACH is not set

#
# Customize TV tuners
#
# CONFIG_MEDIA_TUNER_SIMPLE is not set
# CONFIG_MEDIA_TUNER_TDA8290 is not set
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
# CONFIG_MEDIA_TUNER_TDA9887 is not set
# CONFIG_MEDIA_TUNER_TEA5761 is not set
# CONFIG_MEDIA_TUNER_TEA5767 is not set
CONFIG_MEDIA_TUNER_MT20XX=m
# CONFIG_MEDIA_TUNER_MT2060 is not set
# CONFIG_MEDIA_TUNER_MT2063 is not set
# CONFIG_MEDIA_TUNER_MT2266 is not set
# CONFIG_MEDIA_TUNER_MT2131 is not set
# CONFIG_MEDIA_TUNER_QT1010 is not set
# CONFIG_MEDIA_TUNER_XC2028 is not set
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_XC4000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
# CONFIG_MEDIA_TUNER_MXL5007T is not set
CONFIG_MEDIA_TUNER_MC44S803=m
CONFIG_MEDIA_TUNER_MAX2165=m
CONFIG_MEDIA_TUNER_TDA18218=m
CONFIG_MEDIA_TUNER_FC0011=m
# CONFIG_MEDIA_TUNER_FC0012 is not set
CONFIG_MEDIA_TUNER_FC0013=m
CONFIG_MEDIA_TUNER_TDA18212=m
# CONFIG_MEDIA_TUNER_E4000 is not set
# CONFIG_MEDIA_TUNER_FC2580 is not set
# CONFIG_MEDIA_TUNER_TUA9001 is not set

#
# Customise DVB Frontends
#

#
# Multistandard (satellite) frontends
#
# CONFIG_DVB_STB0899 is not set
# CONFIG_DVB_STB6100 is not set
# CONFIG_DVB_STV090x is not set
# CONFIG_DVB_STV6110x is not set

#
# Multistandard (cable + terrestrial) frontends
#
CONFIG_DVB_DRXK=m
# CONFIG_DVB_TDA18271C2DD is not set

#
# DVB-S (satellite) frontends
#
# CONFIG_DVB_CX24110 is not set
CONFIG_DVB_CX24123=m
CONFIG_DVB_MT312=m
# CONFIG_DVB_ZL10036 is not set
CONFIG_DVB_ZL10039=m
CONFIG_DVB_S5H1420=m
# CONFIG_DVB_STV0288 is not set
CONFIG_DVB_STB6000=m
# CONFIG_DVB_STV0299 is not set
CONFIG_DVB_STV6110=m
CONFIG_DVB_STV0900=m
# CONFIG_DVB_TDA8083 is not set
# CONFIG_DVB_TDA10086 is not set
# CONFIG_DVB_TDA8261 is not set
CONFIG_DVB_VES1X93=m
# CONFIG_DVB_TUNER_ITD1000 is not set
CONFIG_DVB_TUNER_CX24113=m
# CONFIG_DVB_TDA826X is not set
CONFIG_DVB_TUA6100=m
CONFIG_DVB_CX24116=m
CONFIG_DVB_SI21XX=m
CONFIG_DVB_DS3000=m
CONFIG_DVB_MB86A16=m
# CONFIG_DVB_TDA10071 is not set

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=m
# CONFIG_DVB_SP887X is not set
# CONFIG_DVB_CX22700 is not set
# CONFIG_DVB_CX22702 is not set
CONFIG_DVB_S5H1432=m
CONFIG_DVB_DRXD=m
# CONFIG_DVB_L64781 is not set
# CONFIG_DVB_TDA1004X is not set
# CONFIG_DVB_NXT6000 is not set
# CONFIG_DVB_MT352 is not set
# CONFIG_DVB_ZL10353 is not set
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_DIB3000MC=m
# CONFIG_DVB_DIB7000M is not set
CONFIG_DVB_DIB7000P=m
CONFIG_DVB_DIB9000=m
CONFIG_DVB_TDA10048=m
# CONFIG_DVB_AF9013 is not set
CONFIG_DVB_EC100=m
CONFIG_DVB_HD29L2=m
CONFIG_DVB_STV0367=m
# CONFIG_DVB_CXD2820R is not set
CONFIG_DVB_RTL2830=m
CONFIG_DVB_RTL2832=m

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=m
# CONFIG_DVB_TDA10021 is not set
CONFIG_DVB_TDA10023=m
# CONFIG_DVB_STV0297 is not set

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=m
CONFIG_DVB_OR51211=m
CONFIG_DVB_OR51132=m
# CONFIG_DVB_BCM3510 is not set
# CONFIG_DVB_LGDT330X is not set
# CONFIG_DVB_LGDT3305 is not set
CONFIG_DVB_LG2160=m
# CONFIG_DVB_S5H1409 is not set
CONFIG_DVB_AU8522=m
CONFIG_DVB_AU8522_DTV=m
# CONFIG_DVB_S5H1411 is not set

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=m
CONFIG_DVB_DIB8000=m
# CONFIG_DVB_MB86A20S is not set

#
# Digital terrestrial only tuners/PLL
#
# CONFIG_DVB_PLL is not set
# CONFIG_DVB_TUNER_DIB0070 is not set
CONFIG_DVB_TUNER_DIB0090=m

#
# SEC control devices for DVB-S
#
# CONFIG_DVB_LNBP21 is not set
# CONFIG_DVB_LNBP22 is not set
CONFIG_DVB_ISL6405=m
CONFIG_DVB_ISL6421=m
# CONFIG_DVB_ISL6423 is not set
# CONFIG_DVB_A8293 is not set
# CONFIG_DVB_LGS8GL5 is not set
CONFIG_DVB_LGS8GXX=m
# CONFIG_DVB_ATBM8830 is not set
# CONFIG_DVB_TDA665x is not set
# CONFIG_DVB_IX2505V is not set
CONFIG_DVB_IT913X_FE=m
CONFIG_DVB_M88RS2000=m
# CONFIG_DVB_AF9033 is not set

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=m

#
# Graphics support
#
CONFIG_AGP=m
CONFIG_AGP_INTEL=m
# CONFIG_AGP_SIS is not set
CONFIG_AGP_VIA=m
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=m
CONFIG_DRM_KMS_HELPER=m
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
# CONFIG_DRM_TTM is not set
CONFIG_DRM_TDFX=m
# CONFIG_DRM_R128 is not set
CONFIG_DRM_RADEON=m
# CONFIG_DRM_RADEON_KMS is not set
# CONFIG_DRM_NOUVEAU is not set

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=m
# CONFIG_DRM_I2C_SIL164 is not set
CONFIG_DRM_I810=m
# CONFIG_DRM_I915 is not set
CONFIG_DRM_MGA=m
# CONFIG_DRM_SIS is not set
CONFIG_DRM_VIA=m
CONFIG_DRM_SAVAGE=m
# CONFIG_DRM_VMWGFX is not set
# CONFIG_STUB_POULSBO is not set
CONFIG_VGASTATE=m
CONFIG_VIDEO_OUTPUT_CONTROL=m
CONFIG_FB=m
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=m
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=m
CONFIG_FB_CFB_COPYAREA=m
CONFIG_FB_CFB_IMAGEBLIT=m
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=m
CONFIG_FB_SYS_COPYAREA=m
CONFIG_FB_SYS_IMAGEBLIT=m
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=m
# CONFIG_FB_WMT_GE_ROPS is not set
CONFIG_FB_DEFERRED_IO=y
CONFIG_FB_HECUBA=m
CONFIG_FB_SVGALIB=m
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=m
CONFIG_FB_PM2=m
CONFIG_FB_PM2_FIFO_DISCONNECT=y
CONFIG_FB_CYBER2000=m
CONFIG_FB_CYBER2000_DDC=y
CONFIG_FB_ARC=m
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_UVESA is not set
CONFIG_FB_N411=m
# CONFIG_FB_HGA is not set
CONFIG_FB_S1D13XXX=m
# CONFIG_FB_NVIDIA is not set
CONFIG_FB_RIVA=m
# CONFIG_FB_RIVA_I2C is not set
# CONFIG_FB_RIVA_DEBUG is not set
# CONFIG_FB_RIVA_BACKLIGHT is not set
CONFIG_FB_LE80578=m
# CONFIG_FB_CARILLO_RANCH is not set
# CONFIG_FB_MATROX is not set
CONFIG_FB_RADEON=m
# CONFIG_FB_RADEON_I2C is not set
# CONFIG_FB_RADEON_BACKLIGHT is not set
CONFIG_FB_RADEON_DEBUG=y
CONFIG_FB_ATY128=m
# CONFIG_FB_ATY128_BACKLIGHT is not set
CONFIG_FB_ATY=m
CONFIG_FB_ATY_CT=y
# CONFIG_FB_ATY_GENERIC_LCD is not set
CONFIG_FB_ATY_GX=y
CONFIG_FB_ATY_BACKLIGHT=y
CONFIG_FB_S3=m
CONFIG_FB_S3_DDC=y
# CONFIG_FB_SIS is not set
CONFIG_FB_VIA=m
# CONFIG_FB_VIA_DIRECT_PROCFS is not set
CONFIG_FB_VIA_X_COMPATIBILITY=y
CONFIG_FB_NEOMAGIC=m
CONFIG_FB_KYRO=m
CONFIG_FB_3DFX=m
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
CONFIG_FB_TRIDENT=m
# CONFIG_FB_ARK is not set
# CONFIG_FB_CARMINE is not set
# CONFIG_FB_TMIO is not set
# CONFIG_FB_SMSCUFX is not set
CONFIG_FB_UDL=m
# CONFIG_FB_VIRTUAL is not set
CONFIG_FB_METRONOME=m
CONFIG_FB_MB862XX=m
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_MB862XX_I2C=y
CONFIG_FB_BROADSHEET=m
# CONFIG_FB_AUO_K190X is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=m
CONFIG_LCD_L4F00242T03=m
CONFIG_LCD_LMS283GF05=m
CONFIG_LCD_LTV350QV=m
# CONFIG_LCD_ILI9320 is not set
CONFIG_LCD_TDO24M=m
# CONFIG_LCD_VGG2432A4 is not set
# CONFIG_LCD_PLATFORM is not set
CONFIG_LCD_S6E63M0=m
CONFIG_LCD_LD9040=m
# CONFIG_LCD_AMS369FG06 is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=m
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_LM3533 is not set
CONFIG_BACKLIGHT_CARILLO_RANCH=m
# CONFIG_BACKLIGHT_PWM is not set
# CONFIG_BACKLIGHT_DA9052 is not set
# CONFIG_BACKLIGHT_APPLE is not set
CONFIG_BACKLIGHT_SAHARA=m
# CONFIG_BACKLIGHT_ADP8860 is not set
# CONFIG_BACKLIGHT_ADP8870 is not set
CONFIG_BACKLIGHT_LM3630=m
CONFIG_BACKLIGHT_LM3639=m
CONFIG_BACKLIGHT_LP855X=m
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
CONFIG_LOGO_LINUX_VGA16=y
CONFIG_LOGO_LINUX_CLUT224=y
# CONFIG_SOUND is not set

#
# HID support
#
CONFIG_HID=m
# CONFIG_HIDRAW is not set
CONFIG_UHID=m
CONFIG_HID_GENERIC=m

#
# Special HID drivers
#
# CONFIG_HID_A4TECH is not set
# CONFIG_HID_ACRUX is not set
CONFIG_HID_APPLE=m
# CONFIG_HID_AUREAL is not set
CONFIG_HID_BELKIN=m
# CONFIG_HID_CHERRY is not set
# CONFIG_HID_CHICONY is not set
CONFIG_HID_CYPRESS=m
CONFIG_HID_DRAGONRISE=m
CONFIG_DRAGONRISE_FF=y
# CONFIG_HID_EMS_FF is not set
CONFIG_HID_ELECOM=m
CONFIG_HID_EZKEY=m
# CONFIG_HID_HOLTEK is not set
CONFIG_HID_KEYTOUCH=m
CONFIG_HID_KYE=m
CONFIG_HID_UCLOGIC=m
# CONFIG_HID_WALTOP is not set
# CONFIG_HID_GYRATION is not set
CONFIG_HID_ICADE=m
CONFIG_HID_TWINHAN=m
# CONFIG_HID_KENSINGTON is not set
CONFIG_HID_LCPOWER=m
CONFIG_HID_LENOVO_TPKBD=m
CONFIG_HID_LOGITECH=m
CONFIG_HID_LOGITECH_DJ=m
CONFIG_LOGITECH_FF=y
CONFIG_LOGIRUMBLEPAD2_FF=y
CONFIG_LOGIG940_FF=y
# CONFIG_LOGIWHEELS_FF is not set
# CONFIG_HID_MAGICMOUSE is not set
# CONFIG_HID_MICROSOFT is not set
CONFIG_HID_MONTEREY=m
CONFIG_HID_MULTITOUCH=m
CONFIG_HID_NTRIG=m
CONFIG_HID_ORTEK=m
# CONFIG_HID_PANTHERLORD is not set
# CONFIG_HID_PETALYNX is not set
CONFIG_HID_PICOLCD=m
CONFIG_HID_PICOLCD_FB=y
CONFIG_HID_PICOLCD_BACKLIGHT=y
CONFIG_HID_PICOLCD_LCD=y
CONFIG_HID_PICOLCD_LEDS=y
CONFIG_HID_PRIMAX=m
# CONFIG_HID_PS3REMOTE is not set
# CONFIG_HID_ROCCAT is not set
CONFIG_HID_SAITEK=m
CONFIG_HID_SAMSUNG=m
# CONFIG_HID_SONY is not set
# CONFIG_HID_SPEEDLINK is not set
# CONFIG_HID_SUNPLUS is not set
# CONFIG_HID_GREENASIA is not set
# CONFIG_HID_SMARTJOYPLUS is not set
# CONFIG_HID_TIVO is not set
CONFIG_HID_TOPSEED=m
# CONFIG_HID_THRUSTMASTER is not set
CONFIG_HID_WACOM=m
CONFIG_HID_WIIMOTE=m
CONFIG_HID_WIIMOTE_EXT=y
# CONFIG_HID_ZEROPLUS is not set
# CONFIG_HID_ZYDACRON is not set
# CONFIG_HID_SENSOR_HUB is not set

#
# USB HID support
#
CONFIG_USB_HID=m
CONFIG_HID_PID=y
# CONFIG_USB_HIDDEV is not set

#
# USB HID Boot Protocol drivers
#
CONFIG_USB_KBD=m
# CONFIG_USB_MOUSE is not set

#
# I2C HID support
#
# CONFIG_I2C_HID is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_COMMON=m
CONFIG_USB_ARCH_HAS_HCD=y
CONFIG_USB=m
# CONFIG_USB_DEBUG is not set
CONFIG_USB_ANNOUNCE_NEW_DEVICES=y

#
# Miscellaneous USB options
#
# CONFIG_USB_DYNAMIC_MINORS is not set
# CONFIG_USB_OTG_WHITELIST is not set
CONFIG_USB_OTG_BLACKLIST_HUB=y
CONFIG_USB_DWC3=m
# CONFIG_USB_DWC3_DEBUG is not set
# CONFIG_USB_MON is not set
CONFIG_USB_WUSB=m
CONFIG_USB_WUSB_CBAF=m
CONFIG_USB_WUSB_CBAF_DEBUG=y

#
# USB Host Controller Drivers
#
# CONFIG_USB_C67X00_HCD is not set
# CONFIG_USB_XHCI_HCD is not set
CONFIG_USB_EHCI_HCD=m
CONFIG_USB_EHCI_ROOT_HUB_TT=y
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=m
CONFIG_USB_OXU210HP_HCD=m
CONFIG_USB_ISP116X_HCD=m
# CONFIG_USB_ISP1760_HCD is not set
CONFIG_USB_ISP1362_HCD=m
# CONFIG_USB_OHCI_HCD is not set
CONFIG_USB_EHCI_HCD_PLATFORM=m
# CONFIG_USB_UHCI_HCD is not set
CONFIG_USB_U132_HCD=m
# CONFIG_USB_SL811_HCD is not set
# CONFIG_USB_R8A66597_HCD is not set
CONFIG_USB_WHCI_HCD=m
# CONFIG_USB_HWA_HCD is not set
# CONFIG_USB_HCD_SSB is not set
CONFIG_USB_MUSB_HDRC=m
# CONFIG_USB_MUSB_TUSB6010 is not set
CONFIG_MUSB_PIO_ONLY=y
# CONFIG_USB_CHIPIDEA is not set
# CONFIG_USB_RENESAS_USBHS is not set

#
# USB Device Class drivers
#
# CONFIG_USB_ACM is not set
# CONFIG_USB_PRINTER is not set
# CONFIG_USB_WDM is not set
CONFIG_USB_TMC=m

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#

#
# also be needed; see USB_STORAGE Help for more info
#
CONFIG_USB_STORAGE=m
# CONFIG_USB_STORAGE_DEBUG is not set
# CONFIG_USB_STORAGE_REALTEK is not set
# CONFIG_USB_STORAGE_DATAFAB is not set
# CONFIG_USB_STORAGE_FREECOM is not set
CONFIG_USB_STORAGE_ISD200=m
CONFIG_USB_STORAGE_USBAT=m
CONFIG_USB_STORAGE_SDDR09=m
CONFIG_USB_STORAGE_SDDR55=m
# CONFIG_USB_STORAGE_JUMPSHOT is not set
# CONFIG_USB_STORAGE_ALAUDA is not set
CONFIG_USB_STORAGE_ONETOUCH=m
CONFIG_USB_STORAGE_KARMA=m
# CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
# CONFIG_USB_STORAGE_ENE_UB6250 is not set

#
# USB Imaging devices
#
CONFIG_USB_MDC800=m
# CONFIG_USB_MICROTEK is not set

#
# USB port drivers
#
CONFIG_USB_SERIAL=m
# CONFIG_USB_SERIAL_GENERIC is not set
CONFIG_USB_SERIAL_AIRCABLE=m
# CONFIG_USB_SERIAL_ARK3116 is not set
# CONFIG_USB_SERIAL_BELKIN is not set
# CONFIG_USB_SERIAL_CH341 is not set
# CONFIG_USB_SERIAL_WHITEHEAT is not set
CONFIG_USB_SERIAL_DIGI_ACCELEPORT=m
# CONFIG_USB_SERIAL_CP210X is not set
CONFIG_USB_SERIAL_CYPRESS_M8=m
# CONFIG_USB_SERIAL_EMPEG is not set
# CONFIG_USB_SERIAL_FTDI_SIO is not set
# CONFIG_USB_SERIAL_FUNSOFT is not set
# CONFIG_USB_SERIAL_VISOR is not set
CONFIG_USB_SERIAL_IPAQ=m
# CONFIG_USB_SERIAL_IR is not set
# CONFIG_USB_SERIAL_EDGEPORT is not set
# CONFIG_USB_SERIAL_EDGEPORT_TI is not set
# CONFIG_USB_SERIAL_F81232 is not set
# CONFIG_USB_SERIAL_GARMIN is not set
# CONFIG_USB_SERIAL_IPW is not set
CONFIG_USB_SERIAL_IUU=m
CONFIG_USB_SERIAL_KEYSPAN_PDA=m
# CONFIG_USB_SERIAL_KEYSPAN is not set
# CONFIG_USB_SERIAL_KLSI is not set
# CONFIG_USB_SERIAL_KOBIL_SCT is not set
# CONFIG_USB_SERIAL_MCT_U232 is not set
CONFIG_USB_SERIAL_METRO=m
CONFIG_USB_SERIAL_MOS7720=m
# CONFIG_USB_SERIAL_MOS7840 is not set
CONFIG_USB_SERIAL_MOTOROLA=m
CONFIG_USB_SERIAL_NAVMAN=m
CONFIG_USB_SERIAL_PL2303=m
CONFIG_USB_SERIAL_OTI6858=m
# CONFIG_USB_SERIAL_QCAUX is not set
# CONFIG_USB_SERIAL_QUALCOMM is not set
# CONFIG_USB_SERIAL_SPCP8X5 is not set
CONFIG_USB_SERIAL_HP4X=m
# CONFIG_USB_SERIAL_SAFE is not set
# CONFIG_USB_SERIAL_SIEMENS_MPI is not set
CONFIG_USB_SERIAL_SIERRAWIRELESS=m
CONFIG_USB_SERIAL_SYMBOL=m
CONFIG_USB_SERIAL_TI=m
CONFIG_USB_SERIAL_CYBERJACK=m
# CONFIG_USB_SERIAL_XIRCOM is not set
CONFIG_USB_SERIAL_WWAN=m
CONFIG_USB_SERIAL_OPTION=m
CONFIG_USB_SERIAL_OMNINET=m
# CONFIG_USB_SERIAL_OPTICON is not set
CONFIG_USB_SERIAL_VIVOPAY_SERIAL=m
# CONFIG_USB_SERIAL_ZIO is not set
CONFIG_USB_SERIAL_ZTE=m
CONFIG_USB_SERIAL_SSU100=m
CONFIG_USB_SERIAL_QT2=m
# CONFIG_USB_SERIAL_DEBUG is not set

#
# USB Miscellaneous drivers
#
# CONFIG_USB_EMI62 is not set
CONFIG_USB_EMI26=m
# CONFIG_USB_ADUTUX is not set
# CONFIG_USB_SEVSEG is not set
# CONFIG_USB_RIO500 is not set
CONFIG_USB_LEGOTOWER=m
CONFIG_USB_LCD=m
# CONFIG_USB_LED is not set
CONFIG_USB_CYPRESS_CY7C63=m
# CONFIG_USB_CYTHERM is not set
CONFIG_USB_IDMOUSE=m
CONFIG_USB_FTDI_ELAN=m
# CONFIG_USB_APPLEDISPLAY is not set
CONFIG_USB_SISUSBVGA=m
CONFIG_USB_LD=m
# CONFIG_USB_TRANCEVIBRATOR is not set
CONFIG_USB_IOWARRIOR=m
CONFIG_USB_TEST=m
CONFIG_USB_ISIGHTFW=m
# CONFIG_USB_YUREX is not set
CONFIG_USB_EZUSB_FX2=m

#
# USB Physical Layer drivers
#
CONFIG_USB_ISP1301=m
CONFIG_USB_RCAR_PHY=m
CONFIG_USB_ATM=m
CONFIG_USB_SPEEDTOUCH=m
CONFIG_USB_CXACRU=m
# CONFIG_USB_UEAGLEATM is not set
# CONFIG_USB_XUSBATM is not set
CONFIG_USB_GADGET=m
# CONFIG_USB_GADGET_DEBUG is not set
# CONFIG_USB_GADGET_DEBUG_FILES is not set
# CONFIG_USB_GADGET_DEBUG_FS is not set
CONFIG_USB_GADGET_VBUS_DRAW=2
CONFIG_USB_GADGET_STORAGE_NUM_BUFFERS=2

#
# USB Peripheral Controller
#
# CONFIG_USB_R8A66597 is not set
CONFIG_USB_MV_UDC=m
CONFIG_USB_GADGET_MUSB_HDRC=m
# CONFIG_USB_M66592 is not set
# CONFIG_USB_AMD5536UDC is not set
# CONFIG_USB_NET2272 is not set
# CONFIG_USB_NET2280 is not set
CONFIG_USB_GOKU=m
# CONFIG_USB_EG20T is not set
# CONFIG_USB_DUMMY_HCD is not set
CONFIG_USB_LIBCOMPOSITE=m
# CONFIG_USB_ZERO is not set
# CONFIG_USB_ETH is not set
# CONFIG_USB_G_NCM is not set
CONFIG_USB_GADGETFS=m
# CONFIG_USB_FUNCTIONFS is not set
CONFIG_USB_MASS_STORAGE=m
CONFIG_USB_GADGET_TARGET=m
# CONFIG_USB_G_SERIAL is not set
CONFIG_USB_G_PRINTER=m
# CONFIG_USB_CDC_COMPOSITE is not set
# CONFIG_USB_G_NOKIA is not set
CONFIG_USB_G_ACM_MS=m
CONFIG_USB_G_MULTI=m
CONFIG_USB_G_MULTI_RNDIS=y
CONFIG_USB_G_MULTI_CDC=y
# CONFIG_USB_G_HID is not set
# CONFIG_USB_G_DBGP is not set

#
# OTG and related infrastructure
#
CONFIG_USB_OTG_UTILS=y
CONFIG_USB_GPIO_VBUS=m
# CONFIG_NOP_USB_XCEIV is not set
CONFIG_UWB=m
# CONFIG_UWB_HWA is not set
CONFIG_UWB_WHCI=m
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=m

#
# LED drivers
#
CONFIG_LEDS_LM3530=m
# CONFIG_LEDS_LM3533 is not set
CONFIG_LEDS_LM3642=m
CONFIG_LEDS_GPIO=m
# CONFIG_LEDS_LP3944 is not set
CONFIG_LEDS_LP5521=m
# CONFIG_LEDS_LP5523 is not set
# CONFIG_LEDS_CLEVO_MAIL is not set
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA9633 is not set
CONFIG_LEDS_DA9052=m
CONFIG_LEDS_DAC124S085=m
# CONFIG_LEDS_REGULATOR is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_INTEL_SS4200=m
# CONFIG_LEDS_LT3593 is not set
CONFIG_LEDS_MC13783=m
CONFIG_LEDS_TCA6507=m
CONFIG_LEDS_LM355x=m
# CONFIG_LEDS_OT200 is not set
# CONFIG_LEDS_BLINKM is not set
# CONFIG_LEDS_TRIGGERS is not set

#
# LED Triggers
#
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=m
# CONFIG_INFINIBAND_USER_MAD is not set
# CONFIG_INFINIBAND_USER_ACCESS is not set
CONFIG_INFINIBAND_ADDR_TRANS=y
# CONFIG_INFINIBAND_MTHCA is not set
CONFIG_INFINIBAND_QIB=m
# CONFIG_INFINIBAND_AMSO1100 is not set
# CONFIG_INFINIBAND_NES is not set
# CONFIG_INFINIBAND_IPOIB is not set
# CONFIG_INFINIBAND_SRP is not set
# CONFIG_INFINIBAND_SRPT is not set
CONFIG_INFINIBAND_ISER=m
# CONFIG_EDAC is not set
# CONFIG_RTC_CLASS is not set
CONFIG_DMADEVICES=y
CONFIG_DMADEVICES_DEBUG=y
# CONFIG_DMADEVICES_VDEBUG is not set

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=m
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_TIMB_DMA is not set
CONFIG_PCH_DMA=m
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
# CONFIG_NET_DMA is not set
CONFIG_ASYNC_TX_DMA=y
# CONFIG_DMATEST is not set
# CONFIG_AUXDISPLAY is not set
CONFIG_UIO=m
CONFIG_UIO_CIF=m
CONFIG_UIO_PDRV=m
CONFIG_UIO_PDRV_GENIRQ=m
CONFIG_UIO_DMEM_GENIRQ=m
# CONFIG_UIO_AEC is not set
CONFIG_UIO_SERCOS3=m
CONFIG_UIO_PCI_GENERIC=m
CONFIG_UIO_NETX=m

#
# Virtio drivers
#

#
# Microsoft Hyper-V guest support
#
# CONFIG_HYPERV is not set
CONFIG_STAGING=y
# CONFIG_ET131X is not set
CONFIG_SLICOSS=m
CONFIG_USBIP_CORE=m
CONFIG_USBIP_VHCI_HCD=m
# CONFIG_USBIP_HOST is not set
# CONFIG_USBIP_DEBUG is not set
# CONFIG_ECHO is not set
# CONFIG_COMEDI is not set
CONFIG_ASUS_OLED=m
CONFIG_R8187SE=m
# CONFIG_RTL8192U is not set
CONFIG_RTLLIB=m
CONFIG_RTLLIB_CRYPTO_CCMP=m
# CONFIG_RTLLIB_CRYPTO_TKIP is not set
CONFIG_RTLLIB_CRYPTO_WEP=m
# CONFIG_RTL8192E is not set
# CONFIG_R8712U is not set
# CONFIG_RTS5139 is not set
# CONFIG_TRANZPORT is not set
CONFIG_USB_SERIAL_QUATECH2=m
# CONFIG_VT6655 is not set
CONFIG_VT6656=m
# CONFIG_DX_SEP is not set

#
# IIO staging drivers
#
CONFIG_IIO_ST_HWMON=m
CONFIG_IIO_SW_RING=m

#
# Accelerometers
#
CONFIG_ADIS16201=m
# CONFIG_ADIS16203 is not set
CONFIG_ADIS16204=m
CONFIG_ADIS16209=m
# CONFIG_ADIS16220 is not set
CONFIG_ADIS16240=m
CONFIG_KXSD9=m
# CONFIG_LIS3L02DQ is not set
CONFIG_SCA3000=m

#
# Analog to digital converters
#
# CONFIG_AD7291 is not set
CONFIG_AD7606=m
CONFIG_AD7606_IFACE_PARALLEL=m
# CONFIG_AD7606_IFACE_SPI is not set
CONFIG_AD799X=m
CONFIG_AD799X_RING_BUFFER=y
CONFIG_AD7780=m
# CONFIG_AD7816 is not set
CONFIG_AD7192=m
CONFIG_ADT7410=m
CONFIG_AD7280=m

#
# Analog digital bi-direction converters
#
# CONFIG_ADT7316 is not set

#
# Capacitance to digital converters
#
# CONFIG_AD7150 is not set
CONFIG_AD7152=m
# CONFIG_AD7746 is not set

#
# Direct Digital Synthesis
#
CONFIG_AD5930=m
CONFIG_AD9832=m
CONFIG_AD9834=m
CONFIG_AD9850=m
CONFIG_AD9852=m
# CONFIG_AD9910 is not set
# CONFIG_AD9951 is not set

#
# Digital gyroscope sensors
#
CONFIG_ADIS16060=m
CONFIG_ADIS16080=m
CONFIG_ADIS16130=m
CONFIG_ADIS16260=m
CONFIG_ADXRS450=m

#
# Network Analyzer, Impedance Converters
#
# CONFIG_AD5933 is not set

#
# Inertial measurement units
#
CONFIG_ADIS16400=m

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=m
# CONFIG_SENSORS_ISL29028 is not set
# CONFIG_SENSORS_TSL2563 is not set
# CONFIG_TSL2583 is not set
# CONFIG_TSL2x7x is not set

#
# Magnetometer sensors
#
CONFIG_SENSORS_AK8975=m
CONFIG_SENSORS_HMC5843=m

#
# Active energy metering IC
#
CONFIG_ADE7753=m
# CONFIG_ADE7754 is not set
# CONFIG_ADE7758 is not set
CONFIG_ADE7759=m
# CONFIG_ADE7854 is not set

#
# Resolver to digital converters
#
CONFIG_AD2S90=m
CONFIG_AD2S1200=m
# CONFIG_AD2S1210 is not set

#
# Triggers - standalone
#
CONFIG_IIO_GPIO_TRIGGER=m
# CONFIG_IIO_SYSFS_TRIGGER is not set
# CONFIG_IIO_SIMPLE_DUMMY is not set
# CONFIG_ZSMALLOC is not set
CONFIG_FB_SM7XX=m
# CONFIG_CRYSTALHD is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_USB_ENESTORAGE is not set
# CONFIG_BCM_WIMAX is not set
CONFIG_FT1000=m
CONFIG_FT1000_USB=m

#
# Speakup console speech
#
# CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=m
CONFIG_STAGING_MEDIA=y
# CONFIG_DVB_AS102 is not set
CONFIG_DVB_CXD2099=m

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_USB_WPAN_HCD is not set
CONFIG_WIMAX_GDM72XX=m
CONFIG_WIMAX_GDM72XX_QOS=y
CONFIG_WIMAX_GDM72XX_K_MODE=y
CONFIG_WIMAX_GDM72XX_WIMAX2=y
CONFIG_WIMAX_GDM72XX_USB=y
CONFIG_ZCACHE2=y
# CONFIG_NET_VENDOR_SILICOM is not set
# CONFIG_CED1401 is not set
# CONFIG_DGRP is not set
CONFIG_SB105X=m
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
# CONFIG_IOMMU_SUPPORT is not set

#
# Remoteproc drivers (EXPERIMENTAL)
#

#
# Rpmsg drivers (EXPERIMENTAL)
#
# CONFIG_VIRT_DRIVERS is not set
# CONFIG_PM_DEVFREQ is not set
# CONFIG_EXTCON is not set
# CONFIG_MEMORY is not set
CONFIG_IIO=m
CONFIG_IIO_BUFFER=y
CONFIG_IIO_BUFFER_CB=y
CONFIG_IIO_KFIFO_BUF=m
CONFIG_IIO_TRIGGERED_BUFFER=m
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Accelerometers
#

#
# Analog to digital converters
#
CONFIG_AD_SIGMA_DELTA=m
CONFIG_AD7266=m
# CONFIG_AD7298 is not set
# CONFIG_AD7791 is not set
# CONFIG_AD7793 is not set
CONFIG_AD7476=m
# CONFIG_AD7887 is not set
# CONFIG_MAX1363 is not set
# CONFIG_TI_ADC081C is not set
CONFIG_VIPERBOARD_ADC=m

#
# Amplifiers
#
# CONFIG_AD8366 is not set

#
# Hid Sensor IIO Common
#

#
# Digital to analog converters
#
CONFIG_AD5064=m
CONFIG_AD5360=m
CONFIG_AD5380=m
# CONFIG_AD5421 is not set
# CONFIG_AD5624R_SPI is not set
CONFIG_AD5446=m
CONFIG_AD5449=m
CONFIG_AD5504=m
CONFIG_AD5755=m
CONFIG_AD5764=m
# CONFIG_AD5791 is not set
# CONFIG_AD5686 is not set
# CONFIG_MAX517 is not set
CONFIG_MCP4725=m

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#
CONFIG_AD9523=m

#
# Phase-Locked Loop (PLL) frequency synthesizers
#
# CONFIG_ADF4350 is not set

#
# Digital gyroscope sensors
#
# CONFIG_ADIS16136 is not set

#
# Inertial measurement units
#
# CONFIG_ADIS16480 is not set
CONFIG_IIO_ADIS_LIB=m
CONFIG_IIO_ADIS_LIB_BUFFER=y

#
# Light sensors
#
CONFIG_ADJD_S311=m
# CONFIG_SENSORS_LM3533 is not set
CONFIG_VCNL4000=m

#
# Magnetometer sensors
#
# CONFIG_VME_BUS is not set
CONFIG_PWM=y
# CONFIG_IPACK_BUS is not set

#
# Firmware Drivers
#
CONFIG_EDD=m
CONFIG_EDD_OFF=y
# CONFIG_FIRMWARE_MEMMAP is not set
# CONFIG_DELL_RBU is not set
CONFIG_DCDBAS=m
# CONFIG_DMIID is not set
# CONFIG_DMI_SYSFS is not set
# CONFIG_ISCSI_IBFT_FIND is not set
CONFIG_GOOGLE_FIRMWARE=y

#
# Google Firmware Drivers
#
# CONFIG_GOOGLE_SMI is not set
CONFIG_GOOGLE_MEMCONSOLE=m

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
# CONFIG_EXT3_FS is not set
# CONFIG_EXT4_FS is not set
# CONFIG_REISERFS_FS is not set
CONFIG_JFS_FS=m
CONFIG_JFS_POSIX_ACL=y
# CONFIG_JFS_SECURITY is not set
CONFIG_JFS_DEBUG=y
CONFIG_JFS_STATISTICS=y
# CONFIG_XFS_FS is not set
# CONFIG_GFS2_FS is not set
# CONFIG_OCFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
CONFIG_FILE_LOCKING=y
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_FANOTIFY=y
# CONFIG_QUOTA is not set
# CONFIG_QUOTACTL is not set
# CONFIG_AUTOFS4_FS is not set
# CONFIG_FUSE_FS is not set
CONFIG_GENERIC_ACL=y

#
# Caches
#
CONFIG_FSCACHE=m
CONFIG_FSCACHE_STATS=y
CONFIG_FSCACHE_HISTOGRAM=y
# CONFIG_FSCACHE_DEBUG is not set
# CONFIG_FSCACHE_OBJECT_LIST is not set
# CONFIG_CACHEFILES is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=m
# CONFIG_MSDOS_FS is not set
CONFIG_VFAT_FS=m
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
# CONFIG_PROC_SYSCTL is not set
# CONFIG_PROC_PAGE_MONITOR is not set
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_TMPFS_POSIX_ACL=y
CONFIG_TMPFS_XATTR=y
# CONFIG_HUGETLBFS is not set
# CONFIG_HUGETLB_PAGE is not set
CONFIG_CONFIGFS_FS=m
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_HFSPLUS_FS is not set
# CONFIG_CRAMFS is not set
# CONFIG_SQUASHFS is not set
# CONFIG_VXFS_FS is not set
# CONFIG_MINIX_FS is not set
CONFIG_OMFS_FS=m
# CONFIG_HPFS_FS is not set
CONFIG_QNX4FS_FS=m
# CONFIG_QNX6FS_FS is not set
CONFIG_ROMFS_FS=m
CONFIG_ROMFS_BACKED_BY_BLOCK=y
CONFIG_ROMFS_ON_BLOCK=y
# CONFIG_PSTORE is not set
# CONFIG_SYSV_FS is not set
# CONFIG_UFS_FS is not set
# CONFIG_F2FS_FS is not set
# CONFIG_NETWORK_FILESYSTEMS is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
# CONFIG_NLS_CODEPAGE_775 is not set
# CONFIG_NLS_CODEPAGE_850 is not set
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=m
# CONFIG_NLS_CODEPAGE_857 is not set
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=m
# CONFIG_NLS_CODEPAGE_862 is not set
CONFIG_NLS_CODEPAGE_863=m
CONFIG_NLS_CODEPAGE_864=m
CONFIG_NLS_CODEPAGE_865=m
# CONFIG_NLS_CODEPAGE_866 is not set
CONFIG_NLS_CODEPAGE_869=m
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=m
# CONFIG_NLS_CODEPAGE_932 is not set
# CONFIG_NLS_CODEPAGE_949 is not set
CONFIG_NLS_CODEPAGE_874=m
CONFIG_NLS_ISO8859_8=m
# CONFIG_NLS_CODEPAGE_1250 is not set
CONFIG_NLS_CODEPAGE_1251=m
CONFIG_NLS_ASCII=m
CONFIG_NLS_ISO8859_1=m
CONFIG_NLS_ISO8859_2=m
CONFIG_NLS_ISO8859_3=m
CONFIG_NLS_ISO8859_4=m
CONFIG_NLS_ISO8859_5=m
# CONFIG_NLS_ISO8859_6 is not set
CONFIG_NLS_ISO8859_7=m
# CONFIG_NLS_ISO8859_9 is not set
CONFIG_NLS_ISO8859_13=m
# CONFIG_NLS_ISO8859_14 is not set
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=m
CONFIG_NLS_KOI8_U=m
# CONFIG_NLS_MAC_ROMAN is not set
# CONFIG_NLS_MAC_CELTIC is not set
CONFIG_NLS_MAC_CENTEURO=m
# CONFIG_NLS_MAC_CROATIAN is not set
# CONFIG_NLS_MAC_CYRILLIC is not set
# CONFIG_NLS_MAC_GAELIC is not set
# CONFIG_NLS_MAC_GREEK is not set
CONFIG_NLS_MAC_ICELAND=m
# CONFIG_NLS_MAC_INUIT is not set
CONFIG_NLS_MAC_ROMANIAN=m
# CONFIG_NLS_MAC_TURKISH is not set
# CONFIG_NLS_UTF8 is not set
# CONFIG_DLM is not set

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=2048
CONFIG_MAGIC_SYSRQ=y
CONFIG_STRIP_ASM_SYMS=y
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
# CONFIG_DEBUG_SECTION_MISMATCH is not set
CONFIG_DEBUG_KERNEL=y
# CONFIG_DEBUG_SHIRQ is not set
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
CONFIG_DETECT_HUNG_TASK=y
CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y
CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=1
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
# CONFIG_TIMER_STATS is not set
CONFIG_DEBUG_OBJECTS=y
# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
CONFIG_DEBUG_OBJECTS_FREE=y
# CONFIG_DEBUG_OBJECTS_TIMERS is not set
# CONFIG_DEBUG_OBJECTS_WORK is not set
CONFIG_DEBUG_OBJECTS_RCU_HEAD=y
# CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER is not set
CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
# CONFIG_SLUB_STATS is not set
CONFIG_HAVE_DEBUG_KMEMLEAK=y
CONFIG_DEBUG_RT_MUTEXES=y
CONFIG_DEBUG_PI_LIST=y
CONFIG_RT_MUTEX_TESTER=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
# CONFIG_PROVE_RCU is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_LOCKDEP=y
# CONFIG_LOCK_STAT is not set
# CONFIG_DEBUG_LOCKDEP is not set
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
# CONFIG_DEBUG_STACK_USAGE is not set
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_VM=y
# CONFIG_DEBUG_VM_RB is not set
CONFIG_DEBUG_VIRTUAL=y
CONFIG_DEBUG_WRITECOUNT=y
CONFIG_DEBUG_MEMORY_INIT=y
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
CONFIG_DEBUG_SG=y
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
# CONFIG_RCU_TORTURE_TEST is not set
CONFIG_RCU_CPU_STALL_TIMEOUT=21
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_KPROBES_SANITY_TEST is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_DEBUG_BLOCK_EXT_DEVT=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
# CONFIG_DEBUG_PER_CPU_MAPS is not set
# CONFIG_LKDTM is not set
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
# CONFIG_FAIL_MAKE_REQUEST is not set
CONFIG_FAIL_IO_TIMEOUT=y
CONFIG_FAULT_INJECTION_DEBUG_FS=y
CONFIG_LATENCYTOP=y
# CONFIG_DEBUG_PAGEALLOC is not set
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_FENTRY=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACE_CLOCK=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
# CONFIG_EVENT_POWER_TRACING_DEPRECATED is not set
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
# CONFIG_FUNCTION_TRACER is not set
# CONFIG_IRQSOFF_TRACER is not set
# CONFIG_SCHED_TRACER is not set
# CONFIG_FTRACE_SYSCALLS is not set
CONFIG_BRANCH_PROFILE_NONE=y
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
# CONFIG_PROFILE_ALL_BRANCHES is not set
# CONFIG_STACK_TRACER is not set
# CONFIG_BLK_DEV_IO_TRACE is not set
CONFIG_KPROBE_EVENT=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
CONFIG_EVENT_TRACE_TEST_SYSCALLS=y
CONFIG_MMIOTRACE=y
CONFIG_MMIOTRACE_TEST=m
CONFIG_RING_BUFFER_BENCHMARK=m
CONFIG_RBTREE_TEST=m
CONFIG_INTERVAL_TREE_TEST=m
CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
# CONFIG_DYNAMIC_DEBUG is not set
# CONFIG_DMA_API_DEBUG is not set
CONFIG_ATOMIC64_SELFTEST=y
CONFIG_ASYNC_RAID6_TEST=m
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
# CONFIG_KMEMCHECK is not set
CONFIG_TEST_KSTRTOX=m
CONFIG_STRICT_DEVMEM=y
CONFIG_X86_VERBOSE_BOOTUP=y
# CONFIG_EARLY_PRINTK is not set
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_X86_PTDUMP=y
# CONFIG_DEBUG_RODATA is not set
CONFIG_DEBUG_SET_MODULE_RONX=y
CONFIG_DEBUG_NX_TEST=m
# CONFIG_DEBUG_TLBFLUSH is not set
# CONFIG_IOMMU_STRESS is not set
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
# CONFIG_X86_DECODER_SELFTEST is not set
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
CONFIG_DEBUG_BOOT_PARAMS=y
CONFIG_CPA_DEBUG=y
CONFIG_OPTIMIZE_INLINING=y
# CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
CONFIG_DEBUG_NMI_SELFTEST=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_TRUSTED_KEYS=m
CONFIG_ENCRYPTED_KEYS=m
CONFIG_KEYS_DEBUG_PROC_KEYS=y
CONFIG_SECURITY_DMESG_RESTRICT=y
# CONFIG_SECURITY is not set
CONFIG_SECURITYFS=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_XOR_BLOCKS=m
CONFIG_ASYNC_CORE=m
CONFIG_ASYNC_MEMCPY=m
CONFIG_ASYNC_XOR=m
CONFIG_ASYNC_PQ=m
CONFIG_ASYNC_RAID6_RECOV=m
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_FIPS=y
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=m
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=m
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=m
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP=m
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=m
CONFIG_CRYPTO_MANAGER2=y
# CONFIG_CRYPTO_USER is not set
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=m
# CONFIG_CRYPTO_NULL is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=m
CONFIG_CRYPTO_AUTHENC=m
CONFIG_CRYPTO_TEST=m
CONFIG_CRYPTO_ABLK_HELPER_X86=m
CONFIG_CRYPTO_GLUE_HELPER_X86=m

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=m
CONFIG_CRYPTO_GCM=m
CONFIG_CRYPTO_SEQIV=m

#
# Block modes
#
CONFIG_CRYPTO_CBC=m
CONFIG_CRYPTO_CTR=m
CONFIG_CRYPTO_CTS=m
CONFIG_CRYPTO_ECB=m
CONFIG_CRYPTO_LRW=m
CONFIG_CRYPTO_PCBC=m
CONFIG_CRYPTO_XTS=m

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=m

#
# Digest
#
CONFIG_CRYPTO_CRC32C=m
CONFIG_CRYPTO_CRC32C_X86_64=y
CONFIG_CRYPTO_CRC32C_INTEL=m
CONFIG_CRYPTO_GHASH=m
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=m
CONFIG_CRYPTO_MICHAEL_MIC=m
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
# CONFIG_CRYPTO_RMD256 is not set
CONFIG_CRYPTO_RMD320=m
CONFIG_CRYPTO_SHA1=m
# CONFIG_CRYPTO_SHA1_SSSE3 is not set
CONFIG_CRYPTO_SHA256=m
CONFIG_CRYPTO_SHA512=m
CONFIG_CRYPTO_TGR192=m
# CONFIG_CRYPTO_WP512 is not set
# CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=m
CONFIG_CRYPTO_AES_NI_INTEL=m
# CONFIG_CRYPTO_ANUBIS is not set
CONFIG_CRYPTO_ARC4=m
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_BLOWFISH_COMMON=m
CONFIG_CRYPTO_BLOWFISH_X86_64=m
# CONFIG_CRYPTO_CAMELLIA is not set
CONFIG_CRYPTO_CAMELLIA_X86_64=m
CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64=m
# CONFIG_CRYPTO_CAST5 is not set
# CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
# CONFIG_CRYPTO_CAST6 is not set
# CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
CONFIG_CRYPTO_DES=m
# CONFIG_CRYPTO_FCRYPT is not set
# CONFIG_CRYPTO_KHAZAD is not set
CONFIG_CRYPTO_SEED=m
CONFIG_CRYPTO_SERPENT=m
# CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
# CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
CONFIG_CRYPTO_TEA=m
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=m
CONFIG_CRYPTO_TWOFISH_X86_64=m
CONFIG_CRYPTO_TWOFISH_X86_64_3WAY=m
CONFIG_CRYPTO_TWOFISH_AVX_X86_64=m

#
# Compression
#
CONFIG_CRYPTO_DEFLATE=m
CONFIG_CRYPTO_ZLIB=m
CONFIG_CRYPTO_LZO=y

#
# Random Number Generation
#
CONFIG_CRYPTO_ANSI_CPRNG=m
CONFIG_CRYPTO_USER_API=m
CONFIG_CRYPTO_USER_API_HASH=m
CONFIG_CRYPTO_USER_API_SKCIPHER=m
# CONFIG_CRYPTO_HW is not set
CONFIG_ASYMMETRIC_KEY_TYPE=m
# CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_RAID6_PQ=m
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_PERCPU_RWSEM=y
CONFIG_CRC_CCITT=m
CONFIG_CRC16=m
CONFIG_CRC_T10DIF=m
CONFIG_CRC_ITU_T=m
CONFIG_CRC32=y
CONFIG_CRC32_SELFTEST=y
CONFIG_CRC32_SLICEBY8=y
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
# CONFIG_CRC32_BIT is not set
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=m
CONFIG_CRC8=m
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=m
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
# CONFIG_XZ_DEC is not set
# CONFIG_XZ_DEC_BCJ is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPU_RMAP=y
CONFIG_DQL=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
# CONFIG_CORDIC is not set
CONFIG_DDR=y
# CONFIG_ATA_SFF is not set
# CONFIG_ISDN_DRV_LOOP is not set

--J2SCkAp4GZ/dPZZf--
