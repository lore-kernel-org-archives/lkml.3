Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752729AbaCLWaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 18:30:13 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:44931 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbaCLWaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 18:30:10 -0400
MIME-Version: 1.0
In-Reply-To: <20140312181925.GK18016@ZenIV.linux.org.uk>
References: <1393859798-1407-1-git-send-email-dh.herrmann@gmail.com>
	<CA+55aFwzBoTc+09jZTGjfTQTfkgZwrN5m09snb+F9inLaDn0OA@mail.gmail.com>
	<20140312181925.GK18016@ZenIV.linux.org.uk>
Date: Wed, 12 Mar 2014 23:30:09 +0100
Message-ID: <CANq1E4QSFjDiYVmfrNJFfK6zW_HhSBd5d0QF-2t48DzUP+B6pw@mail.gmail.com>
Subject: Re: [PATCH] fs: fix i_writecount on shmem and friends
From: David Herrmann <dh.herrmann@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        stable <stable@vger.kernel.org>, Neil Brown <neilb@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> I think it's trying to fix the problem in the wrong place.  The bug is real,
> all right, but it's not that alloc_file() for non-regulars doesn't grab
> writecount; it's that drop_file_write_access() drops it for those.
>
> What the hell would we want to play with that counter for, anyway?  It's not
> as if they could be mmapped, so all it does is making pipe(2) and socket(2)
> more costly, for no visible reason.

Please see:
  shmem_zero_setup()
    shmem_file_setup()
      __shmem_file_setup()
        alloc_file()

shmem_zero_setup() is used by /dev/zero (drivers/char/mem.c) and
mmap(MAP_ANON). So yes, we do call mmap() on these files.
I also disagree on "for no visible reason". The reason to do this is
uniformity. We make i_writecount work on all inodes regardless how
they got created. Breaking consistent behavior just to save an
atomic_inc_unless_negative() in the alloc_file() path seems
unreasonable to me.

Anyhow, I haven't found any bug if we follow your recommendation.
Every path using alloc_file() either prevents write access on the
underlying inode (eg., anon-inode) or prevents user-space from getting
an FD (all the shmem_file_setup() paths). So it's up to you. Feel free
to fix it yourself, otherwise I will send a second patch following
your idea tomorrow.

Oh, and yes, the md stuff is broken, but I thought that's an orthogonal issue..

Thanks
David
