Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbaHLGzH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 02:55:07 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:53035 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbaHLGzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 02:55:05 -0400
Date: Tue, 12 Aug 2014 08:55:16 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: David Rientjes <rientjes@google.com>
Cc: Rob Clark <robdclark@gmail.com>,
        sanjeev sharma <sanjeevsharmaengg@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drm: Do not use BUG_ON(!spin_is_locked())
Message-ID: <20140812065516.GI10500@phenom.ffwll.local>
Mail-Followup-To: David Rientjes <rientjes@google.com>,
	Rob Clark <robdclark@gmail.com>,
	sanjeev sharma <sanjeevsharmaengg@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <1407731491-22446-1-git-send-email-linux@roeck-us.net>
 <alpine.DEB.2.02.1408110439580.15519@chino.kir.corp.google.com>
 <CAGUYZuS=_rFpukssRebxXBccPrJAen15i8Qf3K+1YyF+feShdQ@mail.gmail.com>
 <CAGUYZuSk4u5jyPcrYTjwjXmQRyr0kCEvxkgFfjcyP+ex544CLA@mail.gmail.com>
 <alpine.DEB.2.02.1408111352090.24240@chino.kir.corp.google.com>
 <CAF6AEGuu7cGpudV-G=vGCZrHjEuqTcFHsqnULE771a5UMNEVsw@mail.gmail.com>
 <alpine.DEB.2.02.1408111636370.23479@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1408111636370.23479@chino.kir.corp.google.com>
X-Operating-System: Linux phenom 3.15.0-rc3+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 04:38:50PM -0700, David Rientjes wrote:
> On Mon, 11 Aug 2014, Rob Clark wrote:
> 
> > > I'm suggesting that if you don't want to incur the cost of the conditional
> > > everytime you call a certain function with assert_spin_locked() that you
> > > could covert these to lockdep_assert_held() so the check is only done when
> > > lockdep is enabled for debugging.
> > 
> > not sure about the nouveau parts, but for the omap and msm hunks, this
> > code getting called at potentially vblank rate (so maybe once or twice
> > per ~16ms)..  and lockdep has considerable overhead (for a gpu driver)
> > so I don't always have it enabled.  So it sounds like for those two at
> > least assert_spin_locked() is a better option.
> > 
> 
> Unless there's a bug, assert_spin_locked() is just going to incur an 
> unnecessary cost every time it is called at runtime.  My suggestion was to 
> limit that check only to debugging kernels that include enabling lockdep 
> when tracking down problems rather than needlessly evaluating the 
> conditional every time when there are no bugs.

My experience with gpu drivers (i915) has been that hw and the software
running it is varied enough that almost always it's better to
unconditionally enable this stuff. I much prefer assert_spin_locked and
friends over the lockdep versions since enabling full lockdep is not
something you usually do. Especially not normal users, and we rely upon
them for testing the old stuff. Furthermore for the modeset code the
overhead is totally irrelevant since we're doing metric piles of register
reads and writes in there anyway.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
