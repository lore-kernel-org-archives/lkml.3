Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab3BDLg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:36:27 -0500
Received: from smtprelay-b31.telenor.se ([213.150.131.20]:45600 "EHLO
	smtprelay-b31.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141Ab3BDLgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:36:25 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArpkAHacD1FV5qjOPGdsb2JhbABEhV+FILBeglcEgQEXAwEBAQE4NIIfAQEEAScTHCMFCwgDISUPBSUKGogeCr1TFY02gyZhA5YehgCNT4FnJA
X-IronPort-AV: E=Sophos;i="4.84,600,1355094000"; 
   d="scan'208";a="198087389"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 4 Feb 2013 12:42:26 +0100
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/9] HID: multitouch: add support for Nexio 42" panel
Message-ID: <20130204114226.GB4313@polaris.bitmath.org>
References: <1359649351-11092-1-git-send-email-benjamin.tissoires@gmail.com>
 <1359649351-11092-4-git-send-email-benjamin.tissoires@gmail.com>
 <20130203130013.GA2657@polaris.bitmath.org>
 <CAN+gG=FO7boJ7mQefL=JoggNiUS7ea6=W=+g=5fvMzpMB0x5+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+gG=FO7boJ7mQefL=JoggNiUS7ea6=W=+g=5fvMzpMB0x5+g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> > Why not an index here?
> 
> Just because an index is not sufficient. You need two things: an index
> within the field, and the actual field (a pointer to a struct
> hid_field). Each .value is local to a field, and even if in most of
> the case, the contact count is alone in its field, it would mean to
> take the risk that a new device does not follow this logic.

The field value is passed to process_mt_event() in a fairly
straight-forward fashion, I was imagining that behavior could be
copied somehow.

> So the actual pointer to the contact count value seemed to be the
> shortest way to do it. But it can be easily changed.

Keeping a pointer into the core structure creates unwanted
dependencies to the scope of that value, making an eventual core
refactoring even harder, not to mention trickier to debug. So even
though it looks neat in the code, it pushes the problem forward.

> >> @@ -251,6 +257,9 @@ static ssize_t mt_set_quirks(struct device *dev,
> >>
> >>       td->mtclass.quirks = val;
> >>
> >> +     if (!td->contactcount)
> >> +             td->mtclass.quirks &= ~MT_QUIRK_CONTACT_CNT_ACCURATE;
> >> +
> >
> > Why override the overrider here?
> 
> This callback is called from the user-space through the sysfs
> attribute. So, it is not called in the same time that the
> mt_post_parse function. This is just to avoid a user setting this
> quirk once the device is up and running leading to a potential oops.

Yes, but the quirk _is_ user modifiable. Hence, the problem lies in
equating the user-modifiable quirk with the branch control of the
program.

> > An index into the the struct actually passed in mt_report() feels safer.
> 
> again, you need to store "field" and "usage->usage_index". Agree, it
> would be safer but it will take more space... :)

If you think the code change is not only correct, but also moves the
whole code base in a good direction, by all means.

> >> @@ -750,11 +765,15 @@ static void mt_post_parse_default_settings(struct mt_device *td)
> >>  static void mt_post_parse(struct mt_device *td)
> >>  {
> >>       struct mt_fields *f = td->fields;
> >> +     struct mt_class *cls = &td->mtclass;
> >>
> >>       if (td->touches_by_report > 0) {
> >>               int field_count_per_touch = f->length / td->touches_by_report;
> >>               td->last_slot_field = f->usages[field_count_per_touch - 1];
> >>       }
> >> +
> >> +     if (!td->contactcount)
> >> +             cls->quirks &= ~MT_QUIRK_CONTACT_CNT_ACCURATE;
> >
> > Since MT_QUIRK_CONTACT_CNT_ACCURATE is a quirk, modifiable by the
> > user, it should probably not validate num_expected in the code. Better
> > use the contact count index or something equivalent for that.
> 
> As when the user changes the quirk, we validate it, this is not required.

True, barring the comments above.

Thanks,
Henrik
