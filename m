Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760716AbaCUPLo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 11:11:44 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:38563 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaCUPLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 11:11:36 -0400
Date: Fri, 21 Mar 2014 16:11:31 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>, David Airlie <airlied@linux.ie>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: I915: OOPSes on linux-3.14-rc7
Message-ID: <20140321151131.GC30571@phenom.ffwll.local>
Mail-Followup-To: Peter Senna Tschudin <peter.senna@gmail.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <CA+MoWDoS77tLjmENha9TkrM=-J4EeVHSVZgWEEF7jAfTraRuGQ@mail.gmail.com>
 <20140320211738.GV30571@phenom.ffwll.local>
 <CA+MoWDqjgiBn75QJZsoUPcVxgQNEc5k-t7yjOo-AfbFpNm-qUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+MoWDqjgiBn75QJZsoUPcVxgQNEc5k-t7yjOo-AfbFpNm-qUg@mail.gmail.com>
X-Operating-System: Linux phenom 3.12.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 12:26:51PM +0100, Peter Senna Tschudin wrote:
> On Thu, Mar 20, 2014 at 10:17 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> > On Thu, Mar 20, 2014 at 05:56:20PM +0100, Peter Senna Tschudin wrote:
> >> When Fedora updated the Kernel package from 3.12 to 3.13 my notebook
> >> stopped booting (Kernel freezes) when a 2560 x 1440 high res monitor
> >> is attached. I have tried using 3.13.6 from kernel.org and the problem
> >> persists. The problem can be partially solved by passing nomodeset to
> >> Kernel which will make the Kernel to boot, but the screens never comes
> >> to life. When using 3.14-rc7 it boots again, the screen works, but
> >> with some oops messages.
> >>
> >> How can I help fixing this issue?
> >>
> >> I've reported te bug at:
> >> https://bugzilla.redhat.com/show_bug.cgi?id=1072557
> >
> > For the oops message (well it's just a WARNING, a real oops would kill
> > your driver for real) please file a bug report on bugs.freedesktop.org
> > against dri -> drm (intel).
> >
> > The information we need is the full dmesg fore the entire boot when
> > enabling drm.debug=0xe on the kernel cmdline.
> It is attached.
> 
> >
> > For the boot hang you've reported on the redhat bz if you want to move it
> > forward I suggest to do a reverse bisect betwen 3.13 and 3.14-rc7 to
> > figure out which bug _fixed_ your problem and then tell me that. I'll
> > submit it for backporting to stable kernels. Google should find you some
> > nice howtos for reverse bisecting kerneels.
> Thank you. I'll do that.

It's an issue with our fastboot clock readout code. Please apply the below
patch and add an updated dmesg (again with drm.debug=0xe) to your bug
report.
-Daniel

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 7be5984431bb..3c0f8f095a6b 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -450,6 +450,8 @@ static void i9xx_clock(int refclk, intel_clock_t *clock)
 {
 	clock->m = i9xx_dpll_compute_m(clock);
 	clock->p = clock->p1 * clock->p2;
+	printk("p1 = %u, p2 = %u, n = %u\n", clock->p1, clock->p2,
+	       clock->n);
 	if (WARN_ON(clock->n + 2 == 0 || clock->p == 0))
 		return;
 	clock->vco = DIV_ROUND_CLOSEST(refclk * clock->m, clock->n + 2);
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
