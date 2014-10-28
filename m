Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbaJ1U3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 16:29:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:37563 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbaJ1U3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 16:29:21 -0400
Message-ID: <544FFC91.9040104@infradead.org>
Date: Tue, 28 Oct 2014 13:29:05 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Jani Nikula <jani.nikula@intel.com>
CC: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linuxppc-dev@lists.ozlabs.org, platform-driver-x86@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org,
        David Airlie <airlied@linux.ie>,
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
Subject: Re: [PATCH] drivers: depend on instead of select BACKLIGHT_CLASS_DEVICE
 and ACPI_VIDEO
References: <1413580403-16225-1-git-send-email-jani.nikula@intel.com> <54476492.6090105@ti.com> <87a94hu3j0.fsf@intel.com> <544E44E9.4040208@ti.com>
In-Reply-To: <544E44E9.4040208@ti.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/14 06:13, Tomi Valkeinen wrote:
> On 27/10/14 13:59, Jani Nikula wrote:
> 
>>> While doing 'depends on' instead of 'select' is an "easy" fix for this,
>>> I do dislike it quite a bit. It's a major pain to go around the kernel
>>> config, trying to find all the dependencies that a particular driver
>>> wants. If I need fb-foobar, I should just be able to enable it, instead
>>> of first searching and selecting its minor dependencies individually.
>>
>> Agreed, but I don't think that's specific to this patch.
> 
> Well, no, the generic problem is not specific to this patch, but we can
> avoid the issue with proper use of 'select' (at least in some cases),
> which is specific to this patch.
> 
>>> So, not a NACK, but a "isn't there an another way to fix this?".
>>
>> I think the real answer would be to fix kconfig to also show menu items
>> whose dependencies are not met, and then recursively enabling the
>> dependencies when the item is enabled. Beyond my scope.
>>
>>> Looking at backlight... BACKLIGHT_LCD_SUPPORT seems to be a "meta"
>>> option, it only enables a Kconfig submenu.
>>>
>>> So I think we could just remove the whole BACKLIGHT_LCD_SUPPORT option.
>>> But if we do that, all the items in drivers/video/backlight/Kconfig with
>>> default 'y' or 'm' would get enabled by default, so I think we should
>>> remove the 'default's from that file. That makes sense in any case, as I
>>> don't see why "HP Jornada 700 series LCD Driver" should be "default y".
>>>
>>> BACKLIGHT_CLASS_DEVICE doesn't depend on anything except
>>> BACKLIGHT_LCD_SUPPORT, so after removing BACKLIGHT_LCD_SUPPORT it should
>>> be safe to 'select' BACKLIGHT_CLASS_DEVICE.
>>>
>>> BACKLIGHT_CLASS_DEVICE could be made a hidden option, and the drivers in
>>> drivers/video/backlight/Kconfig which are under BACKLIGHT_CLASS_DEVICE
>>> could be made to select BACKLIGHT_CLASS_DEVICE instead.
>>
>> I think it should be possible to choose between y and m when it's
> 
> If I'm not mistaken, if CONFIG_FOO is 'm', and it 'select's CONFIG_BAR,
> and CONFIG_BAR is tristate, then CONFIG_BAR will be set to 'm'.
> 
>> selected, and it should be possible to enable it when it's not selected
>> by any drivers. I'm not sure a hidden option is good for that.
> 
> Why would you want to enable it if no one uses it? Does
> BACKLIGHT_CLASS_DEVICE enable something even if no driver uses it?
> 
>>> That doesn't exactly fix anything, but I think it makes sense as
>>> BACKLIGHT_CLASS_DEVICE is something that's selected from all around the
>>> kernel, so it should be a selectable "library" instead of a Kconfig menu
>>> option.
>>
>> At least for drm/i915 BACKLIGHT_CLASS_DEVICE is "an option". We use it
>> if it's enabled, but we are just fine if it's not. I've learned the way
>> to express that is
>>
>> 	depends on BACKLIGHT_CLASS_DEVICE || BACKLIGHT_CLASS_DEVICE=n
>>
>> but I don't think there's a way to express that in terms of select, is
>> there? The dependency above guarantees there's no DRM_I915=y and
>> BACKLIGHT_CLASS_DEVICE=m combo which would fail. And this, btw, is where
>> this whole patch got started, as select didn't handle that properly.
> 
> If backlight support is considered an option for drm/i915, then I think
> there should be a Kconfig option for i915 to enable backlight support,
> which in turn selects BACKLIGHT_CLASS_DEVICE. And that select will force
> BACKLIGHT_CLASS_DEVICE to be built-in if drm/i915 is built-in.
> 
> Oh, but it doesn't work optimally with modules. The new option needed
> for that would be boolean, so BACKLIGHT_CLASS_DEVICE would always be
> either y or n. Sigh...
> 
>>> I didn't look at the ACPI_VIDEO side, so no idea how messy that is.
>>
>> Basically it's another dependency on BACKLIGHT_CLASS_DEVICE. I can only
>> imagine trying to solve this problem with select is going to end up in
>> recursive dependencies that spread out and need changing about as wide
>> as this patch.
> 
> If ACPI_VIDEO uses select to enable BACKLIGHT_CLASS_DEVICE, then, I
> think, selecting ACPI_VIDEO will also select BACKLIGHT_CLASS_DEVICE. So
> I don't right away see any recursive dependencies. Or what did you have
> in mind?
> 
>> In the end, I agree with the problem you have with this patch, but yet I
>> think it's the right thing to do in terms of expressing the
>> dependencies.
> 
> Well, dri/i915 doesn't exactly depend on backlight, if I understood you
> correctly. Instead, backlight is an option for dri/i915, and you kind of
> hack it to be implemented with that 'depends on BACKLIGHT_CLASS_DEVICE
> || BACKLIGHT_CLASS_DEVICE=n'.
> 
> I guess it's debatable whether drivers should automatically use features
> in the kernel if they happen to be enabled in the Kconfig, or should
> they be individually enabled for that driver. I personally like the
> latter option, as it allows more precise control, but it probably also
> depends on the feature in question.
> 
> I also think the 'depends on BACKLIGHT_CLASS_DEVICE ||
> BACKLIGHT_CLASS_DEVICE=n' pattern is quite... interesting (i.e. sounds
> like a hack to me =).

It does exactly what is needed and it is used in many places in kernel
Kconfig files.


-- 
~Randy
