Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933427AbaLKBcl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 20:32:41 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:46963 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758270AbaLKBcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 20:32:39 -0500
MIME-Version: 1.0
In-Reply-To: <5488ECC8.8070802@synaptics.com>
References: <1416874819-9914-1-git-send-email-aduggan@synaptics.com>
	<54863F7A.30609@synaptics.com>
	<CAN+gG=Epx3m0=mg-xfKJveZBvo5ySe5cpFJgRbo79DvKgCFa4A@mail.gmail.com>
	<5488ECC8.8070802@synaptics.com>
Date: Wed, 10 Dec 2014 20:32:38 -0500
Message-ID: <CAN+gG=GEnF940DQZztu66MSLj5DTZwcFWoOA9eh7g5baOmLXDw@mail.gmail.com>
Subject: Re: [PATCH] HID: rmi: Add support for the touchpad in the Razer Blade
 14 laptop
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Andrew Duggan <aduggan@synaptics.com>
Cc: linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 8:00 PM, Andrew Duggan <aduggan@synaptics.com> wrote:
> Hi Benjamin,
>
> Thanks for reviewing my patch. Comments and questions below.
>
> On 12/10/2014 12:51 PM, Benjamin Tissoires wrote:
>>
>> On Mon, Dec 8, 2014 at 7:16 PM, Andrew Duggan <aduggan@synaptics.com>
>> wrote:
>>>
>>> On 11/24/2014 04:20 PM, Andrew Duggan wrote:
>>>>
>>>> The Razer Blade 14 has a Synaptic's TouchPad on one of the interfaces of
>>>> a composite USB device. This patch allows the hid-rmi driver to bind
>>>> to that interface. It also adds support for the external click buttons
>>>> on the Razer's touchpad. External buttons are reported using generic
>>>> mouse reports instead of through the F30 like it is on ClickPads.
>>>>
>>>> Signed-off-by: Andrew Duggan <aduggan@synaptics.com>
>>>> ---
>>>> This patch depends on the "HID: rmi: Scan the report descriptor to
>>>> determine if the device is
>>>> suitable for the hid-rmi driver" I submitted earlier today to correctly
>>>> bind to the touchpad HID
>>>> device in the composite USB device.
>>>
>>> Any comments on this patch?
>>
>> Again, sorry for the lag on this series. I think now that I re-read
>> this one I understood why I did not put too many efforts to properly
>> review the series. This one is a little bit worrisome IMO.
>>
>
> I wasn't sure about this patch either. But, after waiting a while and not
> coming with with anything better I figured I would post it to at least get
> some feedback.

That's the right spirit :)

>
>
>>> Thanks,
>>> Andrew
>>>
>>>>    drivers/hid/hid-core.c |  4 +++-
>>>>    drivers/hid/hid-ids.h  |  3 +++
>>>>    drivers/hid/hid-rmi.c  | 15 ++++++++++++++-
>>>>    3 files changed, 20 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
>>>> index ba9dc59..d69ea16 100644
>>>> --- a/drivers/hid/hid-core.c
>>>> +++ b/drivers/hid/hid-core.c
>>>> @@ -792,7 +792,9 @@ static int hid_scan_report(struct hid_device *hid)
>>>>          /*
>>>>          * Vendor specific handlings
>>>>          */
>>>> -       if ((hid->vendor == USB_VENDOR_ID_SYNAPTICS) &&
>>>> +       if ((hid->vendor == USB_VENDOR_ID_SYNAPTICS
>>>> +           || (hid->vendor == USB_VENDOR_ID_RAZER
>>>> +           && hid->product == USB_DEVICE_ID_RAZER_BLADE_14)) &&
>>
>> I don't like this. We already have a blacklist, an ignore list, and
>> there, we will have a new blacklist...
>>
>> I understood why you put this here, the current have_special_driver
>> list will not fit 100%. Still, I find it not good.
>>
>> It works, but I think we should still head for an entry in
>> have_special_driver, and a specific behavior in hid-rmi which would
>> rely on hid-input to handle the keyboard/mouse buttons and the rest.
>
>
> Are you suggesting that we have hid-rmi bind to all of the hid devices on
> this USB device and then have hid-rmi decide what reports it should process
> and let the remaining events continue to hid-input? I guess once hid-rmi
> loads it could look at the hid report ids and determine if it is one of our
> devices and if it should put the device into rmi mode. If not simply act as
> a pass through.

Yeah, that's basically what I am saying. Add the device in
hid_have_special_driver, add it to the list of supported devices by
hid-rmi, and add a quirk saying that it should be pass through for all
but the rmi report ID.

>
>
>>>>              (hid->group == HID_GROUP_GENERIC)) {
>>>>                  if ((parser->scan_flags &
>>>> HID_SCAN_FLAG_VENDOR_SPECIFIC)
>>>>                      && (parser->scan_flags &
>>>> HID_SCAN_FLAG_GENDESK_POINTER))
>>>> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
>>>> index 25cd674..c677aad 100644
>>>> --- a/drivers/hid/hid-ids.h
>>>> +++ b/drivers/hid/hid-ids.h
>>>> @@ -751,6 +751,9 @@
>>>>    #define USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH_3001               0x3001
>>>>    #define USB_DEVICE_ID_QUANTA_OPTICAL_TOUCH_3008               0x3008
>>>>    +#define USB_VENDOR_ID_RAZER          0x1532
>>>> +#define USB_DEVICE_ID_RAZER_BLADE_14   0x011D
>>>> +
>>>>    #define USB_VENDOR_ID_REALTEK         0x0bda
>>>>    #define USB_DEVICE_ID_REALTEK_READER  0x0152
>>>>    diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
>>>> index 3cccff7..1f131df 100644
>>>> --- a/drivers/hid/hid-rmi.c
>>>> +++ b/drivers/hid/hid-rmi.c
>>>> @@ -453,7 +453,15 @@ static int rmi_raw_event(struct hid_device *hdev,
>>>>          case RMI_ATTN_REPORT_ID:
>>>>                  return rmi_input_event(hdev, data, size);
>>>>          case RMI_MOUSE_REPORT_ID:
>>>> -               rmi_schedule_reset(hdev);
>>>> +               /*
>>>> +                * touchpads with physical mouse buttons will report
>>>> those
>>>> +                * buttons in mouse reports even in RMI mode. Only reset
>>>> +                * the device if we see reports which contain X or Y
>>>> data.
>>>> +                */
>>>> +               if (data[2] != 0 || data[3] != 0)
>>
>> this seems a little bit magical. There may not be an other solution,
>> but I would prefer that we look at alternatives before using this
>> magical numbers (will the touchpad always use the same report
>> descriptor on the mouse interface?)
>
>
> I did just look at the reports and see where X and Y where reported. Since
> mouse mode is really only there for compatibility when no custom driver is
> present I think it is unlikely that it will change in the future. However,
> there is no guarantee that it won't change. I will see if I can come up with
> is less of a hack. Maybe, I can use the event callback instead of raw_event.

I would prefer an event callback (if it is not too much trouble).

>
>
>>>> +                       rmi_schedule_reset(hdev);
>>>> +               else
>>>> +                       return 1;
>>>>                  break;
>>>>          }
>>>>    @@ -871,6 +879,11 @@ static int rmi_input_mapping(struct hid_device
>>>> *hdev,
>>>>                  struct hid_input *hi, struct hid_field *field,
>>>>                  struct hid_usage *usage, unsigned long **bit, int *max)
>>>>    {
>>>> +       if (field->application == HID_GD_POINTER
>>>> +               && (usage->hid & HID_USAGE_PAGE) == HID_UP_BUTTON)
>>>> +               /* Pass mouse button reports to generic code for
>>>> processing */
>>>> +               return 0;
>>>> +
>>>>          /* we want to make HID ignore the advertised HID collection */
>>>>          return -1;
>>>>    }
>>>
>>>
>> Cheers,
>> Benjamin
>
>
> Andrew

Cheers,
Benjamin
