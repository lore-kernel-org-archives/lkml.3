Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782Ab3HIRDB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 13:03:01 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:37603 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab3HIRDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 13:03:00 -0400
MIME-Version: 1.0
In-Reply-To: <520519E7.3020807@ahsoftware.de>
References: <1375382342-25454-1-git-send-email-holler@ahsoftware.de>
	<1375382342-25454-2-git-send-email-holler@ahsoftware.de>
	<20130808151106.7ccaedd4ea3d4e5faa6aa220@linux-foundation.org>
	<5204BA2E.8000100@ahsoftware.de>
	<alpine.LNX.2.00.1308091310490.13089@pobox.suse.cz>
	<5205170E.9030605@ahsoftware.de>
	<520519E7.3020807@ahsoftware.de>
Date: Fri, 9 Aug 2013 19:02:59 +0200
Message-ID: <CANq1E4TkgKsZcJAygY4k8rwvYMPku_uzWqhcgp+HkfMsb+n84Q@mail.gmail.com>
Subject: Re: [rtc-linux] Re: [PATCH 2/2 RESEND] rtc: rtc-hid-sensor-time:
 enable HID input processing early
From: David Herrmann <dh.herrmann@gmail.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: rtc-linux@googlegroups.com, Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Andrew de los Reyes <adlr@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander

On Fri, Aug 9, 2013 at 6:33 PM, Alexander Holler <holler@ahsoftware.de> wrote:
> Am 09.08.2013 18:21, schrieb Alexander Holler:
>
>> I've now also verified if hid-sensor-hub receives an event with
>> sensor_hub_raw_event() in the error-path (hid_device_io_stop() called
>> and probe() failed), and this still *does* happen. That event (input
>> report) doesn't come through hid-sensor-hub to my driver, but I think
>> this is because of my call to sensor_hub_remove_callback() which is in
>> the error path too.
>> So I actually wonder why the input report still is reported from the
>> hid-subsystem to hid-sensor-hub, even after I've called
>> hid_device_io_stop() and probe() failed.
>> Maybe everything is still ok and I just got confused with the somehow
>> complicate interactions between the usb- and hid-subsystem,
>> hid-sensor-hub (which uses MFD) and rtc-hid-sensor-time.
>
>
> Adding some more stuff to the confusion: Currently I think it is correct
> that hid-sensor-hub still receives the event, even after rtc-hid-sensor-time
> called hid_device_io_stop() and probe() failed. The reason the same reason,
> why hid-sensor-hub uses mfd, the actual hardware device might be shared by
> different drivers (therfor -hub).

I don't have time right know to debug this, but I thought I'd just
clarify how the HID I/O lock works:

HID core uses a semaphore to protect driver probe and removal. That
is, the semaphore is locked during the ->probe() and ->remove()
callbacks. The input event handler (in atomic context!) tries to lock
this, too. If it fails due to ->probe or ->remove currently running,
it simply drops the input events (which is fine for reasons that don't
matter here). If it can lock it, it simply calls the ->raw_event() or
whatever callbacks of the driver (probably via hid-input).
If no driver is currently bound to a device, all input events are
always dropped.

If a driver now needs to perform I/O during ->probe or ->remove, they
must explicitly notify HID core about this. We cannot allow it
automatically as drivers must have a chance to setup some context
before the first events are passed in.
We start I/O via hid_device_io_start(). This simply releases the
->probe() semaphore and makes sure HID core knows about this. Once you
call it, your drivers input callbacks will be used by HID core so you
can perform I/O. Once you call hid_device_io_stop() the semaphore is
locked again and no more I/O is possible.

Same applies to the ->remove() callback, although it's not used by any
driver, yet. The reason is that ->remove() is almost always called if
the transport layer is already closed so any I/O will return -EIO.

We make sure we don't do any double down() or up() by tracking it via
a boolean. The memory barriers there aren't really obvious but it
should be correct.

I hope that explains how all this works. I can look over your patch on
Sunday if still necessary.

Cheers
David
