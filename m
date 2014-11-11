Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521AbaKKQNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 11:13:17 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33367 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097AbaKKQNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 11:13:16 -0500
Date: Tue, 11 Nov 2014 17:13:09 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Chen Gong <gong.chen@linux.intel.com>, X86 ML <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 4/5] x86/mce: Simplify flow when handling recoverable
 memory errors
Message-ID: <20141111161309.GG31490@pd.tnic>
References: <1407998986-1834-1-git-send-email-gong.chen@linux.intel.com>
 <1407998986-1834-5-git-send-email-gong.chen@linux.intel.com>
 <20141111114248.GD31490@pd.tnic>
 <CALCETrULeLC3MhqdG5yJKXp9YL6ir3gOO4e9WGt1X3kkKMXdJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrULeLC3MhqdG5yJKXp9YL6ir3gOO4e9WGt1X3kkKMXdJw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 07:42:48AM -0800, Andy Lutomirski wrote:
> The last time I looked at the MCE code, I got a bit lost in the
> control flow.  Is there ever a userspace-killing MCE that's delivered
> from kernel mode?

Yep, so while you're executing a userspace process, you get
an #MC raised which reports an error for which action is
required, i.e. look at all those MCE_AR_SEVERITY errors in
arch/x86/kernel/cpu/mcheck/mce-severity.c.

It happened within the context of current so we go and run the #MC
handler which decides that the process needs to be killed in order to
contain the error. So after we exit the handler and before we return to
try to sched in the process again on any core, we want to actually kill
it and poison all its memory.

> By that, I mean that I think that all userspace-killing MCEs go have
> user_mode_vm(regs) and go through paranoid_exit.

Yes.

> If so, why do you need to jump through hoops at all?  You can't call
> do_exit, but it should be completely safe to force a fatal signal and
> let the scheduler and signal code take care of killing the process,
> right?  For that matter, you should also be able to poke at vm
> structures, etc.

Well, we do that already. memory-failure.c does kill the processes when
it decides to.

The only question is whether adding two new members to task_struct is
ok. It is nicely convenient and it all falls into place.

In the #MC handler we do:

 		if (worst == MCE_AR_SEVERITY) {
 			/* schedule action before return to userland */
+			current->paddr = m.addr;
+			current->restartable = !!(m.mcgstatus & MCG_STATUS_RIPV);
			set_thread_flag(TIF_MCE_NOTIFY);
		}

and then before we return to userspace we do:

+	if (!current->restartable)
 		flags |= MF_MUST_KILL;
 	if (memory_failure(pfn, MCE_VECTOR, flags) < 0) {

and the MF_MUST_KILL makes sure memory_failure() does a force_sig().

So I think this is ok, I only think that people might oppose the two new
members to task_struct but it looks clean to me this way. IMHO at least.

> Or is there a meaningful case where mce_notify_process needs to help
> with recovery but the original MCE happened with !user_mode_vm(regs)?

Well, for the !user_mode_vm(regs) case we panic anyway.

Thanks Andy.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
