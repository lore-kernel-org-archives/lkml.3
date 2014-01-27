Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbaA0WnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 17:43:17 -0500
Received: from mail-ve0-f179.google.com ([209.85.128.179]:54725 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbaA0WnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 17:43:15 -0500
MIME-Version: 1.0
In-Reply-To: <20140127223257.GE10323@ZenIV.linux.org.uk>
References: <CA+55aFzNxTtvNX7zqBELHs489e5mEx1sM=i=red=aQAGviXrNw@mail.gmail.com>
	<20140127002255.GA10323@ZenIV.linux.org.uk>
	<CA+55aFzCtJ5gfw__3A=zkjJdv9Ag2CAmtHG5MnrRnCZYqz7EQA@mail.gmail.com>
	<20140127074208.GB10323@ZenIV.linux.org.uk>
	<52E6D866.604@amacapital.net>
	<CA+55aFzWRjNC4kPeVad3isOOW+vZhnzX0Gk5_8QzD16GZEw5Kg@mail.gmail.com>
	<20140127223257.GE10323@ZenIV.linux.org.uk>
Date: Mon, 27 Jan 2014 14:43:14 -0800
X-Google-Sender-Auth: w5c2QGuQPVU0RGPTgvv3Y4_FmEo
Message-ID: <CA+55aFyajjkCtRiTOS2AbFOWi7qt2FUnW6T3iG9nXqoZ0O9Ljg@mail.gmail.com>
Subject: Re: [RFC] de-asmify the x86-64 system call slowpath
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@amacapital.net>, Peter Anvin <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 2:32 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> do_signal() is also a place where arbitrary changes to regs might've
> been done by tracer, so regs->cs might need to be checked in the same
> place where we validate regs->rip ;-/

Fair enough. But it would still be really easy, and make the common
case signal delivery a bit faster.

Now, sadly, most signal delivery is then followed by sigreturn (the
exceptions being dying or doing a longjmp), so we'd still get the
iretq then. But it would cut the iretq's related to signals in half.

We *could* try to do sigreturn with sysret and a small trampoline too,
of course. But I'm not sure how far I'd want to take it.

               Linus
