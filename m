Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab3LMUm1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 15:42:27 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:52998 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab3LMUm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 15:42:26 -0500
MIME-Version: 1.0
In-Reply-To: <1386962557-8899-1-git-send-email-levex@linux.com>
References: <1386962557-8899-1-git-send-email-levex@linux.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 13 Dec 2013 13:42:05 -0700
Message-ID: <CAErSpo4dJFsK+Wcfz8PrH=Ras343nLS=XgQFbEr_KCgFVED52Q@mail.gmail.com>
Subject: Re: [PATCH 0/4] treewide: add missing put_device calls
To: Levente Kurusa <levex@linux.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Greg]

On Fri, Dec 13, 2013 at 12:22 PM, Levente Kurusa <levex@linux.com> wrote:
> Hi,
>
> This is just the beginning of patchset-set that aims to fix possible
> problems caused by not calling put_device() if device_register() fails.
>
> The root cause for the need to call put_device() is that the underlying
> kobject still has a reference count of 1. Thus, device.release() will not
> be called and the device will just sit there waiting for a put_device().
> Adding the put_device() also removes the need for the call to kfree() as most
> release functions already call kfree() on the container of the device.
>
> While these have not been experienced, they are potential issues and thus
> they need to be fixed. Also, they are a few more files that have the same
> kind of issue, those will be fixed if these are accepted.

Thanks for doing this.  This is the sort of mistake that just gets
copied everywhere, so fixing the examples in the tree will help
prevent the problem from spreading more.

I don't know if there's really value in having device_register()
return an error but rely on the caller to do the put_device().  Are
there cases where the caller still needs the struct device even if
device_register() fails?  E.g., could we do something like this
instead (I know some callers would also require corresponding changes
to avoid double puts):

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1139,8 +1139,13 @@ EXPORT_SYMBOL_GPL(device_add);
  */
 int device_register(struct device *dev)
 {
+       int ret;
+
        device_initialize(dev);
-       return device_add(dev);
+       ret = device_add(dev);
+       if (ret)
+               put_device(dev);
+       return ret;
 }
 EXPORT_SYMBOL_GPL(device_register);
