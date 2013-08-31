Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228Ab3HaGsT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 02:48:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35934 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608Ab3HaGsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 02:48:18 -0400
Date: Sat, 31 Aug 2013 07:48:15 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix the race between the fget() and close()
Message-ID: <20130831064814.GK13318@ZenIV.linux.org.uk>
References: <1377533569.26153.3.camel@cliu38-desktop-build>
 <20130826112946.GD27005@ZenIV.linux.org.uk>
 <27240C0AC20F114CBF8149A2696CBE4A01AEEE31@SHSMSX101.ccr.corp.intel.com>
 <20130827004247.GG27005@ZenIV.linux.org.uk>
 <20130827004852.GH27005@ZenIV.linux.org.uk>
 <27240C0AC20F114CBF8149A2696CBE4A01AF6CFE@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A01AF6CFE@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 31, 2013 at 05:53:11AM +0000, Liu, Chuansheng wrote:

> I think I found one of possible race here(two processes P1 and P2):
> P1 has the the files_struct pointer FILES1, P2 has the files_struct pointer FILES2,
> 
> When P1 open file, the new struct file pointer SHARE_FILE will be installed into FILES1,
> and file refcount is 1;
> 
> And in P1, we can get P2's files_struct FILES2, and thru _fd_install(), we can add SHARE_FILE
> into P2's FILES2.
> 
> Then the same file pointer SHARE_FILE stayed in both P1 and P2's files_struct, and the panic case
> will happen:
> P1                                                            P2
> Open the SHARE_FILE
> Installed SHARE_FILE into P2's file_struct FILES2

... without bumping refcount on SHARE_FILE?  Then you really have a big
problem.  task_fd_install() call is preceded by grabbing a reference
to the file we are installing, though...  BTW, /* TODO: fput? */ after
that call is really bogus - the code doesn't call fput() there and it's
quite correct as is, since at that point the reference had gone into
descriptor table we'd been installing into and doesn't need to be dropped.

> Ioctl(SHARE_FILE)                                                When P2 exiting,
>  fget_light()
>    due to FILES1->refcount is 1,                                     put_files_struct will be called,
>    there will be no RCU and SHARE_FILE refcount increasing                will close all files including SHARE_FILE
> 
> But at this time, P1 is still operate SHARE_FILE without the refcount safety.
> 
> Then the panic will happen at vfs_ioctl() due to the SHARE_FILE has been freed.
> 
> Is it allowable that installing one file pointer into another FILES_STRUCT? Seems binder is doing the similar things.
> In fact, if in ioctl function, we can call fget() instead of fget_light(), this panic can be avoided.
> 
> Is it making sense?

No, it doesn't.  For one thing, any reference in any files_struct should
contribute 1 to refcount of struct file.  For another, you can modify
files_struct *ONLY* if you hold a reference to it.  binder, a misdesigned
piece of shit it is, does that only via proc->files, which is set in
binder_mmap() by grabbing a new reference to current->files of mmap(2)
caller.  It is safe to do (nobody can switch task's ->files to another
files_struct under it) and once that's done, there's a pinned reference
to that files_struct.  If, at the time of task_fd_install(), it happens
to be task->files_struct of some process, its refcount is going to be
at least 2, fdget() done by that other process will see that descriptor
table is shared and will bump the refcount of file being accessed.

The subtle part here is that mmap() does *NOT* use fdget() - the property
we are aiming for is that if at the time of fdget() descriptor table
hadn't been shared, no new references that could be used to modify it
will be acquired until the matching fdput().  So binder_mmap() can
legitimately grab a reference to the descriptor table of calling process.
