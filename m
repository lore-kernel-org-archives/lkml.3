Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab3HZPOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 11:14:15 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:38776 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305Ab3HZPON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 11:14:13 -0400
Message-ID: <1377530045.8828.120.camel@edumazet-glaptop>
Subject: Re: [PATCH] Fix the race between the fget() and close()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 26 Aug 2013 08:14:05 -0700
In-Reply-To: <1377533569.26153.3.camel@cliu38-desktop-build>
References: <1377533569.26153.3.camel@cliu38-desktop-build>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-27 at 00:12 +0800, Chuansheng Liu wrote:
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

Not clear if the bug is not elsewhere.

What panic did you have exactly ?

> Here we can fix it that putting "put_unused_fd()" after filp_close(),
> it can avoid this case.
> 

Three threads doing this kind of stuff cannot expect T3 gets the old or
new file anyway. Its totally unspecified.



