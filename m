Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329Ab3BZM6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 07:58:22 -0500
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:41448 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab3BZM6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 07:58:21 -0500
Date: Tue, 26 Feb 2013 13:57:39 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: bug in generic strncpy_from_user
Message-ID: <20130226125739.GA3924@osiris>
References: <20130226045424.GA3576@osiris>
 <CA+55aFx8pUSHPhC_-ob2i5BbvBkEC4BVYtAbNkf3+FE+=3AmgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx8pUSHPhC_-ob2i5BbvBkEC4BVYtAbNkf3+FE+=3AmgA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022612-6892-0000-0000-0000046F77CD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 09:24:31PM -0800, Linus Torvalds wrote:
> On Mon, Feb 25, 2013 at 8:54 PM, Heiko Carstens
> <heiko.carstens@de.ibm.com> wrote:
> > FWIW, I think the generic strncpy_from_user() implemention has the same
> > bug as the s390 variant:
> >
> > Following example:
> >
> > If there is a NUL terminated string "a\0" starting at e.g. 0xfffe this
> > will cause an (invalid) page fault for the subsequent page at 0x10000
> > in case of CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS for e.g. this invocation:
> >
> > strncpy_from_user(kname, 0xfffe, 4096);
> >
> > If the user space page that contained the string was the last within a
> > VMA this may cause a -EFAULT return value for the __get_user() invocation
> > in strncpy_from_user() and byte-at-a-time processing will happen.
> >
> > This is true and works fine unless the next VMA is the stack.
> >
> > With "ulimit -s unlimited" it will just grow downwards to where the page
> > fault happened instead that -EFAULT will be returned.
> 
> This should _never_ be the case.

I was wrong. -EFAULT will be returned, however the vma will grow nevertheless.
Which in turn will cause trouble.

> Our stack-down growing handling requires the whole guard page, and
> should never grow down to touch the previous vma.
> 
> If it does, that's a bug in our stack growing, not in
> strncpy_from_user(). Which could definitely be the case, of course.
> But we should fix it there, not change the strncpy.

After all expand_stack() simply expands the stack to the requested address,
since the guard page is considered to be not included it will just grow
exactly down to the previous mapping.
Only in handle_mm_fault() afterwards there is a check if the access happened
within the guard page which then will make the access fault.
However the stack vma has already grown and user space is broken afterwards.

Here an example: this is before the kernel accesses memory right behind the
ld.so.cache mapping:

[root@p2345007 ~]# cat /proc/2285/maps
00400000-00401000 r-xp 00000000 5e:01 148858                             /root/a.out
00401000-00402000 rw-p 00000000 5e:01 148858                             /root/a.out
40000000-4001c000 r-xp 00000000 5e:01 260585                             /lib/ld-2.14.1.so
4001c000-4001e000 rw-p 0001b000 5e:01 260585                             /lib/ld-2.14.1.so
4001e000-40020000 r-xp 00000000 00:00 0                                  [vdso]
40020000-40023000 rw-p 00000000 00:00 0
40023000-4002c000 r--p 00000000 5e:01 39                                 /etc/ld.so.cache
7ffdf000-80000000 rw-p 00000000 00:00 0                                  [stack]

Then an "open" system call to the file  "/lib/libc.so.6" happens. The string is
null terminated and completely fits into the 0x4002b000 user space page. However
when copying from user space with strncpy_from_user() the kernel also reads from
the 0x4002c000 page.
This generates a fault and grows the stack vma downwards to 0x4002c000:

[root@p2345007 ~]# cat /proc/2285/maps
00400000-00401000 r-xp 00000000 5e:01 148858                             /root/a.out
00401000-00402000 rw-p 00000000 5e:01 148858                             /root/a.out
40000000-4001c000 r-xp 00000000 5e:01 260585                             /lib/ld-2.14.1.so
4001c000-4001e000 rw-p 0001b000 5e:01 260585                             /lib/ld-2.14.1.so
4001e000-40020000 r-xp 00000000 00:00 0                                  [vdso]
40020000-40023000 rw-p 00000000 00:00 0
40023000-4002c000 r--p 00000000 5e:01 39                                 /etc/ld.so.cache
4002d000-80000000 rw-p 00000000 00:00 0                                  [stack]

/proc/maps explicitly excludes the guard page, so the vma of the stack indeed
starts at 0x4002c000. Only every access to the guard page will still fault.

