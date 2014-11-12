Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbaKLQWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 11:22:34 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33332 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628AbaKLQWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 11:22:33 -0500
Date: Wed, 12 Nov 2014 17:22:25 +0100
From: Borislav Petkov <bp@alien8.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFC PATCH] x86, entry: Switch stacks on a paranoid entry from
 userspace
Message-ID: <20141112162225.GF16807@pd.tnic>
References: <20141111223316.GQ31490@pd.tnic>
 <CALCETrW0+5FkYn-5=WH1vGc-KnRaSj5w83Ds7R9ZTqFX3hQ+5g@mail.gmail.com>
 <20141111230926.GR31490@pd.tnic>
 <CALCETrU+Sq=rW-p2OnjLiaSLqu8rTgbC9uTcqZBJ+J8JhNxa7Q@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292A03B@ORSMSX114.amr.corp.intel.com>
 <CALCETrUU3vSLBVMpsma=8OqOZLRKUYBM19_94tkeZ7aWCEyhog@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3292A157@ORSMSX114.amr.corp.intel.com>
 <CA+8MBbJy3QziFGDzOxMrweWEe_yneETuo4O8bTPZg=2y15qdkQ@mail.gmail.com>
 <20141112103011.GA16807@pd.tnic>
 <CALCETrWsWGf+WRf7gUWs5x=6Ts5KwqWpecrp-Q61jL7usTOvAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALCETrWsWGf+WRf7gUWs5x=6Ts5KwqWpecrp-Q61jL7usTOvAQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 07:48:15AM -0800, Andy Lutomirski wrote:
> I only switch stacks on entry from userspace, and the kernel stack is
> completely empty if that happens.

Ok, fair enough. There's still the argument that something might've
corrupted the kernel stack memory while the MCE_STACK is used only by
#MC.

Btw, we could try something else like making the duration we run on the
IST stack shorter by simply reading out the MCA MSRs, then switch stacks
on exit and do the rest of the processing on the kernel stack. I have no
idea whether something like that would even work/be better.

> One nice thing for testing is that my patch applies to int3 from
> userspace as well, and that's easy to test.

Not that easy for testing the #MC path - there we have to inject real
MCEs and then noodle through the memory_failure() code. I'd be very much
interested to see what would happen if two MCEs happen back-to-back with
your change, the second one being raised when we're on the kernel stack
and in memory_failure()...

> I think I want to make this change anyway, though, since it may
> simplify fsgsbase support enough to justify it solely on that account.
> I don't think that the machine check code needs to change at all to
> accommodate a stack switch, but I think it makes some simplifications
> possible.

Right, I'm very nervous when touching this with non-trivial changes.

> Less intrusive is certainly true.

Right, I can do it in the meantime and we can always experiment more
later. Getting rid of _TIF_MCE_NOTIFY is a good thing already.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
