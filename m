Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbaKKWMn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 17:12:43 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:33345 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaKKWMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 17:12:40 -0500
MIME-Version: 1.0
In-Reply-To: <20141111213628.GP31490@pd.tnic>
References: <c2522bcacf5db9a25a819a8756502edb1d2ca10f.1415739239.git.luto@amacapital.net>
 <20141111213628.GP31490@pd.tnic>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 11 Nov 2014 14:12:18 -0800
Message-ID: <CALCETrU-Uiv8zHC1_-agcH-ByLqzeN1c58EPue5AdbmaDQLpdQ@mail.gmail.com>
Subject: Re: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from userspace
To: Borislav Petkov <bp@alien8.de>
Cc: X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Tony Luck <tony.luck@intel.com>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 1:36 PM, Borislav Petkov <bp@alien8.de> wrote:
> A very big hmmm...
>
> On Tue, Nov 11, 2014 at 12:56:52PM -0800, Andy Lutomirski wrote:
>> This causes all non-NMI kernel entries from userspace to run on the
>> normal kernel stack.
>
> So one of the reasons #MC has its own stack is because we need a
> known-good stack in such situations. What if the normal kernel stack is
> corrupted too due to a #MC?

I don't see why it would be any more likely for the normal kernel
stack to be corrupted due to a hardware issue that interrupted ring 3
code than that the IST stack is corrupted.

>
>> This means that machine check recovery can happen in non-atomic
>> context.  It also obviates the need for the paranoid_userspace path.
>>
>> Borislav has referred to this idea as the tail wagging the dog.  I
>> think that's okay -- the dog was pretty ugly.
>
> And I still am not sure about this: so the #MC handler makes implicit
> assumptions that while it is running nothing is going to interrupt it
> and it can access MCA MSRs. If you switch to process context, another
> #MC will preempt it and overwrite MCA MSRs. Which is a no-no.
>
> So unless I'm missing something - and I probably am - I don't think
> we can run #MC handler in process context. #MC is the highest prio
> abort-type exception along with processor reset for a reason.
>

I don't know what, if anything, masks and unmasks #MC, but certainly
switching to process context like this patch does will not unmask it.
Of course, if you sleep, then all bets are off.

--Andy
