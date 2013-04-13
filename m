Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab3DMUiN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 16:38:13 -0400
Received: from www.linutronix.de ([62.245.132.108]:60556 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362Ab3DMUiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 16:38:11 -0400
Date: Sat, 13 Apr 2013 22:38:07 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Kevin Strasser <kevin.strasser@linux.intel.com>
cc: linux-kernel@vger.kernel.org,
        Michael Brunner <michael.brunner@kontron.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Wolfram Sang <wsa@the-dreams.de>,
        Ben Dooks <ben-linux@fluff.org>, linux-i2c@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        Darren Hart <dvhart@linux.intel.com>, Michael Brunner <mibru@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/4] mfd: Kontron PLD mfd driver
In-Reply-To: <1365441321-21952-1-git-send-email-kevin.strasser@linux.intel.com>
Message-ID: <alpine.LFD.2.02.1304132152320.21884@ionos>
References: <1365441321-21952-1-git-send-email-kevin.strasser@linux.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Apr 2013, Kevin Strasser wrote:
> --- /dev/null
> +++ b/drivers/mfd/kempld-core.c
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/list.h>
> +#include <linux/device.h>
> +#include <linux/platform_device.h>
> +#include <linux/dmi.h>
> +#include <linux/slab.h>
> +#include <linux/io.h>
> +#include <linux/sched.h>
> +#include <linux/mfd/core.h>
> +#include <linux/mfd/kempld.h>

I seriously doubt, that all these includes are required.

> +#define KEMPLD_MAINTAIN_EFT_COMPATIBILITY	1

What's the point of this define ?

> +static int kempld_platform_device_register(const struct dmi_system_id *id);
> +static int kempld_get_mutex_set_index_generic(struct kempld_device_data *pld,
> +					u8 index, unsigned int timeout);
> +static void kempld_release_mutex_generic(struct kempld_device_data *pld);
> +
> +static int kempld_get_info(struct kempld_device_data *pld);
> +static int kempld_get_info_NOW1(struct kempld_device_data *pld);

Can you please get rid of the CamelCase ?

> +static int kempld_get_info_generic(struct kempld_device_data *pld);
> +static int kempld_get_features(struct kempld_device_data *pld);
> +static int kempld_register_cells_generic(struct kempld_device_data *pld);
> +static int kempld_register_cells_NOW1(struct kempld_device_data *pld);

Can you please reshuffle the code, so that we can get rid of all these
forward declarations ?

> +#define MAX_IDENT_LEN 4
> +static char force_ident[MAX_IDENT_LEN + 1] = "";
> +module_param_string(force_ident, force_ident, sizeof(force_ident), 0);
> +MODULE_PARM_DESC(force_ident, "Force detection of specific product");

Please change this to something which is ad hoc understandable w/o
reading the code. e.g. "kempld_device_id". 

> +/* this option is only here for debugging and should never be needed in
> + * production environments */

/*
 * Please use standard multiline comment style and proper
 * sentences starting with a capital letter
 */

> +static bool force_unlock;
> +module_param(force_unlock, bool, 0);
> +MODULE_PARM_DESC(force_unlock, "Force breaking the semaphore on driver load");

Is it really necessary to carry this in the kernel? If yes, then please put it under

#ifdef DEBUG

We really can do without random debug code. And the comment should be
a little more elaborate about what the heck this is doing. "Force
breaking the semaphore ..." makes me shudder, w/o reading the code
which uses this.

> +/**
> + * kempld_read8 - read 8 bit register
> + * @pld: kempld_device_data structure describing the PLD
> + * @index: register index on the chip
> + *
> + * This function reads an 8 bit register of the PLD and returns its value.
> + *
> + * In order for this function to work correctly, kempld_try_get_mutex_set_index
> + * or kempld_get_mutex_set_index has to be called before calling the function
> + * to acquire the mutex. Afterwards the mutex has to be released with
> + * kempld_release_mutex.
> + */
> +u8 kempld_read8(struct kempld_device_data *pld, u8 index)
> +{
> +	kempld_set_index(pld, index);
> +
> +	return ioread8(pld->io_data);
> +}
> +EXPORT_SYMBOL(kempld_read8);

EXPORT_SYMBOL_GPL please. All over the place.

> +/**
> + * kempld_read16 - read 16 bit register
> + * @pld: kempld_device_data structure describing the PLD
> + * @index: register index on the chip
> + *
> + * This function reads a 16 bit register of the PLD and returns its value.
> + *
> + * In order for this function to work correctly, kempld_try_get_mutex_set_index
> + * or kempld_get_mutex_set_index has to be called before calling the function
> + * to acquire the mutex. Afterwards the mutex has to be released with
> + * kempld_release_mutex.
> + */
> +u16 kempld_read16(struct kempld_device_data *pld, u8 index)
> +{
> +	BUG_ON(index+1 < index);

Yuck. What kind of problem are you catching here? Just the corner case
that someone hands in 0xff as index?

I'd rather assume that you tried to catch the case where someone hand
in an index with BIT0 set. So that would be:
   
	BUG_ON(index & 0x01);

Aside of that, do you really want to kill the machine here? A
WARN_ON[_ONCE] would be more appropriate.

	WARN_ON_ONCE(index & 0x01);

> +	return kempld_read8(pld, index) | kempld_read8(pld, index+1) << 8;

  	       			 	  		    index + 1)
Please

> +void kempld_write16(struct kempld_device_data *pld, u8 index, u16 data)
> +{
> +	BUG_ON(index+1 < index);

See above. And all other functions which use that silly BUG_ON as well.

> +/**
> + * kempld_set_index - change the current register index of the PLD
> + * @pld: kempld_device_data structure describing the PLD
> + * @index: register index on the chip
> + *
> + * This function changes the register index of the PLD.

That's really important information after reading the above function
descriptor...

> + *
> + * If the PLD mutex has been acquired the whole time and the desired index is

-ENOPARSE

> + * already set there might be no actual hardware access done in this function.
> + *
> + * In order for this function to work correctly, kempld_try_get_mutex_set_index
> + * or kempld_get_mutex_set_index has to be called before calling the function
> + * to acquire the mutex. Afterwards the mutex has to be released with
> + * kempld_release_mutex.
> + */
> +void kempld_set_index(struct kempld_device_data *pld, u8 index)
> +{
> +	struct kempld_platform_data *pdata = pld->dev->platform_data;
> +
> +	BUG_ON(pld->have_mutex == 0);

What the heck is this? Does pld->have_mutex indicate that there is a
mutex associated with that PLD or what?

If you want to check whether the caller has acquired the mutex which
is always associated to that PLD then you should perhaps read the
mutex documentation^Wcode and figure out how to do that correctly.

> +	if (pld->last_index != index || pdata->force_index_write) {
> +		iowrite8(index, pld->io_index);
> +		pld->last_index = index;
> +	}
> +}
> +EXPORT_SYMBOL(kempld_set_index);
> +
> +static int kempld_get_mutex_set_index_generic(struct kempld_device_data *pld,
> +					u8 index, unsigned int timeout)
> +{
> +	struct kempld_platform_data *pdata = pld->dev->platform_data;
> +	int data;
> +
> +	if (!pld->have_mutex) {

So you use a boolean value to maintain concurrency? OMG. So any task
which calls this code and observes pld->have_mutex != 0 can
proceed. Brilliant design.

> +		unsigned long loop_timeout = jiffies + (HZ*timeout)/1000;
> +
> +		while ((((data = ioread8(pld->io_index)) & KEMPLD_MUTEX_KEY)
> +				== KEMPLD_MUTEX_KEY)) {

So there is a hardware concurrency control, which has a single KEY for
everyone? At least that's what I read from that code.

> +			if (timeout != KEMPLD_MUTEX_NOTIMEOUT)

WTF are you introducing another constant fpor INFINITE timeout?

> +				if (!time_before(jiffies, loop_timeout))
> +					return -ETIMEDOUT;
> +
> +			/* we will have to wait until mutex is free */
> +			spin_unlock_irqrestore(&pld->lock, pld->lock_flags);

Where the heck is documented that this function needs to be called
with pld->lock held and interrupts disabled?

> +			/* give other tasks a chance to release the mutex */
> +			schedule_timeout_interruptible(0);

Creative avoidance of yield? Not that yield is a good idea, but this
is f*cking absurd.

> +			spin_lock_irqsave(&pld->lock, pld->lock_flags);

What's the point of this exercise? 

> +		}
> +	} else
> +		data = ioread8(pld->io_index);
> +
> +	if (KEMPLD_MAINTAIN_EFT_COMPATIBILITY

Evaluates to TRUE unconditionally. What's the point ?

> +		 || ((pld->last_index != (data & ~KEMPLD_MUTEX_KEY))
> +		 || pdata->force_index_write)) {
> +		iowrite8(index, pld->io_index);
> +		pld->last_index = index;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * kempld_get_mutex_set_index - acquire the PLD mutex and set register index
> + * @pld: kempld_device_data structure describing the PLD
> + * @index: register index on the chip
> + *
> + * This function acquires a PLD spinlock and the PLD mutex, additionally it
> + * also changes the register index. In order to do no unnecessary write cycles
> + * the index provided to this function should be the same that will be used
> + * with the first PLD access that is done afterwards.
> + *
> + * The function will block for at least 10 seconds if the mutex can't be
> + * acquired and issue a warning in that case. In order to not lock the device,
> + * the function assumes that the mutex has been acquired in that case.

What the heck? We do not do that in the kernel. Either you get your
locking correct, or you don't. There is no point of 10 seconds timeout
to get a "mutex" which is actually not a mutex. You call that code
with the spinlock held and irqs disabled. Pretty much not mutex
semantics.

> + * To release the spinlock and mutex kempld_release_mutex can be called.
> + * The spinlock and mutex should only be kept for a few milliseconds, in order
> + * to give other drivers a chance to work with the PLD.
> + */
> +inline void kempld_get_mutex_set_index(struct kempld_device_data *pld,
> +					u8 index)
> +{
> +	struct kempld_platform_data *pdata = pld->dev->platform_data;
> +
> +	spin_lock_irqsave(&pld->lock, pld->lock_flags);
> +
> +	if (pdata->get_mutex_set_index) {
> +		/* use a long timeout here as this shouldn't fail */
> +		if (pdata->get_mutex_set_index(pld, index, 10000))
> +			dev_warn(pld->dev, "semaphore broken!\n");
> +
> +		pld->have_mutex = 1;

Now I really start to go berserk. What's the point of this timeout
thing and what is the point of pdata->get_mutex_set_index ?

Either you have the need for a hardware controlled serialization or
you do not. I have the feeling that your understanding of concurrency
control is close to ZERO. 

I'm stopping the review here as this is just a f*cking nightmare and
going further down the patch is just a pointless exercise.

NAK to the whole patch series.

Thanks,

	tglx
