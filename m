Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbaFESKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 14:10:09 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42705 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753072AbaFESKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 14:10:07 -0400
Date: Thu, 5 Jun 2014 14:10:06 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
cc: Wei.Yang@windriver.com, Michal Nazarewicz <mina86@mina86.com>,
        Felipe Balbi <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] USB:gadget: Fix a warning while loading g_mass_storage
In-Reply-To: <53903FB8.7060501@samsung.com>
Message-ID: <Pine.LNX.4.44L0.1406051031500.1103-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2014, Andrzej Pietrasiewicz wrote:

> I think it is easier to tell the purpose of the two structures taking
> gadgets composed with configfs as example.
> 
> In each gadget there is "functions" directory. Function directories
> are created there:
> 
> $ cd $CONFIGFS_ROOT/usb_gadget/our_gadget
> $ mkdir functions/mass_storage.0
> 
> mass_storage.0 is internally represented as an instance of
> struct usb_function_instance, which has its associated
> struct fsg_common (the fsg_common is a member of
> container_of(struct usb_function_instance)).

Okay.

> It can be referenced from multiple configurations.
> 
> $ ln -s functions/mass_storage.0 configs/config.1
> $ ln -s functions/mass_storage.0 configs/config.2
> 
> Each reference (symbolic link) is internally represented as
> an instance of struct usb_function. The struct usb_function here
> has its associated struct fsg_dev (the fsg_dev is a
> container_of(struct usb_function)).

So in essence, a usb_function connects a particular function to a 
particular config.

> By the very nature of any file system one cannot do:
> 
> $ ln -s functions/mass_storage.0 configs/config.1
> $ ln -s functions/mass_storage.0 configs/config.1 => -EEXIST
> 
> By design of how configfs is applied to any usb gadget on cannot even do:
> 
> $ ln -s functions/mass_storage.0 configs/config.1/my_mass_storage.0
> $ ln -s functions/mass_storage.0 configs/config.1/the_same_mass_storage.0 => -EEXIST

So for any given usb_function_instance, only one usb_function will be
active at any time: the one connecting the function to the current
config.

And presumably the reasons why struct fsg_dev contains
interface_number, bulk_in, and bulk_out members are because these
values are determined when the config is originally set up, and they
can vary from one config to another.  Right?  Whereas the items in
struct fsg_common don't depend on the config.

> However, there should be no problem with this:
> 
> $ mkdir functions/mass_storage.0
> $ mkdir functions/mass_storage.1
> $ ln -s functions/mass_storage.0 configs/config.1
> $ ln -s functions/mass_storage.1 configs/config.1

That makes sense now.

> Legacy gadgets (g_mass_storage, g_acm_ms, g_multi) in fact operate in
> a somewhat similar manner, the difference is that instead of creating directories
> and making symbolic links, usb_get_function_instance() and usb_get_function()
> are called, respectively, and composing a gadget happens from beginning to end
> at module init.
> 
> I hope this clarifies things a bit.

Yes, it helps a lot.  Thank you.

Alan Stern

