Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895Ab3FNGqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 02:46:44 -0400
Received: from mga14.intel.com ([143.182.124.37]:29473 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344Ab3FNGqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 02:46:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,863,1363158000"; 
   d="scan'208";a="316879139"
Message-ID: <51BABC6F.3050201@intel.com>
Date: Fri, 14 Jun 2013 14:47:11 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: linux-acpi@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>, daniel.vetter@ffwll.ch,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
        Aaron Lu <aaron.lwe@gmail.com>, Alex Deucher <alexdeucher@gmail.com>
Subject: Re: [PATCH 3/3] i915: Don't provide ACPI backlight interface if firmware
 expects Windows 8
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com> <1370818899-8595-4-git-send-email-matthew.garrett@nebula.com>
In-Reply-To: <1370818899-8595-4-git-send-email-matthew.garrett@nebula.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2013 07:01 AM, Matthew Garrett wrote:
> Windows 8 leaves backlight control up to individual graphics drivers rather
> than making ACPI calls itself. There's plenty of evidence to suggest that
> the Intel driver for Windows doesn't use the ACPI interface, including the
> fact that it's broken on a bunch of machines when the OS claims to support
> Windows 8. The simplest thing to do appears to be to disable the ACPI
> backlight interface on these systems.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
> ---
>  drivers/gpu/drm/i915/i915_dma.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
> index 3b315ba..23b6292 100644
> --- a/drivers/gpu/drm/i915/i915_dma.c
> +++ b/drivers/gpu/drm/i915/i915_dma.c
> @@ -1661,6 +1661,9 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
>  		/* Must be done after probing outputs */
>  		intel_opregion_init(dev);
>  		acpi_video_register();
> +		/* Don't use ACPI backlight functions on Windows 8 platforms */
> +		if (acpi_osi_version() >= ACPI_OSI_WIN_8)
> +			acpi_video_backlight_unregister();

What about the platform driver created backlight interface? Oh right,
thinkpad_acpi will not create backlight interface for them since they
are not in DMI table, so acpi_video_backlight_support() will return
true and thinkspad_acpi thinks ACPI video driver is controlling
backlight so it will not create backlight interface for them.

Then we will need to remember not to add any of those systems into
the DMI table of video_detect.c, or thinkpad_acpi module will create
backlight interface for them and according to reporter, that interface
does not work either.

What about a priority based solution? We can introduce a new field named
priority to backlight_device and instead of calling another module's
function like the unregister one here(which cause unnecessary module
dependency), we only need to boost priority for its own interface. This
field will be exported to sysfs, so user can change it during runtime
too. And we can also introduce a new kernel command line as
backlight.force_interface=raw/firmware/platform, to overcome the limited
functionality provided by acpi_backlight=video/vendor, which does not
involve GPU's interface.

And we can place the quirk code in backlight layer instead of individual
backlight functionality provider module. Suppose we have a backlight
manager there, for all win8 systems, we can boost the raw type's
priority on its registration, so no need to add code in
intel/amd/etc./'s GPU driver code.

With priority based solution, all backlight control interfaces stay,
the priority field is an indication given by kernel to user space.

For a complete description on backlight control background and the
proposed solution, please take a look at:
https://gist.github.com/aaronlu/5779828

It would be good to know your opinions, thanks.

-Aaron
