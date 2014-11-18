Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389AbaKRQvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 11:51:22 -0500
Received: from mail-qg0-f53.google.com ([209.85.192.53]:37045 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbaKRQvU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 11:51:20 -0500
MIME-Version: 1.0
In-Reply-To: <20141118155517.GH8223@saruman>
References: <1415774479-21794-1-git-send-email-kiran.kumar@linaro.org>
	<20141118155517.GH8223@saruman>
Date: Tue, 18 Nov 2014 22:21:20 +0530
Message-ID: <CA+RfmHaocYV+ZSb2Rd_yHjXhrpciZAgEECyiMFyOS9swd-XUeA@mail.gmail.com>
Subject: Re: [RFC v6 3/3] usb: phy: hold wakeupsource when USB is enumerated
 in peripheral mode
From: Kiran Raparthy <kiran.kumar@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Todd Poynor <toddpoynor@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?B?QXJ2ZSBIau+/vW5uZXbvv71n?= <arve@android.com>,
        Benoit Goby <benoit@android.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 November 2014 21:25, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Wed, Nov 12, 2014 at 12:11:19PM +0530, Kiran Kumar Raparthy wrote:
>> From: Todd Poynor <toddpoynor@google.com>
>>
>> usb: phy: hold wakeupsource when USB is enumerated in peripheral mode
>>
>> Some systems require a mechanism to prevent system to enter into suspend
>> state when USB is connected and enumerated in peripheral mode.
>>
>> This patch provides an interface to hold a wakeupsource to prevent suspend.
>> PHY drivers can use this interface when USB is connected and enumerated in
>> peripheral mode.
>>
>> A timed wakeupsource is temporarily held on USB disconnect events, to allow
>> the rest of the system to react to the USB disconnection (dropping host
>> sessions, updating charger status, etc.) prior to re-allowing suspend.
>>
>> Cc: Felipe Balbi <balbi@ti.com>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: linux-kernel@vger.kernel.org
>> Cc: linux-usb@vger.kernel.org
>> Cc: Android Kernel Team <kernel-team@android.com>
>> Cc: John Stultz <john.stultz@linaro.org>
>> Cc: Sumit Semwal <sumit.semwal@linaro.org>
>> Cc: Arve Hj�nnev�g <arve@android.com>
>> Cc: Benoit Goby <benoit@android.com>
>> Signed-off-by: Todd Poynor <toddpoynor@google.com>
>> [kiran: Added context to commit message, squished build fixes
>> from Benoit Goby and Arve Hjønnevåg, changed wakelocks usage
>> to wakeupsource, merged Todd's refactoring logic and simplified
>> the structures and code and addressed community feedback]
>> Signed-off-by: Kiran Raparthy <kiran.kumar@linaro.org>
>> ---
>>  drivers/usb/phy/phy.c   | 29 +++++++++++++++++++++++++++--
>>  include/linux/usb/phy.h |  5 +++++
>>  2 files changed, 32 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/usb/phy/phy.c b/drivers/usb/phy/phy.c
>> index 2b1039e..b5c5fd3 100644
>> --- a/drivers/usb/phy/phy.c
>> +++ b/drivers/usb/phy/phy.c
>> @@ -329,6 +329,7 @@ int usb_add_phy(struct usb_phy *x, enum usb_phy_type type)
>>       int             ret = 0;
>>       unsigned long   flags;
>>       struct usb_phy  *phy;
>> +     char wsource_name[40];
>>
>>       if (x->type != USB_PHY_TYPE_UNDEFINED) {
>>               dev_err(x->dev, "not accepting initialized PHY %s\n", x->label);
>> @@ -351,6 +352,10 @@ int usb_add_phy(struct usb_phy *x, enum usb_phy_type type)
>>       x->type = type;
>>       list_add_tail(&x->head, &phy_list);
>>
>> +     snprintf(wsource_name, sizeof(wsource_name), "vbus-%s",
>> +             dev_name(x->dev));
>> +     wakeup_source_init(&x->wsource, wsource_name);
>
> do you really need the device name on the wakeup source or would
> usb-vbus suffice ? Hmm, I guess we could have several of these in the
> same system, so maybe there's no other way.
yeah true.
>
>> @@ -446,13 +452,32 @@ int usb_bind_phy(const char *dev_name, u8 index,
>>  EXPORT_SYMBOL_GPL(usb_bind_phy);
>>
>>  /**
>> - * usb_phy_set_event - set event to phy event
>> + * usb_phy_set_event - set event to phy event and
>> + * hold/temporarily hold wakeupsource
>>   * @x: the phy returned by usb_get_phy();
>>   *
>> - * This sets event to phy event
>> + * This holds per-PHY wakeupsource/timed wakeupsource
>>   */
>>  void usb_phy_set_event(struct usb_phy *x, unsigned long event)
>>  {
>> +
>>       x->last_event = event;
>> +
>> +     switch (event) {
>> +     case USB_EVENT_ENUMERATED:
>> +             __pm_stay_awake(&x->wsource);
>> +             break;
>> +
>> +     case USB_EVENT_NONE:
>> +     case USB_EVENT_ID:
>> +     case USB_EVENT_VBUS:
>> +     case USB_EVENT_CHARGER:
>> +             __pm_wakeup_event(&x->wsource,
>> +                             msecs_to_jiffies(TEMPORARY_HOLD_TIME));
>> +             break;
>> +
>> +     default:
>> +             break;
>> +     }
>
> much, much better. Completely hidden from PHY drivers.
>
>>  }
>>  EXPORT_SYMBOL_GPL(usb_phy_set_event);
>> diff --git a/include/linux/usb/phy.h b/include/linux/usb/phy.h
>> index 3c713ff..bc58fb8 100644
>> --- a/include/linux/usb/phy.h
>> +++ b/include/linux/usb/phy.h
>> @@ -12,6 +12,8 @@
>>  #include <linux/notifier.h>
>>  #include <linux/usb.h>
>>
>> +#define TEMPORARY_HOLD_TIME    2000
>
> minor nit:
>
> Let's call this:
>
> #define USB_PHY_DEFAULT_WAKEUP_SRC_TIMEOUT      2000 /* ms */
>
> When resending, please drop that "RFC" from subject and make sure your
> series is sent as a single thread, instead of three separate patches.
Sure Felipe,Thanks for your time.
>
> cheers
>
> --
> balbi
