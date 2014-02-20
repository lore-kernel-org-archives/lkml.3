Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbaBTROc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 12:14:32 -0500
Received: from mail-ve0-f176.google.com ([209.85.128.176]:36086 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751AbaBTROa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 12:14:30 -0500
MIME-Version: 1.0
In-Reply-To: <53022DB1.4070805@gmail.com>
References: <53022DB1.4070805@gmail.com>
Date: Thu, 20 Feb 2014 09:14:29 -0800
X-Google-Sender-Auth: qIOB0Fr0_HsurY_mv_YQujS6Vjw
Message-ID: <CA+55aFxjAp23=ySEe8e8bTPbVw8Uh8d03zirg4TdHXGYiyjmwA@mail.gmail.com>
Subject: Re: Update of file offset on write() etc. is non-atomic with I/O
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
        "Theodore T'so" <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>,
        Chris Mason <clm@fb.com>, Dave Chinner <david@fromorbit.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "J. Bruce Fields" <bfields@citi.umich.edu>,
        Yongzhi Pan <panyongzhi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
>                         } while (0)
>
> #define fatal(msg)      do { fprintf(stderr, "%s\n", msg); \
>                              exit(EXIT_FAILURE); } while (0)
>
> #define usageErr(msg, progName)        \
>                         do { fprintf(stderr, "Usage: "); \
>                              fprintf(stderr, msg, progName); \
>                              exit(EXIT_FAILURE); } while (0)
>
> int
> main(int argc, char *argv[])
> {
>     char *buf;
>     int j, k, nblocks, nchildren;
>     size_t blocksize;
>     struct stat sb;
> //  int nchanges;
> //  off_t pos;
>     long long expected;
>
>     if (argc < 4 || strcmp(argv[1], "--help") == 0)
>         usageErr("%s num-children num-blocks block-size [O_APPEND-flag]\n",
>                 argv[0]);
>
>     nblocks = atoi(argv[2]);
>     blocksize = atoi(argv[3]);
>
>     buf = malloc(blocksize + 1);
>     if (buf == NULL)
>         errExit("malloc");
>
>     /* If a fourth command-line argument is specified, set the O_APPEND
>        flag on stdout */
>
>     if (argc > 4)
>         if (fcntl(STDOUT_FILENO, F_SETFL, O_APPEND) == -1)
>             errExit("fcntl-F_SETFL");
>
>     nchildren = atoi(argv[1]);
>
>     /* Create child processes that write blocks to stdout */
>
>     for (j = 0; j < nchildren; j++) {
>         switch(fork()) {
>         case -1:
>             errExit("fork");
>
>         case 0: /* Each child writes nblocks * blocksize bytes to stdout */
> //          nchanges = 0;
>
>             /* Put something distinctive in each child's buffer (in case
>                we want to analyze byte sequences in the output) */
>
>             for (k = 0; k < blocksize; k++)
>                 buf[k] = 'a' + getpid() % 26;
>
>             for (k = 0; k < nblocks; k++) {
> //              if (k > 0 && pos != lseek(STDOUT_FILENO, 0, SEEK_END))
> //                  nchanges++;
>                 if (write(STDOUT_FILENO, buf, blocksize) != blocksize)
>                     fatal("write");
> //              pos = lseek(STDOUT_FILENO, 0, SEEK_END);
>             }
>
> //          fprintf(stderr, "%ld: nchanges = %d\n",
> //                  (long) getpid(), nchanges);
>             exit(EXIT_SUCCESS);
>
>         default:
>             break;      /* Parent falls through to create next child */
>         }
>     }
>
>     /* Wait for all children to terminate */
>
>     while (wait(NULL) > 0)
>         continue;
>
>     /* Compare final length of file against expected size */
>
>     if (fstat(STDOUT_FILENO, &sb) == -1)
>         errExit("fstat");
>
>     expected =  blocksize * nblocks * nchildren;
>     fprintf(stderr, "Expected file size: %10lld\n", expected);
>     fprintf(stderr, "Actual file size:   %10lld\n", (long long) sb.st_size);
>     fprintf(stderr, "Difference:         %10lld\n", expected - sb.st_size);
>
>     exit(EXIT_SUCCESS);
> }
>
>
> --
> Michael Kerrisk
> Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
> Linux/UNIX System Programming Training: http://man7.org/training/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
