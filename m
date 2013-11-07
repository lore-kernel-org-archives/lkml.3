Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab3KGPt5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 10:49:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162Ab3KGPtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 10:49:55 -0500
Message-ID: <527BB695.9040209@redhat.com>
Date: Thu, 07 Nov 2013 10:49:41 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: James Henstridge <james.henstridge@canonical.com>,
        Jiri Kosina <jkosina@suse.cz>
CC: Luis Henriques <luis.henriques@canonical.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        =?ISO-8859-1?Q?Fabien_Andr=E9?= <fabien.andre@gmail.com>,
        Bastien Nocera <hadess@hadess.net>
Subject: Re: [appleir] BUG: unable to handle kernel NULL pointer dereference
References: <20131029145139.GA2788@hercules>	<alpine.LNX.2.00.1311061635160.835@pobox.suse.cz> <CALcaVO=jOEqCwLCMUgEkFJMcc4H6bMLU4yvjo1fJ7DeXgkZH6A@mail.gmail.com>
In-Reply-To: <CALcaVO=jOEqCwLCMUgEkFJMcc4H6bMLU4yvjo1fJ7DeXgkZH6A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

On 07/11/13 02:52, James Henstridge wrote:
> On Wed, Nov 6, 2013 at 11:38 PM, Jiri Kosina <jkosina@suse.cz> wrote:
>> On Tue, 29 Oct 2013, Luis Henriques wrote:
>>
>>> James has reported a NULL pointer dereference[1] on the appleir
>>> driver.  From the bug report[2] it looks like it is 100%
>>> reproducible using a 3.12-rc6 kernel simply by pressing any button on
>>> the IR remote.
>>>
>>> >From the stack trace, it looks like input_event is invoked with the
>>> input_dev parameter set to NULL, which seems to indicate that
>>> appleir_input_configured is never invoked.
>>>
>>> Any ideas?
>>>
>>> [1] https://launchpadlibrarian.net/154942024/macmini-oops.jpg
>>> [2] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1244505
>>
>> [ adding some more CCs ]
>>
>> Okay, so apparently we didn't register with input, but only hiddev /
>> hidraw.
>>
>> appleir 0003:05AC:8240.0005: hiddev0,hidraw4: USB HID v1.11 Device [Apple Computer, Inc. IR Receiver] on usb-0000:00:1d.3-2/input0
>>
>> Therefore ->input_configured() callback has never been called, and thus we
>> oops due to appleir->input_dev being NULL when the first raw event is
>> reported.
>>
>> Could you please provide report descriptor of the device?
>>
>> The driver apparently relies on it being registered with hid-input, but
>> for some reason that doesn't happen.
> 
> Here is the relevant lsusb output that I think contains what you're
> asking for (I had to unbind usbhid for it to include the descriptor):
> 
> Bus 005 Device 003: ID 05ac:8240 Apple, Inc. Built-in IR Receiver
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               2.00
> ...

Ok, thanks for the report. Could you please test the following patch
which should solve your problem (hopefully)?

Cheers,
Benjamin

--

>From 54b332b992da1666abe7180b6cecd313c864e0b7 Mon Sep 17 00:00:00 2001
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date: Thu, 7 Nov 2013 10:46:48 -0500
Subject: [PATCH] HID: appleir: force input to be set

Some weird remotes are not correctly creating the input device. Their
report descriptor starts with:
0x06, 0x00, 0xff,              // Usage Page (Vendor Defined Page 1)  0
0xa1, 0x01,                    // Collection (Application)            3

whereas others (which are correctly handled) start with:
0x05, 0x0c,                    // Usage Page (Consumer Devices)       0
0x09, 0x01,                    // Usage (Consumer Control)            2
0xa1, 0x01,                    // Collection (Application)            4

The rest of the report descriptor is the same.

Adding the quirk HID_QUIRK_HIDINPUT_FORCE forces hid-input to allocate
the inputs, and everything should be ok.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-appleir.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hid/hid-appleir.c b/drivers/hid/hid-appleir.c
index a42e6a3..0e6a42d 100644
--- a/drivers/hid/hid-appleir.c
+++ b/drivers/hid/hid-appleir.c
@@ -297,6 +297,9 @@ static int appleir_probe(struct hid_device *hid, const struct hid_device_id *id)
 
 	appleir->hid = hid;
 
+	/* force input as some remotes bypass the input registration */
+	hid->quirks |= HID_QUIRK_HIDINPUT_FORCE;
+
 	spin_lock_init(&appleir->lock);
 	setup_timer(&appleir->key_up_timer,
 		    key_up_tick, (unsigned long) appleir);
-- 
1.8.3.1

