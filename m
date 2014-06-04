Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472AbaFDP0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 11:26:16 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42509 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751434AbaFDP0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 11:26:14 -0400
Date: Wed, 4 Jun 2014 11:26:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
cc: Wei.Yang@windriver.com, Michal Nazarewicz <mina86@mina86.com>,
        Felipe Balbi <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] USB:gadget: Fix a warning while loading g_mass_storage
In-Reply-To: <538F0BBD.2000605@samsung.com>
Message-ID: <Pine.LNX.4.44L0.1406041100500.922-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2014, Andrzej Pietrasiewicz wrote:

> When Sebastian introduced the function registration interface I didn't
> specially like the naming: struct usb_function_instance is something
> different than an instance of struct usb_function.

What is the difference in purpose between usb_function and
usb_function_instance?  I can't tell just by reading the header file.  
Does one of them get created dynamically when the host sets the
appropriate config?

It's quite noticeable that composite.h does not contain nearly enough
documentation.  Only four of the structures defined there have any
kerneldoc, and none of the functions do.

Also, there seems to be some confusion between structures that 
represent drivers and those that represent devices (or parts of a 
device).  For example, struct usb_function contains instance data as 
well as driver callbacks.

> The purpose of fsg_alloc_inst() is to create a usb_function_instance
> whose container_of is struct fsg_opts. In fact it is struct fsg_opts
> which is actually allocated; one of its members is struct fsg_common
> which is also allocated - individually for each struct usb_function_instance.
> 
> Among traditional gadgets there is no gadget which uses mass storage function
> more than once. On the other hand, when gadgets are created with configfs
> it is forbidden to link a given function more than once into a given
> config,

What is the reason for this restriction?

>  that is a struct usb_function_instance can be referenced by more
> than one config, but can be referenced only once in a given config;
> each symbolic link corresponds to an instance of struct usb_function
> (don't confuse with struct usb_function_instance).

It's extremely easy to confuse them, since I don't understand the 
differences between them.  It even seems like you confused them in this 
description: You mentioned "link a given function", "link corresponds 
to an instance of struct usb_function", and "struct 
usb_function_instance can be referenced by more than one config".  
What's the difference between linking a usb_function and referencing a 
usb_function_instance?  Normally "linking" and "referencing" mean more 
or less the same thing.

> So yes, an fsg_common can be shared among instances of struct usb_function,
> but neither with traditional gadgets as they are now nor with configfs
> is it possible to have the same fsg_common referenced more than once
> in a given config.

That's a relief.  But it still seems like a bad design.  If there can 
be only one struct fsg_dev associated with struct fsg_common, why have 
separate structures?  And if there can be multiple fsg_dev structures 
associated with struct fsg_common, why does struct fsg_common contain a 
pointer to an fsg_dev (in fact, two of them)?

The issue that started these thoughts was the way fsg_common.new_fsg 
gets used, as modified by the patch in the thread's original email.  
It's not clear why new_fsg is needed at all.

Alan Stern

