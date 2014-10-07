Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038AbaJGSu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 14:50:27 -0400
Received: from mail-bn1on0062.outbound.protection.outlook.com ([157.56.110.62]:6824
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754242AbaJGSu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 14:50:26 -0400
Message-ID: <543435EA.7060406@caviumnetworks.com>
Date: Tue, 7 Oct 2014 11:50:18 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Leonid Yegoshin <Leonid.Yegoshin@imgtec.com>,
        Matthew Fortune <Matthew.Fortune@imgtec.com>,
        David Daney <david.s.daney@gmail.com>, Rich Felker <dalias@libc.org>,
        David Daney <ddaney.cavm@gmail.com>,
        "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH resend] MIPS: Allow FPU emulator to use non-stack area.
References: <1412627010-4311-1-git-send-email-ddaney.cavm@gmail.com> <20141006205459.GZ23797@brightrain.aerifal.cx> <5433071B.4050606@caviumnetworks.com> <20141006213101.GA23797@brightrain.aerifal.cx> <54330D79.80102@caviumnetworks.com> <20141006215813.GB23797@brightrain.aerifal.cx> <543327E7.4020608@amacapital.net> <54332A64.5020605@caviumnetworks.com> <20141007000514.GD23797@brightrain.aerifal.cx> <543334CE.8060305@caviumnetworks.com> <20141007004915.GF23797@brightrain.aerifal.cx> <54337127.40806@gmail.com> <6D39441BF12EF246A7ABCE6654B0235320F1E173@LEMAIL01.le.imgtec.org> <543431DA.4090809@imgtec.com> <CALCETrUQEbb=DotSzsneN7Hano_eC-EoTMko6uKcyZXvEcktkw@mail.gmail.com>
In-Reply-To: <CALCETrUQEbb=DotSzsneN7Hano_eC-EoTMko6uKcyZXvEcktkw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-ClientProxiedBy: BLUPR07CA097.namprd07.prod.outlook.com (25.160.24.52) To
 BY2PR07MB583.namprd07.prod.outlook.com (10.141.221.155)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR07MB583;
X-Forefront-PRVS: 035748864E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(51704005)(377454003)(479174003)(189002)(51444003)(164054003)(24454002)(65816999)(50986999)(23676002)(87266999)(81156004)(95666004)(54356999)(66066001)(99396003)(120916001)(76176999)(21056001)(87976001)(65806001)(64706001)(110136001)(47776003)(76482002)(20776003)(106356001)(85852003)(99136001)(105586002)(122386002)(36756003)(33656002)(80316001)(19580395003)(64126003)(92726001)(92566001)(107046002)(83506001)(101416001)(69596002)(102836001)(19580405001)(77096002)(4396001)(93886004)(31966008)(97736003)(42186005)(50466002)(85306004)(59896002)(80022003)(46102003)(53416004)(40100002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR07MB583;H:dl.caveonetworks.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2014 11:44 AM, Andy Lutomirski wrote:
> On Tue, Oct 7, 2014 at 11:32 AM, Leonid Yegoshin
> <Leonid.Yegoshin@imgtec.com> wrote:
>> Well, I am not a subscriber to mail-list, so I read it the first time and
>> some notes:
>>
>
>>
>> 3)  The signal happened during execution of emulated instruction - signals
>> are under control of kernel and we can easily delay a signal during
>> execution of emulated instruction until return from do_dsemulret. It is not
>> a big deal - nor code, nor performance. Thank you for good point.
>
> If you go down this particular rabbit hole, you will never come back out.
>
> What happens if one of those out-of-line instructions causes a
> synchronous trap?  What if SIGSTOP arrives before ret?  What if
> another thread removes the magic ret sequence?
>
>>
>> 4)  The voice for doing any instruction emulation in kernel - it is not a
>> MIPS business model to force customer to put details of all Coprocessor 2
>> instructions public. We provide an interface and the rest is a customer
>> business. Besides that it is really painful to make a differentiation
>> between Cavium Octeon and some another CPU instructions with the same
>> opcode. On other side, leaving emulation of their instructions to them is
>> not a wise after having some good way doing that multiple years.
>
> IMO this is all backwards.  If MIPS customers put proprietary
> instructions into their ISA, they leave out the FPU, and they put a
> proprietary insn in a branch delay slot, then I think that they
> deserve a fatal signal.
>
> There's a really easy solution for new systems: fix the toolchain.
> Teach the assembler to disallow any proprietary instructions in an FP
> branch delay slot.
>

Yes, gas for MIPS already has an instruction attribute for instructions 
that cannot be placed in delay slots.  It should be a fairly simple 
matter to extend this to instructions that cannot be emulated.

Thanks,
David Daney


> --Andy
>

