Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011AbaJGSnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 14:43:22 -0400
Received: from mail-bn1bon0078.outbound.protection.outlook.com ([157.56.111.78]:5808
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754905AbaJGSnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 14:43:20 -0400
Message-ID: <5434343E.2090308@caviumnetworks.com>
Date: Tue, 7 Oct 2014 11:43:10 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>
CC: Matthew Fortune <Matthew.Fortune@imgtec.com>,
        David Daney <david.s.daney@gmail.com>, Rich Felker <dalias@libc.org>,
        Andy Lutomirski <luto@amacapital.net>,
        David Daney <ddaney.cavm@gmail.com>,
        "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH resend] MIPS: Allow FPU emulator to use non-stack area.
References: <1412627010-4311-1-git-send-email-ddaney.cavm@gmail.com> <20141006205459.GZ23797@brightrain.aerifal.cx> <5433071B.4050606@caviumnetworks.com> <20141006213101.GA23797@brightrain.aerifal.cx> <54330D79.80102@caviumnetworks.com> <20141006215813.GB23797@brightrain.aerifal.cx> <543327E7.4020608@amacapital.net> <54332A64.5020605@caviumnetworks.com> <20141007000514.GD23797@brightrain.aerifal.cx> <543334CE.8060305@caviumnetworks.com> <20141007004915.GF23797@brightrain.aerifal.cx> <54337127.40806@gmail.com> <6D39441BF12EF246A7ABCE6654B0235320F1E173@LEMAIL01.le.imgtec.org> <543431DA.4090809@imgtec.com>
In-Reply-To: <543431DA.4090809@imgtec.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-ClientProxiedBy: SN2PR07CA005.namprd07.prod.outlook.com (10.255.174.22) To
 CO2PR07MB587.namprd07.prod.outlook.com (10.141.229.150)
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO2PR07MB587;
X-Forefront-PRVS: 035748864E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(51704005)(479174003)(199003)(377454003)(24454002)(189002)(101416001)(99136001)(110136001)(120916001)(80316001)(54356999)(31966008)(69596002)(64706001)(36756003)(50986999)(47776003)(20776003)(99396003)(92566001)(122386002)(106356001)(66066001)(33656002)(92726001)(102836001)(81156004)(42186005)(59896002)(65806001)(87976001)(77096002)(64126003)(23756003)(50466002)(65816999)(21056001)(97736003)(85852003)(85306004)(76176999)(107046002)(80022003)(87266999)(93886004)(53416004)(46102003)(83506001)(105586002)(95666004)(76482002)(4396001)(40100002);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR07MB587;H:dl.caveonetworks.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO2PR07MB667;
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2014 11:32 AM, Leonid Yegoshin wrote:
> Well, I am not a subscriber to mail-list, so I read it the first time
> and some notes:
>
> 1)  David's approach would likely work for FPU emulation but unlikely
> works for MIPS Rel 2/Rel 1/ MIPS I emulation in MIPS R6 architecture.
> The reason is that the first MIPS R2 instruction (removed from MIPS R6)
> can be hit long before GLIBC/bionic/etc can determine how to use
> properly a new system call. And that instruction needs to be emulated. I
> actually hit this problem with ssh-keygen first and referred to  FPU
> emulation because I got it later, during my attempt to salvage a situation.
>
> 2)  The issue of uMIPS ADDIUPC and similar instructions are overblown in
> my opinion. Never of them are memory-related and their emulation in
> BD-slot can be easily done in kernel and that actually accelerates an
> emulation. Look at piece of code which I wrote to accelerate an
> emulation of some instructions in BD-slot of JR instruction:
>
>          switch (MIPSInst_OPCODE(ir)) {
>          case addiu_op:
>                  if (MIPSInst_RT(ir))
>                          regs->regs[MIPSInst_RT(ir)] =
> (s32)regs->regs[MIPSInst_RS(ir)] +
>                                  (s32)MIPSInst_SIMM(ir);
>                  return(0);
> #ifdef CONFIG_64BIT
>          case daddiu_op:
>                  if (MIPSInst_RT(ir))
>                          regs->regs[MIPSInst_RT(ir)] =
> (s64)regs->regs[MIPSInst_RS(ir)] +
> (s64)MIPSInst_SIMM(ir);
> return(0);
> #endif
>
> Five lines per instruction.

But you must be able to emulate them, so you need an emulator, not XOL.

>
> 3)  The signal happened during execution of emulated instruction -
> signals are under control of kernel and we can easily delay a signal
> during execution of emulated instruction until return from do_dsemulret.
> It is not a big deal - nor code, nor performance. Thank you for good point.
>

The problem is what to do with synchronous signals (SIGSEGV)  Those 
cannot be held off, and you really want the EPC value saved in the 
register state to be correct.

> 4)  The voice for doing any instruction emulation in kernel - it is not
> a MIPS business model to force customer to put details of all
> Coprocessor 2 instructions public. We provide an interface and the rest
> is a customer business. Besides that it is really painful to make a
> differentiation between Cavium Octeon and some another CPU instructions
> with the same opcode. On other side, leaving emulation of their
> instructions to them is not a wise after having some good way doing that
> multiple years.
>

With all the new information we have begun to understand, it seems like 
the only sane thing to do is get rid of this XOL approach and go to full 
emulation of the entire instruction set.

David Daney

