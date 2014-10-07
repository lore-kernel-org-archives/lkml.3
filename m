Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbaJGQJB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 12:09:01 -0400
Received: from mail-bn1bon0069.outbound.protection.outlook.com ([157.56.111.69]:39264
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754259AbaJGQJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 12:09:00 -0400
Message-ID: <54341013.2030509@caviumnetworks.com>
Date: Tue, 7 Oct 2014 09:08:51 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Rich Felker <dalias@libc.org>
CC: David Daney <david.s.daney@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        David Daney <ddaney.cavm@gmail.com>, <libc-alpha@sourceware.org>,
        <linux-kernel@vger.kernel.org>, <linux-mips@linux-mips.org>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH resend] MIPS: Allow FPU emulator to use non-stack area.
References: <5433071B.4050606@caviumnetworks.com> <20141006213101.GA23797@brightrain.aerifal.cx> <54330D79.80102@caviumnetworks.com> <20141006215813.GB23797@brightrain.aerifal.cx> <543327E7.4020608@amacapital.net> <54332A64.5020605@caviumnetworks.com> <20141007000514.GD23797@brightrain.aerifal.cx> <543334CE.8060305@caviumnetworks.com> <20141007004915.GF23797@brightrain.aerifal.cx> <54337127.40806@gmail.com> <20141007111102.GH23797@brightrain.aerifal.cx>
In-Reply-To: <20141007111102.GH23797@brightrain.aerifal.cx>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-ClientProxiedBy: BLUPR07CA083.namprd07.prod.outlook.com (25.160.24.38) To
 CO2PR07MB588.namprd07.prod.outlook.com (10.141.229.153)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CO2PR07MB588;
X-Forefront-PRVS: 035748864E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(479174003)(377454003)(51704005)(199003)(24454002)(189002)(69596002)(54356999)(50986999)(110136001)(87976001)(120916001)(21056001)(117636001)(101416001)(36756003)(76482002)(83506001)(99396003)(59896002)(122386002)(85852003)(87266999)(46102003)(102836001)(93886004)(4396001)(80022003)(64126003)(95666004)(106356001)(107046002)(81156004)(50466002)(105586002)(99136001)(92566001)(77096002)(85306004)(76176999)(66066001)(47776003)(65806001)(97736003)(20776003)(92726001)(64706001)(42186005)(31966008)(65816999)(23756003)(53416004)(40100002)(62816006);DIR:OUT;SFP:1101;SCL:1;SRVR:CO2PR07MB588;H:dl.caveonetworks.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2014 04:11 AM, Rich Felker wrote:
> On Mon, Oct 06, 2014 at 09:50:47PM -0700, David Daney wrote:
>>>> the out-of-line execution trick, but do it somewhere other than in
>>>> stack memory.
>>> How do you answer Andy Lutomirski's question about what happens when a
>>> signal handler interrupts execution while the program counter is
>>> pointing at this "out-of-line execution" trampoline? This seems like a
>>> show-stopper for using anything other than the stack.
>> It would be nice to support, but not doing so would not be a
>> regression from current behavior.
>
> It's not just "nice" to support, it's mandatory. Otherwise you will
> execute essentially *random instructions* in this case, providing a
> very nice attack vector that can almost certainly be elevated to
> arbitrary code execution via timing of signals during floating point
> code.
>
> The current behavior in regards to this is correct: because you have a
> *stack*, each trampoline is pushed onto the stack in its own context,
> and popped when it's no longer needed. You can have arbitrarily many
> such trampolines up to the stack size. Note that each nested signal
> handler already requires sizeof(ucontext_t) in stack space, so these
> trampolines are a negligible additional cost without major effects on
> the number of signal handlers you can nest without overflowing the
> stack.

Yes, the stack takes care of the allocations, but the current 
implementation has many problems:

1) Signals clobber the emulation area.
2) Signals caused by the emulation, have incorrect saved machine state.

We have a low bar to pass, any new solution doesn't have to be perfect, 
it only has to be an improvement.

Keep in mind that we are not starting from a clean slate, there are many 
years of legacy code that has built up here.

David Daney
