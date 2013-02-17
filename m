Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab3BQCVv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 21:21:51 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:61392 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043Ab3BQCVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 21:21:49 -0500
Date: Sat, 16 Feb 2013 18:21:01 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paul McKenney <paul.mckenney@linaro.org>,
        DRI <dri-devel@lists.freedesktop.org>
Subject: Re: Debugging Thinkpad T430s occasional suspend failure.
In-Reply-To: <alpine.LNX.2.00.1302161522130.22723@eggly.anvils>
Message-ID: <alpine.LNX.2.00.1302161803430.23675@eggly.anvils>
References: <20130212193901.GA18906@redhat.com> <alpine.LNX.2.00.1302121549500.890@eggly.anvils> <20130213004059.GA14451@redhat.com> <alpine.LNX.2.00.1302121652240.1077@eggly.anvils> <20130213041629.GA28622@redhat.com> <alpine.LNX.2.00.1302122121170.15020@eggly.anvils>
 <20130213193411.GA15928@redhat.com> <CA+55aFzmEDriX26Z7oJZg9yssFdCAaYwu6krmrwqfj2TBsxA4w@mail.gmail.com> <20130215011503.GA11914@redhat.com> <alpine.LNX.2.00.1302141804400.3330@eggly.anvils> <CA+55aFyLDnmwy16V8TQRwJV2O51K-dmqBhuWi2ytRd4sYi8J+g@mail.gmail.com>
 <alpine.LNX.2.00.1302161302290.21380@eggly.anvils> <CA+55aFwF1qZmPaL5LPA+0ys68s=TF7wfXpb5y9GWi0q5RJDJ-Q@mail.gmail.com> <alpine.LNX.2.00.1302161522130.22723@eggly.anvils>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2013, Hugh Dickins wrote:
> On Sat, 16 Feb 2013, Linus Torvalds wrote:
> > 
> > I think it's worth it to give them a heads-up already. So I've cc'd
> > the main suspects here..
> 
> Okay, thanks.
> 
> > 
> > Daniel, Dave - any comments about a NULL fb in
> > intel_choose_pipe_bpp_dither() during either suspend or resume? Some
> > googling shows this:
> > 
> >     https://bugzilla.redhat.com/show_bug.cgi?id=895123
> 
> Great, yes, I'm sure that's the same (though it says "suspend"
> and I say "resume").
> 
> > 
> > which sounds remarkably similar, and is also during a suspend attempt
> > (but apparently Satish got a full oops out).. Some timing race with a
> > worker entry?

Comparing Satish's backtrace and drivers/gpu/drm history, it's clear that
the oops comes from Daniel's 3.8-rc2 45e2b5f640b3 "drm/i915: force restore
on lid open", whose force_restore case now passes down crtc->base.fb.  But
I wouldn't have a clue why that's usually non-NULL but occasionally NULL:
your timing race with a worker entry, perhaps.

And 45e2b5f640b3 contains a fine history of going back and forth, so I
wouldn't want to play further with it out of ignorance - though tempted
to replace the "if (force_restore) {" by an interim safe-seeming
compromise of "if (force_restore && crtc->base.fb) {".

Hugh
