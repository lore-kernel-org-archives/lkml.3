Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab3JGCLY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 22:11:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:31425 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921Ab3JGCLW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 22:11:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1046,1371106800"; 
   d="scan'208";a="406327395"
Date: Mon, 7 Oct 2013 10:11:18 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: xen-devel@lists.xenproject.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [xen] double fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Message-ID: <20131007021118.GA27927@localhost>
References: <20131006082340.GA24568@localhost>
 <CA+55aFxk2FoG7+BpHJAysR2bz-WQXpje6buMd8Sp6-SBqHexZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxk2FoG7+BpHJAysR2bz-WQXpje6buMd8Sp6-SBqHexZg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 06, 2013 at 10:26:24AM -0700, Linus Torvalds wrote:
> On Sun, Oct 6, 2013 at 1:23 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> >
> > I got the below dmesg and the first bad commit is commit cf39c8e5352b:
> >     Merge tag 'stable/for-linus-3.12-rc0-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip
> 
> Ugh. How reliable is the double fault? Because bisecting it to the
> merge that didn't even have any conflicts in it as far as I can
> remember means that there's something really subtle going on wrt some
> semantic conflict or other. Or, alternatively, it means that the
> bisect failed because the double fault isn't 100% reliable..

Oops, it's not a reliable bisect...

The "first" bad commit cf39c8e5352b4fb9efedfe7e9acb566a85ed847c runs
and produces 25 good dmesgs and 3530 bad dmesgs, however only 1 of the
bad boots has "double fault:" in its dmesg.

Looking into all the 3530 bad dmesgs, I find all kinds of bug messages:

$ grep_crash_head -h dmesg-* | sed 's/^[^a-zA-Z]*//' | sort | uniq -c | sort -nr

   3086 Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
   3047 BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
   3046 Kernel panic - not syncing: Fatal exception in interrupt
   2969 BUG: kernel boot oops
    374 BUG: kernel test oops
    255 WARNING: CPU: 0 PID: 1 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
    167 kernel BUG at /c/wfg/linux-drm/mm/slab.c:3011!
    167 invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
    148 Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
     48 INFO: lockdep is turned off.
     43 BUG: unable to handle kernel 
     33 BUG: kernel boot crashed
     30 BUG: sleeping function called from invalid context at /c/wfg/linux-drm/kernel/rwsem.c:20
     27 general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
     17 WARNING: CPU: 0 PID: 0 at /c/wfg/linux-drm/lib/debugobjects.c:260 debug_print_object+0x7c/0x8b()
     17 WARNING: CPU: 0 PID: 0 at /c/wfg/linux-drm/kernel/workqueue.c:458 work_fixup_activate+0x6a/0x6f()
     17 WARNING: CPU: 0 PID: 0 at /c/wfg/linux-drm/kernel/workqueue.c:1379 __queue_work+0x1a1/0x1ee()
     13 WARNING: CPU: 0 PID: 0 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
     13 BUG: unable to handle kernel NULL pointer dereference at           (null)
     12 Oops: 0010 [#1] PREEMPT SMP DEBUG_PAGEALLOC
     11 WARNING: CPU: 1 PID: 0 at /c/wfg/linux-drm/lib/debugobjects.c:260 debug_print_object+0x7c/0x8b()
     11 WARNING: CPU: 1 PID: 0 at /c/wfg/linux-drm/kernel/workqueue.c:458 work_fixup_activate+0x6a/0x6f()
     11 WARNING: CPU: 1 PID: 0 at /c/wfg/linux-drm/kernel/workqueue.c:1379 __queue_work+0x1a1/0x1ee()
     11 Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
      9 INFO: trying to register non-static key.
      9 BUG: scheduling while atomic: init/136/0x10000002
      8 WARNING: CPU: 1 PID: 0 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      8 BUG: unable to handle kernel NULL pointer dereference
      6 Oops: 0000 [#2] PREEMPT SMP DEBUG_PAGEALLOC
      5 BUG: unable to handle kernel paging request at ffffffffffffffa8
      5 BUG: Bad page map in process init  pte:ffffffffffffffff pmd:06d9e067
      5 BUG: Bad page map in process init  pte:ffffffff pmd:06d9e067
      4 Oops: 0002 [#1] 
      4 Kernel panic - not syncing: Attempted to kill the idle task!
      4 BUG: unable to handle kernel paging request at ffff88000cd94000
      3 invalid opcode: 0000 [#2] PREEMPT SMP DEBUG_PAGEALLOC
      3 WARNING: CPU: 1 PID: 95 at /c/wfg/linux-drm/lib/debugobjects.c:260 debug_print_object+0x7c/0x8b()
      3 WARNING: CPU: 1 PID: 95 at /c/wfg/linux-drm/kernel/workqueue.c:458 work_fixup_activate+0x6a/0x6f()
      3 WARNING: CPU: 1 PID: 95 at /c/wfg/linux-drm/kernel/workqueue.c:1379 __queue_work+0x1a1/0x1ee()
      3 WARNING: CPU: 1 PID: 1 at /c/wfg/linux-drm/lib/debugobjects.c:260 debug_print_object+0x7c/0x8b()
      3 WARNING: CPU: 1 PID: 1 at /c/wfg/linux-drm/kernel/workqueue.c:458 work_fixup_activate+0x6a/0x6f()
      3 WARNING: CPU: 1 PID: 1 at /c/wfg/linux-drm/kernel/workqueue.c:1379 __queue_work+0x1a1/0x1ee()
      3 WARNING: CPU: 0 PID: 116 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      3 BUG: kernel boot hang
      3 BUG: Bad page map in process init  pte:ffffffff81f0fa00 pmd:06d9e067
      3 BUG: Bad page map in process init  pte:ffffffff81b52e93 pmd:06d9e067
      3 BUG: Bad page map in process init  pte:dead4ead00000000 pmd:06d9e067
      2 kernel BUG at /c/wfg/linux-drm/include/linux/mm.h:286!
      2 general protection fault: 0000 [#2] PREEMPT SMP DEBUG_PAGEALLOC
      2 WARNING: CPU: 1 PID: 130 at /c/wfg/linux-drm/drivers/tty/tty_mutex.c:23 tty_lock_nested+0x34/0x83()
      2 WARNING: CPU: 1 PID: 121 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      2 WARNING: CPU: 1 PID: 1 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      2 WARNING: CPU: 0 PID: 20 at /c/wfg/linux-drm/lib/debugobjects.c:260 debug_print_object+0x7c/0x8b()
      2 WARNING: CPU: 0 PID: 20 at /c/wfg/linux-drm/kernel/workqueue.c:458 work_fixup_activate+0x6a/0x6f()
      2 WARNING: CPU: 0 PID: 20 at /c/wfg/linux-drm/kernel/workqueue.c:1379 __queue_work+0x1a1/0x1ee()
      2 WARNING: CPU: 0 PID: 1 at /c/wfg/linux-drm/lib/debugobjects.c:260 debug_print_object+0x7c/0x8b()
      2 WARNING: CPU: 0 PID: 1 at /c/wfg/linux-drm/kernel/workqueue.c:458 work_fixup_activate+0x6a/0x6f()
      2 WARNING: CPU: 0 PID: 1 at /c/wfg/linux-drm/kernel/workqueue.c:1379 __queue_work+0x1a1/0x1ee()
      2 Oops: 0002 [#1] PREEMPT 
      2 Oops: 0000 [#3] PREEMPT SMP DEBUG_PAGEALLOC
      2 BUG: unable to handle kernel paging request at 0000000000010012
      2 BUG: unable to handle kernel NULL pointer dereference at 00000000000008e0
      2 BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
      2 BUG: unable to handle kernel NULL pointer dereference at 0000000000000017
      2 BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
      2 BUG: scheduling while atomic: rc.local/134/0x10000002
      2 BUG: scheduling while atomic: S99-rc.local/210/0x10000002
      2 BUG: Bad page map in process init  pte:ffffffff81b6e50a pmd:06d9e067
      2 BUG: Bad page map in process init  pte:ffff880006d9e290 pmd:06d9e067
      2 BUG: Bad page map in process init  pte:ffff880006d9e208 pmd:06d9e067
      2 BUG: Bad page map in process init  pte:ffff880006d9e180 pmd:06d9e067
      2 BUG: Bad page map in process init  pte:ffff880006d9e0f8 pmd:06d9e067
      2 BUG: Bad page map in process init  pte:ffff880006d9e080 pmd:06d9e067
      2 BUG: Bad page map in process init  pte:ffff880006d9e070 pmd:06d9e067
      2 BUG: Bad page map in process init  pte:00000001 pmd:06d9e067
      1 tail/181 is trying to release lock (&sig->cred_guard_mutex) at:
      1 kernel BUG at /c/wfg/linux-drm/mm/slab.c:463!
      1 general protection fault: 0000 [#3] PREEMPT SMP DEBUG_PAGEALLOC
      1 double fault: 0000 [#9] PREEMPT SMP DEBUG_PAGEALLOC
      1 WARNING: CPU: 1 PID: 95 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      1 WARNING: CPU: 1 PID: 222 at /c/wfg/linux-drm/include/linux/kref.h:47 kobject_get+0x37/0x44()
      1 WARNING: CPU: 1 PID: 22 at /c/wfg/linux-drm/lib/debugobjects.c:260 debug_print_object+0x7c/0x8b()
      1 WARNING: CPU: 1 PID: 22 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      1 WARNING: CPU: 1 PID: 22 at /c/wfg/linux-drm/kernel/workqueue.c:458 work_fixup_activate+0x6a/0x6f()
      1 WARNING: CPU: 1 PID: 22 at /c/wfg/linux-drm/kernel/workqueue.c:1379 __queue_work+0x1a1/0x1ee()
      1 WARNING: CPU: 1 PID: 168 at /c/wfg/linux-drm/lib/debugobjects.c:260 debug_print_object+0x7c/0x8b()
      1 WARNING: CPU: 1 PID: 168 at /c/wfg/linux-drm/kernel/workqueue.c:458 work_fixup_activate+0x6a/0x6f()
      1 WARNING: CPU: 1 PID: 168 at /c/wfg/linux-drm/kernel/workqueue.c:1379 __queue_work+0x1a1/0x1ee()
      1 WARNING: CPU: 1 PID: 130 at /c/wfg/linux-drm/include/linux/kref.h:47 kref_get+0x2d/0x36()
      1 WARNING: CPU: 1 PID: 130 at /c/wfg/linux-drm/drivers/tty/tty_io.c:1411 tty_open+0x215/0x42b()
      1 WARNING: CPU: 1 PID: 129 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      1 WARNING: CPU: 1 PID: 122 at /c/wfg/linux-drm/lib/debugobjects.c:260 debug_print_object+0x7c/0x8b()
      1 WARNING: CPU: 1 PID: 122 at /c/wfg/linux-drm/kernel/workqueue.c:458 work_fixup_activate+0x6a/0x6f()
      1 WARNING: CPU: 1 PID: 122 at /c/wfg/linux-drm/kernel/workqueue.c:1379 __queue_work+0x1a1/0x1ee()
      1 WARNING: CPU: 1 PID: 120 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      1 WARNING: CPU: 1 PID: 119 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      1 WARNING: CPU: 1 PID: 118 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      1 WARNING: CPU: 1 PID: 117 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      1 WARNING: CPU: 1 PID: 116 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      1 WARNING: CPU: 1 PID: 114 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      1 WARNING: CPU: 0 PID: 8 at /c/wfg/linux-drm/lib/debugobjects.c:260 debug_print_object+0x7c/0x8b()
      1 WARNING: CPU: 0 PID: 8 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      1 WARNING: CPU: 0 PID: 8 at /c/wfg/linux-drm/kernel/workqueue.c:458 work_fixup_activate+0x6a/0x6f()
      1 WARNING: CPU: 0 PID: 8 at /c/wfg/linux-drm/kernel/workqueue.c:1379 __queue_work+0x1a1/0x1ee()
      1 WARNING: CPU: 0 PID: 129 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      1 WARNING: CPU: 0 PID: 125 at /c/wfg/linux-drm/lib/debugobjects.c:260 debug_print_object+0x7c/0x8b()
      1 WARNING: CPU: 0 PID: 125 at /c/wfg/linux-drm/kernel/workqueue.c:458 work_fixup_activate+0x6a/0x6f()
      1 WARNING: CPU: 0 PID: 125 at /c/wfg/linux-drm/kernel/workqueue.c:1379 __queue_work+0x1a1/0x1ee()
      1 WARNING: CPU: 0 PID: 119 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      1 WARNING: CPU: 0 PID: 118 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      1 Oops: 0010 [#2] PREEMPT SMP DEBUG_PAGEALLOC
      1 Oops: 0002 [#2] PREEMPT SMP DEBUG_PAGEALLOC
      1 Oops: 0002 [#1] e PorR dEirEecMtoPryT
      1 Oops: 0002 [#1] dPonRe.E
      1 Oops: 0002 [#1] PREEMPT SMP puDlaEteB-vUolGat_ilPe.AGEALLOC
      1 Oops: 0002 [#1] PREEMPT SMP 
      1 Oops: 0002 [#1] PREEMPT /bSinM/sPh:  /procD/sEBUG_PAGEALLOC
      1 Oops: 0000 [#4] PREEMPT SMP DEBUG_PAGEALLOC
      1 Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
      1 INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 2.349 msecs
      1 BUG: unable to handle kernel paging request at ffff88000cd6c800
      1 BUG: unable to handle kernel paging request at 00002939a1ff0088
      1 BUG: unable to handle kernel paging request at 0000200000000000
      1 BUG: unable to handle kernel paging request at 000000010000003f
      1 BUG: unable to handle kernel paging request at 000000007fffffff
      1 BUG: unable to handle kernel paging request at 0000000003ffffc0
      1 BUG: unable to handle kernel ULL pointer dereference at 0000000000000008
      1 BUG: unable to handle kernel ULL pointer dereference
      1 BUG: unable to handle kernel PleaNse wULait: bLoo pointer dereference at 0000000000000008
      1 BUG: unable to handle kernel NULL pointerereference at 0000000000000008
      1 BUG: unable to handle kernel NULL pointer dereference at 0000000000000027
      1 BUG: unable to handle kernel NULL pointer dereference at 0000000000000014
      1 BUG: unable to handle kernel NULL pointer dereference at 0000000000000001
      1 BUG: unable to handle kernel NULL poinr deference at 0000000000000008
      1 BUG: unable to 9: No suchandle kernel NULL pointer dereference at 0000000000000008
      1 BUG: spinlock lockup suspected on CPU#1, migration/1/11
      1 BUG: spinlock lockup suspected on CPU#1, kworker/1:1/20
      1 BUG: spinlock lockup suspected on CPU#0, sh/126
      1 BUG: spinlock lockup suspected on CPU#0, sh/115
      1 BUG: scheduling while atomic: sh/130/0x10000002
      1 BUG: scheduling while atomic: reboot/222/0x10000002
      1 BUG: scheduling while atomic: rc/212/0x10000002
      1 BUG: scheduling while atomic: init/212/0x10000002
      1 BUG: scheduling while atomic: init/138/0x10000002
      1 BUG: Bad rss-counter state mm:ffff88000ca206c0 idx:1 val:2
      1 BUG: Bad rss-counter state mm:ffff88000c9d4080 idx:1 val:2
      1 BUG: Bad rss-counter state mm:ffff880006a106c0 idx:1 val:2
      1 BUG: Bad page map in process init  pte:ffffffff82863660 pmd:06d9e067
      1 BUG: Bad page map in process init  pte:ffffffff828632c0 pmd:06d9e067
      1 BUG: Bad page map in process init  pte:ffffffff828632b8 pmd:06d9e067
      1 BUG: Bad page map in process init  pte:ffffffff828632b0 pmd:06d9e067
      1 BUG: Bad page map in process init  pte:ffffffff828632a0 pmd:06d9e067
      1 BUG: Bad page map in process init  pte:ffffffff82863280 pmd:06d9e067
      1 BUG: Bad page map in process init  pte:ffffffff8275cf00 pmd:06d9e067
      1 BUG: Bad page map in process init  pte:ffffffff82314d30 pmd:06d9e067
      1 BUG: Bad page map in process init  pte:ffffffff82310d10 pmd:06d9e067
      1 BUG: Bad page map in process init  pte:ffffffff823102f0 pmd:06d9e067
      1 BUG: Bad page map in process init  pte:ffffffff8230e7f0 pmd:06d9e067
      1 BUG: Bad page map in process init  pte:ffffffff81b8ab2a pmd:06d9e067
      1 BUG: Bad page map in process init  pte:ffffffff81b8aaf9 pmd:06d9e067
      1 BUG: Bad page map in process init  pte:ffffffff81b8aabc pmd:06d9e067
      1 BUG: Bad page map in process init  pte:ffffffff81b8aaa9 pmd:06d9e067
      1 BUG: Bad page map in process init  pte:ffffffff8191eba0 pmd:06d9e067
      1 BUG: Bad page map in process init  pte:ffff8800076d53c0 pmd:06d9e067
      1 BUG: Bad page map in process init  pte:ffff880006d9e1c8 pmd:06d9e067
      1 BUG: Bad page map in process init  pte:ffff880006d9e140 pmd:06d9e067
      1 BUG: Bad page map in process init  pte:ffff880006d9e0b8 pmd:06d9e067
      1 BUG: Bad page map in process init  pte:ffff880006d90000 pmd:06d9e067
      1 BUG: Bad page map in process init  pte:ffff88000692ec40 pmd:06d9e067
      1 BUG: Bad page map in process init  pte:dead4ead003c003c pmd:06d9e067
      1 BUG: Bad page map in process init  pte:dead4ead002c002c pmd:06d9e067
      1 BUG: Bad page map in process init  pte:200005401 pmd:06d9e067

It's not really the "first" bad commit because its parent commit 3398d252a4d
("Merge tag 'modules-next-for-linus' of git://git.kernel.org/pub/scm/linux/kerne l/git/rusty/linux") 
has a similar 495 good dmesgs and 14587 bad dmesgs with error messages:

  13847 Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
  13792 BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
  13760 Kernel panic - not syncing: Fatal exception in interrupt
  10011 BUG: kernel boot oops
   4280 BUG: kernel test oops
    382 WARNING: CPU: 0 PID: 1 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
    316 kernel BUG at /c/wfg/linux-drm/mm/slab.c:3011!
    301 invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
    225 Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
    178 INFO: lockdep is turned off.
     84 BUG: sleeping function called from invalid context at /c/wfg/linux-drm/kernel/rwsem.c:20
     65 BUG: unable to handle kernel 
     52 WARNING: CPU: 0 PID: 0 at /c/wfg/linux-drm/lib/debugobjects.c:260 debug_print_object+0x7c/0x8b()
     52 WARNING: CPU: 0 PID: 0 at /c/wfg/linux-drm/kernel/workqueue.c:458 work_fixup_activate+0x6a/0x6f()
     52 WARNING: CPU: 0 PID: 0 at /c/wfg/linux-drm/kernel/workqueue.c:1379 __queue_work+0x1a1/0x1ee()
     42 WARNING: CPU: 0 PID: 0 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
     40 general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
     38 WARNING: CPU: 1 PID: 0 at /c/wfg/linux-drm/lib/debugobjects.c:260 debug_print_object+0x7c/0x8b()
     38 WARNING: CPU: 1 PID: 0 at /c/wfg/linux-drm/kernel/workqueue.c:458 work_fixup_activate+0x6a/0x6f()
     38 WARNING: CPU: 1 PID: 0 at /c/wfg/linux-drm/kernel/workqueue.c:1379 __queue_work+0x1a1/0x1ee()
     29 BUG: kernel boot crashed
     27 WARNING: CPU: 1 PID: 0 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
     22 BUG: scheduling while atomic: init/136/0x10000002
     21 BUG: scheduling while atomic: S99-rc.local/210/0x10000002
     17 invalid opcode: 0000 [#2] PREEMPT SMP DEBUG_PAGEALLOC
     15 Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
     14 Oops: 0010 [#1] PREEMPT SMP DEBUG_PAGEALLOC
     13 Oops: 0000 [#2] PREEMPT SMP DEBUG_PAGEALLOC
     13 BUG: unable to handle kernel NULL pointer dereference at           (null)
     13 BUG: unable to handle kernel NULL pointer dereference
     10 BUG: unable to handle kernel paging request at ffffffffffffffa8
      8 Oops: 0002 [#1] 
      8 BUG: scheduling while atomic: init/214/0x10000002
      8 BUG: scheduling while atomic: init/212/0x10000002
      7 BUG: scheduling while atomic: init/213/0x10000002
      6 WARNING: CPU: 1 PID: 1 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      6 BUG: unable to handle kernel paging request at 0000000000010012
      6 BUG: unable to handle kernel NULL pointer dereference at 0000000000000001
      6 BUG: scheduling while atomic: rc.local/134/0x10000002
      5 WARNING: CPU: 1 PID: 1 at /c/wfg/linux-drm/lib/debugobjects.c:260 debug_print_object+0x7c/0x8b()
      5 WARNING: CPU: 1 PID: 1 at /c/wfg/linux-drm/kernel/workqueue.c:458 work_fixup_activate+0x6a/0x6f()
      5 WARNING: CPU: 1 PID: 1 at /c/wfg/linux-drm/kernel/workqueue.c:1379 __queue_work+0x1a1/0x1ee()
      4 BUG: unable to handle kernel NULL pointer dereference at 00000000000008e0
      4 BUG: scheduling while atomic: ifconfig/230/0x10000002
      4 BUG: kernel boot hang
      3 WARNING: CPU: 1 PID: 117 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      3 WARNING: CPU: 1 PID: 116 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      3 WARNING: CPU: 0 PID: 1 at /c/wfg/linux-drm/lib/debugobjects.c:260 debug_print_object+0x7c/0x8b()
      3 WARNING: CPU: 0 PID: 1 at /c/wfg/linux-drm/kernel/workqueue.c:458 work_fixup_activate+0x6a/0x6f()
      3 WARNING: CPU: 0 PID: 1 at /c/wfg/linux-drm/kernel/workqueue.c:1379 __queue_work+0x1a1/0x1ee()
      3 INFO: trying to register non-static key.
      3 BUG: unable to handle kernel paging request at ffff88000cd9f000
      3 BUG: unable to handle kernel N
      3 BUG: scheduling while atomic: rc/212/0x10000002
      2 kernel BUG at /c/wfg/linux-drm/mm/slab.c:463!
      2 WARNING: CPU: 1 PID: 121 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      2 WARNING: CPU: 1 PID: 120 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      2 WARNING: CPU: 1 PID: 118 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      2 WARNING: CPU: 0 PID: 22 at /c/wfg/linux-drm/lib/debugobjects.c:260 debug_print_object+0x7c/0x8b()
      2 WARNING: CPU: 0 PID: 22 at /c/wfg/linux-drm/kernel/workqueue.c:458 work_fixup_activate+0x6a/0x6f()
      2 WARNING: CPU: 0 PID: 22 at /c/wfg/linux-drm/kernel/workqueue.c:1379 __queue_work+0x1a1/0x1ee()
      2 WARNING: CPU: 0 PID: 20 at /c/wfg/linux-drm/lib/debugobjects.c:260 debug_print_object+0x7c/0x8b()
      2 WARNING: CPU: 0 PID: 20 at /c/wfg/linux-drm/kernel/workqueue.c:458 work_fixup_activate+0x6a/0x6f()
      2 WARNING: CPU: 0 PID: 20 at /c/wfg/linux-drm/kernel/workqueue.c:1379 __queue_work+0x1a1/0x1ee()
      2 WARNING: CPU: 0 PID: 130 at /c/wfg/linux-drm/drivers/tty/tty_mutex.c:23 tty_lock_nested+0x34/0x83()
      2 WARNING: CPU: 0 PID: 124 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      2 WARNING: CPU: 0 PID: 123 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      2 Oops: 0002 [#2] PREEMPT SMP DEBUG_PAGEALLOC
      2 Oops: 0000 [#3] PREEMPT SMP DEBUG_PAGEALLOC
      2 BUG: unable to handle kernel ULL pointer dereference at 0000000000000008
      2 BUG: unable to handle kernel NULL pointer dereference at 0000000000000018
      2 BUG: scheduling while atomic: reboot/210/0x10000002
      2 BUG: scheduling while atomic: rc/136/0x10000002
      2 BUG: scheduling while atomic: S20sendsigs/141/0x10000002
      1 t[ri ni ty: n ot  f1o.668013] Kernel panic - not syncing: Fatal exception in interrupt
      1 sh: /[pr oc /s  4.771591] Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
      1 proc o[n /proc  fa   2.048043] Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
      1 n/modp[ro be :   2.087974] Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
      1 kernel BUG at /c/wfg/linux-drm/kernel/cred.c:758!
      1 invalid opcode: 0000 [#3] PREEMPT SMP DEBUG_PAGEALLOC
      1 gr[ep :  /p ro c/2fi.le087655] Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOCsy
      1 general protection fault: 0000 [#3] PREEMPT SMP DEBUG_PAGEALLOC
      1 et c/rc5 .d1.667815] Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC/S99-rc.loca
      1 bi[n/ sh : / pr oc4/s.179326] Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
      1 WARNING: CPU: 1 PID: 96 at /c/wfg/linux-drm/lib/debugobjects.c:260 debug_print_object+0x7c/0x8b()
      1 WARNING: CPU: 1 PID: 96 at /c/wfg/linux-drm/kernel/workqueue.c:458 work_fixup_activate+0x6a/0x6f()
      1 WARNING: CPU: 1 PID: 96 at /c/wfg/linux-drm/kernel/workqueue.c:1379 __queue_work+0x1a1/0x1ee()
      1 WARNING: CPU: 1 PID: 221 at /c/wfg/linux-drm/include/linux/kref.h:47 kobject_get+0x37/0x44()
      1 WARNING: CPU: 1 PID: 22 at /c/wfg/linux-drm/kernel/lockdep.c:960 __bfs+0xf1/0x1b3()
      1 WARNING: CPU: 1 PID: 138 at /c/wfg/linux-drm/drivers/tty/tty_mutex.c:23 tty_lock_nested+0x34/0x83()
      1 WARNING: CPU: 1 PID: 122 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      1 WARNING: CPU: 1 PID: 120 at /c/wfg/linux-drm/lib/debugobjects.c:260 debug_print_object+0x7c/0x8b()
      1 WARNING: CPU: 1 PID: 120 at /c/wfg/linux-drm/kernel/workqueue.c:458 work_fixup_activate+0x6a/0x6f()
      1 WARNING: CPU: 1 PID: 120 at /c/wfg/linux-drm/kernel/workqueue.c:1379 __queue_work+0x1a1/0x1ee()
      1 WARNING: CPU: 1 PID: 12 at /c/wfg/linux-drm/lib/debugobjects.c:260 debug_print_object+0x7c/0x8b()
      1 WARNING: CPU: 1 PID: 12 at /c/wfg/linux-drm/kernel/workqueue.c:458 work_fixup_activate+0x6a/0x6f()
      1 WARNING: CPU: 1 PID: 12 at /c/wfg/linux-drm/kernel/workqueue.c:1379 __queue_work+0x1a1/0x1ee()
      1 WARNING: CPU: 1 PID: 119 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      1 WARNING: CPU: 1 PID: 115 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      1 WARNING: CPU: 1 PID: 113 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      1 WARNING: CPU: 0 PID: 221 at /c/wfg/linux-drm/include/linux/kref.h:47 kobject_get+0x37/0x44()
      1 WARNING: CPU: 0 PID: 200 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      1 WARNING: CPU: 0 PID: 20 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      1 WARNING: CPU: 0 PID: 199 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      1 WARNING: CPU: 0 PID: 196 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      1 WARNING: CPU: 0 PID: 191 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      1 WARNING: CPU: 0 PID: 187 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      1 WARNING: CPU: 0 PID: 168 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      1 WARNING: CPU: 0 PID: 162 at /c/wfg/linux-drm/lib/debugobjects.c:260 debug_print_object+0x7c/0x8b()
      1 WARNING: CPU: 0 PID: 162 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      1 WARNING: CPU: 0 PID: 162 at /c/wfg/linux-drm/kernel/workqueue.c:458 work_fixup_activate+0x6a/0x6f()
      1 WARNING: CPU: 0 PID: 162 at /c/wfg/linux-drm/kernel/workqueue.c:1379 __queue_work+0x1a1/0x1ee()
      1 WARNING: CPU: 0 PID: 147 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      1 WARNING: CPU: 0 PID: 144 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      1 WARNING: CPU: 0 PID: 132 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      1 WARNING: CPU: 0 PID: 130 at /c/wfg/linux-drm/include/linux/kref.h:47 kref_get+0x2d/0x36()
      1 WARNING: CPU: 0 PID: 130 at /c/wfg/linux-drm/drivers/tty/tty_io.c:1411 tty_open+0x215/0x42b()
      1 WARNING: CPU: 0 PID: 128 at /c/wfg/linux-drm/lib/debugobjects.c:260 debug_print_object+0x7c/0x8b()
      1 WARNING: CPU: 0 PID: 128 at /c/wfg/linux-drm/kernel/workqueue.c:458 work_fixup_activate+0x6a/0x6f()
      1 WARNING: CPU: 0 PID: 128 at /c/wfg/linux-drm/kernel/workqueue.c:1379 __queue_work+0x1a1/0x1ee()
      1 WARNING: CPU: 0 PID: 126 at /c/wfg/linux-drm/kernel/workqueue.c:591 set_work_data+0x33/0x50()
      1 Oops: 0010 [#2] PREEMPT SMP DEBUG_PAGEALLOC
      1 Oops: 0002 [#1] iled: NPRo suchE deEMPT SMP DEBUG_PAGEALLOC
      1 Oops: 0002 [#1] grPRep: /Eproc/fileEMPT SMP DEBUG_PAGEALLOC
      1 Oops: 0002 [#1] bPooRtlEogEd.M
      1 Oops: 0002 [#1] PRe EorE dMirPecTto ry
      1 Oops: 0002 [#1] PREmount:E moMPTunt ing SMP DEBUG_PAGEALLOC
      1 Oops: 0002 [#1] PREEMPT nSe M15P:  /triniDtyE:BUG_PAGEALLOC
      1 Oops: 0002 [#1] PREEMPT SmoMunPt:  mountDinEg BUG_PAGEALLOC
      1 Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOCs/
      1 Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOCm
      1 Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOCgrep: /proc/file
      1 Oops: 0002 [#1] PREEMPT SMP 
      1 Oops: 0002 [#1] PREEMPT 
      1 Oops: 0002 [#1] CPonRfiEguEriMngP nTet wSMP DEBUG_PAGEALLOC
      1 Oops: 0002 [#1] /PbiRn/EshE: M/pProTc/ sSMP eDlfE/fBd/U9:G N_o PsuAcGEALLOC
      1 Oops: 0000 [#4] PREEMPT SMP DEBUG_PAGEALLOC
      1 Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
      1 BUG: unable to handle kernel paging request at ffffffffe7e9eb38
      1 BUG: unable to handle kernel paging request at ffff880006db9808
      1 BUG: unable to handle kernel paging request at ffff880006db9800
      1 BUG: unable to handle kernel paging request at ffff880006db3008
      1 BUG: unable to handle kernel paging request at ffff880006db3000
      1 BUG: unable to handle kernel paging request at 00002939a1ff0088
      1 BUG: unable to handle kernel paging request at 0000200000000080
      1 BUG: unable to handle kernel paging request at 00000000c1dcacfe
      1 BUG: unable to handle kernel paging request at 000000007fffffff
      1 BUG: unable to handle kernel paging request at 0000000003ffffc0
      1 BUG: unable to handle kernel gNULL pointer dereference at 0000000000000008
      1 BUG: unable to handle kernel NULproc on /proc Lfa pointer dereference at 0000000000000008
      1 BUG: unable to handle kernel NULgrep: /proc/cmdline: No such file or directory
      1 BUG: unable to handle kernel NULRuLnni ngp poositinnstter  /detec/rrpem-fpoestrinensctse/100.. .at 00
      1 BUG: unable to handle kernel NULL pointer ereference
      1 BUG: unable to handle kernel NULL pointer derefrence at 0000000000000008
      1 BUG: unable to handle kernel NULL pointer dereferenceStarting Bootlog at 0000000000000008
      1 BUG: unable to handle kernel NULL pointer dereference atmo 00unt: 0moun00ti0ng0 00pro0c on /proc fa00ile000d: No such de8
      1 BUG: unable to handle kernel NULL pointer dereference at moun0000t: 0moun0ting0 000000p0roc 0on /8proc
      1 BUG: unable to handle kernel NULL pointer dereference at gr0e0p:0 0/p0ro00000c0/cm0dl0008in
      1 BUG: unable to handle kernel NULL pointer dereference at 0000000000000017
      1 BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
      1 BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
      1 BUG: unable to handle kernel NULL pointer dereference a/bt in0000/sh: 00/p0ro0c/0000s000elf/fd/9:8
      1 BUG: unable to handle kernel NULL pointer dereferce at 0000000000000008
      1 BUG: unable to handle kernel NULL pointer derefence at 0000000000000008
      1 BUG: unable to handle kernel NULL pointe dereference at 0000000000000008
      1 BUG: unable to handle kernel NULL poiner dereference at 0000000000000008
      1 BUG: unable to handle kernel NULL p
      1 BUG: unable to handle kernel NUL/etc/rcS.d/S00fbLsetup : pointer lidne 3:e reference at 0000000000000008
      1 BUG: unable to handle kernel NUL/biLn/s ph: /poiroc/nsterel f/fd/9: dNo sucereh file feror edirectnorcy
      1 BUG: unable to handle kernel NU/bin/LLsh: / procp/soelf/fdi/9: No sucnteh frile or dire ctdoryeref
      1 BUG: unable to handle kernel NU
      1 BUG: unable to handle kernel /kNerUneLl-Lte stpointer dereference at 0000000000000008
      1 BUG: unable to handle kernel -> 0:9
      1 BUG: spinlock lockup suspected on CPU#0, swapper/0/0
      1 BUG: scheduling while atomic: stty/188/0x10000002
      1 BUG: scheduling while atomic: sleep/130/0x00000002
      1 BUG: scheduling while atomic: sleep/129/0x10000002
      1 BUG: scheduling while atomic: sleep/129/0x00000002
      1 BUG: scheduling while atomic: reboot/221/0x10000002
      1 BUG: scheduling while atomic: reboot/134/0x10000002
      1 BUG: scheduling while atomic: rc/214/0x10000002
      1 BUG: scheduling while atomic: rc/213/0x10000002
      1 BUG: scheduling while atomic: rc.local/135/0x10000002
      1 BUG: Bad rss-counter state mm:ffff88000cab4d00 idx:1 val:2
      1 BUG: Bad rss-counter state mm:ffff88000caaf340 idx:1 val:2
      1 BUG: Bad rss-counter state mm:ffff88000ca33340 idx:1 val:2
      1 BUG: Bad rss-counter state mm:ffff88000ca1d980 idx:1 val:2
      1 BUG: Bad rss-counter state mm:ffff88000ca1b980 idx:1 val:2
      1 BUG: Bad rss-counter state mm:ffff88000c9e1980 idx:1 val:2
      1 BUG: Bad rss-counter state mm:ffff88000c9de080 idx:1 val:2
      1 BUG: Bad rss-counter state mm:ffff88000c9d06c0 idx:1 val:2
      1 BUG: Bad rss-counter state mm:ffff88000c9be6c0 idx:1 val:2

Sorry I should have did more analyzes before reporting it out. The Xen tree is
clean: 10000 good boots w/o a single bad dmesg. Which is also indicated by the
below bisect log:

git bisect  bad cf39c8e5352b  # 18:34    727-  Merge tag 'stable/for-linus-3.12-rc0-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip
...
git bisect good 23b7eaf82207  # 03:19   5000+  hvc_xen: Remove unnecessary __GFP_ZERO from kzalloc
git bisect good 3398d252a4da  # 13:35  10000+  Merge tag 'modules-next-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux
git bisect good 23b7eaf82207  # 14:55  10000+  hvc_xen: Remove unnecessary __GFP_ZERO from kzalloc
git bisect  bad 14951f22f1cc  # 14:55      0-  Revert "perf symbols: Demangle cloned functions"
git bisect  bad e62063d69911  # 15:28   1444-  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs
git bisect  bad a0cf1abc25ac  # 15:28      0-  Add linux-next specific files for 20130927
git bisect  bad b31801966611  # 15:56    728-  Merge branch 'tools/kvm'

Where the 5000+/10000+ etc. are the number of boots before claiming the kernel GOOD;
the 727-/0-/728- are the number of boots (minus 1) before finding the bug message in dmesg.

In this bisect, the bug message is "double fault:" and the bisect works in this way:

loop {
        if grep "double fault:" dmesg; then
                report FAILURE
        else if booted N times 
                report GOOD and break
}

I'll check and improve the bisect script to verify the bisect result
for working with this situation.

Thanks,
Fengguang
