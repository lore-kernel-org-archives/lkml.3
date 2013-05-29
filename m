Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966753Ab3E2PTZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 11:19:25 -0400
Received: from mail.skitlab.ru ([217.65.220.135]:34367 "EHLO mail.skitlab.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966175Ab3E2PTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 11:19:23 -0400
Message-ID: <51A61C78.3020409@skitlab.ru>
Date: Wed, 29 May 2013 19:19:20 +0400
From: Aida Mynzhasova <aida.mynzhasova@skitlab.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>
CC: linux-omap@vger.kernel.org, tony@atomide.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: OMAP: fix IVA2 module base address
References: <1369741577-21984-1-git-send-email-aida.mynzhasova@skitlab.ru> <87bo7vdvo2.fsf@linaro.org>
In-Reply-To: <87bo7vdvo2.fsf@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.05.2013 18:30, Kevin Hilman wrote:
> Aida Mynzhasova <aida.mynzhasova@skitlab.ru> writes:
>
>> This patch corrects the base address of IVA2 module on omap3430.
>>
>> Signed-off-by: Aida Mynzhasova <aida.mynzhasova@skitlab.ru>
>
> I know it looks a bit weird to have a negative offset like this, but
> it's actually correct.  These offsets are used relative to
> prm_base (on 34xx, it's OMAP3430_PRM_BASE defined in omap34xx.h).
> So I suggest you double check the values there, and cross reference to
> the "PRCM Register Manual" section of the TRM (last section of the PRCM
> chapter.)
>
> Thanks,
>
> Kevin
>

Ok, thanks for making it clear.

I thought that it can be a bug, because I made an attempt to run
Linux 3.10-rc3 kernel on Texas Instrument's DM816x evaluation module.
Without making any changes I faced with the kernel crush:

[    0.000000] Unhandled fault: external abort on non-linefetch (0x1028) 
at 0xfa17f8e4
[    0.000000] Internal error: : 1028 [#1] SMP ARM
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 
3.10.0-rc3-00001-g0e5443c-dirty #12
[    0.000000] task: c076fc50 ti: c0764000 task.ti: c0764000
[    0.000000] PC is at omap2_pwrdm_wait_transition+0x1c/0xac
[    0.000000] LR is at pwrdm_register_pwrdms+0x15c/0x1ac
[    0.000000] pc : [<c0031698>]    lr : [<c0036010>]    psr: 60000193
[    0.000000] sp : c0765f28  ip : c07bebe0  fp : 00000001
[    0.000000] r10: c07e6a90  r9 : 00000000  r8 : c07e6944
[    0.000000] r7 : c0754a50  r6 : c064f264  r5 : c0775298  r4 : c0773e9c
[    0.000000] r3 : fffff8e4  r2 : fa17f8e4  r1 : 00000004  r0 : c0775298
[    0.000000] Flags: nZCv  IRQs off  FIQs on  Mode SVC_32  ISA ARM 
Segment kernel
[    0.000000] Control: 10c5387d  Table: 80004019  DAC: 00000017
[    0.000000] Process swapper (pid: 0, stack limit = 0xc0764240)
[    0.000000] Stack: (0xc0765f28 to 0xc0766000)
[    0.000000] 5f20:                   c0773e9c c0775298 c064f264 
c0754a50 c0773ee4 c0036010
[    0.000000] 5f40: 35170034 81600134 c05125a8 fa180000 80000200 
c0771348 c07b1b48 c07475ac
[    0.000000] 5f60: c0771348 c07191fc c0647c40 c0711598 16c00000 
c0d24fb4 c06450ac c070c148
[    0.000000] 5f80: c0765f98 c0765f90 c0771134 c0765fdc 00000000 
00000000 00000000 00000000
[    0.000000] 5fa0: c0643878 00000001 00000000 c0748774 c0771134 
c076c880 413fc082 00000000
[    0.000000] 5fc0: 00000000 c07086fc 00000000 00000000 00000000 
00000000 00000000 c0748778
[    0.000000] 5fe0: 10c53c7d c076c910 c0748774 c0771134 80004059 
80008074 00000000 00000000
[    0.000000] [<c0031698>] (omap2_pwrdm_wait_transition+0x1c/0xac) from 
[<c0036010>] (pwrdm_register_pwrdms+0x15c/0x1ac)
[    0.000000] [<c0036010>] (pwrdm_register_pwrdms+0x15c/0x1ac) from 
[<c07191fc>] (omap3xxx_powerdomains_init+0x50/0x144)
[    0.000000] [<c07191fc>] (omap3xxx_powerdomains_init+0x50/0x144) from 
[<c0711598>] (ti81xx_init_early+0xcc/0x178)
[    0.000000] [<c0711598>] (ti81xx_init_early+0xcc/0x178) from 
[<c070c148>] (setup_arch+0x5ac/0x800)
[    0.000000] [<c070c148>] (setup_arch+0x5ac/0x800) from [<c07086fc>] 
(start_kernel+0x7c/0x330)
[    0.000000] [<c07086fc>] (start_kernel+0x7c/0x330) from [<80008074>] 
(0x80008074)
[    0.000000] Code: e1d030f8 e5982000 e28330e4 e0822003 (e5921000)
[    0.000000] ---[ end trace 1b75b31a2719ed1c ]---

So, I tried to find out what's wrong and explored the code of 
omap3xxx_powerdomains_init() call. It turned out that powerdomain 
initialization for ti81xx platform uses *powerdomains_omap3430_common[] 
structures, and when it tries to init iva2_pwrdm kernel crush occures. 
After applying my code changes the situation becomes a little bit 
better, and the kernel is able to continue it's loading (but still 
unable to load completely).

Anyway, maybe it can be a good idea to add new powerdomain structures 
for supporting ti81xx platform in mainline kernel. Actually I have 
already done some code changes for making current kernel bootable on 
DM816x EVM and I'm going to continue my work.

Thanks,

Aida

