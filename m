Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783Ab3CES26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 13:28:58 -0500
Received: from mga14.intel.com ([143.182.124.37]:15410 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756385Ab3CES24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 13:28:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,788,1355126400"; 
   d="scan'208";a="209158268"
Message-ID: <1362508124.29083.15.camel@intelbox>
Subject: Re: [Intel-gfx] [git pull] drm merge for 3.9-rc1
From: Imre Deak <imre.deak@intel.com>
Reply-To: imre.deak@intel.com
To: Paulo Zanoni <przanoni@gmail.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Sedat Dilek <sedat.dilek@gmail.com>, Dave Airlie <airlied@gmail.com>,
        DRI <dri-devel@lists.freedesktop.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>
Date: Tue, 05 Mar 2013 20:28:44 +0200
In-Reply-To: <CA+gsUGQ-cn00=emFkHeWi6akL9TrJ9CV6ikv7C62fhLYMtB=HQ@mail.gmail.com>
References: <CA+icZUXG7WgRap2-oQGBr_s=QbE0QW6_zChDRqC-eEzrWR3Y5g@mail.gmail.com>
	 <CA+icZUUP0hLjkTjsAGbhoT1QG55X2062G5KCCDsKkhDyM_SQEg@mail.gmail.com>
	 <20130228111819.GF11892@cantiga.alporthouse.com>
	 <CA+gsUGQ-cn00=emFkHeWi6akL9TrJ9CV6ikv7C62fhLYMtB=HQ@mail.gmail.com>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-28 at 11:31 -0300, Paulo Zanoni wrote:
> Hi
> 
> 2013/2/28 Chris Wilson <chris@chris-wilson.co.uk>:
> > On Thu, Feb 28, 2013 at 12:06:28AM +0100, Sedat Dilek wrote:
> >> On Wed, Feb 27, 2013 at 11:36 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> >> > Hi,
> >> >
> >> > I am seeing this also on Linux-Next.
> >> >
> >> > /var/log/kern.log:Feb 27 22:52:35 fambox kernel: [   28.202381]
> >> > [drm:intel_dp_aux_wait_done] *ERROR* dp aux hw did not signal timeout
> >> > (has irq: 1)!
> >> > /var/log/kern.log:Feb 27 22:52:35 fambox kernel: [   28.210588]
> >> > [drm:intel_dp_aux_wait_done] *ERROR* dp aux hw did not signal timeout
> >> > (has irq: 1)!
> >> >
> >> > /var/log/kern.log.1:Feb 22 07:36:04 fambox kernel: [   27.408280]
> >> > [drm:intel_dp_aux_wait_done] *ERROR* dp aux hw did not signal timeout
> >> > (has irq: 1)!
> >> >
> >> > This seems to be hard reproducible...
> >> > Laptop-LCD... Sandybridge Mobile-GT2.
> >> >
> >> > Is there a way to force the error?
> >> >
> >> > Possible patch see [1].
> >> >
> >> > - Sedat -
> >> >
> >> > [1] https://patchwork.kernel.org/patch/2192721/
> >
> > That was:
> >
> > +       if (!done) {
> > +               status = I915_READ_NOTRACE(ch_ctl);
> > +               DRM_ERROR("dp aux hw did not signal timeout (has irq:
> > %i), status=%08x!\n",
> > +                         has_aux_irq, status);
> > +       }
> >
> > You applied
> >
> > +       if (!done) {
> > +               status = I915_READ_NOTRACE(ch_ctl);
> > +               DRM_ERROR("dp aux hw did not signal timeout (has irq:
> > %i), status=%08x!\n",
> > +                         has_aux_irq, status);
> > +       {
> 
> In addition to this, after the problem happens can you please dump the
> registers 0x44008 (DEIIR) and 0xC4008 (SDEIIR)? You can do this either
> by running intel-reg-read (from intel-gpu-tools) or by changing the
> DRM_ERROR above to also print the result of I915_READ(0x44008) and
> I915_READ(0xC4008).
> 
> If you conclude that the value of 0x44008 is 0x0 while the value of
> 0xC4008 is not, then this patch should help:
> https://patchwork.kernel.org/patch/2177841/

I can trigger the bug on an ILK consistently by calling udelay(400) just
before 'I915_WRITE(SDEIIR, pch_iir);' in ironlake_irq_handler() until
the first timeout. Afterwards SDEIIR will contain SDE_AUXD and DEIIR
will be 0 and no more AUXD events will be serviced. With Paolo's patch I
can't trigger the bug even with the udelay being in place.

--Imre

> 
> >
> > That second '{' is the source of the compile error.
> > -Chris
> >
> > --
> > Chris Wilson, Intel Open Source Technology Centre
> > _______________________________________________
> > Intel-gfx mailing list
> > Intel-gfx@lists.freedesktop.org
> > http://lists.freedesktop.org/mailman/listinfo/intel-gfx
> 
> 
> 


