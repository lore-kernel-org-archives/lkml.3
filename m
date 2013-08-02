Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab3HBScE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 14:32:04 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:32863 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab3HBScB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 14:32:01 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1308020309340.24017@pobox.suse.cz>
References: <1374153691-25100-1-git-send-email-nlopezcasad@logitech.com>
	<1374153691-25100-2-git-send-email-nlopezcasad@logitech.com>
	<CAN+gG=GcS7pfK9K5FuW9TyX+PJWNkXZWLk8UX9PzLXom2PSpgQ@mail.gmail.com>
	<alpine.LNX.2.00.1308020309340.24017@pobox.suse.cz>
Date: Fri, 2 Aug 2013 20:31:59 +0200
Message-ID: <CAN+gG=FV=OjnktkET-_KM_iTPStsWCKdj8fpyktnJczusFz0=w@mail.gmail.com>
Subject: Re: [PATCH 2/2] HID: hid-logitech-dj, querying_devices was never set
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Andrew de los Reyes <adlr@chromium.org>,
        joseph.salisbury@canonical.com,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 2, 2013 at 3:11 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Thu, 1 Aug 2013, Benjamin Tissoires wrote:
>
>> > Set querying_devices flag to true when we start the enumeration
>> > process.
>> >
>> > This was missing from the original patch. It never produced
>> > undesirable effects as it is highly improbable to have a second
>> > enumeration triggered while a first one was still in progress.
>> >
>> > Signed-off-by: Nestor Lopez Casado <nlopezcasad@logitech.com>
>> > ---
>> >  drivers/hid/hid-logitech-dj.c |    2 ++
>> >  1 file changed, 2 insertions(+)
>> >
>> > diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
>> > index 0d13389..d4657a5 100644
>> > --- a/drivers/hid/hid-logitech-dj.c
>> > +++ b/drivers/hid/hid-logitech-dj.c
>> > @@ -488,6 +488,8 @@ static int logi_dj_recv_query_paired_devices(struct dj_receiver_dev *djrcv_dev)
>> >         if (djrcv_dev->querying_devices)
>> >                 return 0;
>> >
>> > +       djrcv_dev->querying_devices = true;
>> > +
>>
>> Unfortunately, this breaks the fallback mechanism :(
>> We tried to add the two patches in Fedora [1], but this doesn't fix
>> the bug because the driver actually things that it already asked for
>> the enumeration, but as we get the -EPIPE error, the request was never
>> sent.
>>
>> So, Jiri, if you were to submit that series to Linus (or Greg) for
>> fixing the bug, please just drop this second patch.
>
> It's already on its way to Linus (he hasn't pulled yet though) ... which
> is not a big deal per se, I can always push a revert, but I have to admit
> I don't understand the breakage it is causing at all.
>
> Could you please elaborate? (and put an elaborate description to revert
> commit log perhaps?)

Sure, so here is the revert commit log:

--

Commit "HID: hid-logitech-dj, querying_devices was never set" activate
a flag which guarantees that we do not ask the receiver for too many
enumeration. When the flag is set, each following enumeration call is
discarded (the usb request is not forwarded to the receiver). The flag
is then released when the driver receive a pairing information event,
which normally follows the enumeration request.
However, the USB3 bug makes the driver think the enumeration request
has been forwarded to the receiver. However, it is actually not the
case because the USB stack returns -EPIPE. So, when a new unknown
device appears, the workaround consisting in asking for a new
enumeration is not working anymore: this new enumeration is discarded
because of the flag, which is never reset.

A solution could be to trigger a timeout before releasing it, but for
now, let's just revert the patch.

--

Does that makes it more understandable? I'm sorry I was not clear last
time, I was trying to catch this up between two sessions at GUADEC.

Cheers,
Benjamin
