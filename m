Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799AbaEGQad (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 12:30:33 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45417 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493AbaEGQac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 12:30:32 -0400
Date: Wed, 7 May 2014 17:29:41 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Pali =?UTF-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, linux-doc@vger.kernel.org,
        Sonal Santan <sonal.santan@gmail.com>
Subject: Re: [PATCH 1/2] platform: x86: dell-smo8800: Dell Latitude freefall
 driver (ACPI SMO8800/SMO8810)
Message-ID: <20140507172941.66aca8fa@alan.etchedpixels.co.uk>
In-Reply-To: <1399114077-19314-2-git-send-email-pali.rohar@gmail.com>
References: <1399114077-19314-1-git-send-email-pali.rohar@gmail.com>
	<1399114077-19314-2-git-send-email-pali.rohar@gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static irqreturn_t smo8800_interrupt_quick(int irq, void *data)
> +{
> +	struct smo8800_device *smo8800 = data;
> +	atomic_inc(&smo8800->count);
> +	wake_up_interruptible(&smo8800->misc_wait);
> +	return IRQ_WAKE_THREAD;
> +}
> +
> +static irqreturn_t smo8800_interrupt_thread(int irq, void *data)
> +{
> +	struct smo8800_device *smo8800 = data;
> +	dev_info(smo8800->dev, "detected free fall\n");

printk should be fast enough not to justify a thread, in fact the
threaded IRQ overhead is going to be higher than the printk IMHO.

I'm not entirely sure a printk is the useful response here either ?


> +static ssize_t smo8800_misc_read(struct file *file, char __user *buf,
> +				 size_t count, loff_t *pos)
> +{
> +	struct smo8800_device *smo8800 = container_of(file->private_data,
> +					 struct smo8800_device, miscdev);
> +
> +	DECLARE_WAITQUEUE(wait, current);
> +	u32 data;
> +	unsigned char byte_data;
> +	ssize_t retval = 1;
> +
> +	if (count < 1)
> +		return -EINVAL;

How can this occur ??

> +
> +	add_wait_queue(&smo8800->misc_wait, &wait);
> +	while (true) {
> +		set_current_state(TASK_INTERRUPTIBLE);
> +		data = atomic_xchg(&smo8800->count, 0);
> +		if (data)
> +			break;
> +
> +		if (file->f_flags & O_NONBLOCK) {
> +			retval = -EAGAIN;
> +			goto out;
> +		}
> +
> +		if (signal_pending(current)) {
> +			retval = -ERESTARTSYS;
> +			goto out;
> +		}
> +
> +		schedule();
> +	}

wait_event_interruptible ?

> +	if (copy_to_user(buf, &byte_data, sizeof(byte_data)))
> +		retval = -EFAULT;

put_user


> +static int smo8800_add(struct acpi_device *device)
> +{
> +	int err;
> +	struct smo8800_device *smo8800;
> +
> +	if (!device)
> +		return -EINVAL;

How can this occur ??

> +	atomic_set(&smo8800->count, 0);

Not needed - you can't see a count until it is open

> +	dev_info(&device->dev, "device /dev/freefall registered with IRQ %d\n",
> +		 smo8800->irq);

dev_dbg would be more appropriate. If every driver reported its
registration we'd drown in logs

> +	dev_info(&device->dev, "device /dev/freefall unregistered\n");

Ditto


Alan
