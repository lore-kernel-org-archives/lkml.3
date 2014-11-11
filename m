Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668AbaKKQ0A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 11:26:00 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:57034 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaKKQZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 11:25:58 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 11 Nov 2014 17:16:44 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: David Ramos <daramos@stanford.edu>, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH RFC v1b] firewire: cdev: prevent kernel stack leaking into
 ioctl arguments
Message-ID: <20141111171644.7f6b17c7@kant>
In-Reply-To: <20141111171356.2fc62440@kant>
References: <55D28623-C1C7-47D2-9638-0B8FD0733C48@stanford.edu>
	<20141111010340.3329bbd7@kant>
	<20141111130143.2ff3d42e@kant>
	<20141111171356.2fc62440@kant>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found by the UC-KLEE tool:  A user could supply less input to
firewire-cdev ioctls than write- or write/read-type ioctl handlers
expect.  The handlers used data from uninitialized kernel stack then.

This could partially leak back to the user if the kernel subsequently
generated fw_cdev_event_'s (to be read from the firewire-cdev fd)
which notably would contain the _u64 closure field which many of the
ioctl argument structures contain.

The fact that the handlers would act on random garbage input is a
lesser issue since all handlers must check their input anyway.

Remarks:
  - There was never any leak from kernel stack to the ioctl output
    buffer itself.  IOW, it was not possible to read kernel stack by a
    read-type or write/read-type ioctl alone; the leak could at most
    happen in combination with read()ing subsequent event data.
  - The affected character device file interface is specified in
    include/uapi/linux/firewire-cdev.h.  An overview is given in
    Documentation/ABI/stable/firewire-cdev.

This fix simply always null-initializes the entire ioctl argument buffer
regardless of the actual length of expected user input.  That is, a
runtime overhead of memset(..., 40) is added to each firewirew-cdev
ioctl() call.

Reported-by: David Ramos <daramos@stanford.edu>
Cc: <stable@vger.kernel.org>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-cdev.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -1625,32 +1625,31 @@ static int (* const ioctl_handlers[])(st
 
 static int dispatch_ioctl(struct client *client,
 			  unsigned int cmd, void __user *arg)
 {
 	union ioctl_arg buffer;
 	int ret;
 
 	if (fw_device_is_shutdown(client->device))
 		return -ENODEV;
 
 	if (_IOC_TYPE(cmd) != '#' ||
 	    _IOC_NR(cmd) >= ARRAY_SIZE(ioctl_handlers) ||
 	    _IOC_SIZE(cmd) > sizeof(buffer))
 		return -ENOTTY;
 
-	if (_IOC_DIR(cmd) == _IOC_READ)
-		memset(&buffer, 0, _IOC_SIZE(cmd));
+	memset(&buffer, 0, sizeof(buffer));
 
 	if (_IOC_DIR(cmd) & _IOC_WRITE)
 		if (copy_from_user(&buffer, arg, _IOC_SIZE(cmd)))
 			return -EFAULT;
 
 	ret = ioctl_handlers[_IOC_NR(cmd)](client, &buffer);
 	if (ret < 0)
 		return ret;
 
 	if (_IOC_DIR(cmd) & _IOC_READ)
 		if (copy_to_user(arg, &buffer, _IOC_SIZE(cmd)))
 			return -EFAULT;
 
 	return ret;
 }


-- 
Stefan Richter
-=====-====- =-== -=-==
http://arcgraph.de/sr/
