Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760466AbaEMNWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 09:22:08 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:34759 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbaEMNWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 09:22:06 -0400
Date: Tue, 13 May 2014 15:22:00 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: =?iso-8859-1?Q?J=F6rg?= Otte <jrg.otte@gmail.com>
Cc: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= 
	<ville.syrjala@linux.intel.com>,
        Damien Lespiau <damien.lespiau@intel.com>,
        David Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Intel-gfx] [3.14.0-rc4] regression: drm FIFO underruns
Message-ID: <20140513132200.GC3908@phenom.ffwll.local>
Mail-Followup-To: =?iso-8859-1?Q?J=F6rg?= Otte <jrg.otte@gmail.com>,
	Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>,
	Damien Lespiau <damien.lespiau@intel.com>,
	David Airlie <airlied@linux.ie>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Dave Airlie <airlied@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <CAKMK7uG20sF403PJcmWTD=kPF9seV4sXZpp9_hEq3LvV3kK5Hg@mail.gmail.com>
 <CADDKRnB1DCzgjX-q-cgFFW48uT5r5MUcuc5D6chekEET5dFxxA@mail.gmail.com>
 <20140509161438.GH31479@strange.amr.corp.intel.com>
 <20140509170335.GZ18465@intel.com>
 <CADDKRnAiQawK6vi0XO2FDdfGDbcwWQzdeu-rfEU8viJzARO+yQ@mail.gmail.com>
 <CAKMK7uHLSfW0wN-uXMejOcnvaYpZfVSfSh7+NpqAUBCOvbK2eg@mail.gmail.com>
 <CADDKRnCzHQw7_Cr2jpZ7qC50hrdmr0XRaYyMxaOSaqihNGccDA@mail.gmail.com>
 <20140512190300.GF25056@phenom.ffwll.local>
 <CADDKRnAOkdaziCQ_NGkt01hiQqjiAiKza2+QbCuDBuY72LJK=A@mail.gmail.com>
 <CAKMK7uGy3bKdj-B21rCpeF2EPEE4Wi8CxLbDWFBGpLWskoDj3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKMK7uGy3bKdj-B21rCpeF2EPEE4Wi8CxLbDWFBGpLWskoDj3w@mail.gmail.com>
X-Operating-System: Linux phenom 3.14.0+ 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 12:38:41PM +0200, Daniel Vetter wrote:
> On Tue, May 13, 2014 at 12:29 PM, Jörg Otte <jrg.otte@gmail.com> wrote:
> >>> Branch drm-intel-nightly as of
> >>> ed60c27 drm-intel-nightly: 2014y-05m-09d-21h-51m-45s integration manifest
> >>> looks badly:
> >>>    - KDE splash screen on boot-up is not visible
> >>>    - x-windows don't have title and menu bars
> >>>    - KDE system menu is not visible
> >>>    - moving windows around destroys its content
> >>
> >> Ugh, that's ugly. Nothing else change like e.g. the version of
> >> xfree-video-intel?
> >
> >  (II) Loading /usr/lib/xorg/modules/drivers/intel_drv.so
> >  (II) Module intel: vendor="X.Org Foundation"
> >  compiled for 1.11.3, module version = 2.17.0
> >  Module class: X.Org Video Driver
> >  ABI class: X.Org Video Driver, version 11.0
> 
> Chris, any ideas? It's an ivybridge apparently.
> 
> For the fifo underruns I think we've fully confirmed that they only
> happen on boot-up. I'll try to come up with some ideas what could have
> gone wrong there.

Please test the below patch.
-Daniel

diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index b10fbde1d5ee..63ced2dee027 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -427,9 +427,6 @@ bool __intel_set_cpu_fifo_underrun_reporting(struct drm_device *dev,
 
 	ret = !intel_crtc->cpu_fifo_underrun_disabled;
 
-	if (enable == ret)
-		goto done;
-
 	intel_crtc->cpu_fifo_underrun_disabled = !enable;
 
 	if (enable && (INTEL_INFO(dev)->gen < 5 || IS_VALLEYVIEW(dev)))
@@ -441,7 +438,6 @@ bool __intel_set_cpu_fifo_underrun_reporting(struct drm_device *dev,
 	else if (IS_GEN8(dev))
 		broadwell_set_fifo_underrun_reporting(dev, pipe, enable);
 
-done:
 	return ret;
 }
 
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
