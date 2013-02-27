Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490Ab3B0KEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 05:04:23 -0500
Received: from mga14.intel.com ([143.182.124.37]:65289 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab3B0KEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 05:04:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,746,1355126400"; 
   d="scan'208";a="206812243"
Date: Wed, 27 Feb 2013 10:04:08 +0000
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Imre Deak <imre.deak@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Subject: Re: [git pull] drm merge for 3.9-rc1
Message-ID: <20130227100408.GA1924@cantiga.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dave Airlie <airlied@linux.ie>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Imre Deak <imre.deak@intel.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	DRI mailing list <dri-devel@lists.freedesktop.org>
References: <alpine.DEB.2.00.1302260003460.24684@skynet.skynet.ie>
 <CA+55aFzRRxTjuQcLhkhfxDWpHEg3EoSY8CMP+v78i+_Z-EkQ1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzRRxTjuQcLhkhfxDWpHEg3EoSY8CMP+v78i+_Z-EkQ1g@mail.gmail.com>
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
> [    8.149931] [drm:intel_dp_aux_ch] *ERROR* dp_aux_ch not done status
> 0xa145003f
> 
> and after that the screen ends up black.
> 
> It's happened twice now, but is not 100% repeatable. It looks like the
> message itself is new,  but the black screen is also new and does seem
> to happen when I get the message, so...

That message appears to be the canary. For whatever reason the DP
transfer is not functioning, likely the VDD is not powered up. However,
the failure to communicate there causes the modeset to abort, resulting
in the blank screen.
 
> The second time I touched the power button, and the machine came back.
> Apparently the suspend/resume cycle made it all magically work: the
> suspend caused the same errors, but then the resume made it all good
> again.

So it is reproducible during suspend. That should help narrow down the
sequence, thank you.
 
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

The hardware is required to return a timedout error message after 400
microseconds. The timeout here is to catch the dysfunction driver, and
so was intended to be 10 milliseconds, cf
https://patchwork.kernel.org/patch/2160541/

As it happens with your machine 10 jiffies is approximately 10
millisecond, and so we should not be aborting before the hardware has
had a chance to signal failure. One way to check whether it is a failure
to setup the IRQ or a failure to setup the DP comms would be:

diff --git a/drivers/gpu/drm/i915/intel_dp.c b/drivers/gpu/drm/i915/intel_dp.c
index 7b8bfe8..f2486f1 100644
--- a/drivers/gpu/drm/i915/intel_dp.c
+++ b/drivers/gpu/drm/i915/intel_dp.c
@@ -356,9 +356,11 @@ intel_dp_aux_wait_done(struct intel_dp *intel_dp, bool has_aux_irq)
 		done = wait_event_timeout(dev_priv->gmbus_wait_queue, C, 10);
 	else
 		done = wait_for_atomic(C, 10) == 0;
-	if (!done)
-		DRM_ERROR("dp aux hw did not signal timeout (has irq: %i)!\n",
-			  has_aux_irq);
+	if (!done) {
+		status = I915_READ_NOTRACE(ch_ctl);
+		DRM_ERROR("dp aux hw did not signal timeout (has irq: %i), status=%08x!\n",
+			  has_aux_irq, status);
+	}
 #undef C
 
 	return status;

-- 
Chris Wilson, Intel Open Source Technology Centre
