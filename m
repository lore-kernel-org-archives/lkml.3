Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbaEUQsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 12:48:05 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:53737 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751561AbaEUQsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 12:48:04 -0400
Date: Wed, 21 May 2014 17:48:28 +0100
From: Dave P Martin <Dave.Martin@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: debugfs and module unloading
Message-ID: <20140521164827.GB3501@e103592.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

I have a quick debugfs question:

How can I protect against a module being unloaded while debugfs files it
provides are open?

I can do something like the following:

static int my_debugfs_file_open(struct inode *, struct file *)
{
	if (!try_module_get())
		return -EIO;

	/* ... */
}

static int my_debugfs_file_release(struct inode *, struct file *)
{
	/* ... */

	module_put();

	return 0;
}

static const struct file_operations my_debugfs_fops = {
	/* ... */

	.open = my_debugfs_file_open,
	.release = my_debugfs_file_release,

	/* ... */
};

static struct device_driver my_driver {
	/* ... */

	.owner = THIS_MODULE;

	/* ... */
};

static int my_module_init(void)
{
	driver_register(&my_driver);
	debugfs_create_file(..., &my_debugfs_fops);
}

static void my_module_exit(void)
{
	debugfs_remove_recusrive(...);
	driver_unregister(&my_driver);
}


... but it doesn't quite work.  debugfs_remove_recursive() prevents any
new file handles being opened, but files already open remain open -- so
it's still possible for the module text to get unloaded between the
module refcount being decreased inside module_put() and the time
my_debugfs_file_release() returns.

The scenario to consider is when a request to unload the module races
with closure of the last debugfs file.


The only obvious way I can see to solve this without changing the debugfs
code is to make the module impossible to unload by calling __module_get()
during initialisation, before any debugfs file is created.


A similar dependency problem exists when a pointer to some device
instance data is passed to debugfs_create_file().  For pluggable
devices, the device might go away at any time.  I hoped this could
be solved by calling get_device() ... put_device() in the debugfs file
open and release methods, but I found that a device instance can
get removed, and the module unloaded, even though the struct device
refcount is not zero.


Am I missing something?

Cheers
---Dave
