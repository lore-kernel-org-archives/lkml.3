Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbaIYTjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 15:39:00 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:53915 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751162AbaIYTi6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 15:38:58 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: Re: ACPI/i915: Cannot configure display brightness on Dell Latitude E6440
Date: Thu, 25 Sep 2014 21:58:48 +0200
Message-ID: <1481425.msp1jP3vqe@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <542388D7.1010008@intel.com>
References: <201409232206.02819@pali> <201409242021.10107@pali> <542388D7.1010008@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 25, 2014 11:15:35 AM Aaron Lu wrote:
> Hi Hans,
> 
> Thanks for following up and explaining the situation to Pali.
> 
> On 09/25/2014 02:21 AM, Pali Rohár wrote:
> > On Wednesday 24 September 2014 16:34:21 Hans de Goede wrote:
> >> Ok, so the dell-laptop interface is just an obsolete wrapper
> >> around the i915 opregion code, which shows that the right
> >> interface to use is the i915 one, which we do if you don't
> >> specify any kernel commandline parameters, case closed.
> >>
> >> Regards,
> >>
> >> Hans
> > 
> > Nope, its not closed.
> > 
> > Still i915 interface has problem with setting backlight. It 
> > exports lot of levels which turning display off. Which breaking 
> > exiting applications for configuring display brightness. This is 
> > still big regression as black screen is not want people want to 
> > see.
> > 
> > Driver dell-laptop has exported only few - not thousands level 
> > (which is insane) and only usefull levels (not lot of levels 
> > which turn display off).
> > 
> > So for this reason using i915 backlight interface is not possible 
> > and also Dell (for E6440) set kernel param acpi_backlight=vendor 
> > to use dell_laptop module for controlling brightness.
> > 
> > On my laptop E6440 is better for using dell-laptop and not acpi 
> > or i915.
> 
> Hi Pali,
> 
> Please test this patch:
> 
> diff --git a/drivers/gpu/drm/i915/intel_opregion.c b/drivers/gpu/drm/i915/intel_opregion.c
> index ca52ad2ae7d1..15534345bd57 100644
> --- a/drivers/gpu/drm/i915/intel_opregion.c
> +++ b/drivers/gpu/drm/i915/intel_opregion.c
> @@ -396,6 +396,24 @@ int intel_opregion_notify_adapter(struct drm_device *dev, pci_power_t state)
>  	return -EINVAL;
>  }
>  
> +/*
> + * Some of the Thinkpads' firmware will issue a backlight change operation
> + * region request unconditionally on AC plug/unplug, this is undesirable and
> + * should be ignored. Then there is a Dell laptop whose vendor backlight
> + * interface also makes use of operation region request to change backlight
> + * level and we have to keep it work. The rule used here is: if the vendor
> + * backlight interface is not in use and the ACPI backlight interface is
> + * broken, we ignore the requests; oterwise, we keep processing them.
> + */
> +static bool should_ignore_backlight_request(void)
> +{
> +	if (acpi_video_backlight_support() &&
> +	    !acpi_video_verify_backlight_support())
> +		return true;
> +
> +	return false;
> +}

Well, what about

	return acpi_video_backlight_support() && !acpi_video_verify_backlight_support();

?

> +
>  static u32 asle_set_backlight(struct drm_device *dev, u32 bclp)
>  {
>  	struct drm_i915_private *dev_priv = dev->dev_private;
> @@ -404,11 +422,7 @@ static u32 asle_set_backlight(struct drm_device *dev, u32 bclp)
>  
>  	DRM_DEBUG_DRIVER("bclp = 0x%08x\n", bclp);
>  
> -	/*
> -	 * If the acpi_video interface is not supposed to be used, don't
> -	 * bother processing backlight level change requests from firmware.
> -	 */
> -	if (!acpi_video_verify_backlight_support()) {
> +	if (should_ignore_backlight_request()) {
>  		DRM_DEBUG_KMS("opregion backlight request ignored\n");
>  		return 0;
>  	}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
