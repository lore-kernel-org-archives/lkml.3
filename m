Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab3IJFlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 01:41:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:61388 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437Ab3IJFls (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 01:41:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,876,1371106800"; 
   d="scan'208";a="375876455"
Message-ID: <522EB135.2060309@intel.com>
Date: Tue, 10 Sep 2013 13:42:13 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Igor Gnatenko <i.gnatenko.brain@gmail.com>
CC: ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, Yves-Alexis Perez <corsac@debian.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Lee Chun-Yi <jlee@novell.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH 2/2] ACPI / video / i915: Remove ACPI backlight if firmware
 expects Windows 8
References: <522D88C3.7000808@intel.com> <522D89EC.6050103@intel.com>   <1378727093.13401.3.camel@ThinkPad-X230.localdomain>   <522E91A6.6040600@intel.com>  <1378790011.2204.3.camel@ThinkPad-X230.localdomain>  <522EAB25.6000901@intel.com> <1378790561.2160.1.camel@ThinkPad-X230.localdomain>
In-Reply-To: <1378790561.2160.1.camel@ThinkPad-X230.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2013 01:22 PM, Igor Gnatenko wrote:
> On Tue, 2013-09-10 at 13:16 +0800, Aaron Lu wrote:
>> On 09/10/2013 01:13 PM, Igor Gnatenko wrote:
>>> On Tue, 2013-09-10 at 11:27 +0800, Aaron Lu wrote:
>>>> On 09/09/2013 07:44 PM, Igor Gnatenko wrote:
>>>>> On Mon, 2013-09-09 at 16:42 +0800, Aaron Lu wrote:
>>>>>> diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
>>>>>> index f466980..75fba17 100644
>>>>>> --- a/drivers/gpu/drm/i915/i915_dma.c
>>>>>> +++ b/drivers/gpu/drm/i915/i915_dma.c
>>>>>> @@ -1650,7 +1650,7 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
>>>>>>  	if (INTEL_INFO(dev)->num_pipes) {
>>>>>>  		/* Must be done after probing outputs */
>>>>>>  		intel_opregion_init(dev);
>>>>>> -		acpi_video_register();
>>>>>> +		__acpi_video_register(i915_take_over_backlight);
>>>>>>  	}
>>>>>>  
>>>>>>  	if (IS_GEN5(dev))
>>>>>
>>>>> I can't compile:
>>>>>
>>>>>
>>>>> DEBUG: drivers/gpu/drm/i915/i915_dma.c: In function 'i915_driver_load':
>>>>> DEBUG: drivers/gpu/drm/i915/i915_dma.c:1661:3: error: implicit
>>>>> declaration of function
>>>>> '__acpi_video_register' [-Werror=implicit-function-declaration]
>>>>> DEBUG:    __acpi_video_register(i915_take_over_backlight);
>>>>> DEBUG:    ^
>>>>> DEBUG: cc1: some warnings being treated as errors
>>>>> DEBUG: make[4]: *** [drivers/gpu/drm/i915/i915_dma.o] Error 1
>>>>> DEBUG: make[3]: *** [drivers/gpu/drm/i915] Error 2
>>>>> DEBUG: make[2]: *** [drivers/gpu/drm] Error 2
>>>>> DEBUG: make[1]: *** [drivers/gpu] Error 2
>>>>> DEBUG: make: *** [drivers] Error 2
>>>>>
>>>>
>>>> The two patches are based on top of Rafael's linux-next tree. I just
>>>> tried it again, no compile problem for me. I also tried on today Linus'
>>>> master tree, as there are some updates from i915, two conflicts exist.
>>>> I've just resolved them and will update it in next revision.
>>>> If you want to try it now, please use:
>>>> https://github.com/aaronlu/linux acpi_video_rework
>>>>
>>>> Thanks,
>>>> Aaron
>>>
>>> Thanks. this patch fixes my problems w/ compilation. I've tested this
>>> two patches and after apply I have:
>>> $ tree /sys/class/backlight/
>>> /sys/class/backlight/
>>> |-- acpi_video0
>>> -> ../../devices/pci0000:00/0000:00:02.0/backlight/acpi_video0
>>> `-- intel_backlight
>>> -> ../../devices/pci0000:00/0000:00:02.0/drm/card0/card0-LVDS-1/intel_backlight
>>>
>>> 2 directories, 0 files
>>>
>>> I think it's didn't unregistered.. I may forget. I need to apply one of
>>> patch from Matthew ?
>>
>> You need to specify i915.take_over_backlight=1 in kernel cmdline, that
>> module option is set to false by default for now.
>>
>> Thanks for the test.
>>
>> -Aaron
>>
>>>
>>> Some strings from logs:
>>> DMI: LENOVO 23205NG/23205NG, BIOS G2ET92WW (2.52 ) 02/22/2013
>>> thinkpad_acpi: Standard ACPI backlight interface available, not loading
>>> native one
>>>
>>
> 
> Thanks for quick answer. Yes. This option do unregister. Thanks. but for
> this patch-set I also need "[PATCH 2/3] ACPI / video: Always call
> acpi_video_init_brightness() on init" from Matthew (for notifications in
> DE).

That patch is reverted as it cause problem for other system:
https://bugs.freedesktop.org/show_bug.cgi?id=68355

OTOH, the thinkpad-acpi module already has a call to _BCL except that
the tpacpi_acpi_handle_locate failed to locate video controller's handle:
https://bugzilla.kernel.org/show_bug.cgi?id=51231#c121
I'll see if I can figure out why.

Thanks,
Aaron
