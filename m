Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbaJ0L7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 07:59:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:61747 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688AbaJ0L7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 07:59:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,795,1406617200"; 
   d="scan'208";a="596862642"
From: Jani Nikula <jani.nikula@intel.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linuxppc-dev@lists.ozlabs.org,
        platform-driver-x86@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-fbdev@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <dvhart@infradead.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jens Frederich <jfrederich@gmail.com>, Daniel Drake <dsd@laptop.org>,
        Jon Nettleton <jon.nettleton@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Jingoo Han <jg1.han@samsung.com>, Bryan Wu <cooloney@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH] drivers: depend on instead of select BACKLIGHT_CLASS_DEVICE and ACPI_VIDEO
In-Reply-To: <54476492.6090105@ti.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <1413580403-16225-1-git-send-email-jani.nikula@intel.com> <54476492.6090105@ti.com>
User-Agent: Notmuch/0.18.1+133~g83c61fa (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 27 Oct 2014 13:59:31 +0200
Message-ID: <87a94hu3j0.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2014, Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:
> On 18/10/14 00:13, Jani Nikula wrote:
>> Documentation/kbuild/kconfig-language.txt warns to use select with care,
>> and in general use select only for non-visible symbols and for symbols
>> with no dependencies, because select will force a symbol to a value
>> without visiting the dependencies.
>> 
>> Select has become particularly problematic, interdependently, with the
>> BACKLIGHT_CLASS_DEVICE and ACPI_VIDEO configs. For example:
>> 
>> scripts/kconfig/conf --randconfig Kconfig
>> KCONFIG_SEED=0x48312B00
>> warning: (DRM_RADEON && DRM_NOUVEAU && DRM_I915 && DRM_GMA500 &&
>> DRM_SHMOBILE && DRM_TILCDC && FB_BACKLIGHT && FB_MX3 && USB_APPLEDISPLAY
>> && FB_OLPC_DCON && ASUS_LAPTOP && SONY_LAPTOP && THINKPAD_ACPI &&
>> EEEPC_LAPTOP && ACPI_CMPC && SAMSUNG_Q10) selects BACKLIGHT_CLASS_DEVICE
>> which has unmet direct dependencies (HAS_IOMEM && BACKLIGHT_LCD_SUPPORT)
>> warning: (DRM_RADEON && DRM_NOUVEAU && DRM_I915 && DRM_GMA500 &&
>> DRM_SHMOBILE && DRM_TILCDC && FB_BACKLIGHT && FB_MX3 && USB_APPLEDISPLAY
>> && FB_OLPC_DCON && ASUS_LAPTOP && SONY_LAPTOP && THINKPAD_ACPI &&
>> EEEPC_LAPTOP && ACPI_CMPC && SAMSUNG_Q10) selects BACKLIGHT_CLASS_DEVICE
>> which has unmet direct dependencies (HAS_IOMEM && BACKLIGHT_LCD_SUPPORT)
>> 
>> With tristates it's possible to end up selecting FOO=y depending on
>> BAR=m in the config, which gets discovered at build time, not config
>> time, like reported in the thread referenced below.
>> 
>> Do the following to fix the dependencies:
>> 
>> * Depend on instead of select BACKLIGHT_CLASS_DEVICE everywhere. Drop
>>   select BACKLIGHT_LCD_SUPPORT in such cases, as it's a dependency of
>>   BACKLIGHT_CLASS_DEVICE.
>> 
>> * Remove config FB_BACKLIGHT altogether, and replace it with a
>>   dependency on BACKLIGHT_CLASS_DEVICE. All configs selecting
>>   FB_BACKLIGHT select or depend on FB anyway, so we can simplify.
>> 
>> * Depend on (ACPI && ACPI_VIDEO) || ACPI=n in several places instead of
>>   selecting ACPI_VIDEO and a number of its dependencies if ACPI is
>>   enabled. This is tied to backlight, as ACPI_VIDEO depends on
>>   BACKLIGHT_CLASS_DEVICE.
>> 
>> * Replace a couple of select INPUT/VT with depends as it seemed to be
>>   necessary.
>
> While doing 'depends on' instead of 'select' is an "easy" fix for this,
> I do dislike it quite a bit. It's a major pain to go around the kernel
> config, trying to find all the dependencies that a particular driver
> wants. If I need fb-foobar, I should just be able to enable it, instead
> of first searching and selecting its minor dependencies individually.

Agreed, but I don't think that's specific to this patch.

> So, not a NACK, but a "isn't there an another way to fix this?".

I think the real answer would be to fix kconfig to also show menu items
whose dependencies are not met, and then recursively enabling the
dependencies when the item is enabled. Beyond my scope.

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

I think it should be possible to choose between y and m when it's
selected, and it should be possible to enable it when it's not selected
by any drivers. I'm not sure a hidden option is good for that.

> That doesn't exactly fix anything, but I think it makes sense as
> BACKLIGHT_CLASS_DEVICE is something that's selected from all around the
> kernel, so it should be a selectable "library" instead of a Kconfig menu
> option.

At least for drm/i915 BACKLIGHT_CLASS_DEVICE is "an option". We use it
if it's enabled, but we are just fine if it's not. I've learned the way
to express that is

	depends on BACKLIGHT_CLASS_DEVICE || BACKLIGHT_CLASS_DEVICE=n

but I don't think there's a way to express that in terms of select, is
there? The dependency above guarantees there's no DRM_I915=y and
BACKLIGHT_CLASS_DEVICE=m combo which would fail. And this, btw, is where
this whole patch got started, as select didn't handle that properly.

> I didn't look at the ACPI_VIDEO side, so no idea how messy that is.

Basically it's another dependency on BACKLIGHT_CLASS_DEVICE. I can only
imagine trying to solve this problem with select is going to end up in
recursive dependencies that spread out and need changing about as wide
as this patch.

In the end, I agree with the problem you have with this patch, but yet I
think it's the right thing to do in terms of expressing the
dependencies.


BR,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
