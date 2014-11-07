Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751317AbaKGHon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 02:44:43 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:55457 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaKGHom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 02:44:42 -0500
MIME-Version: 1.0
In-Reply-To: <20141107073720.GB24745@yliu-dev.sh.intel.com>
References: <20141107054741.GB30507@yliu-dev.sh.intel.com>
	<CAKv+Gu9_ipZe-BV_CxhYVdv2mPrab3EXdznJUd-Unbw3usmckw@mail.gmail.com>
	<20141107073720.GB24745@yliu-dev.sh.intel.com>
Date: Fri, 7 Nov 2014 08:44:40 +0100
Message-ID: <CAKv+Gu-rRMmcP4LF3oo5=6hf8m7fjzkzV14hfkjBPbPn34OZGA@mail.gmail.com>
Subject: Re: [LKP] [dmi] PANIC: early exception 0e rip 10:ffffffff81899e6b
 error 9 cr2 ffffffffff240000
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: LKP <lkp@01.org>, Matt Fleming <matt.fleming@intel.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 November 2014 08:37, Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:
> On Fri, Nov 07, 2014 at 08:17:36AM +0100, Ard Biesheuvel wrote:
>> On 7 November 2014 06:47, LKP <lkp@01.org> wrote:
>> > FYI, we noticed the below changes on
>> >
>> > https://git.linaro.org/people/ard.biesheuvel/linux-arm efi-for-3.19
>> > commit aacdce6e880894acb57d71dcb2e3fc61b4ed4e96 ("dmi: add support for SMBIOS 3.0 64-bit entry point")
>> >
>> >
>> > +-----------------------+------------+------------+
>> > |                       | 2fa165a26c | aacdce6e88 |
>> > +-----------------------+------------+------------+
>> > | boot_successes        | 20         | 10         |
>> > | early-boot-hang       | 1          |            |
>> > | boot_failures         | 0          | 5          |
>> > | PANIC:early_exception | 0          | 5          |
>> > +-----------------------+------------+------------+
>> >
>> >
>> > [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000036fffffff] usable
>> > [    0.000000] bootconsole [earlyser0] enabled
>> > [    0.000000] NX (Execute Disable) protection: active
>> > PANIC: early exception 0e rip 10:ffffffff81899e6b error 9 cr2 ffffffffff240000
>> > [    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.18.0-rc2-gc5221e6 #1
>> > [    0.000000]  0000000000000000 ffffffff82203d30 ffffffff819f0a6e 00000000000003f8
>> > [    0.000000]  ffffffffff240000 ffffffff82203e18 ffffffff823701b0 ffffffff82511401
>> > [    0.000000]  0000000000000000 0000000000000ba3 0000000000000000 ffffffffff240000
>> > [    0.000000] Call Trace:
>> > [    0.000000]  [<ffffffff819f0a6e>] dump_stack+0x4e/0x68
>> > [    0.000000]  [<ffffffff823701b0>] early_idt_handler+0x90/0xb7
>> > [    0.000000]  [<ffffffff823c80da>] ? dmi_save_one_device+0x81/0x81
>> > [    0.000000]  [<ffffffff81899e6b>] ? dmi_table+0x3f/0x94
>> > [    0.000000]  [<ffffffff81899e42>] ? dmi_table+0x16/0x94
>> > [    0.000000]  [<ffffffff823c80da>] ? dmi_save_one_device+0x81/0x81
>> > [    0.000000]  [<ffffffff823c80da>] ? dmi_save_one_device+0x81/0x81
>> > [    0.000000]  [<ffffffff823c7eff>] dmi_walk_early+0x44/0x69
>> > [    0.000000]  [<ffffffff823c88a2>] dmi_present+0x180/0x1ff
>> > [    0.000000]  [<ffffffff823c8ab3>] dmi_scan_machine+0x144/0x191
>> > [    0.000000]  [<ffffffff82370702>] ? loglevel+0x31/0x31
>> > [    0.000000]  [<ffffffff82377f52>] setup_arch+0x490/0xc73
>> > [    0.000000]  [<ffffffff819eef73>] ? printk+0x4d/0x4f
>> > [    0.000000]  [<ffffffff82370b90>] start_kernel+0x9c/0x43f
>> > [    0.000000]  [<ffffffff82370120>] ? early_idt_handlers+0x120/0x120
>> > [    0.000000]  [<ffffffff823704a2>] x86_64_start_reservations+0x2a/0x2c
>> > [    0.000000]  [<ffffffff823705df>] x86_64_start_kernel+0x13b/0x14a
>> > [    0.000000] RIP 0x4
>> >
>>
>> This is most puzzling. Could anyone decode the exception?
>> This looks like the non-EFI path through dmi_scan_machine(), which
>> calls dmi_present() /after/ calling dmi_smbios3_present(), which
>> apparently has not found the _SM3_ header tag. Or could the call stack
>> be inaccurate?
>>
>> Anyway, it would be good to know the exact type of the platform,
>
> It's a Nehalem-EP machine, wht 16 CPU and 12G memory.
>
>> and
>> perhaps we could find out if there is an inadvertent _SM3_ tag
>> somewhere in the 0xF0000 - 0xFFFFF range?
>
> Sorry, how?
>

That's not a brand new machine, so I suppose there wouldn't be a
SMBIOS 3.0 header lurking in there.

Anyway, if you are in a position to try things, could you apply this

--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -617,7 +617,7 @@ void __init dmi_scan_machine(void)
                memset(buf, 0, 16);
                for (q = p; q < p + 0x10000; q += 16) {
                        memcpy_fromio(buf + 16, q, 16);
-                       if (!dmi_smbios3_present(buf) || !dmi_present(buf)) {
+                       if (!dmi_present(buf)) {
                                dmi_available = 1;
                                dmi_early_unmap(p, 0x10000);
                                goto out;

and try again? That is the only change that is relevant to the non-EFI
code path which this machine appears to take, so if this fixes things,
that would be valuable information even if it doesn't tell us exactly
what is going wrong.

Thanks,
Ard.
