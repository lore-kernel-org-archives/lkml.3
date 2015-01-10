Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbbAJUn7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 15:43:59 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:65453 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbbAJUn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 15:43:58 -0500
MIME-Version: 1.0
In-Reply-To: <CALCETrXS7BvtS3P3J8hnbt3GGvezx-935uxanSN_a=CU6s1d3g@mail.gmail.com>
References: <1420734315-30943-1-git-send-email-dvlasenk@redhat.com>
 <1420734315-30943-4-git-send-email-dvlasenk@redhat.com> <20150109121950.GD13637@pd.tnic>
 <CAK1hOcMsGJ7geRAzfazPLZitcO0o9XYRPJDYa8sJHR4i6DPL-g@mail.gmail.com>
 <20150110142336.GC12218@pd.tnic> <CAK1hOcO7K=4N8CF=LOPmosXRNnogaNi5vLDPMdb0XiKsL=JOfg@mail.gmail.com>
 <CALCETrXS7BvtS3P3J8hnbt3GGvezx-935uxanSN_a=CU6s1d3g@mail.gmail.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Sat, 10 Jan 2015 21:43:37 +0100
Message-ID: <CAK1hOcNeAytfd=tMSeCXV+FDnf16qb6wfO5=n94z3jnEFk=JKQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] x86: open-code register save/restore in
 trace_hardirqs thunks
To: Andy Lutomirski <luto@amacapital.net>
Cc: Borislav Petkov <bp@alien8.de>, Denys Vlasenko <dvlasenk@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 10, 2015 at 9:17 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> After I've seen the disassembly I myself posted, I can't help but wonder
>> why we use 5-byte instructions to store and load regs on stack when
>> pushes and pops are 1 or 2-byte long.
>
> I asked this once, and someone told me that push/pop has lower
> throughput.  I find this surprising.

Theoretically yes.
In practice, AMD K7 and K8 seem to be able to execute two movq's
in one cycle, but only one push.

For all other processors I looked at, they have the same throughput:
K10 can do two movq's in one cycle, but also two push'es.
Bulldozer...Steamroller: can do one insn per cycle.
Bobcat..Jaguar: can do one insn per cycle.
Core 2: can do one insn per cycle.
Nehalem: can do one insn per cycle.

The above was microbenchmarked with long sequences
of similar instructions, in which case store unit gets saturated
and becomes a bottleneck.

Here's the document.

http://www.agner.org/optimize/instruction_tables.pdf
