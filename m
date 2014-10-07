Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbaJGAd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 20:33:27 -0400
Received: from mail-bl2on0081.outbound.protection.outlook.com ([65.55.169.81]:61436
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752338AbaJGAd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 20:33:26 -0400
X-Greylist: delayed 10070 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Oct 2014 20:33:26 EDT
Message-ID: <543334CE.8060305@caviumnetworks.com>
Date: Mon, 6 Oct 2014 17:33:18 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Rich Felker <dalias@libc.org>
CC: Andy Lutomirski <luto@amacapital.net>, David Daney <ddaney.cavm@gmail.com>,
        <libc-alpha@sourceware.org>, <linux-kernel@vger.kernel.org>,
        <linux-mips@linux-mips.org>, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH resend] MIPS: Allow FPU emulator to use non-stack area.
References: <1412627010-4311-1-git-send-email-ddaney.cavm@gmail.com> <20141006205459.GZ23797@brightrain.aerifal.cx> <5433071B.4050606@caviumnetworks.com> <20141006213101.GA23797@brightrain.aerifal.cx> <54330D79.80102@caviumnetworks.com> <20141006215813.GB23797@brightrain.aerifal.cx> <543327E7.4020608@amacapital.net> <54332A64.5020605@caviumnetworks.com> <20141007000514.GD23797@brightrain.aerifal.cx>
In-Reply-To: <20141007000514.GD23797@brightrain.aerifal.cx>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-ClientProxiedBy: BLUPR07CA062.namprd07.prod.outlook.com (25.160.24.17) To
 BLUPR07MB578.namprd07.prod.outlook.com (10.141.206.17)
X-Microsoft-Antispam: UriScan:;UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR07MB578;
X-Forefront-PRVS: 035748864E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(24454002)(377454003)(479174003)(51704005)(77096002)(76482002)(99136001)(99396003)(122386002)(120916001)(102836001)(50986999)(87976001)(36756003)(105586002)(80316001)(69596002)(95666004)(106356001)(40100002)(81156004)(31966008)(83506001)(50466002)(87266999)(85852003)(10300001)(65816999)(76176999)(54356999)(92726001)(33656002)(4396001)(97736003)(93886004)(23756003)(110136001)(65956001)(85306004)(80022003)(92566001)(46102003)(65806001)(53416004)(20776003)(101416001)(42186005)(47776003)(66066001)(107046002)(21056001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR07MB578;H:dl.caveonetworks.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR07MB563;
X-OriginatorOrg: caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2014 05:05 PM, Rich Felker wrote:
> On Mon, Oct 06, 2014 at 04:48:52PM -0700, David Daney wrote:
>> On 10/06/2014 04:38 PM, Andy Lutomirski wrote:
>>> On 10/06/2014 02:58 PM, Rich Felker wrote:
>>>> On Mon, Oct 06, 2014 at 02:45:29PM -0700, David Daney wrote:
>> [...]
>>>> This is a huge ill-designed mess.
>>>
>>> Amen.
>>>
>>> Can the kernel not just emulate the instructions directly?
>>
>> In theory it could, but since there can be implementation defined
>> instructions, there is no way to achieve full instruction set
>> coverage for all possible machines.
>
> Is the issue really implementation-defined instructions with delay
> slots?

It is the instructions in the delay slots, not the branch instructions 
themselves that are of interest.  But, for the sake of the arguments, 
this is not a critical point.

> If so it sounds like a made-up issue.

It is not a made up issue.

If you want an architecture that has a well defined instruction set, 
stick with x86, Intel will tell you what is good for you and you will 
take whatever they give you.

If you want an architecture where you can add implementation defined 
instructions to do whatever you want, then you use an architecture like 
MIPS.

> They're not going to
> occur in real binaries. Certainly a compiler is not going to generate
> implementation-defined instructions,

Why not?  It will emit any instructions we care to make it emit.  If we 
want it to emit crypto instructions with patented algorithms, then it 
will do that.  But we would still like to use a generic kernel with 
generic FPU support.

The most straight forward way (and the currently implemented way) of 
doing this is to execute the instructions in question out-of-line (on 
the userspace stack).

The question here is:  What is the best way to get to a non-executable 
stack.

The consensus among MIPS developers is that we should continue using the 
out-of-line execution trick, but do it somewhere other than in stack memory.

One way of doing this is to have the kernel magically generate thread 
local memory regions.

Another option is to have userspace manage the out-of-line execution areas.

As is often the case, each approach has different pluses and minuses.


