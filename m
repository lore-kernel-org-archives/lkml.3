Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403Ab3GNWZZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 18:25:25 -0400
Received: from s16502780.onlinehome-server.info ([87.106.93.118]:55406 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753322Ab3GNWZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 18:25:24 -0400
X-Greylist: delayed 2206 seconds by postgrey-1.27 at vger.kernel.org; Sun, 14 Jul 2013 18:25:23 EDT
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Sun, 14 Jul 2013 22:48:24 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        David Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH] drm/i915: fix long-standing SNB regression in power
 consumption after resume
Message-ID: <20130714214824.GB31828@cantiga.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>,
	David Airlie <airlied@linux.ie>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dri-devel <dri-devel@lists.freedesktop.org>
References: <20130714163009.22374.22100.stgit@zurg>
 <CAKMK7uEtReZxvzJj9LsSXEJEBNiK492CCONdsF5VFK2cA3u0FA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uEtReZxvzJj9LsSXEJEBNiK492CCONdsF5VFK2cA3u0FA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 78.156.73.22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 14, 2013 at 06:52:39PM +0200, Daniel Vetter wrote:
> On Sun, Jul 14, 2013 at 6:30 PM, Konstantin Khlebnikov
> <khlebnikov@openvz.org> wrote:
> > This patch fixes regression in power consumtion of sandy bridge gpu, which
> > exists since v3.6 Sometimes after resuming from s2ram gpu starts thinking that
> > it's extremely busy. After that it never reaches rc6 state.
> >
> > Bug was introduce by commit b4ae3f22d238617ca11610b29fde16cf8c0bc6e0
> > ("drm/i915: load boot context at driver init time"). Without documentation
> > it's not clear what is happening here, probably this breaks internal state of
> > hardware ring buffers and confuses RPS engine. Fortunately keeping forcewake
> > during whole initialization sequence in gen6_init_clock_gating() fixes this bug.
> >
> > References: https://bugs.freedesktop.org/show_bug.cgi?id=54089
> > Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> 
> We already hold an forcewake reference while setting up the rps stuff,
> should we maybe hold the forcewake for the entire duration, i.e. grab
> it here in clock_gating and release it only in gen6/vlv_enable_rps?
> Can you please test that version, too?
> 
> In any case the forcewake grabbing here in the clock gating function
> needs a big comment that otherwise setting the MCTL register might
> break rc6 entry.

It is not clear why the forcewake works, but is easy to imagine one of
the operations in that sequence requires the GPU to be awake at the time
of programming for it to succeed. MBCTL:EnableBootFetch does seem the most
suspicious from its wording in the bspec. I guess all instances of
poking this bit should be protected similary (snb, ivb, vlv, hsw).

Based on that reasoning and that waking the GPU up here has no negative
consequences, and so long as all paths are fixed, I am happy to give this
an Acked-by: Chris Wilson <chris@chris-wilson.co.uk>

Also, we need to reapply the w/a after a Function Level Reset, in other
words we do need to repeat the init_clock_gating after
intel_gpu_reset().
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
