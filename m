Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948Ab3BYNly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 08:41:54 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:51383 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756399Ab3BYNlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 08:41:52 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1302251328070.2128@pobox.suse.cz>
References: <1361788310-6048-1-git-send-email-benjamin.tissoires@gmail.com>
	<alpine.LNX.2.00.1302251328070.2128@pobox.suse.cz>
Date: Mon, 25 Feb 2013 14:41:51 +0100
Message-ID: <CANq1E4Sa2NhCaqbx+Spd49ffsLqbMM-pRraJVxAoXAaBg7CH8w@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] hid driver transport cleanup
From: David Herrmann <dh.herrmann@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Stephane Chatty <chatty@enac.fr>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys

On Mon, Feb 25, 2013 at 1:29 PM, Jiri Kosina <jkosina@suse.cz> wrote:
> On Mon, 25 Feb 2013, Benjamin Tissoires wrote:
>
>> Hi guys,
>>
>> this is the v2 of the hid transport cleanup.
>>
>> Changes since v1:
>> - gathered reviewed/acked/etc..
>> - changed commit messages of patches 4-6
>> - add newcomer into account (thingm)
>> - incorporated the i2c-hid driver change into the series
>>
>> I still did not implemented the final usb cleanup for hid-multitouch as it may
>> required few comments.
>
> I have now taken the series. Thanks Benjamin, thanks Henrik.

I rewrote the Bluetooth HID session-management last week (patches
pending on linux-bluetooth@vger) as it was horribly broken. This week
I will try to fix the get_report/set_report mess with Bluetooth-HID,
so I was wondering whether you could clear some things up.

(I did read the Bluetooth HID Profile specification but I have no idea
how USB does it, so please bear with me if I mix things up. Maybe some
day I will have the time to read the USB specs, too)

* There are several drivers using "dev->hid_get_raw_report()" and
"dev->hid_output_raw_report()". Any objections to moving these to
"hid_ll_driver" and adding wrapper functions
hid_hw_get/output_raw_report()?

* What should the ll->report() callback exactly do? Should it simply
send a GET_REPORT or SET_REPORT request depending on the direction
(nonblocking)?

* Why don't we do the hid_output_report() call in the hid_hw_report()
helper and pass the raw buffers down? It would allow GFP_KERNEL and
avoid duplicating code in all four backends.

* What should ll->wait() exactly do? Block until the last
SET/GET_REPORT call has been ack'ed by the device?

* Bluetooth-HID might return errors on GET/SET_REPORT. Why don't we
return these in hid_hw_wait() for the last report? It would allow
synchronous calls like:
hid_hw_report();
ret = hid_hw_wait();

* Should hid_hw_report() allow multiple pending requests? Or should it
return an error if there is another pending report that hasn't been
ack'ed, yet?

I will try to implement it for Bluetooth-HID and UHID if no-one else
wants to do it. Doing it for UHID would make debugging/emulating
devices a lot easier.

Thanks
David
