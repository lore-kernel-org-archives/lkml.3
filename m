Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbaAIS4F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 13:56:05 -0500
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:23079
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756216AbaAISzz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 13:55:55 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH 1/1] Drivers: hv: Implement the file copy service
Thread-Topic: [PATCH 1/1] Drivers: hv: Implement the file copy service
Thread-Index: AQHPDMVZ9zrtMOoYp0KOm7oSIbZbR5p8AmiAgAC00tA=
Date: Thu, 9 Jan 2014 18:55:51 +0000
Message-ID: <540ecdf5cf6b47d79583f4f97788e3f0@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1389224915-8737-1-git-send-email-kys@microsoft.com>
 <20140109073949.GR30234@mwanda>
In-Reply-To: <20140109073949.GR30234@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.174.216]
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-forefront-prvs: 008663486A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(377454003)(24454002)(51704005)(199002)(189002)(13464003)(92566001)(81686001)(66066001)(54356001)(551934002)(51856001)(59766001)(77982001)(79102001)(54316002)(46102001)(15975445006)(56776001)(76482001)(53806001)(81816001)(80022001)(65816001)(63696002)(74876001)(85306002)(74316001)(90146001)(56816005)(33646001)(85852003)(74366001)(83072002)(87936001)(2656002)(74706001)(76576001)(76786001)(76796001)(87266001)(4396001)(49866001)(47736001)(47976001)(50986001)(81542001)(80976001)(15202345003)(19580405001)(19580395003)(83322001)(69226001)(74662001)(47446002)(81342001)(74502001)(31966008)(2004002)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB298;H:BY2PR03MB299.namprd03.prod.outlook.com;CLIP:131.107.174.216;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> Sent: Wednesday, January 08, 2014 11:40 PM
> To: KY Srinivasan
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com
> Subject: Re: [PATCH 1/1] Drivers: hv: Implement the file copy service
> 
> On Wed, Jan 08, 2014 at 03:48:35PM -0800, K. Y. Srinivasan wrote:
> > Implement the file copy service for Linux guests on Hyper-V. This permits the
> > host to copy a file (over VMBUS) into the guest. This facility is part of
> > "guest integration services" supported on the Windows platform.
> > Here is a link that provides additional details on this functionality:
> >
> > http://technet.microsoft.com/en-us/library/dn464282.aspx
> >
> >

Dan,

Thank you for your thorough review (as always). I will address the style issues in the next version.

> 
> Is there no way we could implement file copying in user space?

Unfortunately not. The use case is when the files need to be copied into the guest when there is
no other connectivity to the guest other than the vmbus.
 
> 
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > ---
> >  drivers/hv/Makefile        |    2 +-
> >  drivers/hv/hv_fcopy.c      |  451
> ++++++++++++++++++++++++++++++++++++++++++++
> >  drivers/hv/hv_util.c       |   10 +
> >  include/linux/hyperv.h     |   60 ++++++
> >  tools/hv/hv_fcopy_daemon.c |  171 +++++++++++++++++
> >  5 files changed, 693 insertions(+), 1 deletions(-)
> >  create mode 100644 drivers/hv/hv_fcopy.c
> >  create mode 100644 tools/hv/hv_fcopy_daemon.c
> >
> > diff --git a/drivers/hv/Makefile b/drivers/hv/Makefile
> > index 0a74b56..5e4dfa4 100644
> > --- a/drivers/hv/Makefile
> > +++ b/drivers/hv/Makefile
> > @@ -5,4 +5,4 @@ obj-$(CONFIG_HYPERV_BALLOON)	+= hv_balloon.o
> >  hv_vmbus-y := vmbus_drv.o \
> >  		 hv.o connection.o channel.o \
> >  		 channel_mgmt.o ring_buffer.o
> > -hv_utils-y := hv_util.o hv_kvp.o hv_snapshot.o
> > +hv_utils-y := hv_util.o hv_kvp.o hv_snapshot.o hv_fcopy.o
> > diff --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c
> > new file mode 100644
> > index 0000000..e44a112
> > --- /dev/null
> > +++ b/drivers/hv/hv_fcopy.c
> > @@ -0,0 +1,451 @@
> > +/*
> > + * An implementation of file copy service.
> > + *
> > + * Copyright (C) 2014, Microsoft, Inc.
> > + *
> > + * Author : K. Y. Srinivasan <ksrinivasan@novell.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify it
> > + * under the terms of the GNU General Public License version 2 as published
> > + * by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful, but
> > + * WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE
> or
> > + * NON INFRINGEMENT.  See the GNU General Public License for more
> > + * details.
> > + *
> > + */
> > +
> > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > +
> > +#include <linux/semaphore.h>
> > +#include <linux/fs.h>
> > +#include <linux/nls.h>
> > +#include <linux/workqueue.h>
> > +#include <linux/cdev.h>
> > +#include <linux/hyperv.h>
> > +#include <asm-generic/uaccess.h>
> 
> Use #include <asm/uaccess.h> for better security.
> 
> > +
> > +#define WIN8_SRV_MAJOR		1
> > +#define WIN8_SRV_MINOR		1
> > +#define WIN8_SRV_VERSION	(WIN8_SRV_MAJOR << 16 |
> WIN8_SRV_MINOR)
> > +
> > +
> > +
> 
> Extra blank line.
> 
> > +/*
> > + * Global state maintained for transaction that is being processed.
> > + * Note that only one transaction can be active at any point in time.
> > + *
> > + * This state is set when we receive a request from the host; we
> > + * cleanup this state when the transaction is completed - when we respond
> > + * to the host with our response.
> > + */
> > +
> > +static struct {
> > +	bool active; /* transaction status - active or not */
> > +	int recv_len; /* number of bytes received. */
> > +	struct hv_fcopy_hdr  *fcopy_msg; /* current message */
> > +	struct hv_start_fcopy  message; /*  sent to daemon */
> > +	struct vmbus_channel *recv_channel; /* chn we got the request */
> > +	u64 recv_req_id; /* request ID. */
> > +	void *fcopy_context; /* for the channel callback */
> > +	struct semaphore read_sema;
> 
> This is racy at the start.  read_sema is supposed to be locked until
> there is a file to be copied but it starts out unlocked and we unlock it
> again at the start of a transaction.

I am not sure I understand your concern. The initial value of the semaphore will
ensure the reader will block until there is something to be read. This is the case where the read from
the daemon comes in before there is an active transaction that needs processing. This semaphore is only
incremented when we want to send something to the daemon.

> 
> Sending multiple files is also racy.  The "active" flag is supposed to
> serialize it but flags are not locks and they are not atomic.  We can
> queue up one request in the fcopy_context pointer but it's written in
> a last added request overwrites the previous ones.  It could overwrite
> the current one as well if we got really unlucky.

The file copy protocol that the host implements is a synchronous protocol with
only one outstanding transaction at a time. So, if we need to copy multiple files,
we will only copy one file at a time and even there the protocol is synchronous. 
> 
> > +} fcopy_transaction;
> > +
> > +
> > +
> 
> Two extra newlines.
> 
> > +static dev_t fcopy_dev;
> > +static bool daemon_died = false;
> 
> daemon_died is a write only variable.
> 
> > +static bool opened; /* currently device opened */
> > +static struct task_struct *dtp; /* daemon task ptr */
> > +
> > +/*
> > + * Before we can accept copy messages from the host, we need
> > + * to handshake with the user level daemon. This state tracks
> > + * if we are in the handshake phase.
> > + */
> > +static bool in_hand_shake = true;
> > +
> > +static void fcopy_send_data(void);
> > +
> > +
> 
> Extra blank lines throughout...  Never use consecutive blank lines.
> 
> > +static void fcopy_respond_to_host(int error);
> > +static void fcopy_work_func(struct work_struct *dummy);
> > +
> > +static DECLARE_DELAYED_WORK(fcopy_work, fcopy_work_func);
> > +
> > +static u8 *recv_buffer;
> > +
> > +static void fcopy_work_func(struct work_struct *dummy)
> > +{
> > +	/*
> > +	 * If the timer fires, the user-mode component has not responded;
> > +	 * process the pending transaction.
> > +	 */
> > +	fcopy_respond_to_host(HV_E_FAIL);
> > +}
> > +
> > +static int fcopy_handle_handshake(int op)
> 
> This function takes an error code as a paramenter, it calls it an "op"
> and then doesn't use it.
> 
> > +{
> > +	int ret = 1;
> > +
> > +	pr_info("FCP: user-mode registering done.\n");
> > +	fcopy_transaction.active = false;
> > +	set_channel_read_state((struct vmbus_channel *)
> > +				fcopy_transaction.fcopy_context,
> > +				true);
> > +
> > +	if (fcopy_transaction.fcopy_context)
> > +		hv_fcopy_onchannelcallback(fcopy_transaction.fcopy_context);
> > +
> > +	in_hand_shake = false;
> > +	return ret;
> 
> Just do:
> 	return 1;
> 
> > +}
> > +
> > +static void fcopy_send_data(void)
> > +{
> > +	struct hv_start_fcopy *smsg_out = &fcopy_transaction.message;
> > +	int operation = fcopy_transaction.fcopy_msg->operation;
> > +	struct hv_start_fcopy *smsg_in;
> > +
> > +	/*
> > +	 * The  strings sent from the host are encoded in
> > +	 * in utf16; convert it to utf8 strings.
> > +	 * The host assures us that the utf16 strings will not exceed
> > +	 * the max lengths specified. We will however, reserve room
> > +	 * for the string terminating character - in the utf16s_utf8s()
> > +	 * function we limit the size of the buffer where the converted
> > +	 * string is placed to W_MAX_PATH -1 to gaurantee
> > +	 * that the strings can be properly terminated!
> > +	 */
> > +
> > +	switch (operation) {
> > +	case START_FILE_COPY:
> > +		memset(smsg_out, 0, sizeof(struct hv_start_fcopy));
> > +		smsg_out->hdr.operation = operation;
> > +		smsg_in = (struct hv_start_fcopy
> *)fcopy_transaction.fcopy_msg;
> > +
> > +		utf16s_to_utf8s((wchar_t *)smsg_in->file_name,
> W_MAX_PATH,
> > +				UTF16_LITTLE_ENDIAN,
> > +				(__u8 *)smsg_out->file_name, W_MAX_PATH -
> 1);
> > +
> > +		utf16s_to_utf8s((wchar_t *)smsg_in->path_name,
> W_MAX_PATH,
> > +				UTF16_LITTLE_ENDIAN,
> > +				(__u8 *)smsg_out->path_name, W_MAX_PATH -
> 1);
> > +
> > +		smsg_out->copy_flags = smsg_in->copy_flags;
> > +		smsg_out->file_size = smsg_in->file_size;
> > +		break;
> > +
> > +	default:
> > +		break;
> > +	}
> > +	up(&fcopy_transaction.read_sema);
> > +	return;
> > +}
> > +
> > +/*
> > + * Send a response back to the host.
> > + */
> > +
> > +static void
> > +fcopy_respond_to_host(int error)
> > +{
> > +	struct icmsg_hdr *icmsghdrp;
> > +	u32	buf_len;
> > +	struct vmbus_channel *channel;
> > +	u64	req_id;
> 
> Don't put tabs here between the type and the variable.  It is not
> consistent with the rest of the file.
> 
> > +
> > +	/*
> > +	 * Copy the global state for completing the transaction. Note that
> > +	 * only one transaction can be active at a time.
> > +	 */
> > +
> > +	buf_len = fcopy_transaction.recv_len;
> > +	channel = fcopy_transaction.recv_channel;
> > +	req_id = fcopy_transaction.recv_req_id;
> > +
> > +	fcopy_transaction.active = false;
> > +
> > +	icmsghdrp = (struct icmsg_hdr *)
> > +			&recv_buffer[sizeof(struct vmbuspipe_hdr)];
> > +
> > +	if (channel->onchannel_callback == NULL)
> > +		/*
> > +		 * We have raced with util driver being unloaded;
> > +		 * silently return.
> > +		 */
> > +		return;
> > +
> > +	icmsghdrp->status = error;
> > +	icmsghdrp->icflags = ICMSGHDRFLAG_TRANSACTION |
> ICMSGHDRFLAG_RESPONSE;
> > +	vmbus_sendpacket(channel, recv_buffer, buf_len, req_id,
> > +				VM_PKT_DATA_INBAND, 0);
> > +}
> > +
> > +
> > +void hv_fcopy_onchannelcallback(void *context)
> > +{
> > +	struct vmbus_channel *channel = context;
> > +	u32 recvlen;
> > +	u64 requestid;
> > +
> 
> Unwanted blank line in the middle of the declaration block.
> 
> > +	struct hv_fcopy_hdr *fcopy_msg;
> > +
> 
> and here.
> 
> > +	struct icmsg_hdr *icmsghdrp;
> > +	struct icmsg_negotiate *negop = NULL;
> > +	int util_fw_version;
> > +	int fcopy_srv_version;
> > +
> > +
> > +	if (fcopy_transaction.active) {
> > +		/*
> > +		 * We will defer processing this callback once
> > +		 * the current transaction is complete.
> > +		 */
> > +		fcopy_transaction.fcopy_context = context;
> > +		return;
> > +	}
> > +
> > +	vmbus_recvpacket(channel, recv_buffer, PAGE_SIZE * 2, &recvlen,
> > +			 &requestid);
> > +
> 
> Don't put a blank line between the call and the check.
> 
> > +	if (recvlen > 0) {
> 
> Flip this condition around and pull everything in one indent level so
> you don't hit the 80 character limit.
> 
> 	vmbus_recvpacket(channel, recv_buffer, PAGE_SIZE * 2, &recvlen,
> 			 &requestid);
> 	if (recvlen <= 0)
> 		return;
> 
> 	icmsghdrp = (struct icmsg_hdr *)&recv_buffer[sizeof(struct
> vmbuspipe_hdr)];
> 
> 
> > +		icmsghdrp = (struct icmsg_hdr *)&recv_buffer[
> > +			sizeof(struct vmbuspipe_hdr)];
> > +
> > +		if (icmsghdrp->icmsgtype == ICMSGTYPE_NEGOTIATE) {
> > +			util_fw_version = UTIL_FW_VERSION;
> > +			fcopy_srv_version = WIN8_SRV_VERSION;
> > +			vmbus_prep_negotiate_resp(icmsghdrp, negop,
> > +				recv_buffer, util_fw_version,
> > +				fcopy_srv_version);
> > +		} else {
> > +			fcopy_msg = (struct hv_fcopy_hdr *)&recv_buffer[
> > +				sizeof(struct vmbuspipe_hdr) +
> > +				sizeof(struct icmsg_hdr)];
> > +
> > +			/*
> > +			 * Stash away this global state for completing the
> > +			 * transaction; note transactions are serialized.
> > +			 */
> > +
> > +			fcopy_transaction.recv_len = recvlen;
> > +			fcopy_transaction.recv_channel = channel;
> > +			fcopy_transaction.recv_req_id = requestid;
> > +			fcopy_transaction.fcopy_msg = fcopy_msg;
> > +
> > +			/*
> > +			 * Send the information to the user-level daemon.
> > +			 */
> > +			fcopy_send_data();
> > +			schedule_delayed_work(&fcopy_work, 5*HZ);
> > +			return;
> > +		}
> > +
> > +		icmsghdrp->icflags = ICMSGHDRFLAG_TRANSACTION
> > +			| ICMSGHDRFLAG_RESPONSE;
> > +
> > +		vmbus_sendpacket(channel, recv_buffer,
> > +				       recvlen, requestid,
> > +				       VM_PKT_DATA_INBAND, 0);
> > +	}
> > +}
> > +
> > +/*
> > + * Create a char device that can support read/write for passing
> > + * the payload.
> > + */
> > +struct cdev fcopy_cdev;
> > +struct class *cl;
> > +struct device *sysfs_dev;
> > +
> > +static ssize_t fcopy_read(struct file *file, char __user *buf,
> > +		size_t count, loff_t *ppos)
> > +{
> > +	size_t remaining;
> > +	int ret;
> > +	void *src;
> > +	size_t copy_size;
> > +	int operation;
> > +
> > +	/*
> > +	 * Wait until there is something to be read.
> > +	 */
> > +	ret = down_interruptible(&fcopy_transaction.read_sema);
> > +	if (ret)
> > +		return -EINTR;
> > +
> > +	operation = fcopy_transaction.fcopy_msg->operation;
> > +
> > +	if (operation == START_FILE_COPY) {
> > +		src = &fcopy_transaction.message;
> > +		copy_size = sizeof(struct hv_start_fcopy);
> > +		if (count < copy_size)
> > +			return 0;
> > +	} else {
> > +		src = fcopy_transaction.fcopy_msg;
> > +		copy_size = sizeof(struct hv_do_fcopy);
> > +		if (count < copy_size)
> > +			return 0;
> > +	}
> > +
> > +	/*
> > +	 * Now copy the complete fcopy message to the user.
> > +	 */
> 
> Delete this obvious comment.
> 
> > +
> > +	remaining = copy_to_user(buf, src, copy_size);
> > +
> > +	if (remaining)
> > +		return -EFAULT;
> 
> Just do:
> 
> 	if (copy_to_user(buf, src, copy_size))
> 		return -EFAULT;
> 
> > +
> > +	return copy_size;
> > +}
> > +
> > +static ssize_t fcopy_write(struct file *file, const char __user *buf,
> > +			size_t count, loff_t *ppos)
> > +{
> > +	size_t copied;
> > +	int error = 0;
> > +
> > +	if (count != sizeof(int))
> > +		return 0;
> > +
> > +	copied = copy_from_user(&error, buf, sizeof(int));
> > +
> > +	if (copied)
> > +		return -EFAULT;
> 
> "copied" is a poor name because it is the opposite of what is stored in
> the variable.  Just do:
> 
> 	if (copy_from_user(&error, buf, sizeof(int)))
> 		return -EFAULT;
> 
> > +
> > +	if (in_hand_shake) {
> > +		fcopy_handle_handshake(error);
> > +		return 0;
> > +	}
> > +
> > +	/*
> > +	 * Complete the transaction by forwarding the result
> > +	 * to the host. But first, cancel the timeout.
> > +	 */
> > +	if (cancel_delayed_work_sync(&fcopy_work))
> > +		fcopy_respond_to_host(error);
> > +
> > +	return sizeof(int);
> > +}
> > +
> > +int fcopy_open(struct inode *inode, struct file *f)
> > +{
> > +	if (opened)
> > +		return -EBUSY;
> > +
> > +	/*
> > +	 * The daemon is alive; setup the state.
> > +	 */
> > +	daemon_died = false;
> > +	opened = true;
> > +	dtp = current;
> > +	return 0;
> > +}
> > +
> > +int fcopy_release(struct inode *inode, struct file *f)
> > +{
> > +	/*
> > +	 * The daemon has exited; reset the state.
> > +	 */
> > +	daemon_died = true;
> > +	in_hand_shake = true;
> > +	dtp = NULL;
> > +	opened = false;
> > +	return 0;
> > +}
> > +
> > +
> > +static const struct file_operations fcopy_fops = {
> > +	.read           = fcopy_read,
> > +	.write          = fcopy_write,
> > +	.release	= fcopy_release,
> > +	.open		= fcopy_open,
> > +};
> > +
> > +static int fcopy_dev_init(void)
> > +{
> > +	int result;
> > +
> > +	result = alloc_chrdev_region(&fcopy_dev, 1, 1, "hv_fcopy");
> > +
> 
> No blank line between function and error handling.
> 
> > +	if (result < 0) {
> > +		pr_err("Cannot get major number\n");
> > +		return result;
> > +	}
> > +
> > +	cl = class_create(THIS_MODULE, "chardev");
> > +	if (IS_ERR(cl)) {
> > +		pr_err("Error creating fcopy class.\n");
> > +		unregister_chrdev_region(fcopy_dev, 1);
> > +		return PTR_ERR(cl);
> 
> 		result = PTR_ERR(cl);
> 		goto err_unregister;
> 
> > +	}
> > +
> > +	sysfs_dev = device_create(cl, NULL, fcopy_dev, "%s", "hv_fcopy");
> > +	if (IS_ERR(sysfs_dev)) {
> > +		pr_err("Device creation failed\n");
> > +		class_destroy(cl);
> > +		unregister_chrdev_region(fcopy_dev, 1);
> > +		return  PTR_ERR(sysfs_dev);
> 
> 		result = PTR_ERR(sysfs_dev);
> 		goto err_destroy_class;
> 
> > +	}
> > +
> > +	cdev_init(&fcopy_cdev, &fcopy_fops);
> > +	fcopy_cdev.owner = THIS_MODULE;
> > +	fcopy_cdev.ops = &fcopy_fops;
> > +
> > +	result = cdev_add(&fcopy_cdev, fcopy_dev, 1);
> > +
> 
> No blank line in between function and error handling.
> 
> > +	if (result) {
> > +		pr_err("Cannot cdev_add\n");
> > +		goto dev_error;
> > +	}
> > +	return result;
> > +
> > +dev_error:
> 
> Name the location after the actual location.  So err_destroy_device:
> 
> > +	pr_err("Cannot add cdev; result: %d\n", result);
> 
> Don't put a useless printk here.  Really, putting a printk after every
> function call doesn't add anything worthwhile to the code.
> 
> > +	device_destroy(cl, fcopy_dev);
> 
> err_destroy_class:
> 
> > +	class_destroy(cl);
> 
> err_unregister:
> 
> > +	unregister_chrdev_region(fcopy_dev, 1);
> > +	return result;
> > +}
> > +
> > +static void fcopy_dev_deinit(void)
> > +{
> > +	/*
> > +	 * first kill the daemon.
> > +	 */
> > +	if (dtp != NULL)
> > +		send_sig(SIGKILL, dtp, 0);
> > +	opened = false;
> > +
> > +	device_destroy(cl, fcopy_dev);
> > +	class_destroy(cl);
> > +	cdev_del(&fcopy_cdev);
> > +	unregister_chrdev_region(fcopy_dev, 1);
> > +}
> > +
> > +int hv_fcopy_init(struct hv_util_service *srv)
> > +{
> > +	recv_buffer = srv->recv_buffer;
> > +
> > +	/*
> > +	 * When this driver loads, the user level daemon that
> > +	 * processes the host requests may not yet be running.
> > +	 * Defer processing channel callbacks until the daemon
> > +	 * has registered.
> > +	 */
> > +	fcopy_transaction.active = true;
> > +	sema_init(&fcopy_transaction.read_sema, 0);
> > +
> > +	return fcopy_dev_init();
> > +}
> > +
> > +void hv_fcopy_deinit(void)
> > +{
> > +
> 
> No blank line here.
> 
> > +	cancel_delayed_work_sync(&fcopy_work);
> > +	fcopy_dev_deinit();
> > +}
> > diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
> > index 62dfd246..efc5e83 100644
> > --- a/drivers/hv/hv_util.c
> > +++ b/drivers/hv/hv_util.c
> > @@ -82,6 +82,12 @@ static struct hv_util_service util_vss = {
> >  	.util_deinit = hv_vss_deinit,
> >  };
> >
> > +static struct hv_util_service util_fcopy = {
> > +	.util_cb = hv_fcopy_onchannelcallback,
> > +	.util_init = hv_fcopy_init,
> > +	.util_deinit = hv_fcopy_deinit,
> > +};
> > +
> >  static void perform_shutdown(struct work_struct *dummy)
> >  {
> >  	orderly_poweroff(true);
> > @@ -401,6 +407,10 @@ static const struct hv_vmbus_device_id id_table[] = {
> >  	{ HV_VSS_GUID,
> >  	  .driver_data = (unsigned long)&util_vss
> >  	},
> > +	/* File copy GUID */
> > +	{ HV_FCOPY_GUID,
> > +	  .driver_data = (unsigned long)&util_fcopy
> > +	},
> >  	{ },
> >  };
> >
> 
> regards,
> dan carpenter

Regards,

K. Y
