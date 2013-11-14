Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439Ab3KNUdX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 15:33:23 -0500
Received: from mail-qe0-f50.google.com ([209.85.128.50]:45210 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab3KNUdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 15:33:16 -0500
Message-ID: <52853389.7080105@linaro.org>
Date: Thu, 14 Nov 2013 15:33:13 -0500
From: David Long <dave.long@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 10/13] kprobes: Remove uneeded kernel dependency on
 struct arch_specific_insn
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org>   <1381871068-27660-11-git-send-email-dave.long@linaro.org>  <1384362833.3392.42.camel@linaro1.home> <52842F2C.1030701@hitachi.com> <1384438551.3388.78.camel@linaro1.home>
In-Reply-To: <1384438551.3388.78.camel@linaro1.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/13 09:15, Jon Medhurst (Tixy) wrote:
> On Thu, 2013-11-14 at 11:02 +0900, Masami Hiramatsu wrote:
>> (2013/11/14 2:13), Jon Medhurst (Tixy) wrote:
>>> On Tue, 2013-10-15 at 17:04 -0400, David Long wrote:
>>>> From: "David A. Long" <dave.long@linaro.org>
>>>>
>>>> Instead of depending on include/asm/kprobes.h to provide a dummy definition
>>>> for struct arch_specific_insn, do so in include/linux/kprobes.h.
>>>
>>> That change description doesn't quite seem to quite make sense to me.
>>>
>>> Anyway, what we're trying to do with this patch is to allow us to use
>>> arch_specific_insn for purposes additional to implementing kprobes. This
>>> patch enables that but I'm wary that the kprobes code assumes that ainsn
>>> is a struct arch_specific_insn, e.g. in linux/kernel/kprobes.c we have:
>>>
>>> 	memcpy(&p->ainsn, &ap->ainsn, sizeof(struct arch_specific_insn));
>>>
>>> Now, that code isn't compiled when kprobes isn't configured, but it
>>> seams to me to be safer if that was also changed to
>>>
>>> 	memcpy(&p->ainsn, &ap->ainsn, sizeof(p->ainsn));
>>

That does look like an important improvement.

>> This kind of cleanup looks good for me, but I don't agree to change
>> the type of the member (removing is OK) by Kconfig.
>
> Wouldn't that still require an #ifdef CONFIG_KPROBES around ainsn?
> Admittedly a less ugly one than one to change its type to an int.
>

It is also possible to make the include of asm/kprobes.h unconditional, 
although that might only cause the #ifdef to appear in more than one 
include file.

>>   If you want to
>> change the framework of kprobes and uprobes itself (unification),
>> I'm appreciate to discuss with you and uprobes people, because it
>> will involve all arch dependent code change, *NOT ONLY* the ARM issue.
>
> Well, I don't think the goal wasn't unification as such. For kprobes on
> ARM we have to decode and simulate pretty much the entire instruction
> set(s) and the attempt to implement uprobes on ARM have tried to make
> use of as much of that as possible. The tricky bit has been as to where
> to try and draw the level of abstraction, and it seems this may well be
> leaking out of the arch specific arena.
>
> Bit of background, Dave Long has been working on ARM uprobes based on
> Rabin Vincent's earlier work, and I, as author of a large part of the
> current ARM kprobes code, have been reviewing (not very satisfactorily I
> admit) the bits that impact that. One of my motivations has been to push
> the kprobes instruction decoding to be more generic, rather than special
> casing things to cope with uprobes. This is because I'm aware of the
> reoccurring theme on the ARM lists that it would be good to not have all
> the different methods of instruction decoding, for probes, debug and
> simulation, etc. (I'm sceptical that a one-size-fits-all is possible,
> but consolidation where practical is good).
>
>>
>>> However, I also wonder if we should instead leave arch_specific_insn as
>>> a kprobes specific structure and on ARM define it in terms of a new more
>>> generic 'struct probe_insn'? The drawback with that is that we'd
>>> probably end up with a struct just containing a single member which
>>> seems a bit redundant:
>>>
>>> struct arch_specific_insn {
>>> 	struct probe_insn pinsn;
>>> };
>>
>> I also disagree it. If you have a plan to integrate uprobes and kprobes
>> arch specific code, please share it with us.
>
> There's not really a 'plan', just an attempt to reuse the instruction
> decoding code used by kprobes in the implementation of uprobes, i.e. the
> patch series [1] which this mail thread is in reply to.
>
> [1] http://thread.gmane.org/gmane.linux.kernel/1579985
>
>>   I'm happy to work with you.
>> There are already many maintainers on each feature who is responsible for
>> it (even it is a piece of code), and scripts/get_maintainers.pl gives you
>> who are.
>>

Sorry, that would indeed have told me that you were responsible for 
include/linux/kprobes.h.

>>
>> Srikar, Oleg, I think it's a good time to merge such arch_specific mechanism
>> of uprobes and kprobes. Would you think we can do similar thing on x86 too?
>

I welcome input from people who have experience in this area.  I have no 
desire to complicate efforts that might be attempted on other 
architectures, but the existing code was unique to ARM and the goal here 
was just to share it on ARM in implementing the currently non-existant 
ARM uprobes feature.  It seems to me the leakage of these changes into 
generic kprobes code is exceedingly small, and unlikely to be a 
hinderance to any future work (if any is even needed or planned) 
supporting uprobes or kprobes on other architectures.  In the meantime 
we have ARM users who have been asking for uprobes support for a while 
and this is, IMHO, a fairly clean approach to providing it.

-dl

