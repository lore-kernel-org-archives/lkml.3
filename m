Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842AbaHWS0m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 14:26:42 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:54113 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbaHWS0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 14:26:39 -0400
MIME-Version: 1.0
In-Reply-To: <53F78BC2.5090804@kernel.org>
References: <1407911391-26696-1-git-send-email-a.mathur@samsung.com>
	<53EB2AFE.10900@metafoo.de>
	<CADYu309nTht96H077D6YGvhRYz6Xfux7Qri5Hi7dfgQMtOz-Pg@mail.gmail.com>
	<53EB7AD9.9010602@metafoo.de>
	<CADYu30-RHmysR5vhvNLGXMBx2gnQ6rkdW-pPzyVY=E4KYg8g9w@mail.gmail.com>
	<53EC8463.2030802@metafoo.de>
	<53ECC9F9.1050105@kernel.org>
	<CADYu308GLWp1u4XUYTm+W5mF3bCdfq=km8VgYBMN5xc2P3GDdQ@mail.gmail.com>
	<53F78BC2.5090804@kernel.org>
Date: Sat, 23 Aug 2014 23:56:37 +0530
Message-ID: <CADYu308F9SFQ7wGEdnbZSLYbFmRwEksbHG7ECguHfKr0_LU6Jw@mail.gmail.com>
Subject: Re: [PATCH 1/1] IIO: Added write function in iio_buffer_fileops
From: Aniroop Mathur <aniroop.mathur@gmail.com>
To: Jonathan Cameron <jic23@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>
Cc: a.mathur@samsung.com, "cpgs ." <cpgs@samsung.com>,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        p.shailesh@samsung.com, r.mahale@samsung.com, vidushi.koul@samsung.com,
        narendra.m1@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 11:58 PM, Jonathan Cameron <jic23@kernel.org> wrote:
> On 16/08/14 15:44, Aniroop Mathur wrote:
>>
>>
>>
>> On Thu, Aug 14, 2014 at 8:08 PM, Jonathan Cameron <jic23@kernel.org <mailto:jic23@kernel.org>> wrote:
>>
>>     On 14/08/14 10:41, Lars-Peter Clausen wrote:
>>     > On 08/13/2014 06:33 PM, Aniroop Mathur wrote:
>>     >> On Wed, Aug 13, 2014 at 8:18 PM, Lars-Peter Clausen <lars@metafoo.de <mailto:lars@metafoo.de>> wrote:
>>     >>> On 08/13/2014 03:42 PM, Aniroop Mathur wrote:
>>     >>>>
>>     >>>> On Wed, Aug 13, 2014 at 2:38 PM, Lars-Peter Clausen <lars@metafoo.de <mailto:lars@metafoo.de>>
>>     >>>> wrote:
>>     >>>>>
>>     >>>>> On 08/13/2014 08:29 AM, a.mathur@samsung.com <mailto:a.mathur@samsung.com> wrote:
>>     >>>>>>
>>     >>>>>>
>>     >>>>>> From: Aniroop Mathur <a.mathur@samsung.com <mailto:a.mathur@samsung.com>>
>>     >>>>>>
>>     >>>>>> Earlier, user space can only read from iio device node but cannot write
>>     >>>>>> to
>>     >>>>>> it.
>>     >>>>>> This patch adds write function in iio buffer file operations,
>>     >>>>>> which will allow user-space applications/HAL to write the data
>>     >>>>>> to iio device node.
>>     >>>>>> So now there will be two way communication between IIO subsystem
>>     >>>>>> and user space. (userspace <--> kernel)
>>     >>>>>>
>>     >>>>>> It can be used by HAL or any user-space application which wants to
>>     >>>>>> write data to iio device node/buffer upon receiving some data from it.
>>     >>>>>> As an example,
>>     >>>>>> It is useful for iio device simulator application which need to record
>>     >>>>>> the data by reading from iio device node and replay the recorded data
>>     >>>>>> by writing back to iio device node.
>>     >>>>>>
>>     >>>>>
>>     >>>>> I'm not convinced that this is something that should be added to the
>>     >>>>> kernel.
>>     I'm inclined to agree with Lars.  As an additional point this will cause
>>     confusion when we have buffered writing for output devices (DACs).
>>
>>
>>     >>>>> I'm wondering why can't this be done in userspace, e.g. by having a
>>     >>>>> simulator mode for the application or by using LD_PRELOAD. Having this in
>>     >>>>> userspace will be much more flexible and will be easier to implement
>>     >>>>> correctly and you'll most likely want to simulate more than just buffer
>>     >>>>> access, for example setting/getting properties of the device or channel.
>>     >>>>> For
>>     >>>>> the libiio[1] we are planning to implement a test backend that when
>>     >>>>> activated will allow to simulate a whole device rather than just buffer
>>     >>>>> support.
>>     >>>>>
>>     >>>>> [1] https://github.com/analogdevicesinc/libiio
>>     >>>>>
>>     >>>>>
>>     >>>>
>>     >>>> In normal Input Subsystem, there is two way communication between
>>     >>>> kernel and userpace. It has both read and write functionality. :)
>>     >>>> Why there is only one way communication in case of IIO ?
>>     Why should there be?
>>
>>
>>
>> Below is the use case for which write function is required:
>>
>> I am working on Sensor Simulator application for android phones.
> A worthy goal!
>> This android application will simulate the sensor values
>> for any other already developed 3rd party/organization application/s
>> and not for simulator application itself.
>> In other words, I need to check the working of other sensor applications by
>> using my simulator application and along with it, checking of HAL and
>> Framework too.
>>
>> For simulation, below is the data flow
>> by using user-space libiio and by directly writing to iio buffer.
>>
>> Hardware--Driver--IIO--General_IIO_HAL--Framework--Other_Sensor_Application/s
>>   |
>>   | --> libiio <--> Simulator_Sensor_Application
>>   |
>>                    | <--> Simulator_Sensor_Application
>>
>>
>> If we use libiio,
>> Sensor_Simulator_Application will not be able to send sensor data to
>> Other_Sensor_Application/s because it can only write and read data for itself.
>> Reading and writing data for itself is not what is required. There is a need
>> to send data to other application/s.
>> Also, we could not check HAL and Framework here.
>>
>> If we directly write to iio buffer,
>
> This is a non starter via the approach currently suggested.  Writing
> to an IIO buffer means writing to an output device (or will soon),
> not shoving fake data into a driver that has been artificially hacked
> to not send real data (that disabling the real device but keeping the
> buffer running is a bit I really do not like.)
> If you want to do this it should be via a 'fake' driver not a shim on
> a real one.  To do this in a safe way would mean adding additional
> locking into the fast data flow path for a fairly uncommon case.
>
> I would happily except such a fake driver as a useful addition for
> test purposes etc.  The trick here would be in developing a configuration
> interface that allows a new 'fake' driver to be brought up with whatever
> set of channels and interfaces is desired, along with the mechanisms for
> providing data to those channels.
>
>> Sensor_Simulator_Application will be able to send sensor data to
>> Other_Sensor_Application/s and this in turn will also check whether there
>> are any problems in hal and framework for Other_Application to work properly.
>> So, if some Other_Sensor_Application is behaving differently
>> for same sensor data it means there is some problem in
>> HAL/Framework/Application itself.
> Sure, I understand your point here, but I would still not do it via
> tricks on a normal driver.  These other programs will just as happily
> connect to a 'new' device driver that offers the right facilities.
>
>>
>> Also importantly, we can change the recorded data and check Other_Application
>> working with that new data.
>> As an example,
>> There is an application, which uses accel+gyro+pressure to calculate
>> amount of calories burnt of an individual.
>> So once recorded the data physically by going in outside environment,
>> we can change just the pressure data and measure the amount of calories burnt
>> without actually physically going outside at new height for new pressure.
>
> I'd argue that this is a userspace application problem.  If the data is not
> available then userspace should cope with it, not play games with faking the
> data apparently coming from the hardware.
>
> A fake driver would work for this as well if people really want it!
>
>>
>> Now to write directly to IIO buffer, there is a need of two things
>> that should be present in IIO subsystem:
>> 1. Write function in iio_buffer file_ops.
>
> Not on the main buffer.  That has a very specific meaning and it isn't this.
> The 'right' way to do this in my mind is to have a driver that can
> hook up an out buffer to an in buffer (with no real hardware associated).
> That would fit nicely into the interface for normal use of IIO and would be
> a very handy test tool in general as we could playback 'interesting' datasets
> and use it to test the various bridge drivers as well.
>
> The only challenge is in the configuration interface to bring up such a device
> with the right channels!
>
>> 2. Multiple file descriptor support for same device node.
>>    because both Simulator_Sensor_Application and Other_Sensor_Application/s
>>    need to open device node for their use.
>
> Firstly we can actually support multiple buffers just fine, but the target
> for these is not repeating the same userspace interface lots of times.
>
> Secondly, No they don't need to  This is best done in userspace as we have
> emphasised in a number of previous dicussions. The requirements are quite different from
> what is needed from Input and even there filtering input does adds latency to
> it's data flow (and a great deal of complexity).  Input is designed primarily
> for slow devices where inline meta data is reasonable.  IIO has to be designed
> to handle high speed devices where that just isn't feasible.  Try adding meta
> data to the multiple mega sample per second devices Lars has running.
>
> For IIO, multiple buffers each need their own configuration
> interfaces as there is no meta data in the data stream to allow idenficiation
> of what is coming out.
>
> Any change to the flow on any buffer can result in hardware changes effecting
> all other buffers (typically stopping the data flow, changing the channels
> being grabbed and bringing it back up again).  These changes might well slow
> down the rate data is provided to another driver as various tricks that apply
> with only one buffer stop working.
>
> Userspace can mediate between multiple devices and greatly reduce the flow
> of data across the kernel userspace boundary.
>
> Now we do have the facility to do this in kernel and may perhaps support
> IIO on IIO at some point (IIO drivers that are consumers of other IIO drivers)
> thus providing the 'ability' to do what you ask.  However the purpose behind
> this would be to allow the underlying devices userspace interface to be dropped
> if for example, the adc is just feeding an input subsystem bridge driver.
> We are working slowly towards this, but only to allow IIO to be stripped back
> to what is required rather than to allow more complex options.
>
> So long term, it will be possible to have multiple buffers available (and
> created on the fly) but there is a fair bit of work to be done first.
>>
>> Currently, both are not present in IIO subsystem.
>> So first, I am hoping to add write function and
>> after that adding multiple fd support.
>
> I am sorry to say that I'm far from convinced that either is a good idea if
> you aim to do it in a similar way to Input.
>
> The second has been proposed a number of times before.
>>
>> In input subsystem, both facilities are available.
>
> Sorry to put it so bluntly, but IIO has some very different targets from input.
> It needs to be fast.  Input does not (although this is getting a little more
> interesting with mulit touch screens).  That is what IIO is fundamentally different
> from input.  Yes, there are devices in IIO that are slow where perhaps it might
> be nice to make userspaces job a little easier, but any changes have to take
> into account what problems they will cause for the fast end of things.
>
> Ultimately if it's really a problem, then work on the input bridge driver,
> (which has been languishing in the todo heap for a long time now).  If people
> want these facilities then they can use that to make any IIO device accessible
> through input.
>
>>
>> How can we achieve this task without directly writing to iio buffer ?
>
> Fake device - your android kernel would then appear to have multiple similar
> devices, one of which is real and one of which appears to have a matched set
> of output and input channels.  This does give us the pleasing option of
> having interfaces for outputting pressure, acceleration and magnetic field :)
>
> The trick here is how to instantiate such a device.   Sounds like a job for configfs
> to me though will take a bit of thinking to get the interface correct.
>
>> How will user-space libiio help us for this task ?
>
> Clearly it will only work if it becomes the standard option on Android :)
>
> Note as well that a lot of IIO device drives are slow enough that the buffered
> interface will never make sense and so there will always need to be a means to
> simply read values from sysfs attributes.
>
>>
>>
>>     >>>
>>     >>>
>>     >>> I've not seen a compelling reason yet why this must be implemented in kernel
>>     >>> space. In my opinion, as outlined above, userspace if both easier and more
>>     >>> flexible.
>>     >>>
>>     >>>
>>     >>>>
>>     >>>> For Input devices, I completed simulation just by reading and writing at
>>     >>>> input device node /dev/input/eventX.
>>     >>>> But for IIO devices, I am stuck as there is no write function available
>>     >>>> for iio device node /dev/iio:device0.
>>     >>>>
>>     >>>> As per my understanding, if we do the simulation in userspace
>>     >>>> then we need to create one more buffer in userpace. This will lead to
>>     >>>> extra memory usage. With write functionality in IIO just like
>>     >>>> in Input subsystem, we can avoid extra memory space. :)
>>     >>>
>>     >>>
>>     >>> No, you don't actually have to create a additional buffer. Just return the
>>     >>> data that you'd otherwise have passed to write().
>>     >>>
>>     >>>
>>     >>
>>     >> If there is no buffer, then there is clearly a chance of data loss/miss. :)
>>     >> Because if one application is reading the data with frequency 5 Hz
>>     >> and other application is writing the data at frequency 50 Hz (20 ms delay)
>>     >> so this reading application will miss reading a lot of data.
>>     >> Like in this case, after every 200 ms, 9 out of 10 data will be missed.
>>     >
>>     > Not if implemented correctly. Even with the current kernel implementation you'll have this issues as the buffer will
>>     > simply overflow when you write faster than you read.
>>     >
>>
>>
>>
>> Generally, there is less difference between read and write frequency.
>> But there is difference.
>> So, in case of a buffer, there is very very less chance of data loss.
>> But in case of no buffer, there will be data loss/miss.
> Clearly any such system will need a buffer of some sort to remain efficient.
> If done in userspace this could even be a file that is being read.
>>
>> Generally, as you know, application requests for frequency at which
>> hardware should send data for their reading.
>> But driver frequency to write data in buffer
>> and application frequency to read data does not match exactly.
>> So either fast or slow, we end with either data loss
>> or same data being sent again to app.
>>
>> Therefore, buffer is required to avoid such cases.
>>
>>
>>
>>
>>     >
>>     > [...]
>>     If we have a usecase for playback functionality like this I would prefer it to
>>     be on a separate IIO device.  When Lars' DAC buffered code is ready it will
>>     be relatively easy to string together a fake DAC with a fake ADC to get
>>     this sort of functionality.   It will be rather more interesting to
>>     work out how to setup an arbitary device but it could be done,
>>     most likely using configfs.
>>
>>     This would be more similar to uinput than the writing to the chardevs
>>     directly as you are suggesting here.
>>
>>     >>>>> Are you sure that this works? iio_push_to_buffer() expects a data buffer
>>     >>>>> of
>>     >>>>> size rb->bytes_per_datum bytes. On the other hand rb->bytes_per_datum is
>>     >>>>> only valid when the buffer is enabled, so for this to work the buffer
>>     >>>>> would
>>     >>>>> need to be enabled. Which means you'd inject the fake data in the middle
>>     >>>>> of
>>     >>>>> the real data stream.
>>     >>>>>
>>     >>>>>
>>     >>>>
>>     >>>> Yes, It works :)
>>     >>>> In one patch, bytes_per_datum has been removed from kifo_in.
>>     >>>> Patch - iio:kfifo_buf Take advantage of the fixed record size used in IIO
>>     >>>> commit c559afbfb08c7eac215ba417251225d3a8e01062
>>     >>>> - ret = kfifo_in(&kf->kf, data, r->bytes_per_datum);
>>     >>>> + ret = kfifo_in(&kf->kf, data, 1);
>>     >>>> So, I think we can now write only one byte of data.
>>     >>>
>>     >>>
>>     >>> No, we need to write 1 record and the size of one record is bytes_per_datum.
>>     >>> If you only write one byte you'll cause a out of bounds access.
>>     >>>
>>     >>>
>>     >>
>>     >> This is the code flow below which I checked:
>>     >>
>>     >> kfifo_in(&kf->kf, data, 1);
>>     >> so len=1
>>     >> kfifo_copy_in(fifo, buf, len, fifo->in);
>>     >> l = min(len, size - off);
>>     >> memcpy(fifo->data + off, src, l);
>>     >>
>>     >> In memcpy, if l is 1, so it will copy one byte only.
>>     >> So, how it is writing one record and not one byte ?
>>     > You missed this part:
>>     >
>>     >     if (esize != 1) {
>>     >         off *= esize;
>>     >         size *= esize;
>>     >         len *= esize;
>>     >     }
>>     >
>>     > so len gets multiplied by the record size. len=1 means 1 record.
>>     >
>>
>>
>> Oh, I really missed this part.
>> Thank you Mr. Lars for the correction.
>>
>> So, in the write function,
>> we can just replace 1 by rb->bytes_per_datum.
>> And add the check like below:
>> + if(!rb || rb->bytes_per_datum==0)
>> + return -1;
>>
>> I initially write the code with bytes_per_datum only.
>> But changed to 1 after seeing the latest kernel and
>> got confused with "1" value.
>>
>> Is there anything else need to be changed ?
>>
>>
>>
>>     >>
>>     >>>>
>>     >>>> Initially, I wrote the code for write functionality in kernel version 3.6
>>     >>>> using bytes_per_datum instead of fixed size of 1 byte.
>>     >>>> It worked fine. :)
>>     >>>> For this, we just need to replace size 1 by r->bytes_per_datum.
>>     >>>>
>>     >>>> We are not injecting data in middle of real data stream.
>>     >>>> When we inject the recorded data, we disabled the hardware chip,
>>     >>>> so no new/real data is pushed to the buffer during that time.
>>     >>>>
>>     >>>> To record, we enabled the buffer, read the real data and save it.
>>     >>>> To replay, we disabled the hardware chip and injected saved data by
>>     >>>> writing back to iio device node.
>>     >>>> So, Buffer is still enabled at time of writing to iio device node. :)
>>     >>>
>>     >>>
>>     >>> How do you disable the hardware without disabling the buffer?
>>     >>>
>>     >> I disabled the hardware by powering off the chip.
>>     >> And after writing is complete, chip is powered on again. :)
>>     >
>>     > But how do you disable the device when the buffer is still active?
>>     > IIO expects the device to be active when the buffer is active.
>>     Agreed. This sounds like a pretty uggly hack.  I would not be happy with
>>     having this in any driver.
>>
>>
>> Taking example of pressure sensor hardware chip,
>>
>> Case1: Normal case,
>> 1. We enabled the iio software buffer.
>> 2. Pressure Hardware chip generates an interrupt.
>> 3. Driver receives the interrupt call and make
>>    a call to push data to iio buffer
>>
>> But if there is no change in pressure i.e. there is no new data
>> hardware chip will not generate any interrupt and hence
>> no data is pushed to iio software buffer.
> That's actually unusual for an IIO device.  Unlike input which won't kick
> out data if there is no change, IIO devices typically don't assess that at all
> and will push data based on timing.
>
> There are devices that do support hysteresis on their triggers (thus requiring
> a significant change in value) but they are pretty unusual.
>
>> And iio software buffer is still active and waiting if there is any data comes.
>>
>> Case 2: My case,
>> 1. We enable the iio software buffer.
>> 2. We record the pressure real data if there is.
>> 3. We power off the pressure hardware chip
>>    or second way, we disable the irq only.
>
> Nasty and hacky.   Putting aside that I think this is generally a bad idea as
> explained above.  If you do this, you need to allow pushing of data with the interrupt
> still running with appropriate locking to prevent anything nasty occuring.
> Otherwise, you've just killed off the real reading.  The snag here is that you
> have no way of identifying the real reading from fake ones?  Which is right?
>
> I'm not going to be easily persuaded to take any driver that does this sort of
> faking without it being readily apparent to userspace that this is what is going
> on.
>
>>
>> In this case too, there will be no interrupt call received by driver,
>> and hence no data is pushed to iio buffer.
>> And iio software buffer is still active and waiting if there is any data comes.
>>
>> In both cases, from iio buffer perspective,
>> iio software buffer is active and waiting for some data.
>>
>> I cannot see any difference for IIO buffer in both cases.
>> So, I am not able to understand the problem here with IIO buffer ?
>>
>> Later in case 2, as buffer is active,
>> Sensor_Simulator_Application can write data to it
>> and Other_Sensor_Application/s can read data from it.
>> And after simulation is over,
>> we power on the hardware chip again or second way, enable the irq again,
>> everything gets back to normal as before.
>>
> Of course you are welcome to do what you like, but I'm only going to be
> interested in a true 'fake' driver to provide this functionality without
> ever pretending to be real.  Such a driver should be easy to userspace
> to identify and elect to ignore if it wants to.
>
> Sorry it has taken me so long to get back - been a busy few weeks.
> Also if this appears overly negative, remember that with my maintainers
> hat on I have to look at every proposal to change the IIO core and consider
> how it effects all our current use cases.


Okay.
I understand your point about fake driver. It seems better approach. :)

I also thought about such driver few weeks back
but as that time I was thinking from simulation application perspective
so I ignored it because I needed to develop an android application.

Currently, I do not know much about IIO kernel subsystem,
so I will try to explore more and then perhaps some time later,
I will try to work upon creating a fake IIO driver as suggested.

Thank you so much Mr. Jonathan and Mr. Lars for your time and suggestions.
It helped a lot. :)

Have a good day!

- Aniroop Mathur
