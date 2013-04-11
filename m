Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935628Ab3DKNsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:48:50 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:46787 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935413Ab3DKNsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:48:47 -0400
Date: Thu, 11 Apr 2013 06:48:44 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Federico Vaga <federico.vaga@gmail.com>
Cc: linux-kernel@vger.kernel.org, Cornelia Huck <cornelia.huck@de.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alessandro Rubini <rubini@gnudd.com>
Subject: Re: drivers/base/core.c: about device_find_child() function
Message-ID: <20130411134844.GA3489@kroah.com>
References: <3798489.yISokZugC2@harkonnen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3798489.yISokZugC2@harkonnen>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 01:52:36PM +0200, Federico Vaga wrote:
> Hello,
> 
> I'm using the function device_find_child() [drivers/base/core.c] to retrieve 
> a specific child of a device. I see that this function invokes 
> get_device(child) when a child matches. I think that this function must 
> return the reference to the child device without getting it.

No, it should not, otherwise the device could "disappear" at any moment,
and the caller who had the handle, would now have a stale pointer.

> The function's comment does not explicitly talk about an increment of the 
> refcount of the device. So, "man 9 device_find_child" and various derivative 
> webpages do not talk about this. The developer is not correctly informed 
> about this function, unless (s)he looks at the source code.

You are right, I would gladly take a patch adding that comment to the
function, can you send me one?

> I see that users of this function, usually, immediately do put_device() after 
> the call to device_find_child(), so it is not expected that a 
> device_find_child() does a get_device() on the found child.
> 
> 
>    Immediately does put_device():
>      drivers/firewire/core-device.c
>      drivers/rpmsg/virtio_rpmsg_bus.c
>      drivers/s390/kvm/kvm_virtio.c

That's correct.

>    They effectively need a get_device():
>      drivers/net/bluetooth/hci_sysfs.c
>      drivers/net/dsa/dsa.c

Please fix these.

>    Maybe bugged because they do not do put_device():
>      drivers/media/platform/s5p-mfc/s5p_mfc.c
>      drivers/tty/serial/serial_core.c
>    Probably I'm wrong on this and I do not find the associated put_device()

I think the serial core is correct, but I'll audit it, the media one
should be fixed as well.

thanks,

greg k-h
