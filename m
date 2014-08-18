Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbaHRP36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 11:29:58 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:40889 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbaHRP3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 11:29:55 -0400
MIME-Version: 1.0
In-Reply-To: <53ECC9F9.1050105@kernel.org>
References: <1407911391-26696-1-git-send-email-a.mathur@samsung.com>
	<53EB2AFE.10900@metafoo.de>
	<CADYu309nTht96H077D6YGvhRYz6Xfux7Qri5Hi7dfgQMtOz-Pg@mail.gmail.com>
	<53EB7AD9.9010602@metafoo.de>
	<CADYu30-RHmysR5vhvNLGXMBx2gnQ6rkdW-pPzyVY=E4KYg8g9w@mail.gmail.com>
	<53EC8463.2030802@metafoo.de>
	<53ECC9F9.1050105@kernel.org>
Date: Mon, 18 Aug 2014 20:59:53 +0530
Message-ID: <CADYu309gcNg+mkNWDR=VVhKnXBxRPXz1fcGVqyxCTo0v5XZ65Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] IIO: Added write function in iio_buffer_fileops
From: Aniroop Mathur <aniroop.mathur@gmail.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>, a.mathur@samsung.com,
        "cpgs ." <cpgs@samsung.com>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mr. Jonathan, Mr. Lars,
Greetings !

Kindly provide feedback upon the comments below.


On Thu, Aug 14, 2014 at 8:08 PM, Jonathan Cameron <jic23@kernel.org> wrote:
> On 14/08/14 10:41, Lars-Peter Clausen wrote:
>> On 08/13/2014 06:33 PM, Aniroop Mathur wrote:
>>> On Wed, Aug 13, 2014 at 8:18 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
>>>> On 08/13/2014 03:42 PM, Aniroop Mathur wrote:
>>>>>
>>>>> On Wed, Aug 13, 2014 at 2:38 PM, Lars-Peter Clausen <lars@metafoo.de>
>>>>> wrote:
>>>>>>
>>>>>> On 08/13/2014 08:29 AM, a.mathur@samsung.com wrote:
>>>>>>>
>>>>>>>
>>>>>>> From: Aniroop Mathur <a.mathur@samsung.com>
>>>>>>>
>>>>>>> Earlier, user space can only read from iio device node but cannot write
>>>>>>> to
>>>>>>> it.
>>>>>>> This patch adds write function in iio buffer file operations,
>>>>>>> which will allow user-space applications/HAL to write the data
>>>>>>> to iio device node.
>>>>>>> So now there will be two way communication between IIO subsystem
>>>>>>> and user space. (userspace <--> kernel)
>>>>>>>
>>>>>>> It can be used by HAL or any user-space application which wants to
>>>>>>> write data to iio device node/buffer upon receiving some data from it.
>>>>>>> As an example,
>>>>>>> It is useful for iio device simulator application which need to record
>>>>>>> the data by reading from iio device node and replay the recorded data
>>>>>>> by writing back to iio device node.
>>>>>>>
>>>>>>
>>>>>> I'm not convinced that this is something that should be added to the
>>>>>> kernel.
> I'm inclined to agree with Lars.  As an additional point this will cause
> confusion when we have buffered writing for output devices (DACs).
>
>
>>>>>> I'm wondering why can't this be done in userspace, e.g. by having a
>>>>>> simulator mode for the application or by using LD_PRELOAD. Having this in
>>>>>> userspace will be much more flexible and will be easier to implement
>>>>>> correctly and you'll most likely want to simulate more than just buffer
>>>>>> access, for example setting/getting properties of the device or channel.
>>>>>> For
>>>>>> the libiio[1] we are planning to implement a test backend that when
>>>>>> activated will allow to simulate a whole device rather than just buffer
>>>>>> support.
>>>>>>
>>>>>> [1] https://github.com/analogdevicesinc/libiio
>>>>>>
>>>>>>
>>>>>
>>>>> In normal Input Subsystem, there is two way communication between
>>>>> kernel and userpace. It has both read and write functionality. :)
>>>>> Why there is only one way communication in case of IIO ?
> Why should there be?


Below is the use case for which write function is required:

I am working on Sensor Simulator application for android phones.
This android application will simulate the sensor values
for any other already developed 3rd party/organization application/s
and not for simulator application itself.
In other words, I need to check the working of other sensor applications by
using my simulator application and along with it, checking of HAL and
Framework too.

For simulation, below is the data flow
by using user-space libiio and by directly writing to iio buffer.

Hardware--Driver--IIO--General_IIO_HAL--Framework--Other_Sensor_Application/s
                                       |
                                       | --> libiio <-->
Simulator_Sensor_Application
                                       |
                                       | <--> Simulator_Sensor_Application


If we use libiio,
Sensor_Simulator_Application will not be able to send sensor data to
Other_Sensor_Application/s because it can only write and read data for itself.
Reading and writing data for itself is not what is required. There is a need
to send data to other application/s.
Also, we could not check HAL and Framework here.

If we directly write to iio buffer,
Sensor_Simulator_Application will be able to send sensor data to
Other_Sensor_Application/s and this in turn will also check whether there
are any problems in hal and framework for Other_Application to work properly.
So, if some Other_Sensor_Application is behaving differently
for same sensor data it means there is some problem in
HAL/Framework/Application itself.

Also importantly, we can change the recorded data and check Other_Application
working with that new data.
As an example,
There is an application, which uses accel+gyro+pressure to calculate
amount of calories burnt of an individual.
So once recorded the data physically by going in outside environment,
we can change just the pressure data and measure the amount of calories burnt
without actually physically going outside at new height for new pressure.

Now to write directly to IIO buffer, there is a need of two things
that should be present in IIO subsystem:
1. Write function in iio_buffer file_ops.
2. Multiple file descriptor support for same device node.
   because both Simulator_Sensor_Application and Other_Sensor_Application/s
   need to open device node for their use.

Currently, both are not present in IIO subsystem.
So first, I am hoping to add write function and
after that adding multiple fd support.

In input subsystem, both facilities are available.

How can we achieve this task without directly writing to iio buffer ?
How will user-space libiio help us for this task ?

>>>>
>>>>
>>>> I've not seen a compelling reason yet why this must be implemented in kernel
>>>> space. In my opinion, as outlined above, userspace if both easier and more
>>>> flexible.
>>>>
>>>>
>>>>>
>>>>> For Input devices, I completed simulation just by reading and writing at
>>>>> input device node /dev/input/eventX.
>>>>> But for IIO devices, I am stuck as there is no write function available
>>>>> for iio device node /dev/iio:device0.
>>>>>
>>>>> As per my understanding, if we do the simulation in userspace
>>>>> then we need to create one more buffer in userpace. This will lead to
>>>>> extra memory usage. With write functionality in IIO just like
>>>>> in Input subsystem, we can avoid extra memory space. :)
>>>>
>>>>
>>>> No, you don't actually have to create a additional buffer. Just return the
>>>> data that you'd otherwise have passed to write().
>>>>
>>>>
>>>
>>> If there is no buffer, then there is clearly a chance of data loss/miss. :)
>>> Because if one application is reading the data with frequency 5 Hz
>>> and other application is writing the data at frequency 50 Hz (20 ms delay)
>>> so this reading application will miss reading a lot of data.
>>> Like in this case, after every 200 ms, 9 out of 10 data will be missed.
>>
>> Not if implemented correctly. Even with the current kernel implementation you'll have this issues as the buffer will
>> simply overflow when you write faster than you read.
>>
>>

Generally, there is less difference between read and write frequency.
But there is difference.
So, in case of a buffer, there is very very less chance of data loss.
But in case of no buffer, there will be data loss/miss.

Generally, as you know, application requests for frequency at which
hardware should send data for their reading.
But driver frequency to write data in buffer
and application frequency to read data does not match exactly.
So either fast or slow, we end with either data loss
or same data being sent again to app.

Therefore, buffer is required to avoid such cases.


>> [...]
> If we have a usecase for playback functionality like this I would prefer it to
> be on a separate IIO device.  When Lars' DAC buffered code is ready it will
> be relatively easy to string together a fake DAC with a fake ADC to get
> this sort of functionality.   It will be rather more interesting to
> work out how to setup an arbitary device but it could be done,
> most likely using configfs.
>
> This would be more similar to uinput than the writing to the chardevs
> directly as you are suggesting here.
>
>>>>>> Are you sure that this works? iio_push_to_buffer() expects a data buffer
>>>>>> of
>>>>>> size rb->bytes_per_datum bytes. On the other hand rb->bytes_per_datum is
>>>>>> only valid when the buffer is enabled, so for this to work the buffer
>>>>>> would
>>>>>> need to be enabled. Which means you'd inject the fake data in the middle
>>>>>> of
>>>>>> the real data stream.
>>>>>>
>>>>>>
>>>>>
>>>>> Yes, It works :)
>>>>> In one patch, bytes_per_datum has been removed from kifo_in.
>>>>> Patch - iio:kfifo_buf Take advantage of the fixed record size used in IIO
>>>>> commit c559afbfb08c7eac215ba417251225d3a8e01062
>>>>> - ret = kfifo_in(&kf->kf, data, r->bytes_per_datum);
>>>>> + ret = kfifo_in(&kf->kf, data, 1);
>>>>> So, I think we can now write only one byte of data.
>>>>
>>>>
>>>> No, we need to write 1 record and the size of one record is bytes_per_datum.
>>>> If you only write one byte you'll cause a out of bounds access.
>>>>
>>>>
>>>
>>> This is the code flow below which I checked:
>>>
>>> kfifo_in(&kf->kf, data, 1);
>>> so len=1
>>> kfifo_copy_in(fifo, buf, len, fifo->in);
>>> l = min(len, size - off);
>>> memcpy(fifo->data + off, src, l);
>>>
>>> In memcpy, if l is 1, so it will copy one byte only.
>>> So, how it is writing one record and not one byte ?
>> You missed this part:
>>
>>     if (esize != 1) {
>>         off *= esize;
>>         size *= esize;
>>         len *= esize;
>>     }
>>
>> so len gets multiplied by the record size. len=1 means 1 record.
>>

Oh, I really missed this part.
Thank you Mr. Lars for the correction.

So, in the write function,
we can just replace 1 by rb->bytes_per_datum.
And add the check like below:
+ if(!rb || rb->bytes_per_datum==0)
+ return -1;

I initially write the code with bytes_per_datum only.
But changed to 1 after seeing the latest kernel and
got confused with "1" value.

Is there anything else need to be changed ?

>>>
>>>>>
>>>>> Initially, I wrote the code for write functionality in kernel version 3.6
>>>>> using bytes_per_datum instead of fixed size of 1 byte.
>>>>> It worked fine. :)
>>>>> For this, we just need to replace size 1 by r->bytes_per_datum.
>>>>>
>>>>> We are not injecting data in middle of real data stream.
>>>>> When we inject the recorded data, we disabled the hardware chip,
>>>>> so no new/real data is pushed to the buffer during that time.
>>>>>
>>>>> To record, we enabled the buffer, read the real data and save it.
>>>>> To replay, we disabled the hardware chip and injected saved data by
>>>>> writing back to iio device node.
>>>>> So, Buffer is still enabled at time of writing to iio device node. :)
>>>>
>>>>
>>>> How do you disable the hardware without disabling the buffer?
>>>>
>>> I disabled the hardware by powering off the chip.
>>> And after writing is complete, chip is powered on again. :)
>>
>> But how do you disable the device when the buffer is still active?
>> IIO expects the device to be active when the buffer is active.
> Agreed. This sounds like a pretty uggly hack.  I would not be happy with
> having this in any driver.
>

Taking example of pressure sensor hardware chip,

Case1: Normal case,
1. We enabled the iio software buffer.
2. Pressure Hardware chip generates an interrupt.
3. Driver receives the interrupt call and make
   a call to push data to iio buffer

But if there is no change in pressure i.e. there is no new data
hardware chip will not generate any interrupt and hence
no data is pushed to iio software buffer.
And iio software buffer is still active and waiting if there is any data comes.

Case 2: My case,
1. We enable the iio software buffer.
2. We record the pressure real data if there is.
3. We power off the pressure hardware chip
   or second way, we disable the irq only.

In this case too, there will be no interrupt call received by driver,
and hence no data is pushed to iio buffer.
And iio software buffer is still active and waiting if there is any data comes.

In both cases, from iio buffer perspective,
iio software buffer is active and waiting for some data.

I cannot see any difference for IIO buffer in both cases.
So, I am not able to understand the problem here with IIO buffer ?

Later in case 2, as buffer is active,
Sensor_Simulator_Application can write data to it
and Other_Sensor_Application/s can read data from it.
And after simulation is over,
we power on the hardware chip again or second way, enable the irq again,
everything gets back to normal as before.

Thanks,
Aniroop

>>
>> - Lars
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
