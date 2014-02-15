Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbaBOUGP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 15:06:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53293 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbaBOUGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 15:06:13 -0500
Date: Sat, 15 Feb 2014 12:07:34 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com
Subject: Re: [PATCH V6 1/1] Drivers: hv: Implement the file copy service
Message-ID: <20140215200734.GB30476@kroah.com>
References: <1392228843-19450-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392228843-19450-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 10:14:03AM -0800, K. Y. Srinivasan wrote:
> Implement the file copy service for Linux guests on Hyper-V. This permits the
> host to copy a file (over VMBUS) into the guest. This facility is part of
> "guest integration services" supported on the Windows platform.
> Here is a link that provides additional details on this functionality:
> 
> http://technet.microsoft.com/en-us/library/dn464282.aspx
> 
> In V1 version of the patch I have addressed comments from
> Olaf Hering <olaf@aepfle.de> and Dan Carpenter <dan.carpenter@oracle.com>
> 
> In V2 version of this patch I did some minor cleanup (making some globals
> static). In V4 version of the patch I have addressed all of Olaf's
> most recent set of comments/concerns.
> 
> In V5 version of the patch I had addressed Greg's most recent comments.
> I would like to thank Greg for suggesting that I use misc device; it has
> significantly simplified the code.
> 
> In this version of the patch I have cleaned up error message based on Olaf's
> comments. I have also rebased the patch based on the current tip.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/hv/Makefile         |    2 +-
>  drivers/hv/hv_fcopy.c       |  388 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/hv/hv_util.c        |   10 +
>  include/linux/hyperv.h      |   16 ++-
>  include/uapi/linux/hyperv.h |   46 +++++
>  tools/hv/hv_fcopy_daemon.c  |  195 ++++++++++++++++++++++
>  6 files changed, 655 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/hv/hv_fcopy.c
>  create mode 100644 tools/hv/hv_fcopy_daemon.c
> 
> diff --git a/drivers/hv/Makefile b/drivers/hv/Makefile
> index 0a74b56..5e4dfa4 100644
> --- a/drivers/hv/Makefile
> +++ b/drivers/hv/Makefile
> @@ -5,4 +5,4 @@ obj-$(CONFIG_HYPERV_BALLOON)	+= hv_balloon.o
>  hv_vmbus-y := vmbus_drv.o \
>  		 hv.o connection.o channel.o \
>  		 channel_mgmt.o ring_buffer.o
> -hv_utils-y := hv_util.o hv_kvp.o hv_snapshot.o
> +hv_utils-y := hv_util.o hv_kvp.o hv_snapshot.o hv_fcopy.o
> diff --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c
> new file mode 100644
> index 0000000..15cf35c
> --- /dev/null
> +++ b/drivers/hv/hv_fcopy.c
> @@ -0,0 +1,388 @@
> +/*
> + * An implementation of file copy service.
> + *
> + * Copyright (C) 2014, Microsoft, Inc.
> + *
> + * Author : K. Y. Srinivasan <ksrinivasan@novell.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published
> + * by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
> + * NON INFRINGEMENT.  See the GNU General Public License for more
> + * details.
> + *
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#include <linux/semaphore.h>
> +#include <linux/fs.h>
> +#include <linux/nls.h>
> +#include <linux/workqueue.h>
> +#include <linux/cdev.h>
> +#include <linux/hyperv.h>
> +#include <linux/sched.h>
> +#include <linux/uaccess.h>
> +#include <linux/miscdevice.h>
> +
> +#define WIN8_SRV_MAJOR		1
> +#define WIN8_SRV_MINOR		1
> +#define WIN8_SRV_VERSION	(WIN8_SRV_MAJOR << 16 | WIN8_SRV_MINOR)
> +
> +/*
> + * Global state maintained for transaction that is being processed.
> + * For a class of integration services, including the "file copy service",
> + * the specified protocol is a "request/response" protocol which means that
> + * there can only be single outstanding transaction from the host at any
> + * given point in time. We use this to simplify memory management in this
> + * driver - we cache and process only one message at a time.
> + *
> + * While the request/response protocol is guaranteed by the host, we further
> + * ensure this by serializing packet processing in this driver - we do not
> + * read additional packets from the VMBUs until the current packet is fully
> + * handled.
> + *
> + * The transaction "active" state is set when we receive a request from the
> + * host and we cleanup this state when the transaction is completed - when we
> + * respond to the host with our response. When the transaction active state is
> + * set, we defer handling incoming packets.
> + */
> +
> +static struct {
> +	bool active; /* transaction status - active or not */
> +	int recv_len; /* number of bytes received. */
> +	struct hv_fcopy_hdr  *fcopy_msg; /* current message */
> +	struct hv_start_fcopy  message; /*  sent to daemon */
> +	struct vmbus_channel *recv_channel; /* chn we got the request */
> +	u64 recv_req_id; /* request ID. */
> +	void *fcopy_context; /* for the channel callback */
> +	struct semaphore read_sema;
> +} fcopy_transaction;
> +
> +static bool opened; /* currently device opened */
> +
> +/*
> + * Before we can accept copy messages from the host, we need
> + * to handshake with the user level daemon. This state tracks
> + * if we are in the handshake phase.
> + */
> +static bool in_hand_shake = true;
> +static void fcopy_send_data(void);
> +static void fcopy_respond_to_host(int error);
> +static void fcopy_work_func(struct work_struct *dummy);
> +static DECLARE_DELAYED_WORK(fcopy_work, fcopy_work_func);
> +static u8 *recv_buffer;
> +
> +static void fcopy_work_func(struct work_struct *dummy)
> +{
> +	/*
> +	 * If the timer fires, the user-mode component has not responded;
> +	 * process the pending transaction.
> +	 */
> +	fcopy_respond_to_host(HV_E_FAIL);
> +}
> +
> +static int fcopy_handle_handshake(u32 version)
> +{
> +	switch (version) {
> +	case FCOPY_CURRENT_VERSION:
> +		break;
> +	default:
> +		/*
> +		 * For now we will fail the registration.
> +		 * If and when we have multiple versions to
> +		 * deal with, we will be backward compatible.
> +		 * We will add this code when needed.
> +		 */
> +		return -EINVAL;
> +	}
> +	pr_info("FCP: user-mode registering done. Daemon version: %d\n",
> +		version);

Why polute the syslog with this information?

> +	fcopy_transaction.active = false;
> +	if (fcopy_transaction.fcopy_context)
> +		hv_fcopy_onchannelcallback(fcopy_transaction.fcopy_context);
> +	in_hand_shake = false;
> +	return sizeof(int);

sizeof(int)?  Since when is that a valid return value, why are you
returning that?

Ok, I see the caller of this function, and why you are doing this, but
it's really not obvious at all, you should just return -ERROR or 0 and
then deal with the return value at the caller, as it's not obvious what
is going on at all here.

> +static void fcopy_send_data(void)
> +{
> +	struct hv_start_fcopy *smsg_out = &fcopy_transaction.message;
> +	int operation = fcopy_transaction.fcopy_msg->operation;
> +	struct hv_start_fcopy *smsg_in;
> +
> +	/*
> +	 * The  strings sent from the host are encoded in
> +	 * in utf16; convert it to utf8 strings.
> +	 * The host assures us that the utf16 strings will not exceed
> +	 * the max lengths specified. We will however, reserve room
> +	 * for the string terminating character - in the utf16s_utf8s()
> +	 * function we limit the size of the buffer where the converted
> +	 * string is placed to W_MAX_PATH -1 to guarantee
> +	 * that the strings can be properly terminated!
> +	 */
> +
> +	switch (operation) {
> +	case START_FILE_COPY:
> +		memset(smsg_out, 0, sizeof(struct hv_start_fcopy));
> +		smsg_out->hdr.operation = operation;
> +		smsg_in = (struct hv_start_fcopy *)fcopy_transaction.fcopy_msg;
> +
> +		utf16s_to_utf8s((wchar_t *)smsg_in->file_name, W_MAX_PATH,
> +				UTF16_LITTLE_ENDIAN,
> +				(__u8 *)smsg_out->file_name, W_MAX_PATH - 1);
> +
> +		utf16s_to_utf8s((wchar_t *)smsg_in->path_name, W_MAX_PATH,
> +				UTF16_LITTLE_ENDIAN,
> +				(__u8 *)smsg_out->path_name, W_MAX_PATH - 1);
> +
> +		smsg_out->copy_flags = smsg_in->copy_flags;
> +		smsg_out->file_size = smsg_in->file_size;
> +		break;
> +
> +	default:
> +		break;
> +	}
> +	up(&fcopy_transaction.read_sema);
> +	return;
> +}
> +
> +/*
> + * Send a response back to the host.
> + */
> +
> +static void
> +fcopy_respond_to_host(int error)
> +{
> +	struct icmsg_hdr *icmsghdrp;

What's with the "p"?  :)

> +	u32 buf_len;
> +	struct vmbus_channel *channel;
> +	u64 req_id;
> +
> +	/*
> +	 * Copy the global state for completing the transaction. Note that
> +	 * only one transaction can be active at a time.
> +	 */

Who enforces this "one at a time" restriction?

> +
> +	buf_len = fcopy_transaction.recv_len;
> +	channel = fcopy_transaction.recv_channel;
> +	req_id = fcopy_transaction.recv_req_id;
> +
> +	fcopy_transaction.active = false;
> +
> +	icmsghdrp = (struct icmsg_hdr *)
> +			&recv_buffer[sizeof(struct vmbuspipe_hdr)];
> +
> +	if (channel->onchannel_callback == NULL)
> +		/*
> +		 * We have raced with util driver being unloaded;
> +		 * silently return.
> +		 */
> +		return;
> +
> +	icmsghdrp->status = error;
> +	icmsghdrp->icflags = ICMSGHDRFLAG_TRANSACTION | ICMSGHDRFLAG_RESPONSE;
> +	vmbus_sendpacket(channel, recv_buffer, buf_len, req_id,
> +				VM_PKT_DATA_INBAND, 0);
> +}
> +
> +void hv_fcopy_onchannelcallback(void *context)
> +{
> +	struct vmbus_channel *channel = context;
> +	u32 recvlen;
> +	u64 requestid;
> +	struct hv_fcopy_hdr *fcopy_msg;
> +	struct icmsg_hdr *icmsghdrp;
> +	struct icmsg_negotiate *negop = NULL;
> +	int util_fw_version;
> +	int fcopy_srv_version;
> +
> +	if (fcopy_transaction.active) {
> +		/*
> +		 * We will defer processing this callback once
> +		 * the current transaction is complete.
> +		 */
> +		fcopy_transaction.fcopy_context = context;
> +		return;
> +	}
> +
> +	vmbus_recvpacket(channel, recv_buffer, PAGE_SIZE * 2, &recvlen,
> +			 &requestid);
> +	if (recvlen <= 0)
> +		return;
> +
> +	icmsghdrp = (struct icmsg_hdr *)&recv_buffer[
> +			sizeof(struct vmbuspipe_hdr)];
> +	if (icmsghdrp->icmsgtype == ICMSGTYPE_NEGOTIATE) {
> +		util_fw_version = UTIL_FW_VERSION;
> +		fcopy_srv_version = WIN8_SRV_VERSION;
> +		vmbus_prep_negotiate_resp(icmsghdrp, negop, recv_buffer,
> +				util_fw_version, fcopy_srv_version);
> +	} else {
> +		fcopy_msg = (struct hv_fcopy_hdr *)&recv_buffer[
> +				sizeof(struct vmbuspipe_hdr) +
> +				sizeof(struct icmsg_hdr)];
> +
> +		/*
> +		 * Stash away this global state for completing the
> +		 * transaction; note transactions are serialized.
> +		 */
> +
> +		fcopy_transaction.active = true;
> +		fcopy_transaction.recv_len = recvlen;
> +		fcopy_transaction.recv_channel = channel;
> +		fcopy_transaction.recv_req_id = requestid;
> +		fcopy_transaction.fcopy_msg = fcopy_msg;
> +
> +		/*
> +		 * Send the information to the user-level daemon.
> +		 */
> +		fcopy_send_data();
> +		schedule_delayed_work(&fcopy_work, 5*HZ);
> +		return;
> +	}
> +	icmsghdrp->icflags = ICMSGHDRFLAG_TRANSACTION | ICMSGHDRFLAG_RESPONSE;
> +	vmbus_sendpacket(channel, recv_buffer, recvlen, requestid,
> +			VM_PKT_DATA_INBAND, 0);
> +}
> +
> +/*
> + * Create a char device that can support read/write for passing
> + * the payload.
> + */
> +
> +static ssize_t fcopy_read(struct file *file, char __user *buf,
> +		size_t count, loff_t *ppos)
> +{
> +	void *src;
> +	size_t copy_size;
> +	int operation;
> +
> +	/*
> +	 * Wait until there is something to be read.
> +	 */
> +	if (down_interruptible(&fcopy_transaction.read_sema))
> +		return -EINTR;
> +	if (!opened)
> +		return -ENODEV;

How could this ever happen?

> +
> +	operation = fcopy_transaction.fcopy_msg->operation;
> +
> +	if (operation == START_FILE_COPY) {
> +		src = &fcopy_transaction.message;
> +		copy_size = sizeof(struct hv_start_fcopy);
> +		if (count < copy_size)
> +			return 0;
> +	} else {
> +		src = fcopy_transaction.fcopy_msg;
> +		copy_size = sizeof(struct hv_do_fcopy);
> +		if (count < copy_size)
> +			return 0;
> +	}
> +	if (copy_to_user(buf, src, copy_size))
> +		return -EFAULT;
> +
> +	return copy_size;
> +}
> +
> +static ssize_t fcopy_write(struct file *file, const char __user *buf,
> +			size_t count, loff_t *ppos)
> +{
> +	int response = 0;
> +
> +	if (count != sizeof(int))
> +		return -EINVAL;
> +
> +	if (copy_from_user(&response, buf, sizeof(int)))
> +		return -EFAULT;
> +
> +	if (in_hand_shake)
> +		return fcopy_handle_handshake(response);
> +
> +	/*
> +	 * Complete the transaction by forwarding the result
> +	 * to the host. But first, cancel the timeout.
> +	 */
> +	if (cancel_delayed_work_sync(&fcopy_work))
> +		fcopy_respond_to_host(response);
> +
> +	return sizeof(int);
> +}
> +
> +int fcopy_open(struct inode *inode, struct file *f)
> +{
> +	if (opened)
> +		return -EBUSY;

Why?  What does it matter if this is ever opened more than once (and can
it even?)

> +
> +	/*
> +	 * The daemon is alive; setup the state.
> +	 */
> +	opened = true;
> +	return 0;
> +}
> +
> +int fcopy_release(struct inode *inode, struct file *f)
> +{
> +	/*
> +	 * The daemon has exited; reset the state.
> +	 */
> +	in_hand_shake = true;
> +	opened = false;
> +	return 0;
> +}
> +
> +
> +static const struct file_operations fcopy_fops = {
> +	.read           = fcopy_read,
> +	.write          = fcopy_write,
> +	.release	= fcopy_release,
> +	.open		= fcopy_open,
> +};
> +
> +static struct miscdevice fcopy_misc = {
> +	.minor          = MISC_DYNAMIC_MINOR,
> +	.name           = "vmbus/hv_fcopy",

Why the subdir?  Does that work properly?

> +	.fops           = &fcopy_fops,
> +};
> +
> +static int fcopy_dev_init(void)
> +{
> +	return misc_register(&fcopy_misc);
> +}
> +
> +static void fcopy_dev_deinit(void)
> +{
> +	opened = false;

Is this really true here?  You are using "opened" to mean different
things it seems :(

> +	/*
> +	 * Signal the semaphore as the device is
> +	 * going away.
> +	 */
> +	up(&fcopy_transaction.read_sema);
> +	misc_deregister(&fcopy_misc);
> +}
> +
> +int hv_fcopy_init(struct hv_util_service *srv)
> +{
> +	recv_buffer = srv->recv_buffer;
> +
> +	/*
> +	 * When this driver loads, the user level daemon that
> +	 * processes the host requests may not yet be running.
> +	 * Defer processing channel callbacks until the daemon
> +	 * has registered.
> +	 */
> +	fcopy_transaction.active = true;
> +	sema_init(&fcopy_transaction.read_sema, 0);
> +
> +	return fcopy_dev_init();
> +}
> +
> +void hv_fcopy_deinit(void)
> +{
> +	cancel_delayed_work_sync(&fcopy_work);
> +	fcopy_dev_deinit();
> +}
> diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
> index 62dfd246..efc5e83 100644
> --- a/drivers/hv/hv_util.c
> +++ b/drivers/hv/hv_util.c
> @@ -82,6 +82,12 @@ static struct hv_util_service util_vss = {
>  	.util_deinit = hv_vss_deinit,
>  };
>  
> +static struct hv_util_service util_fcopy = {
> +	.util_cb = hv_fcopy_onchannelcallback,
> +	.util_init = hv_fcopy_init,
> +	.util_deinit = hv_fcopy_deinit,
> +};
> +
>  static void perform_shutdown(struct work_struct *dummy)
>  {
>  	orderly_poweroff(true);
> @@ -401,6 +407,10 @@ static const struct hv_vmbus_device_id id_table[] = {
>  	{ HV_VSS_GUID,
>  	  .driver_data = (unsigned long)&util_vss
>  	},
> +	/* File copy GUID */
> +	{ HV_FCOPY_GUID,
> +	  .driver_data = (unsigned long)&util_fcopy
> +	},
>  	{ },
>  };
>  
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index fb66fba..d1ae9e4 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -30,7 +30,6 @@
>  #include <linux/types.h>
>  #include <linux/scatterlist.h>
>  #include <linux/list.h>
> -#include <linux/uuid.h>
>  #include <linux/timer.h>
>  #include <linux/workqueue.h>
>  #include <linux/completion.h>
> @@ -1050,6 +1049,17 @@ void vmbus_driver_unregister(struct hv_driver *hv_driver);
>  		}
>  
>  /*
> + * Guest File Copy Service
> + * {34D14BE3-DEE4-41c8-9AE7-6B174977C192}
> + */
> +
> +#define HV_FCOPY_GUID \
> +	.guid = { \
> +			0xE3, 0x4B, 0xD1, 0x34, 0xE4, 0xDE, 0xC8, 0x41, \
> +			0x9A, 0xE7, 0x6B, 0x17, 0x49, 0x77, 0xC1, 0x92 \
> +		}
> +
> +/*
>   * Common header for Hyper-V ICs
>   */
>  
> @@ -1160,6 +1170,10 @@ void hv_vss_onchannelcallback(void *);
>  extern u64 hyperv_mmio_start;
>  extern u64 hyperv_mmio_size;
>  
> +int hv_fcopy_init(struct hv_util_service *);
> +void hv_fcopy_deinit(void);
> +void hv_fcopy_onchannelcallback(void *);

Why are these needed here and not in a local .h file in drivers/hv/?


thanks,

greg k-h
