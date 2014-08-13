Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510AbaHMJIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 05:08:22 -0400
Received: from smtp-out-102.synserver.de ([212.40.185.102]:1063 "EHLO
	smtp-out-102.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaHMJIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 05:08:20 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 18600
Message-ID: <53EB2AFE.10900@metafoo.de>
Date: Wed, 13 Aug 2014 11:08:14 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.7.0
MIME-Version: 1.0
To: a.mathur@samsung.com, jic23@kernel.org
CC: cpgs@samsung.com, linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        aniroop.mathur@gmail.com, p.shailesh@samsung.com, r.mahale@samsung.com,
        vidushi.koul@samsung.com, narendra.m1@samsung.com
Subject: Re: [PATCH 1/1] IIO: Added write function in iio_buffer_fileops
References: <1407911391-26696-1-git-send-email-a.mathur@samsung.com>
In-Reply-To: <1407911391-26696-1-git-send-email-a.mathur@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2014 08:29 AM, a.mathur@samsung.com wrote:
> From: Aniroop Mathur <a.mathur@samsung.com>
>
> Earlier, user space can only read from iio device node but cannot write to it.
> This patch adds write function in iio buffer file operations,
> which will allow user-space applications/HAL to write the data
> to iio device node.
> So now there will be two way communication between IIO subsystem
> and user space. (userspace <--> kernel)
>
> It can be used by HAL or any user-space application which wants to
> write data to iio device node/buffer upon receiving some data from it.
> As an example,
> It is useful for iio device simulator application which need to record
> the data by reading from iio device node and replay the recorded data
> by writing back to iio device node.
>

I'm not convinced that this is something that should be added to the kernel. 
I'm wondering why can't this be done in userspace, e.g. by having a 
simulator mode for the application or by using LD_PRELOAD. Having this in 
userspace will be much more flexible and will be easier to implement 
correctly and you'll most likely want to simulate more than just buffer 
access, for example setting/getting properties of the device or channel. For 
the libiio[1] we are planning to implement a test backend that when 
activated will allow to simulate a whole device rather than just buffer support.

[1] https://github.com/analogdevicesinc/libiio

> Signed-off-by: Aniroop Mathur <a.mathur@samsung.com>
> ---
>   drivers/iio/iio_core.h            |    5 ++++-
>   drivers/iio/industrialio-buffer.c |   34 ++++++++++++++++++++++++++++++++++
>   drivers/iio/industrialio-core.c   |    1 +
>   3 files changed, 39 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/iio/iio_core.h b/drivers/iio/iio_core.h
> index 5f0ea77..ba3fe53 100644
> --- a/drivers/iio/iio_core.h
> +++ b/drivers/iio/iio_core.h
> @@ -47,10 +47,12 @@ unsigned int iio_buffer_poll(struct file *filp,
>   			     struct poll_table_struct *wait);
>   ssize_t iio_buffer_read_first_n_outer(struct file *filp, char __user *buf,
>   				      size_t n, loff_t *f_ps);
> -
> +ssize_t iio_buffer_write_first_n_outer(struct file *filp,
> +			     const char __user *buf, size_t n, loff_t *f_ps);
>
>   #define iio_buffer_poll_addr (&iio_buffer_poll)
>   #define iio_buffer_read_first_n_outer_addr (&iio_buffer_read_first_n_outer)
> +#define iio_buffer_write_first_n_outer_addr (&iio_buffer_write_first_n_outer)
>
>   void iio_disable_all_buffers(struct iio_dev *indio_dev);
>   void iio_buffer_wakeup_poll(struct iio_dev *indio_dev);
> @@ -59,6 +61,7 @@ void iio_buffer_wakeup_poll(struct iio_dev *indio_dev);
>
>   #define iio_buffer_poll_addr NULL
>   #define iio_buffer_read_first_n_outer_addr NULL
> +#define iio_buffer_write_first_n_outer_addr NULL
>
>   static inline void iio_disable_all_buffers(struct iio_dev *indio_dev) {}
>   static inline void iio_buffer_wakeup_poll(struct iio_dev *indio_dev) {}
> diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
> index 9f1a140..ef889af 100644
> --- a/drivers/iio/industrialio-buffer.c
> +++ b/drivers/iio/industrialio-buffer.c
> @@ -21,6 +21,7 @@
>   #include <linux/slab.h>
>   #include <linux/poll.h>
>   #include <linux/sched.h>
> +#include <asm/uaccess.h>

linux/uaccess.h

>
>   #include <linux/iio/iio.h>
>   #include "iio_core.h"
> @@ -87,6 +88,39 @@ ssize_t iio_buffer_read_first_n_outer(struct file *filp, char __user *buf,
>   }
>
>   /**
> + * iio_buffer_write_first_n_outer() - chrdev write to buffer
> + *
> + * This function pushes the user space data to kernel iio buffer
> + **/
> +ssize_t iio_buffer_write_first_n_outer(struct file *filp,
> +				const char __user *buf, size_t n, loff_t *f_ps)
> +{
> +	struct iio_dev *indio_dev = filp->private_data;
> +	struct iio_buffer *rb = indio_dev->buffer;
> +	int ret = -1;
> +	unsigned char *data = NULL;
> +
> +	if (!indio_dev->info)
> +		return -ENODEV;
> +
> +	if (n != 1)
> +		return -EINVAL;
> +
> +	data = kzalloc(1, GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	if (copy_from_user(data, buf, 1)) {
> +		kfree(data);
> +		return -EFAULT;
> +	}
> +
> +	ret = iio_push_to_buffer(rb, data);

Are you sure that this works? iio_push_to_buffer() expects a data buffer of 
size rb->bytes_per_datum bytes. On the other hand rb->bytes_per_datum is 
only valid when the buffer is enabled, so for this to work the buffer would 
need to be enabled. Which means you'd inject the fake data in the middle of 
the real data stream.

> +	kfree(data);
> +	return ret;
> +}
[...]

