Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab3LSOm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 09:42:57 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:59201 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab3LSOmz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 09:42:55 -0500
Date: Thu, 19 Dec 2013 16:42:51 +0200
From: Timo Teras <timo.teras@iki.fi>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] fs/binfmt_elf: fix memory map for PIE applications
Message-ID: <20131219164251.3ebd124a@vostro>
In-Reply-To: <alpine.LNX.2.00.1312191516270.11852@pobox.suse.cz>
References: <1380698395-5784-1-git-send-email-timo.teras@iki.fi>
	<alpine.LNX.2.00.1312191516270.11852@pobox.suse.cz>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; i486-alpine-linux-uclibc)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Dec 2013 15:17:03 +0100 (CET)
Jiri Kosina <jkosina@suse.cz> wrote:

> On Wed, 2 Oct 2013, Timo Teräs wrote:
> 
> > arch/*/include/asm/elf.h comments say:
> >   ELF_ET_DYN_BASE is the location that an ET_DYN program is loaded
> >   if exec'ed.  Typical use of this is to invoke "./ld.so someprog"
> >   to test out a new version of the loader.  We need to make sure
> >   that it is out of the way of the program that it will "exec",
> >   and that there is sufficient room for the brk.
> > 
> > In case we have main application linked as PIE, this can cause
> > problems as the main program itself is being loaded to this
> > alternate address. And this allows limited heap size. While
> > this is inevitable when exec'ing the interpreter directly,
> > we should do better for PIE applications.
> 
> could you please provide more specific example of the breakage
> scenario you are talking about? It's not completely clear to me from
> your commit message.

The problem is that if PF_RANDOMIZE is on, the PIE application will be
mapped by letting mmap() to randomize the area for the main app (that
is used to base heap).

Example memory layout from x86, running PIE compiled busybox with
randomization enabled:

5756c000-57570000 rw-p 00000000 00:00 0 
57570000-575dd000 r-xp 00000000 00:0f 2039       /lib/libuClibc-0.9.33.2-git.so
575dd000-575de000 r--p 0006c000 00:0f 2039       /lib/libuClibc-0.9.33.2-git.so
575de000-575df000 rw-p 0006d000 00:0f 2039       /lib/libuClibc-0.9.33.2-git.so
575df000-575e5000 rw-p 00000000 00:00 0 
575e5000-575f5000 r-xp 00000000 00:0f 2038       /lib/libm-0.9.33.2-git.so
575f5000-575f6000 r--p 0000f000 00:0f 2038       /lib/libm-0.9.33.2-git.so
575f6000-575f7000 rw-p 00010000 00:0f 2038       /lib/libm-0.9.33.2-git.so
575f7000-575fd000 r-xp 00000000 00:0f 2042       /lib/libcrypt-0.9.33.2-git.so
575fd000-575fe000 r--p 00005000 00:0f 2042       /lib/libcrypt-0.9.33.2-git.so
575fe000-57610000 rw-p 00000000 00:00 0 
57611000-57613000 rw-p 00000000 00:00 0 
57613000-57614000 r-xp 00000000 00:00 0          [vdso]
57614000-5761e000 r-xp 00000000 00:0f 2044       /lib/ld-uClibc-0.9.33.2-git.so
5761e000-5761f000 r--p 00009000 00:0f 2044       /lib/ld-uClibc-0.9.33.2-git.so
5761f000-57620000 rw-p 0000a000 00:0f 2044       /lib/ld-uClibc-0.9.33.2-git.so
57620000-57708000 r-xp 00000000 00:0f 234487046  /root/busybox
57708000-5770a000 rw-p 000e8000 00:0f 234487046  /root/busybox
5770a000-5770c000 rw-p 00000000 00:00 0          [heap]
5ffdf000-60000000 rw-p 00000000 00:00 0          [stack]
b7570000-b75dd000 r-xp 00000000 00:0f 2039       /lib/libuClibc-0.9.33.2-git.so
b75e5000-b75f5000 r-xp 00000000 00:0f 2038       /lib/libm-0.9.33.2-git.so
b75f7000-b75fd000 r-xp 00000000 00:0f 2042       /lib/libcrypt-0.9.33.2-git.so
b7613000-b7614000 r-xp 00000000 00:00 0          [vdso]
b7614000-b761e000 r-xp 00000000 00:0f 2044       /lib/ld-uClibc-0.9.33.2-git.so
b7620000-b7708000 r-xp 00000000 00:0f 234487046  /root/busybox

As you see, the main executable is mapped 57620000-57708000 and
57708000-5770a000. Heap follow immediately after that
5770a000-5770c000 followed by anything mmaped after it (stack or some
other libraries). Heap can grow only up to 5ffdf000 meaning the
application is limited to 140 megs or so in this instance. This limit
can go much lower depending how the randomization went. And even 140
megs is very little for big apps.

Hope this clarifies the issue.

- Timo
