Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934036Ab3GPUwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 16:52:25 -0400
Received: from oproxy14-pub.unifiedlayer.com ([67.222.51.224]:56835 "HELO
	oproxy14-pub.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752741Ab3GPUwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 16:52:24 -0400
Date: Tue, 16 Jul 2013 13:52:19 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Alexander Kaltsas <alexkaltsas@gmail.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        rocko <rockorequin@hotmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: fix long-standing SNB regression
 in power consumption after resume
Message-ID: <20130716135219.57ec32a0@jbarnes-desktop>
In-Reply-To: <20130716204349.GY5784@phenom.ffwll.local>
References: <20130714163009.22374.22100.stgit@zurg>
	<CAKMK7uEtReZxvzJj9LsSXEJEBNiK492CCONdsF5VFK2cA3u0FA@mail.gmail.com>
	<51E2E65D.5050803@openvz.org>
	<20130716063101.GK5784@phenom.ffwll.local>
	<CALYGNiOtt7FUCTqcyBELoHYEVw_zqmA=bpmHy_nDkhXCduB9qg@mail.gmail.com>
	<20130716100654.1185c031@jbarnes-desktop>
	<20130716131925.7997a7ed@jbarnes-desktop>
	<20130716204349.GY5784@phenom.ffwll.local>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Jul 2013 22:43:49 +0200
Daniel Vetter <daniel@ffwll.ch> wrote:

> On Tue, Jul 16, 2013 at 01:19:25PM -0700, Jesse Barnes wrote:
> > On Tue, 16 Jul 2013 10:06:54 -0700
> > Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > 
> > > On Tue, 16 Jul 2013 11:34:25 +0400
> > > Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:
> > > > I've tested that patch and it really works for me. If you want change
> > > > something for other hardware or
> > > > extend range where forcewake is held prease do it in a separate patch.
> > > > This will be good for bisecting new bugs in the future.
> > > 
> > > Thanks a ton for finding this Konstantin, it puts us on the right
> > > track.
> > > 
> > > Can I ask you to test this patch?  The theory is that having RC6
> > > enabled messes with the initial programming sequence, so it's probably
> > > best to just shut it off at init until we're done, rather than trying
> > > to forcewake around everywhere we need it.
> > 
> > Oops, last one triggers a warn about IRQs.  This one doesn't and still
> > works for me.
> > 
> > Testing welcome.
> > 
> > Thanks,
> > -- 
> > Jesse Barnes, Intel Open Source Technology Center
> > 
> > diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
> > index c9d9d20..d962ec0 100644
> > --- a/drivers/gpu/drm/i915/i915_gem.c
> > +++ b/drivers/gpu/drm/i915/i915_gem.c
> > @@ -4112,6 +4112,9 @@ i915_gem_init_hw(struct drm_device *dev)
> >         drm_i915_private_t *dev_priv = dev->dev_private;
> >         int ret;
> >  
> > +       /* BIOS often leaves RC6 enabled, but disable it for hw init */
> > +       intel_disable_gt_powersave(dev);
> 
> I think it'd be better to have an explicit gen >= 6 check here and a
> disable_rps call. disable_gt_powersave also calls the ironlake version,
> which restores probably bogus values (since we haven't read them out yet
> in the enable code) into the hw.

Yeah the ilk "restore to initial freq" needs fixing, but I thought we
wanted this on all gens?  It shouldn't hurt anything, and may help with
other issues as well.

-- 
Jesse Barnes, Intel Open Source Technology Center
