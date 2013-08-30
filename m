Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab3H3LjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 07:39:09 -0400
Received: from mail.active-venture.com ([67.228.131.205]:55973 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119Ab3H3LjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 07:39:06 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <52208458.7070309@roeck-us.net>
Date: Fri, 30 Aug 2013 04:39:04 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tim Bird <tbird20d@gmail.com>
CC: grant.likely@linaro.org, linus.walleij@linaro.org,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        tim.bird@sonymobile.com
Subject: Re: RFC: Bug in error handling in gpiolib.c
References: <521CFB38.8080705@gmail.com>
In-Reply-To: <521CFB38.8080705@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2013 12:17 PM, Tim Bird wrote:
> Hi all,
>
> There appears to be a bug in the error handling in
> drivers/gpi/gpiolib.c  In certain error cases
> desc_to_gpio() is called to get the gpio number
> for an error message, but this may happen on code
> paths where desc->chip is NULL.  This causes a panic
> on my system in gpiod_request(), as follows:
>
> [    4.838393] Unable to handle kernel NULL pointer dereference at virtual address 00000044
> [    4.846379] pgd = c0204000
> [    4.849041] [00000044] *pgd=00000000
> [    4.852572] Internal error: Oops: 5 [#1] PREEMPT ARM
> [    4.857470] CPU: 0 PID: 1 Comm: swapper Not tainted 3.11.0-rc1-00306-g0db7796-dirty #78
> [    4.865373] task: ef01fb80 ti: ef034000 task.ti: ef034000
> [    4.870703] PC is at gpiod_request+0x84/0x2c8
> [    4.874995] LR is at gpiod_request+0x84/0x2c8
> [    4.879293] pc : [<c03373c0>]    lr : [<c03373c0>]    psr: 40000093
> [    4.879293] sp : ef035e00  ip : 000008d0  fp : 00000000
> [    4.890631] r10: 00000000  r9 : ef07ee20  r8 : 40000013
> [    4.895788] r7 : ef034000  r6 : c0482c88  r5 : c0529b90  r4 : fffffdfb
> [    4.902232] r3 : 00000000  r2 : ef035d78  r1 : 00000000  r0 : 00000011
> [    4.908681] Flags: nZcv  IRQs off  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> [    4.915982] Control: 10c5787d  Table: 80204059  DAC: 00000015
> [    4.921652] Process swapper (pid: 1, stack limit = 0xef034230)
> [    4.927408] Stack: (0xef035e00 to 0xef036000)
> [    4.931711] 5e00: 00000000 ef07ee00 ef199880 ef19ae00 ef07ee20 00000001 ef19ae80 c036d0d0
> [    4.939789] 5e20: c0481694 c0482e38 ef07c440 00000035 ef07ee20 ef07ee20 c04f9298 ef07ee00
> [    4.947865] 5e40: 00000000 c052b6b8 00000000 c04ab224 00000000 c037ff84 ef07ee20 c04f9298
> [    4.955943] 5e60: c052b6b0 c03625c8 ef07c440 c04bbd4c ef07ee20 c04f9298 ef07ee54 ef19bdc0
> [    4.964019] 5e80: c04bbd4c c0362840 00000000 c04f9298 c03627b4 c0360c00 ef063318 ef07baf0
> [    4.972097] 5ea0: 00000000 c04f9298 c04f9884 c0361390 c0482e38 c0316f9c c04f9298 c04c021c
> [    4.980174] 5ec0: fa7e5603 00000000 c04bbd4c c0362e1c c04f9884 c04f9274 c04c021c fa7e5603
> [    4.988250] 5ee0: 00000000 c04bbd4c c04ab224 c0381160 00000000 00000006 c04c021c c04ab888
> [    4.996327] 5f00: 00000030 00000000 fa7e5603 00000000 c04ff100 40000013 c04d0e98 00000001
> [    5.004406] 5f20: c05339ff c04305dc 0000003c c0234950 ef035f5c c023ee94 c0483d94 c0494388
> [    5.012481] 5f40: 00000006 00000006 c04d0e8c 00000006 00000006 c04c021c c04c3428 c04ff140
> [    5.020558] 5f60: 0000003c c04c0228 c04ab224 c04aba64 00000006 00000006 c04ab224 ffffffff
> [    5.028635] 5f80: ef035f9c c023ed44 00000000 c041d20c 00000000 00000000 00000000 00000000
> [    5.036713] 5fa0: 00000000 c041d214 00000000 c020e298 00000000 00000000 00000000 00000000
> [    5.044790] 5fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
> [    5.052866] 5fe0: 00000000 00000000 00000000 00000000 00000013 00000000 ffffffff ffffffff
> [    5.060961] [<c03373c0>] (gpiod_request+0x84/0x2c8) from [<c036d0d0>] (lc898300_probe+0x1c4/0x49c)
> [    5.069804] [<c036d0d0>] (lc898300_probe+0x1c4/0x49c) from [<c037ff84>] (i2c_device_probe+0x88/0xcc)
> [    5.078830] [<c037ff84>] (i2c_device_probe+0x88/0xcc) from [<c03625c8>] (driver_probe_device+0xe4/0x2d0)
> [    5.088192] [<c03625c8>] (driver_probe_device+0xe4/0x2d0) from [<c0362840>] (__driver_attach+0x8c/0x90)
> [    5.097470] [<c0362840>] (__driver_attach+0x8c/0x90) from [<c0360c00>] (bus_for_each_dev+0x54/0x88)
> [    5.106405] [<c0360c00>] (bus_for_each_dev+0x54/0x88) from [<c0361390>] (bus_add_driver+0xc8/0x22c)
> [    5.115342] [<c0361390>] (bus_add_driver+0xc8/0x22c) from [<c0362e1c>] (driver_register+0x78/0x14c)
> [    5.124282] [<c0362e1c>] (driver_register+0x78/0x14c) from [<c0381160>] (i2c_register_driver+0x2c/0xc8)
> [    5.133568] [<c0381160>] (i2c_register_driver+0x2c/0xc8) from [<c04ab888>] (do_one_initcall+0x50/0x144)
> [    5.142842] [<c04ab888>] (do_one_initcall+0x50/0x144) from [<c04aba64>] (kernel_init_freeable+0xe8/0x1ac)
> [    5.152293] [<c04aba64>] (kernel_init_freeable+0xe8/0x1ac) from [<c041d214>] (kernel_init+0x8/0xe4)
> [    5.161233] [<c041d214>] (kernel_init+0x8/0xe4) from [<c020e298>] (ret_from_fork+0x14/0x3c)
> [    5.169471] Code: 03c7703f 1a000025 e59f0214 eb039ba7 (e59a3044)
> [    5.175507] ---[ end trace 3e6eedf8393bc047 ]---
> [    5.180035] note: swapper[1] exited with preempt_count 1
> [    5.185368] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
> [    5.185368]
>
> This is happening with a (likely broken) gpio driver, but it would be
> better to get an error message rather than a panic in that case, I think.
>

I wonder if this is because gpiochip_export() failed,
or possibly because the gpio driver is not even registered yet.

Do you see any other error message in the kernel log before this happens ?

Guenter

