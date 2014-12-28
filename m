Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbaL1Oz0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 09:55:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59305 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbaL1OzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 09:55:23 -0500
Message-ID: <54A019BA.4080305@redhat.com>
Date: Sun, 28 Dec 2014 15:54:50 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jeremiah Mahler <jmmahler@gmail.com>, Ilia Mirkin <imirkin@alum.mit.edu>,
        David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Darren Hart <dvhart@infradead.org>
Subject: Re: [PATCH] nouveau: fix ambiguous backlight controls
References: <1419629187-13916-1-git-send-email-jmmahler@gmail.com> <CAKb7Uvi2jXTeD9+pUg6YiQrwK1HaVt2aoC-to1Xw1htvmJao-w@mail.gmail.com> <20141226235151.GA18697@hudson.localdomain> <549EB69E.6070708@redhat.com> <20141228143016.GA22394@hudson.localdomain>
In-Reply-To: <20141228143016.GA22394@hudson.localdomain>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 28-12-14 15:30, Jeremiah Mahler wrote:
> Hans,
>
> On Sat, Dec 27, 2014 at 02:39:42PM +0100, Hans de Goede wrote:
>> Hi,
>>
>> On 27-12-14 00:51, Jeremiah Mahler wrote:
>>> Ilia,
>>>
>>> On Fri, Dec 26, 2014 at 04:39:08PM -0500, Ilia Mirkin wrote:
>>>> On Fri, Dec 26, 2014 at 4:26 PM, Jeremiah Mahler <jmmahler@gmail.com> wrote:
>>>>> If a display supports backlight control using the nouveau driver, and
>>>>> also supports standard ACPI backlight control, there will be two sets of
>>>>> controls.
>>>>>
>>>>> /sys/class/backlight/acpi_video0
>>>>> /sys/class/backlight/nv_backlight
>>>>>
>>>>> This creates ambiguity because these controls can be out of sync with
>>>>> each other.  One could be at 100% while the other is at 0% and the
>>>>> actual display brightness depends on which one was used last.  This also
>>>>> creates anomalies in Powertop which will show two values for brightness
>>>>> with potentially different values.
>>>>>
>>>>> Fix this ambiguity by having the nouveau driver only enable its
>>>>> backlight controls if the standard ACPI controls are not present.
>>>>>
>>>>> Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
>>>>> ---
>>>>>   drivers/gpu/drm/nouveau/nouveau_backlight.c | 5 +++++
>>>>>   1 file changed, 5 insertions(+)
>>>>>
>>>>> diff --git a/drivers/gpu/drm/nouveau/nouveau_backlight.c b/drivers/gpu/drm/nouveau/nouveau_backlight.c
>>>>> index e566c5b..3a52bd4 100644
>>>>> --- a/drivers/gpu/drm/nouveau/nouveau_backlight.c
>>>>> +++ b/drivers/gpu/drm/nouveau/nouveau_backlight.c
>>>>> @@ -221,6 +221,11 @@ nouveau_backlight_init(struct drm_device *dev)
>>>>>          struct nvif_device *device = &drm->device;
>>>>>          struct drm_connector *connector;
>>>>>
>>>>> +       if (acpi_video_backlight_support()) {
>>>>
>>>> None of the other drivers have this. Is nouveau somehow different
>>>> than, say, radeon in this respect?
>>>>
>>>> Unfortunately the backlight situation is pretty fubar'd... sometimes
>>>> the acpi controls don't work, sometimes the card controls don't work,
>>>> sometimes they both work but in different ways (and then everyone's
>>>> favourite -- neither works, and there's some third platform thing).
>>>> I'm pretty sure this code existed before, but got removed. See commit
>>>> bee564430feec1175ee64bcfd4913cacc519f817 and the previous commit
>>>> 5bead799d3f8 before that. The ping-pong is probably not the right way
>>>> to go.
>>>>
>>>
>>> I was not aware of that change. But you are right, it took out what I
>>> was trying to put back in.
>>>
>>> Thanks for the helpful information.  I will have to rethink this fix.
>>
>> So first of all NAK to the original fix, but I think that much was
>> already clear.
>>
>> Let me explain how this currently works, most laptops have up to 3
>> backlight control interfaces (all talking to the same single backlight):
>>
>> acpi_video: a standardized acpi interface for backlight control, broken on most
>> win8 ready laptops.
>>
>> vendor: e.g. asus_wmi, dell_laptop, etc. typically not much better on
>> win8 ready laptops.
>>
>> native: e.g. intel_backlight, nv_backlight, usually your best bet on win8
>> laptops, but not so much on older models.
>>
>> Before windows8 only 2 of these 3 get registered / exported to userspace,
>> either you've:
>>
>> acpi_video + native:
>>
>> or:
>>
>> vendor + native:
>>
>> Since most vendor drivers contain:
>>
>> if (acpi_video_backlight_support())
>> 	return 0;
>>
>> And userspace backlight control code knows the prefer the firmware interfaces
>> over the native one and to simply ignore the native interface, unless there
>> is no firmware interface, so having 2 interfaces present in sysfs is not
>> really a problem as userspace knows how to deal with this.
>>
>> So along came Windows 8, breaking most acpi_video implementations. This got
>> fixed by a new module parameter to the acpi_video driver called use_native_backlight,
>> which now a days defaults to 1. When this parameter is true *and* the BIOS is
>> a win8 ready bios, then acpi_video will not register a backlight interface itself,
>> and acpi_video_backlight_support() will still return 1, causing the vendor interfaces
>> to not register. Leaving only the native interface.
>>
> So acpi_video_backlight_support() will return true for win8 even when ACPI
> isn't actually supported.

Well it is supported (the bios has an acpi_video backlight interface), but
drivers/acpi/video.c choses not to register the interface. Note that video-detect.c
knows nothing about that. As said this is not pretty.

> Could this have been fixed by updating
> acpi_video_backlight_support() function?

In retrospect it would probably have been best to do something akin to adding
a acpi_video_get_backlight_type function when the video.use_native_backlight
kernel option was first introduced.

>
>> Your proposed patch will break things on win8 laptops using nv_backlight, since in the
>> use_native_backlight case it will cause nv_backlight to not register resulting in
>> not having any backlight interface at all.
>>
>> I will happily admit that the combination of acpi_backlight=[video|vendor]
>> + video.use_native_backlight=[0|1] which has evolved over time is not the prettiest
>> solution. IMHO if you want to clean things up, and ensure only one interface gets
>> registered at a time, the solution would be to change acpi_backlight to also take
>> a native option, so that on the kernel commandline we end up with only:
>> acpi_backlight=[video|vendor|native] and move the use_native_backlight handling
>> from drivers/acpi/video.c to drivers/acpi/video_detect.c .
>>
> It is not ideal but I can see why it was done.  It is much better to have
> at least one working interface even if this means there are two in some
> cases.
>
> My complaint of two which can be out of sync with each other is a non-issue
> in most cases.
>
>> Code wise this would mean replacing acpi_video_backlight_support() with a function
>> called acpi_video_get_backlight_type which returns an enum which can be:
>>
>> acpi_video_backlight_acpi_video,
>> acpi_video_backlight_vendor,
>> acpi_video_backlight_native,
>>
>> And fix all callers to use that.
>>
> So all the detection would be done in drivers/acpi/video_detect.c and
> then acpi_video_backlight_type() could be called to determine the type.

Correct.

>> But, things are not that easy because there also is acpi_video_dmi_promote_vendor()
>> which is used by vendor drivers (mostly found under drivers/platform/x86) to tell
>> video_detect.c that the vendor driver knows that on this particular model laptop
>> it is better to use the vendor driver then acpi_video, and in some cases
>> this is used in combination with not actually registering the vendor backlight interface
>> to get the same end result as the new "native" option would give, but then on laptops
>> which need this despite not being win8 ready (and thus not automatically defaulting
>> to native).
>>
>> So you would need to replace this to with a acpi_video_set_dmi_backlight_type, which
>> should change the return of acpi_video_get_backlight_type, but only if not overridden
>> from the kernel commandline, as the commandline takes presedence over the dmi
>> quirks which are tracked in the various vendor drivers.
>>
> Ugh, this is a messy situation.

This is sort of this way by design, so that we can keep the quirks in per vendor
drivers, rather then having one gargantuan quirk table in video-detect.c

>
>> A cleanup to all this would certainly be welcome, but as outlined above it is not
>> trivial. I do not have time to actively work on this myself, but I will happily
>> review any patches you come up with for this.
>>
>> Regards,
>>
>> Hans
>
> Thanks for the very detailed description :)

You're welcome.

Regards,

Hans
