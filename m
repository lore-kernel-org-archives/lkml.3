Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab3GHQ65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 12:58:57 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:62841 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab3GHQ6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 12:58:55 -0400
MIME-Version: 1.0
In-Reply-To: <522C1DF17AF50042AD8AE87F7887BD3D0B7886DB32@exch>
References: <alpine.DEB.2.02.1307021912180.12710@ayla.of.borg>
	<CAErSpo41dwRCbMgYz8veHP6Mz62Z-uFJZ8NEQY6y1ULsqwiY7g@mail.gmail.com>
	<CAMuHMdWoTMEyyph8aEu46+xHfkXRFN_qn4a987n7eo6EPRyyhw@mail.gmail.com>
	<522C1DF17AF50042AD8AE87F7887BD3D0B7886DB32@exch>
Date: Mon, 8 Jul 2013 18:58:54 +0200
X-Google-Sender-Auth: dRPzV9HsqmhtGpjgcUeOrL7br7s
Message-ID: <CAMuHMdXuFUSheKrxD_8Apj0y=j91cB+0p1VCqyF1piopQ_Of5w@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.10
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Marc Gauthier <Marc.Gauthier@tensilica.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marc,

On Sat, Jul 6, 2013 at 8:07 AM, Marc Gauthier
<Marc.Gauthier@tensilica.com> wrote:
> Geert Uytterhoeven wrote:
>> On Tue, Jul 2, 2013 at 8:34 PM, Bjorn Helgaas
>> <bhelgaas@google.com> wrote:
>> >>   + warning: vmlinux.o(.text+0x1ad7a4): Section mismatch
>> in reference from the function pwmchip_add() to the function
>> .init.text:pcibios_fixup_bus():  => N/A
>> >>   + warning: vmlinux.o(.text+0x1b18d8): Section mismatch
>> in reference from the function pci_scan_child_bus() to the
>> function .init.text:pcibios_fixup_bus():  => N/A

Bjorn: both warnings went away after your patch
(http://permalink.gmane.org/gmane.linux.kernel.pci/23678). Thanks!

>> > I understand the second warning, but not the first (reference from
>> > pwmchip_add() to pcibios_fixup_bus()).  I don't think pwmchip_add()
>> > calls pcibios_fixup_bus().  Is the pwmchip_chip() function name
>> > inexact, or is there some other problem here?
>>
>> Indeed, that's weird.
>>
>> This happened with xtensa-allmodconfig.
>> I compiled my own xtensa-allmodconfig kernel, and it happens
>> there, too.
>>
>> If I'm not mistaken, the hex address between parentheses should match
>> the "from" function, right?
>> After disassembly ("xtensa-linux-objdump -D vmlinux"), the addresses
>> didn't seem to match the function names at all.
>> So it may be an issue with the toolchain?
>
> The Xtensa linker, by default, does some code shrinkage
> (some of the "relaxations") after applying relocations,
> causing code to move around.  This can sometimes cause
> error/warning messages to use incorrect addresses.
> (Not trivial to fix in the linker.)
>
> There's a config option LD_NO_RELAX to disable linker
> relaxation.  If using this option fixes the names, it
> may be this issue.

This was allmodconfig, so CONFIG_LD_NO_RELAX was set.
After disabling it, it fails with:

net/built-in.o: In function `net_rx_action':
net/core/dev.c:4194:(.text+0x11b91): dangerous relocation: call8:
misaligned call target: (.text.unlikely+0x47)
net/built-in.o: In function `raw_seqcount_begin':
include/linux/seqlock.h:106:(.text+0x132be): dangerous relocation:
call8: misaligned call target: (.text.unlikely+0x47)

Similar to the defconfig on
http://kisskb.ellerman.id.au/kisskb/buildresult/9070101/.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
