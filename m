Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab3ITPgb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 11:36:31 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:44902 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3ITPg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 11:36:29 -0400
Message-ID: <523C6A88.30800@linux.vnet.ibm.com>
Date: Fri, 20 Sep 2013 21:02:24 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Regression on cpufreq in v3.12-rc1
References: <CACRpkdYo24DO7ra7cgc54BUN-1SGfmbdhacOT41n2=KknyEtLw@mail.gmail.com> <45987104.t6r4hvPgQn@vostro.rjw.lan>	<523AF22F.1010909@linux.vnet.ibm.com> <CACRpkdYxiDA25Yb+csWWgXMmJuKMMTNVbdF+2JUnsSrXQpYysQ@mail.gmail.com> <CACRpkdYBYdMJ6mTGUropOypx0ZVNn8eQMzV+eKocCSBZAu6xTA@mail.gmail.com> <CAKohpokQO82XMGwcTjVmNTbBVESyFqV4DAxMMU_RHEtN+LqUgg@mail.gmail.com> <CACRpkdYoNkgno24dtJAwOq2T9yoKQYgKQ+adfkSN8affYNePjQ@mail.gmail.com> <CAKohpokdOXrGVxEA89yrAq2T8MiqZNHrrXNagqqggo67rEmKYg@mail.gmail.com> <CACRpkdZDqoqrEPfdra+iVS-hopLpJbPmWh=r8UkYRFUMg17jpw@mail.gmail.com>
In-Reply-To: <CACRpkdZDqoqrEPfdra+iVS-hopLpJbPmWh=r8UkYRFUMg17jpw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092015-2674-0000-0000-00000ABAD8C2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2013 08:51 PM, Linus Walleij wrote:
> On Fri, Sep 20, 2013 at 10:49 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> 
>> We used to return early in case policy isn't found, but now we went
>> and took the lock..
> 
> Aha!
> 
>> Hmm... Remember I told you last time that I have another way of fixing
>> it up, probably we need that now..
>>
>> I wanted to add another variable to reflect if a cpufreq_driver is registered
>> or not, and if not then return early from these routines..
>>
>> I will get that in now, please see if you can give it a try..
> 
> OK standing by.
> 
>> But I am still surprised how are we reaching this place before your cpufreq
>> driver gets registered..
> 
> I have no idea really. The funny thing is that Russell has a similar
> platform (Assabet) and he's not seeing the issue. It appears on this
> h3600 iPAQ only.
> 
> So here is the backtrace:
> 
> [<c01db010>] (lock_policy_rwsem_read+0x0/0x3c) from [<c01dc6c8>]
> (cpufreq_get+0x34/0x68)
> [<c01dc694>] (cpufreq_get+0x0/0x68) from [<c01d2c94>]
> (sa1100_pcmcia_set_timing+0x18/0x28)
>  r5:00000000 r4:c182d008
> [<c01d2c7c>] (sa1100_pcmcia_set_timing+0x0/0x28) from [<c01d27ec>]
> (soc_pcmcia_add_one+0x100/0x220)
>  r4:c182d008
> [<c01d26ec>] (soc_pcmcia_add_one+0x0/0x220) from [<c01d2d30>]
> (sa11xx_drv_pcmcia_add_one+0x8c/0xa4)
> [<c01d2ca4>] (sa11xx_drv_pcmcia_add_one+0x0/0xa4) from [<c01d2de4>]
> (sa11xx_drv_pcmcia_probe+0x9c/0xf8)
>  r8:00000002 r7:c182d000 r6:c182d000 r5:00000000 r4:c182d008
> [<c01d2d48>] (sa11xx_drv_pcmcia_probe+0x0/0xf8) from [<c01d3184>]
> (pcmcia_h3600_init+0x1c/0x24)
> [<c01d3168>] (pcmcia_h3600_init+0x0/0x24) from [<c01d2f70>]
> (sa11x0_drv_pcmcia_probe+0x14/0x18)
> [<c01d2f5c>] (sa11x0_drv_pcmcia_probe+0x0/0x18) from [<c019ec70>]
> (platform_drv_probe+0x20/0x24)
> [<c019ec50>] (platform_drv_probe+0x0/0x24) from [<c019d638>]
> (really_probe+0x108/0x1c4)
> [<c019d530>] (really_probe+0x0/0x1c4) from [<c019d724>]
> (driver_probe_device+0x30/0x34)
>  r8:00000000 r7:c019d970 r6:c05c81f0 r5:c05bb6b0 r4:c05bb67c
> [<c019d6f4>] (driver_probe_device+0x0/0x34) from [<c019d9f8>]
> (__driver_attach+0x88/0x8c)
> [<c019d970>] (__driver_attach+0x0/0x8c) from [<c019bea0>]
> (bus_for_each_dev+0x74/0x98)
>  r6:c05c81f0 r5:c1833e40 r4:00000000
> [<c019be2c>] (bus_for_each_dev+0x0/0x98) from [<c019d410>]
> (driver_attach+0x20/0x28)
>  r7:00000000 r6:c05c6c58 r5:c05c81f0 r4:c18c5900
> [<c019d3f0>] (driver_attach+0x0/0x28) from [<c019cc6c>]
> (bus_add_driver+0xe0/0x19c)
> [<c019cb8c>] (bus_add_driver+0x0/0x19c) from [<c019dfe4>]
> (driver_register+0x60/0x104)
>  r7:c036b6ac r6:00000006 r5:00000000 r4:c05c81f0
> [<c019df84>] (driver_register+0x0/0x104) from [<c019ef64>]
> (__platform_driver_register+0x50/0x64)
>  r5:00000000 r4:c1832000
> [<c019ef14>] (__platform_driver_register+0x0/0x64) from [<c036b6c4>]
> (sa11x0_pcmcia_init+0x18/0x20)
> [<c036b6ac>] (sa11x0_pcmcia_init+0x0/0x20) from [<c00085a4>]
> (do_one_initcall+0x9c/0xfc)
> [<c0008508>] (do_one_initcall+0x0/0xfc) from [<c0355590>]
> (do_initcall_level+0x80/0xb0)
>  r7:c036fbec r6:00000006 r5:00000005 r4:c0372d9c
> [<c0355510>] (do_initcall_level+0x0/0xb0) from [<c03555e4>]
> (do_initcalls+0x24/0x30)
>  r7:00000000 r6:00000000 r5:c0297820 r4:00000006
> [<c03555c0>] (do_initcalls+0x0/0x30) from [<c03556bc>]
> (do_basic_setup+0x28/0x2c)
>  r4:00000000
> [<c0355694>] (do_basic_setup+0x0/0x2c) from [<c0355a98>]
> (kernel_init_freeable+0x4c/0xdc)
> [<c0355a4c>] (kernel_init_freeable+0x0/0xdc) from [<c0297830>]
> (kernel_init+0x10/0xf0)
>  r4:00000000
> [<c0297820>] (kernel_init+0x0/0xf0) from [<c000f950>] (ret_from_fork+0x14/0x24)
>  r4:00000000
> Code: e59f0014 eb02f800 e3a00000 e89da800 (e7f001f2)
> 
> sa11x0_pcmcia_init() which starts this chain of events is called as
> an fs_initcall(), see drivers/pcmcia/sa1100_generic.c

But fs_initcall() comes after arch_initcall() right? (looking at
include/linux/init.h). Since the corresponding cpufreq-driver (drivers/
cpufreq/sa1100-cpufreq.c) uses arch_initcall() to register itself, it
is all the more surprising how this could happen...

Regards,
Srivatsa S. Bhat

> if I comment out this one, I get the same thing in the frambuffer
> driver instead, which is at module_init().
> 
> I don't have a trace so it's not like I know exactly what happened
> before this point,
> but the dmesg up to here reads:
> 
> Linux version 3.11.0-rc4-00024-g6eed940 (linus@localhost.localdomain)
> (gcc version 4.2.1) #41 Fri Sep 20 10:50:04 CEST 2013
> CPU: StrongARM-1110 [6901b118] revision 8 (ARMv4), cr=c000717f
> CPU: VIVT data cache, VIVT instruction cache
> Machine: Compaq iPAQ H3600
> Ignoring tag cmdline (using the default kernel command line)
> Memory policy: ECC disabled, Data cache writeback
> Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 8128
> Kernel command line: console=ttySA0,115200n8
> PID hash table entries: 128 (order: -3, 512 bytes)
> Dentry cache hash table entries: 4096 (order: 2, 16384 bytes)
> Inode-cache hash table entries: 2048 (order: 1, 8192 bytes)
> Memory: 26412K/32768K available (2643K kernel code, 118K rwdata, 736K
> rodata, 2411K init, 76K bss, 6356K reserved)
> Virtual kernel memory layout:
>     vector  : 0xffff0000 - 0xffff1000   (   4 kB)
>     fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
>     vmalloc : 0xc2800000 - 0xff000000   ( 968 MB)
>     lowmem  : 0xc0000000 - 0xc2000000   (  32 MB)
>     modules : 0xbf000000 - 0xc0000000   (  16 MB)
>       .text : 0xc0008000 - 0xc0354f18   (3380 kB)
>       .init : 0xc0355000 - 0xc05affb4   (2412 kB)
>       .data : 0xc05b0000 - 0xc05cd840   ( 119 kB)
>        .bss : 0xc05cd840 - 0xc05e0a68   (  77 kB)
> SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
> NR_IRQS:16 nr_irqs:49 49
> sched_clock: 32 bits at 3686kHz, resolution 271ns, wraps every 1165084ms
> Console: colour dummy device 80x30
> console [ttySA0] enabled
> Calibrating delay loop... 136.60 BogoMIPS (lpj=683008)
> pid_max: default: 32768 minimum: 301
> Mount-cache hash table entries: 512
> CPU: Testing write buffer coherency: ok
> Setting up static identity map for 0xc029a910 - 0xc029a968
> NET: Registered protocol family 16
> DMA: preallocated 256 KiB pool for atomic coherent allocations
> bio: create slab <bio-0> at 0
> Switched to clocksource oscr
> 
> Yours,
> Linus Walleij
> 


