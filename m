Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbaJXG5b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 02:57:31 -0400
Received: from mail.fireflyinternet.com ([87.106.93.118]:59474 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751907AbaJXG53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 02:57:29 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Date: Fri, 24 Oct 2014 07:56:52 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Robert Bragg <robert@sixbynine.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Rob Clark <robdclark@gmail.com>,
        Samuel Pitoiset <samuel.pitoiset@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: Re: [RFC PATCH 3/3] i915: Expose PMU for Observation Architecture
Message-ID: <20141024065652.GV13512@nuc-i3427.alporthouse.com>
References: <1413991731-20628-1-git-send-email-robert@sixbynine.org>
 <1413991731-20628-4-git-send-email-robert@sixbynine.org>
 <20141023074739.GH13512@nuc-i3427.alporthouse.com>
 <CAMou1-3n5pC4C_7x_5oxz0WG3sOifKvG-wCER_5g6VeniEJ=6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMou1-3n5pC4C_7x_5oxz0WG3sOifKvG-wCER_5g6VeniEJ=6A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 03:33:14AM +0100, Robert Bragg wrote:
> On Thu, Oct 23, 2014 at 8:47 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> > On Wed, Oct 22, 2014 at 04:28:51PM +0100, Robert Bragg wrote:
> >> +     /* XXX: Not sure that this is really acceptable...
> >> +      *
> >> +      * i915_gem_context.c currently owns pinning/unpinning legacy
> >> +      * context buffers and although that code has a
> >> +      * get_context_alignment() func to handle a different
> >> +      * constraint for gen6 we are assuming it's fixed for gen7
> >> +      * here. Another option besides pinning here would be to
> >> +      * instead hook into context switching and update the
> >> +      * OACONTROL configuration on the fly.
> >> +      */
> >> +     if (dev_priv->oa_pmu.specific_ctx) {
> >> +             struct intel_context *ctx = dev_priv->oa_pmu.specific_ctx;
> >> +             int ret;
> >> +
> >> +             ret = i915_gem_obj_ggtt_pin(ctx->legacy_hw_ctx.rcs_state,
> >> +                                         4096, 0);
> >
> > Right if you pin it here with a different alignment, when we try to  pin
> > it with the required hw ctx alignment it will fail. Easiest way is to
> > record the ctx->legacy_hw_ctx.alignment and reuse that here.
> 
> Ok I can look into that a bit more. I'm not currently sure I can assume the
> ctx will have been pinned before, to be able to record the alignment.
> Skimming i915_gem_context.c, it looks like we only pin the default context
> on creation and a user could open a perf even before we first switch to that
> context.
> 
> I wonder if it would be ok to expose an i915_get_context_alignment() api to
> deal with this?

I would either add intel_context_pin_state()/unpin_state() or expose
ctx->...state_alignment. Leaning towards the former so that we don't have
too many places mucking around inside ctx.

> >
> >> +             if (ret) {
> >> +                     DRM_DEBUG_DRIVER("Couldn't pin %d\n", ret);
> >> +                     ret = -EBUSY;
> >
> > As an exercise, think of all the possible error values from pin() and
> > tell me why overriding that here is a bad, bad idea.
> 
> Hmm, I'm not quite sure why I decided to squash the error code there, it
> looks pretty arbitrary. My take on your comment a.t.m is essentially that
> some of the pin() errors don't really represent a busy state where it would
> make sense for userspace to try again later; such as -ENODEV. Sorry if you
> saw a very specific case that offended you :-) I have removed the override
> locally.

Or EINTR/EAGAIN and try again immediately. ;)
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
