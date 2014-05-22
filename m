Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbaEVJ0b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 05:26:31 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51340 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754125AbaEVJ0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 05:26:30 -0400
Date: Thu, 22 May 2014 10:26:57 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: debugfs and module unloading
Message-ID: <20140522092647.GA5808@e103592.cambridge.arm.com>
References: <20140521164827.GB3501@e103592.cambridge.arm.com>
 <20140521220114.GB15454@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140521220114.GB15454@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2014 at 11:01:14PM +0100, Greg Kroah-Hartman wrote:
> On Wed, May 21, 2014 at 05:48:28PM +0100, Dave P Martin wrote:
> > Hi there,
> > 
> > I have a quick debugfs question:
> > 
> > How can I protect against a module being unloaded while debugfs files it
> > provides are open?
> > 
> > I can do something like the following:

[...]

> > ... but it doesn't quite work.  debugfs_remove_recursive() prevents any
> > new file handles being opened, but files already open remain open -- so
> > it's still possible for the module text to get unloaded between the
> > module refcount being decreased inside module_put() and the time
> > my_debugfs_file_release() returns.
> > 
> > The scenario to consider is when a request to unload the module races
> > with closure of the last debugfs file.
> > 
> > 
> > The only obvious way I can see to solve this without changing the debugfs
> > code is to make the module impossible to unload by calling __module_get()
> > during initialisation, before any debugfs file is created.
> > 
> > 
> > A similar dependency problem exists when a pointer to some device
> > instance data is passed to debugfs_create_file().  For pluggable
> > devices, the device might go away at any time.  I hoped this could
> > be solved by calling get_device() ... put_device() in the debugfs file
> > open and release methods, but I found that a device instance can
> > get removed, and the module unloaded, even though the struct device
> > refcount is not zero.
> > 
> > 
> > Am I missing something?
> 
> Nope, you are not, it's a known issue.  Al Viro is doing some core VFS
> work to help mitigate this, and I am working on converting debugfs to
> use kernfs which should also help resolve this problem.
> 
> Don't unload modules automatically and you should be fine :)

OK, I will stop attempting half-baked workarounds of my own and keep
an eye out for changes in VFS.

Unloading the module certainly speeds up development work, but users
of it are unlikely to care...

Thanks
---Dave
