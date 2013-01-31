Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab3AaWoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 17:44:17 -0500
Received: from www.linutronix.de ([62.245.132.108]:59410 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969Ab3AaWoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 17:44:12 -0500
Date: Thu, 31 Jan 2013 23:44:09 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [patch 00/40] CPU hotplug rework - episode I
In-Reply-To: <CA+55aFx=cv+HxKGx+oQk4iLnnTGO7P0u3+DnvuOWbYzM-wvEeQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1301312302290.11905@ionos>
References: <20130131120348.372374706@linutronix.de> <20130131122342.31b28664.akpm@linux-foundation.org> <alpine.LFD.2.02.1301312233480.11905@ionos> <CA+55aFx=cv+HxKGx+oQk4iLnnTGO7P0u3+DnvuOWbYzM-wvEeQ@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Feb 2013, Linus Torvalds wrote:
> On Fri, Feb 1, 2013 at 8:48 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> I think we want as many people as possible cc'd on this. You may think
> it's an obvious improvement, but maybe it's just because you now
> understand the code because you wrote it yourself, not because it's
> *actually* better.

Fair enough.
 
> Having some explicitly documented states may be nice, but do we need
> eleven of them? And do we want to expose them? At least not for the
> f*cking notifiers, I hope. Notifiers are a disgrace, and almost all of
> them are a major design mistake. They all have locking problems, the
> introduce internal arbitrary API's that are hard to fix later (because
> you have random people who decided to hook into them, which is the
> whole *point* of those notifier chains).

That's the whole point of this. The notifier chains are random places
which allow people to add crap at will. And they did. Just grep for
any of the gazillions hotplug notifier implementations. Though some of
them you might not be able to find because they are burried under a
subsystem macro magic.
 
> Since the patches themselves weren't cc'd, I don't know if you

I screwed up the 0/40 cover header and therefor quilt decided to
exclude you from that 40 patches mail bomb :(

Poke me if you want a private copy

> actually made each state transition do those insane notifiers or not,
> but I seriously hope you didn't. With that many states, hopefully the
> idea is that you don't have any notifiers at all, and you just then
> call the people associated with a particular state directly. Yes? No?

The current lot of patches are converting parts of the documented and
undocumented notifier callbacks into an array of callbacks which
documents the ordering. Some of the patches aggregate multiple
notifiers to a single one which ensures the ordering of the subsystem
specific ones, but at the moment I concentrated to provide a path from
a wild notifier scheme to a documented list of callbacks.
 
> Because if this adds tons of new notifiers, I'm going to say that we

No. It does not add any new notifiers. It simply converts notifier
randomness, i.e. your personal choice of CPU_* action flavor to an
ordered list.

> need about a hundred people signing off on the patches.  Part of your
> explanation made me think you got rid of the notifiers, but then it

I wish I could have got rid of the notifiers. But do you have a way to
do that w/o breaking the world and some more ? The only way to do that
would be reimplementing it from scratch. Sure we can do that, and hell
I know how, but we cannot do that in the current workflow. That would
require a switch back to the 2.odd/even scheme and we all know how
well this works out.

> became clear that you just renamed them as "state callbacks". If

It's not about renaming. It's about making the ordering constraints
clear. It's about documenting the existing horror in a way, that one
can understand the hotplug process w/o hallucinogenic drugs.

> that's some generic exposed interface, I'll NAK it. No way in hell do
> we want to expose eleven states with some random generic "SMP state
> callback interface". F*ck no.

Just face it. The current hotplug maze has 100+ states which are
completely undocumented. They are asymetric vs. startup and
teardown. They just exists and work somehow aside of the occasional
hard to decode hickup.

Do you really want to preserve that state by all means [F*ck no]?

Thanks,

	tglx

