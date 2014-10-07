Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbaJGSeQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 14:34:16 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:12970 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697AbaJGSeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 14:34:15 -0400
Message-ID: <543431DA.4090809@imgtec.com>
Date: Tue, 7 Oct 2014 11:32:58 -0700
From: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Matthew Fortune <Matthew.Fortune@imgtec.com>
CC: David Daney <david.s.daney@gmail.com>, Rich Felker <dalias@libc.org>,
        David Daney <ddaney@caviumnetworks.com>,
        Andy Lutomirski <luto@amacapital.net>,
        David Daney <ddaney.cavm@gmail.com>,
        "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH resend] MIPS: Allow FPU emulator to use non-stack area.
References: <1412627010-4311-1-git-send-email-ddaney.cavm@gmail.com> <20141006205459.GZ23797@brightrain.aerifal.cx> <5433071B.4050606@caviumnetworks.com> <20141006213101.GA23797@brightrain.aerifal.cx> <54330D79.80102@caviumnetworks.com> <20141006215813.GB23797@brightrain.aerifal.cx> <543327E7.4020608@amacapital.net> <54332A64.5020605@caviumnetworks.com> <20141007000514.GD23797@brightrain.aerifal.cx> <543334CE.8060305@caviumnetworks.com> <20141007004915.GF23797@brightrain.aerifal.cx> <54337127.40806@gmail.com> <6D39441BF12EF246A7ABCE6654B0235320F1E173@LEMAIL01.le.imgtec.org>
In-Reply-To: <6D39441BF12EF246A7ABCE6654B0235320F1E173@LEMAIL01.le.imgtec.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.65.146]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, I am not a subscriber to mail-list, so I read it the first time 
and some notes:

1)  David's approach would likely work for FPU emulation but unlikely 
works for MIPS Rel 2/Rel 1/ MIPS I emulation in MIPS R6 architecture. 
The reason is that the first MIPS R2 instruction (removed from MIPS R6) 
can be hit long before GLIBC/bionic/etc can determine how to use 
properly a new system call. And that instruction needs to be emulated. I 
actually hit this problem with ssh-keygen first and referred to  FPU 
emulation because I got it later, during my attempt to salvage a situation.

2)  The issue of uMIPS ADDIUPC and similar instructions are overblown in 
my opinion. Never of them are memory-related and their emulation in 
BD-slot can be easily done in kernel and that actually accelerates an 
emulation. Look at piece of code which I wrote to accelerate an 
emulation of some instructions in BD-slot of JR instruction:

         switch (MIPSInst_OPCODE(ir)) {
         case addiu_op:
                 if (MIPSInst_RT(ir))
                         regs->regs[MIPSInst_RT(ir)] =
(s32)regs->regs[MIPSInst_RS(ir)] +
                                 (s32)MIPSInst_SIMM(ir);
                 return(0);
#ifdef CONFIG_64BIT
         case daddiu_op:
                 if (MIPSInst_RT(ir))
                         regs->regs[MIPSInst_RT(ir)] =
(s64)regs->regs[MIPSInst_RS(ir)] +
(s64)MIPSInst_SIMM(ir);
return(0);
#endif

Five lines per instruction.

3)  The signal happened during execution of emulated instruction - 
signals are under control of kernel and we can easily delay a signal 
during execution of emulated instruction until return from do_dsemulret. 
It is not a big deal - nor code, nor performance. Thank you for good point.

4)  The voice for doing any instruction emulation in kernel - it is not 
a MIPS business model to force customer to put details of all 
Coprocessor 2 instructions public. We provide an interface and the rest 
is a customer business. Besides that it is really painful to make a 
differentiation between Cavium Octeon and some another CPU instructions 
with the same opcode. On other side, leaving emulation of their 
instructions to them is not a wise after having some good way doing that 
multiple years.

- Leonid.

