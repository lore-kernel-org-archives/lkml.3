Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbaLPPi0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 10:38:26 -0500
Received: from mail-qa0-f48.google.com ([209.85.216.48]:38881 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbaLPPiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 10:38:24 -0500
MIME-Version: 1.0
In-Reply-To: <9001812.kk9brShn75@al>
References: <1418691016-30681-1-git-send-email-peter@lekensteyn.nl>
	<1418691016-30681-3-git-send-email-peter@lekensteyn.nl>
	<CAN+gG=HWqpy6MUfWvwBavk+EkmwbBiCCN0L1_i8H61WYRU0yGw@mail.gmail.com>
	<9001812.kk9brShn75@al>
Date: Tue, 16 Dec 2014 10:38:23 -0500
Message-ID: <CAN+gG=EL0kYim=_uaS4yj7c_XC8rKa1eELxpVXaOuvnWgT_eQw@mail.gmail.com>
Subject: Re: [PATCH 2/3] HID: logitech-{dj,hidpp}: check report length
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Peter Wu <peter@lekensteyn.nl>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2014 at 10:20 AM, Peter Wu <peter@lekensteyn.nl> wrote:
> On Tuesday 16 December 2014 09:53:07 Benjamin Tissoires wrote:
>> On Mon, Dec 15, 2014 at 7:50 PM, Peter Wu <peter@lekensteyn.nl> wrote:
>> > Malicious USB devices can send bogus reports smaller than the expected
>> > buffer size. Ensure that the length is valid to avoid reading out of
>> > bounds.
>> >
>> > For the old WTP, I do not have a HID descriptor so just check for the
>> > minimum length in hidpp_raw_event (this can be changed to an inequality
>> > later).
>>
>> Actually you have it :)
>> All the DJ devices share the same report descriptors as they are
>> provided by hid-logitech-dj :)
>
> I see, I thought it was read from the hardware, but that probably
> applies to the other interfaces. Looks like the report should have a
> length of (16 + 12 * 2 + 8 + 8) / 8 = 7 bytes, correct?

Well, if you count the report ID, you get 8 :)
(it's easier to just plug a DJ mouse and look for the incoming report ;-P )

>
>> Anyway, the problem here would be with the bluetooth touchpad T651
>> which sends its raw events over teh mouse (0x02) collection (hint:
>> there is a "< 21" in wtp_raw_event :-P )
>
> Huh, how can that be allowed if the mouse descriptor accept less? Does
> the bluetooth layer pad the report somehow?

2 things actually:
- the bluetooth T651 connects through hidp directly (the bluetooth hid
stack), and it has its own report descriptor which contains the vendor
defined extra data in the mouse collection.
- look at the magic mouse report descriptor, apple does not even
announce the raw report ID, so from time to time, vendor do _really_
ugly things :)

>
>> >
>> > Signed-off-by: Peter Wu <peter@lekensteyn.nl>
>> > ---
>> > Hi,
>> >
>> > If you know that the WTP report (ID 2) has a length of 2, then you can change
>> > "<" to "!=" and remove the paragraph from the commit message.
>>
>> "<" should be kept for the reason above.
>>
>> >
>> > Kind regards,
>> > Peter
>> > ---
>> >  drivers/hid/hid-logitech-dj.c    | 16 +++++++++++++++-
>> >  drivers/hid/hid-logitech-hidpp.c | 12 +++++++++---
>> >  2 files changed, 24 insertions(+), 4 deletions(-)
>> >
>> > diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
>> > index c917ab6..5bc6d80 100644
>> > --- a/drivers/hid/hid-logitech-dj.c
>> > +++ b/drivers/hid/hid-logitech-dj.c
>> > @@ -962,10 +962,24 @@ static int logi_dj_raw_event(struct hid_device *hdev,
>> >
>> >         switch (data[0]) {
>> >         case REPORT_ID_DJ_SHORT:
>> > +               if (size != DJREPORT_SHORT_LENGTH) {
>> > +                       dev_err(&hdev->dev, "DJ report of bad size (%d)", size);
>> > +                       return false;
>> > +               }
>> >                 return logi_dj_dj_event(hdev, report, data, size);
>> >         case REPORT_ID_HIDPP_SHORT:
>> > -               /* intentional fallthrough */
>> > +               if (size != HIDPP_REPORT_SHORT_LENGTH) {
>> > +                       dev_err(&hdev->dev,
>> > +                               "Short HID++ report of bad size (%d)", size);
>> > +                       return false;
>> > +               }
>> > +               return logi_dj_hidpp_event(hdev, report, data, size);
>> >         case REPORT_ID_HIDPP_LONG:
>> > +               if (size != HIDPP_REPORT_LONG_LENGTH) {
>> > +                       dev_err(&hdev->dev,
>> > +                               "Long HID++ report of bad size (%d)", size);
>> > +                       return false;
>> > +               }
>>
>> This hunk is good to me.
>>
>> >                 return logi_dj_hidpp_event(hdev, report, data, size);
>> >         }
>> >
>> > diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
>> > index ae23dec..2315358 100644
>> > --- a/drivers/hid/hid-logitech-hidpp.c
>> > +++ b/drivers/hid/hid-logitech-hidpp.c
>> > @@ -992,11 +992,17 @@ static int hidpp_raw_event(struct hid_device *hdev, struct hid_report *report,
>> >                         return 1;
>> >                 }
>> >                 return hidpp_raw_hidpp_event(hidpp, data, size);
>> > +       case 0x02:
>> > +               if (size < 2) {
>> > +                       hid_err(hdev, "Received HID report of bad size (%d)",
>> > +                               size);
>> > +                       return 1;
>> > +               }
>> > +               if (hidpp->quirks & HIDPP_QUIRK_CLASS_WTP)
>> > +                       return wtp_raw_event(hdev, data, size);
>> > +               return 1;
>> >         }
>> >
>> > -       if (hidpp->quirks & HIDPP_QUIRK_CLASS_WTP)
>> > -               return wtp_raw_event(hdev, data, size);
>>
>> This one is OK, but I don't like it.
>>
>> wtp_raw_event also expects long hid++ reports, and I'd prefer having
>> the raw_event() callback first checking on the generic hid++ reports,
>> and then addressing the various subclasses of devices.
>> After a better look at the code, it occurs that the actual code is
>> already pretty messed up.
>> wtp_raw_event() is called both in the generic hidpp_raw_event() and in
>> the specific hidpp_raw_hidpp_event().
>> This is IMO a design flaw and it should be fixed in a better way.
>>
>> I'd better have:
>>
>> - A check on the report size
>> - A call to the specific hidpp_raw_hidpp_event()
>> - if the previous does not return 1 (consumed event), then check on
>> all subclasses and call their specific raw_event.
>>
>> Does that make sense?
>>
>> If you agree, you can split the patch in 3, one for the -dj, one for
>> the -hidpp checks, and one for the redesign. I'd be happy to make the
>> redesign if you do not want to reshuffle it in a third patch.
>
> wtp_raw_event got called earlier through the long HID++ report handler
> (which returns, so it cannot be called twice?). It looked surprising at

Yeah, that's what I was referring to when I said I badly designed this.

> first, so it makes sense to split it up. I'll send a V2 for this patch
> (leaving the other ones in this bundle untouched).

OK, thanks for that. I'll check on the rest after your series.

>
> Kind regards,
> Peter
>
> PS. I saw a mail on LKML from a maintainer who was not so happy with the
> timing of patches. If my patch submissions are at the wrong moment,
> please let me know.

This is my personal opinion and Jiri can say something different. I
tend not to send big patches while there is a window opened. Sometimes
Jiri has the time to get through them, sometime he does not.
In this case, I think the patches you sent should be in the bugs fixes
categories, and, IMO should make into 3.19-rc1 or 3.19-rc2 (especially
the length check which could lead to CVEs if not tackled soon enough).
For these kind of things there is no timing, and the sooner the
better.
That being said, make sure that you keep track of those patches in
case they get lost for obvious reasons and be prepared to remind about
them if they do not make their way in Jiri's tree.

Jiri, comments?

Cheers,
Benjamin

>
>>
>> Cheers,
>> Benjamin
>>
>> > -
>> >         return 0;
>> >  }
>> >
>> > --
>> > 2.1.3
>
