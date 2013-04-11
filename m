Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934682Ab3DKLwt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 07:52:49 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62804 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934544Ab3DKLws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 07:52:48 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alessandro Rubini <rubini@gnudd.com>
Subject: drivers/base/core.c: about device_find_child() function
Date: Thu, 11 Apr 2013 13:52:36 +0200
Message-ID: <3798489.yISokZugC2@harkonnen>
User-Agent: KMail/4.10.1 (Linux/3.8.5-201.fc18.x86_64; KDE/4.10.1; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm using the function device_find_child() [drivers/base/core.c] to retrieve 
a specific child of a device. I see that this function invokes 
get_device(child) when a child matches. I think that this function must 
return the reference to the child device without getting it.

The function's comment does not explicitly talk about an increment of the 
refcount of the device. So, "man 9 device_find_child" and various derivative 
webpages do not talk about this. The developer is not correctly informed 
about this function, unless (s)he looks at the source code.

I see that users of this function, usually, immediately do put_device() after 
the call to device_find_child(), so it is not expected that a 
device_find_child() does a get_device() on the found child.


   Immediately does put_device():
     drivers/firewire/core-device.c
     drivers/rpmsg/virtio_rpmsg_bus.c
     drivers/s390/kvm/kvm_virtio.c

   They effectively need a get_device():
     drivers/net/bluetooth/hci_sysfs.c
     drivers/net/dsa/dsa.c

   Maybe bugged because they do not do put_device():
     drivers/media/platform/s5p-mfc/s5p_mfc.c
     drivers/tty/serial/serial_core.c
   Probably I'm wrong on this and I do not find the associated put_device()


I should propose the following solution:

* Deprecate the device_find_child() function

* Create the following functions

   struct device *device_search_child(struct device *parent, void *data,
            int (*match)(struct device *dev, void *data))
   {
        struct klist_iter i;
        struct device *child;

        if (!parent)
                return NULL;

        klist_iter_init(&parent->p->klist_children, &i);
        while ((child = next_device(&i)))
                if (match(child, data))
                        break;
        klist_iter_exit(&i);
        return child;
  }

  struct device *get_device_child(struct device *parent, void *data,
            int (*match)(struct device *dev, void *data))
  {
        struct device *child;

        child = device_search_child(parent, data, match);
        if (child)
              get_device(child);
        return child;
  }


In this way, when a driver needs to find and get a child, it uses 
get_device_child() and , when it finishes its duty, it uses put_device(). In 
this situation, the developer use a pair of function with a symmetric names: 
get_device_child() and put_device().

If the driver do not need to get_device() on a child device, it simply does a 
device_search_child() to retrieve a pointer.

-- 
Federico Vaga
