Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab3LRVmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:42:23 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:34714 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284Ab3LRVmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:42:19 -0500
MIME-Version: 1.0
Date: Wed, 18 Dec 2013 13:42:17 -0800
Message-ID: <CAPcyv4h7DG-hrXv-+KgQi9PGR9VBYwmdhdxNnN0977CWDE3rmQ@mail.gmail.com>
Subject: [GIT PULL] dmaengine-fixes-3.13-rc4
From: Dan Williams <dan.j.williams@intel.com>
To: torvalds@linux-foundation.org
Cc: Vinod Koul <vinod.koul@intel.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        Dave Jiang <dave.jiang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here is a dmaengine update to address regressions introduced in -rc1.
All but the most recent "net_dma: mark broken" have appeared in -next,
and this branch is also subscribed for positive build results from the
kbuild robot.

Going forward I have fleshed out my local build regression scripts and
sent the missing configs to Fengguang's robot.

Please pull.

--
Dan


The following changes since commit 85726def1e351bdd057cdc4bb349dcbdf6bdd251:

  dma: fix build breakage in s3c24xx-dma (2013-12-04 11:24:30 +0530)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/dmaengine
tags/dmaengine-fixes-3.13-rc4

for you to fetch changes up to 77873803363c9e831fc1d1e6895c084279090c22:

  net_dma: mark broken (2013-12-18 12:53:43 -0800)

----------------------------------------------------------------
dmaengine fixes for 3.13-rc4

1/ Deprecation of net_dma to be removed in 3.14

2/ Crash regression fix in pl330 from the dmaengine_unmap rework

3/ Crash regression fix for any channel running raid ops without
   CONFIG_ASYNC_TX_DMA from dmaengine_unmap

4/ Memory leak regression in mv_xor from dmaengine_unmap

5/ Build warning regressions in mv_xor, fsldma, ppc4xx, txx9, and
   at_hdmac from dmaengine_unmap

6/ Sleep in atomic regression in dma_async_memcpy_pg_to_pg

7/ New fix in mv_xor for handling channel initialization failures

----------------------------------------------------------------
Dan Williams (7):
      dma: fix build warnings in ppc4xx
      dma: fix fsldma build warnings
      dmatest: fix build warning on mips
      dma: fix build warnings in txx9
      dmaengine: fix enable for high order unmap pools
      dmaengine: fix sleep in atomic
      net_dma: mark broken

Ezequiel Garcia (1):
      dma: mv_xor: Use dmaengine_unmap_data for the self-tests

Jason Cooper (1):
      dma: mv_xor: remove mv_desc_get_dest_addr()

Olof Johansson (1):
      dmaengine: at_hdmac: remove unused function

Russell King (1):
      dmaengine: mv_xor: fix oops when channels fail to initialise

Will Deacon (1):
      dma: pl330: ensure DMA descriptors are zero-initialised

 drivers/dma/Kconfig         |   7 +++
 drivers/dma/at_hdmac_regs.h |   4 --
 drivers/dma/dmaengine.c     |   4 +-
 drivers/dma/dmatest.c       |   8 ++--
 drivers/dma/fsldma.c        |  31 +-------------
 drivers/dma/mv_xor.c        | 101 +++++++++++++++++++++++++++-----------------
 drivers/dma/pl330.c         |   5 +--
 drivers/dma/ppc4xx/adma.c   |  27 +-----------
 drivers/dma/txx9dmac.c      |   1 -
 9 files changed, 79 insertions(+), 109 deletions(-)

Full log:

commit 77873803363c9e831fc1d1e6895c084279090c22
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Dec 17 10:09:32 2013 -0800

    net_dma: mark broken

    net_dma can cause data to be copied to a stale mapping if a
    copy-on-write fault occurs during dma.  The application sees missing
    data.

    The following trace is triggered by modifying the kernel to WARN if it
    ever triggers copy-on-write on a page that is undergoing dma:

     WARNING: CPU: 24 PID: 2529 at lib/dma-debug.c:485
debug_dma_assert_idle+0xd2/0x120()
     ioatdma 0000:00:04.0: DMA-API: cpu touching an active dma mapped
page [pfn=0x16bcd9]
     Modules linked in: iTCO_wdt iTCO_vendor_support ioatdma lpc_ich pcspkr dca
     CPU: 24 PID: 2529 Comm: linbug Tainted: G        W    3.13.0-rc1+ #353
      00000000000001e5 ffff88016f45f688 ffffffff81751041 ffff88017ab0ef70
      ffff88016f45f6d8 ffff88016f45f6c8 ffffffff8104ed9c ffffffff810f3646
      ffff8801768f4840 0000000000000282 ffff88016f6cca10 00007fa2bb699349
     Call Trace:
      [<ffffffff81751041>] dump_stack+0x46/0x58
      [<ffffffff8104ed9c>] warn_slowpath_common+0x8c/0xc0
      [<ffffffff810f3646>] ? ftrace_pid_func+0x26/0x30
      [<ffffffff8104ee86>] warn_slowpath_fmt+0x46/0x50
      [<ffffffff8139c062>] debug_dma_assert_idle+0xd2/0x120
      [<ffffffff81154a40>] do_wp_page+0xd0/0x790
      [<ffffffff811582ac>] handle_mm_fault+0x51c/0xde0
      [<ffffffff813830b9>] ? copy_user_enhanced_fast_string+0x9/0x20
      [<ffffffff8175fc2c>] __do_page_fault+0x19c/0x530
      [<ffffffff8175c196>] ? _raw_spin_lock_bh+0x16/0x40
      [<ffffffff810f3539>] ? trace_clock_local+0x9/0x10
      [<ffffffff810fa1f4>] ? rb_reserve_next_event+0x64/0x310
      [<ffffffffa0014c00>] ? ioat2_dma_prep_memcpy_lock+0x60/0x130 [ioatdma]
      [<ffffffff8175ffce>] do_page_fault+0xe/0x10
      [<ffffffff8175c862>] page_fault+0x22/0x30
      [<ffffffff81643991>] ? __kfree_skb+0x51/0xd0
      [<ffffffff813830b9>] ? copy_user_enhanced_fast_string+0x9/0x20
      [<ffffffff81388ea2>] ? memcpy_toiovec+0x52/0xa0
      [<ffffffff8164770f>] skb_copy_datagram_iovec+0x5f/0x2a0
      [<ffffffff8169d0f4>] tcp_rcv_established+0x674/0x7f0
      [<ffffffff816a68c5>] tcp_v4_do_rcv+0x2e5/0x4a0
      [..]
     ---[ end trace e30e3b01191b7617 ]---
     Mapped at:
      [<ffffffff8139c169>] debug_dma_map_page+0xb9/0x160
      [<ffffffff8142bf47>] dma_async_memcpy_pg_to_pg+0x127/0x210
      [<ffffffff8142cce9>] dma_memcpy_pg_to_iovec+0x119/0x1f0
      [<ffffffff81669d3c>] dma_skb_copy_datagram_iovec+0x11c/0x2b0
      [<ffffffff8169d1ca>] tcp_rcv_established+0x74a/0x7f0:

    ...the problem is that the receive path falls back to cpu-copy in
    several locations and this trace is just one of the areas.  A few
    options were considered to fix this:

    1/ sync all dma whenever a cpu copy branch is taken

    2/ modify the page fault handler to hold off while dma is in-flight

    Option 1 adds yet more cpu overhead to an "offload" that struggles
to compete
    with cpu-copy.  Option 2 adds checks for behavior that is already
documented as
    broken when using get_user_pages().  At a minimum a debug mode is
warranted to
    catch and flag these violations of the dma-api vs get_user_pages().

    Thanks to David for his reproducer.

    Cc: <stable@vger.kernel.org>
    Cc: Dave Jiang <dave.jiang@intel.com>
    Cc: Vinod Koul <vinod.koul@intel.com>
    Cc: Alexander Duyck <alexander.h.duyck@intel.com>
    Reported-by: David Whipple <whipple@securedatainnovations.ch>
    Acked-by: David S. Miller <davem@davemloft.net>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 0baf8f6a2ac86c2c40ed0cacab8ea3d17371a1bb
Author: Will Deacon <will.deacon@arm.com>
Date:   Mon Dec 2 18:01:30 2013 +0000

    dma: pl330: ensure DMA descriptors are zero-initialised

    I see the following splat with 3.13-rc1 when attempting to perform DMA:

    [  253.004516] Alignment trap: not handling instruction e1902f9f
at [<c0204b40>]
    [  253.004583] Unhandled fault: alignment exception (0x221) at 0xdfdfdfd7
    [  253.004646] Internal error: : 221 [#1] PREEMPT SMP ARM
    [  253.004691] Modules linked in: dmatest(+) [last unloaded: dmatest]
    [  253.004798] CPU: 0 PID: 671 Comm: kthreadd Not tainted 3.13.0-rc1+ #2
    [  253.004864] task: df9b0900 ti: df03e000 task.ti: df03e000
    [  253.004937] PC is at dmaengine_unmap_put+0x14/0x34
    [  253.005010] LR is at pl330_tasklet+0x3c8/0x550
    [  253.005087] pc : [<c0204b44>]    lr : [<c0207478>]    psr: a00e0193
    [  253.005087] sp : df03fe48  ip : 00000000  fp : df03bf18
    [  253.005178] r10: bf00e108  r9 : 00000001  r8 : 00000000
    [  253.005245] r7 : df837040  r6 : dfb41800  r5 : df837048  r4 : df837000
    [  253.005316] r3 : dfdfdfcf  r2 : dfb41f80  r1 : df837048  r0 : dfdfdfd7
    [  253.005384] Flags: NzCv  IRQs off  FIQs on  Mode SVC_32  ISA
ARM  Segment kernel
    [  253.005459] Control: 30c5387d  Table: 9fb9ba80  DAC: fffffffd
    [  253.005520] Process kthreadd (pid: 671, stack limit = 0xdf03e248)

    This is due to desc->txd.unmap containing garbage (uninitialised memory).

    Rather than add another dummy initialisation to _init_desc, instead
    ensure that the descriptors are zero-initialised during allocation and
    remove the dummy, per-field initialisation.

    Cc: Andriy Shevchenko <andriy.shevchenko@intel.com>
    Acked-by: Jassi Brar <jassisinghbrar@gmail.com>
    Signed-off-by: Will Deacon <will.deacon@arm.com>
    Acked-by: Vinod Koul <vinod.koul@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 8194ee27764b1a86fa7a6b0d411f0a225a6abd5f
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Fri Dec 13 00:57:03 2013 -0800

    dmaengine: fix sleep in atomic

     BUG: sleeping function called from invalid context at mm/mempool.c:203
     in_atomic(): 1, irqs_disabled(): 0, pid: 43502, name: linbug
     no locks held by linbug/43502.
     CPU: 7 PID: 43502 Comm: linbug Not tainted 3.13.0-rc1+ #15
     Hardware name:
      0000000000000010 ffff88005ebd1878 ffffffff8172d512 ffff8801752bc1c0
      ffff8801752bc1c0 ffff88005ebd1898 ffffffff8109d1f6 ffff88005f9a3c58
      ffff880177f0f080 ffff88005ebd1918 ffffffff81161f43 ffff88005ebd18f8
     Call Trace:
      [<ffffffff8172d512>] dump_stack+0x4e/0x68
      [<ffffffff8109d1f6>] __might_sleep+0xe6/0x120
      [<ffffffff81161f43>] mempool_alloc+0x93/0x170
      [<ffffffff810c0c34>] ? mark_held_locks+0x74/0x140
      [<ffffffff8118a826>] ? follow_page_mask+0x556/0x600
      [<ffffffff814107ae>] dmaengine_get_unmap_data+0x2e/0x60
      [<ffffffff81410f11>] dma_async_memcpy_pg_to_pg+0x41/0x1c0
      [<ffffffff814110e0>] dma_async_memcpy_buf_to_pg+0x50/0x60
      [<ffffffff81411bdc>] dma_memcpy_to_iovec+0xfc/0x190
      [<ffffffff816163af>] dma_skb_copy_datagram_iovec+0x6f/0x2b0

    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 0be8253fa2b4385e6246387db1d6067366e987ba
Author: Russell King <rmk+kernel@arm.linux.org.uk>
Date:   Thu Dec 12 23:59:08 2013 +0000

    dmaengine: mv_xor: fix oops when channels fail to initialise

    When a channel fails to initialise, we error out and clean up any
    previously unregistered channels by walking the entire xordev->channels
    array.  Unfortunately, there are paths which end up storing an error
    pointer in this array, which we then try and dereference in the cleanup
    code, which causes an oops.

    Fix this by avoiding writing invalid pointers to this array in the first
    place.

    Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
    Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit d16695a75019ac4baad7a117dc86d1d292e09115
Author: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Date:   Tue Dec 10 09:32:36 2013 -0300

    dma: mv_xor: Use dmaengine_unmap_data for the self-tests

    The driver-specific unmap code was removed in:

      commit 54f8d501e842879143e867e70996574a54d1e130
      Author: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
      Date:   Fri Oct 18 19:35:32 2013 +0200

          dmaengine: remove DMA unmap from drivers

    which had the side-effect of not unmapping the self-test mappings.
    Fix this by using dmaengine_unmap_data in the self-test routines.

    In addition, since dmaengine_unmap() assumes that all mappings were created
    with dma_map_page, this commit changes the single mapping to a page mapping
    to avoid an incorrect unmapping of the memcpy self-test.

    The allocation could be changed to be alloc_page(), but sticking to kmalloc
    results in a less intrusive patch. The size of the test buffer is increased,
    since dma_map_page() seem to fail when the source and destination pages are
    the same page.

    Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 3cc377b9ae4bd3133bf8ba388d2b2b66b2b973c1
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Dec 9 10:33:16 2013 -0800

    dmaengine: fix enable for high order unmap pools

    The higher order mempools support raid operations, and we want to
    disable them when raid support is not enabled.  Making them conditional
    on ASYNC_TX_DMA is not sufficient as other users (specifically dmatest)
    will also issue raid operations.  Make raid drivers explicitly request
    that the core carry the higher order pools.

    Reported-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
    Tested-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 8e5ee258d98a6643227d958361aec2a62559b804
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Dec 9 11:16:03 2013 -0800

    dma: fix build warnings in txx9

    The unmap rework missed this:
    drivers/dma/txx9dmac.c:409:25: warning: unused variable 'ds'
[-Wunused-variable]

    Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 745c00daf9a75bacb53d0fe8635a132673ab0b46
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Dec 9 11:16:01 2013 -0800

    dmatest: fix build warning on mips

    drivers/dma/dmatest.c:543:11: warning: passing argument 1 of
'virt_to_phys' makes pointer from integer without a cast [enabled by
default]

    mips expects virt_to_phys() to take a pointer.  Fix up the types
accordingly.

    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit bbc76560d488c437dbddff72242b0a07e42a0fd0
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Dec 9 11:16:00 2013 -0800

    dma: fix fsldma build warnings


    drivers/dma/fsldma.c: In function 'fsldma_cleanup_descriptor':
    drivers/dma/fsldma.c:860:6: warning: unused variable 'len'
[-Wunused-variable]
    drivers/dma/fsldma.c:859:13: warning: unused variable 'dst'
[-Wunused-variable]
    drivers/dma/fsldma.c:858:13: warning: unused variable 'src'
[-Wunused-variable]
    drivers/dma/fsldma.c:857:17: warning: unused variable 'dev'
[-Wunused-variable]
    - due to unmap changes

    drivers/dma/fsldma.c: In function 'fsl_dma_tx_submit':
    drivers/dma/fsldma.c:428:2: warning: 'cookie' may be used
uninitialized in this function [-Wuninitialized]
    - long standing warning

    Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
    Cc: Li Yang <leoli@freescale.com>
    Cc: Zhang Wei <zw@zh-kernel.org>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 6aa2731ce2c7bd1305b553b5fc14ae4856d36569
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Mon Dec 9 11:15:59 2013 -0800

    dma: fix build warnings in ppc4xx

    drivers/dma/ppc4xx/adma.c:1507:6: warning: unused variable 'i'
[-Wunused-variable]
    - due to unmap reworks

    drivers/dma/ppc4xx/adma.c:3900:2: warning: format '%s' expects a
matching 'char *' argument [-Wformat]
    - due to memset removal

    drivers/dma/ppc4xx/adma.c:538:13: warning:
'ppc440spe_desc_init_memset' defined but not used [-Wunused-function]
    - due to memset removal

    Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit d7fb0300fe663a5e338e3adeb7f811a2f9727e6c
Author: Olof Johansson <olof@lixom.net>
Date:   Mon Dec 9 11:15:57 2013 -0800

    dmaengine: at_hdmac: remove unused function

    commit 54f8d501e8428 ('dmaengine: remove DMA unmap from drivers')
    refactored some code which resulted in an unused function in the at_hdmac
    driver:

    drivers/dma/at_hdmac_regs.h:350:23: warning: 'chan2parent' defined but
        not used [-Wunused-function]

    Fixes: 54f8d501e8428 ('dmaengine: remove DMA unmap from drivers')
    Signed-off-by: Olof Johansson <olof@lixom.net>
    Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
    Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
    Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
    Acked-by: Vinod Koul <vinod.koul@Intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit f984841bc0c4d596c4e95d1798f318291c4f78f5
Author: Jason Cooper <jason@lakedaemon.net>
Date:   Mon Dec 9 11:15:56 2013 -0800

    dma: mv_xor: remove mv_desc_get_dest_addr()

    The following commit:

      54f8d501e842 dmaengine: remove DMA unmap from drivers

    removed the last caller to mv_desc_get_dest_addr(), creating the
    warning:

      drivers/dma/mv_xor.c:57:12: warning: mv_desc_get_dest_addr defined
      but not used [-Wunused-function]

    Remove it.

    Signed-off-by: Jason Cooper <jason@lakedaemon.net>
    Acked-by: Vinod Koul <vinod.koul@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>
