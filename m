Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093AbaADSQM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 13:16:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55699 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbaADSQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 13:16:11 -0500
Date: Sat, 4 Jan 2014 10:16:20 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jeff Mahoney <jeffm@suse.com>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, tglx@linutronix.de,
        paulmck@linux.vnet.ibm.com, mingo@kernel.org
Subject: Re: [PATCH] kobject: provide kobject_put_wait to fix module unload
 race
Message-ID: <20140104181620.GA2087@kroah.com>
References: <alpine.LRH.2.02.1401021733250.27775@file01.intranet.prod.int.rdu2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1401021733250.27775@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 04, 2014 at 01:06:01PM -0500, Mikulas Patocka wrote:
> Hi
> 
> I noticed that Jeff Mahoney added a new structure kobj_completion, defined 
> in include/linux/kobj_completion.h to the kernel 3.13-rc1 in the patch 
> eee031649707db3c9920d9498f8d03819b74fc23. In the current upstream kernel, 
> this interface is still unused.

There are pending btrfs patches to use this interface.

> However, converting the drivers to use kobj_completion is not trivial 
> (note that all users of the original kobject interface are buggy - so all 
> of them need to be converted).

Wait, what?  How are "all users" buggy?  Please explain this in detail.

> I came up with a simpler patch to achieve the same purpose - this patch 
> makes fixing the drivers easy - the driver is fixed just by replacing 
> "kobject_put" with "kobject_put_wait" in the unload routine.

No, that's not ok at all.

> I'd like to ask if you could revert 
> eee031649707db3c9920d9498f8d03819b74fc23 (no code uses it) and replace it 
> with this patch.
> 
> See http://www.redhat.com/archives/dm-devel/2013-October/msg00141.html for 
> the bug that this patch fixes.
> 
> Mikulas
> 
> 
> 
> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> This patch introduces a new function kobject_put_wait. It decrements the
> kobject reference count, waits until the count reaches zero. When this
> function returns, it is guaranteed that the kobject was freed.
> 
> A rationale for this function:
> 
> The kobject is keeps a reference count. The driver unload routine
> decrements the reference count, however, references to the kobject may
> still be held by other kernel subsystems. The driver must not free the
> memory that contains the kobject. Instead, the driver provides a "release"
> method. The "release" method is called by the kernel when the last kobject
> refernce is dropped. The "release" method should free the memory that
> contains the kobject.
> 
> However, this pattern is buggy with respect to modules. The release method
> is placed in the driver's module. When the driver exits, the module
> reference count is zero, thus the module may be freed. However, there may
> still be references to the kobject. If the module is unloaded and then the
> release method is called, a crash happens.

Yes, module unloading while a kobject is still "active" is not a good
thing, what modules do you have that cause this problem?  Why not just
grab the module reference in your kobject if you need this type of
protection?  It's not the kobject's code fault that this issue is there,
or that we now have a "delayed release" function to expose this type of
thing, it's the user of the kobject.

Please fix the broken users of the kobject first.

thanks,

greg k-h
