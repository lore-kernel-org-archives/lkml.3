Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760703Ab3EBQpL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 12:45:11 -0400
Received: from mail-vb0-f43.google.com ([209.85.212.43]:52640 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760657Ab3EBQpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 12:45:09 -0400
MIME-Version: 1.0
In-Reply-To: <20130502145809.GA16236@linux-mips.org>
References: <20522420.158691367384219315.JavaMail.weblogic@epml17>
	<CAOiHx=mBPHmDse4EwL-+Fgmpz0=XhcgF_0nWdyvErFO4NU7E0Q@mail.gmail.com>
	<alpine.LFD.2.02.1305021241040.3972@ionos>
	<CAOiHx=mA-htk_2daeE9WpbEVV9YLvfLc1NYZZR=JeDdibchCnw@mail.gmail.com>
	<alpine.LFD.2.02.1305021527010.3972@ionos>
	<20130502145809.GA16236@linux-mips.org>
Date: Thu, 2 May 2013 09:45:08 -0700
X-Google-Sender-Auth: Dy7Ks3KjiA-TAD5jlGa8KOJtMrk
Message-ID: <CA+55aFwDGyHOzu=Qh7SJOBK6QvAwAh7pMDL6LfMUE=AW_kapAw@mail.gmail.com>
Subject: Re: [PATCH] MIPS: Enable interrupts in arch_cpu_idle()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jonas Gorski <jogo@openwrt.org>,
        eunb.song@samsung.com,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 2, 2013 at 7:58 AM, Ralf Baechle <ralf@linux-mips.org> wrote:
>
> For a while we just used to live with the race condition resulting from
> not disabling interrupts in the idle loop.  Then c65a5480 fixed this by
> checking if we're returning to the WAIT instruction in the idle loop
> when returning from an interrupt and iff so, rolling back the
> program counter to point to the if (test_thread_flag(TIF_NEED_RESCHED))
> test at the beginning of rollback_r4k_wait.

Umm. That sounds buggy. What if there was an interrupt *between* the
two places, not right at the wait instruction?

It seriously sounds like MIPS should do this by enabling interrupts in
the *assembly* code immediately preceding the wait instruction. IOW,
you'd effectively have the same kind of "sti; halt" kind of sequence
that x86 has. Not "enable interrupts" + C compiler puts random
instructions here + "wait".

                       Linus
