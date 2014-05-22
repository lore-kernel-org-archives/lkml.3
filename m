Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbaEVIuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 04:50:46 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58757 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbaEVIun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 04:50:43 -0400
Date: Thu, 22 May 2014 10:50:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Luck, Tony" <tony.luck@intel.com>, Andy Lutomirski <luto@amacapital.net>,
        Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
Message-ID: <20140522085040.GA4383@pd.tnic>
References: <CALCETrXMe_rvKBcZpGhodXO1WY44WHSyZM8OKQG-AXm=X0kMrw@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F3281198D@ORSMSX114.amr.corp.intel.com>
 <CALCETrXxEAwJ33bF7FeRLeCbE7BfMn==OsFsoorW_NWFLxwuew@mail.gmail.com>
 <20140521224816.GP25130@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F32811B92@ORSMSX114.amr.corp.intel.com>
 <CALCETrVfas7s_F1bFnJou=ymra5zmc3DTeiEm+DDjKJg+J=0qg@mail.gmail.com>
 <3908561D78D1C84285E8C5FCA982C28F32811C5F@ORSMSX114.amr.corp.intel.com>
 <CA+55aFwXTME_Ge53xKjyM35mVQ+gmvDPwTLa5kR5zAMnNTFSbQ@mail.gmail.com>
 <20140521235143.GC21575@pd.tnic>
 <CA+55aFyD7wzt_Ev1yc3R+WnFNCBodGkEw5-qLsbhFMPQoFnEWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFyD7wzt_Ev1yc3R+WnFNCBodGkEw5-qLsbhFMPQoFnEWw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 09:03:34AM +0900, Linus Torvalds wrote:
> No, that's fine, if it's a thread-synchronous thing (ie a memory load
> that causes errors). But for NMI handlers, that is irrelevant: if
> the NMI code itself gets memory errors, the machine really is dead.
> Let's face it, we're going to panic and reboot, there's no other
> real alternative (other than the "just log it, pray, and continue
> in unstable mode", which is actually a perfectly valid alternative
> in many cases, since people don't necessarily care deeply and have
> written their distributed algorithms to not rely on any particular
> thread too much, and will verify the end results anyway).

Oh, definitely.

Infact, we'll panic on uncorrectable errors in any unmovable memory,
i.e. kernel code and data because we simply can't recover from it.
Anything that happens in the NMI handler most probably falls in that
category so...

I was simply pointing out the fact that Andy's algo needs to pay
attention to MCEs and other higher prio exceptions happening.

> The problem is literally the non-synchronous things (like another
> CPU having problems) where things like broadcast will actually turn
> a non-thread-synchronous thing into problems for other CPU's. Then,
> a user-mode memory access error (that we *can* recover from, perhaps
> by killing the process and isolating the page) can turn into a
> unrecoverable error on another CPU because it got interrupted at a
> point where it really couldn't afford to be interrupted.

That definitely sounds like a nasty thing, sure.

Although, there's at least one problem I've been thinking about wrt the
non-broadcast MCE: it is pretty hard to handle an uncorrectable memory
error in a page which is shared by multiple threads running on multiple
cores.

So normally one of the cores will detect it, raise an MCE and deal with
it but there's nothing stopping the other cores from touching that data.

One of the possible things which could happen is, if the other cores
consume that data, they will trigger an MCE too and will have to see
that the first core which detected the error is about to poison that
page so their job in the MCE handler is done and they have to exit.

I'm not saying this is undoable but it is a bit tricky and some
scenarios would need to be played out first to know better.

So, to a certain extent, broadcasting the MCE and keeping the cores in a
holding pattern, not touching any userspace stuff might've been one way
to deal with situations like that. It certainly makes things easier for
that particular scenario.

I'm not saying it was a good idea due to the point you're making - maybe
they should've talked to software people first. I'm basically trying to
explain to me what the reasoning behind that broadcasting might be.

> It appears Intel is fixing their braindamage.

Yep, we'd still need to deal with the existing systems but we don't have
a choice anyway.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
