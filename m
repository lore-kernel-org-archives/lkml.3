Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933191AbaLKUsR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 15:48:17 -0500
Received: from us-mx2.synaptics.com ([192.147.44.131]:14408 "EHLO
	us-mx1.synaptics.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758696AbaLKUsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 15:48:16 -0500
X-PGP-Universal: processed;
	by securemail.synaptics.com on Thu, 11 Dec 2014 13:12:39 -0800
Message-ID: <548A02BD.7030509@synaptics.com>
Date: Thu, 11 Dec 2014 12:46:53 -0800
From: Andrew Duggan <aduggan@synaptics.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Gabriele Mazzotta <gabriele.mzt@gmail.com>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <benjamin.tissoires@redhat.com>, <jkosina@suse.cz>
Subject: Re: NULL pointer dereference in i2c-hid
References: <31518562.V5Oyo0POsI@xps13> <2171175.gv8IA3dxxN@xps13> <5489EEC7.1010709@synaptics.com> <2187886.1Q1zbE8252@xps13>
In-Reply-To: <2187886.1Q1zbE8252@xps13>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.4.10.98]
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/11/2014 11:40 AM, Gabriele Mazzotta wrote:
> On Thursday 11 December 2014 11:21:43 Andrew Duggan wrote:
>> On 12/11/2014 11:11 AM, Gabriele Mazzotta wrote:
>>> On Thursday 11 December 2014 10:40:05 Andrew Duggan wrote:
>>>> On 12/11/2014 10:16 AM, Gabriele Mazzotta wrote:
>>>>> On Thursday 11 December 2014 16:03:07 Mika Westerberg wrote:
>>>>>> On Thu, Dec 11, 2014 at 10:58:01AM +0200, Mika Westerberg wrote:
>>>>>>> On Wed, Dec 10, 2014 at 06:04:51PM +0100, Gabriele Mazzotta wrote:
>>>>>>>> my laptop uses a touchpad that needs hid-rmi along with i2c-hid to work.
>>>>>>>> i2c-hid and hid-rmi can be loaded and unloaded independelty from each
>>>>>>>> other, however since 34f439e4afcd ("HID: i2c-hid: add runtime PM support")
>>>>>>>> if I unload hid-rmi and after it I also unload i2c-hid, I get a NULL
>>>>>>>> pointer dereference.
>>>>>>> I'll look into this.
>>>>>>>
>>>>>>> I can reproduce this easily with i2c-hid + hid-multitouch following your
>>>>>>> directions.
>>>>>> Can you try the below patch?
>>>>>>
>>>>>> I think we shouldn't free buffers yet in ->stop() because we need the
>>>>>> command buffer sending power commands to the device. Also it seems that
>>>>>> ->start() re-allocates buffers anyway if maximum size increases.
>>>>>>
>>>>>> It shouldn't even leak memory as we release buffers at ->remove()
>>>>>> anyway.
>>>>>>
>>>>>> diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
>>>>>> index 62cec01937ea..68a8c938feea 100644
>>>>>> --- a/drivers/hid/i2c-hid/i2c-hid.c
>>>>>> +++ b/drivers/hid/i2c-hid/i2c-hid.c
>>>>>> @@ -705,12 +705,7 @@ static int i2c_hid_start(struct hid_device *hid)
>>>>>>     
>>>>>>     static void i2c_hid_stop(struct hid_device *hid)
>>>>>>     {
>>>>>> -	struct i2c_client *client = hid->driver_data;
>>>>>> -	struct i2c_hid *ihid = i2c_get_clientdata(client);
>>>>>> -
>>>>>>     	hid->claimed = 0;
>>>>>> -
>>>>>> -	i2c_hid_free_buffers(ihid);
>>>>>>     }
>>>>>>     
>>>>>>     static int i2c_hid_open(struct hid_device *hid)
>>>>> Yes, it works, thanks.
>>>>>
>>>>> This change seems to also prevent kernel ooops when I unload either
>>>>> i2c-hid or i2c-designware-platform while the touchpad is in use,
>>>>> thing that is likely to happen because of the other bug I reported.
>>>>>
>>>>> Speaking of it, does any of you have any suggestion on how to debug it?
>>>> I was able to reproduce the initial issue by unloading hid-rmi and
>>>> i2c-hid while holding my fingers on the touchpad. Mika's patch fixes it
>>>> for me.
>>>>
>>>> For the original bug, you can modprobe i2c-hid debug=1 and we can see
>>>> what data the touchpad is reporting. That might help narrowing down if
>>>> it's noise which the touchpad thinks are fingers or if there is a
>>>> problem with the I2C lines causing spurious interrupts.
>>>>
>>>> Andrew
>>> I've already tried to do that and here what I got:
>>>
>>> When I release the finger, the last message is repeated 81 times.
>>> If the byte containing informations about the width of the finger
>>> becomes equal to either c0 or 0c at least once, the last message is
>>> repeated indefinitely and changes as soon as I start using the touchpad.
>>> The only way to stop it is to unload and reload i2c-hid.
>> The reports before log throttling kicks in would still be useful. For
>> instance c0 is outside of the range of finger width which we report so
>> something is wrong there. But, the touchpad should stop interrupting
>> once the finger is lifted. The fact that subsequent reads are reporting
>> the same data does sound like a problem with I2C getting confused and
>> continuously interrupting and reading the old finger data. I am also
>> curious about the value of the byte after the report id.
>>
>> Andrew
> If I'm not wrong c0 means that the width is 12 on y axis, while 0c means
> that the width is 12 on the x axis.

You are correct! I forgot width was 4 bits for X and Y in the same byte. 
That makes more sense.

>
> I have to correct myself. The important thing is that the byte is either
> cx or xc, where x is anything below c.
>
> Another correction. Sometimes unloading i2c-hid is not enough, I have to
> first disable the touchpad with xinput and then unload i2c-hid. If I
> don't do it, the messages starts reappearing as soon as I reload i2c-hid.
>
> I did several tests in the past months and I'm quite sure that the bug
> happens only past xc/cy.

This maybe coincidental. It is not obvious to me why a certain width 
value would cause the symptoms described.

>
> Here few lines right before the bug. The last line is repeated indefinitely:
>
> [ 1983.527097] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 67 5b 61 0a 5f 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.537211] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 67 5b 63 0a 60 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.547329] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 67 5b 64 0a 60 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.557486] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 67 5b 66 0a 60 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.567663] i2c_hid i2c-DLL060A:00: input: 20 00 0c 0c 01 00 67 5b 68 0a 60 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.577719] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 67 5b 6a 0a 61 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.587852] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 67 5b 6b 0a 61 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.598001] i2c_hid i2c-DLL060A:00: input: 20 00 0c 0c 01 00 67 5b 6e 0a 62 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.608215] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 68 5b 61 0a 62 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.618288] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 68 5b 64 0b 63 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.628493] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 68 5b 67 0b 63 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.638552] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 68 5b 69 0b 64 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.648663] i2c_hid i2c-DLL060A:00: input: 20 00 0c 0c 01 00 68 5b 6c 0b 64 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.658789] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 68 5b 6f 0b 64 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.668923] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 69 5b 61 0b 65 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.678819] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 69 5b 64 0b 65 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.689230] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 69 5b 66 0b 65 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.699435] i2c_hid i2c-DLL060A:00: input: 20 00 0c 0c 01 00 69 5b 68 0b 65 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.709502] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 69 5b 6a 0b 66 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.719574] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 69 5b 6c 0b 66 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.729713] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 69 5b 6e 0b 66 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.739863] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 6a 5b 60 0b 66 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.750001] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 6a 5b 62 0b 66 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.760150] i2c_hid i2c-DLL060A:00: input: 20 00 0c 0c 01 00 6a 5b 64 0b 67 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.770291] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 6a 5b 66 0b 67 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.780445] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 6a 5b 68 0b 67 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.790490] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 6a 5b 5a 0b 68 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.800667] i2c_hid i2c-DLL060A:00: input: 20 00 0c 0c 01 00 6a 5b 4e 0c 69 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.810691] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 6b 5b 31 0c 69 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.820963] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 6b 5b 24 0c 6a 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.831071] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 6b 5b 17 0c 6a 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.841178] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 6b 5b 09 0c 6a 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.851325] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 6b 5b 0b 0c 6b 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.861435] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 6b 5b 0d 0c 6b 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.871566] i2c_hid i2c-DLL060A:00: input: 20 00 0c 0c 01 00 6b 5b 0f 0c 6b 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.881735] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 6c 5b 01 0c 6b 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.891975] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 6c 5b 03 0c 6b 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.902073] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 6c 5b 05 0c 6c 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.912155] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 6c 5b 07 0c 6b 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.922224] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 6c 5b 09 0c 6c 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.932364] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 6c 5b 0b 0c 6c 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.942480] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 6c 5b 0d 0c 6c 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.952612] i2c_hid i2c-DLL060A:00: input: 20 00 0c 0c 01 00 6c 5b 0f 0c 6c 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.962774] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 6d 5a f1 0d 6d 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.972932] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 6d 5a f3 0d 6e 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.982872] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 6d 5a f6 0d 6f 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1983.993194] i2c_hid i2c-DLL060A:00: input: 20 00 0c 0c 01 00 6d 5a f9 0d 6f 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1984.003295] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 6d 5a fc 0d 6f 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1984.013511] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 6d 5a ff 0d 70 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1984.023590] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 6e 5a f2 0d 70 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1984.033747] i2c_hid i2c-DLL060A:00: input: 20 00 0c 0c 01 00 6e 5a f5 0e 71 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1984.043850] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 6e 5a f8 0e 71 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1984.053873] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 6e 5a fb 0e 71 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1984.064077] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 6e 5a fe 0e 72 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1984.074207] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 6f 5a f1 0e 72 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1984.084425] i2c_hid i2c-DLL060A:00: input: 20 00 0c 0c 01 00 6f 5a f3 0e 72 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1984.094533] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 6f 5a f6 0e 73 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1984.104629] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 6f 5a f8 0e 73 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1984.114742] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 6f 5a fa 0e 73 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1984.124890] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 6f 5a fc 0e 73 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1984.135006] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 6f 5a fe 0e 73 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1984.145149] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 70 5a f0 0e 73 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1984.155317] i2c_hid i2c-DLL060A:00: input: 20 00 0c 0c 01 00 70 5a e2 0e 73 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1984.165380] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 70 5a d4 0d 74 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1984.175532] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 70 5a d6 0d 74 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1984.185409] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 70 5a d8 0d 75 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1984.195761] i2c_hid i2c-DLL060A:00: input: 20 00 0c 0c 01 00 70 5a db 0d 75 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1984.205909] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 70 5a dd 0d 75 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1984.216034] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 71 5a d0 0e 76 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1984.226198] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 71 5a d3 0e 77 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1984.236301] i2c_hid i2c-DLL060A:00: input: 20 00 0c 0c 01 00 71 5a d6 0e 77 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1984.246520] i2c_hid i2c-DLL060A:00: input: 20 00 0c 0c 01 00 71 5a cb 0f 79 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1984.256573] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 01 00 72 5a b1 0e 78 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1984.266697] i2c_hid i2c-DLL060A:00: input: 20 00 0c 0c 01 00 72 5a a7 0e 77 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1984.276823] i2c_hid i2c-DLL060A:00: input: 20 00 0c 0c 01 00 72 5a 6d 0d 72 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1984.286921] i2c_hid i2c-DLL060A:00: input: 20 00 0c 0c 01 00 73 59 96 0a 5a 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1984.296888] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 00 00 73 59 96 00 00 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1984.306825] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 00 00 73 59 96 00 00 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
> [ 1984.316980] i2c_hid i2c-DLL060A:00: input: 20 00 0c 04 00 00 73 59 96 00 00 03 09 40 00 00 90 86 1d 00 00 00 00 00 00 00 00 00 00 00 00 00
The last report which repeats indicates that no fingers are present. 
But, the click button is generating the interrupt and it is reporting 
that it is in the down position. Could the click button be getting stuck 
down? That would also explain why the data in the report is not 
changing. Could you be bumping the touchpad with your palm which is 
causing the click button to get stuck in the down position? That might 
also explain the large width value. Our max width is 15, so 12 would 
typically indicate a contact larger then a normal finger contact. That 
would explain the width of 12 showing up when this happens.

Andrew
