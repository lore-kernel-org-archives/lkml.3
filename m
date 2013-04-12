Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab3DLMJY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 08:09:24 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:52152 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539Ab3DLMJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 08:09:23 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Cornelia Huck <cornelia.huck@de.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alessandro Rubini <rubini@gnudd.com>
Subject: Re: drivers/base/core.c: about device_find_child() function
Date: Fri, 12 Apr 2013 14:09:20 +0200
Message-ID: <2849474.HO2K6X9Bdi@harkonnen>
User-Agent: KMail/4.10.1 (Linux/3.8.5-201.fc18.x86_64; KDE/4.10.1; x86_64; ; )
In-Reply-To: <20130411134844.GA3489@kroah.com>
References: <3798489.yISokZugC2@harkonnen> <20130411134844.GA3489@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 April 2013 06:48:44 Greg Kroah-Hartman wrote:
> On Thu, Apr 11, 2013 at 01:52:36PM +0200, Federico Vaga wrote:
> > Hello,
> > 
> > I'm using the function device_find_child() [drivers/base/core.c] to
> > retrieve a specific child of a device. I see that this function invokes
> > get_device(child) when a child matches. I think that this function must
> > return the reference to the child device without getting it.
> 
> No, it should not, otherwise the device could "disappear" at any moment,
> and the caller who had the handle, would now have a stale pointer.

I know, I am aware of this, but sometimes it *seems* that it does not
matter. (argument later [**])

> > The function's comment does not explicitly talk about an increment of the
> > refcount of the device. So, "man 9 device_find_child" and various
> > derivative webpages do not talk about this. The developer is not
> > correctly informed about this function, unless (s)he looks at the source
> > code.
> 
> You are right, I would gladly take a patch adding that comment to the
> function, can you send me one?

Already sent.

> > I see that users of this function, usually, immediately do put_device()
> > after the call to device_find_child(), so it is not expected that a
> > device_find_child() does a get_device() on the found child.
> > 
> >    Immediately does put_device():
> >      drivers/firewire/core-device.c
> >      drivers/rpmsg/virtio_rpmsg_bus.c
> >      drivers/s390/kvm/kvm_virtio.c
> 
> That's correct.

[**] (argumentation based, obviously, on my limited understanding)

These drivers work like this:

	child = device_find_child(parent, data, match_function);
	if (child) {
		put_device(child);		
		<do something unrelated with child> 
	}

In these cases we do not need to get_device(). But we need to know if there 
is a child that match a rule. It can also "disapper" after the
put_device(child) but the driver continues on its way because it does not
use the child. For example virtio_rpmsg_bus.c:

	/* make sure a similar channel doesn't already exist */
	tmp = device_find_child(dev, chinfo, rpmsg_channel_match);
	if (tmp) {
		/* decrement the matched device's refcount back */
		put_device(tmp);
		dev_err(dev, "channel %s:%x:%x already exist\n",
				chinfo->name, chinfo->src, chinfo->dst);
		return NULL;
	}

In this case, it does not matter to get_device(), the driver is interested
only on the child existence, it does not use the child.
Maybe it is wrong a driver that works like this. I mean, why retrieve a
child if you do not want to use it? This can be implemented also with
the function device_for_each_child() and return an error if a channel already
exist (-EBUSY).

The same argumentation for firewire/core-device.c:

	revived_dev = device_find_child(card->device,
					device, lookup_existing_device);
	if (revived_dev) {
		put_device(revived_dev);
		fw_device_release(&device->device);

		return;
	}

This can be done with device_for_each_child() because it does not use the
the retrieved device. The function fw_device_release() can be done in the
function lookup_existing_device() when it finds the child. 

Also the driver s390/kvm/kvm_virtio.c:

		/* device already exists */
		dev = device_find_child(kvm_root, d, match_desc);
		if (dev) {
			/* XXX check for hotplug remove */
			put_device(dev);
			continue;
		}

Probably here, in a future patch XXX will be replaced with some code,
so it is correct to use device_find_child().

Now I'm thinking that device_for_each_child() is better in the above
cases. Am I wrong? Am I missing something? Which is the cleaner solution?


Anyway, my suggestion was more about the function name rather than its 
content (again, I am aware that the refcount must be increased if I
work on the retrieved child). Because the verb 'find' does not imply the
verb 'get', so, a function named device_find_child() should not do
get_device() because it may not obvious for the reader. I think that
the name should be something like get_device_child(), get_child_device(),
get_child(), and for symmetry the user will do put_device() on the
retrived child. But I understand that for legacy reason it could be
better to continue use device_find_child()


> >    Maybe bugged because they do not do put_device():
> >      drivers/media/platform/s5p-mfc/s5p_mfc.c

Fixed with commit 6e83e6e25eb49dc57a69b3f8ecc1e764c9775101. I did not see
it before, sorry.

> >      drivers/tty/serial/serial_core.c
> >    Probably I'm wrong on this and I do not find the associated 
put_device()
>
> I think the serial core is correct, but I'll audit it, the media one
> should be fixed as well.

I did not study serial_core, I was looking only for device_find_child().
Probably I'm missing something. Anyway, here what does not convice me:

(line number on next-20130412)
serial_core.c:2003
	tty_dev = device_find_child(uport->dev, &match, serial_match_port);
	if (!uport->suspended && device_may_wakeup(tty_dev)) {
		if (uport->irq_wake) {
			disable_irq_wake(uport->irq);
			uport->irq_wake = 0;
		}
+               put_device(tty_dev);
		mutex_unlock(&port->mutex);
		return 0;
	}
+	put_device(tty_dev);
	uport->suspended = 0; 

serial_core:1936
	tty_dev = device_find_child(uport->dev, &match, serial_match_port);
	if (device_may_wakeup(tty_dev)) {
		if (!enable_irq_wake(uport->irq))
			uport->irq_wake = 1;
		put_device(tty_dev);
		mutex_unlock(&port->mutex);
		return 0;
	}
+	put_device(tty_dev);


> >    They effectively need a get_device():
> >      drivers/net/bluetooth/hci_sysfs.c
> >      drivers/net/dsa/dsa.c
> 
> Please fix these.

Misunderstood. They are correct. I meant: in these cases is useful to have 
get_device() inside device_find_child() because they need to do something on 
child device before putting it

	child = device_find_child(parent, data, match_function);
	if (child) {
		<do something on child> 
		put_device(child);		
	}



In the previous email I forgot the following caller of device_find_child().
It is too complex for me to understand everything in few minutes; I just
looked in the file and around the function occurence.

arch/sparc/kernel/vio.c:335

static void vio_remove(struct mdesc_handle *hp, u64 node)
{
	struct device *dev;

	dev = device_find_child(&root_vdev->dev, (void *) node,
				vio_md_node_match);
	if (dev) {
		printk(KERN_INFO "VIO: Removing device %s\n", dev_name(dev));
		device_unregister(dev);
+               put_device(dev);
	}
}

Otherwise the refcount of dev after this function will be 1, but I suppose
that the expected result is 0 (remove)



Thank you very much for your patience :)

-- 
Federico Vaga
