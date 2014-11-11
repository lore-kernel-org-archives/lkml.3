Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518AbaKKXJe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 18:09:34 -0500
Received: from mail.skyhub.de ([78.46.96.112]:56939 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752252AbaKKXJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 18:09:32 -0500
Date: Wed, 12 Nov 2014 00:09:26 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Tony Luck <tony.luck@intel.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from
 userspace
Message-ID: <20141111230926.GR31490@pd.tnic>
References: <c2522bcacf5db9a25a819a8756502edb1d2ca10f.1415739239.git.luto@amacapital.net>
 <20141111213628.GP31490@pd.tnic>
 <CALCETrU-Uiv8zHC1_-agcH-ByLqzeN1c58EPue5AdbmaDQLpdQ@mail.gmail.com>
 <20141111223316.GQ31490@pd.tnic>
 <CALCETrW0+5FkYn-5=WH1vGc-KnRaSj5w83Ds7R9ZTqFX3hQ+5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrW0+5FkYn-5=WH1vGc-KnRaSj5w83Ds7R9ZTqFX3hQ+5g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 02:40:12PM -0800, Andy Lutomirski wrote:
> I wonder what the IRET is for.  There had better not be another magic
> IRET unmask thing.  I'm guessing that the actual semantics are that
> nothing whatsoever can mask #MC, but that a second #MC when MCIP is
> still set is a shutdown condition.

Hmmm, both manuals are unclear as to what exactly reenables #MC. So
forget about IRET and look at this: "When the processor receives a
machine check when MCIP is set, it automatically enters the shutdown
state." so this really reads like a second #MC while the first is
happening would shutdown the system - regardless whether I'm still in
#MC context or not, running the first #MC handler.

I guess I needz me some hw people to actually confirm.

> Define "atomic".
> 
> You're still running with irqs off and MCIP set.  At some point,

Yes, I need to be atomic wrt to another #MC so that I can be able to
read out the MCA MSRs in time and undisturbed.

> you're presumably done with all of the machine check registers, and
> you can clear MCIP.  Now, if current == victim, you can enable irqs
> and do whatever you want.

This is the key: if I enable irqs and the process gets scheduled on
another CPU, I lose. So I have to be able to say: before you run this
task on any CPU, kill it.

> In my mind, the benefit is that you don't need to think about how to
> save your information and arrange to get called back the next time
> that the victim task is a non-atomic context, since you *are* the
> victim task and you're running in normal irqs-disabled kernel mode.
> 
> In contrast, with the current entry code, if you enable IRQs or so
> anything that could sleep, you're on the wrong stack, so you'll crash.
> That means that taking mutexes, even after clearing MCIP, is
> impossible.

Hmm, it is late here and I need to think about this on a clear head
again but I think I can see the benefit of this to a certain extent.
However(!), I need to be able to run undisturbed and do the minimum work
in the #MC handler before I reenable MCEs.

But Tony also has a valid point as in what is going to happen if I
get another MCE while doing the memory_failure() dance. I guess if
memory_failure() takes proper locks, the second #MC will get to wait
until the first is done. But who knows in reality ...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
