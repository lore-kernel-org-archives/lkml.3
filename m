Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab3AWBDy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 20:03:54 -0500
Received: from tex.lwn.net ([70.33.254.29]:44328 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861Ab3AWBDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 20:03:51 -0500
Date: Tue, 22 Jan 2013 18:03:49 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Roland Stigge <stigge@antcom.de>
Cc: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com, sr@denx.de, wg@grandegger.com, mark.rutland@arm.com,
        nicolas.ferre@atmel.com
Subject: Re: [PATCH 3/6 v14] gpio: Add userland device interface to block
 GPIO
Message-ID: <20130122180349.068f2c6a@lwn.net>
In-Reply-To: <1358856404-8975-4-git-send-email-stigge@antcom.de>
References: <1358856404-8975-1-git-send-email-stigge@antcom.de>
	<1358856404-8975-4-git-send-email-stigge@antcom.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jan 2013 13:06:41 +0100
Roland Stigge <stigge@antcom.de> wrote:

> This patch adds a character device interface to the block GPIO system.

So I was looking at this, and a couple of things caught my eye...

> +static int gpio_block_fop_open(struct inode *in, struct file *f)
> +{
> +	int i;
> +	struct gpio_block *block = gpio_block_find_by_minor(MINOR(in->i_rdev));
> +	int status;
> +	int irq;
> +
> +	if (!block)
> +		return -ENOENT;
> +
> +	block->irq_controlled = false;
> +	block->got_int = false;
> +	spin_lock_init(&block->lock);

So...  there is no protection I can find against multiple opens here.
Meaning that the second process to open the device will reinitialize the
lock (and other variables), regardless of their current state.

More to the point, though, I'm not at all clear on what this lock protects?
It seems to be restricted to the got_int flag, which could be manipulated -
without locks - with bitops?  Or am I missing something?

> +	init_waitqueue_head(&block->wait_queue);
> +	f->private_data = block;
> +
> +	for (i = 0; i < block->ngpio; i++) {
> +		status = gpio_request(block->gpio[i], block->name);

Hmm...  the documentation for the API says that gpio_request() has to be
called separately.  But now you're doing it here?  That's probably OK, but
calling gpio_free() at close time could lead to interesting results if the
code that set up the block expects them to still be allocated.  It seems
like the API should be consistent with regard to this - either call
gpio_request() when the block is created, or always require the caller to
do it.

A quick look shows that the sysfs interface does the same thing?  So now
you're already double-requesting and freeing the gpios?

> +		if (status)
> +			goto err1;
> +
> +		irq = gpio_to_irq(block->gpio[i]);
> +		if (irq >= 0 &&
> +		    !test_bit(FLAG_IS_OUT, &gpio_desc[block->gpio[i]].flags) &&
> +		    !gpio_block_is_irq_duplicate(block, i)) {
> +			status = request_irq(irq, gpio_block_irq_handler,
> +					     IRQF_SHARED,
> +					     block->name, block);
> +			if (status)
> +				goto err2;
> +
> +			block->irq_controlled = true;
> +		}
> +	}

This forces the block to work in the IRQ-driven mode if a line is capable
of it, regardless of whether the creator (or the process calling open())
wants that.  It seems like that should be controllable separately?

> +
> +	return 0;
> +
> +err1:
> +	while (i > 0) {
> +		i--;
> +
> +		irq = gpio_to_irq(block->gpio[i]);
> +		if (irq >= 0 &&
> +		    !test_bit(FLAG_IS_OUT, &gpio_desc[block->gpio[i]].flags) &&
> +		    !gpio_block_is_irq_duplicate(block, i))
> +			free_irq(irq, block);
> +err2:
> +		gpio_free(block->gpio[i]);

Um...wait...you're jumping into the middle of the while loop?  I guess that
will work, but ... hmm...

> +	}
> +	return status;
> +}
> +
> +static int gpio_block_fop_release(struct inode *in, struct file *f)
> +{
> +	int i;
> +	struct gpio_block *block = (struct gpio_block *)f->private_data;

Is there anything that will have prevented a call to gpio_block_free()
while the device is open?  This seems like a concern for all of the fops
here. 

> +	for (i = 0; i < block->ngpio; i++) {
> +		int irq = gpio_to_irq(block->gpio[i]);
> +
> +		if (irq >= 0 &&
> +		    !test_bit(FLAG_IS_OUT, &gpio_desc[block->gpio[i]].flags) &&
> +		    !gpio_block_is_irq_duplicate(block, i))
> +			free_irq(irq, block);
> +
> +		gpio_free(block->gpio[i]);
> +	}
> +
> +	return 0;
> +}
> +
> +static int got_int(struct gpio_block *block)
> +{
> +	unsigned long flags;
> +	int result;
> +
> +	spin_lock_irqsave(&block->lock, flags);
> +	result = block->got_int;
> +	spin_unlock_irqrestore(&block->lock, flags);

The lock doesn't really buy you much here.  Might you have wanted to reset
block->got_int here too?

> +
> +	return result;
> +}
> +
> +static ssize_t gpio_block_fop_read(struct file *f, char __user *buf, size_t n,
> +				   loff_t *offset)
> +{
> +	struct gpio_block *block = (struct gpio_block *)f->private_data;
> +	int err;
> +	unsigned long flags;
> +
> +	if (block->irq_controlled) {
> +		if (!(f->f_flags & O_NONBLOCK))
> +			wait_event_interruptible(block->wait_queue,
> +						 got_int(block));
> +		spin_lock_irqsave(&block->lock, flags);
> +		block->got_int = 0;
> +		spin_unlock_irqrestore(&block->lock, flags);
> +	}

If two processes are waiting on the device, they might both wake up on the
same interrupt.  The second might even reset block->got_int after *another*
interrupt has arrived, causing it to be lost.  Or am I missing something?

> +	if (n >= sizeof(unsigned long)) {
> +		unsigned long values = gpio_block_get(block, block->cur_mask);
> +
> +		err = put_user(values, (unsigned long __user *)buf);
> +		if (err)
> +			return err;
> +
> +		return sizeof(unsigned long);
> +	}
> +	return 0;

And here you've consumed the interrupt even in the case where you'll not
actually return the gpios or return any data.  This one could maybe be
considered to be user-space programmer error, but still...

> +}
> +
> +static ssize_t gpio_block_fop_write(struct file *f, const char __user *buf,
> +				    size_t n, loff_t *offset)
> +{
> +	struct gpio_block *block = (struct gpio_block *)f->private_data;
> +	int err;
> +
> +	if (n >= sizeof(unsigned long)) {
> +		unsigned long values;
> +
> +		err = get_user(values, (unsigned long __user *)buf);
> +		if (err)
> +			return err;
> +		if (gpio_block_is_output(block))
> +			gpio_block_set(block, block->cur_mask, values);
> +		else
> +			return -EPERM;

Is EPERM right?  Or maybe EINVAL?

> +		return sizeof(unsigned long);
> +	}
> +	return 0;
> +}
> +
> +static long gpio_block_fop_ioctl(struct file *f, unsigned int cmd,
> +				 unsigned long arg)
> +{
> +	struct gpio_block *block = (struct gpio_block *)f->private_data;
> +	unsigned long __user *x = (unsigned long __user *)arg;
> +
> +	if (cmd == 0)
> +		return get_user(block->cur_mask, x);

...and this is a little weird.  It seems you should define a proper ioctl()
command code like everybody else does.

> +	return -EINVAL;
> +}
> +
> +static unsigned int gpio_block_fop_poll(struct file *f,
> +					struct poll_table_struct *pt)
> +{
> +	struct gpio_block *block = (struct gpio_block *)f->private_data;
> +
> +	if (!block->irq_controlled)
> +		return -ENOSYS;

Is that what you want, or should you just return POLLIN|POLLOUT in this
case? 

> +	if (!got_int(block))
> +		poll_wait(f, &block->wait_queue, pt);
> +
> +	if (got_int(block))
> +		return POLLIN;

How about 

	if (got_int(block))
		return POLLIN;
        poll_wait(f, &block->wait_queue, pt);

?

jon
