Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758928Ab3EOO6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 10:58:14 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:38035 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699Ab3EOO6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 10:58:12 -0400
MIME-Version: 1.0
In-Reply-To: <20130513232017.GA25489@teo>
References: <1368457290-1734-1-git-send-email-dh.herrmann@gmail.com>
	<20130513232017.GA25489@teo>
Date: Wed, 15 May 2013 16:58:11 +0200
Message-ID: <CANq1E4QuuG6zBgBvBz-KDaWQQOAcmJjUMCm7zt7NaHKtEtaxDg@mail.gmail.com>
Subject: Re: [PATCH] HID: input: return ENODATA if reading battery attrs fails
From: David Herrmann <dh.herrmann@gmail.com>
To: Anton Vorontsov <anton@enomsg.org>
Cc: "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, David Woodhouse <dwmw2@infradead.org>,
        Daniel Nicoletti <dantti12@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton

On Tue, May 14, 2013 at 1:20 AM, Anton Vorontsov <anton@enomsg.org> wrote:
> On Mon, May 13, 2013 at 05:01:30PM +0200, David Herrmann wrote:
> [..]
>> I really dislike the way power_supply core calls into the drivers during the
>> "add" uevent. If a driver holds an I/O mutex (or anything else), it might
>> even deadlock in a very non-obvious way. Is there a reason why we need to
>> pass _all_ battery properties along "add" and "remove" uevents? Isn't it
>> enough to pass them with "change" uevents? This would guarantee that the
>> power_supply callbacks are only called from user-context and "change" events.
>
> I don't think that there is a particular reason for that, but if you want
> to change that, then I'd suggest to still keep uevent reporting of all the
> properties on "add" and "remove" events, but don't actually call the
> drivers' callback, just assume ENODATA.

In case of ENODATA the property is entirely skipped and not included
in the uevent. Therefore, "assuming ENODATA" would be skipping all
properties.

> This way we well preserve the behaviour of the older kernels, so that
> userland will not break if, for example, it allocates needed memory on
> "add" event, and then assumes that "change" will follow the pattern.

I tried fixing this several ways, but there is one deadlock that we
cannot overcome. If we assume a driver holds a lock during
power_supply_unregister() that it also acquires in the get_property
callback, then we will always deadlock. Just think of one CPU
currently calling the power_supply_changed_work() callback while
another CPU currently holds the driver's lock and calls
power_supply_unregister(). power_supply_changed_work() will wait for
the lock, while power_supply_unregister() will wait synchronously for
the work to finish => deadlock

As a side-note, in *_uevent() callbacks we have no chance to see what
kind of event this is. We would have to fix lib/kobject_uevent.c to
provide this information.

So I am back to fixing drivers to allow I/O / safe callbacks while
calling power_supply_register()/unregister(). This might be easy for
HID-USB drivers to implement (there is hid_device_io_start/stop()),
but for Bluetooth HID devices, this will not work as there are
bluetooth locks that are still held. And fixing HIDP isn't enough, we
would actually have to go all the way down to fix Bluetooth HCI core
to provide more fine-grained locking (at least one per hci_conn). And
even then I am not sure how to allow I/O while loading/unloading
drivers on it.

So if anybody wants to step up and fix this mess, feel free to go. I
will give up here. I might try to extend Bluetooth HIDP to allow I/O
during setup, but I currently cannot figure out _any_ way how we can
allow this during destruction/unregistration.
Sorry.

Regards
David
