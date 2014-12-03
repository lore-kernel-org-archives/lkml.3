Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaLCK2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 05:28:20 -0500
Received: from mga14.intel.com ([192.55.52.115]:14045 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbaLCK2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 05:28:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="424484303"
Message-ID: <1417602494.2642.0.camel@intelbox>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: compute wait_ioctl timeout
 correctly
From: Imre Deak <imre.deak@intel.com>
Reply-To: imre.deak@intel.com
To: Daniel Vetter <daniel@ffwll.ch>
Cc: John Stultz <john.stultz@linaro.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 03 Dec 2014 12:28:14 +0200
In-Reply-To: <20141203092216.GZ32117@phenom.ffwll.local>
References: <1417533733-2289-1-git-send-email-daniel.vetter@ffwll.ch>
	 <1417534582-2977-1-git-send-email-daniel.vetter@ffwll.ch>
	 <20141202163506.GG18921@nuc-i3427.alporthouse.com>
	 <CALAqxLUCD7zxyNrZJnKUE3wbORyZez-bDvScGLXyTjVvvZdinA@mail.gmail.com>
	 <20141203092216.GZ32117@phenom.ffwll.local>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-03 at 10:22 +0100, Daniel Vetter wrote:
> On Tue, Dec 02, 2014 at 08:54:13AM -0800, John Stultz wrote:
> > On Tue, Dec 2, 2014 at 8:35 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> > > On Tue, Dec 02, 2014 at 04:36:22PM +0100, Daniel Vetter wrote:
> > >> +static inline unsigned long nsecs_to_jiffies_timeout(const u64 m)
> > >> +{
> > >> +     u64 usecs = div_u64(m + 999, 1000);
> > >> +     unsigned long j = usecs_to_jiffies(usecs);
> > >> +
> > >> +     return min_t(unsigned long, MAX_JIFFY_OFFSET, j + 1);
> > >
> > > Or more concisely and review friendly:
> > >
> > > static inline unsigned long nsecs_to_jiffies_timeout(const u64 n)
> > > {
> > >         return min_t(u64, MAX_JIFFY_OFFSET, nsecs_to_jiffies64(n) + 1);
> > > }
> > 
> > Yea. This looks much nicer. Seems generic enough it might be better
> > added next to nsec_to_jiffies64() in kernel/time/time.c or jiffies.h
> > rather then in a driver header.
> > 
> > And clearly the header comment in nsec_to_jiffies() warning its only
> > for the scheduler and not for use for drivers (for exactly the reason
> > of this patch) are not obvious/memorable enough for me and Thomas
> > makes me wonder if we should change its name to be more clear that its
> > a sched only function.
> 
> This bug here isn't about nsect_to_jiffies vs the 64 bit variant, but
> about the +1 that we need to not have a short sleep. In i915 we have a
> bunch of jiffies_timeout functions which do just the +1 compared to the
> versions in time.c because we screwed this up too often.
> 
> Iirc I did float an rfc to move these to time.c once but it resulted in
> some bikeshed fest (no, I'm not going to audit every single user of
> existing _to_jiffies functions). If there's interest I could try again,
> the i915 versions are in drivers/gpu/drm/i915/i915_drv.h.

There was at least this attempt:
https://lkml.org/lkml/2013/5/10/187

--Imre


