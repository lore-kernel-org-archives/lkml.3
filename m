Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab3BDNm2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 08:42:28 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:61145 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab3BDNm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 08:42:27 -0500
MIME-Version: 1.0
In-Reply-To: <20130204114226.GB4313@polaris.bitmath.org>
References: <1359649351-11092-1-git-send-email-benjamin.tissoires@gmail.com>
	<1359649351-11092-4-git-send-email-benjamin.tissoires@gmail.com>
	<20130203130013.GA2657@polaris.bitmath.org>
	<CAN+gG=FO7boJ7mQefL=JoggNiUS7ea6=W=+g=5fvMzpMB0x5+g@mail.gmail.com>
	<20130204114226.GB4313@polaris.bitmath.org>
Date: Mon, 4 Feb 2013 14:42:25 +0100
Message-ID: <CAN+gG=ENL0aFmBb4Xbk3PSqeqs5-Ebcp3stW6QxMeC4fJNabYg@mail.gmail.com>
Subject: Re: [PATCH v2 3/9] HID: multitouch: add support for Nexio 42" panel
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 4, 2013 at 12:42 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Benjamin,
>
>> > Why not an index here?
>>
>> Just because an index is not sufficient. You need two things: an index
>> within the field, and the actual field (a pointer to a struct
>> hid_field). Each .value is local to a field, and even if in most of
>> the case, the contact count is alone in its field, it would mean to
>> take the risk that a new device does not follow this logic.
>
> The field value is passed to process_mt_event() in a fairly
> straight-forward fashion, I was imagining that behavior could be
> copied somehow.
>
>> So the actual pointer to the contact count value seemed to be the
>> shortest way to do it. But it can be easily changed.
>
> Keeping a pointer into the core structure creates unwanted
> dependencies to the scope of that value, making an eventual core
> refactoring even harder, not to mention trickier to debug. So even
> though it looks neat in the code, it pushes the problem forward.
>
>> >> @@ -251,6 +257,9 @@ static ssize_t mt_set_quirks(struct device *dev,
>> >>
>> >>       td->mtclass.quirks = val;
>> >>
>> >> +     if (!td->contactcount)
>> >> +             td->mtclass.quirks &= ~MT_QUIRK_CONTACT_CNT_ACCURATE;
>> >> +
>> >
>> > Why override the overrider here?
>>
>> This callback is called from the user-space through the sysfs
>> attribute. So, it is not called in the same time that the
>> mt_post_parse function. This is just to avoid a user setting this
>> quirk once the device is up and running leading to a potential oops.
>
> Yes, but the quirk _is_ user modifiable. Hence, the problem lies in
> equating the user-modifiable quirk with the branch control of the
> program.

I'm not sure I understood what you meant there.
The quirk is indeed user modifiable, but through the callback
mt_set_quirks() only. If the HID field Contact Count is not present,
this quirk should not be allowed to be present, thus the two removals
of the quirk in met_set_quirks() and mt_post_parse(). As there are no
other entry points, I'm quite confuse to understand where the pitfall
is.

>
>> > An index into the the struct actually passed in mt_report() feels safer.
>>
>> again, you need to store "field" and "usage->usage_index". Agree, it
>> would be safer but it will take more space... :)
>
> If you think the code change is not only correct, but also moves the
> whole code base in a good direction, by all means.

Ok, will do. After a deeper look at it, I can even have two int
indexes (and no pointers): one for the field and one other for the
value within the field.

Cheers,
Benjamin

>
>> >> @@ -750,11 +765,15 @@ static void mt_post_parse_default_settings(struct mt_device *td)
>> >>  static void mt_post_parse(struct mt_device *td)
>> >>  {
>> >>       struct mt_fields *f = td->fields;
>> >> +     struct mt_class *cls = &td->mtclass;
>> >>
>> >>       if (td->touches_by_report > 0) {
>> >>               int field_count_per_touch = f->length / td->touches_by_report;
>> >>               td->last_slot_field = f->usages[field_count_per_touch - 1];
>> >>       }
>> >> +
>> >> +     if (!td->contactcount)
>> >> +             cls->quirks &= ~MT_QUIRK_CONTACT_CNT_ACCURATE;
>> >
>> > Since MT_QUIRK_CONTACT_CNT_ACCURATE is a quirk, modifiable by the
>> > user, it should probably not validate num_expected in the code. Better
>> > use the contact count index or something equivalent for that.
>>
>> As when the user changes the quirk, we validate it, this is not required.
>
> True, barring the comments above.
>
> Thanks,
> Henrik
