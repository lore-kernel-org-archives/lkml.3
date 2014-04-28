Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbaD1XGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 19:06:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52653 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088AbaD1XGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 19:06:54 -0400
Message-ID: <535EDEC5.7030209@zytor.com>
Date: Mon, 28 Apr 2014 16:05:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andrew Lutomirski <amluto@gmail.com>, comex <comexk@gmail.com>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Borislav Petkov <bp@alien8.de>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Brian Gerst <brgerst@gmail.com>,
        Alexandre Julliard <julliard@winehq.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <1398120472-6190-1-git-send-email-hpa@linux.intel.com> <CAPM5UJ1DYxhGASFVTg_2eUDpg1-whe-26mJ9BD+PB=4FM+540g@mail.gmail.com> <CAObL_7G06PYn=8LGQT69-qhvyWFm_mJYMkbsuwem0PeiLRe0HQ@mail.gmail.com>
In-Reply-To: <CAObL_7G06PYn=8LGQT69-qhvyWFm_mJYMkbsuwem0PeiLRe0HQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2014 09:53 PM, Andrew Lutomirski wrote:
> 
> This particular vector hurts: you can safely keep trying until it works.
> 
> This just gave me an evil idea: what if we make the whole espfix area
> read-only?  This has some weird effects.  To switch to the espfix
> stack, you have to write to an alias.  That's a little strange but
> harmless and barely complicates the implementation.  If the iret
> faults, though, I think the result will be a #DF.  This may actually
> be a good thing: if the #DF handler detects that the cause was a bad
> espfix iret, it could just return directly to bad_iret or send the
> signal itself the same way that do_stack_segment does.  This could
> even be written in C :)
> 
> Peter, is this idea completely nuts?  The only exceptions that can
> happen there are NMI, MCE, #DB, #SS, and #GP.  The first four use IST,
> so they won't double-fault.
> 

So I tried writing this bit up, but it fails in some rather spectacular
ways.  Furthermore, I have been unable to debug it under Qemu, because
breakpoints don't work right (common Qemu problem, sadly.)

The kernel code is at:

https://git.kernel.org/cgit/linux/kernel/git/hpa/espfix64.git/

There are two tests:

git://git.zytor.com/users/hpa/test16/test16.git, build it, and run
./run16 test/hello.elf
http://www.zytor.com/~hpa/ldttest.c

The former will exercise the irq_return_ldt path, but not the fault
path; the latter will exercise the fault path, but doesn't actually use
a 16-bit segment.

Under the 3.14 stock kernel, the former should die with SIGBUS and the
latter should pass.

	-hpa

