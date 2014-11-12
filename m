Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbaKLKaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 05:30:24 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39714 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194AbaKLKaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 05:30:20 -0500
Date: Wed, 12 Nov 2014 11:30:11 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@intel.com>, Andy Lutomirski <luto@amacapital.net>
Cc: X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from
 userspace
Message-ID: <20141112103011.GA16807@pd.tnic>
References: <20141111213628.GP31490@pd.tnic>
 <CALCETrU-Uiv8zHC1_-agcH-ByLqzeN1c58EPue5AdbmaDQLpdQ@mail.gmail.com>
 <20141111223316.GQ31490@pd.tnic>
 <CALCETrW0+5FkYn-5=WH1vGc-KnRaSj5w83Ds7R9ZTqFX3hQ+5g@mail.gmail.com>
 <20141111230926.GR31490@pd.tnic>
 <CALCETrU+Sq=rW-p2OnjLiaSLqu8rTgbC9uTcqZBJ+J8JhNxa7Q@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292A03B@ORSMSX114.amr.corp.intel.com>
 <CALCETrUU3vSLBVMpsma=8OqOZLRKUYBM19_94tkeZ7aWCEyhog@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292A157@ORSMSX114.amr.corp.intel.com>
 <CA+8MBbJy3QziFGDzOxMrweWEe_yneETuo4O8bTPZg=2y15qdkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+8MBbJy3QziFGDzOxMrweWEe_yneETuo4O8bTPZg=2y15qdkQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 11, 2014 at 06:06:48PM -0800, Tony Luck wrote:
> > Innocent bystanders have RIPV=1, EIPV=0 in MCG_STATUS ... so they
> > are quite easy to spot.
> 
> Bother ... except for the SRAO cases where *everyone* is an innocent
> bystander - but someone should go look for the error and queue up
> a page offline event.  Perhaps for this we'd do the self-ipi trick and
> then scan the banks to look for SRAO signatures to process as well
> as clearing MCIP

First of all, good morning :-)

So I'm reading all those notes again and I can't say I'm convinced about
the change. And all those "but but, what might happen if" cases are what
bother me.

First, the stack: switching to a possibly almost full kernel stack
where we have other stuff already allocated is a bad idea IMO. There's
a good reason to have a known-good, solely-for-our-purpose stack which
we get to use. It is always there and it gives us the optimal conditions
possible for recovery. Switching back to the possibly crowded kernel
stack and causing stack overflows while handling an MCE is not an
improvement in my book.

Tony:
> The current code has an ugly hole at the moment. End of
> do_machine_check() clears MCG_STATUS. At that point we are still
> running on the magic stack for machine check exceptions ... if we take
> a machine check in the small window from there until we get off this
> stack (iret) ... then we will enter the handler back on the same stack
> that we haven't finished using yet. Bad things ensue.

I'm not crazy about it either but how often does this actually happen in
practice? And if it does happen, then, well, we die, so be it. It can
happen with other MCEs coming in back-to-back like poisoned data (1st
MCE) being consumed on another core (2nd MCE). I know, Intel does the
broadcasting but that is going to change, I hear and AMD raises an MCE
on the core which detects it only.

Another big issue I see with this is verifying the locking works and
generally testing this serious change. MCA is core kernel infrastructure
and we cannot break this left and right. And changing stacks we're
running on and the whole dynamics of the code might open a whole other
can of worms.

Oh, and we shouldn't forget why we're doing this: just to save two
members to task_struct and getting rid of paranoid_userspace. Yep, still
not convinced the effort is worth it.

Now, I think Andy had a much better/simpler/cleaner suggestion
yesterday: task_work_add(). It is basically what _TIF_MCE_NOTIFY does
and it is called in the same path - do_notify_resume() - but generic and
we can drop _TIF_MCE_NOTIFY then and use the generic thing.

Much less intrusive change.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
