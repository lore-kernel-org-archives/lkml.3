Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbaEUWBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 18:01:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49882 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbaEUWBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 18:01:24 -0400
Date: Thu, 22 May 2014 07:01:14 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dave P Martin <Dave.Martin@arm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: debugfs and module unloading
Message-ID: <20140521220114.GB15454@kroah.com>
References: <20140521164827.GB3501@e103592.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140521164827.GB3501@e103592.cambridge.arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 05:48:28PM +0100, Dave P Martin wrote:
> Hi there,
> 
> I have a quick debugfs question:
> 
> How can I protect against a module being unloaded while debugfs files it
> provides are open?
> 
> I can do something like the following:
> 
> static int my_debugfs_file_open(struct inode *, struct file *)
> {
> 	if (!try_module_get())
> 		return -EIO;
> 
> 	/* ... */
> }
> 
> static int my_debugfs_file_release(struct inode *, struct file *)
> {
> 	/* ... */
> 
> 	module_put();
> 
> 	return 0;
> }
> 
> static const struct file_operations my_debugfs_fops = {
> 	/* ... */
> 
> 	.open = my_debugfs_file_open,
> 	.release = my_debugfs_file_release,
> 
> 	/* ... */
> };
> 
> static struct device_driver my_driver {
> 	/* ... */
> 
> 	.owner = THIS_MODULE;
> 
> 	/* ... */
> };
> 
> static int my_module_init(void)
> {
> 	driver_register(&my_driver);
> 	debugfs_create_file(..., &my_debugfs_fops);
> }
> 
> static void my_module_exit(void)
> {
> 	debugfs_remove_recusrive(...);
> 	driver_unregister(&my_driver);
> }
> 
> 
> ... but it doesn't quite work.  debugfs_remove_recursive() prevents any
> new file handles being opened, but files already open remain open -- so
> it's still possible for the module text to get unloaded between the
> module refcount being decreased inside module_put() and the time
> my_debugfs_file_release() returns.
> 
> The scenario to consider is when a request to unload the module races
> with closure of the last debugfs file.
> 
> 
> The only obvious way I can see to solve this without changing the debugfs
> code is to make the module impossible to unload by calling __module_get()
> during initialisation, before any debugfs file is created.
> 
> 
> A similar dependency problem exists when a pointer to some device
> instance data is passed to debugfs_create_file().  For pluggable
> devices, the device might go away at any time.  I hoped this could
> be solved by calling get_device() ... put_device() in the debugfs file
> open and release methods, but I found that a device instance can
> get removed, and the module unloaded, even though the struct device
> refcount is not zero.
> 
> 
> Am I missing something?

Nope, you are not, it's a known issue.  Al Viro is doing some core VFS
work to help mitigate this, and I am working on converting debugfs to
use kernfs which should also help resolve this problem.

Don't unload modules automatically and you should be fine :)

thanks,

greg k-h
