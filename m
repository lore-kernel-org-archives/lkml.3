Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933323AbaBAQKT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 11:10:19 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:46406 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520AbaBAQKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 11:10:16 -0500
MIME-Version: 1.0
In-Reply-To: <1391088765-6461-1-git-send-email-k.kozlowski@samsung.com>
References: <1391088765-6461-1-git-send-email-k.kozlowski@samsung.com>
Date: Sat, 1 Feb 2014 20:10:15 +0400
Message-ID: <CALT56yMV6Cf8cgnJfWndAkQWPnDsGSDZq4LhSCp_DgK8c-N+kg@mail.gmail.com>
Subject: Re: [PATCH] power: max17040: Fix NULL pointer dereference when there
 is no platform_data
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Minkyu Kang <mk7.kang@samsung.com>, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 30, 2014 at 5:32 PM, Krzysztof Kozlowski
<k.kozlowski@samsung.com> wrote:
> Fix NULL pointer dereference of "chip->pdata" if platform_data was not
> supplied to the driver.
>
> The driver during probe stored the pointer to the platform_data:
>         chip->pdata = client->dev.platform_data;
> Later it was dereferenced in max17040_get_online() and
> max17040_get_status().
>
> If platform_data was not supplied, the NULL pointer exception would
> happen:
>
> [    6.626094] Unable to handle kernel  of a at virtual address 00000000
> [    6.628557] pgd = c0004000
> [    6.632868] [00000000] *pgd=66262564
> [    6.634636] Unable to handle kernel paging request at virtual address e6262000
> [    6.642014] pgd = de468000
> [    6.644700] [e6262000] *pgd=00000000
> [    6.648265] Internal error: Oops: 5 [#1] PREEMPT SMP ARM
> [    6.653552] Modules linked in:
> [    6.656598] CPU: 0 PID: 31 Comm: kworker/0:1 Not tainted 3.10.14-02717-gc58b4b4 #505
> [    6.664334] Workqueue: events max17040_work
> [    6.668488] task: dfa11b80 ti: df9f6000 task.ti: df9f6000
> [    6.673873] PC is at show_pte+0x80/0xb8
> [    6.677687] LR is at show_pte+0x3c/0xb8
> [    6.681503] pc : [<c001b7b8>]    lr : [<c001b774>]    psr: 600f0113
> [    6.681503] sp : df9f7d58  ip : 600f0113  fp : 00000009
> [    6.692965] r10: 00000000  r9 : 00000000  r8 : dfa11b80
> [    6.698171] r7 : df9f7ea0  r6 : e6262000  r5 : 00000000  r4 : 00000000
> [    6.704680] r3 : 00000000  r2 : e6262000  r1 : 600f0193  r0 : c05b3750
> [    6.711194] Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> [    6.718485] Control: 10c53c7d  Table: 5e46806a  DAC: 00000015
> [    6.724218] Process kworker/0:1 (pid: 31, stack limit = 0xdf9f6238)
> [    6.730465] Stack: (0xdf9f7d58 to 0xdf9f8000)
> [    6.914325] [<c001b7b8>] (show_pte+0x80/0xb8) from [<c047107c>] (__do_kernel_fault.part.9+0x44/0x74)
> [    6.923425] [<c047107c>] (__do_kernel_fault.part.9+0x44/0x74) from [<c001bb7c>] (do_page_fault+0x2c4/0x360)
> [    6.933144] [<c001bb7c>] (do_page_fault+0x2c4/0x360) from [<c0008400>] (do_DataAbort+0x34/0x9c)
> [    6.941825] [<c0008400>] (do_DataAbort+0x34/0x9c) from [<c000e5d8>] (__dabt_svc+0x38/0x60)
> [    6.950058] Exception stack(0xdf9f7ea0 to 0xdf9f7ee8)
> [    6.955099] 7ea0: df0c1790 00000000 00000002 00000000 df0c1794 df0c1790 df0c1790 00000042
> [    6.963271] 7ec0: df0c1794 00000001 00000000 00000009 00000000 df9f7ee8 c0306268 c0306270
> [    6.971419] 7ee0: a00f0113 ffffffff
> [    6.974902] [<c000e5d8>] (__dabt_svc+0x38/0x60) from [<c0306270>] (max17040_work+0x8c/0x144)
> [    6.983317] [<c0306270>] (max17040_work+0x8c/0x144) from [<c003f364>] (process_one_work+0x138/0x440)
> [    6.992429] [<c003f364>] (process_one_work+0x138/0x440) from [<c003fa64>] (worker_thread+0x134/0x3b8)
> [    7.001628] [<c003fa64>] (worker_thread+0x134/0x3b8) from [<c00454bc>] (kthread+0xa4/0xb0)
> [    7.009875] [<c00454bc>] (kthread+0xa4/0xb0) from [<c000eb28>] (ret_from_fork+0x14/0x2c)
> [    7.017943] Code: e1a03005 e2422480 e0826104 e59f002c (e7922104)
> [    7.024017] ---[ end trace 73bc7006b9cc5c79 ]---
>
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Fixes: c6f4a42de60b981dd210de01cd3e575835e3158e
> Cc: <stable@vger.kernel.org>

Thank you, I will apply to fixes branch.




-- 
With best wishes
Dmitry
