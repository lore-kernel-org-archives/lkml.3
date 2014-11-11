Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaKKQBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 11:01:55 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59710 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaKKQBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 11:01:53 -0500
MIME-Version: 1.0
In-Reply-To: <20141111054918.GB56947@vmdeb7>
References: <1415073514-12555-1-git-send-email-coproscefalo@gmail.com>
	<20141104062137.GC56751@vmdeb7>
	<CAGdLNWH9OqBO1TgNm7ZRnX_wnGwe3rUuxaqwvLfq=HdYXNmMbw@mail.gmail.com>
	<20141111054918.GB56947@vmdeb7>
Date: Tue, 11 Nov 2014 09:01:51 -0700
Message-ID: <CAGdLNWEnxUWKDKD6Wen+ytOQG+qqKq901auE5CDm-1_RGCe4tQ@mail.gmail.com>
Subject: Re: [PATCH] toshiba_acpi: Fix regression caused by backlight extra
 check code
From: Azael Avalos <coproscefalo@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: rjw@rjwysocki.net,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nuno Lopes <nunoplopes@sapo.pt>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-11-10 22:49 GMT-07:00 Darren Hart <dvhart@infradead.org>:
> On Mon, Nov 10, 2014 at 09:58:29AM -0700, Azael Avalos wrote:
>> Hi Darren,
>>
>> Sorry for the way late reply, I had to go out of town in a hurry.
>>
>> 2014-11-03 23:21 GMT-07:00 Darren Hart <dvhart@infradead.org>:
>> > On Mon, Nov 03, 2014 at 08:58:34PM -0700, Azael Avalos wrote:
>> >> Bug 86521 uncovered that some TOS6208 devices also return
>> >> non zero values on a write call to the backlight method,
>> >> thus getting caught and bailed out by the extra check code.
>> >>
>> >> This patch makes sure that the extra check is being done
>> >> on a TOS1900 device and then make the check for the broken
>> >> backlight code.
>> >>
>> >> Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
>> >> ---
>> >>  drivers/platform/x86/toshiba_acpi.c | 8 ++++++--
>> >>  1 file changed, 6 insertions(+), 2 deletions(-)
>> >>
>> >> diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
>> >> index ef3a190..e3fed12 100644
>> >> --- a/drivers/platform/x86/toshiba_acpi.c
>> >> +++ b/drivers/platform/x86/toshiba_acpi.c
>> >> @@ -944,9 +944,13 @@ static int set_lcd_brightness(struct toshiba_acpi_dev *dev, int value)
>> >>       /* Extra check for "incomplete" backlight method, where the AML code
>> >>        * doesn't check for HCI_SET or HCI_GET and returns TOS_SUCCESS,
>> >>        * the actual brightness, and in some cases the max brightness.
>> >> +      * Use the SPFC method as an indicator that we're on a TOS1900 device,
>> >> +      * otherwise some TOS6208 devices might get bailed out, see bug 86521
>> >
>> > This needs a clearer description here in this comment, rather than redirecting
>> > the reader to a bug report (which may or may not exist when needed).
>>
>> Alright, will do whenever we reach an agreement below.
>>
>> >
>> >>        */
>> >> -     if (out[2] > 0  || out[3] == 0xE000)
>> >> -             return -ENODEV;
>> >> +     if (acpi_has_method(dev->acpi_dev->handle, "SPFC")) {
>> >
>> > Hrm, this checking for the existence of a specific method seems suspect to me.
>> > We would know if we are on a TOS1900 as we matches the acpi id already. Is the
>> > SPFC significant here, or is it just a "we only see SPFC on TOS1900 so it's a
>> > convenient test"? If the latter, it seems rather fragile and prone to other
>> > breakage to me.
>>
>> Yeah, its the latter, the "SPFC" method is specific to TOS1900 devices.
>>
>> All of the TOS1900 support the Toshiba specific backlight read-only,
>> and that test is just to get those implementations where the AML
>> code doesn't check for read/write registers, so far I've identified three
>> series of laptops with this issue (all Qosmios), X500, X505 and X75-A
>> (and there might be more around).
>>
>> We could dissable backlight on all TOS1900 or add those three models
>> to the (growing) DMI list on video.c, but of course, I would like to keep
>> the code in-house, but that's just me :-)
>>
>
> I'm having some trouble grokking the whole picture I think.
>
> So, let's try and clear it up. We have a function to set brightness. On model
> citizen laptops, after the ACPI call, out[2] is 0 (TOS_SUCCESS) and we return 0.

Yeah, at least on TOS1900 devices, all write calls set the out[n] to zero,
and then assign the specified return status to out[0] (either success or error).

>
> The extra check was added by f6aac65 to avoid registering certain badly behaved
> machines (Qosmios) which always return HCI_SUCCESS, even the read/write commands
> are missing. This was determined by checking for observed values in out[2]
> greater than 0 and out[3] equal to 0xE000 (which presumably map to actual or max
> brightness. I take it in a well behaved ACPI implementation, out[2] must be 0
> and out[3] is .... what? I'll call this out[2] || out[3] state the "signature"
> of a bad implementation.

Yeah, since TOS1900 set all out[n] values to zero, I was expecting that same
behaviour from a TOS62XX device, however, bug 86521 proved me wrong.

>
> Now, with bug 86521, we learn that these signatures are not necessarily bad,
> some working laptops also populate these fields in this way.

For TOS1900 devices, they are, but for TOS62XX, that's another story,
the methods
are hidden and I can't see what they're doing... :-(

>
> Finally, while it is only TOS1900 devices that are known to be bad, all TOS1900
> devices are not necessarily bad. So you don't want to block all TOS1900 devices
> at probe time.

We're doing it already, toshiba_acpi_setup_backlight checks for read and write
support in order to register the backlight, and since all* TOS1900
support it read-only
they all get bailed out by these checks, except those badly behaved models,
they simply return SUCCESS and thus pass that check, creating a broken backlight
device with just read capabilities.

* (Actually there are two TOS1900 devices, the ones that support it
read only, and the
ones that don't support it at all)

>
> Do I have this right?
>
> If so, this is looking more and more fragile to me. I'm inclined to push for a
> blacklist of the known bad models and strip out both this and the precious extra
> check, since they are based on circumstantial evidence of failure.

Yeah, I thought that from the beginning, but I found that a bit
cumbersome to add
those models to the growing list, if we can do it in-house. But I'm
fine with whatever
decision is made here.

>
>> >
>> > Rafael, any recommendations here?
>
>
> Rafael, what's your take on this? Does the above influence your position one way
> or the other?
>
>
>
>> >
>> >> +             if (out[2] > 0  || out[3] == 0xE000)
>> >> +                     return -ENODEV;
>> >> +     }
>> >>
>> >>       return out[0] == TOS_SUCCESS ? 0 : -EIO;
>> >>  }
>
> --
> Darren Hart
> Intel Open Source Technology Center

Cheers
Azael



-- 
-- El mundo apesta y vosotros apestais tambien --
