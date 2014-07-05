Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932658AbaGEUE5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 16:04:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42756 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932086AbaGEUE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 16:04:56 -0400
Date: Sat, 5 Jul 2014 22:04:52 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Tejun Heo <tj@kernel.org>
cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Jiri Slaby <jslaby@suse.cz>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>, andi@firstfloor.org,
        paulmck@linux.vnet.ibm.com, Pavel Machek <pavel@ucw.cz>,
        jirislaby@gmail.com, Vojtech Pavlik <vojtech@suse.cz>,
        Michael Matz <matz@suse.de>
Subject: Re: kGraft to -next [was: 00/21 kGraft]
In-Reply-To: <20140702133053.GB20071@mtj.dyndns.org>
Message-ID: <alpine.LNX.2.00.1407052148410.1655@pobox.suse.cz>
References: <1403694329-3064-1-git-send-email-jslaby@suse.cz> <53B3F556.7050002@suse.cz> <20140702123002.GA20071@mtj.dyndns.org> <20140702134721.00163886@alan.etchedpixels.co.uk> <alpine.LNX.2.00.1407021459330.1655@pobox.suse.cz>
 <20140702133053.GB20071@mtj.dyndns.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2014, Tejun Heo wrote:

> >  static inline bool try_to_freeze(void)
> >  {
> > +       kgr_task_safe(current);
> > +
> >         if (!(current->flags & PF_NOFREEZE))
> >                 debug_check_no_locks_held();
> >         return try_to_freeze_unsafe();
> 
> Heh, I'm totally confused now.  Why is this correct?  What guarantees
> that context is not carried across try_to_freeze()?

I think we need to take a step back now, and ask ourselves a question 
"What is the actual goal here?".

What we need is to have a defined point in execution where we can draw a 
line between "old" and "new" universes. For processess that are crossing 
the userspace/kernelspace boundary, the obvious choice, that covers most 
of the use-cases, has been made. There are still scenarios where this 
aproach can't be just-blindly-applied(TM) for various reasons (changing 
lock order might cause deadlocks, there are cases where state is lingering 
between two user <-> kernel transitions, etc). So we'll need to provide 
guidelines for kGraft patch writers anyway.

The same holds for the kernel threads -- until all (or most of) the 
kthreads are converted to workqueues, the obivous choice, that should 
cover most of the use-cases, has been made.

But manual/human inspection is absolutely unavoidably necessary in any 
case.

Please keep in mind that this is designed for fixes that need immediate 
response (getting bounds checking right, adding an extra check, adding a 
missing lock, etc -- please see my previous mail on this topic in the old 
thread). It's absolutely by design not intended for implementing whole new 
features or exchanging the whole kernel on the fly; there are other 
solutions for that (such as the criu-based thing). As such, we tend to 
interfere with the rest of the kernel as little as possible, but it 
inadverently brings drawbacks in the form of putting burden of more work 
to the actual kGraft patch writers. I don't see that as a bad thing.

Thanks,

-- 
Jiri Kosina
SUSE Labs
