Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbaKDIsx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:48:53 -0500
Received: from sym2.noone.org ([178.63.92.236]:60625 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752793AbaKDIsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:48:47 -0500
Date: Tue, 4 Nov 2014 09:48:33 +0100
From: Tobias Klauser <tklauser@distanz.ch>
To: Stephanie Wallick <stephanie.s.wallick@intel.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, "Sean O. Stalley" <sean.stalley@intel.com>
Subject: Re: [PATCH 05/10] added media specific (MS) TCP drivers
Message-ID: <20141104084833.GF26719@distanz.ch>
References: <1415047377-3139-1-git-send-email-stephanie.s.wallick@intel.com>
 <1415047377-3139-6-git-send-email-stephanie.s.wallick@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415047377-3139-6-git-send-email-stephanie.s.wallick@intel.com>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-11-03 at 21:42:52 +0100, Stephanie Wallick <stephanie.s.wallick@intel.com> wrote:
> This is where we handle media specific packets and transport. The MS driver
> interfaces with a media agnostic (MA) driver via a series of transfer pairs.
> Transfer pairs consist of a set of functions to pass MA USB packets back
> and forth between MA and MS drivers. There is one transfer pair per device
> endpoint and one transfer pair for control/management traffic. When the MA
> driver needs to send an MA USB packet, it hands the packet off to the MS
> layer where the packet is converted into an MS form and sent via TCP over
> the underlying ethernet or wireless medium. When the MS driver receives a
> packet, it converts it into an MA USB packet and hands it off the the MA
> driver for handling.
> 
> In addition, the MS driver provides an interface to inititate connection events.
> Because there are no physical MA USB ports in an MA USB host, the host must be
> notified via software when a device is connected.
> 
> Lastly, the MS driver contains a number of ioctl functions that are used by a
> utility to adjust medium-related driver parameters and connect or disconnect the
> MA USB host and device drivers.
> 
> Signed-off-by: Sean O. Stalley <sean.stalley@intel.com>
> Signed-off-by: Stephanie Wallick <stephanie.s.wallick@intel.com>
> ---
>  drivers/staging/mausb/drivers/mausb_ioctl.c      | 373 +++++++++++++++++++
>  drivers/staging/mausb/drivers/mausb_ioctl.h      |  99 +++++
>  drivers/staging/mausb/drivers/mausb_msapi.c      | 110 ++++++
>  drivers/staging/mausb/drivers/mausb_msapi.h      | 232 ++++++++++++
>  drivers/staging/mausb/drivers/mausb_tcp-device.c | 147 ++++++++
>  drivers/staging/mausb/drivers/mausb_tcp-host.c   | 144 ++++++++
>  drivers/staging/mausb/drivers/mausb_tcp.c        | 446 +++++++++++++++++++++++
>  drivers/staging/mausb/drivers/mausb_tcp.h        | 129 +++++++
>  8 files changed, 1680 insertions(+)
>  create mode 100644 drivers/staging/mausb/drivers/mausb_ioctl.c
>  create mode 100644 drivers/staging/mausb/drivers/mausb_ioctl.h
>  create mode 100644 drivers/staging/mausb/drivers/mausb_msapi.c
>  create mode 100644 drivers/staging/mausb/drivers/mausb_msapi.h
>  create mode 100644 drivers/staging/mausb/drivers/mausb_tcp-device.c
>  create mode 100644 drivers/staging/mausb/drivers/mausb_tcp-host.c
>  create mode 100644 drivers/staging/mausb/drivers/mausb_tcp.c
>  create mode 100644 drivers/staging/mausb/drivers/mausb_tcp.h
> 
> diff --git a/drivers/staging/mausb/drivers/mausb_ioctl.c b/drivers/staging/mausb/drivers/mausb_ioctl.c
> new file mode 100644
> index 0000000..0c6c6bd
> --- /dev/null
> +++ b/drivers/staging/mausb/drivers/mausb_ioctl.c

[...]

> +/**
> + * This function is used to send a message to the user, in other words, the
> + * calling process. It basically copies the message one byte at a time.
> + *
> + * @msg:	The message to be sent to the user.
> + * @buffer:	The buffer in which to put the message. This buffer was given to
> + *	    	us to fill.
> + */
> +void to_user(char *msg, long unsigned int buffer)
> +{
> +	int length = (int)strlen(msg);
> +	int bytes = 0;
> +
> +	while (length && *msg) {
> +		put_user(*(msg++), (char *)buffer++);
> +		length--;
> +		bytes++;
> +	}

Any reason not to use copy_to_user here? That way, access_ok would only
need to be executed once for the whole range.

In any case, the return value of put_user/copy_to_user will need to be
checked.

> +
> +	put_user('\0', (char *)buffer + bytes);
> +}

[...]

> +/**
> + * This function is used to read from the device file. From the perspective of
> + * the device, the user is reading information from us. This is one of the
> + * entry points to this module.
> + *
> + * @file:	The device file. We don't use it directly, but it's passed in.
> + * @buffer:	The buffer to put the message into.
> + * @length:	The max length to be read.
> + * @offset:	File offset, which we don't use but it is passed in nontheless.
> + */
> +static ssize_t mausb_read(struct file *file, char __user *buffer,
> +		size_t length, loff_t *offset)
> +{
> +	int bytes_read = 0;
> +
> +	if (*message_point == 0)
> +		return 0;
> +	while (length && *message_point) {
> +		put_user(*(message_point++), buffer++);
> +		length--;
> +		bytes_read++;
> +	}

See comment for to_user above. Why not use copy_to_user?

> +
> +	return bytes_read;
> +}
> +
> +/**
> + * This function is used to write to the device file. From the perspective of
> + * the device, the user is writing information to us. This is one of the
> + * entry points to this module.
> + *
> + * @file:	The device file. We don't use it directly, but it's passed in.
> + * @buffer:	The buffer that holds the message.
> + * @length:	The length of the message to be written.
> + * @offset:	File offset, which we don't use but it is passed in nontheless.
> + */
> +static ssize_t mausb_write(struct file *file, const char __user *buffer,
> +		size_t length, loff_t *offset)
> +{
> +	int i;
> +
> +	for (i = 0; i < length && i < BUFFER; i++)
> +		get_user(message[i], buffer + i);

copy_from_user? In any case, check the return value here as well.

> +	message_point = message;
> +
> +	return i;
> +}
> +
> +/**
> + * This function is used to execute ioctl commands, determined by ioctl_func.
> + *
> + * @file:	  The device file. We don't use it directly, but it's passed in.
> + * @ioctl_func:	  This value determines which ioctl function will be used.
> + * @ioctl_buffer: This buffer is used to transfer data to/from the device.
> + */
> +long mausb_ioctl(struct file *file, unsigned int ioctl_func,
> +		unsigned long ioctl_buffer)
> +{

This entire function needs return value checks for put_user/get_user.

> +	int bytes = 0;
> +	char *msg, *ip_addr;
> +	char chr;
> +	int ret, value;
> +	unsigned long int  long_ret;
> +
> +	switch (ioctl_func) {
> +	case IOCTL_SET_MSG:
> +		msg = (char *)ioctl_buffer;
> +		get_user(chr, msg);
> +		for (bytes = 0; chr && bytes < BUFFER; bytes++, msg++)
> +			get_user(chr, msg);
> +		mausb_write(file, (char *)ioctl_buffer, bytes, 0);
> +		break;
> +	case IOCTL_GET_MSG:
> +		bytes = mausb_read(file, (char *)ioctl_buffer, 99, 0);
> +		put_user('\0', (char *)ioctl_buffer + bytes);
> +		break;
> +	case IOCTL_GET_VRSN:
> +		to_user(DRIVER_VERSION, ioctl_buffer);
> +		break;
> +	case IOCTL_GET_NAME:
> +		to_user(MAUSB_NAME, ioctl_buffer);
> +		break;
> +	case IOCTL_GADGET_C:
> +		ret = gadget_connection(1);
> +		if (ret >= 0)
> +			to_user("g_zero connect process complete", ioctl_buffer);
> +		else
> +			to_user("g_zero connect process failed", ioctl_buffer);
> +		break;
> +	case IOCTL_GADGET_D:
> +		ret = gadget_connection(0);
> +		if (ret >= 0)
> +			to_user("g_zero disconnect process complete",
> +				ioctl_buffer);
> +		else
> +			to_user("g_zero disconnect process failed",
> +				ioctl_buffer);
> +		break;
> +	case IOCTL_MED_DELAY:
> +		msg = (char *)ioctl_buffer;
> +		get_user(chr, msg);
> +		for (bytes = 0; chr && bytes < BUFFER; bytes++, msg++)
> +			get_user(chr, msg);
> +		mausb_write(file, (char *)ioctl_buffer, bytes, 0);
> +		if (kstrtoint((const char *)message_point, 0, &value) != 0) {
> +			/* TODO: handle error */
> +		}
> +		ret = set_medium_delay(value);
> +		sprintf(message_point, "DELAY VALUE: ms: %d, jiffies: %d\n",
> +			value, ret);
> +		to_user(message_point, ioctl_buffer);
> +		break;
> +	case IOCTL_SET_IP:
> +		msg = (char *)ioctl_buffer;
> +		get_user(chr, msg);
> +		for (bytes = 0; chr && bytes < BUFFER; bytes++, msg++)
> +			get_user(chr, msg);
> +		mausb_write(file, (char *)ioctl_buffer, bytes, 0);
> +		ip_addr = kmalloc(strlen(message_point)+1, GFP_KERNEL);
> +		if (!ip_addr) {
> +			printk(KERN_ALERT "Memory allocation failed!\n");

No need to print an error message for memory allocation failures,
kmalloc will take care of printing a more extensive message.

> +			break;
> +		}
> +		strcpy(ip_addr, message_point);
> +		sprintf(message_point, "Connecting to ...\nIP Address: %s\n",
> +			ip_addr);
> +		to_user(message_point, ioctl_buffer);
> +		kfree(ip_addr);
> +		break;
> +	case IOCTL_SET_PORT:
> +		msg = (char *)ioctl_buffer;
> +		get_user(chr, msg);
> +		for (bytes = 0; chr && bytes < BUFFER; bytes++, msg++)
> +			get_user(chr, msg);
> +		mausb_write(file, (char *)ioctl_buffer, bytes, 0);
> +		if (kstrtoint((const char *)message_point, 0, &value) != 0) {
> +			/* TODO: handle error */
> +		}
> +		ret = set_port_no(value);
> +		sprintf(message_point, "PORT NUMBER:%d, Returned %i\n", value,
> +			ret);
> +		to_user(message_point, ioctl_buffer);
> +		break;
> +	case IOCTL_SET_IP_DECIMAL:
> +		msg = (char *)ioctl_buffer;
> +		get_user(chr, msg);
> +		for (bytes = 0; chr && bytes < BUFFER; bytes++, msg++)
> +			get_user(chr, msg);
> +		mausb_write(file, (char *)ioctl_buffer, bytes, 0);
> +		if (kstrtoul((const char *)message_point, 0, &long_ret) != 0) {
> +			/* TODO: handle error */
> +		}
> +
> +		ret = set_ip_addr(long_ret);
> +		sprintf(message_point, "\nDecimal Value:%lx returned %i\n",
> +			long_ret, ret);
> +		to_user(message_point, ioctl_buffer);
> +		break;
> +	case IOCTL_SET_MAC:
> +		{
> +			u8 *mac = kmalloc(6, GFP_KERNEL);
> +			u8 *buf = (u8 __user *)ioctl_buffer;
> +			int i, ret;
> +			if (!mac) {
> +				pr_err("Memory allocation failed!\n");

See comment above. Since this is only a 6 byte buffer, it's probably
easier to just allocate it on the stack.

> +				break;
> +			}
> +			ret = copy_from_user(mac, buf, 6);
> +			if (ret) {
> +				pr_err("copy_from_user failed\n");
> +				kfree(mac);
> +				break;
> +			}
> +			for (i = 0; i < ETH_ALEN; i++)
> +				pr_info("mac[%d]=0x%x\n", i, mac[i]);
> +			ret = set_mac_addr(mac);
> +			if (ret)
> +				pr_err("unable to set MAC addr\n");
> +			kfree(mac);
> +			break;
> +		}
> +	}
> +
> +	return 0;

You probably want to return an error here in case anything went wrong
above or if the ioctl number is invalid.

> +}

[...]

> diff --git a/drivers/staging/mausb/drivers/mausb_msapi.c b/drivers/staging/mausb/drivers/mausb_msapi.c
> new file mode 100644
> index 0000000..9dd8fa5
> --- /dev/null
> +++ b/drivers/staging/mausb/drivers/mausb_msapi.c

[...]

> +/**
> + * Frees the given ms_pkt and associated buffers. This function is not
> + * necessary to use the API, but could be useful on both sides of the interface.
> + */
> +void mausb_free_ms_pkt(struct ms_pkt *pkt)
> +{
> +	int i;
> +	void *current_buf;
> +
> +	for (i = 0; i < pkt->nents; ++i) {
> +		current_buf = pkt[i].kvec->iov_base;
> +		if (NULL != current_buf) {
> +			kfree(current_buf);
> +		} else {
> +			printk(KERN_DEBUG "%s: cannot find buffer for "
> +				"kvec #%i in ms_pkt at %p\n",
> +				__func__, i, pkt->kvec);

pr_debug()

> +		}
> +	}
> +
> +	kfree(pkt);
> +
> +	return;
> +}
> +EXPORT_SYMBOL(mausb_free_ms_pkt);
> +
> +/**
> + * Calculates the total length of the data in a ms_pkt. Returns the total
> + * length of the data in the ms_pkt, or a negative errno.
> + */
> +int mausb_ms_pkt_length(struct ms_pkt *pkt)
> +{
> +	int i;
> +	int total_length = 0;
> +
> +	for (i = 0; i < pkt->nents; ++i)
> +		total_length += pkt[i].kvec->iov_len;
> +
> +	printk(KERN_DEBUG "%s: total *kvec length: %i\n", __func__,
> +		total_length);

pr_debug()

> +
> +	return total_length;
> +}

[...]

> diff --git a/drivers/staging/mausb/drivers/mausb_tcp-device.c b/drivers/staging/mausb/drivers/mausb_tcp-device.c
> new file mode 100644
> index 0000000..28978a0
> --- /dev/null
> +++ b/drivers/staging/mausb/drivers/mausb_tcp-device.c

[...]

> +static int mausb_tcp_device_connect(int on)
> +{
> +	int ret;
> +
> +	if (on && dev_tcp_medium->socket == NULL) {
> +		ret = sock_create(PF_INET, SOCK_STREAM, IPPROTO_TCP,
> +			&dev_tcp_medium->socket);
> +
> +		if (0 > ret) /* TODO: real errorchecking */
> +			return ret;
> +
> +		do {
> +			ret = kernel_connect(dev_tcp_medium->socket,
> +				&dev_tcp_medium->addr,
> +				sizeof(dev_tcp_medium->addr_in), O_RDWR);
> +			printk(KERN_DEBUG "%s:kernel_connect returned %i\n",
> +				__func__, ret);

pr_debug(), here any in several other places across the file...

> +
> +			if (0 > ret) {
> +				/* poll until we can connect sucessfully */
> +				msleep(MAUSB_TCP_DEV_CONNECT_POLL_MS);
> +			}
> +
> +
> +		} while (0 > ret);
> +
> +		/*spawn off a listening thread */
> +		dev_tcp_medium->recv_task = kthread_run(mausb_tcp_device_thread,
> +			NULL, "mausb_tcp_device_thread");

kthread_run might return an ERR_PTR which needs to be handled here.

> +	}
> +
> +	ret = dev_tcp_medium->ma_driver->device_connect(on);
> +
> +	return ret;
> +}

[...]

> diff --git a/drivers/staging/mausb/drivers/mausb_tcp-host.c b/drivers/staging/mausb/drivers/mausb_tcp-host.c
> new file mode 100644
> index 0000000..0302031
> --- /dev/null
> +++ b/drivers/staging/mausb/drivers/mausb_tcp-host.c

[...]

> +static int mausb_tcp_host_connect(int on)
> +{
> +	int ret;
> +
> +	if (on) {
> +		ret = kernel_bind(host_tcp_medium->setup_socket,
> +			&host_tcp_medium->addr,
> +			sizeof(host_tcp_medium->addr_in));

Missing error handling.

> +
> +		ret = kernel_listen(host_tcp_medium->setup_socket,
> +			MAUSB_TCP_MAX_NUM_CHANNELS);

Missing error handling.

> +		printk(KERN_DEBUG "%s: kernel_listen returned %i\n",
> +			__func__, ret);
> +
> +		ret = kernel_accept(host_tcp_medium->setup_socket,
> +				    &host_tcp_medium->socket, 0);
> +		printk(KERN_DEBUG "%s:kernel_accept returned %i\n",
> +			__func__, ret);
> +
> +		if (0 > ret)
> +			return ret;

kernel_accept might return negative values in case of an error, which
needs to be handled properly here.

> +
> +		if (NULL == host_tcp_medium->recv_task) {
> +			host_tcp_medium->recv_task = kthread_run(
> +				mausb_tcp_host_thread, NULL,
> +				"mausb_tcp_host_thread");
> +		}
> +	}
> +
> +	ret = host_tcp_medium->ma_driver->device_connect(on);
> +
> +	return ret;
> +}

[...]

> diff --git a/drivers/staging/mausb/drivers/mausb_tcp.c b/drivers/staging/mausb/drivers/mausb_tcp.c
> new file mode 100644
> index 0000000..291139e
> --- /dev/null
> +++ b/drivers/staging/mausb/drivers/mausb_tcp.c

[...]

> +int mausb_tcp_receive_loop(struct mausb_tcp_medium *tcp_medium)
> +{
> +	struct msghdr msg;
> +	struct ms_pkt *pkt;
> +	int data_rcvd = 0;
> +
> +	mausb_tcp_init_msg(&msg);
> +
> +	while (!kthread_should_stop()) {
> +
> +		pkt = kzalloc(sizeof(struct ms_pkt), GFP_KERNEL);

Missing return value check.

> +
> +		printk(KERN_DEBUG "%s: preparing to receive data\n",
> +			__func__);
> +
> +		data_rcvd = mausb_tcp_receive_packet(tcp_medium, &msg, pkt);
> +
> +		if (0 >= data_rcvd) {
> +			printk(KERN_DEBUG "%s: received no data (err %i)\n",
> +				__func__, data_rcvd);
> +
> +			sock_release(tcp_medium->socket);
> +			return data_rcvd;
> +
> +		} else {
> +			printk(KERN_DEBUG "%s: received %i bytes\n",
> +				__func__, data_rcvd);
> +		}
> +
> +		if (data_rcvd > 0) {
> +			mausb_transfer_packet(pkt,
> +				&tcp_medium->ma_driver->pkt_dmux);
> +		}
> +
> +		data_rcvd = 0;
> +	}
> +
> +	sock_release(tcp_medium->socket);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(mausb_tcp_receive_loop);

[...]

> +/**
> + * initialization function
> + */
> +struct mausb_tcp_medium *alloc_init_mausb_tcp_medium(
> +	enum mausb_tcp_module_type type)
> +{
> +	struct mausb_tcp_medium *medium;
> +	int ret;
> +
> +	printk(KERN_DEBUG "%s\n", __func__);
> +
> +	medium = kzalloc(sizeof(struct mausb_tcp_medium), GFP_KERNEL);
> +	if (NULL == medium) {
> +		printk(KERN_DEBUG "%s: memory allocation failed\n", __func__);

No error message needed, kmalloc will take care of it.

> +		return NULL;
> +	}
> +
> +	ret = sock_create(PF_INET, SOCK_STREAM, IPPROTO_TCP,
> +		&medium->setup_socket);

Error handling is missing.

> +
> +	medium->addr_in.sin_family = AF_INET;
> +	medium->addr_in.sin_port = htons(MAUSB_TCP_PORT_HOST);
> +
> +	spin_lock_init(&medium->lock);
> +
> +	tcp_medium[type] = medium;
> +
> +	return medium;
> +}
> +EXPORT_SYMBOL(alloc_init_mausb_tcp_medium);
