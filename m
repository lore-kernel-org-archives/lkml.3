Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab3HZL3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 07:29:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45993 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab3HZL3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 07:29:50 -0400
Date: Mon, 26 Aug 2013 12:29:47 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix the race between the fget() and close()
Message-ID: <20130826112946.GD27005@ZenIV.linux.org.uk>
References: <1377533569.26153.3.camel@cliu38-desktop-build>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377533569.26153.3.camel@cliu38-desktop-build>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 12:12:49AM +0800, Chuansheng Liu wrote:
> 
> When one thread is calling sys_ioctl(), and another thread is calling
> sys_close(), current code has protected most cases.
> 
> But for the below case, it will cause issue:
> T1                                T2                             T3
> sys_close(oldfile)                sys_open(newfile)              sys_ioctl(oldfile)
>  -> __close_fd()
>    lock file_lock
>     assign NULL file
>     put fd to be unused
>    unlock file_lock
> 				   get new fd is same as old
> 				   assign newfile to same fd
> 								   fget_flight()
>                                                                     get the newfile!!!
>     decrease file->f_count
>      file->f_count == 0
>       --> try to release file
> 
> The race is when T1 try to close one oldFD, T3 is trying to ioctl the oldFD,
> if currently the new T2 is trying to open a newfile, it maybe get the newFD is
> same as oldFD.
> 
> And normal case T3 should get NULL file pointer due to released by T1, but T3
> get the newfile pointer, and continue the ioctl accessing.
> 
> It maybe causes unexpectable error, we hit one system panic at do_vfs_ioctl().
> 
> Here we can fix it that putting "put_unused_fd()" after filp_close(),
> it can avoid this case.

NAK.  T3 getting the new file is valid (think what happens if T1 returns from
close() before T2 enters open() and T3 hits ioctl() after both of those),
the userland code is, at the very least, racy and no, moving put_unused_fd()
around is not going to solve any problems - it might shift the race window,
but that's it.

It certainly does not affect the possibility of panics in do_vfs_ioctl()
you are seeing and I would really like to see the details on those instead of
this kind of voodoo "fixes".
