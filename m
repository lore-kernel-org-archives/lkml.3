Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506AbaDPTVm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 15:21:42 -0400
Received: from mail1.windriver.com ([147.11.146.13]:50768 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187AbaDPTVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 15:21:38 -0400
Message-ID: <534ED833.6020303@windriver.com>
Date: Wed, 16 Apr 2014 15:21:23 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Stanislav Meduna <stano@meduna.org>, <zbr@ioremap.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
Subject: Re: w1-gpio: sleeping function called from invalid context
References: <534E97C8.5090407@meduna.org>
In-Reply-To: <534E97C8.5090407@meduna.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.56.57]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-04-16 10:46 AM, Stanislav Meduna wrote:
> Hi,
> 
> trying 1-wire with rt-patched Linux 3.12.15-rt25+ and lock debugging:

I didn't have 3.12-rt handy, but looking at vanilla 3.12, I see
that w1_touch_bit() turned off irqs via:

  static int w1_disable_irqs = 0;
  module_param_named(disable_irqs, w1_disable_irqs, int, 0);

...

  static void w1_write_bit(struct w1_master *dev, int bit)
  {
        unsigned long flags = 0;

        if(w1_disable_irqs) local_irq_save(flags);

...

so, if you are using the above module parameter, it will do the below
because gpiod_direction_output() does

spin_lock_irqsave(&gpio_lock, flags);

i.e. note it is not a raw lock, so it calls might_sleep, and then
you get the unravel below.

I've no idea why that module parameter exists.  Why do you set it?

Paul.
--

> 
> [   12.055550] BUG: sleeping function called from invalid context at /home/stano/Kernels/linux-3.12-rt/kernel/rtmutex.c:673
> [   12.055573] in_atomic(): 0, irqs_disabled(): 128, pid: 92, name: w1_bus_master1
> [   12.055588] 2 locks held by w1_bus_master1/92:
> [   12.055675]  #0:  (&dev->mutex){+.+...}, at: [<c0233560>] w1_process+0xbc/0xe0
> [   12.055729]  #1:  (&dev->bus_mutex){+.+...}, at: [<c0232a50>] w1_search+0x78/0x1e8
> [   12.055741] irq event stamp: 374
> [   12.055787] hardirqs last  enabled at (373): [<c02e04cc>] _raw_spin_unlock_irqrestore+0x6c/0x74
> [   12.055815] hardirqs last disabled at (374): [<c0234598>] w1_touch_bit+0x50/0xc4
> [   12.055860] softirqs last  enabled at (0): [<c001bacc>] copy_process+0x37c/0x1178
> [   12.055876] softirqs last disabled at (0): [<  (null)>]   (null)
> [   12.055899] CPU: 0 PID: 92 Comm: w1_bus_master1 Not tainted 3.12.15-rt25+ #66
> [   12.055973] [<c00151bc>] (unwind_backtrace+0x0/0xf4) from [<c0012c00>] (show_stack+0x10/0x14)
> [   12.056020] [<c0012c00>] (show_stack+0x10/0x14) from [<c02df920>] (rt_spin_lock+0x20/0x60)
> [   12.056080] [<c02df920>] (rt_spin_lock+0x20/0x60) from [<c01bc98c>] (gpiod_direction_output+0x50/0x2fc)
> [   12.056122] [<c01bc98c>] (gpiod_direction_output+0x50/0x2fc) from [<c02345ac>] (w1_touch_bit+0x64/0xc4)
> [   12.056156] [<c02345ac>] (w1_touch_bit+0x64/0xc4) from [<c0234794>] (w1_write_8+0x54/0x7c)
> [   12.056196] [<c0234794>] (w1_write_8+0x54/0x7c) from [<c0232a78>] (w1_search+0xa0/0x1e8)
> [   12.056239] [<c0232a78>] (w1_search+0xa0/0x1e8) from [<c0233414>] (w1_search_process_cb+0x50/0xe0)
> [   12.056280] [<c0233414>] (w1_search_process_cb+0x50/0xe0) from [<c0233570>] (w1_process+0xcc/0xe0)
> [   12.056334] [<c0233570>] (w1_process+0xcc/0xe0) from [<c003cf24>] (kthread+0xa0/0xa8)
> [   12.056379] [<c003cf24>] (kthread+0xa0/0xa8) from [<c000f3e0>] (ret_from_fork+0x14/0x34)
> 
> This happens reproducibly on any access.
> 
> Please Cc: me when replying
> 
> Thanks
> 
