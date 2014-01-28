Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbaA1Ts3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 14:48:29 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:40718 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299AbaA1Ts1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 14:48:27 -0500
Date: Tue, 28 Jan 2014 20:48:23 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Kees Cook <keescook@chromium.org>, Cong Ding <dinggnu@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mathias Krause <minipli@googlemail.com>,
        Michael Davidson <md@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: Re: [GIT PULL] x86/kaslr for v3.14
Message-ID: <20140128194823.GA18702@gmail.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw_xs1tUteDrXz21QZB7BFk5p+F5NZ-SpV=CUVjeFwapA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Jan 28, 2014 at 9:05 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > Well, I often use the hex numbers to look them up and disassemble them
> > in a vmlinux via gdb and 'list *0x1234123412341234' - where the
> > vmlinux has no debuginfo. (Debuginfo takes longer to build so I
> > generally build without it.)
> 
> Why the heck wouldn't you do that? Just do
> 
>    list schedule+0x45
> 
> instead.
> 
> > AFAICS this won't work in a symbol-less vmlinux. Is there some trick
> > to do it with gdb?
> 
> Why would you have a symbol-less vmlinux? The only reason to strip 
> vmlinux is because you were crazy enough to build with 

I don't think I ever stripped a vmlinux in my life, and I definitely 
didn't strip this one:

  phoenix:~/linux/linux> file vmlinux
  vmlinux: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), statically linked, BuildID[sha1]=0x239d56b40bb654ddd2dd704e6b585d5c90de4e12, not stripped

> CONFIG_DEBUG_INFO and the damn debug info is so large that it won't 
> fit on your root partition. But dammit, if you build with debug_info 
> and then strip the end result, you're just insane. [...]

So, to quote myself from 2 sentences ago:

> > vmlinux has no debuginfo. (Debuginfo takes longer to build so I 
> > generally build without it.)

I really meant it when I said I build without debuginfo! :)

So, when I build a kernel, such as with a regular 'make defconfig', 
the following happens in gdb:

  Reading symbols from /home/mingo/tip/vmlinux...(no debugging symbols found)...done.
  (gdb) list schedule+0x45
  No symbol table is loaded.  Use the "file" command.

Is there a way to resolve schedule+0x45 in a regular vmlinux? It was 
an honest question.

> [...] You made your build take ten times longer, use ten times more 
> diskspace, and then you throw it all away. Crazy.

It's so crazy that I in fact try to force off debuginfo for all my 
builds, even randconfig ones:

  config DEBUG_INFO
        bool "Compile the kernel with debug info"
        depends on DEBUG_KERNEL
        # too slow build in QA
        depends on 0

> So I don't think the symbol-less version is worth even worrying 
> about. You do want to build with KALLSYMS (or whatever the config 
> option is called), so that the symbolic name is worth something, but 
> once you have the symbolc name, you're good unless you did something 
> terminally stupid.

Hm, I have kallsyms on - it's a regular 'make defconfig':

  phoenix:~/linux/linux> grep KALL .config
  CONFIG_KALLSYMS=y

I might be doing something terminally stupid.

> Btw, we should make it harder to enable CONFIG_DEBUG_INFO. [...]

It's really not set:

  phoenix:~/linux/linux> grep DEBUG_INFO .config
  # CONFIG_DEBUG_INFO is not set

> [...] It's a f*cking pain. It's particularly nasty when you do "make 
> allmodconfig" and it enables debug-info and makes the build take 
> forever and waste diskspace - but nobody sane actually *boots* the 
> end result, so that debug info is all pointless.

I actually boot (almost-)allmod and allyesconfigs - still I disable 
DEBUG_INFO because it's such a strain on our planet's climate.

Thanks,

	Ingo
