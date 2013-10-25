Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab3JYKqi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 06:46:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50409 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab3JYKqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 06:46:37 -0400
Date: Fri, 25 Oct 2013 11:42:12 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Frank Haverkamp <haver@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        jsvogt@de.ibm.com, MIJUNG@de.ibm.com, cascardo@linux.vnet.ibm.com,
        michael@ibmra.de, Frank Haverkamp <haver@vnet.ibm.com>
Subject: Re: [PATCH] Generic WorkQueue Engine (GenWQE) device driver (v3)
Message-ID: <20131025104212.GA22369@kroah.com>
References: <20131024100942.GA13614@kroah.com>
 <1382695784-10127-2-git-send-email-haver@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382695784-10127-2-git-send-email-haver@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 12:09:44PM +0200, Frank Haverkamp wrote:
> From: Frank Haverkamp <haver@vnet.ibm.com>
> 
> The GenWQE card itself provides access to a generic work queue into
> which the work can be put, which should be executed, e.g. compression
> or decompression request, or whatever the card was configured to do.
> 
> Each request comes with a set of input data (ASV) and will produce some
> output data (ASIV). The request will also contain a sequence number,
> some timestamps and a command code/subcode plus some fields for hardware-/
> software-interaction.
> 
> A request can contain references to blocks of memory. Since the card
> requires DMA-addresses of that memory, the driver provides two ways to
> solve that task:
>   1) The drivers mmap() will allocate some DMAable memory for the user.
>      The driver has a lookup table such that the virtual userspace
>      address can properly be replaced and checked.
>   2) The user allocates memory and the driver will pin/unpin that
>      memory and setup a scatter gatherlist with matching DMA addresses.
> 
> Currently work requests are synchronous.
> 
> The genwqe driver has a user-space interface described in
> linux/include/genwqe/genwqe_card.h. There are several ioctls which can
> be used to talk to the driver. In addition there are some sysfs
> entries where information can be exchanged with user-space. The sysfs
> interface is described in
> Documentation/ABI/testing/sysfs-driver-genwqe.
> 
> Signed-off-by: Frank Haverkamp <haver@vnet.ibm.com>
> Co-authors: Joerg-Stephan Vogt <jsvogt@de.ibm.com>,
>             Michael Jung <MIJUNG@de.ibm.com>,
>             Michael Ruettger <michael@ibmra.de>

Please run sparse on the code and fix up the issues that it finds (a
short glance seems that there will be some issues, I didn't run it
myself.)

And why are you doing debug stuff through the ioctl interface?  Please
move that to debugfs if you really want/need that information, it does
not belong in an ioctl.

Your huge numbers of module parameters are also worrying.  I think
almost all of them should be sysfs files on a per device/card as you can
not handle different options for different cards with module parameters.
Please remove all of them, as no distro/user will _ever_ know what to do
with a module option, it's not fair to push those types of decisions to
users where you can't make up your mind as a kernel developer.

One final legal question:

> --- /dev/null
> +++ b/drivers/misc/genwqe/card_base.c
> @@ -0,0 +1,1305 @@
> +/**
> + * IBM Accelerator Family 'GenWQE'
> + *
> + * (C) Copyright IBM Corp. 2013
> + *
> + * Author: Frank Haverkamp <haver@linux.vnet.ibm.com>
> + * Author: Joerg-Stephan Vogt <jsvogt@de.ibm.com>
> + * Author: Michael Jung <mijung@de.ibm.com>
> + * Author: Michael Ruettger <michael@ibmra.de>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2, or (at your option)
> + * any later version.

Do you _really_ mean "any later version"?  I have to ask, sorry.

> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
> + * GNU General Public License for more details.

What's with the odd spacing of that last sentence?

Thanks for not putting the FSF's office address in this part of the
files, that's much appreciated.

thanks,

greg k-h
