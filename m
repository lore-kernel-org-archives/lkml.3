Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab3BDDWG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 22:22:06 -0500
Received: from mail.kernel.org ([198.145.19.201]:49073 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759Ab3BDDWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 22:22:04 -0500
Date: Sun, 3 Feb 2013 17:41:14 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Serban Constantinescu <Serban.Constantinescu@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "arve@android.com" <arve@android.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        Dave Butcher <Dave.Butcher@arm.com>
Subject: Re: [PATCH 1/2] staging: android: ashmem: fix ashmem pin/unpin
 interface
Message-ID: <20130204014114.GA14058@kroah.com>
References: <1359734881-15093-1-git-send-email-serban.constantinescu@arm.com>
 <1359734881-15093-2-git-send-email-serban.constantinescu@arm.com>
 <20130201161836.GA29021@kroah.com>
 <510BF365.2010609@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <510BF365.2010609@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2013 at 04:55:01PM +0000, Serban Constantinescu wrote:
> Hi Greg,
> 
> On 01/02/13 16:18, Greg KH wrote:
> >On Fri, Feb 01, 2013 at 04:08:00PM +0000, Serban Constantinescu wrote:
> >>The values exchanged between kernel and userspace through struct
> >>ashmem_pin should be of type size_t. This change won't affect the
> >>existing interface but will stand as the basis of 64bit compat layer.
> >
> >How do you define size_t with a 64bit kernel and a 32bit userspace
> >properly?  Doesn't this change open up a bunch of problems?
> 
> The current ashmem pin/unpin kernel interface uses __u32 to specify
> the memory region and length in bytes. However these values  should
> be of type size_t so that they are able to represent the whole range
> of possible values when compiled for a 64bit platform.

Yes, the issue is, what size is size_t on the system if you have a 32bit
userspace and a 64bit kernel?  :)

That's why we have specific types for when we cross the user/kernel
boundry.  Why not use them instead here so that you know it will work
properly in the future?

> Android API uses ashmem driver through libcutils, from where I
> attach the following snippet:
> 
> <aosp>/system/core/libcutils/ashmem-dev.c
> 
>   75 int ashmem_pin_region(int fd, size_t offset, size_t len)
>   76 {
>   77         struct ashmem_pin pin = { offset, len };
>   78         return ioctl(fd, ASHMEM_PIN, &pin);
>   79 }

Again, the 32/64 bit issue is to blame.

> The kernel changes inline with the userspace usage and do not affect
> existing 32bit Android (we have exported the new kernel header,
> rebuilt and tested the interface with success).
> 
> However this change will affect any 64bit userspace using the
> current faulty interface, but there is none that we know of.

I'd like the Android developers to give some feedback on this, before
I'll do anything.  I still think you need to change this to use the
proper kernel types.

thanks,

greg k-h
