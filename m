Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab3GOU27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 16:28:59 -0400
Received: from mail-vb0-f49.google.com ([209.85.212.49]:57061 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498Ab3GOU25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 16:28:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAOULuOY5VMiiuYmesaGxVWWKtby4Cj9Pc9ctQZeOKfoUzV46dA@mail.gmail.com>
References: <CAOULuOY5VMiiuYmesaGxVWWKtby4Cj9Pc9ctQZeOKfoUzV46dA@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 15 Jul 2013 13:28:36 -0700
Message-ID: <CALCETrVk=ovYjHwALtzB3E3nP4TMivhppM42yw7rMRpzA68cbw@mail.gmail.com>
Subject: Re: BGRT Pointer in System RAM
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        josh@joshtriplett.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 14, 2013 at 12:07 PM, Parag Warudkar <parag.lkml@gmail.com> wrote:
> Saw this warning running latest git (Ubuntu daily mainline.) It looked
> similar to what Andy saw on MSI hardware -
> http://www.spinics.net/lists/linux-acpi/msg43410.html . The patch for
> it doesn't seem to be merged, although it won't help in my case -
> different hardware with valid status instead of invalid and image
> address falling in system RAM instead of just being wild.
>
> Unsure  how this should be handled - moving the is_ram() check in
> efi_bgrt_init and ignoring the BGRT in case where the check succeeds?
> Doesn't sound completely right to me - since the BGRT is valid and
> exists somewhere, but..
>
> [    0.015141] ------------[ cut here ]------------
> [    0.015147] WARNING: CPU: 0 PID: 0 at
> /home/apw/COD/linux/arch/x86/mm/ioremap.c:102
> __ioremap_caller+0x312/0x390()
> [ snip ]
> [    0.015160] Call Trace:
> [    0.015165]  [<ffffffff8170a704>] dump_stack+0x46/0x58
> [    0.015169]  [<ffffffff8106406c>] warn_slowpath_common+0x8c/0xc0
> [    0.015171]  [<ffffffff810640ba>] warn_slowpath_null+0x1a/0x20
> [    0.015173]  [<ffffffff81054e32>] __ioremap_caller+0x312/0x390
> [    0.015176]  [<ffffffff814013d4>] ? acpi_tb_verify_table+0x54/0x58
> [    0.015179]  [<ffffffff81d35551>] ? efi_bgrt_init+0x8f/0x143
> [    0.015181]  [<ffffffff81054f07>] ioremap_nocache+0x17/0x20
> [    0.015183]  [<ffffffff81d35551>] efi_bgrt_init+0x8f/0x143
> [    0.015186]  [<ffffffff81401d36>] ? acpi_tb_initialize_facs+0x32/0x34
> [    0.015188]  [<ffffffff81d34e7f>] efi_late_init+0x9/0xb
> [    0.015190]  [<ffffffff81d18f17>] start_kernel+0x3fd/0x419
> [    0.015192]  [<ffffffff81d189ac>] ? do_early_param+0x87/0x87
> [    0.015194]  [<ffffffff81d18120>] ? early_idt_handlers+0x120/0x120
> [    0.015196]  [<ffffffff81d185e6>] x86_64_start_reservations+0x2a/0x2c
>
> ioremap.c:102
>     /*
>          * Don't allow anybody to remap normal RAM that we're using..
>          */
>         last_pfn = last_addr >> PAGE_SHIFT;
>         for (pfn = phys_addr >> PAGE_SHIFT; pfn <= last_pfn; pfn++) {
>                 int is_ram = page_is_ram(pfn);
>
>                 if (is_ram && pfn_valid(pfn) && !PageReserved(pfn_to_page(pfn)))
>                         return NULL;
>                 WARN_ON_ONCE(is_ram);
>         }
>
> Looking at the BGRT table from IASL, the status seems to be valid but
> the image address *seems* to me that is falling under system RAM.

Interesting.  My BGRT says:

[028h 0040   8]                Image Address : 0D06801800000001

If I reverse the high and low 32-bit dwords, then I get an address in
system RAM.

--Andy
