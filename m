Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbaDNRNA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 13:13:00 -0400
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:56375 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753061AbaDNRMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 13:12:55 -0400
Date: Mon, 14 Apr 2014 12:12:52 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Grygorii Strashko <grygorii.strashko@ti.com>
cc: linux-arm <linux-arm-kernel@lists.infradead.org>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Ingo Molnar <mingo@kernel.org>, linux-usb@vger.kernel.org
Subject: Re: [3.15-rc1] a huge number of warnings produced by xhci &
In-Reply-To: <534C182C.8040206@ti.com>
Message-ID: <alpine.DEB.2.10.1404141206040.18190@nuc>
References: <53285FE7.5010203@ti.com> <534C182C.8040206@ti.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

n Mon, 14 Apr 2014, Grygorii Strashko wrote:

> Hi All,
>
> I'm observing a huge number of warnings produced during the boot of my Keystone 2 board
> when USB is enabled.
>
> [    2.496460] BUG: using __this_cpu_read() in preemptible [00000000] code: khubd/202
> [    2.504030] caller is __mod_zone_page_state+0x20/0xc8
> [    2.509094] CPU: 1 PID: 202 Comm: khubd Not tainted 3.15.0-rc1-00015-ge521fa3-dirty #55
> [    2.517122] [<c0013788>] (unwind_backtrace) from [<c001129c>] (show_stack+0x10/0x14)
> [    2.524854] [<c001129c>] (show_stack) from [<c049f800>] (dump_stack+0x68/0xb8)
> [    2.532086] [<c049f800>] (dump_stack) from [<c02731c0>] (check_preemption_disabled+0xe8/0x10c)
> [    2.540708] [<c02731c0>] (check_preemption_disabled) from [<c00bc944>] (__mod_zone_page_state+0x20/0xc8)
> [    2.550187] [<c00bc944>] (__mod_zone_page_state) from [<c00b50c8>] (reclaim_clean_pages_from_list+0x16c/0x178)
> [    2.560193] [<c00b50c8>] (reclaim_clean_pages_from_list) from [<c00ac8f0>] (alloc_contig_range+0x10c/0x2d0)
> [    2.569932] [<c00ac8f0>] (alloc_contig_range) from [<c02b0e58>] (dma_alloc_from_contiguous+0x70/0x118)
> [    2.579241] [<c02b0e58>] (dma_alloc_from_contiguous) from [<c0017d24>] (__alloc_from_contiguous+0x34/0x160)
> [    2.588974] [<c0017d24>] (__alloc_from_contiguous) from [<c0018760>] (__dma_alloc+0x18c/0x294)
> [    2.597582] [<c0018760>] (__dma_alloc) from [<c00189f0>] (arm_dma_alloc+0xac/0xd8)
> [    2.605140] [<c00189f0>] (arm_dma_alloc) from [<c00d84a8>] (dma_pool_alloc+0xc8/0x1b8)
> [    2.613067] [<c00d84a8>] (dma_pool_alloc) from [<c0317120>] (xhci_alloc_container_ctx+0x70/0xe0)
> [    2.621851] [<c0317120>] (xhci_alloc_container_ctx) from [<c03194e8>] (xhci_alloc_virt_device+0x98/0x220)
> [    2.631418] [<c03194e8>] (xhci_alloc_virt_device) from [<c0315d28>] (xhci_alloc_dev+0x158/0x1f0)
> [    2.640207] [<c0315d28>] (xhci_alloc_dev) from [<c02f6310>] (usb_alloc_dev+0x1d4/0x27c)
> [    2.648217] [<c02f6310>] (usb_alloc_dev) from [<c02fb204>] (hub_thread+0x670/0x1204)
> [    2.655943] [<c02fb204>] (hub_thread) from [<c003d8d8>] (kthread+0xcc/0xe8)
> [    2.662906] [<c003d8d8>] (kthread) from [<c000e2f8>] (ret_from_fork+0x14/0x3c)
>
> Anyone else sees the same thing?

Either disable interrupts or use mod_zone_page_state instead.

This should fix it:




Subject: vmscan: reclaim_clean_pages_from_list must use mod_zone_page_state

Seems to be called with preemption enabled. Therefore it must use
mod_zone_page_state instead.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/mm/vmscan.c
===================================================================
--- linux.orig/mm/vmscan.c	2014-04-09 11:35:43.917930976 -0500
+++ linux/mm/vmscan.c	2014-04-14 12:09:48.070745938 -0500
@@ -1158,7 +1158,7 @@ unsigned long reclaim_clean_pages_from_l
 			TTU_UNMAP|TTU_IGNORE_ACCESS,
 			&dummy1, &dummy2, &dummy3, &dummy4, &dummy5, true);
 	list_splice(&clean_pages, page_list);
-	__mod_zone_page_state(zone, NR_ISOLATED_FILE, -ret);
+	mod_zone_page_state(zone, NR_ISOLATED_FILE, -ret);
 	return ret;
 }

