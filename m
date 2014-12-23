Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085AbaLWNt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 08:49:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:14675 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681AbaLWNtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 08:49:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,632,1413270000"; 
   d="scan'208";a="628224475"
Date: Tue, 23 Dec 2014 15:49:17 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Martin Oldfield <m@mjoldfield.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi/pxa2xx: Clear cur_chip pointer before starting next
 message
Message-ID: <20141223134917.GI1314@lahna.fi.intel.com>
References: <1417425166-150374-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417425166-150374-1-git-send-email-mika.westerberg@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 11:12:46AM +0200, Mika Westerberg wrote:
> Once the current message is finished, the driver notifies SPI core about
> this by calling spi_finalize_current_message(). This function queues next
> message to be transferred. If there are more messages in the queue, it is
> possible that the driver is asked to transfer the next message at this
> point.
> 
> When spi_finalize_current_message() returns the driver clears the
> drv_data->cur_chip pointer to NULL. The problem is that if the driver
> already started the next message clearing drv_data->cur_chip will cause
> NULL pointer dereference which crashes the kernel like:
> 
>  BUG: unable to handle kernel NULL pointer dereference at 0000000000000048
>  IP: [<ffffffffa0022bc8>] cs_deassert+0x18/0x70 [spi_pxa2xx_platform]
>  PGD 78bb8067 PUD 37712067 PMD 0
>  Oops: 0000 [#1] SMP
>  Modules linked in:
>  CPU: 1 PID: 11 Comm: ksoftirqd/1 Tainted: G           O   3.18.0-rc4-mjo #5
>  Hardware name: Intel Corp. VALLEYVIEW B3 PLATFORM/NOTEBOOK, BIOS MNW2CRB1.X64.0071.R30.1408131301 08/13/2014
>  task: ffff880077f9f290 ti: ffff88007a820000 task.ti: ffff88007a820000
>  RIP: 0010:[<ffffffffa0022bc8>]  [<ffffffffa0022bc8>] cs_deassert+0x18/0x70 [spi_pxa2xx_platform]
>  RSP: 0018:ffff88007a823d08  EFLAGS: 00010202
>  RAX: 0000000000000008 RBX: ffff8800379a4430 RCX: 0000000000000026
>  RDX: 0000000000000000 RSI: 0000000000000246 RDI: ffff8800379a4430
>  RBP: ffff88007a823d18 R08: 00000000ffffffff R09: 000000007a9bc65a
>  R10: 000000000000028f R11: 0000000000000005 R12: ffff880070123e98
>  R13: ffff880070123de8 R14: 0000000000000100 R15: ffffc90004888000
>  FS:  0000000000000000(0000) GS:ffff880079a80000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>  CR2: 0000000000000048 CR3: 000000007029b000 CR4: 00000000001007e0
>  Stack:
>   ffff88007a823d58 ffff8800379a4430 ffff88007a823d48 ffffffffa0022c89
>   0000000000000000 ffff8800379a4430 0000000000000000 0000000000000006
>   ffff88007a823da8 ffffffffa0023be0 ffff88007a823dd8 ffffffff81076204
>  Call Trace:
>   [<ffffffffa0022c89>] giveback+0x69/0xa0 [spi_pxa2xx_platform]
>   [<ffffffffa0023be0>] pump_transfers+0x710/0x740 [spi_pxa2xx_platform]
>   [<ffffffff81076204>] ? pick_next_task_fair+0x744/0x830
>   [<ffffffff81049679>] tasklet_action+0xa9/0xe0
>   [<ffffffff81049a0e>] __do_softirq+0xee/0x280
>   [<ffffffff81049bc0>] run_ksoftirqd+0x20/0x40
>   [<ffffffff810646df>] smpboot_thread_fn+0xff/0x1b0
>   [<ffffffff810645e0>] ? SyS_setgroups+0x150/0x150
>   [<ffffffff81060f9d>] kthread+0xcd/0xf0
>   [<ffffffff81060ed0>] ? kthread_create_on_node+0x180/0x180
>   [<ffffffff8187a82c>] ret_from_fork+0x7c/0xb0
> 
> Fix this by clearing drv_data->cur_chip before we call spi_finalize_current_message().
> 
> Reported-by: Martin Oldfield <m@mjoldfield.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Mark, any comments on this?
