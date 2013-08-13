Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758390Ab3HMQ3Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:29:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34220 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758224Ab3HMQ3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:29:13 -0400
Message-ID: <520A5EA5.8090301@zytor.com>
Date: Tue, 13 Aug 2013 09:28:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <bitbucket@online.de>, Andi Kleen <ak@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] per-cpu preempt_count
References: <20130812115113.GE27162@twins.programming.kicks-ass.net> <CA+55aFznj9WqGa_Qa0B4=5iTio2br54uJG7xkm6otN2sG2P=8w@mail.gmail.com> <20130812175830.GB18691@gmail.com> <CA+55aFw=S4xxdkKpjQdg77CehBBW6S-13N6-7tq4=-nN_cCUKA@mail.gmail.com> <20130813103056.GA2170@gmail.com> <20130813122652.GA24092@twins.programming.kicks-ass.net> <CA+55aFxieQGUkEi9i=LRzVK2DRvavKgF-YEvskvJhF3-5xiU2A@mail.gmail.com> <20130813155637.GA5280@gmail.com>
In-Reply-To: <20130813155637.GA5280@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2013 08:56 AM, Ingo Molnar wrote:
> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>> On Tue, Aug 13, 2013 at 5:26 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>>>
>>> So we're now down to something like:
>>>
>>>   decl fs:preempt_count
>>>   cmpl PREEMPT_NEED_RESCHED,fs:preempt_count
>>>   jnz 1f
>>
>> Well, this isn't worth doing unless you can make PREEMPT_NEED_RESCHED be 
>> the high bit, and we can combine it into just "decl+jns". Otherwise we'd 
>> be better off with the simpler two separate adjacent variables.
> 
> Definitely, the cmpl should be avoided.
> 
> PREEMPT_NEED_RESCHED could be made the high bit - or maybe an even simpler 
> solution is to invert its meaning: making '0' the "it needs to resched!" 
> case, so the check would be decl+jz?
> 

That is pretty elegant.  A little more elegant in fact than my
suggestion to bias NEED_RESCHED by 0x7fffffff and test the overflow flag.

That way we also avoid going off to the slow path without the count
being zero, which although we already covered that it doesn't matter all
that much still is a nice bonus.

	-hpa

