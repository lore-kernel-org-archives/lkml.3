Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaC1UwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 16:52:16 -0400
Received: from mail-yh0-f49.google.com ([209.85.213.49]:51977 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaC1UwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 16:52:14 -0400
MIME-Version: 1.0
X-Originating-IP: [84.208.52.246]
In-Reply-To: <20140328.145410.1817326821928803131.davem@davemloft.net>
References: <1395839117-20090-1-git-send-email-dh.herrmann@gmail.com> <20140328.145410.1817326821928803131.davem@davemloft.net>
From: Tom Gundersen <teg@jklm.no>
Date: Fri, 28 Mar 2014 21:51:53 +0100
Message-ID: <CAG-2HqVJPrTWXtuvDkU6MvfNj0MXfNuBMmdoKWtSd5kToZ3mMQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/4] Provide netdev naming-policy via sysfs
To: David Miller <davem@davemloft.net>
Cc: David Herrmann <dh.herrmann@gmail.com>, netdev <netdev@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 7:54 PM, David Miller <davem@davemloft.net> wrote:
> From: David Herrmann <dh.herrmann@gmail.com>
> Date: Wed, 26 Mar 2014 14:05:13 +0100
>
>> The main use-case is to allow udev to skip applying reliable ifnames to virtual
>> devices. For instance, if wifi-P2P devices are created, wpas already provides a
>> suitable naming-policy and udev shouldn't touch these devices. Same is true for
>> other virtual devices.
>
> This makes no sense at all.
>
> If udev should avoid applying names to wifi-P2P devices, that policy can
> be instituted completely inside of udev.  There is no need whatsoever
> for kernel support.
>
> udev can look at the device type, and policies can be defined that key
> off of that device type, entirely in userspace.

Doing this in userspace sounds really wrong and fragile.

In the case of wifi-P2P we could make it work, but for every type of
device that is added to the kernel which is named from userspace, we
would have to play catch-up in udev (and even after we do, new kernels
on old userspace will never work in the expected way).

Moreover, there are of course cases where knowing the type of device
is not sufficient. Take 'ip link add type bridge' vs. 'ip link add dev
bride5 type bridge'. They may both create a new bridge called
'bride5'. In the first case, we may reasonably want a policy in udev
to rename the device to something better, but in the second case we
probably want to leave it alone.

>From userspace there is no way (that I know of) to determine if the
name of a given device was picked by the kernel (i.e., more or less
randomly) or by the userspace process that created it (i.e., probably
for a good reason, so we should not touch it).

Also the problems with third-party processes renaming devices which
David outlined is a real problem that we run into in practice. We
could of course dream up mechanisms for these processes to communicate
to udev that they already renamed the device (and we have), but people
will keep getting this wrong, so asking the kernel for this
information just makes so much more sense.

These patches seem to solve all the problems with network interface
renaming really nicely once and for all, so would be a real shame if
they don't go in.

Cheers,

Tom
