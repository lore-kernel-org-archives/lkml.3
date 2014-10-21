Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933680AbaJUUt4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 16:49:56 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53655 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933095AbaJUUty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 16:49:54 -0400
Date: Tue, 21 Oct 2014 13:50:07 -0700
From: Darren Hart <dvhart@infradead.org>
To: Jani Nikula <jani.nikula@intel.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linuxppc-dev@lists.ozlabs.org, platform-driver-x86@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jens Frederich <jfrederich@gmail.com>, Daniel Drake <dsd@laptop.org>,
        Jon Nettleton <jon.nettleton@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: [PATCH] drivers: depend on instead of select
 BACKLIGHT_CLASS_DEVICE and ACPI_VIDEO
Message-ID: <20141021205006.GC20951@vmdeb7>
References: <1413580403-16225-1-git-send-email-jani.nikula@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413580403-16225-1-git-send-email-jani.nikula@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 18, 2014 at 12:13:23AM +0300, Jani Nikula wrote:
> Documentation/kbuild/kconfig-language.txt warns to use select with care,
> and in general use select only for non-visible symbols and for symbols
> with no dependencies, because select will force a symbol to a value
> without visiting the dependencies.
> 
> Select has become particularly problematic, interdependently, with the
> BACKLIGHT_CLASS_DEVICE and ACPI_VIDEO configs. For example:
> 
> scripts/kconfig/conf --randconfig Kconfig
> KCONFIG_SEED=0x48312B00
> warning: (DRM_RADEON && DRM_NOUVEAU && DRM_I915 && DRM_GMA500 &&
> DRM_SHMOBILE && DRM_TILCDC && FB_BACKLIGHT && FB_MX3 && USB_APPLEDISPLAY
> && FB_OLPC_DCON && ASUS_LAPTOP && SONY_LAPTOP && THINKPAD_ACPI &&
> EEEPC_LAPTOP && ACPI_CMPC && SAMSUNG_Q10) selects BACKLIGHT_CLASS_DEVICE
> which has unmet direct dependencies (HAS_IOMEM && BACKLIGHT_LCD_SUPPORT)
> warning: (DRM_RADEON && DRM_NOUVEAU && DRM_I915 && DRM_GMA500 &&
> DRM_SHMOBILE && DRM_TILCDC && FB_BACKLIGHT && FB_MX3 && USB_APPLEDISPLAY
> && FB_OLPC_DCON && ASUS_LAPTOP && SONY_LAPTOP && THINKPAD_ACPI &&
> EEEPC_LAPTOP && ACPI_CMPC && SAMSUNG_Q10) selects BACKLIGHT_CLASS_DEVICE
> which has unmet direct dependencies (HAS_IOMEM && BACKLIGHT_LCD_SUPPORT)
> 
> With tristates it's possible to end up selecting FOO=y depending on
> BAR=m in the config, which gets discovered at build time, not config
> time, like reported in the thread referenced below.
> 
> Do the following to fix the dependencies:
> 
> * Depend on instead of select BACKLIGHT_CLASS_DEVICE everywhere. Drop
>   select BACKLIGHT_LCD_SUPPORT in such cases, as it's a dependency of
>   BACKLIGHT_CLASS_DEVICE.
> 
> * Remove config FB_BACKLIGHT altogether, and replace it with a
>   dependency on BACKLIGHT_CLASS_DEVICE. All configs selecting
>   FB_BACKLIGHT select or depend on FB anyway, so we can simplify.
> 
> * Depend on (ACPI && ACPI_VIDEO) || ACPI=n in several places instead of
>   selecting ACPI_VIDEO and a number of its dependencies if ACPI is
>   enabled. This is tied to backlight, as ACPI_VIDEO depends on
>   BACKLIGHT_CLASS_DEVICE.
> 
> * Replace a couple of select INPUT/VT with depends as it seemed to be
>   necessary.
> 
> Reference: http://lkml.kernel.org/r/CA+r1ZhhmT4DrWtf6MbRQo5EqXwx+LxCqh15Vsu_d9WpftLhnxw@mail.gmail.com
> Reported-by: Jim Davis <jim.epost@gmail.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: David Airlie <airlied@linux.ie>
> Cc: Daniel Vetter <daniel.vetter@intel.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Darren Hart <dvhart@infradead.org>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Jens Frederich <jfrederich@gmail.com>
> Cc: Daniel Drake <dsd@laptop.org>
> Cc: Jon Nettleton <jon.nettleton@gmail.com>
> Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Signed-off-by: Jani Nikula <jani.nikula@intel.com>

As for the drivers/platform/x86/Kconfig:

Acked-by: Darren Hart <dvhart@linux.intel.com>

Thanks,

-- 
Darren Hart
Intel Open Source Technology Center
