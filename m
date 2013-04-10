Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937109Ab3DJQgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 12:36:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32524 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763998Ab3DJQf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 12:35:59 -0400
Message-ID: <516594BC.30405@redhat.com>
Date: Wed, 10 Apr 2013 18:35:08 +0200
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Bastien Nocera <hadess@hadess.net>, Fabien <fabien.andre@gmail.com>,
        Jarod Wilson <jarod@redhat.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: appleir: add support for Apple ir devices
References: <1365438651-32623-1-git-send-email-benjamin.tissoires@redhat.com> <alpine.LNX.2.00.1304092155330.17280@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1304092155330.17280@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On 04/09/2013 10:10 PM, Jiri Kosina wrote:
> On Mon, 8 Apr 2013, Benjamin Tissoires wrote:
> 
>> This driver was originally written by James McKenzie, updated by
>> Greg Kroah-Hartman, further updated by Bastien Nocera, with suspend
>> support added.
>> I ported it to the HID subsystem, in order to simplify it a litle
>> and allow lirc to use it through hiddev.
>>
>> More recent versions of the IR receiver are also supported through
>> a patch by Alex Karpenko. The patch also adds support for the 2nd
>> and 5th generation of the controller, and the menu key on newer
>> brushed metal remotes.
>>
>> Tested-by: Fabien André <fabien.andre@gmail.com>
>> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>> ---
>> Hi guys,
>>
>> this is the re-spin of Bastien's patch submitted last november.
>> I ported it to use the hid subsystem, reducing the size of the driver
>> to 355 lines instead of 527.
> 
> Thanks. Generally, I like the idea of appleir being on the hid bus.

Thanks for the review.

> 
> Bastien, could you please provide your Ack (and most importantly also 
> Tested-by?).
> 
> [ ... snip ... ]
>> +static void dump_packet(struct appleir *appleir, char *msg, u8 *data, int len)
>> +{
>> +	appleir_dbg(appleir->hid,
>> +		    "appleir: %s (%d bytes) %*ph (should be command %d)\n",
>> +		    msg, len, len, data, (data[4] >> 1) & KEY_MASK);
>> +}
> 
> Can't we just use HID debugfs interface for this kind of debugging output?

sure. I'll change this in v2.

> 
>> +static int get_key(int data)
>> +{
>> +	/*
>> +	 * The indexes of the keys are computed like this:
>> +	 * 0x00 or 0x01 (        )	key:   0	-> KEY_RESERVED
>> +	 * 0x02 or 0x03 (  menu  )	key:   1	-> KEY_MENU
>> +	 * 0x04 or 0x05 (   >"   )	key:   2	-> KEY_PLAYPAUSE
>> +	 * 0x06 or 0x07 (   >>   )	key:   3	-> KEY_FORWARD
>> +	 * 0x08 or 0x09 (   <<   )	key:   4	-> KEY_BACK
>> +	 * 0x0a or 0x0b (    +   )	key:   5	-> KEY_VOLUMEUP
>> +	 * 0x0c or 0x0d (    -   )	key:   6	-> KEY_VOLUMEDOWN
>> +	 * 0x0e or 0x0f (        )	key:   7	-> KEY_RESERVED
>> +	 * 0x50 or 0x51 (        )	key:  -8	-> KEY_RESERVED
>> +	 * 0x52 or 0x53 (        )	key:  -9	-> KEY_RESERVED
>> +	 * 0x54 or 0x55 (        )	key: -10	-> KEY_RESERVED
>> +	 * 0x56 or 0x57 (        )	key: -11	-> KEY_RESERVED
>> +	 * 0x58 or 0x59 (        )	key: -12	-> KEY_RESERVED
>> +	 * 0x5a or 0x5b (        )	key: -13	-> KEY_RESERVED
>> +	 * 0x5c or 0x5d ( middle )	key: -14	-> KEY_ENTER
>> +	 * 0x5e or 0x5f (   >"   )	key: -15	-> KEY_PLAYPAUSE
>> +	 */
>> +	int key = (data >> 1) & KEY_MASK;
>> +
>> +	if ((data & TWO_PACKETS_MASK))
>> +		/* Part of a 2 packet-command */
>> +		key = -key;
> 
> I think all the shuffling with negative indices would justify an 
> explanatory comment; it's quite confusing on a first sight.

Agree :)
I think I'll drop the '-' (minus) in this table, and add a comment
telling that those starting with 0x5 are part of a two packets report,
and we tag it by adding a minus in front of them.

> 
> [ ... snip ... ]
>> +static int appleir_raw_event(struct hid_device *hid, struct hid_report *report,
>> +	 u8 *data, int len)
>> +{
>> +	struct appleir *appleir = hid_get_drvdata(hid);
>> +	static const u8 keydown[] = { 0x25, 0x87, 0xee };
>> +	static const u8 keyrepeat[] = { 0x26, };
>> +	static const u8 flatbattery[] = { 0x25, 0x87, 0xe0 };
>> +	unsigned long flags;
>> +
>> +	if (debug)
>> +		dump_packet(appleir, "received", data, len);
>> +
>> +	if (len != 5)
>> +		goto out;
>> +
>> +	if (!memcmp(data, keydown, sizeof(keydown))) {
>> +		int index;
>> +
>> +		spin_lock_irqsave(&appleir->lock, flags);
>> +		/* If we already have a key down, take it up before marking
>> +		   this one down */
> 
> Could you please make this comment in-line with kernel comments coding 
> style?

Sure. I missed this one.

Thanks again for the review.

Cheers,
Benjamin

