Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab3KFU5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 15:57:39 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:62644 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610Ab3KFU5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 15:57:38 -0500
Date: Wed, 6 Nov 2013 12:57:34 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Chris Mason <chris.mason@fusionio.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        Mike Snitzer <snitzer@redhat.com>, NeilBrown <neilb@suse.de>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] block: Revert bio_clone() default behaviour
Message-ID: <20131106205734.GC3842@kmo>
References: <1383709721-22809-1-git-send-email-kmo@daterainc.com>
 <20131106161130.3802.97153@localhost.localdomain>
 <20131106200222.GA3842@kmo>
 <20131106202236.3802.2079@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131106202236.3802.2079@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 03:22:36PM -0500, Chris Mason wrote:
> Quoting Kent Overstreet (2013-11-06 15:02:22)
> > Yup - that should actually be safe for all the existing bio_clone() users
> > actually, I audited all of them - because normally you're not going to complete
> > the original bio until the clone finishes.
> 
> I'd say we need an ack from Neil before we can switch to _fast.  The
> completions look non-trivial and _fast adds new ordering requirements on
> free.

Agreed, I've already broken md enough lately :P

(I'm started to work on a real test suite for the block layer, that'll help with
this stuff...)

> > > If you look at dm's crypt_free_buffer_pages(), it had similar problems.
> > 
> > Those are fine actually - in both cases, they're bios they allocated, not the
> > bios that were submitted to them.
> 
> Both are expecting bi_vcnt to be non-zero after a clone, which wasn't
> the case before the bi_vcnt patch.  With your current patch (adding
> _fast) both should now be correct.

Yeah, but bi_vcnt being zero was just a symptom - the underlying reason the old
code was wrong was that with the clone sharing the parent's biovec, md was
modifying a biovec (including bv_page!) that it didn't own - _that_ was what was
horribly broken about it.

> > What's unclear about it? The rule is just - if you didn't allocate the biovec,
> > don't modify it or use bio_for_each_segment_all() (probably I didn't quite state
> > it clearly enough before though)
> 
> That part makes sense.  The new rule that scares me is that we can't
> free the src of the clone until all the clones are freed.  If it works
> with today's existing users it feels like it is more by accident than
> design.  I'm not saying we can't do it, we just need some bigger
> flashing warning lights.

Yeah, Jens was saying the same thing yesterday, hence this patch.

OTOH - with regards to just the ordering requirements, the more I look at
various code the less accidental the fact that that works seems to be: the best
explanation I've come up with so far is that you already needed to ensure that
the _pages_ the clone points to stick around until the clone completes, and if
you don't own the original bio the only way to do that is to not complete the
original bio until after the clone completes.

So if you're a driver cloning bios that were submitted to you, bio_clone_fast()
introduces no new ordering requirements.

On the third hand - if you're cloning (i.e. splitting) your own bios, in that
case it would be possible to screw up the ordering - I don't know of any code in
the kernel that does this today (except for, sort of, bcache) but my dio rewrite
takes this approach - but if you do the obvious and sane thing with bio_chain()
it's a non issue, it seems to me you'd have to come up with something pretty
contrived and dumb for this to actually be an issue in practice.

Anyways, I haven't come to any definite conclusions, those are just my
observations so far.
