Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250AbaKKWPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 17:15:31 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:58670 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaKKWPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 17:15:30 -0500
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F32929962@ORSMSX114.amr.corp.intel.com>
References: <c2522bcacf5db9a25a819a8756502edb1d2ca10f.1415739239.git.luto@amacapital.net>
 <20141111213628.GP31490@pd.tnic> <3908561D78D1C84285E8C5FCA982C28F32929962@ORSMSX114.amr.corp.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 11 Nov 2014 14:15:08 -0800
Message-ID: <CALCETrUr8pjC40O_66dDUovEreXqBEEL3bHt7R3ciZ+oD8qW=g@mail.gmail.com>
Subject: Re: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from userspace
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 2:00 PM, Luck, Tony <tony.luck@intel.com> wrote:
> So here is the flow:
>
> 1) A machine check happens - it is (currently) broadcast to all logical cpus on all sockets
>
> 2) First cpu to execute "order = atomic_inc_return(&mce_callin);" in mce_start() gets to be the "monarch" and directs things during the handler.

This is a bit funky, since any number of #MCs might be delivered in
process context, and any one of them, or none of them, might win the
election.  Can this be made to not matter, or can the actual faulting
CPU be made to win the election?

>
> 3) Every cpu gets to scan all the machine check banks to see what happened. If the error was a fatal one we are going to panic - this isn't the interesting case.
>
> 4) There are two kinds of recoverable error
> 4a) Ones not in execution context (SRAO = Software Recoverable Action Optional) -  these also aren't very interesting - save the address in a NMI safe ring buffer to process later
> 4b) In execution context (SRAR = Software Recoverable Action Required) - this is where we need to do some real work to convert from the physical address logged to the list of affected processes.
>
> Now when we get to step 4b - we need to let all the other processors return from the machine check handler (they may have been interrupted in kernel context and could hold locks that we need).
>
> We also need to clear the MSR MCG_STATUS (on each logical cpu) to indicate we are done with this machine check.
>
>
> Andy - with your RFC patch - can we just make the bottom end of do_machine_check() look like this:
>
>         /* collected everything we need from banks - re-enable machine check on all cpus */
>         mce_wrmsrl(MSR_IA32_MCG_STATUS, 0);
>
>         if (we are *not* the thread with the SRAR error)
>                 return;
>
>         /* do all the things that were previously in mce_notify_process() here */
> }

That's the intent.

>
> and if we do this - what happens if we get another machine check while we are in the "do all the things" bit?
>

Is it the case that another #MC can't happen until you clear IA32_MCG_STATUS?

In any event, this should be no more or less safe than the previous
approach of doing the main part of #MC handling, then switching
stacks, then handling the rest in user context.  But you might be able
to get away with waiting to clear IA32_MCG_STATUS until after you're
done, as long as you don't let yourself be preempted.

What are the semantics of #MC nesting and masking, anyway?  Last time
I looked at the SDM, I couldn't figure it out.

--Andy
