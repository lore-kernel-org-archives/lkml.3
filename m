Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbaBRNAt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 08:00:49 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:34790 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264AbaBRNAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 08:00:46 -0500
MIME-Version: 1.0
In-Reply-To: <53022DB1.4070805@gmail.com>
References: <53022DB1.4070805@gmail.com>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Tue, 18 Feb 2014 14:00:25 +0100
X-Google-Sender-Auth: h8kvNGBYrLTg-sfg9bqPShIat8s
Message-ID: <CAHO5Pa3HYokT5qk+YrAVHc3TuH2SzViEn7eo0XHLqs8Kuf6o7A@mail.gmail.com>
Subject: Re: Update of file offset on write() etc. is non-atomic with I/O
To: lkml <linux-kernel@vger.kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Theodore T'so" <tytso@mit.edu>,
        Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Dave Chinner <david@fromorbit.com>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "J. Bruce Fields" <bfields@citi.umich.edu>,
        Yongzhi Pan <panyongzhi@gmail.com>,
        "Michael Kerrisk (gmail)" <mtk.manpages@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>,
        Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        Karaoui mohamed lamine <moharaka@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[expanding the CC list a little more to bring in some previously
interested parties]

On Mon, Feb 17, 2014 at 4:41 PM, Michael Kerrisk (man-pages)
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

Offlist, I was pointed to some previous threads on this topic:

http://thread.gmane.org/gmane.linux.kernel.kernelnewbies/43508

http://lwn.net/Articles/180387/

http://lwn.net/Articles/180396/

Notwithstanding the comments  of Alan and Linus at
http://thread.gmane.org/gmane.linux.kernel/397980/focus=398248 and
http://thread.gmane.org/gmane.linux.kernel/397980/focus=398281 this
*is* a violation of POSIX. When XSI 2.9.7 talks uses the "threads"
language, that is to provide the widest possible guarantee--i.e., that
the threads within a process also get the same atomicity guarantees as
threads in different processes.

I can't comment on the performance implications of adding locking to
fix this issue (at least for simultaneous I/O), but there is an
argument that it should be done on correctness grounds. Linux isn't
conformant with SUSv3 and SUSv4, and isn't consistent with other
implementations such as FreeBSD and Solaris. And I'm pretty sure Linux
isn't consistent with UNIX since early times. (E.g., page 191 of the
1992 edition of Stevens APUE discusses the sharing of the file offset
between the parent and child after fork(). Although Stevens didn't
explicitly spell out the atomicity guarantee, the discussion there
would be a bit nonsensical without the presumption of that guarantee.)

Thanks,

Michael

PS I tried hacking Linus's untested 2006 patch
(http://lwn.net/Articles/180396/) into the kernel, but perhaps not
surprisingly given the age of that patch, I ran into various errors
after boot that meant that user-space didn't come up.
