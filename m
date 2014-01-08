Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbaAHSn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 13:43:29 -0500
Received: from mga09.intel.com ([134.134.136.24]:53188 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbaAHSn1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 13:43:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,625,1384329600"; 
   d="scan'208";a="463666529"
Date: Wed, 8 Jan 2014 20:43:23 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [Intel-gfx] Excessive WARN()s in Intel 915 driver
Message-ID: <20140108184323.GL4800@intel.com>
References: <CAKMK7uFEzOKYjojVop1ouRsJWyeK-rnKH-udBxZcc9fwKCOV6w@mail.gmail.com>
 <Pine.LNX.4.44L0.1401081102040.1659-100000@iolanthe.rowland.org>
 <20140108161713.GT4770@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140108161713.GT4770@phenom.ffwll.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 05:17:13PM +0100, Daniel Vetter wrote:
> On Wed, Jan 08, 2014 at 11:08:08AM -0500, Alan Stern wrote:
> > On Tue, 7 Jan 2014, Daniel Vetter wrote:
> > 
> > > I really want users to report these issues, and excessive WARNs seems
> > > to be the only way to get those reports. Please boot with
> > > drm.debug=0xe added to your kernel cmdline and reproduce this issues.
> > > Also, which precise kernel are you running? Testing latest -rc is
> > > always recommended, this state checker code is fairly new and gets
> > > constantly extended and bugs fixed ...
> > 
> > Here you go.  This is the dmesg output after booting with
> > drm.debug=0xe.  Pay no attention to the "AS" suffix in the version
> > string; this is pristine 3.13-rc7.
> 
> That's strange, I've thought we've fixed the last struggling mismatch in
> the lvds borber bits stuff. Can you please try latest drm-intel-nightly
> from
> 
> http://cgit.freedesktop.org/~danvet/drm-intel/
> 
> Thanks, Daniel

The log looks fairly clear to me:

1. initially panel fitter is enabled on pipe B, and pipe B is outputting
   to LVDS and VGA. Border is enabled.
2. pipe A gets enabled outputting to LVDS. This will overwrite the
   LVDS border bits
3. pipe B is still active so we do the state check, but as the LVDS
   border bits have been clobbered earlier, the state checker gets
   angry

This actually hits another problem we still have. We've changing the
pipe for the LVDS port w/o shutting the port down in between. That
doesn't sound entirely safe. I wonder if we still have some real
issues preventing this change?

         * intel_modeset_setup_hw_state does not.
         */
        *modeset_pipes &= 1 << intel_crtc->pipe;
-       *prepare_pipes &= 1 << intel_crtc->pipe;
 
        DRM_DEBUG_KMS("set mode pipe masks: modeset: %x, prepare: %x, disable: %x\n",
                      *modeset_pipes, *prepare_pipes, *disable_pipes);

-- 
Ville Syrjälä
Intel OTC
