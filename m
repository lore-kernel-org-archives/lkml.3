Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbaJWIKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 04:10:43 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:48414 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090AbaJWIK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 04:10:27 -0400
Date: Thu, 23 Oct 2014 10:10:34 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Jani Nikula <jani.nikula@intel.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linuxppc-dev@lists.ozlabs.org,
        platform-driver-x86@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-fbdev@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>,
        Daniel Drake <dsd@laptop.org>, Jens Frederich <jfrederich@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jon Nettleton <jon.nettleton@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Darren Hart <dvhart@infradead.org>,
        Daniel Vetter <daniel.vetter@intel.com>, Bryan Wu <cooloney@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] drivers: depend on instead of select
 BACKLIGHT_CLASS_DEVICE and ACPI_VIDEO
Message-ID: <20141023081034.GA26941@phenom.ffwll.local>
Mail-Followup-To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Jani Nikula <jani.nikula@intel.com>, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linuxppc-dev@lists.ozlabs.org,
	platform-driver-x86@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-fbdev@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>,
	Daniel Drake <dsd@laptop.org>,
	Jens Frederich <jfrederich@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jon Nettleton <jon.nettleton@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Darren Hart <dvhart@infradead.org>,
	Daniel Vetter <daniel.vetter@intel.com>,
	Bryan Wu <cooloney@gmail.com>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Lee Jones <lee.jones@linaro.org>
References: <1413580403-16225-1-git-send-email-jani.nikula@intel.com>
 <54476492.6090105@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54476492.6090105@ti.com>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 11:02:26AM +0300, Tomi Valkeinen wrote:
> On 18/10/14 00:13, Jani Nikula wrote:
> > Documentation/kbuild/kconfig-language.txt warns to use select with care,
> > and in general use select only for non-visible symbols and for symbols
> > with no dependencies, because select will force a symbol to a value
> > without visiting the dependencies.
> > 
> > Select has become particularly problematic, interdependently, with the
> > BACKLIGHT_CLASS_DEVICE and ACPI_VIDEO configs. For example:
> > 
> > scripts/kconfig/conf --randconfig Kconfig
> > KCONFIG_SEED=0x48312B00
> > warning: (DRM_RADEON && DRM_NOUVEAU && DRM_I915 && DRM_GMA500 &&
> > DRM_SHMOBILE && DRM_TILCDC && FB_BACKLIGHT && FB_MX3 && USB_APPLEDISPLAY
> > && FB_OLPC_DCON && ASUS_LAPTOP && SONY_LAPTOP && THINKPAD_ACPI &&
> > EEEPC_LAPTOP && ACPI_CMPC && SAMSUNG_Q10) selects BACKLIGHT_CLASS_DEVICE
> > which has unmet direct dependencies (HAS_IOMEM && BACKLIGHT_LCD_SUPPORT)
> > warning: (DRM_RADEON && DRM_NOUVEAU && DRM_I915 && DRM_GMA500 &&
> > DRM_SHMOBILE && DRM_TILCDC && FB_BACKLIGHT && FB_MX3 && USB_APPLEDISPLAY
> > && FB_OLPC_DCON && ASUS_LAPTOP && SONY_LAPTOP && THINKPAD_ACPI &&
> > EEEPC_LAPTOP && ACPI_CMPC && SAMSUNG_Q10) selects BACKLIGHT_CLASS_DEVICE
> > which has unmet direct dependencies (HAS_IOMEM && BACKLIGHT_LCD_SUPPORT)
> > 
> > With tristates it's possible to end up selecting FOO=y depending on
> > BAR=m in the config, which gets discovered at build time, not config
> > time, like reported in the thread referenced below.
> > 
> > Do the following to fix the dependencies:
> > 
> > * Depend on instead of select BACKLIGHT_CLASS_DEVICE everywhere. Drop
> >   select BACKLIGHT_LCD_SUPPORT in such cases, as it's a dependency of
> >   BACKLIGHT_CLASS_DEVICE.
> > 
> > * Remove config FB_BACKLIGHT altogether, and replace it with a
> >   dependency on BACKLIGHT_CLASS_DEVICE. All configs selecting
> >   FB_BACKLIGHT select or depend on FB anyway, so we can simplify.
> > 
> > * Depend on (ACPI && ACPI_VIDEO) || ACPI=n in several places instead of
> >   selecting ACPI_VIDEO and a number of its dependencies if ACPI is
> >   enabled. This is tied to backlight, as ACPI_VIDEO depends on
> >   BACKLIGHT_CLASS_DEVICE.
> > 
> > * Replace a couple of select INPUT/VT with depends as it seemed to be
> >   necessary.
> 
> While doing 'depends on' instead of 'select' is an "easy" fix for this,
> I do dislike it quite a bit. It's a major pain to go around the kernel
> config, trying to find all the dependencies that a particular driver
> wants. If I need fb-foobar, I should just be able to enable it, instead
> of first searching and selecting its minor dependencies individually.
> 
> So, not a NACK, but a "isn't there an another way to fix this?".
> 
> Looking at backlight... BACKLIGHT_LCD_SUPPORT seems to be a "meta"
> option, it only enables a Kconfig submenu.
> 
> So I think we could just remove the whole BACKLIGHT_LCD_SUPPORT option.
> But if we do that, all the items in drivers/video/backlight/Kconfig with
> default 'y' or 'm' would get enabled by default, so I think we should
> remove the 'default's from that file. That makes sense in any case, as I
> don't see why "HP Jornada 700 series LCD Driver" should be "default y".
> 
> BACKLIGHT_CLASS_DEVICE doesn't depend on anything except
> BACKLIGHT_LCD_SUPPORT, so after removing BACKLIGHT_LCD_SUPPORT it should
> be safe to 'select' BACKLIGHT_CLASS_DEVICE.
> 
> BACKLIGHT_CLASS_DEVICE could be made a hidden option, and the drivers in
> drivers/video/backlight/Kconfig which are under BACKLIGHT_CLASS_DEVICE
> could be made to select BACKLIGHT_CLASS_DEVICE instead.
> 
> That doesn't exactly fix anything, but I think it makes sense as
> BACKLIGHT_CLASS_DEVICE is something that's selected from all around the
> kernel, so it should be a selectable "library" instead of a Kconfig menu
> option.
> 
> I didn't look at the ACPI_VIDEO side, so no idea how messy that is.

If we want to make BACKLIGHT_CLASS_DEVICE into a library thing then I
guess we could do that, but we must then also drag it out of all the other
meta options to make sure it's always available. No need I think to ditch
the entire BACKLIGHT_LCD_SUPPORT meta option. And then everyone could
select it.

The problem is if you mix depends and select Kconfig falls over and starts
to see loops where there are none. So you really can't ever mix them for
the same symbol.

I think if we get the BACKLIGHT_CLASS_DEVICE out of the picture with that
ACPI_VIDEO should be fixable with some

	select ACPI_VIDEO if ACPI

or so. Currently that doesn't work because of the backlight class knob and
select being broken.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
