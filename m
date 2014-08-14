Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbaHNOi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 10:38:58 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:37678 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323AbaHNOi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 10:38:56 -0400
Message-ID: <53ECC9F9.1050105@kernel.org>
Date: Thu, 14 Aug 2014 15:38:49 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>,
        Aniroop Mathur <aniroop.mathur@gmail.com>
CC: a.mathur@samsung.com, "cpgs ." <cpgs@samsung.com>,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        p.shailesh@samsung.com, r.mahale@samsung.com, vidushi.koul@samsung.com,
        narendra.m1@samsung.com
Subject: Re: [PATCH 1/1] IIO: Added write function in iio_buffer_fileops
References: <1407911391-26696-1-git-send-email-a.mathur@samsung.com>	<53EB2AFE.10900@metafoo.de>	<CADYu309nTht96H077D6YGvhRYz6Xfux7Qri5Hi7dfgQMtOz-Pg@mail.gmail.com>	<53EB7AD9.9010602@metafoo.de> <CADYu30-RHmysR5vhvNLGXMBx2gnQ6rkdW-pPzyVY=E4KYg8g9w@mail.gmail.com> <53EC8463.2030802@metafoo.de>
In-Reply-To: <53EC8463.2030802@metafoo.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/08/14 10:41, Lars-Peter Clausen wrote:
> On 08/13/2014 06:33 PM, Aniroop Mathur wrote:
>> On Wed, Aug 13, 2014 at 8:18 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>>> On 08/13/2014 03:42 PM, Aniroop Mathur wrote:
>>>>
>>>> On Wed, Aug 13, 2014 at 2:38 PM, Lars-Peter Clausen <lars@metafoo.de>
>>>> wrote:
>>>>>
>>>>> On 08/13/2014 08:29 AM, a.mathur@samsung.com wrote:
>>>>>>
>>>>>>
>>>>>> From: Aniroop Mathur <a.mathur@samsung.com>
>>>>>>
>>>>>> Earlier, user space can only read from iio device node but cannot write
>>>>>> to
>>>>>> it.
>>>>>> This patch adds write function in iio buffer file operations,
>>>>>> which will allow user-space applications/HAL to write the data
>>>>>> to iio device node.
>>>>>> So now there will be two way communication between IIO subsystem
>>>>>> and user space. (userspace <--> kernel)
>>>>>>
>>>>>> It can be used by HAL or any user-space application which wants to
>>>>>> write data to iio device node/buffer upon receiving some data from it.
>>>>>> As an example,
>>>>>> It is useful for iio device simulator application which need to record
>>>>>> the data by reading from iio device node and replay the recorded data
>>>>>> by writing back to iio device node.
>>>>>>
>>>>>
>>>>> I'm not convinced that this is something that should be added to the
>>>>> kernel.
I'm inclined to agree with Lars.  As an additional point this will cause
confusion when we have buffered writing for output devices (DACs).


>>>>> I'm wondering why can't this be done in userspace, e.g. by having a
>>>>> simulator mode for the application or by using LD_PRELOAD. Having this in
>>>>> userspace will be much more flexible and will be easier to implement
>>>>> correctly and you'll most likely want to simulate more than just buffer
>>>>> access, for example setting/getting properties of the device or channel.
>>>>> For
>>>>> the libiio[1] we are planning to implement a test backend that when
>>>>> activated will allow to simulate a whole device rather than just buffer
>>>>> support.
>>>>>
>>>>> [1] https://github.com/analogdevicesinc/libiio
>>>>>
>>>>>
>>>>
>>>> In normal Input Subsystem, there is two way communication between
>>>> kernel and userpace. It has both read and write functionality. :)
>>>> Why there is only one way communication in case of IIO ?
Why should there be?
>>>
>>>
>>> I've not seen a compelling reason yet why this must be implemented in kernel
>>> space. In my opinion, as outlined above, userspace if both easier and more
>>> flexible.
>>>
>>>
>>>>
>>>> For Input devices, I completed simulation just by reading and writing at
>>>> input device node /dev/input/eventX.
>>>> But for IIO devices, I am stuck as there is no write function available
>>>> for iio device node /dev/iio:device0.
>>>>
>>>> As per my understanding, if we do the simulation in userspace
>>>> then we need to create one more buffer in userpace. This will lead to
>>>> extra memory usage. With write functionality in IIO just like
>>>> in Input subsystem, we can avoid extra memory space. :)
>>>
>>>
>>> No, you don't actually have to create a additional buffer. Just return the
>>> data that you'd otherwise have passed to write().
>>>
>>>
>>
>> If there is no buffer, then there is clearly a chance of data loss/miss. :)
>> Because if one application is reading the data with frequency 5 Hz
>> and other application is writing the data at frequency 50 Hz (20 ms delay)
>> so this reading application will miss reading a lot of data.
>> Like in this case, after every 200 ms, 9 out of 10 data will be missed.
> 
> Not if implemented correctly. Even with the current kernel implementation you'll have this issues as the buffer will
> simply overflow when you write faster than you read.
> 
> 
> [...]
If we have a usecase for playback functionality like this I would prefer it to
be on a separate IIO device.  When Lars' DAC buffered code is ready it will
be relatively easy to string together a fake DAC with a fake ADC to get
this sort of functionality.   It will be rather more interesting to
work out how to setup an arbitary device but it could be done,
most likely using configfs.

This would be more similar to uinput than the writing to the chardevs
directly as you are suggesting here.

>>>>> Are you sure that this works? iio_push_to_buffer() expects a data buffer
>>>>> of
>>>>> size rb->bytes_per_datum bytes. On the other hand rb->bytes_per_datum is
>>>>> only valid when the buffer is enabled, so for this to work the buffer
>>>>> would
>>>>> need to be enabled. Which means you'd inject the fake data in the middle
>>>>> of
>>>>> the real data stream.
>>>>>
>>>>>
>>>>
>>>> Yes, It works :)
>>>> In one patch, bytes_per_datum has been removed from kifo_in.
>>>> Patch - iio:kfifo_buf Take advantage of the fixed record size used in IIO
>>>> commit c559afbfb08c7eac215ba417251225d3a8e01062
>>>> - ret = kfifo_in(&kf->kf, data, r->bytes_per_datum);
>>>> + ret = kfifo_in(&kf->kf, data, 1);
>>>> So, I think we can now write only one byte of data.
>>>
>>>
>>> No, we need to write 1 record and the size of one record is bytes_per_datum.
>>> If you only write one byte you'll cause a out of bounds access.
>>>
>>>
>>
>> This is the code flow below which I checked:
>>
>> kfifo_in(&kf->kf, data, 1);
>> so len=1
>> kfifo_copy_in(fifo, buf, len, fifo->in);
>> l = min(len, size - off);
>> memcpy(fifo->data + off, src, l);
>>
>> In memcpy, if l is 1, so it will copy one byte only.
>> So, how it is writing one record and not one byte ?
> You missed this part:
> 
>     if (esize != 1) {
>         off *= esize;
>         size *= esize;
>         len *= esize;
>     }
> 
> so len gets multiplied by the record size. len=1 means 1 record.
> 
>>
>>>>
>>>> Initially, I wrote the code for write functionality in kernel version 3.6
>>>> using bytes_per_datum instead of fixed size of 1 byte.
>>>> It worked fine. :)
>>>> For this, we just need to replace size 1 by r->bytes_per_datum.
>>>>
>>>> We are not injecting data in middle of real data stream.
>>>> When we inject the recorded data, we disabled the hardware chip,
>>>> so no new/real data is pushed to the buffer during that time.
>>>>
>>>> To record, we enabled the buffer, read the real data and save it.
>>>> To replay, we disabled the hardware chip and injected saved data by
>>>> writing back to iio device node.
>>>> So, Buffer is still enabled at time of writing to iio device node. :)
>>>
>>>
>>> How do you disable the hardware without disabling the buffer?
>>>
>> I disabled the hardware by powering off the chip.
>> And after writing is complete, chip is powered on again. :)
> 
> But how do you disable the device when the buffer is still active?
> IIO expects the device to be active when the buffer is active.
Agreed. This sounds like a pretty uggly hack.  I would not be happy with
having this in any driver.

> 
> - Lars
> 
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
