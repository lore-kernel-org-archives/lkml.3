Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaKKFt2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 00:49:28 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:34215 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089AbaKKFt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 00:49:27 -0500
Date: Mon, 10 Nov 2014 21:49:19 -0800
From: Darren Hart <dvhart@infradead.org>
To: Azael Avalos <coproscefalo@gmail.com>
Cc: rjw@rjwysocki.net,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nuno Lopes <nunoplopes@sapo.pt>
Subject: Re: [PATCH] toshiba_acpi: Fix regression caused by backlight extra
 check code
Message-ID: <20141111054918.GB56947@vmdeb7>
References: <1415073514-12555-1-git-send-email-coproscefalo@gmail.com>
 <20141104062137.GC56751@vmdeb7>
 <CAGdLNWH9OqBO1TgNm7ZRnX_wnGwe3rUuxaqwvLfq=HdYXNmMbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGdLNWH9OqBO1TgNm7ZRnX_wnGwe3rUuxaqwvLfq=HdYXNmMbw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 09:58:29AM -0700, Azael Avalos wrote:
> Hi Darren,
> 
> Sorry for the way late reply, I had to go out of town in a hurry.
> 
> 2014-11-03 23:21 GMT-07:00 Darren Hart <dvhart@infradead.org>:
> > On Mon, Nov 03, 2014 at 08:58:34PM -0700, Azael Avalos wrote:
> >> Bug 86521 uncovered that some TOS6208 devices also return
> >> non zero values on a write call to the backlight method,
> >> thus getting caught and bailed out by the extra check code.
> >>
> >> This patch makes sure that the extra check is being done
> >> on a TOS1900 device and then make the check for the broken
> >> backlight code.
> >>
> >> Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
> >> ---
> >>  drivers/platform/x86/toshiba_acpi.c | 8 ++++++--
> >>  1 file changed, 6 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
> >> index ef3a190..e3fed12 100644
> >> --- a/drivers/platform/x86/toshiba_acpi.c
> >> +++ b/drivers/platform/x86/toshiba_acpi.c
> >> @@ -944,9 +944,13 @@ static int set_lcd_brightness(struct toshiba_acpi_dev *dev, int value)
> >>       /* Extra check for "incomplete" backlight method, where the AML code
> >>        * doesn't check for HCI_SET or HCI_GET and returns TOS_SUCCESS,
> >>        * the actual brightness, and in some cases the max brightness.
> >> +      * Use the SPFC method as an indicator that we're on a TOS1900 device,
> >> +      * otherwise some TOS6208 devices might get bailed out, see bug 86521
> >
> > This needs a clearer description here in this comment, rather than redirecting
> > the reader to a bug report (which may or may not exist when needed).
> 
> Alright, will do whenever we reach an agreement below.
> 
> >
> >>        */
> >> -     if (out[2] > 0  || out[3] == 0xE000)
> >> -             return -ENODEV;
> >> +     if (acpi_has_method(dev->acpi_dev->handle, "SPFC")) {
> >
> > Hrm, this checking for the existence of a specific method seems suspect to me.
> > We would know if we are on a TOS1900 as we matches the acpi id already. Is the
> > SPFC significant here, or is it just a "we only see SPFC on TOS1900 so it's a
> > convenient test"? If the latter, it seems rather fragile and prone to other
> > breakage to me.
> 
> Yeah, its the latter, the "SPFC" method is specific to TOS1900 devices.
> 
> All of the TOS1900 support the Toshiba specific backlight read-only,
> and that test is just to get those implementations where the AML
> code doesn't check for read/write registers, so far I've identified three
> series of laptops with this issue (all Qosmios), X500, X505 and X75-A
> (and there might be more around).
> 
> We could dissable backlight on all TOS1900 or add those three models
> to the (growing) DMI list on video.c, but of course, I would like to keep
> the code in-house, but that's just me :-)
> 

I'm having some trouble grokking the whole picture I think.

So, let's try and clear it up. We have a function to set brightness. On model
citizen laptops, after the ACPI call, out[2] is 0 (TOS_SUCCESS) and we return 0.

The extra check was added by f6aac65 to avoid registering certain badly behaved
machines (Qosmios) which always return HCI_SUCCESS, even the read/write commands
are missing. This was determined by checking for observed values in out[2]
greater than 0 and out[3] equal to 0xE000 (which presumably map to actual or max
brightness. I take it in a well behaved ACPI implementation, out[2] must be 0
and out[3] is .... what? I'll call this out[2] || out[3] state the "signature"
of a bad implementation.

Now, with bug 86521, we learn that these signatures are not necessarily bad,
some working laptops also populate these fields in this way.

Finally, while it is only TOS1900 devices that are known to be bad, all TOS1900
devices are not necessarily bad. So you don't want to block all TOS1900 devices
at probe time.

Do I have this right?

If so, this is looking more and more fragile to me. I'm inclined to push for a
blacklist of the known bad models and strip out both this and the precious extra
check, since they are based on circumstantial evidence of failure.

> >
> > Rafael, any recommendations here?


Rafael, what's your take on this? Does the above influence your position one way
or the other?



> >
> >> +             if (out[2] > 0  || out[3] == 0xE000)
> >> +                     return -ENODEV;
> >> +     }
> >>
> >>       return out[0] == TOS_SUCCESS ? 0 : -EIO;
> >>  }

-- 
Darren Hart
Intel Open Source Technology Center
