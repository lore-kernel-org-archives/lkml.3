Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965222AbaCSQCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 12:02:49 -0400
Received: from postout2.mail.lrz.de ([129.187.255.138]:60990 "EHLO
	postout2.mail.lrz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933574AbaCSQCo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 12:02:44 -0400
X-Greylist: delayed 432 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Mar 2014 12:02:43 EDT
X-Spam-Flag: NO
X-Spam-Score: -0.199
From: Alejandra Morales <alejandra.morales@tum.de>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "christian@grothoff.org" <christian@grothoff.org>
Subject: Cryogenic: Enabling Power-Aware Applications on Linux
Thread-Topic: Cryogenic: Enabling Power-Aware Applications on Linux
Thread-Index: AQHPQ4ulQbG/gOY4B0O8SmsJmY0lIw==
Date: Wed, 19 Mar 2014 15:55:26 +0000
Message-ID: <9E3F9C2076C45D4783F09B90D5BE77CE1AEF7A@BADWLRZ-SWMBX13.ads.mwn.de>
Accept-Language: en-US, es-ES
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.155.5.52]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

Cryogenic is a Linux kernel module that allows to reduce energy consumption
by means of enabling cooperative clustering of I/O operations among the various
applications that make use of the same hardware device. In order to achieve this
target, Cryogenic provides an API that enables applications to schedule I/O operations
on SCSI and network devices at times where the impact the operations have on
energy consumption is small.

Internally, Cryogenic defers (or anticipates) the execution of non-urgent tasks so that
they coincide with the performance of I/O operations requested by other urgent
applications. Therefore, background tasks operate when the device is already active
and they do not need to wake it up by themselves. Moreover, tasks using the same
device are ideally executed in a clustered way and, as a result, the idle periods become
longer.

The actual moment when an I/O operation is performed is determined by a tolerance
window set by the application developer. The window is defined by a minimum delay
and a maximum timeout, which ensures that the task will not indefinitely wait for other
I/O operations and starve as a result. The delay and the timeout must be properly
calculated and set by the programmer, since they determine the application behavior
and they are the key factor to trade-off between the responsiveness of the application
and the energy it consumes.

The architecture of Cryogenic defines an API composed of:

a) A character device under /dev/cryogenic/ for each targeted device
b) Redefinition of the following system calls: open, close, ioctl, select

The character devices, managed by the system calls, determine whether a task can
proceed with its operation. The call to ioctl is used to set the delay and the timeout for
each task, and select allows or forbids the execution of an I/O operation at a given time.

In order to see how to use the Cryogenic API, we present the following example:

 1 main()
 2 {
 3     sock_fd = create_socket();
 4     while() {
 5         send(sock_fd);
 6         sleep(period);
 7     }
 8     close(sock_fd)
 9 }

This code is a simplified version of a UDP client that sends packets periodically.
In order to apply Cryogenic to this program, the following modifications are needed:

1) Open the character device corresponding to the active interface that is sending
the packets, which we need to know beforehand.
2) Within the main loop, and before the transmission, calculate the delay and the
timeout and pass it to Cryogenic by calling ioctl.
3) Call select before the transmission. The call to select will block until one of the
events that are meant to allow the resumption of the task happen: an I/O operation
requested by other applications or the expiration of the timeout that we set previously.
4) After the loop, close the file descriptor.

The resulting code looks like this:

 1 main()
 2 {
 3     sock_fd = create_socket();
 4     fd = open("/dev/cryogenic/wlan0");
 5     while() {
 6         times = calculate_delay_timeout(period);
 7         ioctl(fd, times);
 8         select(fd);
 9         send(sock_fd);
10     }
11     close(fd);
12     close(sock_fd);
13 }

The call to sleep() has been removed since it is assumed now that the delay and the
timeout completely determine the transmission time. Nevertheless, this is just an
example and programmers may still want to keep it depending on the behavior
they want to achieve.

Cryogenic is the result of my Master's Thesis, completed at the Technical University
of Munich under the supervision of Christian Grothoff. You can find more information
about Cryogenic at https://gnunet.org/cryogenic

I would like to submit the module as a patch now, do you have any suggestions to
do this properly? Also, I would really appreciate any feedback about the code, which
you can find at the end of the e-mail. Thank you.

Best regards,
Alejandra Morales

---

#include <linux/module.h>
#include <linux/cdev.h>
#include <linux/kallsyms.h>
#include <linux/netdevice.h>
#include <linux/poll.h>
#include <scsi/scsi_device.h>
#include <scsi/scsi_eh.h>

#define MAX_DEVICES 10
#define FREE_SLOT -1
#define DEVICE_NAME "cryogenic"
#define PM_IOC_MAGIC 'k'
#define SET_DELAY_AND_TIMEOUT _IOW(PM_IOC_MAGIC, 1, struct pm_times)
#define SCSI_TIMEOUT (2*HZ)
#define MAX_SERIAL_NUMBER_SIZE 21


struct pm_device {
	int minor;
	const char *name;
	struct cdev pm_cdev;
	struct device *dev;
	wait_queue_head_t event_queue;
	int unplugged;
	request_fn_proc *scsi_request_fn_address;
	unsigned char serial_number[MAX_SERIAL_NUMBER_SIZE];
	int scsi_cdev_open;
	struct net_device_ops my_ops;
	const struct net_device_ops *old_ops;
};


struct pm_private {
	int first_poll;
	unsigned long min_delay;
	struct timer_list timer;
	int timer_added;
	struct pm_device *pm_dev;
};


struct pm_times {
	unsigned long delay_msecs;
	unsigned long timeout_msecs;
};


static int major;
static int device_open;
static struct class *pm_class;
static struct pm_device *pm_devices;
static void *scsi_uevent_address;
static void *net_uevent_address;
static unsigned int scsi_inq_timeout = SCSI_TIMEOUT/HZ + 18;

static int pm_open(struct inode *, struct file *);
static int pm_release(struct inode *, struct file *);
static unsigned int pm_poll(struct file *, struct poll_table_struct *);
static long pm_ioctl(struct file *, unsigned int, unsigned long);

static int scsi_uevent_interceptor(struct device *dev,
				   struct kobj_uevent_env *env);
static int net_uevent_interceptor(struct device *dev,
				  struct kobj_uevent_env *env);
static void request_fn_interceptor(struct request_queue *);
static netdev_tx_t ndo_start_xmit_interceptor(struct sk_buff *,
					      struct net_device *);

static int create_device(struct pm_device *, struct device *, int);
static int remove_device(struct pm_device *);
static void clean_module(void);
static int assign_scsi_devices(struct device *, void *);
static int set_scsi_serial_number(struct scsi_device *, unsigned char *);
static int for_each_net_device(int *);
static void wake_up_tasks(wait_queue_head_t *);
static void timeout_wake_up(unsigned long);
static void enable_hotplugging(void);
static void disable_hotplugging(void);
static void plug_device(struct device *);
static void unplug_device(struct device *);
static int scsi_device_reconnected(struct device *);


MODULE_AUTHOR("A. Morales Ruiz");
MODULE_LICENSE("GPL");

extern struct bus_type scsi_bus_type;

static struct file_operations pm_fops = {
	.owner = THIS_MODULE,
	.open = pm_open,
	.release = pm_release,
	.poll = pm_poll,
	.unlocked_ioctl = pm_ioctl
};


/* *************************** init/exit methods *************************** */


/*
 * Gets a range of minor numbers [0..MAX_DEVICES]
 * Creates the device class
 * Allocates an array for MAX_DEVICES devices and marks all slots as free
 * Creates existing devices
 * Enables hotplugging
 * Marks the device as not open
 */
static int __init pm_init(void)
{
	dev_t tmp_dev;
	int err;
	int i;
	int n;
	
	tmp_dev = 0;
	err = alloc_chrdev_region(&tmp_dev, 0, MAX_DEVICES, DEVICE_NAME);
	if (err < 0) {
		printk(KERN_WARNING "Cryogenic could not be loaded [alloc_chrdev_region() failed].\n");
		return err;
	}
	
	major = MAJOR(tmp_dev);
	
	pm_class = class_create(THIS_MODULE, DEVICE_NAME);
	if (IS_ERR(pm_class)) {
		clean_module();
		printk(KERN_WARNING "Cryogenic could not be loaded [class_create() failed].\n");
		return PTR_ERR(pm_class);
	}
	
	pm_devices =
		(struct pm_device *)kzalloc(MAX_DEVICES*sizeof(struct pm_device),
					    GFP_KERNEL);
	if (pm_devices == NULL) {
		clean_module();
		printk(KERN_WARNING "Cryogenic could not be loaded [kzalloc() failed].\n");
		return -ENOMEM;
	}
	for (i = 0; i < MAX_DEVICES; ++i) {
		pm_devices[i].minor = FREE_SLOT;
		pm_devices[i].unplugged = FREE_SLOT;
	}
	
	n = 0;
	err = bus_for_each_dev(&scsi_bus_type,
			       NULL,
			       (void *) &n,
			       assign_scsi_devices);
	if (err < 0) {
		clean_module();
		printk(KERN_WARNING "Cryogenic could not be loaded [assign_scsi_devices() failed].\n");
		return err;
	}
	
	err = for_each_net_device(&n);
	if (err < 0) {
		clean_module();
		printk(KERN_WARNING "Cryogenic could not be loaded [for_each_net_device_() failed].\n");
		return err;
	}
	
	enable_hotplugging();
	
	device_open = 0;
	
	printk(KERN_INFO "Cryogenic was loaded [MAJOR number %d].\n", major);
	
	return 0;
	
}


/*
 * Cleans all the module data and disables hotplugging
 */
static void __exit pm_exit(void)
{
	if (!device_open) {
		clean_module();
		disable_hotplugging();
		printk(KERN_INFO "Cryogenic was unloaded.\n");
	}
	else printk(KERN_INFO "Cryogenic is in use.\n");
	
}


/* ************************ new system call methods ************************ */


/* 
 * Allocates and initialises private_data and increases the counter
 */
static int pm_open(struct inode *inode, struct file *filp)
{
	struct pm_private *priv;
	int minor = iminor(filp->f_dentry->d_inode);
	
	priv = kzalloc (sizeof (struct pm_private), GFP_KERNEL);
	if (priv == NULL) {
		printk(KERN_WARNING "Cryogenic: Device could not be opened [kzalloc() failed].\n");
		return -ENOMEM;
	}
	
	filp->private_data = priv;
	priv->pm_dev = &pm_devices[minor];
	priv->timer.function = timeout_wake_up;
	priv->timer.data = (unsigned long) priv;
	priv->timer_added = 0;
	init_timer(&priv->timer);
	
	if (scsi_is_sdev_device(pm_devices[minor].dev))
		pm_devices[minor].scsi_cdev_open++;
	device_open++;
	try_module_get(THIS_MODULE);
	
	return 0;
}


/*
 * Frees private_data and decreases the counter
 */
static int pm_release(struct inode *inode, struct file *filp)
{	
	struct pm_private *priv = filp->private_data;
	int minor = iminor(filp->f_dentry->d_inode);
	
	if (priv->timer_added) {
		del_timer_sync(&priv->timer);
		priv->timer_added = 0;
	}
	kfree(priv);
	
	/* We check if it is a scsi device this way because
	 * if the device has been unplugged, the call to
	 * scsi_is_sdev_device may return NULL */
	if (pm_devices[minor].scsi_request_fn_address != NULL) {
		pm_devices[minor].scsi_cdev_open--;
		if (pm_devices[minor].unplugged == 1 &&
		    pm_devices[minor].scsi_cdev_open == 0) {
			remove_device(&pm_devices[minor]);
			printk(KERN_INFO "Cryogenic: Device %s was removed.\n",
					pm_devices[minor].serial_number);
			pm_devices[minor].minor = FREE_SLOT;
			pm_devices[minor].unplugged = FREE_SLOT;
		}
	}
	device_open--;
	module_put(THIS_MODULE);
	
	return 0;
}


/*
 * Returns whether a device can be used (> 0) or not (0)
 * In case it can't be used, the call is queued and a timer is added
 */
static unsigned int pm_poll(struct file *filp, struct poll_table_struct *table)
{
	struct pm_private *priv = filp->private_data;
	int minor = iminor(filp->f_dentry->d_inode);
	
	/* 
	 * unplugged == 1 -> return that poll is ready, delegate error handling
	 * 
	 * first_poll == 0 -> timeout expired or call from interceptor
	 * otherwise -> first time we call poll
	 */
	if (pm_devices[minor].unplugged == 1 ||
	    ((jiffies >= priv->min_delay) && !priv->first_poll)) {
		if (priv->timer_added) {
			del_timer_sync(&priv->timer);
			priv->timer_added = 0;
		}
		
		return POLLIN | POLLRDNORM | POLLOUT | POLLWRNORM;
	}
	
	priv->first_poll = 0;
	poll_wait(filp, &pm_devices[minor].event_queue, table);
	
	/* If timeout == MAX, do NOT add_timer */
	if (!priv->timer_added && priv->timer.expires > jiffies) {
		add_timer(&priv->timer);
		priv->timer_added = 1;
	}
	
	return 0;
}


/*
 * Sets the min delay and the maximum timeout
 * We assume time is given in milliseconds
 * jiffies = msec*HZ/1000
 */
static long pm_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
{
	unsigned long j;
	struct pm_times *times;
	struct pm_private *priv = filp->private_data;
	priv->first_poll = 1;
	if (priv->timer_added) {
		del_timer_sync(&priv->timer);
		priv->timer_added = 0;
	}
	switch(cmd) {
	case SET_DELAY_AND_TIMEOUT:
		times = kzalloc (sizeof (struct pm_times), GFP_KERNEL);
		if (copy_from_user(times, (void *) arg, sizeof(struct pm_times)) != 0)
			return -EFAULT;
		if (times->delay_msecs > times->timeout_msecs)
			return -EINVAL;
		j = jiffies;
		priv->min_delay = j + (times->delay_msecs * HZ)/1000;
		priv->timer.expires = j + (times->timeout_msecs * HZ)/1000;
		kfree(times);
		break;
	default:
		return -ENOTTY;
	}
	
	return 0;
}


/* **************************** interceptors ******************************* */


/*
 * Dynamically adds or removes scsi devices when these are plugged/unplugged
 */
static int scsi_uevent_interceptor(struct device *dev,
				   struct kobj_uevent_env *env)
{
	typedef int uevent(struct device *dev, struct kobj_uevent_env *env);
	uevent *original_uevent;
	int res;
	
	if (scsi_is_sdev_device(dev) &&
	    !strncmp(env->envp[0], "ACTION=add", 10)) {
			plug_device(dev);
		
	}
	else if (scsi_is_sdev_device(dev) &&
		 !strncmp(env->envp[0], "ACTION=remove", 13))
		unplug_device(dev);
	
	original_uevent = (uevent *) scsi_uevent_address;
	res = original_uevent(dev, env);
	return res;
}


/*
 * Dynamically adds or removes network devices when these are plugged/unplugged
 */
static int net_uevent_interceptor(struct device *dev,
				  struct kobj_uevent_env *env)
{
	typedef int uevent(struct device *dev, struct kobj_uevent_env *env);
	uevent *original_uevent;
	int res;
	
	if (env->envp_idx > 0 && !strncmp(env->envp[0], "ACTION=add", 10))
		plug_device(dev);
	else if (env->envp_idx > 0 &&
		 !strncmp(env->envp[0], "ACTION=remove", 13))
		unplug_device(dev);
	
	original_uevent = (uevent *) net_uevent_address;
	res = original_uevent(dev, env);
	return res;
}


/*
 * Intercepts the call to the request_fn method for every disk and calls its
 * original method
 */
static void request_fn_interceptor(struct request_queue *q)
{
	int i;
	request_fn_proc *address = NULL;
	typedef void request(struct request_queue *);
	request *original_request;
	
	for (i = 0; (i < MAX_DEVICES) && address == NULL; ++i) {
		if (pm_devices[i].minor != FREE_SLOT) {
			if (scsi_is_sdev_device(pm_devices[i].dev)) {
				struct scsi_device *sdev =
					to_scsi_device(pm_devices[i].dev);
				if (sdev->request_queue == q)
					address =
						pm_devices[i].scsi_request_fn_address;
			}
		}
	}
	
	if (address == NULL)
		printk(KERN_WARNING "Cryogenic: Requested device was unplugged.");
	else {
		--i;
		wake_up_tasks(&pm_devices[i].event_queue);
		original_request = (request *) address;
		original_request(q);
	}
}


/*
 * Intercepts the call to the ndo_start_xmit method for every network device
 * and calls its original method
 */
static netdev_tx_t ndo_start_xmit_interceptor(struct sk_buff *skb,
					      struct net_device *dev)
{
	void *address = NULL;
	typedef netdev_tx_t xmit(struct sk_buff *skb, struct net_device *dev);
	xmit *original_xmit;
	
	int i;
	for (i = 0; (i < MAX_DEVICES) && address == NULL; ++i) {
		if (pm_devices[i].minor != FREE_SLOT) {
			if (!scsi_is_sdev_device(pm_devices[i].dev)) {
				struct net_device *netdev =
					to_net_dev(pm_devices[i].dev);
				if (netdev == dev) {
					address =
						pm_devices[i].old_ops->ndo_start_xmit;
				}
			}
		}
	}
	
	if (address == NULL) {
		printk(KERN_WARNING "Cryogenic: Requested device was unplugged.");
		return NETDEV_TX_BUSY;
	}
	--i;
	wake_up_tasks(&pm_devices[i].event_queue);
	original_xmit = (xmit *) address;
	return original_xmit(skb, dev);
}


/* ***************************** other methods ***************************** */


/*
 * Sets fields of the pm_device struct and creates a new character device
 */
static int create_device(struct pm_device *pm_dev,
			 struct device *dev, int minor)
{
	int err;
	struct device *device;
	const char *name;
	dev_t current_dev = MKDEV(major, minor);
	
	pm_dev->minor = minor;
	pm_dev->name = dev_name(dev);
	pm_dev->unplugged = 0;
	pm_dev->scsi_cdev_open = 0;
	
	if (scsi_is_sdev_device(dev)) {
		struct scsi_device *sdev = to_scsi_device(dev);
		if (set_scsi_serial_number(sdev, pm_dev->serial_number) == 1)
			name = pm_dev->serial_number;
		else {
			/* The scsi inquiry that gets the serial number of the
			 * device may sometimes fail. In this case, we name the
			 * char device after the scsi address and set the
			 * serial_number field to the null character */
			name = pm_dev->name;
			pm_dev->serial_number[0] = '\0';
		}
	}
	else
		name = pm_dev->name;
	
	cdev_init(&pm_dev->pm_cdev, &pm_fops);
	pm_dev->pm_cdev.owner = THIS_MODULE;
	err = cdev_add(&(pm_dev->pm_cdev), current_dev, 1);
	if (err < 0) {
		printk(KERN_WARNING "Cryogenic: Error [cdev_add() failed].\n");
		return err;
	}
	
	device = device_create(pm_class, NULL, current_dev, NULL, "cryogenic/%s",
			       name);
	if (IS_ERR(device)) {
		cdev_del(&(pm_dev->pm_cdev));
		printk(KERN_WARNING "Cryogenic: Error [device_create() failed].\n");
		return PTR_ERR(device);
	}
	
	pm_dev->dev = dev;
	
	/* Initialise event wait queue */
	init_waitqueue_head(&pm_dev->event_queue);
	
	if (scsi_is_sdev_device(dev)) {
		/* Save the original request_fn address and set
		 * the interceptor address */
		struct scsi_device *sdev = to_scsi_device(dev);
		pm_dev->scsi_request_fn_address =
			sdev->request_queue->request_fn;
		sdev->request_queue->request_fn = &request_fn_interceptor;
		/* Unused fields */
		memset(&pm_dev->my_ops, 0, sizeof(struct net_device_ops));
		pm_dev->old_ops = NULL;
	}
	else {
		/* Save the original ndo_start_xmit address and
		 * set the interceptor address */
		struct net_device *netdev = to_net_dev(dev);
		const struct net_device_ops *ops = netdev->netdev_ops;
		pm_dev->old_ops = ops;
		pm_dev->my_ops = *ops;
		pm_dev->my_ops.ndo_start_xmit = &ndo_start_xmit_interceptor;
		netdev->netdev_ops = &pm_dev->my_ops;
		/* Unused field */
		pm_dev->scsi_request_fn_address = NULL;
	}
	
	return 0;
}


/*
 * If the device can be removed: restores addresses, wakes ups waiting tasks
 * and destroys the character device. Returns 1.
 * Otherwise, wakes up waiting tasks and returns 0.
 */
static int remove_device(struct pm_device *pm_dev)
{
	/* We check if it is a scsi device this way because
	 * if the device has been unplugged, the call to
	 * scsi_is_sdev_device may return NULL */
	if (pm_dev->scsi_request_fn_address != NULL) {
		/* pm_dev->serial_number[0] == '\0' means that the char device
		 * is named after the scsi address and it is destroyed even
		 * though it is open */
		if (pm_dev->scsi_cdev_open > 0 &&
		    pm_dev->serial_number[0] != '\0') {
			wake_up_tasks(&pm_dev->event_queue);
			return 0;
		}
		/* If device has not been unplugged, restore its address */
		if (pm_dev->unplugged == 0) {
			struct scsi_device *sdev = to_scsi_device(pm_dev->dev);
			sdev->request_queue->request_fn =
				pm_dev->scsi_request_fn_address;
		}
		pm_dev->scsi_request_fn_address = NULL;
	}
	else {
		/* If device has not been unplugged, restore its address */
		if (pm_dev->unplugged == 0) {
			struct net_device *netdev = to_net_dev(pm_dev->dev);
			netdev->netdev_ops = pm_dev->old_ops;
		}
		memset(&pm_dev->my_ops, 0, sizeof(struct net_device_ops));
		pm_dev->old_ops = NULL;
	}
	
	wake_up_tasks(&pm_dev->event_queue);
	
	device_destroy(pm_class, MKDEV(major, pm_dev->minor));
	cdev_del(&(pm_dev->pm_cdev));
	
	return 1;
}


/*
 * Cleans data before unloading the module
 */
static void clean_module()
{
	int i;
	
	if (pm_devices) {
		for (i = 0; i < MAX_DEVICES; ++i) {
			if (pm_devices[i].minor != FREE_SLOT)
				remove_device(&pm_devices[i]);
		}
		kfree(pm_devices);
	}
	
	if (pm_class)
		class_destroy(pm_class);
	
	unregister_chrdev_region(MKDEV(major, 0), MAX_DEVICES);
}


/*
 * Creates scsi devices
 */
static int assign_scsi_devices(struct device *dev, void *d)
{
	int *idx = ((int*) d);
	
	if (scsi_is_sdev_device(dev) && !strcmp(dev->driver->name, "sd")) {
		
		if (*idx < MAX_DEVICES) {
			int err;
			struct pm_device *pm_dev = &pm_devices[*idx];
			err = create_device(pm_dev, dev, *idx);
			if (err < 0) {
				pm_dev->minor = FREE_SLOT;
				return err;
			}
			++(*idx);
		}
		else {
			struct scsi_device *sdev = to_scsi_device(dev);
			unsigned char buf[MAX_SERIAL_NUMBER_SIZE];
			set_scsi_serial_number(sdev, buf);
			printk(KERN_WARNING "Cryogenic: Device %s could not be created [No available slot].\n", buf);
		}
	}
	
	return 0;
}


/*
 * Sets the scsi device serial number on buf
 */
static int set_scsi_serial_number(struct scsi_device *sdev, unsigned char *buf)
{
	struct scsi_sense_hdr sshdr;
	unsigned char inq_result[255];
	int result, resid;
	unsigned char scsi_cmd[16];
	int length = 255;
	int i;
	int j;
	int k;
	
	scsi_cmd[0] = INQUIRY;
	scsi_cmd[1] = 0x01;
	scsi_cmd[2] = 0x80;
	scsi_cmd[4] = length;
	
	for (k = 0; k < 3; ++k) {
		result = scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
					  inq_result,  length, &sshdr,
					  HZ / 2 + HZ * scsi_inq_timeout,
					  3, &resid);
		if (!result) {
			j = 0;
			for (i = 0; i < MAX_SERIAL_NUMBER_SIZE-1; ++i) {
				if (inq_result[i+4] > 32) {
					buf[j] = inq_result[i+4];
					++j;
				}
			}
			buf[j] = '\0';
			return 1;
		}
	}
	return 0;
}


/*
 * Creates net devices
 */
static int for_each_net_device(int *n)
{
	struct net_device *netdev = first_net_device(&init_net);
	
	while (netdev) {
		const char *name = netdev->name;
		
		if (strcmp(name, "lo") != 0) {
			if (*n < MAX_DEVICES) {
				int err;
				struct pm_device *pm_dev = &pm_devices[*n];
				err = create_device(pm_dev, &netdev->dev, *n);
				if (err < 0) {
					pm_dev->minor = FREE_SLOT;
					return err;
				}
				++(*n);
			}
			else
				printk(KERN_WARNING "Cryogenic: Device %s could not be created [No available slot].\n", name);
		}
		netdev = next_net_device(netdev);
	}
	
	return 0;
}


/*
 * Checks if queue is active and wakes up processes
 */
static void wake_up_tasks(wait_queue_head_t *queue)
{
	if (waitqueue_active(queue))
		wake_up(queue);
}


/*
 * Function called when the timer expires
 * Wakes up devices that were waiting on the event_queue
 */
static void timeout_wake_up(unsigned long private_data)
{
	struct pm_private *priv = (struct pm_private *) private_data;
	wake_up_tasks(&priv->pm_dev->event_queue);
}


/*
 * Set the interceptors addresses to the scsi bus and class net uvent
 * functions 
 */
static void enable_hotplugging(void)
{
	struct net_device *netdev;
	struct class *netclass;
	
	scsi_uevent_address = scsi_bus_type.uevent;
	scsi_bus_type.uevent = &scsi_uevent_interceptor;
	
	netdev = first_net_device(&init_net);
	netclass = netdev->dev.class;
	net_uevent_address = netclass->dev_uevent;
	netclass->dev_uevent = &net_uevent_interceptor;
}


/*
 * Set the original addresses to the scsi bus and net class uevent
 * functions
 */
static void disable_hotplugging(void)
{
	struct net_device *netdev = first_net_device(&init_net);
	struct class *netclass;
	
	scsi_bus_type.uevent = scsi_uevent_address;
	netdev = first_net_device(&init_net);
	netclass = netdev->dev.class;
	netclass->dev_uevent = net_uevent_address;
}


/*
 * Adds a device that has been hotplugged (but not reconnected)
 */
static void plug_device(struct device *dev)
{
	int i;
	int err;
	int free_slot = 0;
	
	/* Only network devices or scsi devices
	 * that have not been reconnected */
	if (!scsi_is_sdev_device(dev) || scsi_device_reconnected(dev) == 0) {
		for (i = 0; i < MAX_DEVICES && !free_slot; ++i) {
			if (pm_devices[i].minor == FREE_SLOT) {
				struct pm_device *pm_dev = &pm_devices[i];
				err = create_device(pm_dev, dev, i);
				if (err < 0) {
					printk(KERN_WARNING "Cryogenic: Device could not be added [create_device() failed].\n");
					pm_dev->minor = FREE_SLOT;
				}
				else {
					const char *name;
					if (scsi_is_sdev_device(dev) &&
					    pm_dev->serial_number[0] != '\0')
						name = pm_dev->serial_number;
					else
						name = pm_dev->name;
					printk(KERN_INFO "Cryogenic: New device %s was added.\n",
					       name);
				}
				free_slot = 1;
			}
		}
		if (!free_slot)
			printk(KERN_INFO "Cryogenic: Device could not be added [No available slot].\n");
	}
}


/*
 * Removes a device that has been unplugged
 */
static void unplug_device(struct device *dev)
{
	int i;
	int device_found = 0;
	
	for (i = 0; i < MAX_DEVICES && !device_found; ++i) {
		if ((pm_devices[i].minor != FREE_SLOT) &&
		     !strcmp(pm_devices[i].name, dev_name(dev))) {
			pm_devices[i].unplugged = 1;
			if (remove_device(&pm_devices[i])) {
				const char *name;
				if (scsi_is_sdev_device(dev))
					name = pm_devices[i].serial_number;
				else
					name = pm_devices[i].name;
				printk(KERN_INFO "Cryogenic: Device %s was removed.\n",
				       name);
				pm_devices[i].minor = FREE_SLOT;
				pm_devices[i].unplugged = FREE_SLOT;
			}
			else
				printk(KERN_INFO "Cryogenic: Device %s was unplugged but not removed because it is being used.\n", 
				       pm_devices[i].serial_number);
			device_found = 1;
		}
	}
}


/*
 * Checks if a scsi device has been reconnected. If so, resets
 * the necessary fields and returns 1. Otherwise, returns 0.
 */
static int scsi_device_reconnected(struct device *dev)
{
	int i;
	char tmp_serial[MAX_SERIAL_NUMBER_SIZE];
	
	struct scsi_device *sdev = to_scsi_device(dev);
	set_scsi_serial_number(sdev, tmp_serial);
	
	for (i = 0; i < MAX_DEVICES; ++i) {
		if (pm_devices[i].unplugged == 1 &&
		    !strcmp(tmp_serial, pm_devices[i].serial_number)) {
			struct scsi_device *sdev = to_scsi_device(dev);
			pm_devices[i].unplugged = 0;
			/* The following fields may change after the
			 * reconnection. Thus, we must reset them */
			pm_devices[i].name = dev_name(dev);
			pm_devices[i].dev = dev;
			pm_devices[i].scsi_request_fn_address =
				sdev->request_queue->request_fn;
			sdev->request_queue->request_fn = &request_fn_interceptor;
			printk(KERN_INFO "Cryogenic: Device %s was reconnected.\n", 
			       pm_devices[i].serial_number);
			return 1;
		}
	}
	return 0;
}


module_init(pm_init);
module_exit(pm_exit);