Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932519AbaGWRdo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 13:33:44 -0400
Received: from canardo.mork.no ([148.122.252.1]:58933 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756793AbaGWRdn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 13:33:43 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Nick Krause <xerofoify@gmail.com>
Cc: drbd-dev@lists.linbit.com, drbd-user@lists.linbit.com,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drbd: Remove fix me statements
Organization: m
References: <1406053161-5048-1-git-send-email-xerofoify@gmail.com>
	<8738dsi7l7.fsf@nemi.mork.no>
	<CAPDOMVjwzfmHAKGBENfpxN2cswckq2T=QbQa56k3w0X+cDuJKg@mail.gmail.com>
Date: Wed, 23 Jul 2014 19:33:30 +0200
In-Reply-To: <CAPDOMVjwzfmHAKGBENfpxN2cswckq2T=QbQa56k3w0X+cDuJKg@mail.gmail.com>
	(Nick Krause's message of "Wed, 23 Jul 2014 11:45:13 -0400")
Message-ID: <87a980getx.fsf@nemi.mork.no>
User-Agent: Gnus/5.130011 (Ma Gnus v0.11) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Krause <xerofoify@gmail.com> writes:

> Bjorn,
> Can we remove the double locking  as you are stating or do  we still need it
> to protect against the list being accessed  as the list seems to be moving
> to a spinlock protected list.

I wouldn't know.

The only thing I know is that the original author of those lines, who we
must assume has thorough knowlegde of this code, did not know how to fix
that in a simple and straight forward way.

>From this we can deduce that there is more to it than just changing a
couple of lines. If you don't alrady know this code in and out, then you
would have to start by analyzing the current locking model and
understanding that.  Then, assuming the current double locking is in
fact necessary, you would need to redesign it so that you can make one
of the locks go away.  Then you need to implement your new design.  Then
test it _thoroughly_ to eliminate all the small bugs. Everyone adds bugs
when writing non-trivial code.  (You seem to think that you can delegate
all the bug squashing to others simply because you don't own the
hardware.  That is not so.  If you don't have access to hardware for
testing, then you should not add any bugs.  Yes, this implies that you
cannot write non-trivial code for hardware you don't have). Then you must
verify that the result is at least as efficient as the old code was. Or
there would be no point, would there?

When all this is done, and the testing shows it is a success, *then* you
can remove the FIXME comment with a nice commit message explaining the
new locking model and why it now is safe to drop one of the locks.

There is a fat chance that this just isn't worth all the work.  Which is
most likely why the FIXME was stuck there in the first place.

You should understand that noone will add a FIXME for anything trivial.
And if an author who knows the code well finds something non-trivial,
then you should definitely not touch it without investing enough time to
have a similar understanding of the code.

Note again that I am writing all this as purely generic comments.  I
don't know anything at all about the code in question, and I wouldn't
dare touching it without spending a lot of time understanding it first.

As Steven said: find an area to focus on.  Spend some time understanding
a small part of the kernel instead of jumping all around.

And: Being able to test code yourself is absolutely necessary in the
beginning.  But you don't necessarily have to run out and buy some odd
new hardware for that. I'm pretty sure many drivers and other parts of
the kernel is in use on the hardware you already have at hand :-)
Choose among those parts for your learning experience.

Your USB hcd patch is a nice example of code that you most likely can
test yourself.  And the pacth was fine too, except for the lack of a
proper commit message explaining why it was OK.  But most of us will
just look at the "Acked-by: Alan Stern" line and figure that the change
definitely must be fine :-)


Bjørn (who also has sumitted his share of buggy patches, creating
unnecessary work for innoncent maintainers in the past.  Sorry about
that Greg, Oliver, Alan, David, Mauro and all the others... I'm afraid I
cannot even guarantee that it won't happen again, but I do try my best)
