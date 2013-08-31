Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab3HaHfs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 03:35:48 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35953 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab3HaHfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 03:35:46 -0400
Date: Sat, 31 Aug 2013 08:35:43 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix the race between the fget() and close()
Message-ID: <20130831073543.GL13318@ZenIV.linux.org.uk>
References: <1377533569.26153.3.camel@cliu38-desktop-build>
 <20130826112946.GD27005@ZenIV.linux.org.uk>
 <27240C0AC20F114CBF8149A2696CBE4A01AEEE31@SHSMSX101.ccr.corp.intel.com>
 <20130827004247.GG27005@ZenIV.linux.org.uk>
 <20130827004852.GH27005@ZenIV.linux.org.uk>
 <27240C0AC20F114CBF8149A2696CBE4A01AF6CFE@SHSMSX101.ccr.corp.intel.com>
 <20130831064814.GK13318@ZenIV.linux.org.uk>
 <27240C0AC20F114CBF8149A2696CBE4A01AF6D3B@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A01AF6D3B@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 31, 2013 at 07:01:33AM +0000, Liu, Chuansheng wrote:

> My scenario is:
> P1 files_struct refcount is 1, P2's is 1 also.
> P1 get_files_struct(P2)
> P1 install one file into P2's files_struct
> P1 put_files_struct(P2)
> 
> Then P1 and P2's files_struct refcount are 1, then when P1 is doing ioctl() and P2 is exiting
> with put_files_struct(P2), the race will occur, my understanding is wrong?

First of all, this wouldn't have been a problem (so you get a new reference
to file inserted in P2's files_struct; file refcount had been bumped, so
destruction of P2's files_struct will undo that increment of file refcount
and we are still fine).  _Removal_ in a similar scenario would have been
a problem, with P2 doing fdget() while its table isn't shared, then P1
removing a reference from it and dropping a file - the last one, at that,
since fdget() assumed that the reference would've stayed in P2's descriptor
table.  HOWEVER, P1 does not do get_files_struct(P2) at all - it's only
done by P2 in binder_mmap().

Again, the invariant to look for is this:
	* if current->files had not been shared at fdget() time, it won't
be shared at matching fdput() and no entries will have been removed in
between.

task_fd_install()/task_close_fd() are done on proc->files, which contributes
to descriptor table refcount.  All other modifications are done to
current->files, which also contributes to refcount.  If at fdget() time
current->files had refcount 1, we had no other processes with task->files
pointing to this descriptor table *and* no binder_proc had their ->files
pointint to it.  No new ones may appear, since new process could get
such a reference only from do_fork() called by us and new binder_proc could
get such a reference only from binder_mmap() called by us.  Neither is
called between fdget() and fdput().  So in that case the only reference
to this descriptor table will remain current->files and all removals
would have to be done by ourselves (and not via task_close_fd(), at that).

And AFAICS, binder_lock() prevents proc->files being dropped under
task_close_fd() and task_fd_install().  Hell knows...

How reproducible it is?  Do you have any more instances, or had that
been a one-off panic?
