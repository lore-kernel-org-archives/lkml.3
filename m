Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab3FYTwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:52:36 -0400
Received: from oproxy13-pub.unifiedlayer.com ([69.89.16.30]:42832 "HELO
	oproxy13-pub.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752023Ab3FYTwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 15:52:35 -0400
Date: Tue, 25 Jun 2013 12:54:37 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Dave Airlie <airlied@redhat.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: Re: Linux 3.10-rc7
Message-ID: <20130625125437.6e7bb2d4@jbarnes-desktop>
In-Reply-To: <CAKMK7uH0q1vSaVRigtZD2pf5ZeVLEv1sn+tsiO7ZWjJdt=DwBA@mail.gmail.com>
References: <CA+55aFz1yMZ1q5daHdTA91pW5QtQ1Yids1dLD9b2JC-ruicNQw@mail.gmail.com>
	<B8EFE96D1287C24090BAD9D858E15E6172FFB9@sisaex02sj>
	<CA+55aFxuB_nx8fZ_kN8U=fMFOq43cKZC_HJbj=6vKo7-fDqNuw@mail.gmail.com>
	<CAKMK7uH0q1vSaVRigtZD2pf5ZeVLEv1sn+tsiO7ZWjJdt=DwBA@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jun 2013 21:37:37 +0200
Daniel Vetter <daniel.vetter@ffwll.ch> wrote:

> On Tue, Jun 25, 2013 at 9:05 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > Adding the appropriate cc'd.. I'm not seeing why this would start
> > happening now, but there's been a number of commits that touch the
> > intel crtc 'active' state and hotplug logic, so I'm assuming one of
> > them is to blame.. Lots of small changes around
> > ironlake_crtc_mode_set() etc.
> >
> > This warning seems to imply that the pll activity count is buggered.
> > Anybody? Chris/Daniel/Dave?
> 
> Hm, looks like a new one. On a quick guess it's an ugly interaction
> between the new state restore code we've added for vt-switchless
> resume in 3.10 and the lack of proper pch pll refcount reconstruction
> when taking over foreign state. I'm thinking of
> 1) hibernate to disk with every crtc switched off
> 2) after power cycle boot into the loader kernel with crtc enables
> 3) restore the hibernated kernel image
> 4) restored kernel reads out current hw state and restores the old
> state by disabling everything
> 5) we hit the WARN(!pll->active) and also the follow-up assert since
> the hw pch pll is indeed on (it's driving the crtc we're disabling
> after all), but our state reconstruction failed to track this
> properly.
> 
> Dunno on a quick guess what to do this late in the -rc to duct-tape
> this WARN away, since we should at least try to shut down the pch pll
> (which we currently won't do). For 3.11 I've completely revamped the
> pch pll code with massively increased paranoia and much better
> tracking of the hw state. It's not all merged yet (some will probably
> miss 3.11), but the refcounting part is all in -next.
> 
> So I think the first step would be to test latest linux-next (or the
> drm-intel-nightly branch from
> http://cgit.freedesktop.org/~danvet/drm-intel/ if you just want the
> drm parts on top of a recent -rc). Also it'd be good to corrobate my
> guess of what's going on with a dmesg with drm debugging enabled
> (drm.debug=0xe).
> 
> Adding more lists to cc + Jesse since he's the guilty one for the
> vt-switchless state restore stuff.

Yeah, looks like we don't fetch the PLL state on resume from hibernate,
leading to this warning.  The refcount is nonzero, indicating the pll
is in use, but the active field is clear, which means we're missing an
update somewhere.

Shuah, just to confirm, does your resume actually work ok aside from
the warning?  I *think* it's harmless in this case, but does indicate a
real bug in our state tracking... trying to come up with a patch now.

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
