Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab3GNTHa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 15:07:30 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:42925 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab3GNTH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 15:07:27 -0400
MIME-Version: 1.0
Date: Sun, 14 Jul 2013 15:07:25 -0400
Message-ID: <CAOULuOY5VMiiuYmesaGxVWWKtby4Cj9Pc9ctQZeOKfoUzV46dA@mail.gmail.com>
Subject: BGRT Pointer in System RAM
From: Parag Warudkar <parag.lkml@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        luto@amacapital.net, josh@joshtriplett.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Saw this warning running latest git (Ubuntu daily mainline.) It looked
similar to what Andy saw on MSI hardware -
http://www.spinics.net/lists/linux-acpi/msg43410.html . The patch for
it doesn't seem to be merged, although it won't help in my case -
different hardware with valid status instead of invalid and image
address falling in system RAM instead of just being wild.

Unsure  how this should be handled - moving the is_ram() check in
efi_bgrt_init and ignoring the BGRT in case where the check succeeds?
Doesn't sound completely right to me - since the BGRT is valid and
exists somewhere, but..

[    0.015141] ------------[ cut here ]------------
[    0.015147] WARNING: CPU: 0 PID: 0 at
/home/apw/COD/linux/arch/x86/mm/ioremap.c:102
__ioremap_caller+0x312/0x390()
[ snip ]
[    0.015160] Call Trace:
[    0.015165]  [<ffffffff8170a704>] dump_stack+0x46/0x58
[    0.015169]  [<ffffffff8106406c>] warn_slowpath_common+0x8c/0xc0
[    0.015171]  [<ffffffff810640ba>] warn_slowpath_null+0x1a/0x20
[    0.015173]  [<ffffffff81054e32>] __ioremap_caller+0x312/0x390
[    0.015176]  [<ffffffff814013d4>] ? acpi_tb_verify_table+0x54/0x58
[    0.015179]  [<ffffffff81d35551>] ? efi_bgrt_init+0x8f/0x143
[    0.015181]  [<ffffffff81054f07>] ioremap_nocache+0x17/0x20
[    0.015183]  [<ffffffff81d35551>] efi_bgrt_init+0x8f/0x143
[    0.015186]  [<ffffffff81401d36>] ? acpi_tb_initialize_facs+0x32/0x34
[    0.015188]  [<ffffffff81d34e7f>] efi_late_init+0x9/0xb
[    0.015190]  [<ffffffff81d18f17>] start_kernel+0x3fd/0x419
[    0.015192]  [<ffffffff81d189ac>] ? do_early_param+0x87/0x87
[    0.015194]  [<ffffffff81d18120>] ? early_idt_handlers+0x120/0x120
[    0.015196]  [<ffffffff81d185e6>] x86_64_start_reservations+0x2a/0x2c

ioremap.c:102
    /*
         * Don't allow anybody to remap normal RAM that we're using..
         */
        last_pfn = last_addr >> PAGE_SHIFT;
        for (pfn = phys_addr >> PAGE_SHIFT; pfn <= last_pfn; pfn++) {
                int is_ram = page_is_ram(pfn);

                if (is_ram && pfn_valid(pfn) && !PageReserved(pfn_to_page(pfn)))
                        return NULL;
                WARN_ON_ONCE(is_ram);
        }

Looking at the BGRT table from IASL, the status seems to be valid but
the image address *seems* to me that is falling under system RAM.

[000h 0000   4]                    Signature : "BGRT"    [Boot
Graphics Resource Table]
[004h 0004   4]                 Table Length : 00000038
[008h 0008   1]                     Revision : 00
[009h 0009   1]                     Checksum : 3D
[00Ah 0010   6]                       Oem ID : "HPQOEM"
[010h 0016   8]                 Oem Table ID : "SLIC-CPC"
[018h 0024   4]                 Oem Revision : 01072009
[01Ch 0028   4]              Asl Compiler ID : "AMI "
[020h 0032   4]        Asl Compiler Revision : 00010013

[024h 0036   2]                      Version : 0001
[026h 0038   1]                       Status : 01
[027h 0039   1]                   Image Type : 00
[028h 0040   8]                Image Address : 00000000B2E1B018
[030h 0048   4]                Image OffsetX : 00000279
[034h 0052   4]                Image OffsetY : 0000014F

Below is from 3.8 kernel - I think that shouldn't make a difference
given ioremap also find the address in RAM.

$ cat /proc/iomem |grep RAM00010000-0009ffff : System RAM
00100000-bdb6bfff : System RAM
be6ef000-be6effff : System RAM
be8f6000-bed2ffff : System RAM
beff3000-beffffff : System RAM
bf000000-bfffffff : RAM buffer
100001000-2beffffff : System RAM
2bf000000-2bfffffff : RAM buffer
