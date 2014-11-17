Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbaKQVWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 16:22:09 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:54799 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbaKQVWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 16:22:07 -0500
MIME-Version: 1.0
In-Reply-To: <3357597.nYlNZ6O0nJ@wuerfel>
References: <1416097066-20452-1-git-send-email-cernekee@gmail.com>
 <2911624.UJRs5QOPN5@wuerfel> <CAJiQ=7BH8K=Q+JcWTKSfn6xAteOF4B6jahMu_qVd-FyZWD3pjA@mail.gmail.com>
 <3357597.nYlNZ6O0nJ@wuerfel>
From: Kevin Cernekee <cernekee@gmail.com>
Date: Mon, 17 Nov 2014 13:21:45 -0800
Message-ID: <CAJiQ=7B6Xwz2iqqH4vEG8WzPOzHj7NHsuGWqq49uy-E34RHp4A@mail.gmail.com>
Subject: Re: [PATCH V2 22/22] MIPS: Add multiplatform BMIPS target
To: Arnd Bergmann <arnd@arndb.de>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jon Fraser <jfraser@broadcom.com>, Dmitry Torokhov <dtor@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jonas Gorski <jonas.gorski@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 12:40 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> One possible complication: for BCM63xx/BCM7xxx (MIPS) there is no
>> decompressor in the kernel.  The firmware loads an ELF image into
>> memory and jumps directly to kernel_entry.
>>
>
> Right, that complicates it a bit, but is there a reason why a decompressor
> would be hard to do, or would be considered a bad thing?
> There is already generic decompressor code in arch/mips/boot/compressed/
> that I would assume you could use without firmware changes. Are you
> worried about boot time overhead?

Currently the bootloader is responsible for decompressing the image.
On STB the bootloader typically loads a gzipped ELF file; on DSL/CM
the bootloader unpacks a custom image format containing an
LZMA-compressed kernel in some form.  So we would be
double-compressing the same kernel in this scheme.

STB/DSL should be able to boot the arch/mips/boot/compressed "vmlinuz"
ELF file; I tested STB.  CM might be questionable, but doesn't need
decompressor mods because the bootloader is DT-aware.

Also, the decompressor may need to be modified so that it recognizes /
passes / doesn't overwrite DTB blobs coming from the bootloader.  And
to make sure it doesn't stomp on any of the code or data that our
bootloaders use for their callback mechanisms.

So, one possibility is to submit a V3 patch which allows 0 or 1 DTB
files to be compiled in statically (similar to
CONFIG_ARM_APPENDED_DTB) and requires a DT-aware bootloader or
decompressor for anything else.  Any opinions?
