Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbaAMQC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:02:59 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53148 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbaAMQCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:02:35 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dave Jiang <dave.jiang@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 073/208] net_dma: mark broken
Date: Mon, 13 Jan 2014 15:58:34 +0000
Message-Id: <1389628849-1614-74-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit 77873803363c9e831fc1d1e6895c084279090c22 upstream.

net_dma can cause data to be copied to a stale mapping if a
copy-on-write fault occurs during dma.  The application sees missing
data.

The following trace is triggered by modifying the kernel to WARN if it
ever triggers copy-on-write on a page that is undergoing dma:

 WARNING: CPU: 24 PID: 2529 at lib/dma-debug.c:485 debug_dma_assert_idle+0xd2/0x120()
 ioatdma 0000:00:04.0: DMA-API: cpu touching an active dma mapped page [pfn=0x16bcd9]
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

Option 1 adds yet more cpu overhead to an "offload" that struggles to compete
with cpu-copy.  Option 2 adds checks for behavior that is already documented as
broken when using get_user_pages().  At a minimum a debug mode is warranted to
catch and flag these violations of the dma-api vs get_user_pages().

Thanks to David for his reproducer.

Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Alexander Duyck <alexander.h.duyck@intel.com>
Reported-by: David Whipple <whipple@securedatainnovations.ch>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/dma/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 643d7c7..d71c409 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -321,6 +321,7 @@ config NET_DMA
 	bool "Network: TCP receive copy offload"
 	depends on DMA_ENGINE && NET
 	default (INTEL_IOATDMA || FSL_DMA)
+	depends on BROKEN
 	help
 	  This enables the use of DMA engines in the network stack to
 	  offload receive copy-to-user operations, freeing CPU cycles.
-- 
1.8.3.2

