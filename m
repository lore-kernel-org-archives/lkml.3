Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965206AbaGEUgN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 16:36:13 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:59460 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932687AbaGEUgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 16:36:12 -0400
Date: Sat, 5 Jul 2014 16:36:06 -0400
From: Tejun Heo <tj@kernel.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Jiri Slaby <jslaby@suse.cz>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, mingo@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>, andi@firstfloor.org,
        paulmck@linux.vnet.ibm.com, Pavel Machek <pavel@ucw.cz>,
        jirislaby@gmail.com, Vojtech Pavlik <vojtech@suse.cz>,
        Michael Matz <matz@suse.de>
Subject: Re: kGraft to -next [was: 00/21 kGraft]
Message-ID: <20140705203606.GC3069@mtj.dyndns.org>
References: <1403694329-3064-1-git-send-email-jslaby@suse.cz>
 <53B3F556.7050002@suse.cz>
 <20140702123002.GA20071@mtj.dyndns.org>
 <20140702134721.00163886@alan.etchedpixels.co.uk>
 <alpine.LNX.2.00.1407021459330.1655@pobox.suse.cz>
 <20140702133053.GB20071@mtj.dyndns.org>
 <alpine.LNX.2.00.1407052148410.1655@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1407052148410.1655@pobox.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Jul 05, 2014 at 10:04:52PM +0200, Jiri Kosina wrote:
> What we need is to have a defined point in execution where we can draw a 
> line between "old" and "new" universes. For processess that are crossing 
> the userspace/kernelspace boundary, the obvious choice, that covers most 
> of the use-cases, has been made. There are still scenarios where this 
> aproach can't be just-blindly-applied(TM) for various reasons (changing 
> lock order might cause deadlocks, there are cases where state is lingering 

Sure, if something breaks work due to semantic differences, there
isn't anything we can do.

> between two user <-> kernel transitions, etc). So we'll need to provide 
> guidelines for kGraft patch writers anyway.
> 
> The same holds for the kernel threads -- until all (or most of) the 
> kthreads are converted to workqueues, the obivous choice, that should 
> cover most of the use-cases, has been made.

But, this is different.  This is the mechanism itself being flaky and
buggy.  This can make things fail not because the patch itself is
semantically wrong but because the mechanism stopped the kernel at the
wrong place.  The mechanism is simply broken and it might as well
declare that patching whatever kthreads are running isn't supported.

> But manual/human inspection is absolutely unavoidably necessary in any 
> case.

This is extremely tricky to inspect and likely to just work in most,
but not all, cases when it goes wrong just out of sheer luck.

> Please keep in mind that this is designed for fixes that need immediate 
> response (getting bounds checking right, adding an extra check, adding a 
> missing lock, etc -- please see my previous mail on this topic in the old 
> thread). It's absolutely by design not intended for implementing whole new 
> features or exchanging the whole kernel on the fly; there are other 
> solutions for that (such as the criu-based thing). As such, we tend to 
> interfere with the rest of the kernel as little as possible, but it 
> inadverently brings drawbacks in the form of putting burden of more work 
> to the actual kGraft patch writers. I don't see that as a bad thing.

I'm not saying this must be able to do everything but it shouldn't be
voodoo either.  Freezer points *can* coincide with what kgraft
requires but it may not too.  Why claim that freezing points are safe
as stopping points when they aren't?  That doesn't make any sense to
me.  If kthread can't be safely supported now, that's fine but then
make it clear that functions which may be executed by kthreads aren't
supported.

Thanks.

-- 
tejun
