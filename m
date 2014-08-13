Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbaHMQdw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 12:33:52 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:51350 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbaHMQdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 12:33:50 -0400
MIME-Version: 1.0
In-Reply-To: <53EB7AD9.9010602@metafoo.de>
References: <1407911391-26696-1-git-send-email-a.mathur@samsung.com>
	<53EB2AFE.10900@metafoo.de>
	<CADYu309nTht96H077D6YGvhRYz6Xfux7Qri5Hi7dfgQMtOz-Pg@mail.gmail.com>
	<53EB7AD9.9010602@metafoo.de>
Date: Wed, 13 Aug 2014 22:03:48 +0530
Message-ID: <CADYu30-RHmysR5vhvNLGXMBx2gnQ6rkdW-pPzyVY=E4KYg8g9w@mail.gmail.com>
Subject: Re: [PATCH 1/1] IIO: Added write function in iio_buffer_fileops
From: Aniroop Mathur <aniroop.mathur@gmail.com>
To: Lars-Peter Clausen <lars@metafoo.de>,
        "jic23@kernel.org" <jic23@kernel.org>
Cc: a.mathur@samsung.com, "cpgs ." <cpgs@samsung.com>,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        p.shailesh@samsung.com, r.mahale@samsung.com, vidushi.koul@samsung.com,
        narendra.m1@samsung.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 8:18 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:
> On 08/13/2014 03:42 PM, Aniroop Mathur wrote:
>>
>> On Wed, Aug 13, 2014 at 2:38 PM, Lars-Peter Clausen <lars@metafoo.de>
>> wrote:
>>>
>>> On 08/13/2014 08:29 AM, a.mathur@samsung.com wrote:
>>>>
>>>>
>>>> From: Aniroop Mathur <a.mathur@samsung.com>
>>>>
>>>> Earlier, user space can only read from iio device node but cannot write
>>>> to
>>>> it.
>>>> This patch adds write function in iio buffer file operations,
>>>> which will allow user-space applications/HAL to write the data
>>>> to iio device node.
>>>> So now there will be two way communication between IIO subsystem
>>>> and user space. (userspace <--> kernel)
>>>>
>>>> It can be used by HAL or any user-space application which wants to
>>>> write data to iio device node/buffer upon receiving some data from it.
>>>> As an example,
>>>> It is useful for iio device simulator application which need to record
>>>> the data by reading from iio device node and replay the recorded data
>>>> by writing back to iio device node.
>>>>
>>>
>>> I'm not convinced that this is something that should be added to the
>>> kernel.
>>> I'm wondering why can't this be done in userspace, e.g. by having a
>>> simulator mode for the application or by using LD_PRELOAD. Having this in
>>> userspace will be much more flexible and will be easier to implement
>>> correctly and you'll most likely want to simulate more than just buffer
>>> access, for example setting/getting properties of the device or channel.
>>> For
>>> the libiio[1] we are planning to implement a test backend that when
>>> activated will allow to simulate a whole device rather than just buffer
>>> support.
>>>
>>> [1] https://github.com/analogdevicesinc/libiio
>>>
>>>
>>
>> In normal Input Subsystem, there is two way communication between
>> kernel and userpace. It has both read and write functionality. :)
>> Why there is only one way communication in case of IIO ?
>
>
> I've not seen a compelling reason yet why this must be implemented in kernel
> space. In my opinion, as outlined above, userspace if both easier and more
> flexible.
>
>
>>
>> For Input devices, I completed simulation just by reading and writing at
>> input device node /dev/input/eventX.
>> But for IIO devices, I am stuck as there is no write function available
>> for iio device node /dev/iio:device0.
>>
>> As per my understanding, if we do the simulation in userspace
>> then we need to create one more buffer in userpace. This will lead to
>> extra memory usage. With write functionality in IIO just like
>> in Input subsystem, we can avoid extra memory space. :)
>
>
> No, you don't actually have to create a additional buffer. Just return the
> data that you'd otherwise have passed to write().
>
>

If there is no buffer, then there is clearly a chance of data loss/miss. :)
Because if one application is reading the data with frequency 5 Hz
and other application is writing the data at frequency 50 Hz (20 ms delay)
so this reading application will miss reading a lot of data.
Like in this case, after every 200 ms, 9 out of 10 data will be missed.

>>
>>>> Signed-off-by: Aniroop Mathur <a.mathur@samsung.com>
>>>> ---
>>>>    drivers/iio/iio_core.h            |    5 ++++-
>>>>    drivers/iio/industrialio-buffer.c |   34
>>>> ++++++++++++++++++++++++++++++++++
>>>>    drivers/iio/industrialio-core.c   |    1 +
>>>>    3 files changed, 39 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/iio/iio_core.h b/drivers/iio/iio_core.h
>>>> index 5f0ea77..ba3fe53 100644
>>>> --- a/drivers/iio/iio_core.h
>>>> +++ b/drivers/iio/iio_core.h
>>>> @@ -47,10 +47,12 @@ unsigned int iio_buffer_poll(struct file *filp,
>>>>                               struct poll_table_struct *wait);
>>>>    ssize_t iio_buffer_read_first_n_outer(struct file *filp, char __user
>>>> *buf,
>>>>                                        size_t n, loff_t *f_ps);
>>>> -
>>>> +ssize_t iio_buffer_write_first_n_outer(struct file *filp,
>>>> +                            const char __user *buf, size_t n, loff_t
>>>> *f_ps);
>>>>
>>>>    #define iio_buffer_poll_addr (&iio_buffer_poll)
>>>>    #define iio_buffer_read_first_n_outer_addr
>>>> (&iio_buffer_read_first_n_outer)
>>>> +#define iio_buffer_write_first_n_outer_addr
>>>> (&iio_buffer_write_first_n_outer)
>>>>
>>>>    void iio_disable_all_buffers(struct iio_dev *indio_dev);
>>>>    void iio_buffer_wakeup_poll(struct iio_dev *indio_dev);
>>>> @@ -59,6 +61,7 @@ void iio_buffer_wakeup_poll(struct iio_dev
>>>> *indio_dev);
>>>>
>>>>    #define iio_buffer_poll_addr NULL
>>>>    #define iio_buffer_read_first_n_outer_addr NULL
>>>> +#define iio_buffer_write_first_n_outer_addr NULL
>>>>
>>>>    static inline void iio_disable_all_buffers(struct iio_dev *indio_dev)
>>>> {}
>>>>    static inline void iio_buffer_wakeup_poll(struct iio_dev *indio_dev)
>>>> {}
>>>> diff --git a/drivers/iio/industrialio-buffer.c
>>>> b/drivers/iio/industrialio-buffer.c
>>>> index 9f1a140..ef889af 100644
>>>> --- a/drivers/iio/industrialio-buffer.c
>>>> +++ b/drivers/iio/industrialio-buffer.c
>>>> @@ -21,6 +21,7 @@
>>>>    #include <linux/slab.h>
>>>>    #include <linux/poll.h>
>>>>    #include <linux/sched.h>
>>>> +#include <asm/uaccess.h>
>>>
>>>
>>>
>>> linux/uaccess.h
>>>
>>>
>>>>
>>>>    #include <linux/iio/iio.h>
>>>>    #include "iio_core.h"
>>>> @@ -87,6 +88,39 @@ ssize_t iio_buffer_read_first_n_outer(struct file
>>>> *filp, char __user *buf,
>>>>    }
>>>>
>>>>    /**
>>>> + * iio_buffer_write_first_n_outer() - chrdev write to buffer
>>>> + *
>>>> + * This function pushes the user space data to kernel iio buffer
>>>> + **/
>>>> +ssize_t iio_buffer_write_first_n_outer(struct file *filp,
>>>> +                               const char __user *buf, size_t n, loff_t
>>>> *f_ps)
>>>> +{
>>>> +       struct iio_dev *indio_dev = filp->private_data;
>>>> +       struct iio_buffer *rb = indio_dev->buffer;
>>>> +       int ret = -1;
>>>> +       unsigned char *data = NULL;
>>>> +
>>>> +       if (!indio_dev->info)
>>>> +               return -ENODEV;
>>>> +
>>>> +       if (n != 1)
>>>> +               return -EINVAL;
>>>> +
>>>> +       data = kzalloc(1, GFP_KERNEL);
>>>> +       if (!data)
>>>> +               return -ENOMEM;
>>>> +
>>>> +       if (copy_from_user(data, buf, 1)) {
>>>> +               kfree(data);
>>>> +               return -EFAULT;
>>>> +       }
>>>> +
>>>> +       ret = iio_push_to_buffer(rb, data);
>>>
>>>
>>>
>>> Are you sure that this works? iio_push_to_buffer() expects a data buffer
>>> of
>>> size rb->bytes_per_datum bytes. On the other hand rb->bytes_per_datum is
>>> only valid when the buffer is enabled, so for this to work the buffer
>>> would
>>> need to be enabled. Which means you'd inject the fake data in the middle
>>> of
>>> the real data stream.
>>>
>>>
>>
>> Yes, It works :)
>> In one patch, bytes_per_datum has been removed from kifo_in.
>> Patch - iio:kfifo_buf Take advantage of the fixed record size used in IIO
>> commit c559afbfb08c7eac215ba417251225d3a8e01062
>> - ret = kfifo_in(&kf->kf, data, r->bytes_per_datum);
>> + ret = kfifo_in(&kf->kf, data, 1);
>> So, I think we can now write only one byte of data.
>
>
> No, we need to write 1 record and the size of one record is bytes_per_datum.
> If you only write one byte you'll cause a out of bounds access.
>
>

This is the code flow below which I checked:

kfifo_in(&kf->kf, data, 1);
so len=1
kfifo_copy_in(fifo, buf, len, fifo->in);
l = min(len, size - off);
memcpy(fifo->data + off, src, l);

In memcpy, if l is 1, so it will copy one byte only.
So, how it is writing one record and not one byte ?

>>
>> Initially, I wrote the code for write functionality in kernel version 3.6
>> using bytes_per_datum instead of fixed size of 1 byte.
>> It worked fine. :)
>> For this, we just need to replace size 1 by r->bytes_per_datum.
>>
>> We are not injecting data in middle of real data stream.
>> When we inject the recorded data, we disabled the hardware chip,
>> so no new/real data is pushed to the buffer during that time.
>>
>> To record, we enabled the buffer, read the real data and save it.
>> To replay, we disabled the hardware chip and injected saved data by
>> writing back to iio device node.
>> So, Buffer is still enabled at time of writing to iio device node. :)
>
>
> How do you disable the hardware without disabling the buffer?
>
I disabled the hardware by powering off the chip.
And after writing is complete, chip is powered on again. :)

Thanks,
Aniroop
