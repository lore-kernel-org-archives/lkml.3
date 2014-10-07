Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbaJGAco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 20:32:44 -0400
Received: from mail-bn1on0055.outbound.protection.outlook.com ([157.56.110.55]:44970
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751290AbaJGAcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 20:32:43 -0400
Message-ID: <543334A2.3060203@caviumnetworks.com>
Date: Mon, 6 Oct 2014 17:32:34 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Andrew Pinski <pinskia@gmail.com>, Rich Felker <dalias@libc.org>,
        David Daney <ddaney.cavm@gmail.com>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH resend] MIPS: Allow FPU emulator to use non-stack area.
References: <1412627010-4311-1-git-send-email-ddaney.cavm@gmail.com> <20141006205459.GZ23797@brightrain.aerifal.cx> <5433071B.4050606@caviumnetworks.com> <20141006213101.GA23797@brightrain.aerifal.cx> <54330D79.80102@caviumnetworks.com> <20141006215813.GB23797@brightrain.aerifal.cx> <543327E7.4020608@amacapital.net> <54332A64.5020605@caviumnetworks.com> <20141007000514.GD23797@brightrain.aerifal.cx> <CA+=Sn1nR2ugXUf=V9F9O6VLAP1d6WhBDioZzu0G05-8z6KMMuA@mail.gmail.com> <20141007002147.GE23797@brightrain.aerifal.cx> <CA+=Sn1n_S-JT1pZwMtDGM+Vkbp7rsg4bPAeESwJpSkbx8vqn5g@mail.gmail.com> <CALCETrXz+rYB0JxuXLPZroWCsqHqajfemiG1ohS7o33QebwQkA@mail.gmail.com>
In-Reply-To: <CALCETrXz+rYB0JxuXLPZroWCsqHqajfemiG1ohS7o33QebwQkA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-ClientProxiedBy: BLUPR07CA078.namprd07.prod.outlook.com (25.160.24.33) To
 DM2PR07MB591.namprd07.prod.outlook.com (10.141.176.142)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR07MB591;
X-Forefront-PRVS: 035748864E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(479174003)(377454003)(24454002)(199003)(51704005)(66066001)(20776003)(47776003)(81156004)(107046002)(21056001)(85852003)(65956001)(99136001)(65816999)(76176999)(92726001)(92566001)(50466002)(97736003)(87976001)(4396001)(31966008)(110136001)(40100002)(102836001)(106356001)(65806001)(105586002)(23676002)(69596002)(80022003)(87266999)(95666004)(50986999)(101416001)(83506001)(120916001)(19580395003)(42186005)(19580405001)(80316001)(33656002)(93886004)(85306004)(36756003)(99396003)(10300001)(54356999)(76482002)(77096002)(46102003)(122386002)(53416004);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR07MB591;H:dl.caveonetworks.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2014 05:29 PM, Andy Lutomirski wrote:
> On Mon, Oct 6, 2014 at 5:28 PM, Andrew Pinski <pinskia@gmail.com> wrote:
>> On Mon, Oct 6, 2014 at 5:21 PM, Rich Felker <dalias@libc.org> wrote:
>>> On Mon, Oct 06, 2014 at 05:11:38PM -0700, Andrew Pinski wrote:
>>>> On Mon, Oct 6, 2014 at 5:05 PM, Rich Felker <dalias@libc.org> wrote:
>>>>> On Mon, Oct 06, 2014 at 04:48:52PM -0700, David Daney wrote:
>>>>>> On 10/06/2014 04:38 PM, Andy Lutomirski wrote:
>>>>>>> On 10/06/2014 02:58 PM, Rich Felker wrote:
>>>>>>>> On Mon, Oct 06, 2014 at 02:45:29PM -0700, David Daney wrote:
>>>>>> [...]
>>>>>>>> This is a huge ill-designed mess.
>>>>>>>
>>>>>>> Amen.
>>>>>>>
>>>>>>> Can the kernel not just emulate the instructions directly?
>>>>>>
>>>>>> In theory it could, but since there can be implementation defined
>>>>>> instructions, there is no way to achieve full instruction set
>>>>>> coverage for all possible machines.
>>>>>
>>>>> Is the issue really implementation-defined instructions with delay
>>>>> slots? If so it sounds like a made-up issue. They're not going to
>>>>> occur in real binaries. Certainly a compiler is not going to generate
>>>>> implementation-defined instructions, and if you're writing the asm by
>>>>> hand, you just don't put floating point instructions in the delay
>>>>> slot.
>>>>
>>>> It is not the instruction with delay slot but rather the instruction
>>>> in the delay slot itself.
>>>
>>> An instruction in the delay slot for the instruction being emulated?
>>> How would that arise? Are there floating point instructions with delay
>>> slots?
>>
>> Yes branches.
>
> I admit I have no idea what's going here, but I find it hard to
> believe that having the kernel fix this up for new code is desirable.
> Unless MIPS can round-trip a trap *very* quickly, performance will be
> awful for any code that has this problem.
>

It is FPU *emulation*, of course the performance will suck.  We don't 
care about performance, we just want it to execute correctly.

David Daney

