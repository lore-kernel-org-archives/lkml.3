Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab3KFVvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 16:51:09 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:54642 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756411Ab3KFVvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 16:51:06 -0500
Date: Wed, 6 Nov 2013 13:51:03 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Chris Mason <chris.mason@fusionio.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        Mike Snitzer <snitzer@redhat.com>, NeilBrown <neilb@suse.de>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] block: Revert bio_clone() default behaviour
Message-ID: <20131106215103.GE3842@kmo>
References: <1383709721-22809-1-git-send-email-kmo@daterainc.com>
 <20131106161130.3802.97153@localhost.localdomain>
 <20131106200222.GA3842@kmo>
 <20131106202236.3802.2079@localhost.localdomain>
 <20131106205734.GC3842@kmo>
 <20131106212545.3802.19657@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106212545.3802.19657@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 04:25:45PM -0500, Chris Mason wrote:
> Quoting Kent Overstreet (2013-11-06 15:57:34)
> > On Wed, Nov 06, 2013 at 03:22:36PM -0500, Chris Mason wrote:
> > > Quoting Kent Overstreet (2013-11-06 15:02:22)
> 
> [ ... nods, thanks! ... ]
> 
> > OTOH - with regards to just the ordering requirements, the more I look at
> > various code the less accidental the fact that that works seems to be: the best
> > explanation I've come up with so far is that you already needed to ensure that
> > the _pages_ the clone points to stick around until the clone completes, and if
> > you don't own the original bio the only way to do that is to not complete the
> > original bio until after the clone completes.
> > 
> > So if you're a driver cloning bios that were submitted to you, bio_clone_fast()
> > introduces no new ordering requirements.
> > 
> > On the third hand - if you're cloning (i.e. splitting) your own bios, in that
> > case it would be possible to screw up the ordering - I don't know of any code in
> > the kernel that does this today (except for, sort of, bcache) but my dio rewrite
> > takes this approach - but if you do the obvious and sane thing with bio_chain()
> > it's a non issue, it seems to me you'd have to come up with something pretty
> > contrived and dumb for this to actually be an issue in practice.
> > 
> > Anyways, I haven't come to any definite conclusions, those are just my
> > observations so far.
> 
> I do think you're right.  We all seem to have clones doing work on
> behalf of the original, and when everyone is done we complete the
> original.
> 
> But, btrfs does have silly things like this:
> 
>         dio_end_io(dio_bio, err); // end and free the original
> 	bio_put(bio); // free the clone
> 
> It's not a bug yet, but given enough time the space between those two
> frees will grow new code that kills us all.

Hopefully the DIO situation will get better in the near future, Josef was
telling me btrfs was probably going to end up with its own DIO code (replacing a
good chunk of direct-io.c) and that should get a lot easier and saner for you
guys with my dio rewrite. Need to finish getting that to pass xfstests...

> Really though, the new stuff is better, thanks.

Thanks! :)
