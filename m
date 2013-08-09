Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030848Ab3HITZX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 15:25:23 -0400
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:13772
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030789Ab3HITZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 15:25:19 -0400
Message-ID: <52054208.4040201@caviumnetworks.com>
Date: Fri, 9 Aug 2013 12:24:56 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Gilad Ben-Yossef <gilad@benyossef.com>
CC: Christoph Lameter <cl@gentwo.org>, David Daney <ddaney.cavm@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, Chris Metcalf <cmetcalf@tilera.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] smp.c: Quit unconditionally enabling irqs in on_each_cpu_mask().
References: <1375986342-22999-1-git-send-email-ddaney.cavm@gmail.com> <000001405f6459b8-32fb5ffe-837b-41be-bec4-c9c05fd4f114-000000@email.amazonses.com> <5203FF48.7000903@caviumnetworks.com> <CAOtvUMcR2Hx2jMy6Y0QQv5h7dM2a5fAC_M7BpgnaLa0VUieEHg@mail.gmail.com>
In-Reply-To: <CAOtvUMcR2Hx2jMy6Y0QQv5h7dM2a5fAC_M7BpgnaLa0VUieEHg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.2.3.195]
X-Forefront-PRVS: 0933E9FD8D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(199002)(189002)(377454003)(479174003)(24454002)(51704005)(81342001)(23756003)(81542001)(66066001)(4396001)(19580395003)(50986001)(83322001)(74706001)(53416003)(74876001)(19580405001)(80976001)(50466002)(49866001)(47736001)(47976001)(65956001)(69226001)(74366001)(80022001)(65806001)(46102001)(54356001)(77982001)(63696002)(83072001)(51856001)(56816003)(64126003)(31966008)(74662001)(79102001)(81686001)(74502001)(47446002)(76786001)(59896001)(59766001)(36756003)(53806001)(76482001)(76796001)(56776001)(47776003)(16406001)(77096001)(54316002)(62816003);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR07MB113;H:BY2PRD0712HT002.namprd07.prod.outlook.com;CLIP:64.2.3.195;RD:InfoNoRecords;A:1;MX:1;LANG:en;
X-OriginatorOrg: DuplicateDomain-a3ec847f-e37f-4d9a-9900-9d9d96f75f58.caviumnetworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2013 11:51 AM, Gilad Ben-Yossef wrote:
> On Thu, Aug 8, 2013 at 11:27 PM, David Daney <ddaney@caviumnetworks.com> wrote:
>>
>> On 08/08/2013 12:25 PM, Christoph Lameter wrote:
>>>
>>> On Thu, 8 Aug 2013, David Daney wrote:
>>>
>>>> I don't know of any bugs currently caused by this unconditional
>>>> local_irq_enable(), but I want to use this function in MIPS/OCTEON
>>>> early boot (when we have early_boot_irqs_disabled).  This also makes
>>>> this function have similar semantics to on_each_cpu() which is good in
>>>> itself.
>>>
>>>
>>> smp_call_function_many() wants interrupts enabled.
>>
>>
>> That's what the comments say, but it isn't actually true.
>>
>> The usage introduced by the patch is no different than the existing usage in on_each_cpu() 30 line up in the file.
>>
>
> Regardless of the question of how smp_call_function_many() should be
> called, the IRQ disable/enable pair is actually there to make sure the
> provided function runs on the current CPU at the same conditions as it
> would get called via the IPI.

Yes, I am aware of that.

You will notice that my patch doesn't change in any way the state of the 
system while running the provided function, irqs are still disabled, 
just as they are in the current implementation.

>
> I would at least consider putting a test there to make sure IRQs
> really are disabled when entering the function,

I think this may be a false predicate.  on_each_cpu_mask() is usually 
called with IRQs enabled...

> otherwise the bugs
> stemming from incorrect use can be tricky to catch.
>

... all my patch does is allow on_each_cpu_mask() to be called with IRQs 
disabled if we are in Early Boot.  This is already the case with 
smp_call_function(), smp_call_function_many() and on_each_cpu().  I am 
arguing that for the sake of consistency and the principle that function 
behavior shouldn't be surprising, that we make on_each_cpu_mask() work 
the same way.

Any required preconditions on the state of the system when calling 
on_each_cpu_mask() are already verified as it unconditionally calls 
smp_call_function_many() which has a lot of conditions it warns on. 
Additional tests in the callers of smp_call_function_many() would only 
be redundant.


David Daney
