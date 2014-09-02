Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139AbaIBTIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 15:08:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:39103 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084AbaIBTIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 15:08:34 -0400
Date: Tue, 2 Sep 2014 21:08:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Itzcak Pechtalt <itzcak@flashnetworks.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Race condition in HR timers that cause double insertion and hard
 lockup -- all latest versions
In-Reply-To: <CA+55aFw9HL4E=3eofs4=hzY=LvWEcKzzJZOTDDTGkeF1_vDcog@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1409022101080.3333@nanos>
References: <5dfbace37c434be58ed26ea524aa0675@AM3PR06MB388.eurprd06.prod.outlook.com> <CA+55aFw9HL4E=3eofs4=hzY=LvWEcKzzJZOTDDTGkeF1_vDcog@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2014, Linus Torvalds wrote:

> On Tue, Sep 2, 2014 at 8:45 AM, Itzcak Pechtalt
> <itzcak@flashnetworks.com> wrote:
> >
> > I opened a bug in https://bugzilla.kernel.org/show_bug.cgi?id=83601  for this subject with full description.
> > There is also a short fix patch for kernel/hrtimer.c file.
> > Even if this bug occurs rary, however it resolves system hard lockup option.
> 
> The patch is whitespace-damaged, but with a small oneliner like this
> that doesn't much matter (the timer files moved to kernel/time/ during
> this merge window, so the patch wouldn't apply as-is anyway).
> 
> It needs a sign-off (see Documentation/SubmittingPatches), but even
> more importantly it needs to go to the right people for
> double-checking.
> 
> But the patch is more broken than whitespace and even lack of
> sign-off. It cannot even have compiled. I'm assuming "timer_state" was
> intended to be "timer->state". Also, every caller but one already has
> "HRTIMER_STATE_CALLBACK" set unconditionally or to the old state in
> "newstate", so I suspect if this patch is the real fix (which I'll
> leave for Thomas to comment more on), afaik the actual problem can
> only happen through migrate_hrtimer_list() which uconditionally sets
> the whole state to HRTIMER_STATE_MIGRATE.
> 
> Thomas? Leaving damaged patch quoted below.

Right. It's been fixed long ago and the migrate path cannot suffer
from this problem because at this point a callback running on the dead
cpu would cause the 

    BUG_ON(hrtimer_callback_running(timer));

a few lines above the remove_hrtimer() call to trigger and send the
machine into lala land.

Thanks,

	tglx
