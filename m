Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458AbaHFRni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 13:43:38 -0400
Received: from mail.tune-it.ru ([80.246.244.150]:62147 "EHLO mail.tune-it.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754182AbaHFRng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 13:43:36 -0400
Message-ID: <53E2681D.3020508@Tune-IT.Ru>
Date: Wed, 06 Aug 2014 21:38:37 +0400
From: Sergey Klyaus <Sergey.Klyaus@Tune-IT.Ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.de>
CC: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH] driver core: fix race with userland in device_add()
References: <Pine.LNX.4.44L0.1407281020180.1183-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1407281020180.1183-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/28/2014 06:22 PM, Alan Stern wrote:
> On Mon, 28 Jul 2014, Oliver Neukum wrote:
>
>> On Fri, 2014-07-25 at 17:43 +0400, Sergey Klyaus wrote:
>>> Hello.
>>>
>>> I am currently working on a project with Thin clients with Citrix
>>> Receiver 13 for Linux and encountered interesting problem with USB
>>> device redirection.
>>> ctxusb/ctxusbd process from Citrix Receiver are using inotify mechanism
>>> to monitor /dev/bus/usb filesystem, and when device arrives, tries to
>>> open it, but get ENODEV status:
>>> Jul 25 11:36:13 myaut-desktop ctxusbd[2664]: Failed to open device: No
>>> such device
>>> Jul 25 11:36:13 myaut-desktop ctxusb[2751]: Failed to open device
>>> 001:003 (error 19 - No such device), bad id?
>>>
>>> It is caused by design of device_add() function: it calls
>>> devtmpfs_create_node before bus_add_device. Here are sequence of events:
>>> 1. device_add() calls devtmpfs_create_node(). That leads to inotify
>>> event that.
>>> 2. ctxusb is awoken because inotify event arises, and calls ctxusbd daemon.
>>> 3. ctxusbd daemon opens /dev/bus/usb/new-device, so usbdev_open()
>>> routine is called
>>> 4. usbdev_open() calls  usbdev_lookup_by_devt(). Because device is not
>>> yet attached to "usb bus", it returns NULL, and thus usbdev_open()
>>> returns -ENODEV
>>> 5. Finally, device_add() calls bus_add_device(), and all subsequent
>>> calls of usbdev_open() will succeed. However, ctxusb/ctxusbd already
>>> reported an error and abandon device. User is unsatisfied.
>>>
>>> I was able to reproduce that issue on Ubuntu 10.04 with 2.6.32 and 3.13
>>> kernels.
>>> However, it only occur on uni-processor systems (!)
>>>
>>> I see three ways to solve that issue:
>>> 1. Leave it to userland applications (i.e. using loop with retries and
>>> timeouts). However, I feel that it is a kernel issue (application is
>>> notified before device is ready).
>>> 2. Call bus_add_device() before devtmpfs_create_node(). Very rough, and
>>> probably breaks a lot of other kernel code.
>>> 3. Wait in usbdev_open() until reconfiguration is finished (i.e. by
>>> using some global lock between usb_new_device() and usbdev_open(), or
>>> add completion and special state USB_STATE_CONNECTING to a device).
>> No to your third option. This is no USB problem. The issue is in the
>> generic code. The only clean fix is your suggestion (2)
> I agree.  That whole "if (MAJOR(dev->devt)) {" thing in device_add()
> should come at the end, not in the middle.
>
> Alan Stern
>
Hello.

I wrote a patch that fixes the problem that described above, here are a 
patch for 3.16.0+ kernel (cloned from GitHub today). Maybe that "if 
(MAJOR(dev->devt)) " part has to go even after BUS_NOTIFY_ADD_DEVICE abd 
KOBJ_ADD? I put it before it, because there is no rollback code in 
device_add() for that part.

Here are a patch:

bus_add_device() should be called before devtmpfs_create_node(), so when 
userland application opens device from devtmpfs, it wouldn't get ENODEV 
from kernel, because device_add() wasn't completed.

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 20da3ad..cc84ba8 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1019,18 +1029,6 @@ int device_add(struct device *dev)
      if (error)
          goto attrError;

-    if (MAJOR(dev->devt)) {
-        error = device_create_file(dev, &dev_attr_dev);
-        if (error)
-            goto ueventattrError;
-
-        error = device_create_sys_dev_entry(dev);
-        if (error)
-            goto devtattrError;
-
-        devtmpfs_create_node(dev);
-    }
-
      error = device_add_class_symlinks(dev);
      if (error)
          goto SymlinkError;
@@ -1044,7 +1042,19 @@ int device_add(struct device *dev)
      if (error)
          goto DPMError;
      device_pm_add(dev);
-
+
+    if (MAJOR(dev->devt)) {
+        error = device_create_file(dev, &dev_attr_dev);
+        if (error)
+            goto DevAttrError;
+
+        error = device_create_sys_dev_entry(dev);
+        if (error)
+            goto SysEntryError;
+
+        devtmpfs_create_node(dev);
+    }
+
      /* Notify clients of device addition.  This call must come
       * after dpm_sysfs_add() and before kobject_uevent().
       */
@@ -1074,6 +1084,12 @@ int device_add(struct device *dev)
  done:
      put_device(dev);
      return error;
+ SysEntryError:
+    if (MAJOR(dev->devt))
+        device_remove_file(dev, &dev_attr_dev);
+ DevAttrError:
+    device_pm_remove(dev);
+    dpm_sysfs_remove(dev);
   DPMError:
      bus_remove_device(dev);
   BusError:
@@ -1081,14 +1097,6 @@ done:
   AttrsError:
      device_remove_class_symlinks(dev);
   SymlinkError:
-    if (MAJOR(dev->devt))
-        devtmpfs_delete_node(dev);
-    if (MAJOR(dev->devt))
-        device_remove_sys_dev_entry(dev);
- devtattrError:
-    if (MAJOR(dev->devt))
-        device_remove_file(dev, &dev_attr_dev);
- ueventattrError:
      device_remove_file(dev, &dev_attr_uevent);
   attrError:
      kobject_uevent(&dev->kobj, KOBJ_REMOVE);
