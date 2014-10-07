Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbaJGSo6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 14:44:58 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:44031 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242AbaJGSo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 14:44:57 -0400
MIME-Version: 1.0
In-Reply-To: <543431DA.4090809@imgtec.com>
References: <1412627010-4311-1-git-send-email-ddaney.cavm@gmail.com>
 <20141006205459.GZ23797@brightrain.aerifal.cx> <5433071B.4050606@caviumnetworks.com>
 <20141006213101.GA23797@brightrain.aerifal.cx> <54330D79.80102@caviumnetworks.com>
 <20141006215813.GB23797@brightrain.aerifal.cx> <543327E7.4020608@amacapital.net>
 <54332A64.5020605@caviumnetworks.com> <20141007000514.GD23797@brightrain.aerifal.cx>
 <543334CE.8060305@caviumnetworks.com> <20141007004915.GF23797@brightrain.aerifal.cx>
 <54337127.40806@gmail.com> <6D39441BF12EF246A7ABCE6654B0235320F1E173@LEMAIL01.le.imgtec.org>
 <543431DA.4090809@imgtec.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 7 Oct 2014 11:44:35 -0700
Message-ID: <CALCETrUQEbb=DotSzsneN7Hano_eC-EoTMko6uKcyZXvEcktkw@mail.gmail.com>
Subject: Re: [PATCH resend] MIPS: Allow FPU emulator to use non-stack area.
To: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
Cc: Matthew Fortune <Matthew.Fortune@imgtec.com>,
        David Daney <david.s.daney@gmail.com>, Rich Felker <dalias@libc.org>,
        David Daney <ddaney@caviumnetworks.com>,
        David Daney <ddaney.cavm@gmail.com>,
        "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        David Daney <david.daney@cavium.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 7, 2014 at 11:32 AM, Leonid Yegoshin
<Leonid.Yegoshin@imgtec.com> wrote:
> Well, I am not a subscriber to mail-list, so I read it the first time and
> some notes:
>

>
> 3)  The signal happened during execution of emulated instruction - signals
> are under control of kernel and we can easily delay a signal during
> execution of emulated instruction until return from do_dsemulret. It is not
> a big deal - nor code, nor performance. Thank you for good point.

If you go down this particular rabbit hole, you will never come back out.

What happens if one of those out-of-line instructions causes a
synchronous trap?  What if SIGSTOP arrives before ret?  What if
another thread removes the magic ret sequence?

>
> 4)  The voice for doing any instruction emulation in kernel - it is not a
> MIPS business model to force customer to put details of all Coprocessor 2
> instructions public. We provide an interface and the rest is a customer
> business. Besides that it is really painful to make a differentiation
> between Cavium Octeon and some another CPU instructions with the same
> opcode. On other side, leaving emulation of their instructions to them is
> not a wise after having some good way doing that multiple years.

IMO this is all backwards.  If MIPS customers put proprietary
instructions into their ISA, they leave out the FPU, and they put a
proprietary insn in a branch delay slot, then I think that they
deserve a fatal signal.

There's a really easy solution for new systems: fix the toolchain.
Teach the assembler to disallow any proprietary instructions in an FP
branch delay slot.

--Andy
