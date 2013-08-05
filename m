Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab3HEDpU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 23:45:20 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:52367 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439Ab3HEDpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 23:45:18 -0400
MIME-Version: 1.0
In-Reply-To: <51FF0F18.5020705@mit.edu>
References: <CA+55aFwTX47vLvZckozZub0rUEo-aCBe7weqe=4mfQGfrW7NUA@mail.gmail.com>
	<51FF0F18.5020705@mit.edu>
Date: Sun, 4 Aug 2013 20:45:16 -0700
X-Google-Sender-Auth: lFe-F-wj6MmKzs6YVjpZSh2XH6A
Message-ID: <CA+55aFw9AY2GLC3xieuy7jgFwsUePJ+kety-AHqFxkP1pPUAVw@mail.gmail.com>
Subject: Re: O_TMPFILE fs corruption (Re: Linux 3.11-rc4)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch looks right to me - we should pass in similar flags for the
create case as for tmpfile to the filesystem.

But let's make sure we're all on the same page. Al?

                 Linus

On Sun, Aug 4, 2013 at 7:34 PM, Andy Lutomirski <luto@mit.edu> wrote:
> On 08/04/2013 02:09 PM, Linus Torvalds wrote:
>>
>> It's that time of the week again..
>
>
> I still get filesystem corruption with O_TMPFILE.  The program below, run as
> flinktest foo proc (or flinktest foo linkat if you're root) will produce a
> bogus inode.  On ext4, once the inode is gone from cache, the inode will be
> impossible to delete and will require a fsck to fix
>
> A patch (not necessarily the appropriate fix) is here:
>
> http://article.gmane.org/gmane.linux.kernel/1537088
>
> --- cut here ---
>
> #include <stdio.h>
> #include <err.h>
> #include <fcntl.h>
> #include <unistd.h>
> #include <string.h>
>
> #define __O_TMPFILE 020000000
> #define O_TMPFILE (__O_TMPFILE | O_DIRECTORY)
> #define AT_EMPTY_PATH 0x1000
>
> int main(int argc, char **argv)
> {
>   char buf[128];
>
>   if (argc != 3)
>     errx(1, "Usage: flinktest PATH linkat|proc");
>
>   int fd = open(".", O_TMPFILE | O_RDWR, 0600);
>   if (fd == -1)
>     err(1, "O_TMPFILE");
>   write(fd, "test", 4);
>
>   if (!strcmp(argv[2], "linkat")) {
>     if (linkat(fd, "", AT_FDCWD, argv[1], AT_EMPTY_PATH) != 0)
>       err(1, "linkat");
>   } else if (!strcmp(argv[2], "proc")) {
>     sprintf(buf, "/proc/self/fd/%d", fd);
>     if (linkat(AT_FDCWD, buf, AT_FDCWD, argv[1], AT_SYMLINK_FOLLOW) != 0)
>       err(1, "linkat");
>   } else {
>     errx(1, "invalid mode");
>   }
>   return 0;
> }
>
