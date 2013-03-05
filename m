Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759040Ab3CETQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 14:16:21 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:38548 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911Ab3CETQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 14:16:18 -0500
Date: Tue, 5 Mar 2013 20:18:49 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Imre Deak <imre.deak@intel.com>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Paulo Zanoni <przanoni@gmail.com>
Subject: Re: [git pull] drm merge for 3.9-rc1
Message-ID: <20130305191849.GL9021@phenom.ffwll.local>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	Dave Airlie <airlied@linux.ie>, Imre Deak <imre.deak@intel.com>,
	DRI mailing list <dri-devel@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Paulo Zanoni <przanoni@gmail.com>
References: <alpine.DEB.2.00.1302260003460.24684@skynet.skynet.ie>
 <CA+55aFzRRxTjuQcLhkhfxDWpHEg3EoSY8CMP+v78i+_Z-EkQ1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzRRxTjuQcLhkhfxDWpHEg3EoSY8CMP+v78i+_Z-EkQ1g@mail.gmail.com>
X-Operating-System: Linux phenom 3.7.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 05:39:46PM -0800, Linus Torvalds wrote:
> On Mon, Feb 25, 2013 at 4:05 PM, Dave Airlie <airlied@linux.ie> wrote:
> >
> > Highlights:
> >
> > i915: all over the map, haswell power well enhancements, valleyview macro horrors cleaned up, killing lots of legacy GTT
> > code,
> 
> Lowlight:
> 
> There's something wrong with i915 DP detection or whatever. I get
> stuff like this:
> 
> [    5.710827] [drm:intel_dp_aux_wait_done] *ERROR* dp aux hw did not
> signal timeout (has irq: 1)!
> [    5.720810] [drm:intel_dp_aux_wait_done] *ERROR* dp aux hw did not
> signal timeout (has irq: 1)!
> [    5.730794] [drm:intel_dp_aux_wait_done] *ERROR* dp aux hw did not
> signal timeout (has irq: 1)!
> [    5.740782] [drm:intel_dp_aux_wait_done] *ERROR* dp aux hw did not
> signal timeout (has irq: 1)!
> [    5.750775] [drm:intel_dp_aux_wait_done] *ERROR* dp aux hw did not
> signal timeout (has irq: 1)!
> [    5.750778] [drm:intel_dp_aux_ch] *ERROR* dp_aux_ch not done status
> 0xa145003f
> .....
> [    8.149931] [drm:intel_dp_aux_ch] *ERROR* dp_aux_ch not done status
> 0xa145003f
> 
> and after that the screen ends up black.
> 
> It's happened twice now, but is not 100% repeatable. It looks like the
> message itself is new,  but the black screen is also new and does seem
> to happen when I get the message, so...
> 
> The second time I touched the power button, and the machine came back.
> Apparently the suspend/resume cycle made it all magically work: the
> suspend caused the same errors, but then the resume made it all good
> again.
> 
> Some kind of missed initialization at bootup? It's not reliable enough
> to bisect, but I obviously suspect commit 9ee32fea5fe8 ("drm/i915:
> irq-drive the dp aux communication") since that is where the message
> was added..
> 
> Btw, looking at that commit, what do you think the semantics of the
> timeout in something like
> 
>     done = wait_event_timeout(dev_priv->gmbus_wait_queue, C, 10);
> 
> would be? What's that magic "10"? It's some totally random number.
> 
> Guys, it should be something meaningful. If you meant a tenth of a
> second, use HZ/10 or something. Because just the plain "10" is crazy.
> I happen to have CONFIG_HZ_1000=y, and you're apparently waiting for a
> hundreth of a second. Was that what you intended? Because if it was,
> it is still crap, since CONFIG_HZ might be 100, and then you're
> waiting for ten times longer.
> 
> IOW, passing in a random number like that is crazy. It cannot possibly
> be right.
> 
> I have no idea whether the timeout has anything to do with anything,
> but it reinforces my suspicion that there is something wrong with that
> commit.

Ok, I've merged two patches from Paulo, one to fixup the harmless jiffies
vs. msec confusion. And the other to plug a race in our irq handler which
did lead to missed dp aux interrupts according to some digging done by
Imre. The important patch is the current tip of

git://people.freedesktop.org/~danvet/drm-intel drm-intel-fixes

44498aea293b37af1d463acd9658cdce1ecdf427 drm/i915: also disable south interrupts when handling them

Just in case you want to give it a quick whirl. Since the failed dp aux
transaction caused the resume modeset to fail for you (resulting in the
black screen) I hope that this should fix both issues.

I'll forward the pull to Dave in a few days since atm I'm stalling a bit
for confirmation on another little regression fix. And there's nothing
earth-shattering in my -fixes queue right now.

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
