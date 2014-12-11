Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208AbaLKSmB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 13:42:01 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:42985 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966AbaLKSl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 13:41:59 -0500
MIME-Version: 1.0
In-Reply-To: <2128690.c90ERDd9ZP@xps13>
References: <31518562.V5Oyo0POsI@xps13>
	<20141211085801.GR1300@lahna.fi.intel.com>
	<20141211140307.GE1300@lahna.fi.intel.com>
	<2128690.c90ERDd9ZP@xps13>
Date: Thu, 11 Dec 2014 13:41:57 -0500
Message-ID: <CAN+gG=Fa5dPtfMSsU2MpqQJ6PWMTjN2izOfx2-ee-Shq21Hutw@mail.gmail.com>
Subject: Re: NULL pointer dereference in i2c-hid
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Andrew Duggan <aduggan@synaptics.com>, Jiri Kosina <jkosina@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2014 at 1:16 PM, Gabriele Mazzotta
<gabriele.mzt@gmail.com> wrote:
> On Thursday 11 December 2014 16:03:07 Mika Westerberg wrote:
>> On Thu, Dec 11, 2014 at 10:58:01AM +0200, Mika Westerberg wrote:
>> > On Wed, Dec 10, 2014 at 06:04:51PM +0100, Gabriele Mazzotta wrote:
>> > > my laptop uses a touchpad that needs hid-rmi along with i2c-hid to work.
>> > > i2c-hid and hid-rmi can be loaded and unloaded independelty from each
>> > > other, however since 34f439e4afcd ("HID: i2c-hid: add runtime PM support")
>> > > if I unload hid-rmi and after it I also unload i2c-hid, I get a NULL
>> > > pointer dereference.
>> >
>> > I'll look into this.
>> >
>> > I can reproduce this easily with i2c-hid + hid-multitouch following your
>> > directions.
>>
>> Can you try the below patch?
>>
>> I think we shouldn't free buffers yet in ->stop() because we need the
>> command buffer sending power commands to the device. Also it seems that
>> ->start() re-allocates buffers anyway if maximum size increases.
>>
>> It shouldn't even leak memory as we release buffers at ->remove()
>> anyway.
>>
>> diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
>> index 62cec01937ea..68a8c938feea 100644
>> --- a/drivers/hid/i2c-hid/i2c-hid.c
>> +++ b/drivers/hid/i2c-hid/i2c-hid.c
>> @@ -705,12 +705,7 @@ static int i2c_hid_start(struct hid_device *hid)
>>
>>  static void i2c_hid_stop(struct hid_device *hid)
>>  {
>> -     struct i2c_client *client = hid->driver_data;
>> -     struct i2c_hid *ihid = i2c_get_clientdata(client);
>> -
>>       hid->claimed = 0;
>> -
>> -     i2c_hid_free_buffers(ihid);
>>  }
>>
>>  static int i2c_hid_open(struct hid_device *hid)

Mika,

you can add my Rev-by when submitting this patch to the mailing list.


>
> Yes, it works, thanks.
>
> This change seems to also prevent kernel ooops when I unload either
> i2c-hid or i2c-designware-platform while the touchpad is in use,
> thing that is likely to happen because of the other bug I reported.
>
> Speaking of it, does any of you have any suggestion on how to debug it?

Hehe, I coincidentally just replied to your bug with one patch to try
(that was proposed by the intel folks back in May[1]).
The powertop problem is IMO really worrying because the purpose of
i2c_hid was to reduce power consumption :)

Anyway, thanks for the quick test.

Cheers,
Benjamin

[1] https://patchwork.kernel.org/patch/4133771/
