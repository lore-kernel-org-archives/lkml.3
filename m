Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759743Ab3BYPGI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 10:06:08 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:49042 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290Ab3BYPGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 10:06:04 -0500
MIME-Version: 1.0
In-Reply-To: <CANq1E4Sa2NhCaqbx+Spd49ffsLqbMM-pRraJVxAoXAaBg7CH8w@mail.gmail.com>
References: <1361788310-6048-1-git-send-email-benjamin.tissoires@gmail.com>
	<alpine.LNX.2.00.1302251328070.2128@pobox.suse.cz>
	<CANq1E4Sa2NhCaqbx+Spd49ffsLqbMM-pRraJVxAoXAaBg7CH8w@mail.gmail.com>
Date: Mon, 25 Feb 2013 16:06:01 +0100
Message-ID: <CAN+gG=GmK4eHizLG6pE0gxSNBsQMg8R+KcUZk8P8-G84t1XUJQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] hid driver transport cleanup
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@enac.fr>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Mon, Feb 25, 2013 at 2:41 PM, David Herrmann <dh.herrmann@gmail.com> wrote:
> Hi guys
>
> On Mon, Feb 25, 2013 at 1:29 PM, Jiri Kosina <jkosina@suse.cz> wrote:
>> On Mon, 25 Feb 2013, Benjamin Tissoires wrote:
>>
>>> Hi guys,
>>>
>>> this is the v2 of the hid transport cleanup.
>>>
>>> Changes since v1:
>>> - gathered reviewed/acked/etc..
>>> - changed commit messages of patches 4-6
>>> - add newcomer into account (thingm)
>>> - incorporated the i2c-hid driver change into the series
>>>
>>> I still did not implemented the final usb cleanup for hid-multitouch as it may
>>> required few comments.
>>
>> I have now taken the series. Thanks Benjamin, thanks Henrik.
>
> I rewrote the Bluetooth HID session-management last week (patches
> pending on linux-bluetooth@vger) as it was horribly broken. This week
> I will try to fix the get_report/set_report mess with Bluetooth-HID,
> so I was wondering whether you could clear some things up.

Sure, I'll do my best. I'm not sure that you will have a better idea
after my answers because the use cases are very different and there is
not a good rational for each use.

>
> (I did read the Bluetooth HID Profile specification but I have no idea
> how USB does it, so please bear with me if I mix things up. Maybe some
> day I will have the time to read the USB specs, too)
>
> * There are several drivers using "dev->hid_get_raw_report()" and
> "dev->hid_output_raw_report()". Any objections to moving these to
> "hid_ll_driver" and adding wrapper functions
> hid_hw_get/output_raw_report()?

I can't see any. Those two callbacks are transport dependent, so I
also think it makes sense to put them into hid_ll_driver.

I also wish we have the set/get hid idle callback (it would remove the
last usb dependency in hid-multitouch).

>
> * What should the ll->report() callback exactly do? Should it simply
> send a GET_REPORT or SET_REPORT request depending on the direction
> (nonblocking)?

Well, given the way it's used in hid drivers and usbhid/i2c-hid:
- SET_REPORT takes an already parsed report and send it to the device
-> the usbhid part is nonblocking, i2c-hid is blocking.
- GET_REPORT asks for the HID command GET_REPORT and once it's done,
the incoming report is parsed as if it was spontaneously generated
(meaning that there are no guarantees that the report the caller reads
after report() is the requested one).

The patch for implementing those functions in i2c-hid is IMHO simpler
to understand than the usb one as i2c-hid makes no use of dma or async
calls.

For the nonblocking part, the usb pendant is asynchronous, thus the
need of the .wait().
The i2c-hid driver is synchronous, meaning that the call is blocking
(sorry). But .wait() is not required to be called, and then, we don't
need to set it.

>
> * Why don't we do the hid_output_report() call in the hid_hw_report()
> helper and pass the raw buffers down? It would allow GFP_KERNEL and
> avoid duplicating code in all four backends.

Well. I continued Henrik's work on that, and the idea was to not break
any existing device. So, the code path should be the nearest possible
to the existing one. Now that this part is done, we can look at
something more efficient in terms of duplication.

Actually, the implementation of i2c-hid .request() already uses the
raw buffers commands, meaning that it's nearly what we need (except
that we need  to get the size of the buffer in some other way).

However, in usbhid and i2c-hid, .hid_get_raw_report() and
.hid_output_raw_report() are blocking, meaning that it will change the
current behavior for drivers.

>
> * What should ll->wait() exactly do? Block until the last
> SET/GET_REPORT call has been ack'ed by the device?
>

It waits for at most 10*HZ until both the CTRL (command queue for
set_report/get_report and 90% of the hid communication) and the OUTPUT
queues are empty.
Honestly, I don't like the way the wait is done: nobody cares about
the return value, meaning that nobody know why we have finished to
wait. In 90% of the cases, it's used in conjunction with a .request()
call.

So to sum up, given its current use, I would say that .wait() "blocks
until all queues are flushed or for an amount of time that gives the
caller good chances that his/her previous call has been transferred to
the device".

> * Bluetooth-HID might return errors on GET/SET_REPORT. Why don't we
> return these in hid_hw_wait() for the last report? It would allow
> synchronous calls like:
> hid_hw_report();
> ret = hid_hw_wait();

As there are several uses of .wait(), it seems difficult.
Some are using it to make 'sure' that their previous command has been
sent -> in this case, I would say, yes, go for it.
Some others are using it for it's real purpose: flush the queues
before/after sending new commands -> it's difficult to put the last
command result as a return value in this case (the latest result does
not mean anything to the caller).

Maybe turning the hid_hw_report() for these cases into a blocking one
would solve the problem.

>
> * Should hid_hw_report() allow multiple pending requests? Or should it
> return an error if there is another pending report that hasn't been
> ack'ed, yet?

I would say that it should.
If you ask for a report, it's then parsed through hid_input_report,
meaning that you can ask for several reports at the same time. Each of
them will be parsed in it's own buffer.

>
> I will try to implement it for Bluetooth-HID and UHID if no-one else
> wants to do it. Doing it for UHID would make debugging/emulating
> devices a lot easier.

That would be great. I can't do the bluetooth part (I'm lacking of
hardware), and for the UHID part... I don't really care about it in my
tests for now :)

Cheers,
Benjamin
