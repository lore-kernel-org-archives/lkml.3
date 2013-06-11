Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab3FKU72 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:59:28 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:59769 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755141Ab3FKU71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:59:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQWfpK6oVaeY8tv+TrTq0pu-s1BMVsQ91E10XF6qTAv5mw@mail.gmail.com>
References: <20130611184113.GA2288@www.outflux.net>
	<CAE9FiQXCj+H=h+SPcfW82dBK5n6aDGuX+pmg7zr+6mKtdD4nMg@mail.gmail.com>
	<CAGXu5jLnHTuMSQbLUPbJXAADMwOZAeNv_WyknuEiggCaqA5gpw@mail.gmail.com>
	<CAE9FiQWfpK6oVaeY8tv+TrTq0pu-s1BMVsQ91E10XF6qTAv5mw@mail.gmail.com>
Date: Tue, 11 Jun 2013 13:59:26 -0700
X-Google-Sender-Auth: aDRueeSWeovVgnOx5JReLGRJ_jk
Message-ID: <CAE9FiQUvdqcUnVjZVV2Qi4S9anrXQuWg0060WDV6yEyFRsWX2Q@mail.gmail.com>
Subject: Re: [PATCH] x86, boot: access cmdline when loaded high
From: Yinghai Lu <yinghai@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Gokul Caushik <caushik1@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 1:54 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>
>>> Before the patch, command line that is loaded high
>>> can be processed correctly in arch/x86/boot/compressed/cmdline.c.
>>
>> It can't. Here is the code from arch/x86/boot/cmdline.c:
>
> Are you sure?
>
> I tested that with kexec loaded second kernel high.
>
> How do you test that?

double checked, it works already:

10:~/k # sh kk
add_buffer: base:11fff6000 bufsz:80e0 memsz:a000
add_buffer: base:11fff0000 bufsz:44ce memsz:44ce
add_buffer: base:11d000000 bufsz:9084f0 memsz:2c43000
add_buffer: base:11acef000 bufsz:230f6ec memsz:230f6ec
[   33.551046] cpu0 machine_kexec: fn: ffffffff81076960, data: ffff880116a20000
10:~/k # kexec -d -e
[   52.939049] psmouse serio1: shutdown
...
[   52.965553] Starting new kernel
early console in decompress_kernel                  ============> from misc.c
decompress_kernel:
  input: [0x11ea902c2-0x11f390ba1], output: 0x11d000000, heap:
[0x11f398500-0x11f3a04ff]                               ============>
from misc.c

Decompressing Linux... xz... Parsing ELF... done.    ========> from misc.c
Booting the kernel.
[    0.000000]    real_mode_data :      phys 000000011fff0000
[    0.000000]    real_mode_data :      virt ffff88011fff0000
[    0.000000]       boot_params : init virt ffffffff82f839a0
[    0.000000]       boot_params :      phys 000000011ef839a0
[    0.000000]       boot_params :      virt ffff88011ef839a0
[    0.000000] boot_command_line : init virt ffffffff82e51020
[    0.000000] boot_command_line :      phys 000000011ee51020   ===> is high ?
[    0.000000] boot_command_line :      virt ffff88011ee51020
[    0.000000] Kernel Layout:
[    0.000000]   .text: [0x11d000000-0x11e0ae480]
[    0.000000] .rodata: [0x11e200000-0x11e9cefff]
[    0.000000]   .data: [0x11ea00000-0x11ebd3fbf]
[    0.000000]   .init: [0x11ebd5000-0x11ef6efff]
[    0.000000]    .bss: [0x11ef7d000-0x11fc1dfff]
[    0.000000]    .brk: [0x11fc1e000-0x11fc42fff]
[    0.000000] memblock_reserve: [0x0009f000-0x000fffff] * BIOS reserved
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.10.0-rc5-yh-00864-g9cca511-dirty
(yhlu@linux-siqj.site) (gcc version 4.7.2 20130108 [gcc-4_7-branch
revision 195012] (SUSE Linux) ) #1732 SMP Tue Jun 11 13:47:35 PDT 2013
[    0.000000] memblock_reserve: [0x11d000000-0x11fc1dfff] TEXT DATA BSS
[    0.000000] memblock_reserve: [0x11acef000-0x11cffefff] RAMDISK
[    0.000000] Command line: initcall_debug pci=routeirq debug
ignore_loglevel apic=debug ramdisk_size=262144 root=/dev/ram0 rw
ip=dhcp console=uart8250,io,0x3f8,115200n8
