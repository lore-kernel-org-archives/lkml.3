Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab3A3JkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 04:40:14 -0500
Received: from forward2.mail.yandex.net ([77.88.46.7]:36784 "EHLO
	forward2.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab3A3JkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 04:40:09 -0500
Message-ID: <5108EA4B.7030003@yandex.ru>
Date: Wed, 30 Jan 2013 13:39:23 +0400
From: Mike Lykov <combr@yandex.ru>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.10) Gecko/20121030 Thunderbird/10.0.10
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, kirill@shutemov.name
Subject: Re: [BUG?] false positive in soft lockup detector while unlzma initramfs
 on slow cpu
References: <5107D1D3.6040105@yandex.ru> <20130129153348.GR98867@redhat.com>
In-Reply-To: <20130129153348.GR98867@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

29.01.2013 19:33, Don Zickus пишет:

> The softlockup mechanism works scheduling a high priority task that kicks
> the softlockups.  If the unzip thread is taking too long, it could
> accidentally trip the detection.

Inyerestingly, that a decompress of lzma -4 takes longer time than 
decompress lzma -9, and it stated in man lzma(1):
"  On  the  same hardware, the decompression speed is approximately a 
constant number of bytes of compressed data per second.  In other words, 
the better the compression, the faster the  decompression
will  usually  be. "

I tested it on target computer by hand:

lzma -4 compressed: time unlzma initram-alt-p6rel3-4.cpio.lzma
20.94user 1.47system 0:22:45elapsed 99%CPU (...19424maxresidents)k

lzma -9 compressed: time unlzma initram-alt-p6rel3-9.cpio.lzma
19.49user 1.92system 0:21:44elapsed 99%CPU (...241488maxresidents)k

So, it cannot "take too long" because not-working faster than working.
Apparently time not matter, but algorithm complexity?

>> 2. How to change watchdog_thresh parameter at boot without patching
>> sources? If it necessary (with it side effects) maybe implement it
>> as commandline parameter or config compile time parameter?
>
> I attached a patch below that allows you to set it a boot time.  Let me
> know if this works for you, then I can clean it up and post it properly.

It not works for me. I apply this patch, build, use ("int __read_mostly 
watchdog_thresh = 10;"  as in original)
command line:

[    0.000000] Kernel command line: 
initrd=initram-alt-p6rel3-9.cpio.lzma console=uart,io,0x240,115200n8 
kernel.watchdog_thresh=30 BOOT_IMAGE=bzImage-3232-ml5-fwinkrn-wtdg10cmd

Full list of panic:

[   28.057086] BUG: soft lockup - CPU#0 stuck for 23s! [swapper:1]
[   28.057086]
[   28.057086] Pid: 1, comm: swapper Not tainted 
3.2.32VEP-01ML5-initramfs #19
[   28.057086] EIP: 0060:[<c03ab92f>] EFLAGS: 00000212 CPU: 0
[   28.057086] EIP is at rc_get_bit+0x1a/0x7c
[   28.057086] EAX: ce827f34 EBX: ce827f34 ECX: ce827f70 EDX: d481f926
[   28.057086] ESI: d481f926 EDI: ce827f70 EBP: ce827ee0 ESP: ce827ed4
[   28.057086]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[   28.057086] Process swapper (pid: 1, ti=ce802000 task=ce80b410 
task.ti=ce826000)
[   28.057086] Stack:
[   28.057086]  00000001 02857802 d481f86c ce827f80 c03abd13 0b60a3e6 
d481c666 00000000
[   28.057086]  00000003 cf0ea000 00000183 004f1e0a cf0ea000 00000003 
00000000 00e584dd
[   28.057086]  009c2509 d481f86c d481c000 d080a000 00000012 00000002 
000003dd ffffffff
[   28.057086] Call Trace:
[   28.057086]  [<c03abd13>] unlzma+0x382/0xac0
[   28.057086]  [<c03ab8ae>] ? gunzip+0x25b/0x25b
[   28.057086]  [<c039ed46>] ? initrd_load+0x3b/0x3b
[   28.057086]  [<c03ab991>] ? rc_get_bit+0x7c/0x7c
[   28.057086]  [<c039f211>] unpack_to_rootfs+0x139/0x237
[   28.057086]  [<c039ef53>] ? write_buffer+0x2c/0x2c
[   28.057086]  [<c039ed46>] ? initrd_load+0x3b/0x3b
[   28.057086]  [<c039e791>] ? do_one_initcall+0x112/0x112
[   28.057086]  [<c039f9b4>] populate_rootfs+0x42/0x85
[   28.057086]  [<c039e6ef>] do_one_initcall+0x70/0x112
[   28.057086]  [<c039f972>] ? do_header+0x1d4/0x1d4
[   28.057086]  [<c039e791>] ? do_one_initcall+0x112/0x112
[   28.057086]  [<c039e810>] kernel_init+0x7f/0xf8
[   28.057086]  [<c02eb2b6>] kernel_thread_helper+0x6/0xd
[   28.057086] Code: b6 01 41 c1 e2 08 89 4b 04 09 d0 89 43 14 5b 5d c3 
55 89 e5 57 89 cf 56 89 d6 53 89 c3 81 78 18 ff ff ff 00 77 05 e8 b5 ff 
ff ff <8b> 4b 18 0f b7 06 89 ca c1 ea 0b 0f af c2 8b 53 14 39 c2 89 43
[   28.057086] Call Trace:
[   28.057086]  [<c03abd13>] unlzma+0x382/0xac0
[   28.057086]  [<c03ab8ae>] ? gunzip+0x25b/0x25b
[   28.057086]  [<c039ed46>] ? initrd_load+0x3b/0x3b
[   28.057086]  [<c03ab991>] ? rc_get_bit+0x7c/0x7c
[   28.057086]  [<c039f211>] unpack_to_rootfs+0x139/0x237
[   28.057086]  [<c039ef53>] ? write_buffer+0x2c/0x2c
[   28.057086]  [<c039ed46>] ? initrd_load+0x3b/0x3b
[   28.057086]  [<c039e791>] ? do_one_initcall+0x112/0x112
[   28.057086]  [<c039f9b4>] populate_rootfs+0x42/0x85
[   28.057086]  [<c039e6ef>] do_one_initcall+0x70/0x112
[   28.057086]  [<c039f972>] ? do_header+0x1d4/0x1d4
[   28.057086]  [<c039e791>] ? do_one_initcall+0x112/0x112
[   28.057086]  [<c039e810>] kernel_init+0x7f/0xf8
[   28.057086]  [<c02eb2b6>] kernel_thread_helper+0x6/0xd
[   28.057086] Kernel panic - not syncing: softlockup: hung tasks
[   28.057086] Pid: 1, comm: swapper Not tainted 
3.2.32VEP-01ML5-initramfs #19
[   28.057086] Call Trace:
[   28.057086]  [<c02e91c4>] ? printk+0xf/0x11
[   28.057086]  [<c02e90c0>] panic+0x50/0x145
[   28.057086]  [<c012fa9b>] watchdog_timer_fn+0xf2/0x10f
[   28.057086]  [<c0124ae0>] hrtimer_run_queues+0x13d/0x1bc
[   28.057086]  [<c01193cf>] run_local_timers+0x8/0x14
[   28.057086]  [<c01193f6>] update_process_times+0x1b/0x4e
[   28.057086]  [<c012b6d2>] tick_periodic.clone.20+0x52/0x54
[   28.057086]  [<c012b6e1>] tick_handle_periodic+0xd/0x5b
[   28.057086]  [<c010339f>] timer_interrupt+0x13/0x1a
[   28.057086]  [<c013032b>] handle_irq_event_percpu+0x24/0xfb
[   28.057086]  [<c0131a80>] ? handle_simple_irq+0x3f/0x3f
[   28.057086]  [<c013041e>] handle_irq_event+0x1c/0x26
[   28.057086]  [<c0131aeb>] handle_level_irq+0x6b/0x75
[   28.057086]  <IRQ>  [<c0102f62>] ? do_IRQ+0x34/0x74
[   28.057086]  [<c02eb2a9>] ? common_interrupt+0x29/0x30
[   28.057086]  [<c03ab92f>] ? rc_get_bit+0x1a/0x7c
[   28.057086]  [<c03abd13>] ? unlzma+0x382/0xac0
[   28.057086]  [<c03ab8ae>] ? gunzip+0x25b/0x25b
[   28.057086]  [<c039ed46>] ? initrd_load+0x3b/0x3b
[   28.057086]  [<c03ab991>] ? rc_get_bit+0x7c/0x7c
[   28.057086]  [<c039f211>] ? unpack_to_rootfs+0x139/0x237
[   28.057086]  [<c039ef53>] ? write_buffer+0x2c/0x2c
[   28.057086]  [<c039ed46>] ? initrd_load+0x3b/0x3b
[   28.057086]  [<c039e791>] ? do_one_initcall+0x112/0x112
[   28.057086]  [<c039f9b4>] ? populate_rootfs+0x42/0x85
[   28.057086]  [<c039e6ef>] ? do_one_initcall+0x70/0x112
[   28.057086]  [<c039f972>] ? do_header+0x1d4/0x1d4
[   28.057086]  [<c039e791>] ? do_one_initcall+0x112/0x112
[   28.057086]  [<c039e810>] ? kernel_init+0x7f/0xf8
[   28.057086]  [<c02eb2b6>] ? kernel_thread_helper+0x6/0xd


> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 75a2ab3..e448d63 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -79,6 +79,14 @@ static int __init softlockup_panic_setup(char *str)
>   }
>   __setup("softlockup_panic=", softlockup_panic_setup);
>
> +static int __init watchdog_thresh_setup(char *str)
> +{
> +	watchdog_thresh = simple_strtoul(str, NULL, 0);
> +
> +	return 1;
> +}
> +__setup("watchdog_thresh=", watchdog_thresh_setup);
> +
>   static int __init nowatchdog_setup(char *str)
>   {
>   	watchdog_enabled = 0;

--
Mike
