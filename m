Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284AbaGEVEK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 17:04:10 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:54239 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbaGEVEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 17:04:08 -0400
Date: Sat, 5 Jul 2014 17:04:02 -0400
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
Message-ID: <20140705210402.GD3069@mtj.dyndns.org>
References: <1403694329-3064-1-git-send-email-jslaby@suse.cz>
 <53B3F556.7050002@suse.cz>
 <20140702123002.GA20071@mtj.dyndns.org>
 <20140702134721.00163886@alan.etchedpixels.co.uk>
 <alpine.LNX.2.00.1407021459330.1655@pobox.suse.cz>
 <20140702133053.GB20071@mtj.dyndns.org>
 <alpine.LNX.2.00.1407052148410.1655@pobox.suse.cz>
 <20140705203606.GC3069@mtj.dyndns.org>
 <alpine.LNX.2.00.1407052240020.1655@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1407052240020.1655@pobox.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Jul 05, 2014 at 10:49:18PM +0200, Jiri Kosina wrote:
> Quite frankly, I have to say that I don't personally see *that* big 
> difference. In both cases we are making assumptions about semantics, and 
> are trying to get "as close as possible" to the point in time where the 
> set of assumptions can be made as minimal as possible.
>
> With userspace thread, this is kernel/userspace boundary. With kthread, 
> this is starting of new iteration of the main loop / try_to_freeze().

This is really different.  With kernel/userspace boundary, if the
patch is correct, the mechanism, sans bugs, should be able to
guarantee that the patched result is correct.  With kthreads, it
can't.  The boundary between the old and new worlds might or might not
be correct.  How can they be the same?

The fact that they may coincide often can be useful as a guideline or
whatever but I'm completely against just mushing it together when it
isn't correct.  This kind of things quickly lead to ambiguous
situations where people are not sure about the specific semantics or
guarantees of the construct and implement weird voodoo code followed
by voodoo fixes.  We already had a full round of that with the kernel
freezer itself, where people thought that the freezer magically makes
PM work properly for a subsystem.  Let's please not do that again.

> > This is the mechanism itself being flaky and buggy.  This can make 
> > things fail not because the patch itself is semantically wrong but 
> > because the mechanism stopped the kernel at the wrong place.  
> 
> Well, to be precise, we are not "stopping" the kernel at all.

Sure, whatever the term is, this is the boundary that the mechanism
considers it safe to swap the code, right?  User/kernel boundary
should be able to serve that purpose.  Freezing points can't.

> > If kthread can't be safely supported now, that's fine but then make it 
> > clear that functions which may be executed by kthreads aren't supported.
> 
> So one of the aproaches implied by this would be first merging a light 
> version of kGraft which doesn't support kthreads, and working towards a 
> solution for kthreads as well (which might be tangential to kGraft; if 
> most of the kthreads get converted to workqueues, it's a win-win 
> situation anyway); would such kGraft-light get your Ack then? :)

Yes, I think that converting things over to workqueue or
kthread_worker is generally a good idea but I'm not sure I'm in the
position to ack or nack kgraft as a whole.  I am not too sure about
the capability itself (neither positive or negative) and it'd take
quite a bit of energy to scrutinize and compare all the alternatives.
It'd be awesome if people who are working on the features can talk to
each other and see whether things can be combined.

Thanks.

-- 
tejun
