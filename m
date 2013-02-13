Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444Ab3BMA0T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 19:26:19 -0500
Received: from mail-da0-f51.google.com ([209.85.210.51]:61181 "EHLO
	mail-da0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759199Ab3BMA0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 19:26:17 -0500
Date: Tue, 12 Feb 2013 16:26:22 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Dave Jones <davej@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Debugging Thinkpad T430s occasional suspend failure.
In-Reply-To: <20130212193901.GA18906@redhat.com>
Message-ID: <alpine.LNX.2.00.1302121549500.890@eggly.anvils>
References: <20130212193901.GA18906@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2013, Dave Jones wrote:

> My Thinkpad T430s suspend/resumes fine most of the time. But every so often
> (like one in ten times or so), as soon as I suspend, I get a black screen,
> and a blinking power button.
> 
> (Note: Not the capslock lights like when we panic, this laptop 'conveniently
>  doesn't have those. This is the light surrounding the power button, which afaik
>  isn't even OS controlled, so maybe we're dying somewhere in SMI/BIOS land?)

Me too on T420s, except that is blessed with a blinking CapsLk.

It's so erratic (though I think I see more failures than you do: I'd say
a quick resume never fails, but an overnight resume fails half the time):
I'm afraid I didn't have the patience to embark on pm_trace at all.

I did try to bisect it during the -rc5 week.  I'm not sure, but I have
no record of seeing it on -rc1 or -rc2, but definitely saw it on -rc3.
So I tried bisecting between -rc2 and -rc3, persisting for a day if it
looked good; but the bisection didn't seem to be converging anywhere
likely when -rc6 came out, and I switched to see if -rc6 solved it.

I had no problem with -rc6; but with -rc7 it happens more than ever.
Though still not on "quick" resumes, the kind you want to do when
bisecting.

Sharing these anecdotes in case they match or diverge from your
experience and others, and might help towards finding the cause.
Not-to-be-trusted bisection log appended: of course the bads are
reliable, but perhaps none of the goods.

Hugh

> 
> I tried debugging this with pm_trace, which told me..
> 
> [    4.576035]   Magic number: 0:455:740
> [    4.576037]   hash matches drivers/base/power/main.c:645
> 
> Which points me at..
> 
>  642  Complete:
>  643         complete_all(&dev->power.completion);
>  644 
>  645         TRACE_RESUME(error);
>  646 
>  647         return error;
>  648 }
> 
> The only thing interesting here I think is that this is the resume path.
> So perhaps something failed to suspend, and we tried to back out of suspending,
> but something was too screwed up to abort cleanly ?
> 
> I've tried hooking up a serial console, and even tried console_noblank, 
> which yielded no additional info at all. (I'm guessing the consoles are suspended
> at the time of panic)
> 
> I also tried unloading all the modules I have loaded before the suspend, which
> seemed to reduce the chances of it happening, but eventually it reoccurred.
> 
> Any ideas on how I can further debug this ?
> 
> 	Dave

git bisect start
# good: [d1c3ed669a2d452cacfb48c2d171a1f364dae2ed] Linux 3.8-rc2
git bisect good d1c3ed669a2d452cacfb48c2d171a1f364dae2ed
# bad: [9931faca02c604c22335f5a935a501bb2ace6e20] Linux 3.8-rc3
git bisect bad 9931faca02c604c22335f5a935a501bb2ace6e20
# bad: [36a25de23359940b7713fc40cbcbb046b3797511] sctp: fix Kconfig bug in default cookie hmac selection
git bisect bad 36a25de23359940b7713fc40cbcbb046b3797511
# good: [49569646b2413ee1a4fb7c4537fca058ac22292e] Merge tag 'driver-core-3.8-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core
git bisect good 49569646b2413ee1a4fb7c4537fca058ac22292e
# good: [251741b130c4396d5076f8e0e685cd8883ba39c0] MAINTAINERS: fix drivers/ieee802154/
git bisect good 251741b130c4396d5076f8e0e685cd8883ba39c0
# good: [d0631c6e09f51e094ae5aec1eabe81cc63d78178] Merge branch 'akpm' (fixes from Andrew)
git bisect good d0631c6e09f51e094ae5aec1eabe81cc63d78178
# good: [5ce2955e04a80da7287dc12f32da7f870039bf8f] Merge branch 'upstream' of git://git.linux-mips.org/pub/scm/ralf/upstream-linus
git bisect good 5ce2955e04a80da7287dc12f32da7f870039bf8f
