Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777AbaI2HQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 03:16:36 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:59111 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbaI2HQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 03:16:34 -0400
Date: Mon, 29 Sep 2014 09:16:26 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Aaron Lu <aaron.lu@intel.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] ACPI / i915: Update the condition to ignore firmware
 backlight change request
Message-ID: <20140929071606.GA4109@phenom.ffwll.local>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Aaron Lu <aaron.lu@intel.com>,
	Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jani Nikula <jani.nikula@linux.intel.com>,
	David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org
References: <201409232206.02819@pali>
 <201409251623.45636@pali>
 <5424CFB0.4080102@intel.com>
 <5560330.d2v72ZBmJs@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5560330.d2v72ZBmJs@vostro.rjw.lan>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 11:52:09PM +0200, Rafael J. Wysocki wrote:
> On Friday, September 26, 2014 10:30:08 AM Aaron Lu wrote:
> > Some of the Thinkpads' firmware will issue a backlight change request
> > through i915 operation region unconditionally on AC plug/unplug, the
> > backlight level used is arbitrary and thus should be ignored. This is
> > handled by commit 0b9f7d93ca61 (ACPI / i915: ignore firmware requests
> > for backlight change). Then there is a Dell laptop whose vendor backlight
> > interface also makes use of operation region to change backlight level
> > and with the above commit, that interface no long works. The condition
> > used to ignore the backlight change request from firmware is thus
> > changed to: if the vendor backlight interface is not in use and the ACPI
> > backlight interface is broken, we ignore the requests; oterwise, we keep
> > processing them.
> > 
> > Reference: https://lkml.org/lkml/2014/9/23/854
> > Reported-and-tested-by: Pali Rohár <pali.rohar@gmail.com>
> > Cc: <stable@vger.kernel.org> # v3.16 and later
> > Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> 
> Daniel, any objections?

Nope, ack from my side.
-Daniel

> 
> > ---
> >  drivers/gpu/drm/i915/intel_opregion.c | 16 +++++++++++-----
> >  1 file changed, 11 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/i915/intel_opregion.c b/drivers/gpu/drm/i915/intel_opregion.c
> > index ca52ad2ae7d1..d8de1d5140a7 100644
> > --- a/drivers/gpu/drm/i915/intel_opregion.c
> > +++ b/drivers/gpu/drm/i915/intel_opregion.c
> > @@ -396,6 +396,16 @@ int intel_opregion_notify_adapter(struct drm_device *dev, pci_power_t state)
> >  	return -EINVAL;
> >  }
> >  
> > +/*
> > + * If the vendor backlight interface is not in use and ACPI backlight interface
> > + * is broken, do not bother processing backlight change requests from firmware.
> > + */
> > +static bool should_ignore_backlight_request(void)
> > +{
> > +	return acpi_video_backlight_support() &&
> > +	       !acpi_video_verify_backlight_support();
> > +}
> > +
> >  static u32 asle_set_backlight(struct drm_device *dev, u32 bclp)
> >  {
> >  	struct drm_i915_private *dev_priv = dev->dev_private;
> > @@ -404,11 +414,7 @@ static u32 asle_set_backlight(struct drm_device *dev, u32 bclp)
> >  
> >  	DRM_DEBUG_DRIVER("bclp = 0x%08x\n", bclp);
> >  
> > -	/*
> > -	 * If the acpi_video interface is not supposed to be used, don't
> > -	 * bother processing backlight level change requests from firmware.
> > -	 */
> > -	if (!acpi_video_verify_backlight_support()) {
> > +	if (should_ignore_backlight_request()) {
> >  		DRM_DEBUG_KMS("opregion backlight request ignored\n");
> >  		return 0;
> >  	}
> > 
> 
> -- 
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.

-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
