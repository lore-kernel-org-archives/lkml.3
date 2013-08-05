Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab3HEOkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 10:40:46 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:59937 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab3HEOko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 10:40:44 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1308051516181.17512@pobox.suse.cz>
References: <1374153691-25100-1-git-send-email-nlopezcasad@logitech.com>
	<1374153691-25100-2-git-send-email-nlopezcasad@logitech.com>
	<CAN+gG=GcS7pfK9K5FuW9TyX+PJWNkXZWLk8UX9PzLXom2PSpgQ@mail.gmail.com>
	<alpine.LNX.2.00.1308020309340.24017@pobox.suse.cz>
	<CAN+gG=FV=OjnktkET-_KM_iTPStsWCKdj8fpyktnJczusFz0=w@mail.gmail.com>
	<alpine.LNX.2.00.1308051516181.17512@pobox.suse.cz>
Date: Mon, 5 Aug 2013 16:40:42 +0200
Message-ID: <CAN+gG=Hjd1Ay0=HrJdV9797DxTMf97_13kdkuHNWi24EfPL-ig@mail.gmail.com>
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

On Mon, Aug 5, 2013 at 3:22 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Fri, 2 Aug 2013, Benjamin Tissoires wrote:
>
>> > Could you please elaborate? (and put an elaborate description to revert
>> > commit log perhaps?)
>>
>> Sure, so here is the revert commit log:
>>
>> --
>>
>> Commit "HID: hid-logitech-dj, querying_devices was never set" activate
>> a flag which guarantees that we do not ask the receiver for too many
>> enumeration. When the flag is set, each following enumeration call is
>> discarded (the usb request is not forwarded to the receiver). The flag
>> is then released when the driver receive a pairing information event,
>> which normally follows the enumeration request.
>> However, the USB3 bug makes the driver think the enumeration request
>> has been forwarded to the receiver. However, it is actually not the
>> case because the USB stack returns -EPIPE. So, when a new unknown
>> device appears, the workaround consisting in asking for a new
>> enumeration is not working anymore: this new enumeration is discarded
>> because of the flag, which is never reset.
>>
>> A solution could be to trigger a timeout before releasing it, but for
>> now, let's just revert the patch.
>>
>> --
>
> Thanks Benjamin.
>
> I'd like to have a bit more clarification about the USB3 bug, as this
> whole issue is not completely clear to me.
>
> To be more specific -- when exactly do we receive -EPIPE, why do we
> receive it and why do we not handle it properly?

Sure, I'll try (though the more I think of it, the more it seems
blurry to me :( ).

So the initial probe function in hid-logitech-dj was implemented by
using a direct call to hid_output_raw_report(). This call was
synchronous, so we did get the -EPIPE return code. Then, the probe()
function returns the -EPIPE error, cleaning the receiver and
unregister it from the hid bus.

However, now, we use hid_hw_request(), which is asynchronous (from
what I can read). At least, this code returns "void" as the set_report
command seems to be scheduled for later handling. In usbhid, when the
queue is flushed, I did not found a way to retrieve the error code...

So basically, the -EPIPE is received in usbhid_restart_ctrl_queue(),
but nothing notifies hid-logitech-dj from the error. In the end, the
probe() function returns without error code, but the receiver never
received the notification.

Cheers,
Benjamin
