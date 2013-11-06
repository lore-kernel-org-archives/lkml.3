Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419Ab3KFVZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 16:25:51 -0500
Received: from dkim2.fusionio.com ([66.114.96.54]:49628 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756391Ab3KFVZu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 16:25:50 -0500
X-ASG-Debug-ID: 1383773149-03d6a54d1b12c8d0001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Kent Overstreet <kmo@daterainc.com>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <20131106205734.GC3842@kmo>
CC: <axboe@kernel.dk>, <linux-kernel@vger.kernel.org>,
        Mike Snitzer <snitzer@redhat.com>, NeilBrown <neilb@suse.de>,
        Olof Johansson <olof@lixom.net>
References: <1383709721-22809-1-git-send-email-kmo@daterainc.com>
 <20131106161130.3802.97153@localhost.localdomain> <20131106200222.GA3842@kmo>
 <20131106202236.3802.2079@localhost.localdomain> <20131106205734.GC3842@kmo>
Message-ID: <20131106212545.3802.19657@localhost.localdomain>
User-Agent: alot/0.3.4
Subject: Re: [PATCH] block: Revert bio_clone() default behaviour
Date: Wed, 6 Nov 2013 16:25:45 -0500
X-ASG-Orig-Subj: Re: [PATCH] block: Revert bio_clone() default behaviour
X-Originating-IP: [10.101.1.160]
X-Barracuda-Connect: cas2.int.fusionio.com[10.101.1.41]
X-Barracuda-Start-Time: 1383773149
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0713 1.0000 -1.5670
X-Barracuda-Spam-Score: -1.57
X-Barracuda-Spam-Status: No, SCORE=-1.57 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.142113
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kent Overstreet (2013-11-06 15:57:34)
> On Wed, Nov 06, 2013 at 03:22:36PM -0500, Chris Mason wrote:
> > Quoting Kent Overstreet (2013-11-06 15:02:22)

[ ... nods, thanks! ... ]

> OTOH - with regards to just the ordering requirements, the more I look at
> various code the less accidental the fact that that works seems to be: the best
> explanation I've come up with so far is that you already needed to ensure that
> the _pages_ the clone points to stick around until the clone completes, and if
> you don't own the original bio the only way to do that is to not complete the
> original bio until after the clone completes.
> 
> So if you're a driver cloning bios that were submitted to you, bio_clone_fast()
> introduces no new ordering requirements.
> 
> On the third hand - if you're cloning (i.e. splitting) your own bios, in that
> case it would be possible to screw up the ordering - I don't know of any code in
> the kernel that does this today (except for, sort of, bcache) but my dio rewrite
> takes this approach - but if you do the obvious and sane thing with bio_chain()
> it's a non issue, it seems to me you'd have to come up with something pretty
> contrived and dumb for this to actually be an issue in practice.
> 
> Anyways, I haven't come to any definite conclusions, those are just my
> observations so far.

I do think you're right.  We all seem to have clones doing work on
behalf of the original, and when everyone is done we complete the
original.

But, btrfs does have silly things like this:

        dio_end_io(dio_bio, err); // end and free the original
	bio_put(bio); // free the clone

It's not a bug yet, but given enough time the space between those two
frees will grow new code that kills us all.

Really though, the new stuff is better, thanks.

-chris
