Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433AbaLZSkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 13:40:46 -0500
Received: from mout.gmx.net ([212.227.15.19]:62456 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbaLZSkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 13:40:42 -0500
Message-ID: <549DAB95.3090003@gmx.de>
Date: Fri, 26 Dec 2014 19:40:21 +0100
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: ivo.welch@gmail.com, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>
Subject: Re: fanotify bug on gdb -- hard crash
References: <CAPr7RtWpX_kYiJRRnPVSZrL-U2GqoV5aBPM_AF7xBzV99jzJuw@mail.gmail.com>
In-Reply-To: <CAPr7RtWpX_kYiJRRnPVSZrL-U2GqoV5aBPM_AF7xBzV99jzJuw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:rRBEnZwg0p7ZB4aZhhW9whzwUqc3xTg9tBsFeX2tIalIlSQBHCo
 yLOfbHhn5+syXudaq8Eq5SEWuFZwYkbkaTLW29dzH6Q7X1E1UKfT0Nn+Y/hacgAAGL+aILf
 uQ0kkrXExbgRHVHYu8WbNKxkhnAXN2LEZzwvGEcu41/HPuYCIj9AbpNouH7KF+8aD4GMH4r
 RZSrGpDiZkwzborYnbr2w==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ivo,

On 26.12.2014 15:45, ivo welch wrote:
> I am not a kernel developer, so forgive the intrusion.
>
> I suspect I have found either a bug in gdb (less likely) or a bug in
> fanotify (more likely).  it is replicable, and the code is almost
> unchanged from the example in the fanotify man page.  to trigger it,
> all an su needs to do is to step through the program below with gdb
> 7.8.1 'n' command, and linux locks up the system pretty hard (reboot
> required).  I have confirmed the replicability of this issue on a
> clean arch 2014.12.01 3.17.6-1 system and on a clean ubuntu 14.10
> system, both VMs created just to check it.  /iaw
>
>
> #define _GNU_SOURCE     /* Needed to get O_LARGEFILE definition */
> #include <stdio.h>
> #include <stdlib.h>
> #include <errno.h>
> #include <fcntl.h>
> #include <poll.h>
> #include <sys/fanotify.h>
>
> int main(int argc, char *argv[]) {
>    int fd;
>    fd = fanotify_init(FAN_CLOEXEC | FAN_CLASS_CONTENT | FAN_NONBLOCK,
> O_RDONLY | O_LARGEFILE);
>    if (fd == -1) exit(1);
>    fprintf(stderr, "calling fanotify_mark: fd=%d\n", fd);
>    if (fanotify_mark(fd, FAN_MARK_ADD | FAN_MARK_MOUNT, FAN_OPEN_PERM |
> FAN_CLOSE_WRITE, -1, "/") == -1) exit(2);
>    fprintf(stderr, "in gdb step through with 'n' for repeat.\n");
>    fprintf(stderr, "  (and sometimes otherwise), a ^C works, but a ^Z
> and then ^C does not.\n");
> }

I was not able to reproduce your problem according to your description 
with Ubuntu 14.10.

I ran a Ubuntu 14.04 amd64 LiveImage in a VM and compiled your example with
gcc -g -o test test.c

The gdb version in Ubuntu 14.10 is 7.4 and not 7.8.1. The kernel version 
is 3.13.

root@ubuntu:/home/ubuntu/temp# gdb ./test
GNU gdb (Ubuntu/Linaro 7.4-2012.04-0ubuntu2.1) 7.4-2012.04
Copyright (C) 2012 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later 
<http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
and "show warranty" for details.
This GDB was configured as "x86_64-linux-gnu".
For bug reporting instructions, please see:
<http://bugs.launchpad.net/gdb-linaro/>...
Reading symbols from /home/ubuntu/temp/test...done.
(gdb) break main
Breakpoint 1 at 0x400693: file test.c, line 10.
(gdb) run
Starting program: /home/ubuntu/temp/test
warning: no loadable sections found in added symbol-file system-supplied 
DSO at 0x7ffff7ffa000

Breakpoint 1, main (argc=1, argv=0x7fffffffe638) at test.c:10
10        fd = fanotify_init(FAN_CLOEXEC | FAN_CLASS_CONTENT | FAN_NONBLOCK,
(gdb) n
12        if (fd == -1) exit(1);
(gdb) n
13        fprintf(stderr, "calling fanotify_mark: fd=%d\n", fd);
(gdb) n
calling fanotify_mark: fd=7
14        if (fanotify_mark(fd, FAN_MARK_ADD | FAN_MARK_MOUNT, 
FAN_OPEN_PERM |
(gdb) n
16        fprintf(stderr, "in gdb step through with 'n' for repeat.\n");
(gdb) n
in gdb step through with 'n' for repeat.
17        fprintf(stderr, "  (and sometimes otherwise), a ^C works, but 
a ^Z and then ^C does not.\n");
(gdb) n
   (and sometimes otherwise), a ^C works, but a ^Z and then ^C does not.
18      }
(gdb) n
0x00007ffff7a3b78d in __libc_start_main () from 
/lib/x86_64-linux-gnu/libc.so.6
(gdb) n
Single stepping until exit from function __libc_start_main,
which has no line number information.
[Inferior 1 (process 4423) exited with code 0110]
(gdb) n
The program is not being run.
(gdb) q
root@ubuntu:/home/ubuntu/temp#

>
> I don't know who else to tell this.  I hope this report is useful, if
> someone competent can confirm it.  /iaw

Bug reports for the Linux kernel should be adressed to the maintainer. 
You can find him in the MAINTAINERS file of the linux source.

See
https://www.kernel.org/pub/linux/docs/lkml/reporting-bugs.html
https://bugzilla.kernel.org/

Before reporting a bug it is worthwhile to check if the problem also 
occurs with the current kernel version (as of today 3.18.1 or 3.19-rc1).

 > PS: Is there an alternative to fanotify to avoid this?  I want to
 > learn of all file-open requests on a ro device.
 > ----

The fanotify API is the right choice. Inotify is an alternative but 
requires marking all directories.

For your task you can use the code provided at
https://launchpad.net/fatrace

Best regards

Heinrich Schuchardt
