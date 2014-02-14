Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbaBNNfw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 08:35:52 -0500
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:57277 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752025AbaBNNfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 08:35:51 -0500
MIME-Version: 1.0
In-Reply-To: <CAE7qMrpEnF3y-dVP14190y33YNidCdjtJeO9PcMVcBBJDJsYuw@mail.gmail.com>
References: <1389219529-29671-1-git-send-email-benjamin.tissoires@redhat.com>
 <1389219529-29671-2-git-send-email-benjamin.tissoires@redhat.com>
 <alpine.LNX.2.00.1401162249150.23018@pobox.suse.cz> <CAE7qMrpEKYesrcHkhTYxCCOW3TRA7P8SOX9brj83zqY7y=3_3g@mail.gmail.com>
 <CAE7qMrpEnF3y-dVP14190y33YNidCdjtJeO9PcMVcBBJDJsYuw@mail.gmail.com>
From: Nestor Lopez Casado <nlopezcasad@logitech.com>
Date: Fri, 14 Feb 2014 14:35:19 +0100
Message-ID: <CAE7qMrqek3tw13jLu8KW0Ns4Uv8QdPrnGoLoRkPw4ebf=EVynw@mail.gmail.com>
Subject: Re: [PATCH 1/5] HID: logitech-dj: Fix USB 3.0 issue
To: Jiri Kosina <jkosina@suse.cz>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Andrew de los Reyes <adlr@chromium.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We discussed this issue with one of the receiver firmware developers today.

We do see a clear issue when more than one DJ command (those with
report id 0x20, 0x21) are sent to the receiver in quick sequence. The
second command can be trashed if the first is still under processing,
and there is no way for the host to know when the receiver has
actually finished processing the first DJ command.

Both the first and the second commands are ACKed at the USB level.

For hidpp commands (those with report id 0x10, 0x11) there is a
response sent from the receiver to the host, and the host should wait
for the response before sending a new command.

For some DJ commands (those with report id 0x20, 0x21) there is no
response at all, as is the case for the 0x80 (switch to dj mode with
keep alive)

So the ugly sleep accounts to workaround this issue on the receiver.

There may be a cleaner workaround that could be tested (I did not test
myself, but looking at the receiver code it does seem as a plausible
solution)

Invert the order in which the commands are sent to the receiver:

First send the CMD_GET_PAIRED_DEVICES (0x81) to the receiver, and wait
to get all the device paired notifications, (the last notification is
specially tagged), then send the CMD_SWITCH (0x80).
Using this mechanism we guarantee that the receiver never sees a
second command while still processing the previous one and no explicit
sleep will be required.

For me, the ugly sleep suffices, as long as we understand the root
cause of the problem.

Cheers,
-nestor

On Fri, Feb 14, 2014 at 2:32 PM, Nestor Lopez Casado
<nlopezcasad@logitech.com> wrote:
> We discussed this issue with one of the receiver firmware developers today.
>
> We do see a clear issue when more than one DJ command (those with report id
> 0x20, 0x21) are sent to the receiver in quick sequence. The second command
> can be trashed if the first is still under processing, and there is no way
> for the host to know when the receiver has actually finished processing the
> first DJ command.
>
> Both the first and the second commands are ACKed at the USB level.
>
> For hidpp commands (those with report id 0x10, 0x11) there is a response
> sent from the receiver to the host, and the host should wait for the
> response before sending a new command.
>
> For some DJ commands (those with report id 0x20, 0x21) there is no response
> at all, as is the case for the 0x80 (switch to dj mode with keep alive)
>
> So the ugly sleep accounts to workaround this issue on the receiver.
>
> There may be a cleaner workaround that could be tested (I did not test
> myself, but looking at the receiver code it does seem as a plausible
> solution)
>
> Invert the order in which the commands are sent to the receiver:
>
> First send the CMD_GET_PAIRED_DEVICES (0x81) to the receiver, and wait to
> get all the device paired notifications, (the last notification is specially
> tagged), then send the CMD_SWITCH (0x80).
> Using this mechanism we guarantee that the receiver never sees a second
> command while still processing the previous one and no explicit sleep will
> be required.
>
> For me, the ugly sleep suffices, as long as we understand the root cause of
> the problem.
>
> Cheers,
> -nestor
>
>
> On Fri, Jan 17, 2014 at 9:48 AM, Nestor Lopez Casado
> <nlopezcasad@logitech.com> wrote:
>>
>> On Thu, Jan 16, 2014 at 10:50 PM, Jiri Kosina <jkosina@suse.cz> wrote:
>> > On Wed, 8 Jan 2014, Benjamin Tissoires wrote:
>> >
>> >> From: Benjamin Tisssoires <benjamin.tissoires@redhat.com>
>> >>
>> >> This fix (not very clean though) should fix the long time USB3
>> >> issue that was spotted last year. The rational has been given by
>> >> Hans de Goede:
>> >
>> > Man this is so ugly ... makes one wonder how come that other OSes don't
>> > suffer from this. Are they really *that much* slower? :)
>> >
>> > I have applied this (and just this) one for 3.14.
>>
>> This is clearly a workaround for an underlying bug.
>> Most probably the issue is in the receiver firmware, and the bug
>> happens to become apparent easier when it is plugged in a usb 3.0
>> port.
>> We are experiencing some issues when the receiver is plugged to usb
>> 3.0 ports in other OSes as well, these could also be explained by the
>> same phenomenon of vendor requests being missed by the receiver. But
>> we dont have a clear understanding of the problem yet.
>>
>> >
>> > Thanks,
>> >
>> > --
>> > Jiri Kosina
>> > SUSE Labs
>> Cheers,
>> -nestor
>
>
