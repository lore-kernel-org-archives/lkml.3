Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756189Ab3JICG2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 22:06:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60713 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab3JICG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 22:06:26 -0400
Date: Wed, 9 Oct 2013 03:06:23 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ftp.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 10/13] make dump_emit() use vfs_write() instead of
 banging at ->f_op->write directly
Message-ID: <20131009020623.GG13318@ZenIV.linux.org.uk>
References: <E1VThRL-0002yt-ON@ZenIV.linux.org.uk>
 <CA+55aFxvNhuXoux88tcYemMWe5Nxdc-srfj3YgBZ7LJ-JaBEdQ@mail.gmail.com>
 <20131009011833.GE13318@ZenIV.linux.org.uk>
 <CA+55aFyej+u+JmWeGZgVECGFQPY909HkDc83+fuC5M1r1HSeHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyej+u+JmWeGZgVECGFQPY909HkDc83+fuC5M1r1HSeHA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 06:38:47PM -0700, Linus Torvalds wrote:
> On Tue, Oct 8, 2013 at 6:18 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Point, but I would argue that we should yell very loud if we get 0 from
> > vfs_write() for non-zero size.  I'm not sure if POSIX allows write(2)
> > to return that, but a lot of userland code won't be expecting that and
> > won't be able to cope...
> 
> Actually POSIX very much allows zero returns. O_NDELAY is mentioned as
> a possible cause, in addition to zero-sized writes themselves, of
> course.

Umm...  What it says is "If some data can be written without blocking the
thread, write() shall write what it can and return the number of bytes
written. Otherwise, it shall return -1 and set errno to EAGAIN."  For
sockets EWOULDBLOCK is also allowed as a possible errno value.  I hadn't
dug through the streams-related part, but we don't have that mess anyway.
 
> Also, writing to (but not past) the end of a block device returns 0
> for "end of device", iirc.

What do you mean?  If the starting position is below the end of device,
we get a non-zero length write, not exceeding the end.  If it's at
the end of device, we get -ENOSPC.  It's out of scope for POSIX, but
Linux is definitely acting that way...
