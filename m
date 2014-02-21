Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbaBUGBy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 01:01:54 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:36206 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbaBUGBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 01:01:52 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20140220182932.GF18016@ZenIV.linux.org.uk>
References: <a8df285f-de7f-4a3a-9a19-e0ad07ab3a5c@blur> <8e9349a1-d900-4c93-8dad-1e32f26529c2@blur>
 <20140220182932.GF18016@ZenIV.linux.org.uk>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Fri, 21 Feb 2014 07:01:31 +0100
Message-ID: <CAKgNAkjFquLPDBXCS50pzVz0EiSfgvJjrG6cEVMFwKZopeHHBg@mail.gmail.com>
Subject: Re: Update of file offset on write() etc. is non-atomic with I/O
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Zuckerman, Boris" <borisz@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>, "Theodore T'so" <tytso@mit.edu>,
        Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Dave Chinner <david@fromorbit.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        "J. Bruce Fields" <bfields@citi.umich.edu>,
        Yongzhi Pan <panyongzhi@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 7:29 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Thu, Feb 20, 2014 at 06:15:15PM +0000, Zuckerman, Boris wrote:
>> Hi,
>>
>> You probably already considered that - sorry, if so...
>>
>> Instead of the mutex Windows use ExecutiveResource with shared and exclusive semantics. Readers serialize by taking the resource shared and writers take it exclusive. I have that implemented for Linux. Please, let me know if there is any interest!
>
> See include/linux/rwsem.h...
>
> Anyway, the really interesting question here is what does POSIX promise
> wrt lseek() vs. write().  What warranties are given there?

I suppose you are wondering about cases such as:

Process A                     Process B
write():                      lseek()
    perform I/O
                              update f_pos
    update f_pos()

In my reading of POSIX, lseeek() and write() should be atomic w.r.t.
each other, and the above should not be allowed.

Here's the fulll list from POSIX.1-2008/SUSv4 Section XSI 2.9.7:

[[
2.9.7 Thread Interactions with Regular File Operations

All of the following functions shall be atomic with respect to each
other in the effects specified in
POSIX.1-2008 when they operate on regular files or symbolic links:

chmod( )
chown( )
close( )
creat( )
dup2( )
fchmod( )
fchmodat( )
fchown( )
fchownat( )
fcntl( )
fstat( )
fstatat( )
ftruncate( )
lchown( )
link( )
linkat( )
lseek( )
lstat( )
open( )
openat( )
pread( )
read( )
readlink( )
readlinkat( )
readv( )
pwrite( )
rename( )
renameat( )
stat( )
symlink( )
symlinkat( )
truncate( )
unlink( )
unlinkat( )
utime( )
utimensat( )
utimes( )
write( )
writev( )

If two threads each call one of these functions, each call shall
either see all of the specified effects
of the other call, or none of them.
]]

I'd bet that there's a bunch of violations to be found, but the
read/write f_pos case is one of the most egregious.

For example, I got curious about stat() versus rename(). If one
stat()s a directory() while a subdirectory is being renamed to a new
name within that directory, does the link count of the parent
directory ever change--that is, could stat() ever see a changed link
count in the middle of the rename()? My experiments suggest that it
can. I suppose it would have to be a very unusual application that
would be troubled by that, but it does appear to be a violation of
2.9.7.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
