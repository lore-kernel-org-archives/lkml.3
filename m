Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbaA1UH2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 15:07:28 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:57027 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790AbaA1UH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 15:07:27 -0500
MIME-Version: 1.0
In-Reply-To: <20140128194823.GA18702@gmail.com>
References: <52E6954F.2060303@nod.at>
	<CAGXu5jKXqUhTdhX_n8xSe+d3sPmZ0SK-aTQh2jCXWL6TgA5o=w@mail.gmail.com>
	<20140128062806.GA20750@gmail.com>
	<52E76997.40303@nod.at>
	<52E7D2E5.8090208@linux.intel.com>
	<52E7D9FF.1080506@nod.at>
	<52E7DB15.3090808@zytor.com>
	<CA+55aFzRJNEt-tOGgj-6OPB0cMW9ReM6y6kzCyR5bfts1de-Jg@mail.gmail.com>
	<20140128170507.GA16279@gmail.com>
	<CA+55aFw_xs1tUteDrXz21QZB7BFk5p+F5NZ-SpV=CUVjeFwapA@mail.gmail.com>
	<20140128194823.GA18702@gmail.com>
Date: Tue, 28 Jan 2014 12:07:26 -0800
X-Google-Sender-Auth: BR17wjbRJBgaq0TmEpsDUBhjptg
Message-ID: <CA+55aFzqJe2XFCTu3Wb4hvZULuR97OOeEhQLYvFMF2bYTLb5Vw@mail.gmail.com>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Kees Cook <keescook@chromium.org>, Cong Ding <dinggnu@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 11:48 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> I really meant it when I said I build without debuginfo! :)

Ok, but so what?

As mentioned, nobody sane should build with DEBUG_INFO. But a normal
vmlinux file has the symbol information even without it.

> So, when I build a kernel, such as with a regular 'make defconfig',
> the following happens in gdb:
>
>   Reading symbols from /home/mingo/tip/vmlinux...(no debugging symbols found)...done.
>   (gdb) list schedule+0x45
>   No symbol table is loaded.  Use the "file" command.
>
> Is there a way to resolve schedule+0x45 in a regular vmlinux? It was
> an honest question.

That seems to be just a gdb bug (or "UI feature"), in that gdb likes
to give misleading error messages and requires odd syntax for some
things.

The symbols are there (see the first line):

  Reading symbols from /home/mingo/tip/vmlinux...(no debugging symbols
found)...done.

and that "no debugging symbols found" is just because you don't have
the extra *debug* info.

The "list" command requires debug info to work (since that's where the
line number information is), and will not work with hex symbols either
if you don't have that. So when it says "No symbol table is loaded" it
really means "no debug information is loaded".

But you can see that the symbol is perfectly fine:

  (gdb) list *(schedule+0x45)
  No symbol table is loaded.  Use the "file" command.
  (gdb) x/3i schedule+0x45
     0xffffffff81616d05 <schedule+69>: adc    0x1(%rsi),%bh
     0xffffffff81616d0b <schedule+75>: callq  0xffffffff812c0b30
<blk_flush_plug_list>
     0xffffffff81616d10 <schedule+80>: jmp    0xffffffff81616cdf <schedule+31>

(ok, so 0x45 wasn't the start of a real instruction, but you get the idea).

So my point is that the hex address doesn't give you *anything* that
the symbolic address doesn't give you. Unless you do truly crazy
things like actively strip the kernel.

              Linus
