Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbaIXME4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 08:04:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbaIXMEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 08:04:54 -0400
Message-ID: <5422B354.4010005@redhat.com>
Date: Wed, 24 Sep 2014 14:04:36 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>
CC: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Lu <aaron.lu@intel.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: Re: ACPI/i915: Cannot configure display brightness on Dell Latitude
 E6440
References: <201409232206.02819@pali> <54227E9A.7080107@redhat.com> <201409241059.41465@pali> <201409241114.11604@pali>
In-Reply-To: <201409241114.11604@pali>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/24/2014 11:14 AM, Pali Rohár wrote:
> On Wednesday 24 September 2014 10:59:41 Pali Rohár wrote:
>> On Wednesday 24 September 2014 10:19:38 Hans de Goede wrote:
>>> Hi,
>>>
>>> On 09/23/2014 10:44 PM, Pali Rohár wrote:
>>>> On Tuesday 23 September 2014 22:31:31 you wrote:
>>>>> Hi,
>>>>>
>>>>> On 09/23/2014 10:06 PM, Pali Rohár wrote:
>>>>>> Hello,
>>>>>>
>>>>>> after big changes in acpi video/i915 code I cannot
>>>>>> change display brightness on my Dell Latitude E6440
>>>>>> with kernel 3.17-rc6. With kernel 3.13 everything
>>>>>> worked fine.
>>>>>>
>>>>>> More information about this problem:
>>>>>>
>>>>>> For configuring brightness on Dell laptops there are 4
>>>>>> ways: 1) via acpi video driver
>>>>>> 2) via dell-laptop driver
>>>>>> 3) via i915 drm driver
>>>>>> 4) from userspace with special dell SMI call
>>>>>>
>>>>>>     (e.g with program dellLcdBrightness from libsmbios
>>>>>>     package)
>>>>>>
>>>>>> Methods 2) and 4) are same, both making special SMI call
>>>>>> and Bios handing this request (just 2 is from kernel and
>>>>>> 4 from userspace)
>>>>>>
>>>>>> Method 1) via acpi video driver working, but is not
>>>>>> perfect. Driver can be used to change brightness (but
>>>>>> only some levels, probably this depends on acpi/DSDT
>>>>>> tables), but cannot be used to retrieve current
>>>>>> brightness (when BIOS/SMI change brightness acpi driver
>>>>>> report old incorrect value). So I prefer dell-laptop
>>>>>> driver instead acpi video.
>>>>>>
>>>>>> Method 3) working even with 3.17-rc6 kernel but because
>>>>>> that backlight device exported by i915 is marked as raw,
>>>>>> desktop programs prefer to use other devices.
>>>>>>
>>>>>> Moreover it looks like that methods 1) 2) and 4) just
>>>>>> forward request to method 3). So in any cased brightness
>>>>>> is changed by i915 drm driver.
>>>>>>
>>>>>> I'm not sure (correct me if I'm wrong!) but I think that
>>>>>> intel i915 drm driver accept changes (file
>>>>>> intel_opregion.c) only if acpi function
>>>>>> acpi_video_verify_backlight_support() returns true.
>>>>>>
>>>>>> Function acpi_video_verify_backlight_support() returns
>>>>>> true iff: function acpi_video_backlight_support()
>>>>>> returns true AND at least one of these functions
>>>>>> returns false: acpi_osi_is_win8()
>>>>>> acpi_video_use_native_backlight()
>>>>>> backlight_device_registered(BACKLIGHT_RAW)
>>>>>>
>>>>>> On my notebook acpi_osi_is_win8() returns true (as is
>>>>>> win8 compliant),
>>>>>> backlight_device_registered(BACKLIGHT_RAW) returns true
>>>>>> as I'm using intel i915 drm driver with raw backlight
>>>>>> device and acpi_video_use_native_backlight() returns
>>>>>> true/false depending on
>>>>>> "video.use_native_backlight" kernel param. Default is
>>>>>> true.
>>>>>>
>>>>>> So if I want to have working acpi video driver with
>>>>>> display brightness support I need to boot kernel with
>>>>>> param: "video.use_native_backlight=0". I tested it with
>>>>>> kernel 3.17-rc6 and this param really enabled display
>>>>>> brightness support via acpi video driver -- which is
>>>>>> good.
>>>>>>
>>>>>> Driver dell-laptop creating backligh device for
>>>>>> brightness control only if
>>>>>> acpi_video_backlight_support() returns false. There is
>>>>>> complicated condition for it and when kernel is booted
>>>>>> with "video.use_native_backlight=0" that function
>>>>>> returns true.
>>>>>>
>>>>>> So conclusion is: With current code in kernel 3.17-rc6
>>>>>> it is not possible to control brightness of display
>>>>>> with native driver dell-laptop on Dell Latitude E6440
>>>>>> (and probably on others too)!!!
>>>>>>
>>>>>> And Because laptop is win8 compliant and you create
>>>>>> decision to use native driver (instead acpi one) it is
>>>>>> not possible to control display brightness without
>>>>>> tweeks in kernel cmdline.
>>>>>>
>>>>>> As I wrote I would rather to use native dell-laptop
>>>>>> driver for controlling brightness, but it is not
>>>>>> possible.
>>>>>>
>>>>>> So how to solve this problem?
>>>>>>
>>>>>> Quick solution would be to set use_native_backlight
>>>>>> false for some Dell laptops which means, that acpi
>>>>>> video will be used and in this case intel i915 driver
>>>>>> will *not* drop backlight change request.
>>>>>>
>>>>>> Another solution could be to disable check in
>>>>>> dell_laptop driver and add use_native_backlight=0 to
>>>>>> hooks. But this create two backlight interfaces (which
>>>>>> is not good), but only way (for now) how to make
>>>>>> dell_laptop working again.
>>>>>>
>>>>>> Better and maybe only one proper solution would be to
>>>>>> teach intel drm i915 driver to not drop backlight change
>>>>>> request for Dell laptops (or all??). (This allows to
>>>>>> work both acpi video and dell_laptop drivers without
>>>>>> any change and with *any* value in param
>>>>>> use_native_backlight). I think that problematic code is
>>>>>> in function asle_set_backlight() in file
>>>>>> intel_opregion.c (but I'm not sure). My idea is that
>>>>>> "drop" event function it is caused by this commit
>>>>>> 0b9f7d93ca6109048a4eb06332b666b6e29df4fe (but I'm not
>>>>>> sure).
>>>>>>
>>>>>> At least something must be done as I think that I'm not
>>>>>> only one who has Dell laptop and brightness
>>>>>> configuration is really important...
>>>>>
>>>>> I don't understand your problem, the kernel is selecting
>>>>> the i915 backlight driver, making that the only one
>>>>> available to userspace, so the one problem you state with
>>>>> the i915 driver, that it is "raw" is not an issue, as
>>>>> userspace will pick it when it is the only one.
>>>>
>>>> It is not only one.
>>>
>>> Are you sure, if you do not specify any commandline
>>> parameters, then neither dell-laptop nor acpi-video should
>>> register a backlight interface.
>>>
>>> dell-laptop.c has:
>>>
>>> #ifdef CONFIG_ACPI
>>>
>>>         /* In the event of an ACPI backlight being
>>>         available,
>>>
>>> don't * register the platform controller.
>>>
>>>          */
>>>         
>>>         if (acpi_video_backlight_support())
>>>         
>>>                 return 0;
>>>
>>> #endif
>>>
>>> And acpi_video_backlight_support() will (normally) return
>>> true on acpi-backlight capable systems independent of
>>> use_native_backlight.
>>>
>>> And drivers/acpi/video.c has this:
>>>         /* no warning message if acpi_backlight=vendor or a
>>>
>>> quirk is used */ if (!acpi_video_verify_backlight_support())
>>>
>>>                 return;
>>>
>>> ...
>>>
>>> bool acpi_video_verify_backlight_support(void)
>>> {
>>>
>>>         if (acpi_osi_is_win8() &&
>>>
>>> acpi_video_use_native_backlight() &&
>>> backlight_device_registered(BACKLIGHT_RAW)) return false;
>>>
>>>         return acpi_video_backlight_support();
>>>
>>> }
>>>
>>> So unlike the check in dell-laptop this one does depend on
>>> the use_native_backlight setting.
>>
>> It depends (see my previous mail). Here is code:
>>
>> static bool acpi_video_use_native_backlight(void)
>> {
>> 	if (use_native_backlight_param != -1)
>> 		return use_native_backlight_param;
>> 	else
>> 		return use_native_backlight_dmi;
>> }

Not sure what you're trying to say here, the default for
this is 1, so if you don't specify anything, then this:

bool acpi_video_verify_backlight_support(void)
{
        if (acpi_osi_is_win8() && acpi_video_use_native_backlight() &&
            backlight_device_registered(BACKLIGHT_RAW))
                return false;
        return acpi_video_backlight_support();
}

Will return false, and you won't get an acpi_video0 backlight interface,
only the intel_backlight one, and everything should just work
(except for the turning off on low settings).

Have you tried not using any kernel commandline options? What happens?

>>
>>> I've just checked 3.17 on my E6430 and there this works as
>>> it should, I only get the intel_backlight in
>>> /sys/class/backlight
>>>
>>>> Also dell-laptop (or acpi video) backlight
>>>> interface is created (depends on use_native_backlight
>>>> param). And userspace will pick dell-laptop (or acpi
>>>> video) to use (which cannot change brightness).
>>>>
>>>>> Why would you want to use dell-laptop despite the i915
>>>>> driver working fine ?
>>>>
>>>> i915 working only if I compile kernel without acpi video
>>>> dell- laptop support (distributions compile kernel with
>>>> these drivers) and i915 is not good for usage. First it
>>>> provides more then thousand brightness levels and lot of
>>>> (with low numbers) completely turn display off. And if
>>>> userspace map these thousand levels into 5-10 levels (as
>>>> nobody want to press brightness key up/down 1000x) two
>>>> lowest levels cause display off.
>>>
>>> More and more laptops will only have working backlight
>>> control at all when using i915, so userspace will need to
>>> learn to better deal with backlight controls with these
>>> ranges. And low pwm levels turning the backlight of is
>>> normal for raw interfaces, if userspace does not want this,
>>> then they should not go so low.
>>
>> So then kernel should report which low levels turn backlight
>> off so userspace will know which levels should avoid. But
>> this is not implemented yet.
>>
>>> I suggest that you file a bug against your desktop
>>> environment that it is not using the backlight controls in
>>> an optimal manner, from the kernel pov everything is
>>> working fine.
>>
>> Once I will know which levels should not DE use I can report
>> bug.
>>
>>>> With acpi
>>>> video and dell-laptop driver levels are mapped into small
>>>> level space in perfect way. So this is reason I want to
>>>> use dell-laptop for controlling brightness.
>>>
>>> If you want to use dell-laptop, specify
>>> acpi_backlight=vendor on the kernel commandline, that will
>>> give you dell_laptop + intel_backlight as backlight
>>> interfaces, and userspace should prefer dell_laptop.
>>
>> With acpi_backlight=vendor dell-laptop is not working, see my
>> previous mail. In this case intel i915 drm driver ignore bios
>> events for changing brightness. And userspace prefer to use
>> dell_laptop which do nothing!
>>
> 
> Ok, that problematic commit is:
> 
> ACPI / i915: ignore firmware requests for backlight change
> 0b9f7d93ca6109048a4eb06332b666b6e29df4fe
> 
> When I reverted it acpi_backlight=vendor started working again 
> (via dell_laptop). Without reverting that commit dell_laptop 
> simply do nothing.
> 
> Tested and on my laptop Dell Latitude E6440 driver dell_laptop 
> does not work with above commit.

Hmm, interesting, so when dell-laptop registers and makes a few
calls using the dell-laptop acpi interface, then you either
stop getting key press events through the acpi-video-bus, or
dell-laptop is just a shim around the i915 interface with the
firmware calling into itself on these models. Given that dell-laptop
is ancient, the shim story is not that far fetched.

Do you still get an on screen display showing the brightness when
using a kernel without this patch + acpi_backlight=vendor ?

Regards,

Hans
