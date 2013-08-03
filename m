Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab3HCB41 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 21:56:27 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:58203 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751127Ab3HCB40 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 21:56:26 -0400
Message-ID: <1375494985.2034.160.camel@joe-AO722>
Subject: Re: [PATCH 001/001] CHAR DRIVERS: a simple device to give daemons a
 /sys-like interface
From: Joe Perches <joe@perches.com>
To: Bob Smith <bsmith@linuxtoys.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Date: Fri, 02 Aug 2013 18:56:25 -0700
In-Reply-To: <51FC5A97.1090102@linuxtoys.org>
References: <51FC5478.40500@linuxtoys.org> <51FC5A97.1090102@linuxtoys.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-02 at 18:19 -0700, Bob Smith wrote:
> This character device can give daemons an interface similar to
> the kernel's /sys and /proc interfaces.   It is a nice way to
> give user space drivers real device nodes in /dev.

Trivial notes:

> diff --git a/drivers/char/proxy.c b/drivers/char/proxy.c
[]
+int proxy_init_module(void)
> +{
> +	int i, err;
> +	px_devices = kmalloc(numberofdevs * sizeof(struct px), GFP_KERNEL);
> +	if (px_devices == NULL) {
> +		/* no memory available */
> +		if (debuglevel >= 1)
> +			pr_err("%s: init fails: no memory.\n",
> +			       DEVNAME);

OOM messages aren't necessary.
dump_stack() is already done on OOM.

> +		return 0;
> +	}
> +	memset(px_devices, 0, numberofdevs * sizeof(struct px));

kcalloc instead of kmalloc/memset

> +
> +	/* init devices in this block */
> +	for (i = 0; i < numberofdevs; i++) {   /* for every minor device */
> +		px_devices[i].minor = i;	  /* set minor number */
> +		px_devices[i].ewbuf.buf = (char *) 0;
> +		px_devices[i].webuf.buf = (char *) 0;
> +		px_devices[i].ewbuf.widx = 0;
> +		px_devices[i].webuf.widx = 0;
> +		px_devices[i].ewbuf.ridx = 0;
> +		px_devices[i].webuf.ridx = 0;

sets to zero after zeroed alloc are redundant.

> +	err = cdev_add(&px_cdev, px_devicenumber, numberofdevs);
> +	if (err < 0) {
> +		if (debuglevel >= 1)
> +			pr_err("%s: init fails. err=%d.\n",
> +			       DEVNAME, err);
> +		return err;
> +	}

It's either an err or a debug message.
Don't hide actual errors under debugging levels.

I suggest you only use pr_debug and/or have a macro like

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

#define proxy_dbg(level, fmt, ...)		\
do {						\
	if (level >= debuglevel)		\
		pr_debug(fmt, ##__VA_ARGS__);	\
} while (0)

> +	if (debuglevel >= 2)
> +		pr_info("%s: Installed %d minor devices on major number %d.\n",
> +		       DEVNAME, numberofdevs, px_major);

Then this (and the rest) becomes

		proxy_dbg(2, "Installed %d minor devices on major %d\n",
			  numberofdevs, px_major);

etc...


> +static int proxy_open(struct inode *inode, struct file *filp)
> +{

> +	if (!dev->ewbuf.buf) {			/* get east-to-west buffer */
> +		dev->ewbuf.buf = kmalloc(buffersize, GFP_KERNEL);
> +		if (!dev->ewbuf.buf) {
> +			if (debuglevel >= 1)
> +				pr_err("%s: No memory dev=%d.\n",
> +				       DEVNAME, mnr);
> +			up(&dev->sem);
> +			return -ENOMEM;
> +		}
> +	}
> +	if (!dev->webuf.buf) {			/* get west-to-east buffer */
> +		dev->webuf.buf = kmalloc(buffersize, GFP_KERNEL);
> +		if (!dev->webuf.buf) {
> +			if (debuglevel >= 1)
> +				pr_err("%s: No memory dev=%d.\n",
> +				       DEVNAME, mnr);

no OOMs.

> +static int proxy_release(struct inode *inode, struct file *filp)
> +{
> +	struct px *dev = (struct px *) filp->private_data;
> +
> +	if (debuglevel >= 3)
> +		pr_info("%s release. Minor#=%d.\n", DEVNAME,
> +		       ((struct px *) filp->private_data)->minor);
> +
> +	if (down_interruptible(&dev->sem))	/* prevent races on close */
> +		return -ERESTARTSYS;
> +
> +	dev->nopen = dev->nopen - 1;
> +
> +	if (dev->east == filp) {
> +		dev->east = (struct file *) 0;	/* mark as not in use */

s/0/NULL; (no need to cast either)

> +		dev->ewbuf.cidx = dev->ewbuf.widx; /* set close index */
> +	} else if (dev->west == filp) {
> +		dev->west = (struct file *) 0;	/* mark as not in use */

etc.


