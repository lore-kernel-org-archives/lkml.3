Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbbAYQPw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 11:15:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54826 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230AbbAYQPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 11:15:48 -0500
Date: Sun, 25 Jan 2015 20:36:05 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Mandeep Sandhu <mandeep.sandhu@cyaninc.com>
Cc: hjk@hansjkoch.de, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/4] libunload: A library to help remove open files
Message-ID: <20150125123605.GB9141@kroah.com>
References: <1421434179-3650-1-git-send-email-mandeep.sandhu@cyaninc.com>
 <1421434179-3650-4-git-send-email-mandeep.sandhu@cyaninc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421434179-3650-4-git-send-email-mandeep.sandhu@cyaninc.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 10:49:38AM -0800, Mandeep Sandhu wrote:
> The problem of how to remove open files due to module unloading or
> device hotunplugging keeps coming up.  We have multiple implementations
> of roughly the same logic in proc, sysctl, sysfs, tun and now I am
> working on yet another one for uio. It is time to start working on a
> generic implementation.
> 
> This library does not aim to allow wrapping any arbitray set of file
> operations and making it safe to unload any module. This library aims
> to work in conjunction with the code implementiong an object to make it
> safe to remove the object while file handles to it are still open.
> libunload implements the necessary locking and logic to make it
> striaght forward to implement file_operations for objects that are
> removed at runtime.
> 
> It is hard to arrange for the ->close method of vm_operations_struct to
> be called when an object is being removed, and this code doesn't even
> attempt to help with that. Instead it is assumed that calling ->close
> is not needed. Without close support mmap at hotunplug time is simply a
> matter of calling umap_mapping_range() to invaildate the mappings, and
> to arrange for vm_fault to return VM_FAULT_SIGBUS when the
> unload_trylock fails.
> 
> Wait queues and fasync queues can safely be woken up after
> unload_barrier making the semantics clean. The fasync entries can be
> freed as a list of all of the file descriptors is kept. poll entries
> can not be freed so the poll wait queue heads must be kept around. If
> someone else's poll method is being wrapped, the wrapped poll wait
> queue head could be freed, but it requires that there is a wrapping
> wait queue head that is kept around. If there is no other way wrapping
> a poll wait queue head seems practical but in general it isn't
> particularly useful.
> 
> libunload is best understood from the perspective of code that calls
> unload_barrier(). Past the unload barrier it is guaranteed that there
> is no code in the critical sections protectecd by the unload lock, and
> the unload release lock. Past the unload barrier it is safe to call the
> release methods for remaining file descriptors, to ensure some logical
> state does not persist.

Can you provide some documentation for how to use this, kerneldoc at the
very least.

Also, can you port the above mentioned interfaces (proc, sysfs, tun,
etc.) that need this type of logic to this api, so we can see how well
it works out?  Just providing one user of the code (uio), doesn't really
show if this is "generic" enough for everyone to use.

thanks,

greg k-h
