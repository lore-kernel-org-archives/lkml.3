Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbaBTSQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 13:16:25 -0500
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:56990 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473AbaBTSQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 13:16:22 -0500
From: "Zuckerman, Boris" <borisz@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
        "Theodore T'so" <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>,
        Chris Mason <clm@fb.com>, Dave Chinner <david@fromorbit.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "J. Bruce Fields" <bfields@citi.umich.edu>,
        Yongzhi Pan <panyongzhi@gmail.com>
Subject: Re: Update of file offset on write() etc. is non-atomic with I/O
Thread-Topic: Update of file offset on write() etc. is non-atomic with I/O
Thread-Index: Ac8uZ7Ow9055LhE4C0igrtGSOJUsQQ==
Date: Thu, 20 Feb 2014 18:15:15 +0000
Message-ID: <8e9349a1-d900-4c93-8dad-1e32f26529c2@blur>
References: <a8df285f-de7f-4a3a-9a19-e0ad07ab3a5c@blur>
In-Reply-To: <a8df285f-de7f-4a3a-9a19-e0ad07ab3a5c@blur>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="utf-8"
Content-ID: <D78A791CC8A94D418B2C42C815C0539A@Compaq.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1KIGUEd020183

Hi,

You probably already considered that - sorry, if soâ€¦

Instead of the mutex Windows use ExecutiveResource with shared and exclusive semantics. Readers serialize by taking the resource shared and writers take it exclusive. I have that implemented for Linux. Please, let me know if there is any interest!


Sent from my Verizon Wireless Droid


-----Original message-----
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Theodore T&apos;so <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>, Dave Chinner <david@fromorbit.com>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, "J. Bruce Fields" <bfields@citi.umich.edu>, Yongzhi Pan <panyongzhi@gmail.com>
Sent: Thu, Feb 20, 2014 17:15:07 GMT+00:00
Subject: Re: Update of file offset on write() etc. is non-atomic with I/O

Yes, I do think we violate POSIX here because of how we handle f_pos
(the earlier thread from 2006 you point to talks about the "thread
safe" part, the point here about the actual wording of "atomic" is a
separate issue).

Long long ago we used to just pass in the pointer to f_pos directly,
and then the low-level write would update it all under the inode
semaphore, and all was good.

And then we ended up having tons of problems with non-regular files
and drivers accessing f_pos and having nasty races with it because
they did *not* have any locking (and very fundamentally didn't want
any), and we broke the serialization of f_pos. We still do the *IO*
atomically, but yes, the f_pos access itself is outside the lock.

Ho humm.. Al, any ideas of how to fix this?

                     Linus



On Mon, Feb 17, 2014 at 7:41 AM, Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
> Hello all,
>
> A note from Yongzhi Pan about some of my own code led me to dig deeper
> and discover behavior that is surprising and also seems to be a
> fairly clear violation of POSIX requirements.
>
> It appears that write() (and, presumably read() and other similar
> system calls) are not atomic with respect to performing I/O and
> updating the file offset behavior.
>
> The problem can be demonstrated using the program below.
> That program takes three arguments:
>
> $ ./multi_writer num-children num-blocks block-size > somefile
>
> It creates 'num-children' children, each of which writes 'num-blocks'
> blocks of 'block-size' bytes to standard output; for my experiments,
> stdout is redirected to a file. After all children have finished,
> the parent inspects the size of the file written on stdout, calculates
> the expected size of the file, and displays these two values, and
> their difference on stderr.
>
> Some observations:
>
> * All children inherit the stdout file descriptor from the parent;
>   thus the FDs refer to the same open file description, and therefore
>   share the file offset.
>
> * When I run this on a multi-CPU BSD systems, I get the expected result:
>
> $ ./multi_writer 10 10000 1000 > g 2> run.log
> $ ls -l g
> -rw-------  1 mkerrisk  users  100000000 Jan 17 07:34 g
>
> * Someone else tested this code for me on a Solaris system, and also got
>   the expected result.
>
> * On Linux, by contrast, we see behavior such as the following:
>
> $ ./multi_writer 10 10000 1000 > g
> Expected file size:  100000000
> Actual file size:     16323000
> Difference:           83677000
> $ ls -l g
> -rw-r--r--. 1 mtk mtk 16323000 Feb 17 16:05 g
>
> Summary of the above output: some children are overwriting the output
> of other children because output is not atomic with respect to updates
> to the file offset.
>
> For reference, POSIX.1-2008/SUSv4 Section XSI 2.9.7 says:
>
> [[
> 2.9.7 Thread Interactions with Regular File Operations
>
> All of the following functions shall be atomic with respect to each other
> in the effects specified in POSIX.1-2008 when they operate on regular
> files or symbolic links:
>
>
> chmod()
> ...
> pread()
> read()
> ...
> readv()
> pwrite()
> ...
> write()
> writev()
>
>
> If two threads each call one of these functions, each call shall either
> see all of the specified effects of the other call, or none of them.
> ]]
>
> (POSIX.1-2001 has similar text.)
>
> This text is in one of the Threads sections, but it applies equally
> to threads in different processes as to threads in the same process.
>
> I've tested the code below on ext4, XFS, and BtrFS, on kernel 3.12 and a
> number of other recent kernels, all with similar results, which suggests
> the result is in the VFS layer. (Can it really be so simple as no locking
> around pieces such as
>
>                 loff_t pos = file_pos_read(f.file);
>                 ret = vfs_write(f.file, buf, count, &pos);
>                 if (ret >= 0)
>                         file_pos_write(f.file, pos);
>
> in fs/read_write.c?)
>
> I discovered this behavior after Yongzhi Pan reported some unexpected
> behavior in some of my code that forked to create a parent and
> child that wrote to the same file. In some cases, expected output
> was not appearing. In other words, after a fork(), and in the absence
> of any other synchronization technique, a parent and a child cannot
> safely write to the same file descriptor without risking overwriting
> each other's output. But POSIX requires this, and other systems seem
> to guarantee it.
>
> Am I correct to think there's a kernel problem here?
>
> Thanks,
>
> Michael
>
> ===
>
> /* multi_writer.c
> */
>
> #include <sys/wait.h>
> #include <sys/types.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <unistd.h>
> #include <sys/fcntl.h>
> #include <sys/stat.h>
> #include <string.h>
> #include <errno.h>
>
> typedef enum { FALSE, TRUE } Boolean;
>
> #define errExit(msg)    do { perror(msg); exit(EXIT_FAILURE); \
>             &nbs
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
