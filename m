Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745Ab3GEWNt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 18:13:49 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:59867 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018Ab3GEWNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 18:13:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: daniel.vetter@ffwll.ch, linux-acpi@vger.kernel.org,
        seth.forshee@canonical.com, joeyli.kernel@gmail.com,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, lenb@kernel.org
Subject: Re: [PATCH 3/3] i915: Don't provide ACPI backlight interface if firmware expects Windows 8
Date: Sat, 06 Jul 2013 00:23:26 +0200
Message-ID: <2962350.laXfENfrac@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <2888060.4Smt6Tu6bv@vostro.rjw.lan>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com> <2759570.WXymCRumvH@vostro.rjw.lan> <2888060.4Smt6Tu6bv@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 05, 2013 11:40:02 PM Rafael J. Wysocki wrote:
> On Friday, July 05, 2013 10:00:55 PM Rafael J. Wysocki wrote:
> > On Friday, July 05, 2013 02:20:14 PM Rafael J. Wysocki wrote:
> > > On Sunday, June 09, 2013 07:01:39 PM Matthew Garrett wrote:
> > > > Windows 8 leaves backlight control up to individual graphics drivers rather
> > > > than making ACPI calls itself. There's plenty of evidence to suggest that
> > > > the Intel driver for Windows doesn't use the ACPI interface, including the
> > > > fact that it's broken on a bunch of machines when the OS claims to support
> > > > Windows 8. The simplest thing to do appears to be to disable the ACPI
> > > > backlight interface on these systems.
> > > > 
> > > > Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> > > > ---
> > > >  drivers/gpu/drm/i915/i915_dma.c | 3 +++
> > > >  1 file changed, 3 insertions(+)
> > > > 
> > > > diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
> > > > index 3b315ba..23b6292 100644
> > > > --- a/drivers/gpu/drm/i915/i915_dma.c
> > > > +++ b/drivers/gpu/drm/i915/i915_dma.c
> > > > @@ -1661,6 +1661,9 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
> > > >  		/* Must be done after probing outputs */
> > > >  		intel_opregion_init(dev);
> > > >  		acpi_video_register();
> > > > +		/* Don't use ACPI backlight functions on Windows 8 platforms */
> > > > +		if (acpi_osi_version() >= ACPI_OSI_WIN_8)
> > > > +			acpi_video_backlight_unregister();
> > > >  	}
> > > >  
> > > >  	if (IS_GEN5(dev))
> > > > 
> > > 
> > > Well, this causes build failures to happen when the ACPI video driver is
> > > modular and the graphics driver is not.
> > > 
> > > I'm not sure how to resolve that, so suggestions are welcome.
> > 
> > Actually, that happened with the radeon patch.
> > 
> > That said, ACPI_OSI_WIN_8 doesn't make much sense for !CONFIG_ACPI, for
> > example.
> > 
> > What about making acpi_video_register() do the quirk instead?  We could add an
> > argument to it indicating whether or not quirks should be applied.
> 
> Actually, I wonder what about the appended patch (on top of the Aaron's
> https://patchwork.kernel.org/patch/2812951/) instead of [1-3/3] from this series.

Or even something as simple as this one.

---
 drivers/acpi/video_detect.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-pm/drivers/acpi/video_detect.c
===================================================================
--- linux-pm.orig/drivers/acpi/video_detect.c
+++ linux-pm/drivers/acpi/video_detect.c
@@ -203,6 +203,9 @@ long acpi_video_get_capabilities(acpi_ha
 		 */
 
 		dmi_check_system(video_detect_dmi_table);
+
+		if (acpi_gbl_osi_data >= ACPI_OSI_WIN_8)
+			acpi_video_support |= ACPI_VIDEO_BACKLIGHT_FORCE_VENDOR;
 	} else {
 		status = acpi_bus_get_device(graphics_handle, &tmp_dev);
 		if (ACPI_FAILURE(status)) {

